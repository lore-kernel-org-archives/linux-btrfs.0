Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35375 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab3GWPGY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 11:06:24 -0400
Date: Tue, 23 Jul 2013 16:06:20 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jerome Haltom <wasabi@cogito.cx>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Q: Why subvolumes?
Message-ID: <20130723150620.GG20517@carfax.org.uk>
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L+ofChggJdETEG3Y"
In-Reply-To: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--L+ofChggJdETEG3Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 06:59:35AM -0500, Jerome Haltom wrote:
> May I ask why the decision to implement snapshotting through
> subvolumes? I've been very curious about why the design wasn't to
> simply allow snapshotting of any directory or file.

   tl;dr: It just doesn't work that way, and it's hard to do so within
the bounds of snapshots being atomic.

   It's down to the way that snapshots are implemented (btrfs being a
copy-on-write filesystem). A snapshot is an (atomic) copy of the FS
tree for a subvolume, where the FS tree is the metadata tree which
holds the inode information, filenames, directory structure,
permissions and so forth. Being a CoW FS, we can do this easily and
trivially by copying only the root block of the tree -- a matter of a
few KiB. Running ls -R on a snapshot and its original will read
exactly the same blocks on the disk, except for the single top-level
block in each case. As the snapshot is modified, the metadata changes,
and parts of the FS tree for the snapshot are CoWed, leaving the
original blocks in place. There is a reference-counting mechanism here
as well, to ensure that we don't leave unused blocks lying around the
place.

   Now... since the snapshot's FS tree is a direct duplicate of the
original FS tree (actually, it's the same tree, but they look like
different things to the outside world), they share everything --
including things like inode numbers. This is OK within a subvolume,
because we have the semantics that subvolumes have their own distinct
inode-number spaces. If we could snapshot arbitrary subsections of the
FS, we'd end up having to fix up inode numbers to ensure that they
were unique -- which can't really be an atomic operation (unless you
want to have the FS locked while the kernel updates the inodes of the
billion files you just snapshotted).

   The other thing to talk about here is that while the FS tree is a
tree structure, it's not a direct one-to-one map to the directory tree
structure. In fact, it looks more like a list of inodes, in inode
order, with some extra info for easily tracking through the list. The
B-tree structure of the FS tree is just a fast indexing method. So
snapshotting a directory entry within the FS tree would require
(somehow) making an atomic copy, or CoW copy, of only the parts of the
FS tree that fall under the directory in question -- so you'd end up
trying to take a sequence of records in the FS tree, of arbitrary size
(proportional roughly to the number of entries in the directory) and
copying them to somewhere else in the same tree in such a way that you
can automatically dereference the copies when you modify them. So,
ultimately, it boils down to being able to do CoW operations at the
byte level, which is going to introduce huge quantities of extra
metadata, and it all starts looking really awkward to implement (plus
having to deal with the long time taken to copy the directory entries
for the thing you're snapshotting).

   I doubt it would be possible to retrofit btrfs to do it without
more or less a ground-up rewrite, if even then. I would further doubt
that you'd end up with something that would run with any kind of
acceptable performance, or with sane bounds on the amount of metadata
used.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am but mad north-north-west:  when the wind is southerly, I ---  
                       know a hawk from a handsaw.                       

--L+ofChggJdETEG3Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUe6b7FheFHXiqx3kAQIfxg/9ELTbyWN257oEvGVLNVSacYTP5BR5sSMT
lBqXumvI55kuOUkB1l2FcvpDp0WUbgntucCluuRdjppCQkXNzws1q2TKivYynG9j
oJhV4+9vmyiTt70B0JPD4rucW7i1FJ38Qmn0+dWF01Vy9BSpVlSkxq9MpRwqUKXC
mshIRFhMNH7ivjen1xUTYviet8xL3uk+6eEi7smYwn2EFZ+cVbsrcxY7UXuaW03+
2AiETb8gzTS+STreImzuYrkSPbue5FOW/D4Ph9/AbKKn843PaL+byTtGk/a3pjMP
jtb4oyvx+2qvNOL64nQfUSlxQ9pNBUEtDL37EStpDJOcCwWw3tb/wJaze6HVKXHB
WKkf5IzjA4dgTRqRhU81fiiFzFL2eI56rDEqqbjic63tiLL7hApkbufHyTfduT/0
2EaINtqxdfaMYX6fH2vijvQLo16lQzvWQYVpymRNhj9imI801UdwiC5J7A/klIWS
y/+UJzzR3+ecUGdfd7i4Nnah7E4+Li8Q5MpPwH8rKOL4JgW4eEHAPZtORb1fQ+8L
cD7c4Rcstrnyrmu9mJZMhsfXwuZ1M89oi4CGCN7MY8lTOoPUPSkkxD7aISjy6a5w
8dvNIK6Fk6a8vtcVrwG/cSQ4IU2wcb78ps6XO2gtROmsyhzgQKa0a93E2osYNzuZ
pr/LR/EfYYM=
=MzN0
-----END PGP SIGNATURE-----

--L+ofChggJdETEG3Y--
