Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:50123 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab3AYNAR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 08:00:17 -0500
Date: Fri, 25 Jan 2013 19:00:12 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
Message-ID: <20130125190012.3672dae6@natsu>
In-Reply-To: <51027AB8.6030901@czarc.net>
References: <1359113550-23962-1-git-send-email-gene@czarc.net>
	<20130125175530.75402fb5@natsu>
	<51027AB8.6030901@czarc.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VBOrusASlgZSHLuHBVo6nlC"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/VBOrusASlgZSHLuHBVo6nlC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jan 2013 07:29:44 -0500
Gene Czarcinski <gene@czarc.net> wrote:

> After all, I do not need to be root to execute "btrfs --version".

Is that all that comes to mind? I just did

$ dd if=3D/dev/zero of=3Dfs.img bs=3D1M count=3D2048
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 3.76772 s, 570 MB/s

$ /sbin/mkfs.btrfs fs.img

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on fs.img
	nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
Btrfs Btrfs v0.19

$ /sbin/btrfsck fs.img=20
checking extents
checking fs roots
checking root refs
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 23875
file data blocks allocated: 0
 referenced 0
Btrfs Btrfs v0.19

etc, etc.

And after that I could start a QEMU VM or an UserModeLinux kernel image,
passing this fs.img to it as a block device -- all while still being a regu=
lar
user, without needing root privileges.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/VBOrusASlgZSHLuHBVo6nlC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlECgdwACgkQTLKSvz+PZwgisACdHbxLTpIjKbh1j1GmhOjBYJMk
EccAn0v6dSWxrigZgxSISfoLSWnKpkKK
=CcBS
-----END PGP SIGNATURE-----

--Sig_/VBOrusASlgZSHLuHBVo6nlC--
