Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53155 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbdGYNrR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 09:47:17 -0400
Date: Tue, 25 Jul 2017 13:46:56 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?H=E9rikz?= Nawarro <herikz.nawarro@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid assurance
Message-ID: <20170725134656.GL7140@carfax.org.uk>
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/T+UM55GOh1Yge7W"
In-Reply-To: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/T+UM55GOh1Yge7W
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 25, 2017 at 09:55:37AM -0300, H=E9rikz Nawarro wrote:
> Hello everyone,
>=20
> I'm migrating to btrfs and i would like to know, in a btrfs filesystem
> with 4 disks (multiple sizes) with -d raid0 & -m raid1, how many
> drives can i lost without losing the entire array?

   You can lose one device in the array, and the FS structure will be
OK -- it will still mount, and you'll be able to see all the filenames
and directory structures and so on.

   However, if you do lose one device, then you'll lose
(approximately) half of the bytes in all of your files, most likely in
alternating 64k slices in each file. Attempting to read the missing
parts will result in I/O errors being returned from the filesystem.

   So, while the FS is in theory still fine as a (probably read-only)
filesystem, it's actually going to be *completely* useless with a
missing device, because none of your file data will be usably intact.

   If you want the FS to behave well when you lose a device, you'll
need some kind of actual redundancy in the data storage part -- RAID-1
would be my recommendation (it stores two copies of each piece of
data, so you can lose up to one device and still be OK).

   Hugo.

--=20
Hugo Mills             | One of these days, I'll catch that man without a
hugo@... carfax.org.uk | quotation, and he'll look undressed.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                   Leto Atreides, D=
une

--/T+UM55GOh1Yge7W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZd0vQAAoJEFheFHXiqx3kyLAP/R1/nIlbb3qOoGKugUhZ3Xxc
SgD6fSWla9KlBAVYFMBMRNT6EGtXxj7ehJ6pF27oPcFuH+lkezgCmVMrv3XFHgrJ
+2d135+Oh2nq5OkVN8BA6xeuVLmr5n8OmNX3n9HSKVnAUy6cxd50bTqJS8QZVzOB
jQPQC/g7QWT9KS5W6zMkgm6EOtVn4lkZ+kNmlsIssXmwszVrqYbwmLRwJhNOX+Ol
NUbUJX2gqHFK6Bp4vySQdBqVAJjbta4LaeZ+TBeiEyNCzo3foEa+w9PneltLWxxs
D8SSbuqUKdOtsHJsyJukUdZJIqXVcLsnv5raEhRbP2cCvMiQcIDH2V+p9NLEsWEC
bYLO32iaM8Bk6DmnUnB8rZQ42gjeBOrmhAQ25TzCntx83LlYWOfYgMFUZAj2ljvm
9Wc8HarABmbpV8rECz/3ckMKo1d/2GVhdbxhGnmbDZgAKxtDRlr/t22g+4/FSnKy
WNcE6u89A2EY0qmgOz/T4lpsFvK7mTxyXpQD9V7GRJYlgqa9RePNZJr5edT3cY11
PyUa3dFiUvwApogr4JjaTwYqpzJhXfiHRS5/T7IekofmZJY4qx+ReSZ56WyU5nWu
a0z9mzEsITv/mCgnb78+6sfq3Ge06Jsp5/R+13bMmeL12Gcf0TwnSN+P5uEogZcU
wY9oslc3X+TJi0JQb4Px
=uCkL
-----END PGP SIGNATURE-----

--/T+UM55GOh1Yge7W--
