Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55519 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935067AbcIFNEL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 09:04:11 -0400
Subject: Re: [PATCH 0/7] Kill the btree inode
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
 <20160905163120.GY16983@twin.jikos.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <734c61f0-0e0f-2098-ef37-aa99e004a04b@fb.com>
Date: Tue, 6 Sep 2016 09:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <20160905163120.GY16983@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2016 12:31 PM, David Sterba wrote:
> On Fri, Sep 02, 2016 at 03:39:59PM -0400, Josef Bacik wrote:
>> In order to provide a better way to do subpage blocksizes we need to stop
>> allocating pages from a per fs btree inode and instead allocate our own pages.
>> This work depends on 3 generic patches that I've sent previously
>>
>> remove mapping from balance_dirty_pages*()
>> writeback: allow for dirty metadata accounting
>> writeback: introduce super_operations->write_metadata
>
> What's the status of the patches? I don't see them in current
> linux-next. I can put them to our for-next for the time being so we can
> test the btree_inode removal.

Still waiting on reviews.  The first pass had no big objections, just need to 
get people to look at the next pass.

>
>> This is a pretty big change but ultimately makes extent_buffer reclaim much
>> cleaner and will make the sub-pagesize blocksize work significantly cleaner.
>> I've been hammering on this for a few weeks now and seems to be pretty solid.
>
> The preparatory patches are ok. The core patch is quite large, although
> there are simple transformations to the new eb_info, the remaining
> changes are still quite big for a review. But I don't see a way how to
> split it, it's basically an all-or-nothing change. Overall it looks ok
> so I'll put it to for-next.
>

Yeah I broke out what I could but unfortunately ripping out the btree_inode 
means we have to make a bunch of other changes all at once, or we wouldn't be 
able to bisect across it without things breaking horribly.  Thanks,

Josef
