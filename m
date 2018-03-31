Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43240 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750776AbeCaFDp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 01:03:45 -0400
Date: Sat, 31 Mar 2018 01:03:45 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: kreijack@inwind.it
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Status of RAID5/6
Message-ID: <20180331050345.GE2446@hungrycats.org>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
In-Reply-To: <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 30, 2018 at 06:14:52PM +0200, Goffredo Baroncelli wrote:
> On 03/29/2018 11:50 PM, Zygo Blaxell wrote:
> > On Wed, Mar 21, 2018 at 09:02:36PM +0100, Christoph Anton Mitterer wrot=
e:
> >> Hey.
> >>
> >> Some things would IMO be nice to get done/clarified (i.e. documented in
> >> the Wiki and manpages) from users'/admin's  POV:
> [...]
> >=20
> > btrfs has no optimization like mdadm write-intent bitmaps; recovery
> > is always a full-device operation.  In theory btrfs could track
> > modifications at the chunk level but this isn't even specified in the
> > on-disk format, much less implemented.
>=20
> It could go even further; it would be sufficient to track which
> *partial* stripes update will be performed before a commit, in one
> of the btrfs logs. Then in case of a mount of an unclean filesystem,
> a scrub on these stripes would be sufficient.

A scrub cannot fix a raid56 write hole--the data is already lost.
The damaged stripe updates must be replayed from the log.

A scrub could fix raid1/raid10 partial updates but only if the filesystem
can reliably track which blocks failed to be updated by the disconnected
disks.

It would be nice if scrub could be filtered the same way balance is, e.g.
only certain block ranges, or only metadata blocks; however, this is not
presently implemented.

> BR
> G.Baroncelli
>=20
> [...]
>=20
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWr8WqAAKCRCB+YsaVrMb
nOk4AJ47UT2Mfc7d6rwcvPkEvVFPpNP5dwCg6ZdHShC54Vcrd4ISv29fEj7vjBc=
=saJ/
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
