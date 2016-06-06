Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbcFFONL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 10:13:11 -0400
Subject: Re: Transaction aborted in btrfs_rename2
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
References: <20160606114732.GA30582@angband.pl>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>
Date: Mon, 6 Jun 2016 10:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <20160606114732.GA30582@angband.pl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GoQ1FNFBXFQiJVQJwTrFAXTtqGIJ42S2s"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GoQ1FNFBXFQiJVQJwTrFAXTtqGIJ42S2s
Content-Type: multipart/mixed; boundary="FlB3FAv2R0ds4xdH81H1m90LFWD8tcvOu"
From: Jeff Mahoney <jeffm@suse.com>
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
Message-ID: <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>
Subject: Re: Transaction aborted in btrfs_rename2
References: <20160606114732.GA30582@angband.pl>
In-Reply-To: <20160606114732.GA30582@angband.pl>

--FlB3FAv2R0ds4xdH81H1m90LFWD8tcvOu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/6/16 7:47 AM, Adam Borowski wrote:
> Hi!
> I just got this thrice, in 4.7-rc1 and 4.7-rc2:
>=20
> [ 1836.672368] ------------[ cut here ]------------
> [ 1836.672382] WARNING: CPU: 1 PID: 16348 at fs/btrfs/inode.c:9820 btrf=
s_rename2+0xcd2/0x2a50
> [ 1836.672385] BTRFS: Transaction aborted (error -2)
> [ 1836.672387] Modules linked in: nvidia(PO) usb_storage
> [ 1836.672396] CPU: 1 PID: 16348 Comm: gcc-6 Tainted: P           O    =
4.7.0-rc2-debug+ #3
> [ 1836.672399] Hardware name: System manufacturer System Product Name/M=
4A77T, BIOS 2401    05/18/2011
> [ 1836.672402]  ffffffff81f8b504 ffff880062c47c78 ffffffff8165be6d 0000=
000000000007
> [ 1836.672407]  ffff880062c47cd0 0000000000000000 ffff880062c47cc0 ffff=
ffff81110c1c
> [ 1836.672411]  ffff880062c47d20 0000265c814e8642 0000000000000000 0000=
000000a25ade
> [ 1836.672415] Call Trace:
> [ 1836.672423]  [<ffffffff8165be6d>] dump_stack+0x4e/0x71
> [ 1836.672429]  [<ffffffff81110c1c>] __warn+0x10c/0x150
> [ 1836.672433]  [<ffffffff81110caa>] warn_slowpath_fmt+0x4a/0x50
> [ 1836.672437]  [<ffffffff814f4842>] btrfs_rename2+0xcd2/0x2a50
> [ 1836.672443]  [<ffffffff814dfcfb>] ? btrfs_permission+0x5b/0xc0
> [ 1836.672448]  [<ffffffff81d288c8>] ? down_write+0x18/0x60
> [ 1836.672453]  [<ffffffff8133a0cc>] vfs_rename+0x7cc/0xc30
> [ 1836.672457]  [<ffffffff8133dc8b>] SyS_rename+0x32b/0x420
> [ 1836.672461]  [<ffffffff81d2ab9f>] entry_SYSCALL_64_fastpath+0x17/0x9=
3
> [ 1836.672464] ---[ end trace 6405b6e3d0e6c945 ]---
> [ 1836.672468] BTRFS warning (device sda1): btrfs_rename:9820: Aborting=
 unused transaction(No such entry).
> [ 1836.675505] BTRFS warning (device sda1): btrfs_rename:9820: Aborting=
 unused transaction(No such entry).
> <repeated 1152 times>
> [ 1837.935238] BTRFS warning (device sda1): btrfs_rename:9820: Aborting=
 unused transaction(No such entry).
> [ 1837.937602] BTRFS: error (device sda1) in btrfs_rename:9820: errno=3D=
-2 No such entry
> [ 1837.937607] BTRFS info (device sda1): forced readonly
> [ 1838.086754] BTRFS warning (device sda1): Skipping commit of aborted =
transaction.
> [ 1838.086762] BTRFS: error (device sda1) in cleanup_transaction:1857: =
errno=3D-2 No such entry
> [ 1838.086782] BTRFS info (device sda1): delayed_refs has NO entry
>=20
> Didn't trigger during a week of other work, yet a kernel compile trigge=
rs
> this reliably.
>=20
> Filesystem appears consistent (btrfs check, scrub).
> Mount options: noatime,compress=3Dlzo,ssd,space_cache.
>=20

Oh, interesting.  We're seeing this on our 4.4-based kernels as well but
only on arm64.  That it's triggering on x86_64 is a good data point.
I'm hunting this one today.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--FlB3FAv2R0ds4xdH81H1m90LFWD8tcvOu--

--GoQ1FNFBXFQiJVQJwTrFAXTtqGIJ42S2s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXVYTwAAoJEB57S2MheeWyzq8P/iFeeJRJDVTOLC12pzIDMXMM
oOIMPaZMjJeeb67AnYY8EqpuZ9HrASuSQujqMGEjz3QXnPIL0qrqTVv/y+VJAE9r
oNeUVJiDMQW6oRXTdGRNCkJFikrWN7qBueZm7oLMq8PW9Uz9O8JqYR/Fh1uLmRim
R9qF6z+ZAPjzmGNX4fn1hXXmv4H4pi2DDOmBFuWwQ255E/lz3RwcgxKuv4rkwa1J
p9btDhcdsGXfUnwLNRmCrkTrfhOzxYxCnFpCKSbyORcArQ6/LlnKaz1FgrAUj+fK
c1lFs/cBb18HovMdQ0Crb9DJeGJDFirllpI2FnrIg9LS1FFJHw+RB+B9PWwjJ0sy
/uD/vGrJFEy4gek4PNC3bf9V2gPu9HJpIn53a0EeWvxveWi7qTUsAxEWLXT9XEOn
tnHLzZbDQqQzkU2yykKk948trkbN1Ylj8HpQHXJUdtHReu+1OK+lpeBDFp4mDCOQ
eAtaImPBmV61Ik/xLzyly/8AyKDXcnIJIqLdW2Pt6dnSI3HZ0h/aUw8gTHDEEdn4
P7pHMOL8WdEaGE0vt/INnZdTFiqi7BObc3hsYDskSyveNTRlgk59QUUFyjPUbn9h
XMd/0iRxRcSzIiuZJbR+55sAArvksBfi7zTqbv690NH/Qv6QsH0MMZzGo0fAiNz3
2ag1lNdGek6z5wRR2YLq
=Hz1J
-----END PGP SIGNATURE-----

--GoQ1FNFBXFQiJVQJwTrFAXTtqGIJ42S2s--
