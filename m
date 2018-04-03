Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38966 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754406AbeDCW5u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Apr 2018 18:57:50 -0400
Date: Tue, 3 Apr 2018 18:57:46 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Status of RAID5/6
Message-ID: <20180403225742.GJ2446@hungrycats.org>
References: <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
 <20180401034544.GA28769@hungrycats.org>
 <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
 <20180402222250.GH2446@hungrycats.org>
 <20180403003102.GI2446@hungrycats.org>
 <242e2515-fad2-e98d-3e59-c0838362afdc@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nywXBoy70X0GaB8B"
In-Reply-To: <242e2515-fad2-e98d-3e59-c0838362afdc@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nywXBoy70X0GaB8B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 03, 2018 at 07:03:06PM +0200, Goffredo Baroncelli wrote:
> On 04/03/2018 02:31 AM, Zygo Blaxell wrote:
> > On Mon, Apr 02, 2018 at 06:23:34PM -0400, Zygo Blaxell wrote:
> >> On Mon, Apr 02, 2018 at 11:49:42AM -0400, Austin S. Hemmelgarn wrote:
> >>> On 2018-04-02 11:18, Goffredo Baroncelli wrote:
> >>>> I thought that a possible solution is to create BG with different
> >>> number of data disks. E.g. supposing to have a raid 6 system with 6
> >>> disks, where 2 are parity disk; we should allocate 3 BG
> >>>> BG #1: 1 data disk, 2 parity disks
> >>>> BG #2: 2 data disks, 2 parity disks,
> >>>> BG #3: 4 data disks, 2 parity disks
> >>>>
> >>>> For simplicity, the disk-stripe length is assumed =3D 4K.
> >>>>
> >>>> So If you have a write with a length of 4 KB, this should be placed
> >>> in BG#1; if you have a write with a length of 4*3KB, the first 8KB,
> >>> should be placed in in BG#2, then in BG#1.
> >>>> This would avoid space wasting, even if the fragmentation will
> >>> increase (but shall the fragmentation matters with the modern solid
> >>> state disks ?).
> >> I don't really see why this would increase fragmentation or waste spac=
e.
>=20
> > Oh, wait, yes I do.  If there's a write of 6 blocks, we would have
> > to split an extent between BG #3 (the first 4 blocks) and BG #2 (the
> > remaining 2 blocks).  It also flips the usual order of "determine size
> > of extent, then allocate space for it" which might require major surgery
> > on the btrfs allocator to implement.
>=20
> I have to point out that in any case the extent is physically
> interrupted at the disk-stripe size. Assuming disk-stripe=3D64KB, if
> you want to write 128KB, the first half is written in the first disk,
> the other in the 2nd disk.  If you want to write 96kb, the first 64
> are written in the first disk, the last part in the 2nd, only on a
> different BG.

The "only on a different BG" part implies something expensive, either
a seek or a new erase page depending on the hardware.  Without that,
nearby logical blocks are nearby physical blocks as well.

> So yes there is a fragmentation from a logical point of view; from a
> physical point of view the data is spread on the disks in any case.

What matters is the extent-tree point of view.  There is (currently)
no fragmentation there, even for RAID5/6.  The extent tree is unaware
of RAID5/6 (to its peril).

ZFS makes its thing-like-the-extent-tree aware of RAID5/6, and it can
put a stripe of any size anywhere.  If we're going to do that in btrfs,
you might as well just do what ZFS does.

OTOH, variable-size block groups give us read-compatibility with old
kernel versions (and write-compatibility for that matter--a kernel that
didn't know about the BG separation would just work but have write hole).

If an application does a loop writing 68K then fsync(), the multiple-BG
solution adds two seeks to read every 68K.  That's expensive if sequential
read bandwidth is more scarce than free space.

> In any case, you are right, we should gather some data, because the
> performance impact are no so clear.
>=20
> I am not worried abut having different BG; we have problem with these
> because we never developed tool to handle this issue properly (i.e. a
> daemon which starts a balance when needed). But I hope that this will
> be solved in future.

Balance daemons are easy to the point of being trivial to write in Python.

The balancing itself is quite expensive and invasive:  can't usefully
ionice it, can only abort it on block group boundaries, can't delete
snapshots while it's running.

If balance could be given a vrange that was the size of one extent...then
we could talk about daemons.

> In any case, the all solutions proposed have their trade off:
>=20
> - a) as is: write hole bug
> - b) variable stripe size (like ZFS): big impact on how btrfs handle
> the extent. limited waste of space
> - c) logging data before writing: we wrote the data two times in a
> short time window. Moreover the log area is written several order of
> magnitude more than the other area; there was some patch around
> - d) rounding the writing to the stripe size: waste of space; simple
> to implement;
> - e) different BG with different stripe size: limited waste of space;
> logical fragmentation.

Also:

  - f) avoiding writes to partially filled stripes: free space
  fragmentation; simple to implement (ssd_spread does it accidentally)

The difference between d) and f) is that d) allocates the space to the
extent while f) leaves the space unallocated, but skips any free space
fragments smaller than the stripe size when allocating.  f) gets the
space back with a balance (i.e. it is exactly as space-efficient as (a)
after balance).

> * c),d),e) are applied only for the tail of the extent, in case the
size is less than the stripe size.

It's only necessary to split an extent if there are no other writes
in the same transaction that could be combined with the extent tail
into a single RAID stripe.  As long as everything in the RAID stripe
belongs to a single transaction, there is no write hole.

> * for b),d), e), the wasting of space may be reduced with a balance=20

Not for d.  Balance doesn't know how to get rid of unreachable blocks
in extents (it just moves the entire extent around) so after a balance
the writes would still be rounded up to the stripe size.  Balance would
never be able to free the rounded-up space.  That space would just be
gone until the file was overwritten, deleted, or defragged.

Possibly not for b either, for the same reason.  Defrag is the existing
btrfs tool to fix extents with unused space attached to them.  Or some
new thing designed explicitly to handle these cases.

And also not for e, but it's a little different there.  In e the wasted
space is the extra metadata extent refs due to discontiguous extent
allocation.  You don't get that back with balance, you need defrag
here too.  e) also effectively can't claim that unused space in BG's is
"free" since there are non-trivial restrictions on whether it can be
allocated for any given write.  So even if you have free space, 'df'
has to tell you that you don't.

>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--nywXBoy70X0GaB8B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWsQG2wAKCRCB+YsaVrMb
nO8+AJ9bdRuQ11ylJb6XgJtXw4McVPYtvgCfaXO67GMv5XNYimCPWa44uYKuB2U=
=gXDG
-----END PGP SIGNATURE-----

--nywXBoy70X0GaB8B--
