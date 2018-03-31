Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35884 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752501AbeCaOkk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 10:40:40 -0400
Date: Sat, 31 Mar 2018 10:40:38 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: kreijack@inwind.it, Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Status of RAID5/6
Message-ID: <20180331144020.GG2446@hungrycats.org>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
 <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
 <20180331074320.GF2446@hungrycats.org>
 <b3214c3e-cf0c-4070-acbb-892a449476f8@inwind.it>
 <28a574db-0f74-b12c-ab5f-400205fd80c8@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
In-Reply-To: <28a574db-0f74-b12c-ab5f-400205fd80c8@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 31, 2018 at 11:36:50AM +0300, Andrei Borzenkov wrote:
> 31.03.2018 11:16, Goffredo Baroncelli =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On 03/31/2018 09:43 AM, Zygo Blaxell wrote:
> >>> The key is that if a data write is interrupted, all the transaction
> >>> is interrupted and aborted. And due to the COW nature of btrfs, the
> >>> "old state" is restored at the next reboot.
> >=20
> >> This is not presently true with raid56 and btrfs.  RAID56 on btrfs uses
> >> RMW operations which are not COW and don't provide any data integrity
> >> guarantee.  Old data (i.e. data from very old transactions that are not
> >> part of the currently written transaction) can be destroyed by this.
> >=20
> > Could you elaborate a bit ?
> >=20
> > Generally speaking, updating a part of a stripe require a RMW cycle, be=
cause
> > - you need to read all data stripe (with parity in case of a problem)
> > - then you should write
> > 	- the new data
> > 	- the new parity (calculated on the basis of the first read, and the n=
ew data)
> >=20
> > However the "old" data should be untouched; or you are saying that the =
"old" data is rewritten with the same data ?=20
> >=20
>=20
> If old data block becomes unavailable, it can no more be reconstructed
> because old content of "new data" and "new priority" blocks are lost.
> Fortunately if checksum is in use it does not cause silent data
> corruption but it effectively means data loss.
>=20
> Writing of data belonging to unrelated transaction affects previous
> transactions precisely due to RMW cycle. This fundamentally violates
> btrfs claim of always having either old or new consistent state.

Correct.

To fix this, any RMW stripe update on raid56 has to be written to a
log first.  All RMW updates must be logged because a disk failure could
happen at any time.

Full stripe writes don't need to be logged because all the data in the
stripe belongs to the same transaction, so if a disk fails the entire
stripe is either committed or it is not.

One way to avoid the logging is to change the btrfs allocation parameters
so that the filesystem doesn't allocate data in RAID stripes that are
already occupied by data from older transactions.  This is similar to
what 'ssd_spread' does, although the ssd_spread option wasn't designed
for this and won't be effective on large arrays.  This avoids modifying
stripes that contain old committed data, but it also means the free space
on the filesystem will become heavily fragmented over time.  Users will
have to run balance *much* more often to defragment the free space.


--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWr+dzwAKCRCB+YsaVrMb
nMcqAKC2uxAt0sNboNWdLe87b/bhlYMEFgCdFVGbcPurHOR/haZhJN1t/qsiVXM=
=FgBT
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
