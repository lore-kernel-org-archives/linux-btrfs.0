Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35510 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751050AbcIQEig (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 00:38:36 -0400
Date: Sat, 17 Sep 2016 00:38:30 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160917043829.GC21290@hungrycats.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard>
 <nrg4mh$bkn$1@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
In-Reply-To: <nrg4mh$bkn$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2016 at 06:49:53AM +0000, Alex Elsayed wrote:
> The main issue I see is that subvolumes as btrfs has them _do_ introduce=
=20
> novel concerns - in particular, how should snapshots interact with keying=
=20
> (and nonces)? None of the AEADs currently in the kernel are nonce-misuse=
=20
> resistant, which means that if different data is encrypted under the same=
=20
> key and nonce, things go _very_ badly wrong. With writable snapshots, I'd=
=20
> consider that a nontrivial risk.

Snapshots should copy subvolume keys (or key UUIDs, since the keys aren't
stored in the filesystem), i.e. an ioctl could say "create a new subvol
'foo' with the same key as existing subvol 'bar'".  This could also
handle nested subvols (child copies key of parent) if the nested
subvols weren't created with their own separate keys.  For snapshots,
we wouldn't even ask--the snapshot and its origin subvol would share a
key unconditionally. (*)

I don't see how snapshots could work, writable or otherwise, without
separating the key identity from the subvol identity and having a
many-to-one relationship between subvols and keys.  The extents in each
subvol would be shared, and they'd be encrypted with a single secret,
so there's not really another way to do this.

If the key is immutable (which it probably is, given that it's used to
encrypt at the extent level, and extents are (mostly) immutable) then just
giving each subvol a copy of the key ID is sufficient.

(*) OK, we could ask, but if the answer was "no, please do not use the
origin subvol's key", then btrfs would return EINVAL and not create
the snapshot, since there would be no way to read any data contained
within it without the key.

> > Indeed, with the generic file encryption, btrfs may not even need the
> > special subvolume encryption pixies. i.e. you can effectively implement
> > subvolume encryption via configuration of a multi-user encryption key
> > for each subvolume and apply it to the subvolume tree root at creation
> > time. Then only users with permission to unlock the subvolume key can
> > access it.

Life is pretty easy when we're only encrypting data extents.

Encrypted subvol trees cause quite a few problems for btrfs when it needs
to relocate extents (e.g. to shrink a filesystem or change RAID profile)
or validate data integrity.  Ideally it would still be able to do these
operations without decrypting the data; otherwise, there are bad cases,
e.g. if a disk fails, all of the subvolumes would have to be unlocked
in order to replace a disk.

Still, there could be a half way point here.  If btrfs could tie
block groups to subvol encryption keys, it could arrange for all of
the extents in a metadata block group to use the same encryption key.
Then it would be possible to relocate the entire metadata block group
without decrypting its contents.  It would only be necessary to copy
the block group's encrypted data, then update the virtual-to-physical
address mappings in the chunk tree.  Something would have to be done
about checksums during the copy but that's a larger question (are there
two sets of checksums, one authenticated for the encrypted data, and
the crc32 check for device-level data corruption?).

There's also a nasty problem with the extent tree--there's only one per
filesystem, it's shared between all subvols and block groups, and every
extent in that tree has back references to the (possibly encrypted) subvol
trees.  I'll leave that problem as an exercise for other readers.  ;)


--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfcyMUACgkQgfmLGlazG5xoWACeM6s1gIGEyf+oxQwvAYm+C/KG
sbMAnRCvVbcG0R0HOm/9S+isga0/mWZF
=PwAi
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
