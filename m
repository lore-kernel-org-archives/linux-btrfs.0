Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44648 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3BAAbq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 19:31:46 -0500
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D06163EE0B5
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 09:31:43 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id B9A2345DE4F
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 09:31:43 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 898D245DE50
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 09:31:43 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 7A0381DB802F
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 09:31:43 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 3095B1DB803B
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 09:31:43 +0900 (JST)
Message-ID: <510B0CE5.9090601@jp.fujitsu.com>
Date: Fri, 01 Feb 2013 09:31:33 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com, Eric Sandeen <sandeen@redhat.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at fs/btrfs/async-thread.c:605!
References: <5109E70D.3010005@jp.fujitsu.com> <510A0756.40206@redhat.com> <510A243C.3010508@cn.fujitsu.com>
In-Reply-To: <510A243C.3010508@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2013/01/31 16:58, Miao Xie wrote:
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
> 
> How about this one?

Thanks Eric and Miao.
But I can not reproduce this problem, yet.
('Btrfs: too many missing devices, writeable mount is not allowed' messages was
 displayed, but not panic)
 So, I can not test your patch, sorry.

Can you please explain similar problems, Miao?

Thanks,
Tsutomu

> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0c31d07..d8fd711 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2728,13 +2728,13 @@ fail_cleaner:
>   	 * kthreads
>   	 */
>   	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>   
>   fail_block_groups:
>   	btrfs_free_block_groups(fs_info);
>   
>   fail_tree_roots:
>   	free_root_pointers(fs_info, 1);
> +	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>   
>   fail_sb_buffer:
>   	btrfs_stop_workers(&fs_info->generic_worker);
> @@ -2755,7 +2755,6 @@ fail_alloc:
>   fail_iput:
>   	btrfs_mapping_tree_free(&fs_info->mapping_tree);
>   
> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>   	iput(fs_info->btree_inode);
>   fail_bdi:
>   	bdi_destroy(&fs_info->bdi);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


