Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:56484 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055AbcATP3P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 10:29:15 -0500
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id 5D7F7FD46A
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 15:29:10 +0000 (UTC)
Date: Wed, 20 Jan 2016 20:29:09 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Kernel 4.4.0 intermittent ENOSPC during heavy data write and
 concurrent snapshotting
Message-ID: <20160120202909.4a804707@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Corgr6GwHJOVgoD10yojqZr"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Corgr6GwHJOVgoD10yojqZr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

To reproduce...

*) in one terminal window:

    btrfs sub create test
    chattr +C test
    cd test/
    while true; do dd if=3D/dev/zero of=3Dzerofile bs=3D1M count=3D1024; sy=
nc; done

*) in another terminal window start repeatedly snapshotting 'test', at rand=
om
  1-3-5 second intervals:=20

    mkdir snaps
    btrfs sub snap test snaps/test-`date +%Y-%m-%dT%H:%M:%S`

The 'dd' output of first window then looks like this for me:

1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 0.49982 s, 2.1 GB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 0.541291 s, 2.0 GB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 4.88021 s, 220 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 4.56427 s, 235 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 0.530991 s, 2.0 GB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 5.68497 s, 189 MB/s
dd: writing `zerofile': No space left on device
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000591943 s, 0.0 kB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 4.25015 s, 253 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 4.66459 s, 230 MB/s
dd: writing `zerofile': No space left on device
1015+0 records in
1014+0 records out
1063489536 bytes (1.1 GB) copied, 3.0433 s, 349 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 4.24264 s, 253 MB/s
dd: writing `zerofile': No space left on device
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000647234 s, 0.0 kB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 3.56673 s, 301 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 3.71281 s, 289 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 0.551317 s, 1.9 GB/s
^C
-----

This also causes my KVM VMs to fail with a high probability during
snapshotting of their backing subvolume (as described in the previous threa=
d).

--=20
With respect,
Roman

--Sig_/Corgr6GwHJOVgoD10yojqZr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlafp8UACgkQTLKSvz+PZwhekgCfbfRqATnEb1KRwJWEUTziEnHc
qtAAnA6A4gaph0O2cuH/y2P1NUqp/Xw0
=y9VA
-----END PGP SIGNATURE-----

--Sig_/Corgr6GwHJOVgoD10yojqZr--
