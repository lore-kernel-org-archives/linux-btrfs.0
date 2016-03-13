Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:51562 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbcCMJYj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 05:24:39 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id E28FB124C82
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 09:24:33 +0000 (UTC)
Date: Sun, 13 Mar 2016 14:24:28 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: parent transid verify failed on snapshot deletion
Message-ID: <20160313142428.377b51b8@natsu>
In-Reply-To: <20160312221524.646e1a66@natsu>
References: <20160312204847.2092f3f3@natsu>
	<20160312221524.646e1a66@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CCsgtcI.qU0HbdnD/W6zUpY"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/CCsgtcI.qU0HbdnD/W6zUpY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Mar 2016 22:15:24 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> Seems like it should be safe to run --repair?

Well this is unexpected, I ran --repair, and it did not do anything.

# btrfsck --repair /dev/alpha/lv1
enabling repair mode
Checking filesystem on /dev/alpha/lv1
UUID: 8cf8eff9-fd5a-4b6f-bb85-3f2df2f63c99
checking extents
parent transid verify failed on 7483566862336 wanted 410578 found 404133
parent transid verify failed on 7483566862336 wanted 410578 found 404133
parent transid verify failed on 7483566862336 wanted 410578 found 404133
parent transid verify failed on 7483566862336 wanted 410578 found 404133
Ignoring transid failure
bad block 7483566862336
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 7483566862336 wanted 410578 found 404133
Ignoring transid failure
Fixed 0 roots.
checking free space cache
parent transid verify failed on 7483566862336 wanted 410578 found 404133
Ignoring transid failure
There is no free space entry for 6504947712-7537164288
cache appears valid but isnt 6463422464
found 2455135691065 bytes used err is -22
total csum bytes: 0
total tree bytes: 368590848
total fs tree bytes: 0
total extent tree bytes: 364605440
btree space waste bytes: 122267201
file data blocks allocated: 1294204928
 referenced 1294204928

# btrfsck /dev/alpha/lv1
Checking filesystem on /dev/alpha/lv1
UUID: 8cf8eff9-fd5a-4b6f-bb85-3f2df2f63c99
checking extents
parent transid verify failed on 7483566862336 wanted 410578 found 404133
parent transid verify failed on 7483566862336 wanted 410578 found 404133
parent transid verify failed on 7483566862336 wanted 410578 found 404133
parent transid verify failed on 7483566862336 wanted 410578 found 404133
Ignoring transid failure
bad block 7483566862336
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 7483566862336 wanted 410578 found 404133
Ignoring transid failure
checking free space cache
parent transid verify failed on 7483566862336 wanted 410578 found 404133
Ignoring transid failure
There is no free space entry for 6504947712-7537164288
cache appears valid but isnt 6463422464
found 2455135691065 bytes used err is -22
total csum bytes: 0
total tree bytes: 368590848
total fs tree bytes: 0
total extent tree bytes: 364605440
btree space waste bytes: 122267201
file data blocks allocated: 1294204928
 referenced 1294204928

With "Errors found in extent allocation tree", I wonder if I should
try --init-extent-tree next.

--=20
With respect,
Roman

--Sig_/CCsgtcI.qU0HbdnD/W6zUpY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlblMdEACgkQTLKSvz+PZwhi6gCgl3GFKwXlNbbXUclrm/VRRxjl
1A0An1lSDkEBgvfnhCl2+00V8sgd8nvx
=1L+b
-----END PGP SIGNATURE-----

--Sig_/CCsgtcI.qU0HbdnD/W6zUpY--
