Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38452 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752293AbcITBKK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 21:10:10 -0400
Date: Mon, 19 Sep 2016 21:10:08 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Alex Elsayed <eternaleye@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160920011008.GL21290@hungrycats.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard>
 <nrg4mh$bkn$1@blaine.gmane.org>
 <20160917043829.GC21290@hungrycats.org>
 <nrioas$da6$1@blaine.gmane.org>
 <20160919180805.GG21290@hungrycats.org>
 <nrpg62$g72$2@blaine.gmane.org>
 <CAJCQCtR=6_cLa_f2BdcfhkfWGB_4kHSG-JfFh4w+40R7zOMtWQ@mail.gmail.com>
 <20160919223119.GK21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+svXpSx+RSEd8UhP"
In-Reply-To: <20160919223119.GK21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+svXpSx+RSEd8UhP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 06:31:22PM -0400, Zygo Blaxell wrote:
> On Mon, Sep 19, 2016 at 04:25:55PM -0600, Chris Murphy wrote:
> > >> Files are modified by creating new extents (using parameters inherit=
ed
> > >> from the inode to fill in the extent attributes) and updating the in=
ode
> > >> to refer to the new extent instead of the old one at the modified
> > >> offset. Cloned extents are references to existing extents associated
> > >> with a different inode or at a different place within the same inode=
 (if
> > >> the extent is not compatible with the destination inode, clone fails
> > >> with an error).  A snapshot is an efficient way to clone an entire
> > >> subvol tree at once, including all inodes and attributes.
> > >
> > > There is the caveat of chattr +C, which would need hard-disabled for
> > > extent-level encryption (vs block level).
> >=20
> > What about raid56 partial stripe writes? Aren't these effectively nocow?
>=20
> Those are a straight-up bug that should be fixed.  They are mixing commit=
ted
> data with uncommitted data from two different transactions, and the stripe
> temporarily contains garbage.  Combine that with unclean shutdown in degr=
aded
> mode and the data is gone.

A slightly more detailed answer:

nocow and raid56 partial stripe writes are different because nocow writes
won't corrupt unrelated extents, while raid56 partial stripe writes will.
They are entirely different classes of problem.

Even in non-degraded mode, an interrupted write to a modified stripe
is not recoverable from parity until after the parity is reconstructed
(e.g. by scrub or a later write to the stripe in non-degraded mode).

If one of the disks is significantly slower or has deeper queues than
the others, this could affect many extents, as btrfs could submit a
lot of writes to each disk and then wait for all the disks to finish
asynchronously, leaving a large time window for interruption.

If a disk fails after an unclean shutdown but before a scrub is complete,
data in all of the uncorrected stripes will be lost.  If the array enters
or is already in degraded mode during a write when an unclean shutdown
occurs, data will be lost immediately.

Users who don't scrub immediately after unclean shutdowns are sitting on
a ticking time bomb of corruption that explodes when a disk fails.

If this happens to data extents, only file data is lost.  If it happens
to metadata extents, the filesystem is severely damaged or destroyed
(more likely destroyed as the roots of the metadata trees are usually
the most recently written blocks).

mdadm avoids this by scrubbing immediately after an unclean shutdown
to minimize the vulnerable window (or using the new stripe journalling
feature), but it fails (causing severe filesystem damage) when there
are crashes in degraded mode.  ZFS avoids this using a combination of
dynamic stripe width to avoid failed devices and the ZIL journal.

The best thing to do is rework the raid56 layer (and probably some
higher layers in btrfs) until there are no further references to
raid56_rmw_stripe or async_rmw_stripe, then remove those functions and
never put them back.


--+svXpSx+RSEd8UhP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgjHAACgkQgfmLGlazG5z0cQCfQL5ZtbiUBTFLcMrZtYO/pyaz
WbMAoL+60rlL4RDuGB2lADroB4IK0fiQ
=z7Ax
-----END PGP SIGNATURE-----

--+svXpSx+RSEd8UhP--
