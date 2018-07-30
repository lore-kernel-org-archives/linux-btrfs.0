Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51417 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbeG3JAj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 05:00:39 -0400
Subject: Re: [PATCH 1/1] btrfs: locking: Allow btrfs_tree_lock() to return
 error to avoid deadlock
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180730061723.13290-1-wqu@suse.com>
 <20180730061723.13290-2-wqu@suse.com>
 <66cf31bb-126f-68d7-83ee-c4214c6129c1@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <91772b2d-49fb-4aa8-17ad-99d8f56dcc86@gmx.com>
Date: Mon, 30 Jul 2018 15:26:52 +0800
MIME-Version: 1.0
In-Reply-To: <66cf31bb-126f-68d7-83ee-c4214c6129c1@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月30日 15:18, Nikolay Borisov wrote:
> 
> 
> On 30.07.2018 09:17, Qu Wenruo wrote:
>> -void btrfs_tree_lock(struct extent_buffer *eb)
>> +int btrfs_tree_lock(struct extent_buffer *eb)
>>  {
>> -	WARN_ON(eb->lock_owner == current->pid);
>> +	if (unlikely(eb->lock_owner == current->pid)) {
>> +		WARN(1,
>> +"tree block %llu already locked by current (pid=%llu), refuse to lock",
>> +		     eb->start, current->pid);
>> +		return -EUCLEAN;
>> +	}
> 
> If this happens it should point to a logical bug in which case we need
> to halt the kernel. Furthermore this seems the wrong abstraction level
> at which to solve the problem. eb->lock_owner is a runtime
> characteristic of the eb, yet when it has an unexpected value you return
> EUCLEAN which is an error for an on-disk error.

On-disk corruption leads to unexpected runtime error, this looks valid
to me at least.
Especially when we can't really verify on-disk data for it's cross
reference.

> 
> I don't think it's productive to try and solve every possible
> fuzz-inspired corruption.

Surprisingly, we should.

The point here is, such image can be used to do kernel deny-of-service
attack.
(Such debate happened a long time ago, and at that time I was thinking
the same as you)

No one likes a USB stick to cause kernel deadlock, even for desktop users.

> In the worst case this corruption should be
> caught a lot earlier rather than when we are locking an in-memory
> structure.

This makes sense, although not that doable.
For early detection, we need to do some level cross check, which could
be time and IO consuming.

Currently this fix is the least performance-impacting one I could think of.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
