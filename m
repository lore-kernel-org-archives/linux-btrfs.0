Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36122 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2GCPIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 11:08:44 -0400
Date: Tue, 3 Jul 2012 11:08:41 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: NeilBrown <neilb@suse.de>
CC: Kerin Millar <kerframil@gmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: raid10 make_request failure during iozone benchmark upon btrfs
Message-ID: <20120703150841.GE14928@shiny>
References: <4FF108A8.6090606@gmail.com>
 <20120702125227.179c4343@notabene.brown>
 <4FF10E71.2090501@gmail.com>
 <20120703113943.3e4c43ad@notabene.brown>
 <4FF2554D.2040300@gmail.com>
 <20120703124727.6e2232d1@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120703124727.6e2232d1@notabene.brown>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2012 at 08:47:27PM -0600, NeilBrown wrote:
> Thanks.  Looks like it is a btrfs bug - so a big "hello" to linux-btrfs :-)
> 
> The symptom is that iozone on btrfs on md/raid10 can result in
> 
> [  919.893454] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653500160 256
> [  919.893465] btrfs: bdev /dev/mapper/vg0-test errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> 
> 
> i.e. RAID10 has a 256K chunk size, but is getting 256K requests which overlap
> two chunks - the last half of one chunk and the first half of the next.
> That isn't allowed and raid10_mergeable_bvec, called by bio_add_page, should
> prevent it.
> 
> However btrfs_map_bio() sets ->bi_sector to a new value without verifying
> that the resulting bio is still acceptable - which it isn't.
> 
> The core problem is that you cannot build a bio for one location, then use it
> freely at another location.
> md/raid1 handles this by checking each addition to a bio against all the
> possible location that it might read/write it.  Maybe btrfs could do the
> same.
> Alternately we could work with Kent Overstreet (of bcache fame) to remove the
> restriction that the fs must make the bio compatible with the device -
> instead requiring the device to split bios when needed, and making it easy to
> do that (currently it is not easy).
> And there are probably other alternative.

In this case btrfs should really break the bio down to smaller chunks
and hand feed the lower layers.  There are corners where we think the
device can go a certain size and then later on figure out we were just
too optimistic.  So we should deal with it by breaking the bio up and
then lowering our max.

-chris

