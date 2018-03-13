Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39174 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752689AbeCMPay (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 11:30:54 -0400
Subject: Re: [PATCH 02/22] btrfs: assume that prev_em_start is always valid in
 __do_readpage
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1520518876.git.dsterba@suse.com>
 <f92bec1a7defa40fe7c51a4d570e45f419d0c9df.1520518876.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <46bf43fc-6fd2-3199-9b5d-3bbb768bba2f@oracle.com>
Date: Tue, 13 Mar 2018 23:03:31 +0800
MIME-Version: 1.0
In-Reply-To: <f92bec1a7defa40fe7c51a4d570e45f419d0c9df.1520518876.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/08/2018 10:33 PM, David Sterba wrote:
> All callers pass a valid pointer, we can remove the redundant checks.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/extent_io.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d00d5a59ff21..36514baa661e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2875,6 +2875,8 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
>    * handlers)
>    * XXX JDM: This needs looking at to ensure proper page locking
>    * return 0 on success, otherwise return error
> + *
> + * @prev_em_start:	return value of previous em start value; must be valid
>    */
>   static int __do_readpage(struct extent_io_tree *tree,
>   			 struct page *page,
> @@ -2903,6 +2905,8 @@ static int __do_readpage(struct extent_io_tree *tree,
>   	size_t blocksize = inode->i_sb->s_blocksize;
>   	unsigned long this_bio_flag = 0;
>   
> +	ASSERT(prev_em_start);
> +


mount is failing with this patch as in this stack below the 
prev_em_start is NULL.

--------
static int __extent_read_full_page(struct extent_io_tree *tree,
                                    struct page *page,
                                    get_extent_t *get_extent,
                                    struct bio **bio, int mirror_num,
                                    unsigned long *bio_flags,
                                    unsigned int read_flags)
{
::
         ret = __do_readpage(tree, page, get_extent, NULL, bio, mirror_num,
                             bio_flags, read_flags, NULL);


----------
  kernel: assertion failed: prev_em_start, file: fs/btrfs/extent_io.c, 
line: 2911
  kernel: ------------[ cut here ]------------
  kernel: kernel BUG at fs/btrfs/ctree.h:3462!

  kernel:  __do_readpage+0x7f/0x7e0 [btrfs]
  kernel:  ? btree_fs_info+0x20/0x20 [btrfs]
  kernel:  ? mark_held_locks+0x65/0x80
  kernel:  ? _raw_spin_unlock_irq+0x29/0x40
  kernel:  __extent_read_full_page+0xe7/0x100 [btrfs]
  kernel:  ? btree_fs_info+0x20/0x20 [btrfs]
  kernel:  read_extent_buffer_pages+0x1af/0x2b0 [btrfs]
  kernel:  btree_read_extent_buffer_pages+0x4f/0xe0 [btrfs]
  kernel:  read_tree_block+0x31/0x60 [btrfs]
  kernel:  ? __raw_spin_lock_init+0x2d/0x50
  kernel:  open_ctree+0x19a2/0x25f0 [btrfs]
  kernel:  btrfs_mount_root+0x465/0x720 [btrfs]
  kernel:  ? __lockdep_init_map+0xb6/0x1d0
  kernel:  ? mount_fs+0x89/0x130
  kernel:  ? __init_waitqueue_head+0x36/0x50
  kernel:  mount_fs+0x89/0x130
  kernel:  vfs_kern_mount+0x69/0x160
---------

Thanks, Anand



>   	set_page_extent_mapped(page);
>   
>   	end = page_end;
> @@ -3012,12 +3016,11 @@ static int __do_readpage(struct extent_io_tree *tree,
>   		 * non-optimal behavior (submitting 2 bios for the same extent).
>   		 */
>   		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
> -		    prev_em_start && *prev_em_start != (u64)-1 &&
> +		    *prev_em_start != (u64)-1 &&
>   		    *prev_em_start != em->orig_start)
>   			force_bio_submit = true;
>   
> -		if (prev_em_start)
> -			*prev_em_start = em->orig_start;
> +		*prev_em_start = em->orig_start;
>   
>   		free_extent_map(em);
>   		em = NULL;
> 
