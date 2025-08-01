@extends('layouts.default')

@section('title')
    Dashboard
@endsection

@section('breadcrumb')
    <li class="breadcrumb-item active"><a href="/">Home</a></li>
@endsection

@section('content')
    <!-- Default box -->
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Dashboard</h3>
        </div>
        <div class="card-body">
            <p>Surimbim Dududuw</p>
        </div>
    </div>
    <!-- /.card -->
@endsection

@push('scripts')

@endpush
