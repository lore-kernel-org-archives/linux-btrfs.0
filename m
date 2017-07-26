Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39727 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751034AbdGZN2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 09:28:41 -0400
Date: Wed, 26 Jul 2017 15:27:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
Message-ID: <20170726132721.GF2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
 <20170724142508.GW2866@twin.jikos.cz>
 <25d92d3d-52a8-8763-0936-c891d903c588@fb.com>
 <20170724184135.GA2866@twin.jikos.cz>
 <f4b9d041-6c07-fc31-91d2-b4f2f034df61@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f4b9d041-6c07-fc31-91d2-b4f2f034df61@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 02:53:52PM -0400, Chris Mason wrote:
> On 07/24/2017 02:41 PM, David Sterba wrote:
> > On Mon, Jul 24, 2017 at 02:01:07PM -0400, Chris Mason wrote:
> >> On 07/24/2017 10:25 AM, David Sterba wrote:
> >>
> >>> Thanks for the extensive historical summary, this change really deserves
> >>> it.
> >>>
> >>> Decoupling the assumptions about the device's block management is really
> >>> a good thing, mount option 'ssd' should mean that the device just has
> >>> cheap seeks. Moving the the allocation tweaks to ssd_spread provides a
> >>> way to keep the behaviour for anybody who wants it.
> >>>
> >>> I'd like to push this change to 4.13-rc3, as I don't think we need more
> >>> time to let other users to test this. The effects of current ssd
> >>> implementation have been debated and debugged on IRC for a long time.
> >>
> >> The description is great, but I'd love to see many more benchmarks.  At
> >> Facebook we use the current ssd_spread mode in production on top of
> >> hardware raid5/6 (spinning storage) because it dramatically reduces the
> >> read/modify/write cycles done for metadata writes.
> > 
> > Well, I think this is an example that ssd got misused because of the
> > side effects of the allocation. If you observe good patterns for raid5,
> > then the allocator should be adapted for that case, otherwise
> > ssd/ssd_spread should be independent of the raid level.
> 
> Absolutely.  The optimizations that made ssd_spread useful for first 
> generation flash are the same things that raid5/6 need.  Big writes, or 
> said differently a minimum size for fast writes.

Actually, you can do the alignments if the block group is raid56
automatically, and don't rely on ssd_spread. This should be equivalent
in function, but a bit cleaner from the code and interface side.

> >> If we're going to play around with these, we need a good way to measure
> >> free space fragmentation as part of benchmarks, as well as the IO
> >> patterns coming out of the allocator.
> > 
> > Hans has a tool that visualizes the fragmentation. Most complaints I've
> > seen were about 'ssd' itself, excessive fragmentation, early ENOSPC. Not
> > many people use ssd_spread, 'ssd' gets turned on automatically so it has
> > much wider impact.
> > 
> >> At least for our uses, ssd_spread matters much more for metadata than
> >> data (the data writes are large and metadata is small).
> > 
> >  From the changes overview:
> > 
> >> 1. Throw out the current ssd_spread behaviour.
> > 
> > would it be ok for you to keep ssd_working as before?
> > 
> > I'd really like to get this patch merged soon because "do not use ssd
> > mode for ssd" has started to be the recommended workaround. Once this
> > sticks, we won't need to have any ssd mode anymore ...
> 
> Works for me.  I do want to make sure that commits in this area include 
> the workload they were targeting, how they were measured and what 
> impacts they had.  That way when we go back to try and change this again 
> we'll understand what profiles we want to preserve.

So there are at least two ways how to look at the change:

performance - ssd + alignments gives better results under some
conditions, especially when there's enough space, rough summary of my
recent measurements with dbench, mailserver workload, fio jobs with
random readwrite

early ENOSPC (user experience) - ie. when a fragmented filesystem, can't
statisfy allocation due to the constraints, although it would be
possible without the alignments; an aged filesystem, near-full

The target here is not a particular workload or profile, but the
behaviour in the near-full conditions, on a filesystem that's likely
fragmented and aged, mixed workload. The patch should fix it in a way
that will make it work at all. There will be some performance impact,
hard to measure or predict under the conditions.

The reports where nossd fixed the ENOSPC problem IMO validate the
change. We don't have performance characteristics attached to them, but
I think that's not relevant to compare if a 'balance finished in a few
hours' compared to 'balance failed too early, what next'.

Technically, this is an ENOSPC fix, and it took quite some time to
identify the cause.
