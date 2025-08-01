<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\Response;

class GenerateRequestId
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (! $request->headers->has('X-Request-Id')) {
            $requestId = (string) Str::uuid();

            $request->headers->set('X-Request-Id', $requestId);

            $response = $next($request);

            $response->headers->set('X-Request-Id', $request->headers->get('X-Request-Id'));

            return $response;
        }

        return $next($request);
    }
}
