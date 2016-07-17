Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from achille.seblu.net ([62.210.204.83]:39798 "EHLO
	achille.seblu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbcGQCJb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 22:09:31 -0400
Received: from murphy.h.seblu.net (cac94-h02-176-184-25-92.dsl.sta.abo.bbox.fr [176.184.25.92])
	(Authenticated sender: seblu)
	by achille.seblu.net (Postfix) with ESMTPSA id D816750C0093
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 04:09:21 +0200 (CEST)
Message-ID: <1468721359.19617.169.camel@seblu.net>
Subject: Size reported differently between profiles
From: =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Sun, 17 Jul 2016 04:09:19 +0200
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-0zZuD784itTn6mVEMT1s"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-0zZuD784itTn6mVEMT1s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

=C2=ABbtrfs fi usage=C2=BB report size differently between single,RAID0,RAI=
D1,RAID5,RAID6
and RAID10.

The test is done with 2 files of 1.4GiB each on 4x10GiB devices. I used bal=
ance
to get size between profiles.

Data,single: Size:4.00GiB, Used:2.85GiB
=C2=A0=C2=A0=C2=A0/dev/sdb	=C2=A0=C2=A0=C2=A01.00GiB
=C2=A0=C2=A0=C2=A0/dev/sdc	=C2=A0=C2=A0=C2=A01.00GiB
=C2=A0=C2=A0=C2=A0/dev/sdd	=C2=A0=C2=A0=C2=A01.00GiB
=C2=A0=C2=A0=C2=A0/dev/sde	=C2=A0=C2=A0=C2=A01.00GiB

Data,RAID0: Size:8.00GiB, Used:2.85GiB
=C2=A0=C2=A0=C2=A0/dev/sdb	=C2=A0=C2=A0=C2=A02.00GiB
=C2=A0=C2=A0=C2=A0/dev/sdc	=C2=A0=C2=A0=C2=A02.00GiB
=C2=A0=C2=A0=C2=A0/dev/sdd	=C2=A0=C2=A0=C2=A02.00GiB
=C2=A0=C2=A0=C2=A0/dev/sde	=C2=A0=C2=A0=C2=A02.00GiB

Data,RAID1: Size:4.00GiB, Used:2.85GiB
   /dev/sdb	   2.00GiB
   /dev/sdc	   2.00GiB
   /dev/sdd	   2.00GiB
   /dev/sde	   2.00GiB

Data,RAID5: Size:6.00GiB, Used:2.85GiB
   /dev/sdb	   2.00GiB
   /dev/sdc	   2.00GiB
   /dev/sdd	   2.00GiB
   /dev/sde	   2.00GiB

Data,RAID6: Size:6.00GiB, Used:2.85GiB
   /dev/sdb	   3.00GiB
   /dev/sdc	   3.00GiB
   /dev/sdd	   3.00GiB
   /dev/sde	   3.00GiB

Data,RAID10: Size:4.00GiB, Used:2.85GiB
   /dev/sdb	   1.00GiB
   /dev/sdc	   1.00GiB
   /dev/sdd	   1.00GiB
   /dev/sde	   1.00GiB

For single,RAID0,RAID10 profiles, the sum of device sizes is equal to total=
 size. Like total size is the "byte allocated size" for all devices.

For RAID1,RAID5,RAID6 profiles, sum of devices sizes is more than the total=
 size. Looks like the redundancy was subtracted from the total.
Like total size is the "profile size allocated".

So, why RAID1 and RAID10 are reporting their sizes differently? This confus=
e me.

Cheers,

--=20
S=C3=A9bastien "Seblu" Luttringer
https://seblu.net | Twitter: @seblu42
GPG: 0x2072D77A
--=-0zZuD784itTn6mVEMT1s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIUBAABCQAGBQJXiujPAAoJEDwch2Awtl/iuEAPwJywRGDeO/0lxKLOG5jDBjhB
JiVrnSTra9PgKuDP+h3Dvla1BwVurur25+CQqnkkFi2kUDmtbXUV+8NrL3SZDlnW
feYfkMliIuxcL9WVS0Fy9UBugutRzCFZHIMG22ywTsRUlrgu1RstoAPDrXSi6Bod
chtbD7jnutbGQEloGZOPoHxXUAsZuXtGIg+0xSHbH5E6BJWmVmXGqdQED6Xyae9s
mgxKHhXhLZhMdWtcMdcv/HfRpqrvD6rEEAoE3TuQ38ETQv+IQbt8U9wBU0UUHLGD
GjqCWcUqp6YDfq1OGp6P4t/wHuG7jBD8mzBfsAuzTOm0A6NbYWVuKAWlY0YbGZXR
udAzli1b4d/qxQydTH11dsj1ZajRNOyZz1gOC3UpRBEEq17uM1yxBwVodKsKASsI
q/vGYZBeZ2K6xpiz7nqARXVnz//mDuqixB52xb2jZpObClq+wKDscS1NZJNIoa9a
gsQjMhQvly///yOEOtv727evRlNs/XWY0Ps4lJ/AqFf+H37Dicz9SXYBqZYDM9w3
A4OxL+C4B/1AUN43WPRxghJFFIwoodSx2U4UP5rMAHpWAX+IaQx6TPFsbwrCqk21
hw621X9WFOv09hCDMMgEAFHzWr2MeimQy95WrCCEy+Lqf8I5QIMqL5z2rVWpqFYA
y2/zQ+osPg==
=sLiU
-----END PGP SIGNATURE-----

--=-0zZuD784itTn6mVEMT1s--

