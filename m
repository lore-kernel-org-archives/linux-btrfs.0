Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43703 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934101AbcCIVub (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 16:50:31 -0500
Date: Wed, 9 Mar 2016 21:50:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How to move a btrfs volume to a smaller disk
Message-ID: <20160309215029.GG17196@carfax.org.uk>
References: <56E099A1.8040506@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwxaKO075aXzzOz0"
In-Reply-To: <56E099A1.8040506@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RwxaKO075aXzzOz0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 09, 2016 at 10:46:09PM +0100, Hendrik Friedel wrote:
> Hello,
>=20
> I intend to move this subvolume to a new device.
> btrfs fi show /mnt2/Data_Store/
> Label: 'Data_Store'  uuid: 0ccc1e24-090d-42e2-9e61-d0a1b3101f93
>         Total devices 1 FS bytes used 47.93GiB
>         devid    1 size 102.94GiB used 76.03GiB path /dev/sdb4
>=20
> (fi usage at the bottom of this message)
>=20
> The new device (sda4) is 8G smaller unfortunately.
> sda       8:0    0 111.8G  0 disk
> =E2=94=94=E2=94=80sda4    8:4    0 103.5G  0 part
> sdb       8:16   0 119.2G  0 disk
> =E2=94=94=E2=94=80sdb4    8:20   0   111G  0 part  /mnt2/Data_Store
>=20
> Thus, btrfs replace does not work
>=20
> What would you suggest now to move the FS (it does contain many subvolume=
s)?

   btrfs dev resize to shrink it to (slightly smaller than) the
replacement device, then btrfs replace should work. Then btrfs dev
resize max to fill up the replacement device completely.

   Hugo.

> I tried btrfs send /mnt2/Data_Store/read_only_snapshot/ | btrfs
> receive /mnt/sda4/
> but this only created an empty subvolume /mnt/sda4/read_only_snapshot/
>=20
> So, then
> btrfs device add /dev/sda4 /mnt/Data_Store
> btrfs balance start /mnt/Data_Store
> btrfs device remove /dev/sdb4 /mnt/Data_Store
> ?
>=20
> Or is there a better option?
>=20
> Regards,
> Hendrik
>=20
>=20
>  btrfs fi usage  /mnt2/Data_Store/
> Overall:
>     Device size:                 102.94GiB
>     Device allocated:             74.03GiB
>     Device unallocated:           28.91GiB
>     Device missing:                  0.00B
>     Used:                         47.96GiB
>     Free (estimated):             53.24GiB      (min: 53.24GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>=20
> Data,single: Size:69.00GiB, Used:44.67GiB
>    /dev/sdb4      69.00GiB
>=20
> Metadata,single: Size:5.00GiB, Used:3.29GiB
>    /dev/sdb4       5.00GiB
>=20
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/sdb4      32.00MiB
>=20
> Unallocated:
>    /dev/sdb4      28.91GiB
>=20
>=20
> ---
> Diese E-Mail wurde von Avast Antivirus-Software auf Viren gepr=C3=BCft.
> https://www.avast.com/antivirus
>=20

--=20
Hugo Mills             | Well, sir, the floor is yours. But remember, the
hugo@... carfax.org.uk | roof is ours!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Go=
ons

--RwxaKO075aXzzOz0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW4JqlAAoJEFheFHXiqx3kUa8P/0mnsiLrVKT0BLHMPKziNTlg
s8VinuuMCNZWRdFTGgvd0aW7TWLEV7/CHRXvX2MaGOprXtTh2S0itZAXfQxKpfqc
1zV+U5MXI2D2aAyW9fioNu4UDq5+7uS4Zr8EqVTD0R6OGRRPmBGFpbuMmEUDhZzv
FcNs7g85rVImeJG/pzp547vzZ52gViTDMD32++r9zY8oEvAZRvBrZRDj/DnpP72c
9rnKKxo2jCtPbD0zCK5Q7yjBb1GBR0gip1DE6RqCNDBfzsIP5B6FLtCdrqshEz3c
PvHVTqa15p+YqNGBRUlRCUWF61aD/wzGb8ApuIwfAn2VX2xJdpel2q2D8WG7/iUZ
woEgnr9xVF8gePjirBECvxsSAqiCN2pOa/H01EaUFqgT7YZfKmqXgYW580KCDTiF
Inb7lgPqnORtW47wzWH2KOPyEkh7iAP0VpLq7+PaNUGxG9B0tIExCME+ON41/pnc
DkEWOeOf3mmnEY0NPx2dAGXKwqxGrNBbPfHFLI52LbpoHwOThJREEbb4TyNkIWnA
YGyJBE7+mLrzz1hOOWewcQ+0LRrsBlUv+3vm+UgB+WCpwVggf379fqFKMRrLzj04
vze2L0vpCLE+pazLfLhigqt8Adpx5CCV6ZvfECptlGDhn5u7XQNzp5onEXn774cm
ZEpxgSGSZQf6Qyx/0fkf
=aiWa
-----END PGP SIGNATURE-----

--RwxaKO075aXzzOz0--
