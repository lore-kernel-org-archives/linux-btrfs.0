Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35338 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750995AbcITEJ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 00:09:26 -0400
Date: Tue, 20 Sep 2016 00:09:17 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>, Alex Elsayed <eternaleye@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Experimental btrfs encryption
Message-ID: <20160920040917.GM21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NZtAI5QFBF0GmLcW"
In-Reply-To: <20160920025041.mzeljxxzclikktxn@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20160919151518.i2aon4axmfzt54rn@thunk.org>
 <nrpjhc$g72$3@blaine.gmane.org>
 <a8dc3c28-5629-d870-f202-de35d2f941f1@fb.com>
 <20160920025041.mzeljxxzclikktxn@thunk.org>


--NZtAI5QFBF0GmLcW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 10:50:41PM -0400, Theodore Ts'o wrote:
> On Mon, Sep 19, 2016 at 08:32:34PM -0400, Chris Mason wrote:
> One of the other things that was in the original design, but which got
> dropped in our initial implementation, was the concept of having the
> per-inode key wrapped by multiple user keys.  This would allow a file
> to be accessible by more than one user.  So something to consider is
> that there may very well be situations where you *want* to have more
> than one key associated with a directory hierarchy.

That can get very complicated very quickly, unless you push the keys
off to one side and make them objects with separate lifetimes from the
files and subvols that use them by reference.  Any problem can be made
different by another layer of indirection.

> The main issue is if you want to reflink a file and then have the two
> files have different permissions / ownerships.  In that case, you
> really want to use different keys for user A and for user B --- but if
> you are assuming a single key per subvolume, you can't support
> different keys for different users anyway, so you're kind of toast for
> that use case in any case.

The gotcha there is that reflink file copies are just a special case
of shared extent refs in which all the individual extents in a file are
reflinked at once, but that's not the only case (or even a common one).

Currently any extent in the filesystem can be shared by any inode in
the filesystem (assuming the two inodes have compatible attributes,
which could include encryption policy), including multiple references
=66rom the same inode to the same extent at different logical offsets.
This is the basis of the deduplication and copy_file_range features.

This confuses the VFS caching layer when dealing with deduped reflinked,
or snapshotted files.  It's not surprising that VFS crypto has problems
coping with it as well.

It's much more natural for btrfs to attach nonces to the extents rather
than the inodes, and even put references to keys on the extents as well.
Key references could be inherited from the inode (directory, parent,
subvol, wherever you want to put them) that was used to create the extent,
the same way extents inherit their other attributes from inodes now.

> So in any case, assuming you're using block encryption (which is what
> fscrypt uses) there really isn't a problem with nonce reuse, although
> in some cases if you really do want to reflink a file and have it be
> protected by different user keys, this would have to force copy of the
> duplicated blocks at that point.  But arguably, that is a feature, not
> a bug.  If the two users are mutually suspicious, you don't _want_ to
> leak information about who much of a particular file had been changed
> by a particular user.  So you would want to break the reflink and have
> separate copies for both users anyway.

It would probably be most naturally implemented as not allowing the
reflink in the first place, or not allowing a key change on a non-empty
file (the same way that attributes like nodatasum and nodatacow are
implemented).  'cp' would then have to fall back to a brute-force copy.
Cloning reflinks after the fact would be a radical change of direction
for btrfs.

This does create all sorts of interesting interactions with snapshots.
What happens if you remove a user's key to a file in a snapshot?  If the
key is embedded in an inode, only one snapshot is affected, but if the
key is stored separately by reference, it could revoke access to files
in all the snapshots at once.

The only information I know of that one (non-root) user gets about
modifications to the other user's reflink file is the SHARED bit in
FIEMAP, which goes from 1 to 0 when the user holds the last reference
to the file.  That could simply be forced to always be 1 if the extent
is encrypted so it doesn't leak information.


--NZtAI5QFBF0GmLcW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgtmwACgkQgfmLGlazG5wILQCgiYPAKH+gxXydiossZ0GSf4pi
Hd4An2Rp1FrgnL1jCoZ0ztiSgOrNfzQz
=b8Ye
-----END PGP SIGNATURE-----

--NZtAI5QFBF0GmLcW--
