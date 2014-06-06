Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:43452 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaFFOkQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 10:40:16 -0400
Received: from natsu (unknown [IPv6:fd39::a60:6eff:fef3:b5b3])
	by mari.romanrm.net (Postfix) with ESMTPS id 5585B21403
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Jun 2014 14:40:12 +0000 (UTC)
Date: Fri, 6 Jun 2014 20:40:09 +0600
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs module dependencies broken in 3.14?
Message-ID: <20140606204009.261e8ec3@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0EDuK.EZ3PhunD3MukINSjr"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/0EDuK.EZ3PhunD3MukINSjr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Not sure if this has been reported somewhere closer to Btrfs development, a=
nd
not just in Debian... Anyways, just now I (also) hit this bug when upgradin=
g my
kernel from 3.12.21 to 3.14.5 on one machine (but not on a number of others=
):

  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D747929

I use btrfs as my root FS, and the error early in the initramfs stage, is
along the lines of:

> FATAL: Error inserting btrfs...: Unknown symbol in=20
> module, or unknown parameter (see dmesg)

(noting in dmesg).

The workaround has been detailed back in 2010:
https://lists.debian.org/debian-user/2010/06/msg02060.html

After adding "crc32c" into /etc/initramfs-tools/modules (for forced inclusi=
on
into the initramfs) and regenerating the initramfs image, the btrfs module
started loading fine.

Interesting why this problem from 2010 has resurfaced in 3.14, with 3.12
working normally. Also why not every machine with a similar setup is affect=
ed
(I have several hosts with btrfs root, although both hardware and software
configurations are not identical but quite diverse), but as I said just one
for me.

--=20
With respect,
Roman

--Sig_/0EDuK.EZ3PhunD3MukINSjr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOR0skACgkQTLKSvz+PZwg3+ACghzSbKVxK/+W9g5mIZ+crfDaX
qIEAn17n44GpSEo+/Qs8O/KJqCciVxGt
=1Sia
-----END PGP SIGNATURE-----

--Sig_/0EDuK.EZ3PhunD3MukINSjr--
