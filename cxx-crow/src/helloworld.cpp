#include "crow.h"

int main()
{
    crow::SimpleApp app;

    CROW_ROUTE(app, "/api/hello")([](){
        return "Hello, World!";
    });

    app.port(8080).multithreaded().run();
}
