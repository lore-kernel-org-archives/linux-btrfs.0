Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.ru ([50.31.253.214]:36564 "EHLO rin.romanrm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436Ab2FHTzt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 15:55:49 -0400
Received: from home.romanrm.ru (unknown [92.255.174.192])
	by rin.romanrm.ru (Postfix) with ESMTPS id 0F13F434720
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2012 19:55:47 +0000 (UTC)
Received: from natsu (unknown [IPv6:2001:470:d7f6::100])
	by home.romanrm.ru (Postfix) with ESMTPS id 074A21FE19
	for <linux-btrfs@vger.kernel.org>; Sat,  9 Jun 2012 01:38:26 +0600 (YEKT)
Date: Sat, 9 Jun 2012 01:38:22 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: linux-btrfs@vger.kernel.org
Subject: Massive metadata size increase after upgrade from 3.2.18 to 3.4.1
Message-ID: <20120609013822.6b06a008@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.aaP6qlKyquuKhPRsbitzw0"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/.aaP6qlKyquuKhPRsbitzw0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Before the upgrade (on 3.2.18):

Metadata, DUP: total=3D9.38GB, used=3D5.94GB

After the FS has been mounted once with 3.4.1:

Data: total=3D3.44TB, used=3D2.67TB
System, DUP: total=3D8.00MB, used=3D412.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D84.38GB, used=3D5.94GB

Where did my 75 GB of free space just went?

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/.aaP6qlKyquuKhPRsbitzw0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/SVK4ACgkQTLKSvz+PZwj8GgCgkAKaGgA1n79+kRaIHMbZlnck
m84AniTj5BZdx941A35x7la6V5NhaF/z
=n8yT
-----END PGP SIGNATURE-----

--Sig_/.aaP6qlKyquuKhPRsbitzw0--
