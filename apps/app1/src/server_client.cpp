#include "apps/app1/include/server_client.hpp"
#include "apps/app1/include/client.hpp"
#include "third_party/crow/crow_all.h"
#include <string>
#include <iostream>
#include <stdio.h>
#include <unistd.h>
#include <thread>
#include <cstdlib>
#include <fstream>


#include "third_party/crow/crow_all.h"
#include "third_party/getTimeOfDay/include/TimeStamp.h"
#include "third_party/Config/include/Config.h"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <cstdlib>

Server_client::Server_client()
{
}

int main(int argc, char *argv[])
{
    std::cout << "enter in main" << std::endl;
    crow::SimpleApp app;

    Server_client srv;
    std::cout << "Should enter in run" << std::endl;
    std::string res = srv.run();
    std::cout << "should have gone through run" << std::endl;
    CROW_ROUTE(app, "/")([res](){
        std::cout << "Will return: " << res << std::endl;
        return res;
    });

    app.port(atoi(std::getenv("APP1_PORT"))).multithreaded().run();
} 


std::string Server_client::run()
{
    //app2 return the date 
    //app1 call app2 to ge the date and return it to the user
    //app1 also keep an history of the response sent since app1 start   
    std::cout << "start server_client run" << std::endl;
    std::string path_to_file = "client_history.txt";//"/data/history/client_history.txt";
    std::cout << "we will store output history in " << path_to_file << std::endl;

    std::fstream file(path_to_file, std::ios::in | std::ios::out | std::ios::app);
    if (!file)
    {
        std::cerr << "Unable to open file.\n";
        std::cout << "We will run whithout saving history" << std::endl;
    }

    std::string data;
    Client client;
    std::string url = client.getUrl() + ":" + client.getPort();
    std::cout << "client use url: " << url << std::endl;
    data = client.getDate();
    
    //std::cout << "client data: " << data << std::endl;
    file.close();
    return data;
}
