Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37641 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbFJXKQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 19:10:16 -0400
Date: Wed, 10 Jun 2015 23:10:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: pubny@xs4all.nl
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "@" prefix in subvolume paths
Message-ID: <20150610231014.GF18226@carfax.org.uk>
References: <20150609195505.12ace1e8@host22323.xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NGIwU0kFl1Z1A3An"
In-Reply-To: <20150609195505.12ace1e8@host22323.xs4all.nl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NGIwU0kFl1Z1A3An
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 09, 2015 at 07:55:05PM +0200, pubny@xs4all.nl wrote:
> Hi,
>=20
> I've noticed this "@" sign in the subvolume's path with SLES12. I'm
> wondering what is its purpose. openSUSE 13.2 doesn't seem to be using
> it.

   They created a subvolume called "@" and then put all the other
subvolumes under there. There's nothing special about it.

   The @ is often used as a prefix on subvolumes (e.g. in Ubuntu) to
indicate that they're subvolumes, but it's not required, and doesn't
have any extra meaning beyond being a useful naming convention.

   Hugo.

> Thanks,
> G=E1bor
>=20
>=20
> SLES12:
> # btrfs sub list /
> ID 257 gen 2270 top level 5 path @
> ID 258 gen 1655 top level 257 path @/boot/grub2/i386-pc
> ID 259 gen 4263 top level 257 path @/boot/grub2/x86_64-efi
> ID 260 gen 4037 top level 257 path @/opt
> ID 261 gen 2553 top level 257 path @/srv
> ID 262 gen 4521 top level 257 path @/tmp
> ID 263 gen 4492 top level 257 path @/usr/local
> ID 264 gen 1655 top level 257 path @/var/crash
> ID 265 gen 1655 top level 257 path @/var/lib/mailman
> ID 266 gen 1655 top level 257 path @/var/lib/named
> ID 267 gen 1655 top level 257 path @/var/lib/pgsql
> ID 268 gen 4523 top level 257 path @/var/log
> ID 269 gen 1655 top level 257 path @/var/opt
> ID 270 gen 4524 top level 257 path @/var/spool
> ID 271 gen 4521 top level 257 path @/var/tmp
> ID 275 gen 4505 top level 257 path @/.snapshots
>=20
>=20
> openSUSE 13.2:
>=20
> # btrfs subvol list /
> ID 257 gen 3481911 top level 5 path boot/grub2/i386-pc
> ID 258 gen 3481911 top level 5 path boot/grub2/x86_64-efi
> ID 259 gen 3517714 top level 5 path home
> ID 260 gen 3515789 top level 5 path opt
> ID 261 gen 3513493 top level 5 path srv
> ID 262 gen 3513372 top level 5 path tmp
> ID 263 gen 3517660 top level 5 path usr/local
> ID 264 gen 3513372 top level 5 path var/crash
> ID 265 gen 3513372 top level 5 path var/lib/mailman
> ID 266 gen 3513372 top level 5 path var/lib/named
> ID 267 gen 3513372 top level 5 path var/lib/pgsql
> ID 268 gen 3517714 top level 5 path var/log
> ID 269 gen 3513372 top level 5 path var/opt
> ID 270 gen 3517714 top level 5 path var/spool
> ID 271 gen 3517706 top level 5 path var/tmp
> ID 276 gen 3517669 top level 5 path .snapshots

--=20
Hugo Mills             | ... one ping(1) to rule them all, and in the
hugo@... carfax.org.uk | darkness bind(2) them.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Ill=
iad

--NGIwU0kFl1Z1A3An
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVeMPWAAoJEFheFHXiqx3kguQP/iF3aN5IO/+W87LanAYiH02Y
mOoH1eZnoK2uQZRsc6WincvzrO0vkRQGZ/KoctgklzSduVZSoINWEJS5DTScMWpy
BCoe18Uros103XGzxIaVb4jH0lToRQeink7HcbAf4eEuhB10Va2UabCshNm7l48b
gHVGwPlC7CUGWjSuP7JAWvt3azhA1PXzcYtjXZ2SzPbkdwoDNoohhXP3hpvyT+Aj
rAB2M3ZeXaOti69oxyPzX0c/6yRpc4hIIeUNCtqHlnUA2wAh9X8j1bHsRdnmPYtQ
MwxrjjWkIKHc7ljn56h9BsYDB+aQyFptQXDsNqVQdurigsZoKLq6erja7TC9mo7l
29ntTtWm65oltnNDlYoefUWxTHtapHkYPKZxw0xpTpQR+bHWqR8tcrVvxV/aAuUn
r253mMB5xlNrCqlp027IgfcJWneLcLS88mLUcCJ0FGA7+oXX83A+mOjpKwVtvD/P
wlTEmQ5FzBLWAfJFAy8HZQyvXJuAAeMCDjD8jUb8uAGNVxUmYAs7AxpXxvMjpAY8
bvIDgZW4GCMGjcLcTjqvW+o6uoKCcHPs10V6DhJts8+PA16aXczQlRcUj/BSQVt/
GX85A9eR89c+YHtBooxmzIku2FWTJPakC/86GBPbqAhblAxc8HpASKvfRYmg852Q
oUNhnXC3QOnJVJ0effx3
=x/O+
-----END PGP SIGNATURE-----

--NGIwU0kFl1Z1A3An--
