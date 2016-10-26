Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37593 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751810AbcJZPMM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 11:12:12 -0400
Subject: Re: [PATCH 5/5] fs: don't set *REFERENCED unless we are on the lru
 list
To: Dave Chinner <david@fromorbit.com>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-6-git-send-email-jbacik@fb.com>
 <20161025220112.GE14023@dastard>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <jack@suse.cz>,
        <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <hch@infradead.org>, <jweiner@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <d5f330d4-8969-b90c-9fe9-134b1bf5d57f@fb.com>
Date: Wed, 26 Oct 2016 11:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <20161025220112.GE14023@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/25/2016 06:01 PM, Dave Chinner wrote:
> On Tue, Oct 25, 2016 at 02:41:44PM -0400, Josef Bacik wrote:
>> With anything that populates the inode/dentry cache with a lot of one time use
>> inodes we can really put a lot of pressure on the system for things we don't
>> need to keep in cache.  It takes two runs through the LRU to evict these one use
>> entries, and if you have a lot of memory you can end up with 10's of millions of
>> entries in the dcache or icache that have never actually been touched since they
>> were first instantiated, and it will take a lot of CPU and a lot of pressure to
>> evict all of them.
>>
>> So instead do what we do with pagecache, only set the *REFERENCED flags if we
>> are being used after we've been put onto the LRU.  This makes a significant
>> difference in the system's ability to evict these useless cache entries.  With a
>> fs_mark workload that creates 40 million files we get the following results (all
>> in files/sec)
>
> What's the workload, storage, etc?

Oops sorry I thought I said it.  It's fs_mark creating 20 million empty files on 
a single NVME drive.

>
>> Btrfs			Patched		Unpatched
>> Average Files/sec:	72209.3		63254.2
>> p50 Files/sec:	70850		57560
>> p90 Files/sec:	68757		53085
>> p99 Files/sec:	68757		53085
>
> So how much of this is from changing the dentry referenced
> behaviour, and how much from the inode? Can you separate out the two
> changes so we know which one is actually affecting reclaim
> performance?
>
> Indeed, I wonder if just changing the superblock shrinker
> default_seeks for btrfs would have exactly the same impact because
> that canbe used to exactly double the reclaim scan rate for the same
> memory pressure.  If that doesn't change performance by a similar
> amount (changing defaults seeks is the normal way of changing
> shrinker balance), then more digging is required here to explain why
> the referenced bits make such an impact to steady state
> performance...
>

I'll tease out the impact of changing dcache vs icache vs both.  Yeah I'll 
reduce default_seeks and see what that turns out to be.

>> XFS			Patched		Unpatched
>> Average Files/sec:	61025.5		60719.5
>> p50 Files/sec:	60107		59465
>> p90 Files/sec:	59300		57966
>> p99 Files/sec:	59227		57528
>
> You made XFS never use I_REFERENCED at all (hint: not all
> filesystems use find_inode/find_inode_fast()), so it's not clear
> that the extra scanning (less than 1% difference in average
> throughput) is actuallly the cause of things being slower in btrfs.
>
>> The reason Btrfs has a much larger improvement is because it holds a lot more
>> things in memory so benefits more from faster slab reclaim, but across the board
>> is an improvement for each of the file systems.
>
> Less than 1% for XFS and ~1.5% for ext4 is well within the
> run-to-run variation of fsmark. It looks like it might be slightly
> faster, but it's not a cut-and-dried win for anything other than
> btrfs.
>

Sure the win in this benchmark is clearly benefiting btrfs the most, but I think 
the overall approach is sound and likely to help everybody in theory.  Inside FB 
we definitely have had problems where the memory pressure induced by some 
idi^H^H^Hprocess goes along and runs find / which causes us to evict real things 
that are being used rather than these one use inodes.  This sort of behavior 
could possibly be mitigated by this patch, but I haven't sat down to figure out 
a reliable way to mirror this workload to test that theory.  Thanks

Josef

