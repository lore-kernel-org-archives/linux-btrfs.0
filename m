Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34984 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbbKWHGm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 02:06:42 -0500
Received: by pacej9 with SMTP id ej9so182258781pac.2
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2015 23:06:41 -0800 (PST)
Received: from [192.168.146.53] (fenrir.ics.es.osaka-u.ac.jp. [133.1.236.59])
        by smtp.googlemail.com with ESMTPSA id ir5sm8975050pbc.13.2015.11.22.23.06.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 22 Nov 2015 23:06:41 -0800 (PST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jiachen Yang <farseerfc@gmail.com>
Subject: Error while deleting device from a raid1 array
Message-ID: <5652BAF9.7030307@gmail.com>
Date: Mon, 23 Nov 2015 16:06:33 +0900
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vgN6dT9xX9TwLe0b57bpdct1uaiK0n9lP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vgN6dT9xX9TwLe0b57bpdct1uaiK0n9lP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm sorry if this email is sent twice. Gmail says it failed to deliver
because it contains HTML, so I will try with plain text:

I have a raid1 array that contains 3 devices like this:

Label: 'pool' uuid: 7e66ba23-14c7-47b5-90fc-481ecc769138

Total devices 3 FS bytes used 888.04GiB
devid    1 size 931.51GiB used 738.03GiB path /dev/sdb
devid    2 size 465.76GiB used 228.00GiB path /dev/sdc
devid    5 size 1.82TiB used 966.03GiB path /dev/sdd

btrfs-progs v4.3
Data, RAID1: total=3D939.00GiB, used=3D871.94GiB
System, RAID1: total=3D32.00MiB, used=3D192.00KiB
Metadata, RAID1: total=3D27.00GiB, used=3D16.10GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

I was planning to replace devid 2 with another larger HDD so that I can
have more space.
Because I have no spare slots for a new device, I have to firstly delete
the devid 2 and then add the new device to it. A simple calculation
suggested that after deleting devid 2, I should still have enough space
to hold a raid1 on the remaining 2 devices.

So I issued `btrfs device delete /dev/sdc /pool`, and after a while, my
FS turned write-only with this error in dmesg:
https://cfp.vim-cn.com/ccm2

I have reboot and tried for several times, and it will always stopped
with this kind of situation.
The last time I tried, the system refused to mount the btrfs array with
an error says something like:
`BTRFS: open_ctree failed`. I reboot forcefully and it mounted again.

Now I am afraid to try again, so I bring it here. I have 2 questions:
1. Do I have enough space to hold raid1 even if I deleted devid 2?
2. How to delete devid 2 safely?

About my system version:
Linux yang-z800 4.2.5-1-ARCH #1 SMP PREEMPT Tue Oct 27 08:13:28 CET 2015
x86_64 GNU/Linux
btrfs-progs v4.3.1

Thank you

--=20
Jiachen Yang =E6=A5=8A=E5=98=89=E6=99=A8
Graduate School of Information Science and Technology, Osaka University
Blog: https://farseerfc.me/
Gmail: farseerfc@gmail.com


--vgN6dT9xX9TwLe0b57bpdct1uaiK0n9lP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWUrr9AAoJEJDLPWLBPUeW17oIAKz/j5CYxyGmojpovkbjohuZ
YRI3Yvd0rw8i2JEYEL9uONNLI6lg6dMJyfwwi2exiKNhrFivGHck6qWXbd1jniWy
CRIoqOVqoBssf/0F27lmtjR475VyfRfe1O12m012JwuOx9t3loI3K+QApseyFJqu
G3+/c03/BpIT0CJ26Gg7b+6t5UkKt/zuTJDKdGzYlzPI1D8eeXA6TS/D1ohij4I3
czXqtMsdVjRq0GfbTCFChiZx/nB+746e7i0KMKu4drkr9dC52cYnHYw1qFgcWrfr
mnRt81QOo7mi0t+1PrGTT9cFK/6dx4K0hGhp/q6+NnHqV+SZAYzgQsjkvn/FgZM=
=94++
-----END PGP SIGNATURE-----

--vgN6dT9xX9TwLe0b57bpdct1uaiK0n9lP--
