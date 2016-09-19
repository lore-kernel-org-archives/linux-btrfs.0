Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35472 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S932536AbcISSQB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 14:16:01 -0400
Date: Mon, 19 Sep 2016 14:08:06 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160919180805.GG21290@hungrycats.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard>
 <nrg4mh$bkn$1@blaine.gmane.org>
 <20160917043829.GC21290@hungrycats.org>
 <nrioas$da6$1@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7lMq7vMTJT4tNk0a"
In-Reply-To: <nrioas$da6$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7lMq7vMTJT4tNk0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 17, 2016 at 06:37:16AM +0000, Alex Elsayed wrote:
> > Encryption in ext4 is a per-directory-tree affair. One starts by
> > setting an encryption policy (using an ioctl() call) for a given
> > directory, which must be empty at the time; that policy includes a
> > master key used for all files and directories stored below the target
> > directory. Each individual file is encrypted with its own key, which is
> > derived from the master key and a per-file random nonce value (which is
> > stored in an extended attribute attached to the file's inode). File
> > names and symbolic links are also encrypted.

Probably the simplest way to map this to btrfs is to move the nonce from
the inode to the extent.

Inodes aren't unique within a btrfs filesystem, extents can be shared
by multiple inodes, and a single extent can appear multiple times in the
same inode at different offsets.  Attaching the nonce to the inode would
not be sufficient to read the extent in all but the special case of a
single reference at the original offset where it was written, and it
also leads to the replay problems with duplicate inodes you pointed out.

Extents in a btrfs filesystem are unique and carry their own attributes
(e.g. compression format, checksums) and reference count.  They can easily
carry a reference to an encryption policy object and a nonce attribute.

Nonces within metadata are more complicated.  btrfs doesn't have directory
files like ext4 does, so it doesn't get directory filename encryption
for free with file encryption.  Encryption could be done per-item in the
metadata trees, but in the special case of directories that happen to
the the roots of subvols, it would be possible to encrypt entire pages
of metadata at a time (with the caveat that a snapshot would require
shared encryption policy between the origin and snapshot subvols).
This is what makes keys at the subvol root level so attractive.

> So there isn't quite a "subvol key" in the VFS approach - each directory=
=20
> has a key, and there are derived keys for the entries below it. (I'll=20
> note that this framing does not address shared extents _at all_, and=20
> would love to have clarification on that).

Files are modified by creating new extents (using parameters inherited
=66rom the inode to fill in the extent attributes) and updating the inode to
refer to the new extent instead of the old one at the modified offset.
Cloned extents are references to existing extents associated with a
different inode or at a different place within the same inode (if the
extent is not compatible with the destination inode, clone fails with
an error).  A snapshot is an efficient way to clone an entire subvol
tree at once, including all inodes and attributes.

Inode attributes and extent attributes can sometimes conflict, especially
during a clone operation.  Encryption attributes could become one of
these cases (i.e. to prevent an extent from one encryption policy from
being cloned to an inode under a different encryption policy).

> > I don't see how snapshots could work, writable or otherwise, without
> > separating the key identity from the subvol identity and having a
> > many-to-one relationship between subvols and keys.  The extents in each
> > subvol would be shared, and they'd be encrypted with a single secret,
> > so there's not really another way to do this.
>=20
> That's not the issue. The issue is that, assuming the key stays the same,=
=20
> then a user could quite possibly create a snapshot, write into both the=
=20
> original and the snapshot, causing encryption to occur twice with the=20
> same key, same nonce, and different data.

If the extents have nonces (and inodes do not) then this doesn't happen.
A write to either snapshot necessarily creates new extents in all cases
(the nodatacow feature, the only way to modify a data extent in-place,
is disabled when the extent is shared).


--7lMq7vMTJT4tNk0a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgKYUACgkQgfmLGlazG5ysdACeLabZvWYSb9Stpc5HnSay+hSH
3IgAn3KRVVtBeyxWvft+GFV0GKXQjd2D
=anX/
-----END PGP SIGNATURE-----

--7lMq7vMTJT4tNk0a--
