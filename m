Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62118 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbaHUIOW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 04:14:22 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: init uninitialized output buf for btrfs-restore
Date: Thu, 21 Aug 2014 10:14:12 +0200
Message-ID: <2179924.d4q2ELedVV@fb07-iapwap2>
In-Reply-To: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3032052.eE8A6LkL2j"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3032052.eE8A6LkL2j
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Hi Gui,

Am Donnerstag, 21. August 2014, 11:35:36 schrieb Gui Hecheng:
> A memory problem reported by valgrind as follows:
> 	=== Syscall param pwrite64(buf) points to uninitialised byte(s)
> When running:
> 	# valgrind --leak-check=yes btrfs restore /dev/sda9 /mnt/backup
> 
> Because the output buf size is alloced with malloc, but the length of
> output data is shorter than the sizeof(buf), so valgrind report
> uninitialised byte(s).
> We could use calloc to repalce malloc and clear this WARNING away.

yes, the warning vanished. But the reads from free'd memory make me more 
worring...

Marc

--nextPart3032052.eE8A6LkL2j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJT9apUAAoJEKyeR39HFBto5J4H/RYMJfOZYnIOLrWdECovotwK
HVNj/awzcwl7V3HiE1G6ZdrQbkNvV/gQEjaKl8mOtuz5f0icI8+hgi9mVsDEbOIj
OoizH8v09Gt+qKqzFL9yvlBgtlMtrunq5D+rE2SHrA6Vpd0mqRKSF0x7KA498yba
L5kHrAg0AxOeHBpoxNsvK4xwJtd+OTUNjcuMdinQWw6oYLkfFTmeEm8mqw5WxhVB
nyCZqiasPDXDqGBEA70Q1u3PhR7bDKC53CQ3Qztq3CJ2EyrxvhRejpOGkwMCQmds
q268FhIy0pZZAwvCYQtovEJz3LyJlw4gQSZm6gBCkaWr4zwmPjny0LF9lsMQwUM=
=cxY2
-----END PGP SIGNATURE-----

--nextPart3032052.eE8A6LkL2j--

