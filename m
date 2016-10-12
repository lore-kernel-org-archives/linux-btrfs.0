Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42498 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S932566AbcJLUeT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 16:34:19 -0400
Date: Wed, 12 Oct 2016 16:33:23 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161012203323.GI26140@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <20161012122551.27d949ee@natsu>
 <20161012173141.GX21290@hungrycats.org>
 <20161012191915.GF26140@hungrycats.org>
 <20161013003331.5e33c006@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HuXIgs6JvY9hJs5C"
In-Reply-To: <20161013003331.5e33c006@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HuXIgs6JvY9hJs5C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13, 2016 at 12:33:31AM +0500, Roman Mamedov wrote:
> On Wed, 12 Oct 2016 15:19:16 -0400
> Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
>=20
> > I'm not even sure btrfs does this--I haven't checked precisely what
> > it does in dup mode.  It could send both copies of metadata to the
> > disks with a single barrier to separate both metadata updates from
> > the superblock updates.  That would be bad in this particular case.
>=20
> It would be bad in any case, including a single physical disk and no RAID=
, and

No, a single disk does not have these problems.  On a single disk we don't
have to deal with temporarily corrupted metadata _outside_ the areas we
are writing, as the disk will confine damaged data to individual sectors.
On RAID5, data damage is only limited at the stripe level, a unit orders
of magnitude larger than a sector.

> I don't think there's any basis to speculate that mdadm doesn't implement
> write barriers properly.

btrfs and mdadm have to use them properly together.  It's possible to
get it fatally wrong from the btrfs side even if mdadm does everything
perfectly.  Single disks don't have stripe consistency requirements,
so if btrfs has single-disk assumptions about the behavior of writes
then it can do the wrong thing on multi-disk systems.

> > In degraded RAID5/6 mode, all writes temporarily corrupt data, so if th=
ere
> > is an interruption (system crash, a disk times out, etc) in degraded mo=
de,
>=20
> Moreover, in any non-COW system writes temporarily corrupt data. So again,
> writing to a (degraded or not) mdadm RAID5 is not much different than wri=
ting
> to a single physical disk. However I believe in the Btrfs case metadata is
> always COW, so this particular problem may be not as relevant here in the
> first place.

Degraded RAID5 does not behave like a single disk.  That's the point
people seem to keep missing when thinking about this.  btrfs CoW relies
on single-disk behavior, and fails badly when it doesn't get it.

btrfs CoW requires that writes to one sector don't modify or jeopardize
data integrity in any other sectors.  mdadm in degraded raid5/6 mode with
no stripe journal device cannot deliver this requirement.  Writes always
temporarily disrupt data on other disks in the same RAID stripe.  Each
individual disruption lasts only milliseconds, but there may be hundreds
or thousands of failure windows per second.

>=20
> --=20
> With respect,
> Roman



--HuXIgs6JvY9hJs5C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf+nhMACgkQgfmLGlazG5yNWACfTfjCsDKNx070aaluq04SFCl2
OScAoJjUxlLuizAVLipG8cQIs+qIXN+R
=Tvju
-----END PGP SIGNATURE-----

--HuXIgs6JvY9hJs5C--
