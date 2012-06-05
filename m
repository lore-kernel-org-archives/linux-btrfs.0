Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43151 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2FETJ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 15:09:29 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.72)
	(envelope-from <hrm@carfax.org.uk>)
	id 1Sbz86-0003oK-Ad
	for linux-btrfs@vger.kernel.org; Tue, 05 Jun 2012 19:09:26 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.77)
	(envelope-from <hrm@carfax.org.uk>)
	id 1Sbz85-0001th-Jj
	for linux-btrfs@vger.kernel.org; Tue, 05 Jun 2012 20:09:21 +0100
Date: Tue, 5 Jun 2012 20:09:21 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: New btrfs-progs integration branch
Message-ID: <20120605190921.GM15986@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2YJj5f1P6Th4nBRw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2YJj5f1P6Th4nBRw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

   I've just pushed out a new integration branch to my git repo. This
is purely bugfix patches -- there are no new features in this issue of
the integration branch. I've got a stack of about a dozen more patches
with new features in them still to go. I'll be working on those
tomorrow. As always, there's minimal testing involved here, but it
does at least compile on my system(*).

   The branch is fetchable with git from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20120=
605

   And viewable in human-readable form at:

http://git.darksatanic.net/cgi/gitweb.cgi?p=3Dbtrfs-progs-unstable.git

   Shortlog is below.

   Hugo.

(*) "I don't care about works-on-my-machine. We are not shipping your
machine!"

----

Akira Fujita (1):
      Btrfs-progs: Fix manual of btrfs command

Chris Samuel (1):
      Fix "set-dafault" typo in cmds-subvolume.c

Csaba T=F3th (1):
      mkfs.btrfs on ARM

Goffredo Baroncelli (1):
      scrub_fs_info( ) file handle leaking

Hubert Kario (2):
      Fix segmentation fault when opening invalid file system
      man: fix btrfs man page formatting

Jan Kara (1):
      mkfs: Handle creation of filesystem larger than the first device

Jim Meyering (5):
      btrfs_scan_one_dir: avoid use-after-free on error path
      mkfs: use strdup in place of strlen,malloc,strcpy sequence
      restore: don't corrupt stack for a zero-length command-line argument
      avoid several strncpy-induced buffer overruns
      mkfs: avoid heap-buffer-read-underrun for zero-length "size" arg

Josef Bacik (3):
      Btrfs-progs: make btrfsck aware of free space inodes
      Btrfs-progs: make btrfs filesystem show <uuid> actually work
      btrfs-progs: enforce block count on all devices in mkfs

Miao Xie (3):
      Btrfs-progs: fix btrfsck's snapshot wrong "unresolved refs"
      Btrfs-progs, btrfs-corrupt-block: fix the wrong usage
      Btrfs-progs, btrfs-map-logical: Fix typo in usage

Phillip Susi (2):
      btrfs-progs: removed extraneous whitespace from mkfs man page
      btrfs-progs: document --rootdir mkfs switch

Sergei Trofimovich (2):
      Makefile: use $(CC) as a compilers instead of $(CC)/gcc
      Makefile: use $(MAKE) instead of hardcoded 'make'

Shawn Bohrer (1):
      btrfs-progs: Update resize documentation

Wang Sheng-Hui (1):
      btrfs-progs: cleanup: remove the redundant BTRFS_CSUM_TYPE_CRC32 macr=
o def

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Great oxymorons of the world, no.  5: Manifesto Promise ---    =20

--2YJj5f1P6Th4nBRw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPzllhIKyzvlFcI40RAjvDAKCAXWG1ONYYEr65J/dtJffACGPtuwCePK9z
ky0zucf5oBYuWXcbWjm20Wc=
=lGFG
-----END PGP SIGNATURE-----

--2YJj5f1P6Th4nBRw--
