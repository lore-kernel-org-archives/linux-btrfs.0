Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45379 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdC3Kce (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 06:32:34 -0400
Date: Thu, 30 Mar 2017 12:31:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/5] btrfs: scrub: Introduce full stripe lock for
 RAID56
Message-ID: <20170330103149.GF4781@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
 <20170329013322.1323-2-quwenruo@cn.fujitsu.com>
 <20170330003444.GA15452@lim.localdomain>
 <1a67dcaf-f1b5-a9bf-673a-2a364bd94d89@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1a67dcaf-f1b5-a9bf-673a-2a364bd94d89@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 30, 2017 at 09:03:21AM +0800, Qu Wenruo wrote:
> >> +static int lock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr)
> >> +{
> >> +	struct btrfs_block_group_cache *bg_cache;
> >> +	struct btrfs_full_stripe_locks_tree *locks_root;
> >> +	struct full_stripe_lock *existing;
> >> +	u64 fstripe_start;
> >> +	int ret = 0;
> >> +
> >> +	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
> >> +	if (!bg_cache)
> >> +		return -ENOENT;
> >> +
> >
> > When starting to scrub a chunk, we've already increased a ref for block group,
> > could you please put a ASSERT to catch it?
> 
> Personally I prefer WARN_ON() than ASSERT().
> 
> ASSERT() always panic the modules and forces us to reset the system. 
> Wiping out any possibility to check the system.

I think the sematnics of WARN_ON and ASSERT are different, so it should
be decided case by case which one to use. Assert is good for 'never
happens' or catch errors at development time (wrong API use, invariant
condition that must always match).

Also the asserts are gone if the config option is unset, while WARN_ON
will stay in some form (verbose or not). Both are suitable for catching
problems, but the warning is for less critical errors so we want to know
when it happens but still can continue.

The above case looks like a candidate for ASSERT as the refcounts must
be correct, continuing with the warning could lead to other unspecified
problems.
