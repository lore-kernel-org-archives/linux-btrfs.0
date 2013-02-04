Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab3BDQFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Feb 2013 11:05:46 -0500
Message-ID: <510FDC54.4010902@redhat.com>
Date: Mon, 04 Feb 2013 10:05:40 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at fs/btrfs/async-thread.c:605!
References: <5109E70D.3010005@jp.fujitsu.com> <510A0756.40206@redhat.com> <510A243C.3010508@cn.fujitsu.com> <510B0CE5.9090601@jp.fujitsu.com> <510B3B4B.6070607@cn.fujitsu.com> <510B5845.2020602@jp.fujitsu.com> <510F1F63.8000203@cn.fujitsu.com>
In-Reply-To: <510F1F63.8000203@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/3/13 8:39 PM, Miao Xie wrote:
> Hi, Eric
> 
> I want to send out my fix patch, but Could I add your Signed-off-by?
> because you found the key to solving the problem.

I don't know if a signed-off-by chain is the right approach, but
don't worry about it.  You can mention my first patch in the changelog if you like.

Thanks,
-Eric

> Thanks
> Miao
> 
> On Fri, 01 Feb 2013 14:53:09 +0900, Tsutomu Itoh wrote:
>>>> Can you please explain similar problems, Miao?
>>>
>>> Before missing device check, there are several places where we read the metadata,
>>> such as reading chunk tree root, btrfs_read_chunk_tree, those functions may fail
>>> after submit a bio. If we don't wait until the bio end, and just stop the workers,
>>> the same problem will happen.
>>>
>>> (invalidate_inode_pages2() will wait until the bio end, because it need lock the pages
>>>   which are going to be invalidated, and the page is locked if it is under disk read IO)
>>
>> I understood.
>>
>> My reproducer is not reproduce this problem yet. But the following messages were
>> displayed when 'rmmod btrfs' command was executed.
>>
>>  [76378.723481] =============================================================================
>>  [76378.723901] BUG btrfs_extent_buffer (Tainted: G   B       ): Objects remaining in btrfs_extent_buffer on kmem_cache_close()
>>  [76378.724333] -----------------------------------------------------------------------------
>>  [76378.724333]
>>  [76378.724959] INFO: Slab 0xffffea00065c3280 objects=23 used=2 fp=0xffff8801970caac0 flags=0x8000000000004080
>>  [76378.725391] Pid: 9156, comm: rmmod Tainted: G B        3.8.0-rc5 #1
>>  [76378.725397] Call Trace:
>>  [76378.725403]  [<ffffffff8111bc23>] slab_err+0xb0/0xd2
>>
>> I think that this message means there is a possibility that I/O did not end
>> normally.
>> and, after Miao's patch applied, this message is not displayed when rmmod was
>> executed.
>>
>> So, Miao's patch seems to fix the problem for me.
> [SNIP]
>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>> index 0c31d07..d8fd711 100644
>>>>> --- a/fs/btrfs/disk-io.c
>>>>> +++ b/fs/btrfs/disk-io.c
>>>>> @@ -2728,13 +2728,13 @@ fail_cleaner:
>>>>>    	 * kthreads
>>>>>    	 */
>>>>>    	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>>>>> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>>>>>    
>>>>>    fail_block_groups:
>>>>>    	btrfs_free_block_groups(fs_info);
>>>>>    
>>>>>    fail_tree_roots:
>>>>>    	free_root_pointers(fs_info, 1);
>>>>> +	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>>>>>    
>>>>>    fail_sb_buffer:
>>>>>    	btrfs_stop_workers(&fs_info->generic_worker);
>>>>> @@ -2755,7 +2755,6 @@ fail_alloc:
>>>>>    fail_iput:
>>>>>    	btrfs_mapping_tree_free(&fs_info->mapping_tree);
>>>>>    
>>>>> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>>>>>    	iput(fs_info->btree_inode);
>>>>>    fail_bdi:
>>>>>    	bdi_destroy(&fs_info->bdi);
>>>>>
>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

