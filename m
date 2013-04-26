Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49314 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3DZVAE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:00:04 -0400
Received: by mail-ie0-f173.google.com with SMTP id k5so5461377iea.32
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 14:00:03 -0700 (PDT)
Received: from zeppelin.localnet (adsl-76-235-179-162.dsl.klmzmi.sbcglobal.net. [76.235.179.162])
        by mx.google.com with ESMTPSA id dy5sm5256132igc.1.2013.04.26.14.00.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 26 Apr 2013 14:00:02 -0700 (PDT)
From: Dave <dave@thekilempire.com>
To: linux-btrfs@vger.kernel.org
Subject: for-linus and linux 3.8.9
Date: Fri, 26 Apr 2013 17:00:01 -0400
Message-ID: <19280726.yCn8YDygvD@zeppelin>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7838550.CoH0lqvTBL"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart7838550.CoH0lqvTBL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

I've not been able to pull Chris's for-linus branch into a recent kernel for a 
few weeks now (since 3.8.5).  Is for-linus still compatible with the latest 
stable releases?  If not, what is the preferred way of running the latest 
btrfs code?

$ git clone linux linux-3.8.10
$ cd linux-3.8.10
$ git checkout v3.8.10
$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git 
for-linus

>From git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
 * branch            for-linus  -> FETCH_HEAD
Auto-merging include/uapi/linux/btrfs.h
Auto-merging fs/btrfs/volumes.c
Auto-merging fs/btrfs/tree-log.c
CONFLICT (content): Merge conflict in fs/btrfs/tree-log.c
Auto-merging fs/btrfs/scrub.c
Auto-merging fs/btrfs/inode.c
Auto-merging fs/btrfs/extent_io.h
Auto-merging fs/btrfs/extent_io.c
Auto-merging fs/btrfs/extent-tree.c
CONFLICT (content): Merge conflict in fs/btrfs/extent-tree.c
Auto-merging fs/btrfs/ctree.c
Automatic merge failed; fix conflicts and then commit the result.

-- 
-=[dave]=-

Entropy isn't what it used to be.
--nextPart7838550.CoH0lqvTBL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iF4EABEIAAYFAlF66tEACgkQXM0u5ajNnCiMkgD+NBNjldP4gEDsyVWTiNVwrue8
B0PPw52OV3s3ralikxEBAIlETKInSrqQ1faAJgKjg/IT51DElgrxa5AsTrMmFBRR
=Yf2D
-----END PGP SIGNATURE-----

--nextPart7838550.CoH0lqvTBL--

