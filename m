Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38034 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab3JMNOW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Oct 2013 09:14:22 -0400
Date: Sun, 13 Oct 2013 14:14:19 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Thomas Schneider <c.monty@web.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS Multidevice Filesystem: Save to delete one device?
Message-ID: <20131013131419.GB28147@carfax.org.uk>
References: <trinity-f923ab06-8e1c-42f6-8266-b864c521187e-1381669360111@3capp-webde-bs45>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d2IMS6fuC0p5eWIP"
In-Reply-To: <trinity-f923ab06-8e1c-42f6-8266-b864c521187e-1381669360111@3capp-webde-bs45>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--d2IMS6fuC0p5eWIP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 13, 2013 at 03:02:40PM +0200, Thomas Schneider wrote:
> Hello!
> I have the following disk setup:
> 1x 3TB WD
> 2x 2TB WD
> On each disk I have created a single partition, and this partition is for=
matted in BTRFS.
> Then, I have setup a multidevice filesystem:
> root@pc5:/media# btrfs filesystem show
> Label: 'WD30EZRX-00M'=A0 uuid: 7008c941-a5e1-44b6-9965-de726d22cc21
> Total devices 3 FS bytes used 4.07TB
> =A0 =A0devid=A0 =A0 2 size 1.82TB used 1.72TB path /dev/sdd1
> =A0 =A0devid=A0 =A0 1 size 2.73TB used 2.63TB path /dev/sdb1
> =A0 =A0devid=A0 =A0 3 size 1.82TB used 0.00 path /dev/sdc1
>=20
> Btrfs Btrfs v0.19
> root@pc5:/media# btrfs filesystem df /media/sdb1/
> Data: total=3D4.17TB, used=3D4.07TB
> System, DUP: total=3D8.00MB, used=3D472.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D94.00GB, used=3D5.30GB
> Metadata: total=3D8.00MB, used=3D0.00
> =A0
> You can see that devid 3 (=3D/dev/sdc1) is not utilized at all.

   Was that added later, after you'd filled much of the FS? (I'm just
checking -- otherwise, the space usage you show here might indicate
some kind of problem).

> Question:
> How can I delete devid 2 (=3D/dev/sdd1) securely without loosing any data?

$ btrfs dev del /media/sdb1 /dev/sdd1

   The data on the device will be moved elsewhere in the FS (i.e. to
the other two devices).

   However, be aware that there's a bug in the code in the area of
balancing and device management, and you should probably be running a
3.12-rc4+ kernel (or 3.11.5) before you try this. Your userspace tools
are also old and could probably do with an upgrade -- but that's not
particulary an issue in this instance.

> Please note that all data stored in this multidevice filesystem is locate=
d in a subvolume, means no data is stored in root tree.
> =A0
> root@pc5:/media# btrfs subvolume list /media/sdb1/
> ID 258 top level 5 path @video
> ID 2760 top level 5 path @musik
> ID 3995 top level 5 path @bilder
> ID 3996 top level 5 path @dokumente
> ID 3997 top level 5 path @software
> ID 3998 top level 5 path @hardware

   That doesn't make any difference for this operation.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "You know,  the British have always been nice to mad people." --- =20

--d2IMS6fuC0p5eWIP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUlqcqlheFHXiqx3kAQL0ahAAuEmaaI0OImNQw6G4RS6TiZoeVfjSYvzD
kaY9FjhdI64bMmaQi+ftv+QCNYK83NFX/2N7IM2HeCpIhdf0iHGy58sSHQrXFeCQ
mlT89MT5nC3Q8+71sHcGN0XUwfoAmicCVvOn/DQLSKlgr+SwNT/1dsexX+se8EuX
ykqQp1jIQlmGFEEu8uVDRXz8b0sbx0YH3YtUpKgA2zYZ7UYg0HqdEHt4o63NonLm
xkbulE0fAZvqyAHdvk1FqV69M58ZpNN6q45wG7erSABZFQV0ruyLpVzSChyhJUYn
j8quNYYvd0lfFx+jELgnbjiMJKwnV6Ood8FK3nZgKDn7mzP2VWvfqd2vS/irI9hZ
AHq7qIYl8NBhJk7iXcX5mqjyOt2I4GVStZZ1BV0fV7qsLHPt3UqsYaZjFE6dHgpZ
hdQH8XvkHLH6hnkqNFjGIX2XwyQPD7yM8M2SjOttKN11wPyM0Sw5wC4rCSNXH5M8
Nu3YMrWr+sWquU4IkE625QdPGfZjjIvT2+5F6rxr066BNmHgBL9unhOAafo8oB4W
XNGFmFNWTHBTun9jRcPApe3MC7PKofj24J2paNYIkAqWGLVPt0ojxN4qpXGbjAOV
YzMsChLCx+UpwlCkWSHp1dhDIpwETmKnkD4zaSr5/zObA3Cz4ZGkY71Ii1qvUV+H
xMJw+oWQ7uY=
=UwvS
-----END PGP SIGNATURE-----

--d2IMS6fuC0p5eWIP--
