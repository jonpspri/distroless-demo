#include <restinio/all.hpp>
int main()
{
    restinio::run(
        restinio::on_this_thread()
        .port(8080)
        //.address("localhost")
        .request_handler([](auto req) {
            // TODO - use express routers to confine this to one path
            return req->create_response().set_body("Hello, World!").done();
        }));
    return 0;
}
