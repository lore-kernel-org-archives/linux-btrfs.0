Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:54119 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab3B0JRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 04:17:24 -0500
Date: Wed, 27 Feb 2013 15:17:21 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: "Fajar A. Nugraha" <list@fajar.net>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Suman C <schakrava@gmail.com>
Subject: Re: lvm volume like support
Message-ID: <20130227151721.5da0c46d@natsu>
In-Reply-To: <201302270942.03347.Martin@lichtvoll.de>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
	<CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com>
	<20130227100558.37d86d82@natsu>
	<201302270942.03347.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G+rPriupMTiAp6O_nV0Ocx3"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/G+rPriupMTiAp6O_nV0Ocx3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Feb 2013 09:42:02 +0100
Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Are you sure about the partition support? I thought something related to=
=20
> loop partition support has gone into some not so recent kernel.

Sorry, you are correct, this was in fact added since 2.6.26.

Just tried out making a partitioned loop device:

  dd if=3D/dev/zero of=3D100GB bs=3D1 count=3D1 seek=3D100G
  modprobe loop max_part=3D8
  losetup /dev/loop7 100GB
  cfdisk /dev/loop7

  [ made two partitions, commit, quit cfdisk ]

  [ ...but partitions did not automatically appear as /dev/loop7pX ]

  blockdev --rereadpt /dev/loop7

  [ OK, now here they are: ]
 =20
  $ ls -la /dev/loop7p?
  brw-rw---T 1 root disk 7, 113 Feb 27 15:10 /dev/loop7p1
  brw-rw---T 1 root disk 7, 114 Feb 27 15:10 /dev/loop7p2

--=20
With respect,
Roman

--Sig_/G+rPriupMTiAp6O_nV0Ocx3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEtzyEACgkQTLKSvz+PZwi0vwCfQ8bt914fKdhMuo4qJ5yxH/JD
BdkAnR21rF88Qfsrzg8sGL1hPtvR4RBF
=+MPF
-----END PGP SIGNATURE-----

--Sig_/G+rPriupMTiAp6O_nV0Ocx3--
