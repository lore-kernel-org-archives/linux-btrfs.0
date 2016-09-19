Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41738 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932516AbcISWWM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 18:22:12 -0400
Date: Mon, 19 Sep 2016 18:22:09 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160919222209.GJ21290@hungrycats.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard>
 <nrg4mh$bkn$1@blaine.gmane.org>
 <20160917043829.GC21290@hungrycats.org>
 <nrioas$da6$1@blaine.gmane.org>
 <20160919180805.GG21290@hungrycats.org>
 <nrpg62$g72$2@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CxDuMX1Cv2n9FQfo"
In-Reply-To: <nrpg62$g72$2@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CxDuMX1Cv2n9FQfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 08:01:06PM +0000, Alex Elsayed wrote:
> >> > I don't see how snapshots could work, writable or otherwise, without
> >> > separating the key identity from the subvol identity and having a
> >> > many-to-one relationship between subvols and keys.  The extents in
> >> > each subvol would be shared, and they'd be encrypted with a single
> >> > secret, so there's not really another way to do this.
> >>=20
> >> That's not the issue. The issue is that, assuming the key stays the
> >> same,
> >> then a user could quite possibly create a snapshot, write into both the
> >> original and the snapshot, causing encryption to occur twice with the
> >> same key, same nonce, and different data.
> >=20
> > If the extents have nonces (and inodes do not) then this doesn't happen.
> > A write to either snapshot necessarily creates new extents in all cases
> > (the nodatacow feature, the only way to modify a data extent in-place,
> > is disabled when the extent is shared).
>=20
> As above, note that if encryption is applied to extents rather than=20
> blocks, nodatacow becomes a data loss vector (partial write -> AEAD=20
> verify failure).

nodatacow is already a data loss vector.  There is already no atomic
update guarantee and no checksums (not even CRC32) on nodatacow extents.
Silent data corruption is an expected outcome.

They are supposed to be used for applications where performance needs
trump data integrity needs on specific files (presumably applications
that provide their own checking or can reconstruct the data).

They could support an unauthenticated dm-crypt-style block level
encryption...if we like writing long security manual pages full of
caveats that nobody ever reads.  It's certainly safer to just prohibit
the combination of nodatacow and encryption.

Someone could implement metadata logging/journalling to make nodatacow
work with checksums, which would make AEAD work with them, but the
overhead would probably negate the performance benefit that makes
nodatacow attractive in the first place.


--CxDuMX1Cv2n9FQfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgZREACgkQgfmLGlazG5xYIgCgh3Al5x+9/fWnIfpj60riqCZe
jA8AoJJGSGjzJY3R2VhVPfBl49P5S19E
=8FPF
-----END PGP SIGNATURE-----

--CxDuMX1Cv2n9FQfo--
