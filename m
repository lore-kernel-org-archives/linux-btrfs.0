From: Chris Mason <chris.mason@Oracle.COM>
Subject: Re: [PATCH] btrfs: fix return value check of btrfs_start_transaction()
Date: Tue, 01 Feb 2011 07:38:46 -0500
Message-ID: <1296563905-sup-3613@think>
References: <201101200619.AA00004@T-ITOH1.jp.fujitsu.com> <20110120160959.GB6609@dhcp231-156.rdu.redhat.com> <4D38C980.3020001@jp.fujitsu.com> <4D392265.1020003@jp.fujitsu.com> <1296251516-sup-9915@think> <4D476CC4.6030902@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D476CC4.6030902@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tsutomu Itoh's message of 2011-01-31 21:15:32 -0500:
> Hi Chris,
> 
> (2011/01/29 6:53), Chris Mason wrote:
> > Excerpts from Tsutomu Itoh's message of 2011-01-21 01:06:29 -0500:
> >> (2011/01/21 8:47), Tsutomu Itoh wrote:
> >>> (2011/01/21 1:09), Josef Bacik wrote:
> >>>> I'd rather we go through and have these things return an error than do a
> >>>> BUG_ON().  We're moving towards a more stable BTRFS, not one that panics more
> >>>> often :).
> >>>
> >>> Yes, I also think so.
> >>> This patch is my first step.
> >>>
> >>> My modification policy is as follows:
> >>>
> >>> 1. short term
> >>>  - To more stable BTRFS, the part that should be corrected is clarified. 
> >>>  - The panic is not done by the NULL pointer reference etc.
> >> This means, even if temporary increase BUG_ON()...
> >>
> >> In addition, I think that an important memory allocation should retry several times. 
> >> So, I propose the following patches as this sample.
> >>
> >>>
> >>> 2. long term
> >>>  - BUG_ON() is decreased by using the forced-readonly framework(already posted by Liu Bo),
> >>>    etc. 
> >>
> >>
> >> This patch retries kmem_cache_alloc() in start_transaction() several times. 
> > 
> > Thanks for working on these, it's really good to see these error checks
> > going on.
> > 
> > We don't want to loop on kmem_cache_alloc(), for allocations less than
> > 4KB, the allocator only returns NULL if the box has gone into OOM
> > anyway.  By the time we get these, things have gone horribly wrong.
> > 
> > If we really can't fail, we can use GFP_NOFAIL, which loops for us.
> 
> I agree to your opinion, and please ignore following patch.
> But, please apply http://marc.info/?l=linux-btrfs&m=129550441505242&w=2

Thanks, I have this one now as well.

-chris
