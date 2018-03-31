Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40244 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751460AbeCaHnX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 03:43:23 -0400
Date: Sat, 31 Mar 2018 03:43:22 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Status of RAID5/6
Message-ID: <20180331074320.GF2446@hungrycats.org>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
 <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gdTfX7fkYsEEjebm"
In-Reply-To: <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 31, 2018 at 08:57:18AM +0200, Goffredo Baroncelli wrote:
> On 03/31/2018 07:03 AM, Zygo Blaxell wrote:
> >>> btrfs has no optimization like mdadm write-intent bitmaps; recovery
> >>> is always a full-device operation.  In theory btrfs could track
> >>> modifications at the chunk level but this isn't even specified in the
> >>> on-disk format, much less implemented.
> >> It could go even further; it would be sufficient to track which
> >> *partial* stripes update will be performed before a commit, in one
> >> of the btrfs logs. Then in case of a mount of an unclean filesystem,
> >> a scrub on these stripes would be sufficient.
>=20
> > A scrub cannot fix a raid56 write hole--the data is already lost.
> > The damaged stripe updates must be replayed from the log.
>=20
> Your statement is correct, but you doesn't consider the COW nature of btr=
fs.
>=20
> The key is that if a data write is interrupted, all the transaction
> is interrupted and aborted. And due to the COW nature of btrfs, the
> "old state" is restored at the next reboot.

This is not presently true with raid56 and btrfs.  RAID56 on btrfs uses
RMW operations which are not COW and don't provide any data integrity
guarantee.  Old data (i.e. data from very old transactions that are not
part of the currently written transaction) can be destroyed by this.

> What is needed in any case is rebuild of parity to avoid the
> "write-hole" bug. And this is needed only for a partial stripe
> write. For a full stripe write, due to the fact that the commit is
> not flushed, it is not needed the scrub at all.
>=20
> Of course for the NODATACOW file this is not entirely true; but I
> don't see the gain to switch from the cost of COW to the cost of a log.
>=20
> The above sentences are correct (IMHO) if we don't consider a power
> failure+device missing case. However in this case even logging the
> "new data" would be not sufficient.
>=20
> BR
> G.Baroncelli
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--gdTfX7fkYsEEjebm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWr88FQAKCRCB+YsaVrMb
nEHgAKDdL1B5iCfZT7zINvfIwhVs9btnGgCeKsuNvQKKZ1k67AaAlH16axR2+mc=
=JHMB
-----END PGP SIGNATURE-----

--gdTfX7fkYsEEjebm--
