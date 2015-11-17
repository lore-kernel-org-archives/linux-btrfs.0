Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bender.boerde.de ([83.223.75.23]:57564 "EHLO bender.boerde.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbbKQNSR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Nov 2015 08:18:17 -0500
Received: from hunapu.boerde.de (darkwing.home.local [IPv6:2a01:30:2802:1:2ad2:44ff:feb0:8e38])
	by bender.boerde.de (Postfix) with ESMTPSA id 7211914540FD
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2015 14:18:14 +0100 (CET)
Date: Tue, 17 Nov 2015 14:18:13 +0100
From: Georg Lukas <georg@op-co.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-replace OOM on 2GB machine
Message-ID: <20151117131657.GA3424@ovgu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
In-Reply-To: <564B23D8.2000202@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Austin S Hemmelgarn <ahferroin7@gmail.com> [2015-11-17 13:56]:
> While it probably isn't related to the OOM issue, I would be particularly
> wary of using BTRFS on SMR disks, we've had multiple reports of serious
> issues with them (and IIRC, they were all the same model of 8TB Seagate S=
MR
> disks).

Yes, that's exactly the model I have here, but the problems are related
to the SMR support in the kernel, and hopefully not at all to btrfs.
With the latest patch by Martin K. Petersen [*], the disks seem to be
stable and reliable, finally.

[*] https://bugzilla.kernel.org/show_bug.cgi?id=3D93581

> Hmm, it looks like things weren't all RAID1, you've got a little over 1TiB
> of data that was RAID0, and that may be why you can't rebuild the FS.  Th=
is
> shouldn't be causing an OOM condition, but it definitely means things are
> not fully recoverable.

I think this was caused by my attempt to rebalance the degraded RAID1
into RAID0, and there are indeed some files on the fs that I can't read
any more. As this is not a production system, I'm not very bothered - I
just wanted to find out if I can get it back to live, which currently
fails on the replace.

> This actually looks like it's a different issue potentially, for some rea=
son
> BTRFS is trying to scrub the missing disk (which won't work of course).

Indeed, scrubbing the degraded disk set did not succeed either.

If you need me to perform any other actions on that disk set, let me
know on- or off-list.

Georg
--=20
|| http://op-co.de ++  GCS d--(++) s: a C+++ UL+++ !P L+++ !E W+++ N  ++
|| gpg: 0x962FD2DE ||  o? K- w---() O M V? PS+ PE-- Y++ PGP+ t+ 5 R+  ||
|| Ge0rG: euIRCnet ||  X(+++) tv+ b+(++) DI+++ D- G e++++ h- r++ y?   ||
++ IRCnet OFTC OPN ||_________________________________________________||

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVkspFGBRyWxizTQeAQKtPA/+NDld5RtzUZgX2ycbNXDLy8PvA/z0G4L4
L1srKmR94CZn82EaGohykLG97ZOAa/lFROS6WIjTBpr10kvOsUcI/YPKOx4GICAY
IRANe3HfB0BhaEpb2nO1zy/1gjyAHFq2tylrI2TFqwa9bNWkWi63XuNdZ0tMVZGe
vypiTkHE4QS+hMJheiVz+r5pedegRFk1iVE/hkiI0EpcyvyE356za6gbrA8VS/aB
4gjMrOJ2Oi4lUZOm+yw1LNMkWPJK9/WaY0JLuVp6wKxujcGWkbTXhThpcIxExbu2
wXysbCnfs1fpg6apwqOJouBJDdx31/NwCABcYFQBBzZPYeKxs0+7dA4MiM9v6jn2
Q5ComhKwo/6gfPthXHnRlZINYdzLRWLonM/ruB24lOimTo6puqmY73ZtBp+AdGuL
bsHEBB1//nH+BpCPMIbF/sF9GIRlD1NyFiVdM0yLrVzqw4RD2Lz9aLAflv3xOiLY
DLhq5vz+eF0ZGWiZRtQKRDjGpNP2k2txRT10Li4NQf+NYIyHMmK2Jrkzbmvm0vBF
VRLbABFEh2vvAbeCkC9OFLOWfuarTfMegk32Evf++1rA+ZVqleQ2PovooLkiocCJ
/oEf2GH9D0yi4kSoQmpwTeewr2knLBsTXD+V7T1jGygCbp94paJa1mwGyKPKcaXN
t1JGLvJcY90=
=3qpz
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
