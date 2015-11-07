Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43437 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbbKGXa7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 18:30:59 -0500
Date: Sat, 7 Nov 2015 23:30:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: strange "No space left on device"
Message-ID: <20151107233057.GG27446@carfax.org.uk>
References: <1446938562.7297.7.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f5QefDQHtn8hx44O"
In-Reply-To: <1446938562.7297.7.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--f5QefDQHtn8hx44O
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 08, 2015 at 12:22:42AM +0100, Christoph Anton Mitterer wrote:
> Hey.
>=20
> I just repeatedly did the following twice on a ~8GB USB stick, under
> Debian sid (ergo kernel=C2=A04.2.0-1-amd64, btrfsprogs=C2=A04.2.2-1).
>=20
> First, created some GPT on the stick:
> Number=C2=A0=C2=A0Start (sector)=C2=A0=C2=A0=C2=A0=C2=A0End (sector)=C2=
=A0=C2=A0Size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Code=C2=A0=C2=A0Name
> =C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A02048=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01048575=C2=A0=C2=A0=C2=A0511.0 MiB=C2=A0=C2=A0=C2=A0EF02=C2=A0=C2=A0BIOS=
 boot partition
> =C2=A0=C2=A0=C2=A02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
1048576=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A03145727=C2=A0=
=C2=A0=C2=A01024.0 MiB=C2=A0=C2=A08300=C2=A0=C2=A0Linux filesystem
> =C2=A0=C2=A0=C2=A03=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
3145728=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04194303=C2=A0=
=C2=A0=C2=A0512.0 MiB=C2=A0=C2=A0=C2=A08300=C2=A0=C2=A0Linux filesystem
> =C2=A0=C2=A0=C2=A04=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
4194304=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A06291455=C2=A0=
=C2=A0=C2=A01024.0 MiB=C2=A0=C2=A08300=C2=A0=C2=A0Linux filesystem
> =C2=A0=C2=A0=C2=A05=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
6291456=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A015687644=C2=A0=C2=A0=
=C2=A04.5 GiB=C2=A0=C2=A0=C2=A0=C2=A0=C2=A08300=C2=A0=C2=A0Linux filesystem

   These are all really small.

   I would suggest running mkfs with --mixed for all of these
filesystems and trying again.

   Hugo.

> Then filesystems:
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-main /dev/sdb2=20
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Label:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0boot-main
> UUID:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0150ee9fb-c650-4b5b-8f64-606e589e429a
> Node size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0163=
84
> Sector size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04096
> Filesystem size:=C2=A0=C2=A0=C2=A0=C2=A01.00GiB
> Block group profiles:
> =C2=A0 Data:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0single=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A08.00MiB
> =C2=A0 Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0DUP=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A059.19MiB
> =C2=A0 System:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0DUP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A012.00MiB
> SSD detected:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0no
> Incompat features:=C2=A0=C2=A0extref, skinny-metadata
> Number of devices:=C2=A0=C2=A01
> Devices:
> =C2=A0=C2=A0=C2=A0ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SIZE=
=C2=A0=C2=A0PATH
> =C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01.00GiB=C2=A0=C2=
=A0/dev/sdb2
>=20
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-data /dev/sdb3
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Label:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0boot-data
> UUID:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0b1c1fc77-c965-4f0c-a2b5-44a301fd8772
> Node size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0163=
84
> Sector size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04096
> Filesystem size:=C2=A0=C2=A0=C2=A0=C2=A01.00GiB
> Block group profiles:
> =C2=A0 Data:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0single=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A08.00MiB
> =C2=A0 Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0DUP=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A059.19MiB
> =C2=A0 System:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0DUP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A012.00MiB
> SSD detected:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0no
> Incompat features:=C2=A0=C2=A0extref, skinny-metadata
> Number of devices:=C2=A0=C2=A01
> Devices:
> =C2=A0=C2=A0=C2=A0ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SIZE=
=C2=A0=C2=A0PATH
> =C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01.00GiB=C2=A0=C2=
=A0/dev/sdb3
>=20
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-archive
> /dev/sdb4
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Label:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0boot-archive
> UUID:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0a063cf3b-0322-4ec7-a8c1-2dabecad9f57
> Node size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0163=
84
> Sector size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04096
> Filesystem size:=C2=A0=C2=A0=C2=A0=C2=A01.00GiB
> Block group profiles:
> =C2=A0 Data:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0single=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A08.00MiB
> =C2=A0 Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0DUP=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A059.19MiB
> =C2=A0 System:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0DUP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A012.00MiB
> SSD detected:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0no
> Incompat features:=C2=A0=C2=A0extref, skinny-metadata
> Number of devices:=C2=A0=C2=A01
> Devices:
> =C2=A0=C2=A0=C2=A0ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SIZE=
=C2=A0=C2=A0PATH
> =C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01.00GiB=C2=A0=C2=
=A0/dev/sdb4
>=20
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-rescue /dev/sdb5
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Label:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0boot-rescue
> UUID:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0104b7bc3-3b8c-4a08-b0a6-9172ed664e68
> Node size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0163=
84
> Sector size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04096
> Filesystem size:=C2=A0=C2=A0=C2=A0=C2=A03.98GiB
> Block group profiles:
> =C2=A0 Data:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0single=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A08.00MiB
> =C2=A0 Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0DUP=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0211.75MiB
> =C2=A0 System:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0DUP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A012.00MiB
> SSD detected:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0no
> Incompat features:=C2=A0=C2=A0extref, skinny-metadata
> Number of devices:=C2=A0=C2=A01
> Devices:
> =C2=A0=C2=A0=C2=A0ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SIZE=
=C2=A0=C2=A0PATH
> =C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A03.98GiB=C2=A0=C2=
=A0/dev/sdb5
>=20
>=20
>=20
> No errors in the kernel log.
>=20
>=20
>=20
> Then I got usage info:
> root@heisenberg:/data/SSS/boot# btrfs filesystem usage data/
> Overall:
> =C2=A0=C2=A0=C2=A0=C2=A0Device size:		=C2=A0=C2=A0=C2=A01.00GiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device allocated:		=C2=A0126.38MiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device unallocated:		=C2=A0897.62MiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device missing:		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.=
00B
> =C2=A0=C2=A0=C2=A0=C2=A0Used:			=C2=A0256.00KiB
> =C2=A0=C2=A0=C2=A0=C2=A0Free (estimated):		=C2=A0905.62MiB	(min: 456.81Mi=
B)
> =C2=A0=C2=A0=C2=A0=C2=A0Data ratio:			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01.00
> =C2=A0=C2=A0=C2=A0=C2=A0Metadata ratio:		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A02.00
> =C2=A0=C2=A0=C2=A0=C2=A0Global reserve:		=C2=A0=C2=A016.00MiB	(used: 0.00=
B)
>=20
> Data,single: Size:8.00MiB, Used:0.00B
> =C2=A0=C2=A0=C2=A0/dev/sdb3	=C2=A0=C2=A0=C2=A08.00MiB
>=20
> Metadata,DUP: Size:51.19MiB, Used:112.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdb3	=C2=A0102.38MiB
>=20
> System,DUP: Size:8.00MiB, Used:16.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdb3	=C2=A0=C2=A016.00MiB
>=20
> Unallocated:
> =C2=A0=C2=A0=C2=A0/dev/sdb3	=C2=A0897.62MiB
> root@heisenberg:/data/SSS/boot# btrfs filesystem usage main/
> Overall:
> =C2=A0=C2=A0=C2=A0=C2=A0Device size:		=C2=A0=C2=A0=C2=A01.00GiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device allocated:		=C2=A0126.38MiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device unallocated:		=C2=A0897.62MiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device missing:		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.=
00B
> =C2=A0=C2=A0=C2=A0=C2=A0Used:			=C2=A0256.00KiB
> =C2=A0=C2=A0=C2=A0=C2=A0Free (estimated):		=C2=A0905.62MiB	(min: 456.81Mi=
B)
> =C2=A0=C2=A0=C2=A0=C2=A0Data ratio:			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01.00
> =C2=A0=C2=A0=C2=A0=C2=A0Metadata ratio:		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A02.00
> =C2=A0=C2=A0=C2=A0=C2=A0Global reserve:		=C2=A0=C2=A016.00MiB	(used: 0.00=
B)
>=20
> Data,single: Size:8.00MiB, Used:0.00B
> =C2=A0=C2=A0=C2=A0/dev/sdb2	=C2=A0=C2=A0=C2=A08.00MiB
>=20
> Metadata,DUP: Size:51.19MiB, Used:112.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdb2	=C2=A0102.38MiB
>=20
> System,DUP: Size:8.00MiB, Used:16.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdb2	=C2=A0=C2=A016.00MiB
>=20
> Unallocated:
> =C2=A0=C2=A0=C2=A0/dev/sdb2	=C2=A0897.62MiB
> root@heisenberg:/data/SSS/boot# btrfs filesystem usage rescue/
> Overall:
> =C2=A0=C2=A0=C2=A0=C2=A0Device size:		=C2=A0=C2=A0=C2=A03.98GiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device allocated:		=C2=A0431.50MiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device unallocated:		=C2=A0=C2=A0=C2=A03.56GiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device missing:		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.=
00B
> =C2=A0=C2=A0=C2=A0=C2=A0Used:			=C2=A0320.00KiB
> =C2=A0=C2=A0=C2=A0=C2=A0Free (estimated):		=C2=A0=C2=A0=C2=A03.57GiB	(min=
: 1.79GiB)
> =C2=A0=C2=A0=C2=A0=C2=A0Data ratio:			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01.00
> =C2=A0=C2=A0=C2=A0=C2=A0Metadata ratio:		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A02.00
> =C2=A0=C2=A0=C2=A0=C2=A0Global reserve:		=C2=A0=C2=A016.00MiB	(used: 0.00=
B)
>=20
> Data,single: Size:8.00MiB, Used:64.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdb5	=C2=A0=C2=A0=C2=A08.00MiB
>=20
> Metadata,DUP: Size:203.75MiB, Used:112.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdb5	=C2=A0407.50MiB
>=20
> System,DUP: Size:8.00MiB, Used:16.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdb5	=C2=A0=C2=A016.00MiB
>=20
> Unallocated:
> =C2=A0=C2=A0=C2=A0/dev/sdb5	=C2=A0=C2=A0=C2=A03.56GiB
>=20
>=20
>=20
> Still all fine.
>=20
> Now I write to one of the filesystems (main at first, that still works)
> but then when I cp -a from another btrfs to data:
> cp: error writing =E2=80=98data/SHA512-sums.OLD=E2=80=99: No space left o=
n device
> cp: failed to extend =E2=80=98data/SHA512-sums.OLD=E2=80=99: No space lef=
t on device
> cp: error writing =E2=80=98data/SHA512-sums=E2=80=99: No space left on de=
vice
> cp: failed to extend =E2=80=98data/SHA512-sums=E2=80=99: No space left on=
 device
>=20
> (these files are just a few bytes large)
> On the target fs, they're there but all 0 bytes large.
>=20
> (btw: I've aliased cp to cp --reflink=3Dauto
>=20
>=20
> When I now repeat the usage info:
> root@heisenberg:/data/SSS/boot# btrfs filesystem usage data
> Overall:
> =C2=A0=C2=A0=C2=A0=C2=A0Device size:		=C2=A0=C2=A0=C2=A01.00GiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device allocated:		=C2=A0118.38MiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device unallocated:		=C2=A0905.62MiB
> =C2=A0=C2=A0=C2=A0=C2=A0Device missing:		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00.=
00B
> =C2=A0=C2=A0=C2=A0=C2=A0Used:			=C2=A0256.00KiB
> =C2=A0=C2=A0=C2=A0=C2=A0Free (estimated):		=C2=A0=C2=A0=C2=A08.00EiB	(min=
: 8.00EiB)
> =C2=A0=C2=A0=C2=A0=C2=A0Data ratio:			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0-nan
> =C2=A0=C2=A0=C2=A0=C2=A0Metadata ratio:		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A02.00
> =C2=A0=C2=A0=C2=A0=C2=A0Global reserve:		=C2=A0=C2=A016.00MiB	(used: 0.00=
B)
>=20
> Metadata,DUP: Size:51.19MiB, Used:112.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdc3	=C2=A0102.38MiB
>=20
> System,DUP: Size:8.00MiB, Used:16.00KiB
> =C2=A0=C2=A0=C2=A0/dev/sdc3	=C2=A0=C2=A016.00MiB
>=20
> Unallocated:
> =C2=A0=C2=A0=C2=A0/dev/sdc3	=C2=A0905.62MiB
>=20
> It get's bogus... at least the Free space shows 8 EiB (if wishes were
> horses)...
>=20
> Still no error in kernel logs:
> =C2=A03401.934514] BTRFS: device label boot-rescue devid 1 transid 8
> /dev/sdc5
> [ 3401.985858] BTRFS: device label boot-main devid 1 transid 8
> /dev/sdc2
> [ 3401.988601] BTRFS: device label boot-data devid 1 transid 9
> /dev/sdc3
> [ 3401.997370] BTRFS: device label boot-archive devid 1 transid 9
> /dev/sdc4
> [ 3403.721091] BTRFS info (device sdc3): disk space caching is enabled
> [ 3403.721098] BTRFS: has skinny extents
> [ 3413.964033] BTRFS info (device sdb3): disk space caching is enabled
> [ 3413.964042] BTRFS: has skinny extents
> [ 3522.902309] BTRFS info (device sdb3): disk space caching is enabled
> [ 3522.902314] BTRFS: has skinny extents
> [ 3525.055653] BTRFS info (device sdc3): disk space caching is enabled
> [ 3525.055659] BTRFS: has skinny extents
>=20
>=20
> btrfs check doesn't show errors either.
>=20
>=20
> After a balance, i can copy again, even though the usage still shows 8
> EiB for a while...
>=20
>=20
> Anyway how can it happen, that on a fresh btrfs with no files at all a
> balance is necessary?
> Or is there some deeper corruption going on here?
>=20
>=20
> Thanks,
> Chris.



--=20
Hugo Mills             | Reintarnation: Coming back from the dead as a
hugo@... carfax.org.uk | hillbilly
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--f5QefDQHtn8hx44O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWPomxAAoJEFheFHXiqx3k/jsQAIXsQ0f1OGIQOETWh/rNMmH4
OMUnOHpOKZskoSVB3BUlgUayeSy5/GDBo93OA/pqZqnsH1QopOM1iyRoWoF3Ug1R
dVc7wl4FsWKpluyoV+QcPzePN5WxpxkbZotOdRPraVtGnzG6C2i0o1dFGk3Ydidj
Wka/bdVrxwER1Zo/slJ/RuHWpuIoz+rj2SpYaBl71E6+K6A1IC4w+qx1x7BATwCE
jQ+oEFGa7DiWkNH286FsZ3LgZL+7qmlCUF9y1RTEW8busMtrdjRnxJ/udMLJmppl
uVjGNV8BltoryKJbopM7mVzDZaxBSGmdvxlqPo3LisJs2oPTtT4ZmZU0zvlXOEUp
GBngX/dW1ZoBAQ+3WQG+TINcD1AmifU12FlwfOW3juDw/CpgHAsAvE9jFIqOVypO
jUPA9yccGWZWwAsOHUCsKX8vN/1XNUNiD1EyO5GdV3r0HHU1AQ3HgYZTYWP2OPI8
U4Yv1sNn8Opj18PMMPbhBW9UU1C9Pq710bwVwOzCZoO9Znlb/nShql+ffbzmGDxd
iRvEQKkdvzBx9ZqlbADkDjG1JySi+g4dgbEsSZbI4lv0lXzkxFor7ACxU+jeb7oA
HZyY8aeluGywcvvZL57r1lvvye/gY4lu9a+fzRYcSbeTUaGibydf8VjwMtYzYXQv
98vRU+RC3Wlp4JnVblvJ
=hTrb
-----END PGP SIGNATURE-----

--f5QefDQHtn8hx44O--
