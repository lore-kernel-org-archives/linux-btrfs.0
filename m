Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3AaPhh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 10:37:37 -0500
Message-ID: <510A8FB6.50107@redhat.com>
Date: Thu, 31 Jan 2013 09:37:26 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at fs/btrfs/async-thread.c:605!
References: <5109E70D.3010005@jp.fujitsu.com> <510A0756.40206@redhat.com> <510A243C.3010508@cn.fujitsu.com>
In-Reply-To: <510A243C.3010508@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/31/13 1:58 AM, Miao Xie wrote:
> On wed, 30 Jan 2013 23:55:34 -0600, Eric Sandeen wrote:
>> if you move the fail_block_groups: target above the comment, does that fix it?
>> (although I don't know yet what started IO . . . )
>>
>> like this:
>>
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> Make sure that we are always done with the btree_inode's mapping
>> before we shut down the worker threads in open_ctree() error
>> cases.
> 
> 
> I reviewed your patch again, and found it just fix the above problem, it still
> have similar problems which are not fixed.

Can you explain the similar problems you found?

(Also, the reason I thought a write had been started was because the original
panic was in comm: btrfs-endio-wr[iter])

Thanks,
-Eric

> How about this one?
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0c31d07..d8fd711 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2728,13 +2728,13 @@ fail_cleaner:
>  	 * kthreads
>  	 */
>  	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>  
>  fail_block_groups:
>  	btrfs_free_block_groups(fs_info);
>  
>  fail_tree_roots:
>  	free_root_pointers(fs_info, 1);
> +	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>  
>  fail_sb_buffer:
>  	btrfs_stop_workers(&fs_info->generic_worker);
> @@ -2755,7 +2755,6 @@ fail_alloc:
>  fail_iput:
>  	btrfs_mapping_tree_free(&fs_info->mapping_tree);
>  
> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>  	iput(fs_info->btree_inode);
>  fail_bdi:
>  	bdi_destroy(&fs_info->bdi);
> 

