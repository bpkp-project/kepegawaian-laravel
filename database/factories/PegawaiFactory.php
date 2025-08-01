<?php

namespace Database\Factories;

use App\Models\Bidang;
use App\Models\PangkatGolongan;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Pegawai>
 */
class PegawaiFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $user = User::factory()->create();
        $user->assignRole('pegawai');
        $bidang = Bidang::query()->inRandomOrder()->first();
        $pangkatGolongan = PangkatGolongan::query()->inRandomOrder()->first();

        return [
            'user_id' => $user->id,
            'bidang_id' => $bidang->id,
            'pangkat_golongan_id' => $pangkatGolongan->id,
            'nip' => fake()->unique()->numerify('####################'),
            'nama' => fake()->name(),
            'jabatan' => fake()->jobTitle(),
        ];
    }
}
