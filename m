Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37467 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbcEHJLt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 May 2016 05:11:49 -0400
Date: Sun, 8 May 2016 09:11:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: block group xxx has wrong amount of free space
Message-ID: <20160508091146.GU7228@carfax.org.uk>
References: <CABXGCsMnqD1kSDipKzq3FN6+mE0Zct6r3HsCpZMO7qDr6aRi2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sosn/fv6aiTyEgxl"
In-Reply-To: <CABXGCsMnqD1kSDipKzq3FN6+mE0Zct6r3HsCpZMO7qDr6aRi2g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Sosn/fv6aiTyEgxl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 08, 2016 at 12:10:35PM +0500, =D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=
=BB =D0=93=D0=B0=D0=B2=D1=80=D0=B8=D0=BB=D0=BE=D0=B2 wrote:
> $ journalctl -b -1 --no-pager | grep BTRFS
> May 08 01:28:23 localhost kernel: BTRFS: device fsid
> a22dd8bc-24ef-4f97-bb62-01fcd7c3f11c devid 1 transid 25 /dev/sda4
> May 08 01:28:23 localhost kernel: BTRFS: device fsid
> eaa531cd-25f4-4e00-b31f-22665faa9768 devid 1 transid 333 /dev/sdb
> May 08 01:28:23 localhost kernel: BTRFS: device label home devid 1
> transid 2326870 /dev/sdc1
> May 08 01:28:26 localhost.localdomain kernel: BTRFS info (device
> sdc1): disk space caching is enabled

   All perfectly normal.

> May 08 01:28:26 localhost.localdomain kernel: BTRFS info (device
> sdc1): bdev /dev/sdc1 errs: wr 0, rd 14, flush 0, corrupt 0, gen 0

   As long as the number after "rd" doesn't change, you're OK. This
records all errors that the FS has encountered. You can reset the
values with btrfs dev stat -z.

> May 08 01:28:39 localhost.localdomain kernel: BTRFS error (device
> sdc1): could not find root 8

   This is harmless -- the FS is reporting that something (usually
systemd) was probing to find out if quotas are enabled, and they
aren't.

> May 08 01:40:30 localhost.localdomain kernel: BTRFS warning (device
> sdc1): block group 2286562574336 has wrong amount of free space
> May 08 01:40:30 localhost.localdomain kernel: BTRFS warning (device
> sdc1): failed to load free space cache for block group 2286562574336,
> rebuilding it now
> May 08 02:06:09 localhost.localdomain kernel: BTRFS warning (device
> sdc1): block group 3844117364736 has wrong amount of free space
> May 08 02:06:09 localhost.localdomain kernel: BTRFS warning (device
> sdc1): failed to load free space cache for block group 3844117364736,
> rebuilding it now

   These report that there's a problem with the free space cache. This
is not likely to be damaging, but could impact performance. It will
probably take some time (possibly on the scale of hours, depending on
the size of the FS) for the cache to rebuild, so leave the machine up
for a while. If the cache messages persist, clear it manually by
mounting once with -oclear_cache, then mount again once with
-ospace_cache, and again wait for it to rebuild.

   Hugo.

> These messages appear on every boot.
> That they means? And how fix it?
>=20
> $ uname -r
> 4.5.3-300.fc24.x86_64
>=20

--=20
Hugo Mills             | Two things came out of Berkeley in the 1960s: LSD
hugo@... carfax.org.uk | and Unix. This is not a coincidence.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Sosn/fv6aiTyEgxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXLwLSAAoJEFheFHXiqx3keQ0P/i87N8djog0QTkOg+y9went9
6E7vw7x9PCz5qi/pkz1E73T0QimUI9JA3UsfaIC6tT5IBmUkiXz0YpcIS4HDVRRf
WugqXx95aX05eqrLyW25fwuYmTRts42II/5aHa1vDJXPPwRGBAcMB9hWp81qQNSa
kJUCaNak5XQUKvKwwzH8mkRJCF5o4hm7SgHzajCsrSbU9lfSRBStcaQICy05DtfE
dd58MXPVoHQp1E6dEVsrV+Klw3ci9HIJcySnlDJv44ZL6tyNIoQdqxmVuiASzPPw
8dd7RBcTo5B29iD6fYQU4u6+Pn3SdBa+WLuPTyh7r6JIIEVJcKDav2MgJkwGhIbn
+xPRkehpe/OiVYhipD79V3NAzz1Lsu9i8WIYRrqSe/F6qklgfCd0oGOwP+sij5T6
QDmeKi0E0IJzA565zAV3sTrZ5vcILxOhYZ7ppm8r5H/tcLceU1XGrZFHBU9FKdqH
nu0M336IomMJi8RwXVfs1oW/jvr3uNsmG8wqF5x/aC4dBFTYJ/x9znHYcuDxNgNi
h2vI24oognGRvKSGN3ofmYwW+j+WtWCfJkn+49z1NsnIc72nyJide74u+ucPF3Ha
f1c9oufwJkFLyTAvNdLs94tiZ02Z+ozX+pZ+FF6BfTTdA99ScUYw9nMyoyC1ZnRL
YdFWpARbziAazf0PJlvP
=gOqa
-----END PGP SIGNATURE-----

--Sosn/fv6aiTyEgxl--
