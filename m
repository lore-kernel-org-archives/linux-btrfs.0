From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Balancing leaves when walking from top to down (was Btrfs:...)
Date: Tue, 22 Jun 2010 10:20:06 -0400
Message-ID: <20100622142006.GT23009@think>
References: <4C07C321.8010000@redhat.com>
 <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
 <4C1B7560.1000806@gmail.com>
 <20100618155653.GC10919@shareable.org>
 <4C1BC924.30604@redhat.com>
 <20100618193555.GV27466@think>
 <4C1BED56.9010300@redhat.com>
 <20100621131528.GA17979@think>
 <20100621180013.GD17979@think>
 <4C20C4E9.60203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jamie Lokier <jamie@shareable.org>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C20C4E9.60203@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 22, 2010 at 04:12:57PM +0200, Edward Shishkin wrote:
> Chris Mason wrote:
> >On Mon, Jun 21, 2010 at 09:15:28AM -0400, Chris Mason wrote:
> >>I'll reproduce from your test case and provide a fix.  mount -o
> >>max_inline=1500 would give us 50% usage in the worst case
> 
> This is a very strange statement: how did you calculate this lower bound?

We want room for the extent and the inode item and the inode backref.
It's a rough number that leaves some extra room.  But even with a 2K
item we're getting very close to 50% usage of the metadata area.

> 
> >> (minus the
> >>balancing bug you hit).
> >
> >Ok, the balancing bug was interesting.  What happens is we create all
> >the inodes and directory items nicely packed into the leaves.
> >
> >Then delayed allocation kicks in and starts inserting the big fat inline
> >extents.  This often forces the balancing code to split a leaf twice in
> >order to make room for the new inline extent.  The double split code
> >wasn't balancing the bits that were left over on either side of our
> >desired slot.
> >
> >The patch below fixes the problem for me, reducing the number of leaves
> >that have more than 2K of free space down from 6% of the total to about
> >74 leaves.  It could be zero, but the balancing code doesn't push
> >items around if our leaf is in the first or last slot of the parent
> >node (complexity vs benefit tradeoff).
> 
> Nevertheless, I see leaves, which are not in the first or last slot,
> but mergeable with their neighbors (test case is the same):

Correct, but it was in the first or last slot when it was balanced (I
confirmed this with printk).

Then the higher layers were balanced and our leaves were no longer in
the first/last slot.  We don't rebalance leaves when we balance level 1.

> 
> leaf 269557760 items 22 free space 2323 generation 25 owner 2
> fs uuid 614fb921-cfa9-403d-9feb-940021e72382
> chunk uuid b1674882-a445-45f9-b250-0985e483d231
> 
> leaf 280027136 items 18 free space 2627 generation 25 owner 2
> fs uuid 614fb921-cfa9-403d-9feb-940021e72382
> chunk uuid b1674882-a445-45f9-b250-0985e483d231
> 
> node 269549568 level 1 items 60 free 61 generation 25 owner 2
> fs uuid 614fb921-cfa9-403d-9feb-940021e72382
> chunk uuid b1674882-a445-45f9-b250-0985e483d231
>        key (175812608 EXTENT_ITEM 4096) block 175828992 (42927) gen 15
>        key (176025600 EXTENT_ITEM 4096) block 176111616 (42996) gen 15
>        key (176238592 EXTENT_ITEM 4096) block 176300032 (43042) gen 15
>        key (176451584 EXTENT_ITEM 4096) block 216248320 (52795) gen 17
>        key (176672768 EXTENT_ITEM 4096) block 216236032 (52792) gen 17
>        key (176783360 EXTENT_ITEM 4096) block 216252416 (52796) gen 17
>        key (176955392 EXTENT_ITEM 4096) block 138854400 (33900) gen 25
>        key (177131520 EXTENT_ITEM 4096) block 280289280 (68430) gen 25
>        key (177348608 EXTENT_ITEM 4096) block 280285184 (68429) gen 25
>        key (177561600 EXTENT_ITEM 4096) block 269557760 (65810) gen 25
>        key (177795072 EXTENT_ITEM 4096) block 280027136 (68366) gen 25
>        key (178008064 EXTENT_ITEM 4096) block 280064000 (68375) gen 25
>        key (178233344 EXTENT_ITEM 4096) block 285061120 (69595) gen 25
>        key (178442240 EXTENT_ITEM 4096) block 178442240 (43565) gen 16
>        key (178655232 EXTENT_ITEM 4096) block 178655232 (43617) gen 16
>        key (178868224 EXTENT_ITEM 4096) block 178868224 (43669) gen 16
> [...]
> 
> >With the patch, I'm able to create 106894 files (2K each) on a 1GB FS.
> >That doesn't sound like a huge improvement, but the default from
> >mkfs.btrfs is to duplicate metadata.  After duplication, that's about
> >417MB or about 40% of the overall space.
> >
> >When you factor in the space that we reserve to avoid exploding on
> >enospc and the space that we have allocated for data extents, that's not
> >a very surprising number.
> >
> >I'm still putting this patch through more testing, the double split code
> >is used in some difficult corners and I need to make sure I've tried
> >all of them.
> 
> Chris, for the further code review we need documents, which reflect
> the original ideas of the balancing, etc. Could you please provide them?
> Obviously, I can not do it instead of you, as I don't know those ideas.
> 

Which part are you most interested in?

-chris
