Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933217AbdCaR0u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:26:50 -0400
Date: Fri, 31 Mar 2017 19:26:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/5] btrfs: scrub: Introduce full stripe lock for
 RAID56
Message-ID: <20170331172605.GO4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
 <20170329013322.1323-2-quwenruo@cn.fujitsu.com>
 <20170330003444.GA15452@lim.localdomain>
 <1a67dcaf-f1b5-a9bf-673a-2a364bd94d89@cn.fujitsu.com>
 <20170330103149.GF4781@suse.cz>
 <b3ba9d44-9ceb-729c-5b31-89c44db7ee12@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b3ba9d44-9ceb-729c-5b31-89c44db7ee12@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 31, 2017 at 10:03:28AM +0800, Qu Wenruo wrote:
> 
> 
> At 03/30/2017 06:31 PM, David Sterba wrote:
> > On Thu, Mar 30, 2017 at 09:03:21AM +0800, Qu Wenruo wrote:
> >>>> +static int lock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr)
> >>>> +{
> >>>> +	struct btrfs_block_group_cache *bg_cache;
> >>>> +	struct btrfs_full_stripe_locks_tree *locks_root;
> >>>> +	struct full_stripe_lock *existing;
> >>>> +	u64 fstripe_start;
> >>>> +	int ret = 0;
> >>>> +
> >>>> +	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
> >>>> +	if (!bg_cache)
> >>>> +		return -ENOENT;
> >>>> +
> >>>
> >>> When starting to scrub a chunk, we've already increased a ref for block group,
> >>> could you please put a ASSERT to catch it?
> >>
> >> Personally I prefer WARN_ON() than ASSERT().
> >>
> >> ASSERT() always panic the modules and forces us to reset the system.
> >> Wiping out any possibility to check the system.
> >
> > I think the sematnics of WARN_ON and ASSERT are different, so it should
> > be decided case by case which one to use. Assert is good for 'never
> > happens' or catch errors at development time (wrong API use, invariant
> > condition that must always match).
> >
> > Also the asserts are gone if the config option is unset, while WARN_ON
> > will stay in some form (verbose or not). Both are suitable for catching
> > problems, but the warning is for less critical errors so we want to know
> > when it happens but still can continue.
> >
> > The above case looks like a candidate for ASSERT as the refcounts must
> > be correct, continuing with the warning could lead to other unspecified
> > problems.
> 
> I'm OK to use ASSERT() here, but current ASSERT() in btrfs can hide real 
> problem if CONFIG_BTRFS_ASSERT is not set.
> 
> When CONFIG_BTRFS_ASSERT is not set, ASSERT() just does thing, and 
> *continue* executing.
> 
> This forces us to build a fallback method.
> 
> For above case, if we simply do "ASSERT(bg_cache);" then for 
> BTRFS_CONFIG_ASSERT not set case (which is quite common for most 
> distributions) we will cause NULL pointer deference.
> 
> So here, we still need to do bg_cache return value check, but just 
> change "WARN_ON(1);" to "ASSERT(0);" like:
> ------
> 	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
> 	if (!bg_cache) {
> 		ASSERT(0); /* WARN_ON(1); */
> 		return -ENOENT;
> 	}
> ------
> 
> Can we make ASSERT() really catch problem no matter kernel config?
> Current ASSERT() behavior is in fact forcing us to consider both 
> situation, which makes it less handy.

All agreed, I'm not very happy about how the current ASSERT is
implemented. We want to add more and potentially expensive checks during
debugging builds, but also want to make sure that code does not proceed
pass some points if the invariants and expected values do not hold.

BUG_ON does that but then we have tons of them already and some of them
are just a temporary error handling, while at some other places it
serves as the sanity checker. We'd probably need 3rd option, that would
behave like BUG_ON but named differently, so we can clearly see that
it's intentional, or we can annotate the BUG_ON by comments.
