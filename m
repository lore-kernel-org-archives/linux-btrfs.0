Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:37183 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3ISRH3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 13:07:29 -0400
Message-ID: <523B2F4B.6050702@mur.at>
Date: Thu, 19 Sep 2013 19:07:23 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Frank Holton <fholton@gmail.com>
Subject: Re: rootfs crash
References: <5236E1FF.4080900@mur.at> <5238343F.3020802@mur.at> <20130917111809.GA16032@panda> <52384A08.40404@mur.at> <523873FC.20504@mur.at> <CAFvQSYS7U6VdYeUa-BocBq2tgQuyg1Z_eqpO=6UkcER2a1_p-g@mail.gmail.com> <5239EDC3.2060804@mur.at> <CAC4gV=57gOWABD3n+fhEkxRVDKKeejKSQYVEC-M=V2rDXr8Uog@mail.gmail.com>
In-Reply-To: <CAC4gV=57gOWABD3n+fhEkxRVDKKeejKSQYVEC-M=V2rDXr8Uog@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig7EE8A3DC8409BDC63DBAD34A"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7EE8A3DC8409BDC63DBAD34A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Frank,

Am 2013-09-19 18:18, schrieb Frank Holton:

> I'm not sure what's causing the free error, I'll keep looking.

So am I :)  In fact I would really like to help fix the tool.  I hope I
can provide some suggestions for fixes, but I'm having my trouble with
the code ;)

All I can tell so far is that when you run `btrfs restore` via valgrind
you get much farther then without.  But even that eventually crashes :(

> Have you tried running restore on your home subvolume yet? By default
> restore only works on the default subvolume which in your case is /

I managed to retrieve almost everything from /home/.  I am even working
on the machine that had the crashed file system now :)

> The following command will try to restore your /home subvolume
> btrfs restore -i -r 258 [image] [destination]

Good point!  I could not find any references to restoring only parts of
the file system.  It's just a pain to see it restoring everything in
/var/cache/apt/archives ... and stopping before it get's to `valuable`
data ;)

> Run that and see if you get your home folder restored. Hopefully the
> errors are only on the root volume.

I will give it another try since I have backups of the corrupted devices
anyhow and will use them as test ground now.

Thanks for your reply!

Cheers!
--=20
j.hofm=C3=BCller

Optimism doesn't alter the laws of physics.         - Subcommander T'Pol


--------------enig7EE8A3DC8409BDC63DBAD34A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iF4EAREIAAYFAlI7L0sACgkQkaXhaapqItlhPgEA2T4GEZ0ZgP+MRdZxF699jPLM
yKJ5m/QQE1jzWkjpHSsBAIWjqbKonzc9KDbkqPLC56aqzg5FsIUh0ObU7RvbRUA2
=h8Pu
-----END PGP SIGNATURE-----

--------------enig7EE8A3DC8409BDC63DBAD34A--
