Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47434 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754457AbeDBWXh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Apr 2018 18:23:37 -0400
Date: Mon, 2 Apr 2018 18:23:34 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: kreijack@inwind.it, Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Status of RAID5/6
Message-ID: <20180402222250.GH2446@hungrycats.org>
References: <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
 <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
 <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
 <20180401034544.GA28769@hungrycats.org>
 <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ik0NlRzMGhMnxrMX"
In-Reply-To: <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ik0NlRzMGhMnxrMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 02, 2018 at 11:49:42AM -0400, Austin S. Hemmelgarn wrote:
> On 2018-04-02 11:18, Goffredo Baroncelli wrote:
> > On 04/02/2018 07:45 AM, Zygo Blaxell wrote:
> > [...]
> > > It is possible to combine writes from a single transaction into full
> > > RMW stripes, but this *does* have an impact on fragmentation in btrfs.
> > > Any partially-filled stripe is effectively read-only and the space wi=
thin
> > > it is inaccessible until all data within the stripe is overwritten,
> > > deleted, or relocated by balance.
> > >=20
> > > btrfs could do a mini-balance on one RAID stripe instead of a RMW str=
ipe
> > > update, but that has a significant write magnification effect (and be=
fore
> > > kernel 4.14, non-trivial CPU load as well).
> > >=20
> > > btrfs could also just allocate the full stripe to an extent, but emit
> > > only extent ref items for the blocks that are in use.  No fragmentati=
on
> > > but lots of extra disk space used.  Also doesn't quite work the same
> > > way for metadata pages.
> > >=20
> > > If btrfs adopted the ZFS approach, the extent allocator and all higher
> > > layers of the filesystem would have to know about--and skip over--the
> > > parity blocks embedded inside extents.  Making this change would mean
> > > that some btrfs RAID profiles start interacting with stuff like balan=
ce
> > > and compression which they currently do not.  It would create a new
> > > block group type and require an incompatible on-disk format change for
> > > both reads and writes.
> >=20
> > I thought that a possible solution is to create BG with different
> number of data disks. E.g. supposing to have a raid 6 system with 6
> disks, where 2 are parity disk; we should allocate 3 BG
> >=20
> > BG #1: 1 data disk, 2 parity disks
> > BG #2: 2 data disks, 2 parity disks,
> > BG #3: 4 data disks, 2 parity disks
> >=20
> > For simplicity, the disk-stripe length is assumed =3D 4K.
> >=20
> > So If you have a write with a length of 4 KB, this should be placed
> in BG#1; if you have a write with a length of 4*3KB, the first 8KB,
> should be placed in in BG#2, then in BG#1.
> >=20
> > This would avoid space wasting, even if the fragmentation will
> increase (but shall the fragmentation matters with the modern solid
> state disks ?).

I don't really see why this would increase fragmentation or waste space.
The extent size is determined before allocation anyway, all that changes
in this proposal is where those small extents ultimately land on the disk.

If anything, it might _reduce_ fragmentation since everything in BG #1
and BG #2 will be of uniform size.

It does solve write hole (one transaction per RAID stripe).

> Also, you're still going to be wasting space, it's just that less space w=
ill
> be wasted, and it will be wasted at the chunk level instead of the block
> level, which opens up a whole new set of issues to deal with, most
> significantly that it becomes functionally impossible without brute-force
> search techniques to determine when you will hit the common-case of -ENOS=
PC
> due to being unable to allocate a new chunk.

Hopefully the allocator only keeps one of each size of small block groups
around at a time.  The allocator can take significant short cuts because
the size of every extent in the small block groups is known (they are
all the same size by definition).

When a small block group fills up, the next one should occupy the
most-empty subset of disks--which is the opposite of the usual RAID5/6
allocation policy.  This will probably lead to "interesting" imbalances
since there are now two allocators on the filesystem with different goals
(though it is no worse than -draid5 -mraid1, and I had no problems with
free space when I was running that).

There will be an increase in the amount of allocated but not usable space,
though, because now the amount of free space depends on how much data
is batched up before fsync() or sync().  Probably best to just not count
any space in the small block groups as 'free' in statvfs terms at all.

There are a lot of variables implied there.  Without running some
simulations I have no idea if this is a good idea or not.

> > Time to time, a re-balance should be performed to empty the BG #1,
> and #2. Otherwise a new BG should be allocated.

That shouldn't be _necessary_ (the filesystem should just allocate
whatever BGs it needs), though it will improve storage efficiency if it
is done.

> > The cost should be comparable to the logging/journaling (each
> data shorter than a full-stripe, has to be written two times); the
> implementation should be quite easy, because already NOW btrfs support
> BG with different set of disks.


--ik0NlRzMGhMnxrMX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWsKtNgAKCRCB+YsaVrMb
nFlqAJ4xuYDYupdwxz7wEBVhHcaejV3RMwCbBBr96WGeV+5raukoAsFaBf5jpAU=
=XHy6
-----END PGP SIGNATURE-----

--ik0NlRzMGhMnxrMX--
