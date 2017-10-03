Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46198 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdJCUKs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 16:10:48 -0400
Date: Tue, 3 Oct 2017 20:10:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Stephen Nesbitt <nesbittmeister@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Seeking Help on Corruption Issues
Message-ID: <20171003201047.GE3293@carfax.org.uk>
References: <c67167b4-190b-dfdc-33a8-8cb75a4744ef@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vv4Sf/kQfcwinyKX"
In-Reply-To: <c67167b4-190b-dfdc-33a8-8cb75a4744ef@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vv4Sf/kQfcwinyKX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 03, 2017 at 01:06:50PM -0700, Stephen Nesbitt wrote:
> All:
>=20
> I came back to my computer yesterday to find my filesystem in read
> only mode. Running a btrfs scrub start -dB aborts as follows:
>=20
> btrfs scrub start -dB /mnt
> ERROR: scrubbing /mnt failed for device id 4: ret=3D-1, errno=3D5
> (Input/output error)
> ERROR: scrubbing /mnt failed for device id 5: ret=3D-1, errno=3D5
> (Input/output error)
> scrub device /dev/sdb (id 4) canceled
> =A0=A0=A0 scrub started at Mon Oct=A0 2 21:51:46 2017 and was aborted aft=
er
> 00:09:02
> =A0=A0=A0 total bytes scrubbed: 75.58GiB with 1 errors
> =A0=A0=A0 error details: csum=3D1
> =A0=A0=A0 corrected errors: 0, uncorrectable errors: 1, unverified errors=
: 0
> scrub device /dev/sdc (id 5) canceled
> =A0=A0=A0 scrub started at Mon Oct=A0 2 21:51:46 2017 and was aborted aft=
er
> 00:11:11
> =A0=A0=A0 total bytes scrubbed: 50.75GiB with 0 errors
>=20
> The resulting dmesg is:
> [=A0 699.534066] BTRFS error (device sdc): bdev /dev/sdb errs: wr 0,
> rd 0, flush 0, corrupt 6, gen 0
> [=A0 699.703045] BTRFS error (device sdc): unable to fixup (regular)
> error at logical 1609808347136 on dev /dev/sdb
> [=A0 783.306525] BTRFS critical (device sdc): corrupt leaf, bad key
> order: block=3D2589782867968, root=3D1, slot=3D116

   This error usually means bad RAM. Can you show us the output of
"btrfs-debug-tree -b 2589782867968 /dev/sdc"?

   Hugo.

> [=A0 789.776132] BTRFS critical (device sdc): corrupt leaf, bad key
> order: block=3D2589782867968, root=3D1, slot=3D116
> [=A0 911.529842] BTRFS critical (device sdc): corrupt leaf, bad key
> order: block=3D2589782867968, root=3D1, slot=3D116
> [=A0 918.365225] BTRFS critical (device sdc): corrupt leaf, bad key
> order: block=3D2589782867968, root=3D1, slot=3D116
>=20
> Running btrfs check /dev/sdc results in:
> btrfs check /dev/sdc
> Checking filesystem on /dev/sdc
> UUID: 24b768c3-2141-44bf-ae93-1c3833c8c8e3
> checking extents
> bad key ordering 116 117
> bad block 2589782867968
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> There is no free space entry for 1623012450304-1623012663296
> There is no free space entry for 1623012450304-1623225008128
> cache appears valid but isn't 1622151266304
> found 288815742976 bytes used err is -22
> total csum bytes: 0
> total tree bytes: 350781440
> total fs tree bytes: 0
> total extent tree bytes: 350027776
> btree space waste bytes: 115829777
> file data blocks allocated: 156499968
>=20
> uname -a:
> Linux sysresccd 4.9.24-std500-amd64 #2 SMP Sat Apr 22 17:14:43 UTC
> 2017 x86_64 Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz GenuineIntel
> GNU/Linux
>=20
> btrfs --version: btrfs-progs v4.9.1
>=20
> btrfs fi show:
> Label: none=A0 uuid: 24b768c3-2141-44bf-ae93-1c3833c8c8e3
> =A0=A0=A0 Total devices 2 FS bytes used 475.08GiB
> =A0=A0=A0 devid=A0=A0=A0 4 size 931.51GiB used 612.06GiB path /dev/sdb
> =A0=A0=A0 devid=A0=A0=A0 5 size 931.51GiB used 613.09GiB path /dev/sdc
>=20
> btrfs fi df /mnt:
> Data, RAID1: total=3D603.00GiB, used=3D468.03GiB
> System, RAID1: total=3D64.00MiB, used=3D112.00KiB
> System, single: total=3D32.00MiB, used=3D0.00B
> Metadata, RAID1: total=3D9.00GiB, used=3D7.04GiB
> Metadata, single: total=3D1.00GiB, used=3D0.00B
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> What is the recommended procedure at this point? Run btrfs check
> --repair? I have backups so losing a file or two isn't critical, but
> I really don't want to go through the effort of a bare metal
> reinstall.
>=20
> In the process of researching this I did uncover a bad DIMM. Am I
> correct that the problems I'm seeing are likely linked to the
> resulting memory errors.
>=20
> Thx in advance,
>=20
> -steve
>=20

--=20
Hugo Mills             | Quidquid latine dictum sit, altum videtur
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--vv4Sf/kQfcwinyKX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZ0+7GAAoJEFheFHXiqx3kr4sQALjAaI3DGzKOiZUA5XNLtCPu
xi5nKW8XPXLCBqueEHsuca2UzFE1KB0i9Z/labi7qKjcv6bSiDnGsln6PVJ47Spd
dCv/mASgciuCDxUJQXaNL6Dwzvq/CbmA3tB8pf1QWe52rTFcshdz9FGtJGDRxBwR
MryZu3N2a2hz7kCLuvHeAAa1TWZqvAgd12Mm+JD4x0zYMyls5/ulsAR9rL5p+gBi
QL99lM95QH+YdnZnpcXe8Wqv9ydUpnu8RQlGqAkkRi2fziz6pLem5PgxoVqrba5+
w8TniHmrM7IApjAwDESZ39zrHx9rYjtBymIw8iJfPl7abxM9znp3nl+3nxMCxjzK
HiXNev72wKPFWxnPDt8acOk1e7xzIFeR4Fn+wTdi1EzVlSymO5XK5hdZ32EwfA3F
RU8IkEjkXszK8eVKtLSxcw17c4PBNaa9lE0nwamcyD9VP0SXSocC1e8Er8JkAOU3
5+T4z2rt5AHWp50dUlZNh2qOYCvIgM+tMSq1m01PMTn/73LIBb8GyqZquw2wxlsB
4KAsamaHGVlariRQA8O/EPWWBUSFo0HnP7mffmLUXhzQ3O/6xi7+W1zJ//jZfFSk
/wZTRGlcpsFIEu3aGpDMyRAt00sHTkxc6ntnuSRokHIVgUmrD0ArG8VJx5OnYs46
VKw8C/bdV1GF7XhBSwc3
=fA2Q
-----END PGP SIGNATURE-----

--vv4Sf/kQfcwinyKX--
