Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60647 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbeH3NhP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 09:37:15 -0400
Subject: Re: How to erase a RAID1 (+++)?
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
 <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1bc34cb7-7523-11e1-b12f-05aff161b3c6@gmx.com>
Date: Thu, 30 Aug 2018 17:35:49 +0800
MIME-Version: 1.0
In-Reply-To: <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Dc4YdFhjyXrXbsBosI2VWSmCvANI1IrQ7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Dc4YdFhjyXrXbsBosI2VWSmCvANI1IrQ7
Content-Type: multipart/mixed; boundary="DHMJwtYhZDgffFci9pJocDj1Oe6gz87Mw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
Message-ID: <1bc34cb7-7523-11e1-b12f-05aff161b3c6@gmx.com>
Subject: Re: How to erase a RAID1 (+++)?
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
 <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
In-Reply-To: <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>

--DHMJwtYhZDgffFci9pJocDj1Oe6gz87Mw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/30 =E4=B8=8B=E5=8D=885:13, Pierre Couderc wrote:
> Trying to install a RAID1 on a debian stretch, I made some mistake and
> got this, after installing on disk1 and trying to add second disk=C2=A0=
 :
>=20
>=20
> root@server:~# fdisk -l
> Disk /dev/sda: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> Units: sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Disk identifier: 0x2a799300
>=20
> Device=C2=A0=C2=A0=C2=A0=C2=A0 Boot Start=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 End=C2=A0=C2=A0=C2=A0 Sectors=C2=A0 Size Id Type
> /dev/sda1=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0 2048 3907028991 3907026944=C2=
=A0 1.8T 83 Linux
>=20
>=20
> Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> Units: sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Disk identifier: 0x9770f6fa
>=20
> Device=C2=A0=C2=A0=C2=A0=C2=A0 Boot Start=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 End=C2=A0=C2=A0=C2=A0 Sectors=C2=A0 Size Id Type
> /dev/sdb1=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0 2048 3907029167 3907027120=C2=
=A0 1.8T=C2=A0 5 Extended
>=20
>=20
> And :
>=20
> root@server:~# btrfs fi show
> Label: none=C2=A0 uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes use=
d 1.10GiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 1.82TiB used 4.02GiB path /dev/sda1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 si=
ze 1.00KiB used 0.00B path /dev/sdb1
>=20
> ...
>=20
> My purpose is a simple RAID1 main fs, with bootable flag on the 2 disks=

> in prder to start in degraded mode....
> How to get out ofr that...?

The 2nd device is indeed strange.

Considering how old packages Debian tends to deliver, it should be some
old btrfs-progs.

You could just boot into the system and execute the following commands:

# btrfs device remove 2 <mnt>

Then add a new real device to the fs

# btrfs device add <new device> <mnt>

Then convert the fs to RAID1

# btrfs balance start -dconvert=3DRAID1 -mconvert=3DRAID1 <mnt>

Thanks,
Qu

>=20
> Thnaks
> PC


--DHMJwtYhZDgffFci9pJocDj1Oe6gz87Mw--

--Dc4YdFhjyXrXbsBosI2VWSmCvANI1IrQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluHunUACgkQwj2R86El
/qjxCQgAgoH3TEF0QL25jAMfYLjBWrOr6ITvJv7BJA+u64YfvGHHABVNWID8/Uk1
ABRdUo9g1Tn/LHEgCX5EdHeRt2lPjeyzG0OGvE26WgKCz1v2/93R65xg1iLeYnjz
lXsNbWS+p42zq47HGzswG6nU5LpaRJHY2SapD4fiw5XvxRulokEC3JBCHM+wVIBV
mNjlH9ES0sWGbCYlCgZaxTwfpyYqtdrYnJElR+m5UW8fgOXQWtILZHwsE9ghf1Yz
rO/em76u6gmIjAjNOHyCDuGigcrXzIfz766zHAyCVjaKGaPj6qrCPv1tqfzYFz1S
1fB4BmyoX0mexB1FOFfqgx+Kp5B74g==
=FPsb
-----END PGP SIGNATURE-----

--Dc4YdFhjyXrXbsBosI2VWSmCvANI1IrQ7--
