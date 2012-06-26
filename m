Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56889 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2FZJ6U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 05:58:20 -0400
Date: Tue, 26 Jun 2012 10:58:17 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: New btrfs-progs integration branch
Message-ID: <20120626095816.GH25572@carfax.org.uk>
References: <20120605190921.GM15986@carfax.org.uk>
 <CAHf9xvbTL6DFP_KdpJrphWYTNJOqHgpzi+i44ZGjTg0oBY1V+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Z7/5fzWRHDJ0o7Q"
In-Reply-To: <CAHf9xvbTL6DFP_KdpJrphWYTNJOqHgpzi+i44ZGjTg0oBY1V+w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+Z7/5fzWRHDJ0o7Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 11:58:41AM +0300, Alex Lyakas wrote:
> Hi Hugo,
> forgive me, but I am somewhat confused.
> What is the "main" repo of btrfs-progs, if there is such thing?
> I see patches coming in, but no updates to
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git,
> which I thought was the one.
>=20
> Can you pls clarify where should I pull updates from for btrfs-progs?

   The official source for btrfs-progs is Chris's one, at the URL
above. The integration repo is kind of a staging area where I pull in
as many patches as I can and get them a bit more visibility. We don't
really have a well-defined workflow here.

   It depends on what you intend doing: if you want to make packages
for your distribution, use Chris's repo. If you want something
reasonably stable and tested, use Chris's repo. If there's some
experimental kernel feature you want to test out, use integration. If
you want to be helpful and test out new patches and report problems
with them, use integration.

   Hugo.

> Thanks,
> Alex.
>=20
>=20
>=20
> On Tue, Jun 5, 2012 at 10:09 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > =A0 I've just pushed out a new integration branch to my git repo. This
> > is purely bugfix patches -- there are no new features in this issue of
> > the integration branch. I've got a stack of about a dozen more patches
> > with new features in them still to go. I'll be working on those
> > tomorrow. As always, there's minimal testing involved here, but it
> > does at least compile on my system(*).
> >
> > =A0 The branch is fetchable with git from:
> >
> > http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-2=
0120605
> >
> > =A0 And viewable in human-readable form at:
> >
> > http://git.darksatanic.net/cgi/gitweb.cgi?p=3Dbtrfs-progs-unstable.git
> >
> > =A0 Shortlog is below.
> >
> > =A0 Hugo.
> >
> > (*) "I don't care about works-on-my-machine. We are not shipping your
> > machine!"
> >
> > ----
> >
> > Akira Fujita (1):
> > =A0 =A0 =A0Btrfs-progs: Fix manual of btrfs command
> >
> > Chris Samuel (1):
> > =A0 =A0 =A0Fix "set-dafault" typo in cmds-subvolume.c
> >
> > Csaba T=F3th (1):
> > =A0 =A0 =A0mkfs.btrfs on ARM
> >
> > Goffredo Baroncelli (1):
> > =A0 =A0 =A0scrub_fs_info( ) file handle leaking
> >
> > Hubert Kario (2):
> > =A0 =A0 =A0Fix segmentation fault when opening invalid file system
> > =A0 =A0 =A0man: fix btrfs man page formatting
> >
> > Jan Kara (1):
> > =A0 =A0 =A0mkfs: Handle creation of filesystem larger than the first de=
vice
> >
> > Jim Meyering (5):
> > =A0 =A0 =A0btrfs_scan_one_dir: avoid use-after-free on error path
> > =A0 =A0 =A0mkfs: use strdup in place of strlen,malloc,strcpy sequence
> > =A0 =A0 =A0restore: don't corrupt stack for a zero-length command-line =
argument
> > =A0 =A0 =A0avoid several strncpy-induced buffer overruns
> > =A0 =A0 =A0mkfs: avoid heap-buffer-read-underrun for zero-length "size"=
 arg
> >
> > Josef Bacik (3):
> > =A0 =A0 =A0Btrfs-progs: make btrfsck aware of free space inodes
> > =A0 =A0 =A0Btrfs-progs: make btrfs filesystem show <uuid> actually work
> > =A0 =A0 =A0btrfs-progs: enforce block count on all devices in mkfs
> >
> > Miao Xie (3):
> > =A0 =A0 =A0Btrfs-progs: fix btrfsck's snapshot wrong "unresolved refs"
> > =A0 =A0 =A0Btrfs-progs, btrfs-corrupt-block: fix the wrong usage
> > =A0 =A0 =A0Btrfs-progs, btrfs-map-logical: Fix typo in usage
> >
> > Phillip Susi (2):
> > =A0 =A0 =A0btrfs-progs: removed extraneous whitespace from mkfs man page
> > =A0 =A0 =A0btrfs-progs: document --rootdir mkfs switch
> >
> > Sergei Trofimovich (2):
> > =A0 =A0 =A0Makefile: use $(CC) as a compilers instead of $(CC)/gcc
> > =A0 =A0 =A0Makefile: use $(MAKE) instead of hardcoded 'make'
> >
> > Shawn Bohrer (1):
> > =A0 =A0 =A0btrfs-progs: Update resize documentation
> >
> > Wang Sheng-Hui (1):
> > =A0 =A0 =A0btrfs-progs: cleanup: remove the redundant BTRFS_CSUM_TYPE_C=
RC32 macro def
> >

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---         =20
                         darkness bind(2) them.                         =20

--+Z7/5fzWRHDJ0o7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP6Ye4IKyzvlFcI40RAs7GAJ4wsEC8SwdouNAEGMUCrL2qh5E0dQCeNu4N
z0kJGdhWCt5CLKdrIXmyN6g=
=IxAf
-----END PGP SIGNATURE-----

--+Z7/5fzWRHDJ0o7Q--
