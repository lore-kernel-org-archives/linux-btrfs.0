Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45750 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754604AbeDCAbM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Apr 2018 20:31:12 -0400
Date: Mon, 2 Apr 2018 20:31:11 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: kreijack@inwind.it, Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Status of RAID5/6
Message-ID: <20180403003102.GI2446@hungrycats.org>
References: <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
 <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
 <20180401034544.GA28769@hungrycats.org>
 <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
 <20180402222250.GH2446@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="N8NGGaQn1mzfvaPg"
In-Reply-To: <20180402222250.GH2446@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--N8NGGaQn1mzfvaPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 02, 2018 at 06:23:34PM -0400, Zygo Blaxell wrote:
> On Mon, Apr 02, 2018 at 11:49:42AM -0400, Austin S. Hemmelgarn wrote:
> > On 2018-04-02 11:18, Goffredo Baroncelli wrote:
> > > I thought that a possible solution is to create BG with different
> > number of data disks. E.g. supposing to have a raid 6 system with 6
> > disks, where 2 are parity disk; we should allocate 3 BG
> > >=20
> > > BG #1: 1 data disk, 2 parity disks
> > > BG #2: 2 data disks, 2 parity disks,
> > > BG #3: 4 data disks, 2 parity disks
> > >=20
> > > For simplicity, the disk-stripe length is assumed =3D 4K.
> > >=20
> > > So If you have a write with a length of 4 KB, this should be placed
> > in BG#1; if you have a write with a length of 4*3KB, the first 8KB,
> > should be placed in in BG#2, then in BG#1.
> > >=20
> > > This would avoid space wasting, even if the fragmentation will
> > increase (but shall the fragmentation matters with the modern solid
> > state disks ?).
>=20
> I don't really see why this would increase fragmentation or waste space.

Oh, wait, yes I do.  If there's a write of 6 blocks, we would have
to split an extent between BG #3 (the first 4 blocks) and BG #2 (the
remaining 2 blocks).  It also flips the usual order of "determine size
of extent, then allocate space for it" which might require major surgery
on the btrfs allocator to implement.

If we round that write up to 8 blocks (so we can put both pieces in
BG #3), it degenerates into the "pretend partially filled RAID stripes
are completely full" case, something like what ssd_spread already does.
That trades less file fragmentation for more free space fragmentation.

> The extent size is determined before allocation anyway, all that changes
> in this proposal is where those small extents ultimately land on the disk.
>=20
> If anything, it might _reduce_ fragmentation since everything in BG #1
> and BG #2 will be of uniform size.
>=20
> It does solve write hole (one transaction per RAID stripe).
>=20
> > Also, you're still going to be wasting space, it's just that less space=
 will
> > be wasted, and it will be wasted at the chunk level instead of the block
> > level, which opens up a whole new set of issues to deal with, most
> > significantly that it becomes functionally impossible without brute-for=
ce
> > search techniques to determine when you will hit the common-case of -EN=
OSPC
> > due to being unable to allocate a new chunk.
>=20
> Hopefully the allocator only keeps one of each size of small block groups
> around at a time.  The allocator can take significant short cuts because
> the size of every extent in the small block groups is known (they are
> all the same size by definition).
>=20
> When a small block group fills up, the next one should occupy the
> most-empty subset of disks--which is the opposite of the usual RAID5/6
> allocation policy.  This will probably lead to "interesting" imbalances
> since there are now two allocators on the filesystem with different goals
> (though it is no worse than -draid5 -mraid1, and I had no problems with
> free space when I was running that).
>=20
> There will be an increase in the amount of allocated but not usable space,
> though, because now the amount of free space depends on how much data
> is batched up before fsync() or sync().  Probably best to just not count
> any space in the small block groups as 'free' in statvfs terms at all.
>=20
> There are a lot of variables implied there.  Without running some
> simulations I have no idea if this is a good idea or not.
>=20
> > > Time to time, a re-balance should be performed to empty the BG #1,
> > and #2. Otherwise a new BG should be allocated.
>=20
> That shouldn't be _necessary_ (the filesystem should just allocate
> whatever BGs it needs), though it will improve storage efficiency if it
> is done.
>=20
> > > The cost should be comparable to the logging/journaling (each
> > data shorter than a full-stripe, has to be written two times); the
> > implementation should be quite easy, because already NOW btrfs support
> > BG with different set of disks.
>=20



--N8NGGaQn1mzfvaPg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWsLLNwAKCRCB+YsaVrMb
nFdTAKDkoshPrfXGmQsOBK9yJyn5GVLdDQCZAXPEDjo5mZo2qMLktJBNOC5gZDI=
=un2u
-----END PGP SIGNATURE-----

--N8NGGaQn1mzfvaPg--
