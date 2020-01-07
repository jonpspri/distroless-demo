#include <restinio/all.hpp>

template < typename RESP >
RESP
init_resp( RESP resp )
{
    resp.append_header( restinio::http_field::server, "RESTinio sample server /v.0.2" );
    resp.append_header_date_field();
    return resp;
}

using router_t = restinio::router::express_router_t<>;
auto create_request_handler()
{
    auto router = std::make_unique< router_t >();
    router->http_get(
        "/api/hello",
        []( auto req, auto ){
                init_resp( req->create_response() )
                    .append_header( restinio::http_field::content_type, "text/plain; charset=utf-8" )
                    .set_body( "Hello, world!")
                    .done();
                return restinio::request_accepted();
        } );

    router->non_matched_request_handler(
        []( auto req ){
            return req->create_response(restinio::status_not_found())
                .connection_close()
                .done();
        } );
    return router;
}

int main()
{
    using namespace std::chrono;
    try
    {
        using traits_t =
            restinio::traits_t<
                restinio::asio_timer_manager_t,
                restinio::single_threaded_ostream_logger_t,
                router_t >;
        restinio::run(
            restinio::on_this_thread<traits_t>()
                .port( 8080 )
                .request_handler( create_request_handler() ) );
    }
    catch( const std::exception & ex )
    {
        std::cerr << "Error: " << ex.what() << std::endl;
        return 1;
    }
    return 0;
}
