Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:36346 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaB1HhO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 02:37:14 -0500
Date: Fri, 28 Feb 2014 13:37:12 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Help with space
Message-ID: <20140228133712.3d0eef21@natsu>
In-Reply-To: <pan$49c16$7a7687d1$aadeeb14$c250e08e@cox.net>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
	<20140228103436.2dfd2669@natsu>
	<pan$49c16$7a7687d1$aadeeb14$c250e08e@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/V0quPe2CMnn/1HsL7hX/yHB"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/V0quPe2CMnn/1HsL7hX/yHB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Feb 2014 07:27:06 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Based on what I've read on-list, btrfs is not arch-agnostic, with certain=
=20
> on-disk sizes set to native kernel page size, etc, so a filesystem=20
> created on one arch may well not work on another.
>=20
> Question: Does this apply to x86/amd64?  Will a filesystem created/used=20
> on 32-bit x86 even mount/work on 64-bit amd64/x86_64, or does upgrading=20
> to 64-bit imply backing up (in this case) double-digit TiB of data to=20
> something other than btrfs and testing it, doing a mkfs on the original=20
> filesystem once in 64-bit mode, and restoring all that data from backup?

Page size (4K) is the same on both i386 and amd64. It's also the same on AR=
M.

Problem arises only on architectures like MIPS and PowerPC, some variants of
which use 16K or 64K page sizes.

Other than this page size issue, it has no arch-specific dependencies,  e.g.
no on-disk structures with "CPU-native integer" sized fields etc, that'd be=
 too
crazy to be true.

--=20
With respect,
Roman

--Sig_/V0quPe2CMnn/1HsL7hX/yHB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlMQPKgACgkQTLKSvz+PZwhrEQCfcalfR15vDwpWxLamKvMtRpO7
IT8An29+xNqaPRwjqIDlZhgUlbmBVLUp
=MKHj
-----END PGP SIGNATURE-----

--Sig_/V0quPe2CMnn/1HsL7hX/yHB--
