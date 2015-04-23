Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38014 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbbDWNWo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 09:22:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlH5K-0003Po-2X
	for linux-btrfs@vger.kernel.org; Thu, 23 Apr 2015 15:22:30 +0200
Received: from p4ff58852.dip0.t-ipconnect.de ([79.245.136.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 15:22:30 +0200
Received: from holger.hoffstaette by p4ff58852.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 15:22:30 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: fix race when reusing stale extent buffers that
 leads to BUG_ON
Date: Thu, 23 Apr 2015 13:22:23 +0000 (UTC)
Message-ID: <pan.2015.04.23.13.22.23@googlemail.com>
References: <1429784928-12665-1-git-send-email-fdmanana@suse.com>
	<pan.2015.04.23.12.16.21@googlemail.com> <5538E6C7.9050201@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23 Apr 2015 13:34:15 +0100, Filipe Manana wrote:

> On 04/23/2015 01:16 PM, Holger Hoffstätte wrote:
>> On Thu, 23 Apr 2015 11:28:48 +0100, Filipe Manana wrote:
>> 
>>> There's a race between releasing extent buffers that are flagged as stale
>>> and recycling them that makes us it the following BUG_ON at
>>> btrfs_release_extent_buffer_page:
>>>
>>>     BUG_ON(extent_buffer_under_io(eb))
>>>
>>> The BUG_ON is triggered because the extent buffer has the flag
>>> EXTENT_BUFFER_DIRTY set as a consequence of having been reused and made
>>> dirty by another concurrent task.
>> 
>> Awesome analysis!
>> 
>>> @@ -4768,6 +4768,25 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
>>>  			       start >> PAGE_CACHE_SHIFT);
>>>  	if (eb && atomic_inc_not_zero(&eb->refs)) {
>>>  		rcu_read_unlock();
>>> +		/*
>>> +		 * Lock our eb's refs_lock to avoid races with
>>> +		 * free_extent_buffer. When we get our eb it might be flagged
>>> +		 * with EXTENT_BUFFER_STALE and another task running
>>> +		 * free_extent_buffer might have seen that flag set,
>>> +		 * eb->refs == 2, that the buffer isn't under IO (dirty and
>>> +		 * writeback flags not set) and it's still in the tree (flag
>>> +		 * EXTENT_BUFFER_TREE_REF set), therefore being in the process
>>> +		 * of decrementing the extent buffer's reference count twice.
>>> +		 * So here we could race and increment the eb's reference count,
>>> +		 * clear its stale flag, mark it as dirty and drop our reference
>>> +		 * before the other task finishes executing free_extent_buffer,
>>> +		 * which would later result in an attempt to free an extent
>>> +		 * buffer that is dirty.
>>> +		 */
>>> +		if (test_bit(EXTENT_BUFFER_STALE, &eb->bflags)) {
>>> +			spin_lock(&eb->refs_lock);
>>> +			spin_unlock(&eb->refs_lock);
>>> +		}
>>>  		mark_extent_buffer_accessed(eb, NULL);
>>>  		return eb;
>>>  	}
>> 
>> After staring at this (and the Lovecraftian horrors of free_extent_buffer())
>> for over an hour and trying to understand how and why this could even remotely
>> work, I cannot help but think that this fix would shift the race to the much
>> smaller window between the test_bit and the first spin_lock.
>> Essentially you subtly phase-shifted all participants and make them avoid the
>> race most of the time, yet I cannot help but think it's still there (just much
>> smaller), and could strike again with different scheduling intervals.
>> 
>> Would this be accurate?
> 
> Hi Holger,
> 
> Can you explain how the race can still happen?
> 
> The goal here is just to make sure a reader does not advance too fast if
> the eb is stale and there's a concurrent call to free_extent_buffer() in
> progress.

Yes, that much I understood. I look at this change from the perspective of
an optimizing compiler:

- without the new if-block we would fall through and mark_extent_buffer
while it's being deleted, which complains with a BUG.

- the new block therefore checks for the problematic state, but then does
something that - from a work perspective - could be eliminated (lock+unlock),
since nothing seemimgly useful happens inbetween.

-that leaves the if without observable side effect and so could be
eliminated as well.

So theoretically we have not really "coordinated" anything. That made me
suspicious: at the very least I would have expected some kind of loop
or something that protects/reliably delays mark_extent_buffer so that it
really has a completion/atomicity guarantee, not just a small "bump" in
its timeline. You said that a "real fix" would be proper refcounting -
that's sort of what I was expecting, at least in terms of side effects.

Now, I understand that the block is not eliminated, but the if followed
by the lock acquiry is not atomic. That's where - very theoretically -
the same race as before could happen e.g. on a single core and the thread
running free_extent_buffer is scheduled after the if but before the lock.
We'd then get the lock, immediately unlock it and proceed to mark.

I don't know if any of this can actually happen! It's just that I've never
seen a construct like this (and I like lock-free/wait-free coordination),
so this got me curious.

Thanks!
Holger

