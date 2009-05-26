From: Michael Raskin <7c6f434c@mail.ru>
Subject: free space reporting - further tests
Date: Tue, 26 May 2009 16:23:35 +0400
Message-ID: <4A1BDF47.6090804@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

		Hello.
	I previously reported results of BTRFS synthetical tests. Now I have
tried it under a real-life usage.
/dev/sda6              29G   18G   12G  61% /nix/store
/dev/sda6             30009388  18103372  11906016  61% /nix/store

I can create small files, but trying to write a big file gives
dd: writing `/nix/store/garbage1': No space left on device

btrfs-show shows the following:
Label: store  uuid: 8eac2c04-5e1c-4f47-b4eb-b56bea578cb1
        Total devices 1 FS bytes used 17.26GB
        devid    1 size 28.62GB used 28.62GB path /dev/sda6

Why does such a signinficant misreporting occur?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEcBAEBAgAGBQJKG99GAAoJEE6tnN0aWvw3+5cIALPSC73vf0sF9hugfLdoKLu1
wcsc4jfEM8cUVOpaCrpObL9VZYHyZtv99CTgB2pixBbpVXuJu/wXJYgZ/lpC22xw
tIKugyjYEUBY9AhR4Jvx9Qkx/LLYfRmCBedGmHG46HEUpfo88S/PTXzvVMiZSTnW
iGdpWpzCaoa3Hdclc+M+zKOEr96/VM590n4d4vnTbvnv+kuqWFrXBKYMSAjrtTby
t8mtxA8RaLAMM/B+3zU9wGTH2SxZAQ7CMh1UQ5tYgcs5Ba4v5/hvyYAFTNUgr9xA
vk5Tc3fo3JQ8sTgNyT8kg6i7ctSinwOW6TRvKL1vcGNI92z5wClr8mJI0a9AB2M=
=4qXg
-----END PGP SIGNATURE-----
