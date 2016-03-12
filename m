Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:51526 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbcCLRPa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 12:15:30 -0500
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id E0D9D124798
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Mar 2016 17:15:27 +0000 (UTC)
Date: Sat, 12 Mar 2016 22:15:24 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: parent transid verify failed on snapshot deletion
Message-ID: <20160312221524.646e1a66@natsu>
In-Reply-To: <20160312204847.2092f3f3@natsu>
References: <20160312204847.2092f3f3@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/efzmZ53z03UkrS1WN+u7NrP"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/efzmZ53z03UkrS1WN+u7NrP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

btrfsck output:

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
found 2455135703350 bytes used err is -22
total csum bytes: 0
total tree bytes: 368590848
total fs tree bytes: 0
total extent tree bytes: 364605440
btree space waste bytes: 122267203
file data blocks allocated: 1294204928
 referenced 1294204928

Seems like it should be safe to run --repair?

--=20
With respect,
Roman

--Sig_/efzmZ53z03UkrS1WN+u7NrP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbkTq8ACgkQTLKSvz+PZwisXACeJ47aTvrkFWmsYbnqoOnKWzPx
1OcAmgJeB6QbhC9BgxxCFWOzXwQqAiQO
=oaJ7
-----END PGP SIGNATURE-----

--Sig_/efzmZ53z03UkrS1WN+u7NrP--
