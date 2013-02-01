Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40451 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3BAFxZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 00:53:25 -0500
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id B10433EE0CB
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 14:53:23 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 94AC145DE59
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 14:53:23 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 708F545DE51
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 14:53:23 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 5FC7C1DB803B
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 14:53:23 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 01A651DB802F
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 14:53:23 +0900 (JST)
Message-ID: <510B5845.2020602@jp.fujitsu.com>
Date: Fri, 01 Feb 2013 14:53:09 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Eric Sandeen <sandeen@redhat.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at fs/btrfs/async-thread.c:605!
References: <5109E70D.3010005@jp.fujitsu.com> <510A0756.40206@redhat.com> <510A243C.3010508@cn.fujitsu.com> <510B0CE5.9090601@jp.fujitsu.com> <510B3B4B.6070607@cn.fujitsu.com>
In-Reply-To: <510B3B4B.6070607@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/01 12:49, Miao Xie wrote:
> On Fri, 01 Feb 2013 09:31:33 +0900, Tsutomu Itoh wrote:
>> Hi,
>>
>> On 2013/01/31 16:58, Miao Xie wrote:
>>> On wed, 30 Jan 2013 23:55:34 -0600, Eric Sandeen wrote:
>>>> if you move the fail_block_groups: target above the comment, does that fix it?
>>>> (although I don't know yet what started IO . . . )
>>>>
>>>> like this:
>>>>
>>>> From: Eric Sandeen <sandeen@redhat.com>
>>>>
>>>> Make sure that we are always done with the btree_inode's mapping
>>>> before we shut down the worker threads in open_ctree() error
>>>> cases.
>>>
>>>
>>> I reviewed your patch again, and found it just fix the above problem, it still
>>> have similar problems which are not fixed.
>>>
>>> How about this one?
>>
>> Thanks Eric and Miao.
>> But I can not reproduce this problem, yet.
>> ('Btrfs: too many missing devices, writeable mount is not allowed' messages was
>>   displayed, but not panic)
>>   So, I can not test your patch, sorry.
>>
>> Can you please explain similar problems, Miao?
> 
> Before missing device check, there are several places where we read the metadata,
> such as reading chunk tree root, btrfs_read_chunk_tree, those functions may fail
> after submit a bio. If we don't wait until the bio end, and just stop the workers,
> the same problem will happen.
> 
> (invalidate_inode_pages2() will wait until the bio end, because it need lock the pages
>   which are going to be invalidated, and the page is locked if it is under disk read IO)

I understood.

My reproducer is not reproduce this problem yet. But the following messages were
displayed when 'rmmod btrfs' command was executed.

 [76378.723481] =============================================================================
 [76378.723901] BUG btrfs_extent_buffer (Tainted: G   B       ): Objects remaining in btrfs_extent_buffer on kmem_cache_close()
 [76378.724333] -----------------------------------------------------------------------------
 [76378.724333]
 [76378.724959] INFO: Slab 0xffffea00065c3280 objects=23 used=2 fp=0xffff8801970caac0 flags=0x8000000000004080
 [76378.725391] Pid: 9156, comm: rmmod Tainted: G B        3.8.0-rc5 #1
 [76378.725397] Call Trace:
 [76378.725403]  [<ffffffff8111bc23>] slab_err+0xb0/0xd2

I think that this message means there is a possibility that I/O did not end
normally.
and, after Miao's patch applied, this message is not displayed when rmmod was
executed.

So, Miao's patch seems to fix the problem for me.

Thanks,
Tsutomu

> 
> Thanks
> Miao
> 
>>
>> Thanks,
>> Tsutomu
>>
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 0c31d07..d8fd711 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -2728,13 +2728,13 @@ fail_cleaner:
>>>    	 * kthreads
>>>    	 */
>>>    	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>>> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>>>    
>>>    fail_block_groups:
>>>    	btrfs_free_block_groups(fs_info);
>>>    
>>>    fail_tree_roots:
>>>    	free_root_pointers(fs_info, 1);
>>> +	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>>>    
>>>    fail_sb_buffer:
>>>    	btrfs_stop_workers(&fs_info->generic_worker);
>>> @@ -2755,7 +2755,6 @@ fail_alloc:
>>>    fail_iput:
>>>    	btrfs_mapping_tree_free(&fs_info->mapping_tree);
>>>    
>>> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>>>    	iput(fs_info->btree_inode);
>>>    fail_bdi:
>>>    	bdi_destroy(&fs_info->bdi);
>>>


