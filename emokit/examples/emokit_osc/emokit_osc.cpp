/* 
	Simple example of sending an OSC message using oscpack.
*/

#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <csignal>
#include <iostream>
#include "oscpack/osc/OscOutboundPacketStream.h"
#include "oscpack/ip/UdpSocket.h"
#include "emokit/emokit.h"

#define ADDRESS "239.0.0.1"
#define PORT 7777

#define OUTPUT_BUFFER_SIZE 4096

void sigproc(int i)
{
	std::cout << "closing epoc and quitting" << std::endl;
	exit(0);
}

float conv(int v)
{
	return (v-8200)/8200.0;
}

int main(int argc, char* argv[])
{
	signal(SIGINT, sigproc);
#ifndef WIN32
	signal(SIGQUIT, sigproc);
#endif

	UdpTransmitSocket transmitSocket( IpEndpointName( ADDRESS, PORT ) );

	char buffer[OUTPUT_BUFFER_SIZE];


	FILE *input;
	FILE *output;

	char raw_frame[32];
	struct emokit_frame frame;
	emokit_device* d;
	uint8_t data[32];

	d = emokit_create();
	printf("Current epoc devices connected: %d\n", emokit_get_count(d, EMOKIT_VID, EMOKIT_PID));
	if(emokit_open(d, EMOKIT_VID, EMOKIT_PID, 1) != 0)
	{
		printf("CANNOT CONNECT\n");
		return 1;
	}
	while(1)
	{
		int r;
		if((r=emokit_read_data_timeout(d, 1000)) > 0) {
			
			frame = emokit_get_next_frame(d);
			
			osc::OutboundPacketStream p( buffer, OUTPUT_BUFFER_SIZE );
			p << osc::BeginBundleImmediate;	
		        
		        p << osc::BeginMessage( "/data" )
				  << conv(frame.F3) << conv(frame.FC6) << conv(frame.P7 )
				  << conv(frame.T8) << conv(frame.F7 ) << conv(frame.F8 )
				  << conv(frame.T7) << conv(frame.P8 ) << conv(frame.AF4)
				  << conv(frame.F4) << conv(frame.AF3) << conv(frame.O2 )
				  << conv(frame.O1) << conv(frame.FC5) << osc::EndMessage;

		        p << osc::BeginMessage( "/quality" )
				  << frame.cq.F3 << frame.cq.FC6 << frame.cq.P7 
				  << frame.cq.T8 << frame.cq.F7  << frame.cq.F8 
				  << frame.cq.T7 << frame.cq.P8  << frame.cq.AF4
				  << frame.cq.F4 << frame.cq.AF3 << frame.cq.O2 
				  << frame.cq.O1 << frame.cq.FC5 << osc::EndMessage;

				p << osc::BeginMessage( "/gyro" )
				  << (int)frame.gyroX << (int)frame.gyroY << osc::EndMessage;

				if (frame.counter == 128) {
					p << osc::BeginMessage( "/battery" ) 
				      << frame.battery << osc::EndMessage;
				}
				
			p << osc::EndBundle;

			transmitSocket.Send( p.Data(), p.Size() );

		} else if(r == 0)
			fprintf(stderr, "Headset Timeout\n");
		else {
			fprintf(stderr, "Headset Error\n");
			break;
		}
	}

	emokit_close(d);
	emokit_delete(d);
	return 0;

}
