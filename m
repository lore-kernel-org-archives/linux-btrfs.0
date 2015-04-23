Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:56166 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753910AbbDWMeZ (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 23 Apr 2015 08:34:25 -0400
Message-ID: <5538E6C7.9050201@suse.com>
Date: Thu, 23 Apr 2015 13:34:15 +0100
From: Filipe Manana <fdmanana@suse.com>
MIME-Version: 1.0
To: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race when reusing stale extent buffers that
 leads to BUG_ON
References: <1429784928-12665-1-git-send-email-fdmanana@suse.com> <pan.2015.04.23.12.16.21@googlemail.com>
In-Reply-To: <pan.2015.04.23.12.16.21@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/23/2015 01:16 PM, Holger Hoffstätte wrote:
> On Thu, 23 Apr 2015 11:28:48 +0100, Filipe Manana wrote:
> 
>> There's a race between releasing extent buffers that are flagged as stale
>> and recycling them that makes us it the following BUG_ON at
>> btrfs_release_extent_buffer_page:
>>
>>     BUG_ON(extent_buffer_under_io(eb))
>>
>> The BUG_ON is triggered because the extent buffer has the flag
>> EXTENT_BUFFER_DIRTY set as a consequence of having been reused and made
>> dirty by another concurrent task.
> 
> Awesome analysis!
> 
>> @@ -4768,6 +4768,25 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
>>  			       start >> PAGE_CACHE_SHIFT);
>>  	if (eb && atomic_inc_not_zero(&eb->refs)) {
>>  		rcu_read_unlock();
>> +		/*
>> +		 * Lock our eb's refs_lock to avoid races with
>> +		 * free_extent_buffer. When we get our eb it might be flagged
>> +		 * with EXTENT_BUFFER_STALE and another task running
>> +		 * free_extent_buffer might have seen that flag set,
>> +		 * eb->refs == 2, that the buffer isn't under IO (dirty and
>> +		 * writeback flags not set) and it's still in the tree (flag
>> +		 * EXTENT_BUFFER_TREE_REF set), therefore being in the process
>> +		 * of decrementing the extent buffer's reference count twice.
>> +		 * So here we could race and increment the eb's reference count,
>> +		 * clear its stale flag, mark it as dirty and drop our reference
>> +		 * before the other task finishes executing free_extent_buffer,
>> +		 * which would later result in an attempt to free an extent
>> +		 * buffer that is dirty.
>> +		 */
>> +		if (test_bit(EXTENT_BUFFER_STALE, &eb->bflags)) {
>> +			spin_lock(&eb->refs_lock);
>> +			spin_unlock(&eb->refs_lock);
>> +		}
>>  		mark_extent_buffer_accessed(eb, NULL);
>>  		return eb;
>>  	}
> 
> After staring at this (and the Lovecraftian horrors of free_extent_buffer())
> for over an hour and trying to understand how and why this could even remotely
> work, I cannot help but think that this fix would shift the race to the much
> smaller window between the test_bit and the first spin_lock.
> Essentially you subtly phase-shifted all participants and make them avoid the
> race most of the time, yet I cannot help but think it's still there (just much
> smaller), and could strike again with different scheduling intervals.
> 
> Would this be accurate?

Hi Holger,

Can you explain how the race can still happen?

The goal here is just to make sure a reader does not advance too fast if
the eb is stale and there's a concurrent call to free_extent_buffer() in
progress.

thanks

> 
> -h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
