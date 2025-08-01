<?php

namespace Database\Seeders;

use App\Models\Pegawai;
use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            RoleSeeder::class,
            BidangSeeder::class,
            PangkatGolonganSeeder::class,
            PegawaiSeeder::class,
        ]);

        foreach (['admin', 'pegawai'] as $role) {
            $pegawai = Pegawai::factory()->create();
            $user = $pegawai->user;
            $user->username = $role;
            $user->save();
            $user->assignRole($role);
        }
    }
}
