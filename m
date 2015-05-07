Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34016 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750876AbbEGWUf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 May 2015 18:20:35 -0400
Date: Thu, 7 May 2015 18:20:34 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Recipe for creating unlink deadlocks
Message-ID: <20150507222034.GC18025@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is the simplest repro recipe for this that I have found so far.
It takes only a few minutes for the rm processes to get stuck here:

# cat /proc/28396/stack                                                    =
                                                                           =
        Thu May  7 18:13:05 2015

[<ffffffff813c8a2d>] lock_extent_bits+0x1ad/0x200
[<ffffffff813b5dfa>] btrfs_evict_inode+0x17a/0x5e0
[<ffffffff8123fc68>] evict+0xb8/0x1b0
[<ffffffff81240813>] iput+0x1f3/0x260
[<ffffffff81233c68>] do_unlinkat+0x1d8/0x360
[<ffffffff812346db>] SyS_unlinkat+0x1b/0x40
[<ffffffff8190024d>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff


Run these three scripts in a directory that is the top of a subvol:

	# Script #1:  randomly create or delete snapshots
	while sleep 1; do
		if [ $[RANDOM%2] =3D 0 ]; then
			btrfs sub snap . snaps-$RANDOM
		else
			for x in snaps-*; do
				btrfs sub del $x
				break
			done
			btrfs sub sync .
		fi
	done=20

	# Script #2:  create a bunch of files of random sizes
	while true; do
		d=3D$[RANDOM%9]/$[RANDOM%9]/$[RANDOM%9]/$[RANDOM%9]
		mkdir -p ${d%/*}
		head -c $[RANDOM%1024]k /usr/share/doc/chromium/copyright > $d
	done=20

	# Script #3:  read and immediately delete all the files
	while date; do
		sleep 1
		find -type f -exec cat {} \; -exec rm -fv {} \; > /dev/null
	done=20


--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVL5TIACgkQgfmLGlazG5z7uACdECu6Y9eISMjWIk443Fwl/vch
F3IAn03CE6Gkpxz5kRzelbm1TJRJ03/X
=6hVL
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
