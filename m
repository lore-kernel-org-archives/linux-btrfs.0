Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:60867 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3AaQxK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 11:53:10 -0500
Message-ID: <510AA14D.8070009@sandia.gov>
Date: Thu, 31 Jan 2013 09:52:29 -0700
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: "Josef Bacik" <jbacik@fusionio.com>
cc: "Liu Bo" <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
 <510817C6.5070007@sandia.gov>
 <20130129200415.GE3660@localhost.localdomain>
 <510855AD.2020602@sandia.gov>
 <20130130163832.GH3660@localhost.localdomain>
 <510992A4.4090703@sandia.gov>
 <20130131153317.GM3660@localhost.localdomain>
In-Reply-To: <20130131153317.GM3660@localhost.localdomain>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/31/2013 08:33 AM, Josef Bacik wrote:
> On Wed, Jan 30, 2013 at 02:37:40PM -0700, Jim Schutt wrote:
>> On 01/30/2013 09:38 AM, Josef Bacik wrote:
>>> On Tue, Jan 29, 2013 at 04:05:17PM -0700, Jim Schutt wrote:
>>>>> On 01/29/2013 01:04 PM, Josef Bacik wrote:
>>>>>>> On Tue, Jan 29, 2013 at 11:41:10AM -0700, Jim Schutt wrote:
>>>>>>>>>>> On 01/28/2013 02:23 PM, Josef Bacik wrote:
>>>>>>>>>>>>>>> On Thu, Jan 03, 2013 at 11:44:46AM -0700, Jim Schutt wrote:
>>>>>>>>>>>>>>>>>>> Hi Josef,
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> Thanks for the patch - sorry for the long delay in testing...
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Jim,
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I've been trying to reason out how this happens, could you do a btrfs fi df on
>>>>>>>>>>>>>>> the filesystem thats giving you trouble so I can see if what I think is
>>>>>>>>>>>>>>> happening is what's actually happening.  Thanks,
>>>>>>>>>>>
>>>>>>>>>>> Here's an example, using a slightly different kernel than
>>>>>>>>>>> my previous report.  It's your btrfs-next master branch
>>>>>>>>>>> (commit 8f139e59d5 "Btrfs: use bit operation for ->fs_state")
>>>>>>>>>>> with ceph 3.8 for-linus (commit 0fa6ebc600 from linus' tree).
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Here I'm finding the file system in question:
>>>>>>>>>>>
>>>>>>>>>>> # ls -l /dev/mapper | grep dm-93
>>>>>>>>>>> lrwxrwxrwx 1 root root       8 Jan 29 11:13 cs53s19p2 -> ../dm-93
>>>>>>>>>>>
>>>>>>>>>>> # df -h | grep -A 1 cs53s19p2
>>>>>>>>>>> /dev/mapper/cs53s19p2
>>>>>>>>>>>                       896G  1.1G  896G   1% /ram/mnt/ceph/data.osd.522
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Here's the info you asked for:
>>>>>>>>>>>
>>>>>>>>>>> # btrfs fi df /ram/mnt/ceph/data.osd.522
>>>>>>>>>>> Data: total=2.01GB, used=1.00GB
>>>>>>>>>>> System: total=4.00MB, used=64.00KB
>>>>>>>>>>> Metadata: total=8.00MB, used=7.56MB
>>>>>>>>>>>
>>>>>>> How big is the disk you are using, and what mount options?  I have a patch to
>>>>>>> keep the panic from happening and hopefully the abort, could you try this?  I
>>>>>>> still want to keep the underlying error from happening because it shouldn't be,
>>>>>>> but no reason I can't fix the error case while you can easily reproduce it :).
>>>>>>> Thanks,
>>>>>>>
>>>>>>> Josef
>>>>>>>
>>>>>>> >From c50b725c74c7d39064e553ef85ac9753efbd8aec Mon Sep 17 00:00:00 2001
>>>>>>> From: Josef Bacik <jbacik@fusionio.com>
>>>>>>> Date: Tue, 29 Jan 2013 15:03:37 -0500
>>>>>>> Subject: [PATCH] Btrfs: fix chunk allocation error handling
>>>>>>>
>>>>>>> If we error out allocating a dev extent we will have already created the
>>>>>>> block group and such which will cause problems since the allocator may have
>>>>>>> tried to allocate out of the block group that no longer exists.  This will
>>>>>>> cause BUG_ON()'s in the bio submission path.  This also makes a failure to
>>>>>>> allocate a dev extent a non-abort error, we will just clean up the dev
>>>>>>> extents we did allocate and exit.  Now if we fail to delete the dev extents
>>>>>>> we will abort since we can't have half of the dev extents hanging around,
>>>>>>> but this will make us much less likely to abort.  Thanks,
>>>>>>>
>>>>>>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>>>>>>> ---
>>>>>
>>>>> Interesting - with your patch applied I triggered the following, just
>>>>> bringing up a fresh Ceph filesystem - I didn't even get a chance to
>>>>> mount it on my Ceph clients:
>>>>>
>>> Ok can you give this patch a whirl as well?  It seems to fix the problem for me.
>>
>> With this patch on top of your previous patch, after several trials of
>> my test I am also unable to reproduce the issue.  Since I had been
>> having trouble first time, every time, I think it also seems to fix
>> the problem for me.
>>
> 
> Hey Jim,
> 
> Could you test this patch instead?  I think it's a little less hamfisted and
> should give us a nice balance between not crashing and being good for
> performance.  Thanks,

Hi Josef,

Running with this patch in place of your previous version, I
was again unable to reproduce the issue.

I might be seeing a couple percent increase in performance, or
it might just be noise, but I'm willing to say that I think
performance is same-or-better than the previous version of
the patch.

Thanks again!

-- Jim

> 
> Josef
> 
> commit 43510c0e5faad8e5e4d8ba13baa1dd5dfb3d39ce
> Author: Josef Bacik <jbacik@fusionio.com>
> Date:   Wed Jan 30 17:02:51 2013 -0500
> 
>     Btrfs: do not allow overcommit to happen if we are over 80% in use
>     
>     Because of how little we allocate chunks now we can get really tight on
>     metadata space before we will allocate a new chunk.  This resulted in being
>     unable to add device extents when allocating a new metadata chunk as we did
>     not have enough space.  This is because we were allowed to overcommit too
>     much metadata without actually making sure we had enough space to make
>     allocations.  The idea behind overcommit is that we are allowed to say "sure
>     you can have that reservation" when most of the free space is occupied by
>     reservations, not actual allocations.  But in this case where a majority of
>     the total space is in use by actual allocations we can screw ourselves by
>     not being able to make real allocations when it matters.  So put this cap in
>     place for now to keep us from overcommitting so much that we run out of
>     space.  Thanks,
>     
>     Reported-and-tested-by: Jim Schutt <jaschut@sandia.gov>
>     Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index dca5679..156341e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3672,13 +3672,30 @@ static int can_overcommit(struct btrfs_root *root,
>  			  struct btrfs_space_info *space_info, u64 bytes,
>  			  enum btrfs_reserve_flush_enum flush)
>  {
> +	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
>  	u64 profile = btrfs_get_alloc_profile(root, 0);
> +	u64 rsv_size = 0;
>  	u64 avail;
>  	u64 used;
>  
>  	used = space_info->bytes_used + space_info->bytes_reserved +
> -		space_info->bytes_pinned + space_info->bytes_readonly +
> -		space_info->bytes_may_use;
> +		space_info->bytes_pinned + space_info->bytes_readonly;
> +
> +	spin_lock(&global_rsv->lock);
> +	rsv_size = global_rsv->size;
> +	spin_unlock(&global_rsv->lock);
> +
> +	/*
> +	 * We only want to allow over committing if we have lots of actual space
> +	 * free, but if we don't have enough space to handle the global reserve
> +	 * space then we could end up having a real enospc problem when trying
> +	 * to allocate a chunk or some other such important allocation.
> +	 */
> +	rsv_size <<= 1;
> +	if (used + rsv_size >= space_info->total_bytes)
> +		return 0;
> +
> +	used += space_info->bytes_may_use;
>  
>  	spin_lock(&root->fs_info->free_chunk_lock);
>  	avail = root->fs_info->free_chunk_space;
> 
> 


