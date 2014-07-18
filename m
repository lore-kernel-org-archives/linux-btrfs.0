Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from omr-d02.mx.aol.com ([205.188.109.194]:60429 "EHLO
	omr-d02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbaGRMBt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 08:01:49 -0400
Received: from mtaout-aaj01.mx.aol.com (mtaout-aaj01.mx.aol.com [172.27.3.205])
	by omr-d02.mx.aol.com (Outbound Mail Relay) with ESMTP id E8251700000BA
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 08:01:47 -0400 (EDT)
Received: from [141.20.212.200] (unknown [141.20.212.200])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mtaout-aaj01.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 1458638000092
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 08:01:46 -0400 (EDT)
Message-ID: <53C90CA8.2000104@aol.de>
Date: Fri, 18 Jul 2014 14:01:44 +0200
From: Karl-Philipp Richter <krichter722@aol.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: `btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
 & 1)' failed.` in `btrfsck`
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RAUTfdVBJavKcSxrJqkBI2hBDNAXXjFEf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RAUTfdVBJavKcSxrJqkBI2hBDNAXXjFEf
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi together,
I'm experiencing the following issues when I invoke `btrfsck` on a
sparse file image with a GPT and one (the only) btrfs partition attached
to a loop device

    $ sudo btrfsck --repair --init-csum-tree --init-extent-tree -b
/dev/loop0p1
    Incorrect local backref count on 128510738432 root 5 owner 3849475
offset 0 found 1 wanted 0 back 0xbab41270
    backpointer mismatch on [128510738432 4096]
    ref mismatch on [128510742528 12288] extent item 0, found 1
    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
& 1)' failed.

    $ sudo btrfsck --repair --init-csum-tree --init-extent-tree /dev/loop=
0p1
    Incorrect local backref count on 128510726144 root 5 owner 3849470
offset 0 found 1 wanted 0 back 0xbbcb9500
    backpointer mismatch on [128510726144 12288]
    ref mismatch on [128510738432 4096] extent item 0, found 1
    adding new data backref on 128510738432 root 5 owner 3849475 offset
0 found 1
    Backref 128510738432 root 5 owner 3849475 offset 0 num_refs 0 not
found in extent tree
    Incorrect local backref count on 128510738432 root 5 owner 3849475
offset 0 found 1 wanted 0 back 0xbbcb9630
    backpointer mismatch on [128510738432 4096]
    ref mismatch on [128510742528 12288] extent item 0, found 1
    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
& 1)' failed.

    $ sudo btrfsck --repair /dev/loop0p1
    Incorrect local backref count on 130861096960 root 5 owner 22733727
offset 0 found 1 wanted 0 back 0xc7c7d170
    backpointer mismatch on [130861096960 8192]
    ref mismatch on [130861105152 8192] extent item 0, found 1
    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
& 1)' failed.

    $ sudo btrfsck --repair /dev/loop0p1
    Backref 130861096960 root 5 owner 22733727 offset 0 num_refs 0 not
found in extent tree
    Incorrect local backref count on 130861096960 root 5 owner 22733727
offset 0 found 1 wanted 0 back 0xc7f31170
    backpointer mismatch on [130861096960 8192]
    ref mismatch on [130861105152 8192] extent item 0, found 1
    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
& 1)' failed.

I'm using `btrfs-progs` 24cf4d8c3ee924b474f68514e0167cc2e602a48d on
Linux 3.16-rc5 (anything else, i.e. older versions, give me immediate
error after start because errornous file system)

I'd like to know whether this (assertion) error is related to a bug or
missing feature in btrfs-progs and might be fixed at some point or
whether this might indicate a completely messed up btrfs.

Best regards,
Karl-P. Richter


--RAUTfdVBJavKcSxrJqkBI2hBDNAXXjFEf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTyQyoAAoJEGadKJ8eJ7ZGKeYH/Rah6BiSq2ZjCdYR5TOfKzm8
hfl2QF5KWF6kRCC/JzmhheRZtlpoq8LHiAcvIuBA9tXxTkefO6EC1pmYvCLX75Rk
U900ar/OFQTu2nbnMBSE2azg39lTzY6EHDlv5aIt/HULlC1PuabKhiVBsdrDR4UT
K5X0ed1vLXT48Zhv6BLldKBZvc6Mkb/qza2p36Ca2PzqjldkK3p0v8Guigku57rc
P0JGssPnnJhHPUPR73Ex6I5Gl5o74wlo1Q/qHiaxu1y9E763KQA29VxbQC/G6466
ni4vQNnQckp+mKsSRoZgTXhxGSoAaMPNYv/moZC5SqRD8XHabAtxN7ggu+sLZ+Y=
=4MBP
-----END PGP SIGNATURE-----

--RAUTfdVBJavKcSxrJqkBI2hBDNAXXjFEf--
