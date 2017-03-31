Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38646 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750820AbdCaCDd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 22:03:33 -0400
Subject: Re: [PATCH v3 1/5] btrfs: scrub: Introduce full stripe lock for
 RAID56
To: <dsterba@suse.cz>, <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
 <20170329013322.1323-2-quwenruo@cn.fujitsu.com>
 <20170330003444.GA15452@lim.localdomain>
 <1a67dcaf-f1b5-a9bf-673a-2a364bd94d89@cn.fujitsu.com>
 <20170330103149.GF4781@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b3ba9d44-9ceb-729c-5b31-89c44db7ee12@cn.fujitsu.com>
Date: Fri, 31 Mar 2017 10:03:28 +0800
MIME-Version: 1.0
In-Reply-To: <20170330103149.GF4781@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/30/2017 06:31 PM, David Sterba wrote:
> On Thu, Mar 30, 2017 at 09:03:21AM +0800, Qu Wenruo wrote:
>>>> +static int lock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr)
>>>> +{
>>>> +	struct btrfs_block_group_cache *bg_cache;
>>>> +	struct btrfs_full_stripe_locks_tree *locks_root;
>>>> +	struct full_stripe_lock *existing;
>>>> +	u64 fstripe_start;
>>>> +	int ret = 0;
>>>> +
>>>> +	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
>>>> +	if (!bg_cache)
>>>> +		return -ENOENT;
>>>> +
>>>
>>> When starting to scrub a chunk, we've already increased a ref for block group,
>>> could you please put a ASSERT to catch it?
>>
>> Personally I prefer WARN_ON() than ASSERT().
>>
>> ASSERT() always panic the modules and forces us to reset the system.
>> Wiping out any possibility to check the system.
>
> I think the sematnics of WARN_ON and ASSERT are different, so it should
> be decided case by case which one to use. Assert is good for 'never
> happens' or catch errors at development time (wrong API use, invariant
> condition that must always match).
>
> Also the asserts are gone if the config option is unset, while WARN_ON
> will stay in some form (verbose or not). Both are suitable for catching
> problems, but the warning is for less critical errors so we want to know
> when it happens but still can continue.
>
> The above case looks like a candidate for ASSERT as the refcounts must
> be correct, continuing with the warning could lead to other unspecified
> problems.

I'm OK to use ASSERT() here, but current ASSERT() in btrfs can hide real 
problem if CONFIG_BTRFS_ASSERT is not set.

When CONFIG_BTRFS_ASSERT is not set, ASSERT() just does thing, and 
*continue* executing.

This forces us to build a fallback method.

For above case, if we simply do "ASSERT(bg_cache);" then for 
BTRFS_CONFIG_ASSERT not set case (which is quite common for most 
distributions) we will cause NULL pointer deference.

So here, we still need to do bg_cache return value check, but just 
change "WARN_ON(1);" to "ASSERT(0);" like:
------
	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
	if (!bg_cache) {
		ASSERT(0); /* WARN_ON(1); */
		return -ENOENT;
	}
------

Can we make ASSERT() really catch problem no matter kernel config?
Current ASSERT() behavior is in fact forcing us to consider both 
situation, which makes it less handy.

Thanks,
Qu


