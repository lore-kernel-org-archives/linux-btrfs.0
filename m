Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:36574 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab3BZF5I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 00:57:08 -0500
Date: Tue, 26 Feb 2013 11:57:04 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Suman C <schakrava@gmail.com>
Cc: "Fajar A. Nugraha" <list@fajar.net>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: lvm volume like support
Message-ID: <20130226115704.50102196@natsu>
In-Reply-To: <CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
	<CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
	<CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
	<CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//ZdqgVkZMQSZ2C73LqS/9KV"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//ZdqgVkZMQSZ2C73LqS/9KV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Feb 2013 21:35:08 -0800
Suman C <schakrava@gmail.com> wrote:

> Yes, zvol like feature where a btrfs subvolume like construct can be
> made available as a LUN/block device. This device can then be used by
> any application that wants a raw block device. iscsi is another
> obvious usecase. Having thin provisioning support would make it pretty
> awesome.

I think what you are missing is that btrfs is a filesystem, not a block dev=
ice
management mechanism.

For your use case can simply create a snapshot and then make a sparse file
inside of it.

  btrfs sub create foobar
  dd if=3D/dev/zero of=3Dfoobar/100GB.img bs=3D1 count=3D1 seek=3D100G

If you need this to be a block device, use 'losetup' to make foobar/100GB.i=
mg
appear as one (/dev/loopX). But iSCSI/AoE/NBD can export files as well as b=
lock
devices, so this is not even necessary.

--=20
With respect,
Roman

--Sig_//ZdqgVkZMQSZ2C73LqS/9KV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEsTrAACgkQTLKSvz+PZwgcVgCeLBTFqv/s8vCp+TNX+I+v4Mab
woMAnAzM+Dy9mwckAHhoU6cq7q6ol09b
=dSUK
-----END PGP SIGNATURE-----

--Sig_//ZdqgVkZMQSZ2C73LqS/9KV--
