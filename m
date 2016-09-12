Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57026 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932752AbcILO5f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:57:35 -0400
Subject: Re: [PATCH 2/3] writeback: allow for dirty metadata accounting
To: Jan Kara <jack@suse.cz>
References: <1471887302-12730-1-git-send-email-jbacik@fb.com>
 <1471887302-12730-3-git-send-email-jbacik@fb.com>
 <20160909081743.GC22777@quack2.suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>, <linux-mm@kvack.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <bd00ed53-00c8-49d2-13b2-5f7dfa607185@fb.com>
Date: Mon, 12 Sep 2016 10:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <20160909081743.GC22777@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2016 04:17 AM, Jan Kara wrote:
> On Mon 22-08-16 13:35:01, Josef Bacik wrote:
>> Provide a mechanism for file systems to indicate how much dirty metadata they
>> are holding.  This introduces a few things
>>
>> 1) Zone stats for dirty metadata, which is the same as the NR_FILE_DIRTY.
>> 2) WB stat for dirty metadata.  This way we know if we need to try and call into
>> the file system to write out metadata.  This could potentially be used in the
>> future to make balancing of dirty pages smarter.
>
> So I'm curious about one thing: In the previous posting you have mentioned
> that the main motivation for this work is to have a simple support for
> sub-pagesize dirty metadata blocks that need tracking in btrfs. However you
> do the dirty accounting at page granularity. What are your plans to handle
> this mismatch?

We already track how much dirty metadata we have internally in btrfs, I 
envisioned the subpage blocksize guys just calling the accounting ever N objects 
that were dirited in order to keep the accounting correct.  This is not great, 
but it was better than the hoops we needed to jump through to deal with the 
btree_inode and subpagesize blocksizes.

>
> The thing is you actually shouldn't miscount by too much as that could
> upset some checks in mm checking how much dirty pages a node has directing
> how reclaim should be done... But it's a question whether NR_METADATA_DIRTY
> should be actually used in the checks in node_limits_ok() or in
> node_pagecache_reclaimable() at all because once you start accounting dirty
> slab objects, you are really on a thin ice...

Agreed, this does get a bit ugly.

>
>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> index 56c8fda..d329f89 100644
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -1809,6 +1809,7 @@ static unsigned long get_nr_dirty_pages(void)
>>  {
>>  	return global_node_page_state(NR_FILE_DIRTY) +
>>  		global_node_page_state(NR_UNSTABLE_NFS) +
>> +		global_node_page_state(NR_METADATA_DIRTY) +
>>  		get_nr_dirty_inodes();
>
> With my question is also connected this - when we have NR_METADATA_DIRTY,
> we could just account dirty inodes there and get rid of this
> get_nr_dirty_inodes() hack...
>
> But actually getting this to work right to be able to track dirty inodes would
> be useful on its own - some throlling of creation of dirty inodes would be
> useful for several filesystems (ext4, xfs, ...).

So I suppose what I could do is instead provide a callback for the vm to ask how 
many dirty objects we have in the file system, instead of adding another page 
counter.  That way the actual accounting is kept internal to the file system, 
and it gets rid of the weird mismatch when blocksize < pagesize.  Does that 
sound like a more acceptable approach?  Unfortunately I decided to do this work 
to make the blocksize < pagesize work easier, but then didn't actually think 
about how the accounting would interact with that case, because I'm an idiot.

I think that looping through all the sb's in the system would be kinda shitty 
for this tho, we want the "get number of dirty pages" part to be relatively 
fast.  What if I do something like the shrinker_control only for dirty objects. 
So the fs registers some dirty_objects_control, we call into each of those and 
get the counts from that.  Does that sound less crappy?  Thanks,

Josef
