Return-Path: <SRS0=OwOL=RT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9A2C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 23:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C8062186A
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 23:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfCPXKc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Mar 2019 19:10:32 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41018 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfCPXKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Mar 2019 19:10:31 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 076F7266BC0; Sat, 16 Mar 2019 19:10:28 -0400 (EDT)
Date:   Sat, 16 Mar 2019 19:10:28 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Hans van Kranenburg <hans@knorrie.org>,
        Jakub =?iso-8859-1?Q?Hus=E1k?= <jakub@husak.pro>,
        linux-btrfs@vger.kernel.org
Subject: Re: Balancing raid5 after adding another disk does not move/use any
 data on it
Message-ID: <20190316231028.GA16664@hungrycats.org>
References: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro>
 <20190315180123.GJ9995@hungrycats.org>
 <3dce71e1-6caa-59ad-1765-6a29c7dd774f@knorrie.org>
 <aa4fc47e-2eee-de11-c73f-00d947f96dbf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <aa4fc47e-2eee-de11-c73f-00d947f96dbf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 16, 2019 at 09:07:17AM +0300, Andrei Borzenkov wrote:
> 15.03.2019 23:31, Hans van Kranenburg =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> ...
> >>
> >>>> If so, shouldn't it be really balancing (spreading) the data among a=
ll
> >>>> the drives to use all the IOPS capacity, even when the raid5 redunda=
ncy
> >>>> constraint is currently satisfied?
> >>
> >> btrfs divides the disks into chunks first, then spreads the data across
> >> the chunks.  The chunk allocation behavior spreads chunks across all t=
he
> >> disks.  When you are adding a disk to raid5, you have to redistribute =
all
> >> the old data across all the disks to get balanced IOPS and space usage,
> >> hence the full balance requirement.
> >>
> >> If you don't do a full balance, it will eventually allocate data on
> >> all disks, but it will run out of space on sdb, sdc, and sde first,
> >> and then be unable to use the remaining 2TB+ on sdd.
> >=20
> > Also, if you have a lot of empty space in the current allocations, btrfs
> > balance has the tendency to first start packing everything together
> > before allocating new (4 disk wide) block groups.
> >=20
> > This is annoying, because it can result in moving the same data multiple
> > times during balance (into empty space of another existing block group,
> > and then when that one has its turn again etc).
> > > So you want to get rid of empty space in existing block groups as soon
> > as possible. btrfs-balance-least-used can do this, (also an example from
> > python-btrfs), by doing them in order of most empty one first.
> >=20
>=20
> But if I understand the above correctly it will still attempt to move
> data in next most empty chunks first. Is there any way to force
> allocation of new chunks? Or, better, force usage of chunks with given
> stripe width as balance target?
>=20
> This thread actually made me wonder - is there any guarantee (or even
> tentative promise) about RAID stripe width from btrfs at all? Is it
> possible that RAID5 degrades to mirror by itself due to unfortunate
> space distribution?

Note that the data layout of RAID5 with 1 data disk, 1 parity disk, and
even parity is identical to RAID1 with 1 data disk and 1 mirror copy.
The two algorithms produce the same data layout with those parameters.
IRC btrfs uses odd parity, so on btrfs the RAID5 parity stripes are
the complement of the data stripes, but they don't need to be:  with
even parity on 2 disks, the data and parity blocks are identical and
interchangeable.

If you have RAID5 with non-equal device sizes, as long as the two largest
disks are the same size, btrfs will adjust the stripe width to match
the disks with free space available, subject to the constraint that the
resulting block group must have enough disks to survive one disk failure.
e.g. for RAID5 with 5 disks, 2x3TB, 2x2TB, 1x1TB, you get three zones:

  -> raid5 fills smallest unallocated spaces first, all drives ->
   3TB AAAAAAAAAABBBBBBBBBBCCCCCCCCCC
   3TB AAAAAAAAAABBBBBBBBBBCCCCCCCCCC
   2TB AAAAAAAAAABBBBBBBBBB
   2TB AAAAAAAAAABBBBBBBBBB
   1TB AAAAAAAAAA

Zone "A" is 5 disks wide, zone "B" is 4 disks wide, and zone "C" is
2 disks wide (each letter represents 100x1GB chunks).  This is not
necessarily how the data is laid out on disk--the btrfs allocator will
store data on disk in some permutation of this order; however, the
total number of chunks in each zone on each disk is as shown.

For -draid5 -mraid1, you can get patterns like this:

  <- raid1 fills largest unallocated spaces first, 2 drives <-
   3TB 5AAAAAAAA4BBBBBBBBB3CCCCCCCC21
   3TB 5AAAAAAAA4BBBBBBBBB3CCCCCCCC21
   2TB 6AAAAAAAADBBBBBBBBBC
   2TB 6AAAAAAAADBBBBBBBBBC
   1TB UAAAAAAAAD

where numbered zones are raid1 metadata chunks, zone "D" is raid5 3 disks
wide, and "U" is the worst-case one unusable 1GB chunk (not to scale)
in arrays with an odd number of disks.  The numbered zones occupy space
that would normally form a full-width raid5 stripe in the zone, so the
last raid5 block groups in each zone are less wide (i.e. the metadata
chunks in the "B" zone make some stripes in the "B" zone space behave
like stripes in "C" zone space).

If the allocations start from empty disks and there are no array reshaping
operations (convert profile, add/delete/resize devices) then the allocator
should allocate all the usable space as efficiently as possible.  In the
-draid5 -mraid1 case, it would be slightly more efficient to allocate all
the metadata in the "C" zone so it doesn't make any narrower stripes in
the "B" and "A" zones.  Typically this is exactly what happens, since
all the "A" and "B" space must be allocated before raid5 can reach the
"C" zone from the left, while all the "C" space must be allocated before
raid1 can reach the "B" zone from the right, and the two allocators only
interact when the filesystem is completely full.

  <- raid1 fills from the right, raid5 from the left <-
   3TB AAAAAAAAAABBBBBBBBBBCCCC654321
   3TB AAAAAAAAAABBBBBBBBBBCCCC654321
   2TB AAAAAAAAAABBBBBBBBBB
   2TB AAAAAAAAAABBBBBBBBBB
   1TB AAAAAAAAAA
  -> they meet somewhere in the middle, no space wasted ->

If all the drives are the same size, then raid5 and raid1 meet
immediately in zone "A":

  <- raid1 fills from the right, raid5 from the left <-
   3TB AAAAAAAAAAAAAAAAAAAAAAAAAAA421
   3TB AAAAAAAAAAAAAAAAAAAAAAAAAAA431
   3TB AAAAAAAAAAAAAAAAAAAAAAAAAAAU32
  -> they meet somewhere in the middle, up to 1GB wasted ->

There used to be a bug (maybe there still is?) where the allocator would
randomly place about 0.1% of chunks on a non-optimal disk (due to a race
condition?).  That can theoretically lose a few GB of space per TB by
shrinking the stripe width on a few block groups, or stealing a mirror
chunk from the largest disk in a raid1 array with multiple disk sizes.
You can get rid of those using the 'stripes' filter for balance--though
only 0.1% of the space is gained or lost this way, so it may not be
worth the IO cost.

If you are converting or reshaping an array, the nice rules above don't
hold any more.  e.g. if we replace a 1TB drive with a 3TB drive, we get
2TB unallocated ("_"):

   3TB AAAAAAAAAABBBBBBBBBBCCCC654321
   3TB AAAAAAAAAABBBBBBBBBBCCCC654321
   2TB AAAAAAAAAABBBBBBBBBB
   2TB AAAAAAAAAABBBBBBBBBB
   3TB AAAAAAAAAA____________________

Now we have no available space because there's no free chunks on two
or more drives (i.e. all the free space is on 1 drive and all the RAID
profiles we are using require 2).  Upgrade another disk, and...

   3TB AAAAAAAAAABBBBBBBBBBCCCC654321
   3TB AAAAAAAAAABBBBBBBBBBCCCC654321
   2TB AAAAAAAAAABBBBBBBBBB
   3TB AAAAAAAAAABBBBBBBBBB__________
   3TB AAAAAAAAAA____________________

Now we have 1TB of free space, in stripes 2 disks wide.  Without a balance,
it would fill up like this:

   3TB AAAAAAAAAABBBBBBBBBBCCCC654321
   3TB AAAAAAAAAABBBBBBBBBBCCCC654321
   2TB AAAAAAAAAABBBBBBBBBB
   3TB AAAAAAAAAABBBBBBBBBBCCCCCCCCCC
   3TB AAAAAAAAAACCCCCCCCCCXXXXXXXXXX
  -> raid5 fills smallest unallocated spaces first on all drives ->

Note the "C" zone here is still stripes 2 disks wide, so a lot of space is
wasted by narrow stripes.  Even the diagram makes it look we did something
wrong--we don't have the nice orderly fill pattern.  1TB is unusable,
and the free space estimated by 'df' was egregiously wrong the whole time.

Full balance fixes that, and we get some unallocated space that is
usable:

  -> raid5 from left to right ->
   3TB AAAAAAAAAAAAAAAAAAA________531
   3TB AAAAAAAAAAAAAAAAAAA________531
   2TB AAAAAAAAAAAAAAAAAAA_
   3TB AAAAAAAAAAAAAAAAAAA________642
   3TB AAAAAAAAAAAAAAAAAAA________642
  <- raid1 from right to left <-

which can then be filled up like this:

   3TB AAAAAAAAAAAAAAAAAAAABBBBBB7531
   3TB AAAAAAAAAAAAAAAAAAAABBBBBB7531
   2TB AAAAAAAAAAAAAAAAAAAA
   3TB AAAAAAAAAAAAAAAAAAAABBBBBBC642
   3TB AAAAAAAAAAAAAAAAAAAABBBBBBC642

By the time our hypothetical filesystem was full, there was another
metadata chunk allocated, so we end up with one 1GB block group in zone
"C" with 2 disks--but at most one.

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXI2CYgAKCRCB+YsaVrMb
nBK3AJ91zttg03LqQGzvjnEuLVxQAOL+ZwCg58u9pm5QFhO81p+w/zxWzDvHg1M=
=K9CQ
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
