Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27160 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3D0Cui (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 22:50:38 -0400
Date: Sat, 27 Apr 2013 10:50:43 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [bug] 3.9-rc7+next: NULL deref in
 btrfs_next_old_leaf/btrfs_search_slot
Message-ID: <20130427025042.GB999@liubo>
Reply-To: bo.li.liu@oracle.com
References: <20130418144218.GH16427@twin.jikos.cz>
 <20130425171858.GM16427@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130425171858.GM16427@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 25, 2013 at 07:18:59PM +0200, David Sterba wrote:
> On Thu, Apr 18, 2013 at 04:42:18PM +0200, David Sterba wrote:
> > [64394.422743] BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
> > [64394.426716] RIP: 0010:[<ffffffffa0010e0f>]  [<ffffffffa0010e0f>] btrfs_search_slot+0xbf/0x9e0 [btrfs]
> > [64394.426716]  [<ffffffffa0014977>] btrfs_next_old_leaf+0x247/0x4e0 [btrfs]
> > [64394.426716]  [<ffffffffa0014c20>] btrfs_next_leaf+0x10/0x20 [btrfs]
> 
> The bisection set was reduced to these patches (on top of
> cmason/for-linus 4bc4bee45):
> 
> 1  Btrfs: cleanup unused function				Liu Bo
> 2  btrfs: enhance superblock checks				David Sterba
> 3  Btrfs: add some free space cache tests			Josef Bacik
> 4  btrfs: merge save_error_info helpers into one		David Sterba
> 5  btrfs: clean up transaction abort messages			David Sterba
> 6  Btrfs: cleanup unused arguments of btrfs_csum_data		Liu Bo
> 7  Btrfs: use helper to cleanup tree roots			Liu Bo
> 8  Btrfs: add a incompatible format change for smaller metadata extent ref  Josef Bacik
> 
> The bisecting process points to patch 8, ie the 'first bad', but the
> reproducer has proved to be unreliable and I think it's very sensitive
> to scheduling timing.
> 
> Reproducer is to simply run 273 in a loop on a single/single filesystem,
> the null deref happens during umount. The tricky part is that it does not
> happen every time, I must not touch the testbox nor let any process run
> except 'dstat'. It usually crashed on first or second test run, but I've
> left it up to 10 to be sure.
> 
> I don't think it's caused by the skinny metadata, because it does not
> touch the affected functions, but somehow helps to make it visible.
> 
> Although the test never crashed when patch 7
>   Btrfs: use helper to cleanup tree roots
>   http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=3fa215686c574d26f43f1bcf6c9f69658e02908f
> was on top (I once left it running overnight, all fine), that's my main
> suspect:
> 
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3483,20 +3483,7 @@ int close_ctree(struct btrfs_root *root)
>  		       percpu_counter_sum(&fs_info->delalloc_bytes));
>  	}
>  
> -	free_extent_buffer(fs_info->extent_root->node);
> -	free_extent_buffer(fs_info->extent_root->commit_root);
> -	free_extent_buffer(fs_info->tree_root->node);
> -	free_extent_buffer(fs_info->tree_root->commit_root);
> -	free_extent_buffer(fs_info->chunk_root->node);
> -	free_extent_buffer(fs_info->chunk_root->commit_root);
> -	free_extent_buffer(fs_info->dev_root->node);
> -	free_extent_buffer(fs_info->dev_root->commit_root);
> -	free_extent_buffer(fs_info->csum_root->node);
> -	free_extent_buffer(fs_info->csum_root->commit_root);
> -	if (fs_info->quota_root) {
> -		free_extent_buffer(fs_info->quota_root->node);
> -		free_extent_buffer(fs_info->quota_root->commit_root);
> -	}
> +	free_root_pointers(fs_info, 1);
> 
> and if you look what free_root_pointers does, sets all the pointers to NULL.
> 
> The crash site:
> 
> gdb) l *(btrfs_search_slot+0xb6)
> 0x11076 is in btrfs_search_slot (/home/dsterba/linux-2.6/arch/x86/include/asm/atomic.h:95).
> 90       *
> 91       * Atomically increments @v by 1.
> 92       */
> 93      static inline void atomic_inc(atomic_t *v)
> 94      {
> 95              asm volatile(LOCK_PREFIX "incl %0"
> 96                           : "+m" (v->counter));
> 97      }
> 
> (gdb) l *(btrfs_search_slot+0xb5)
> 0x11075 is in btrfs_search_slot (fs/btrfs/ctree.c:2513).
> 2508            if (p->search_commit_root) {
> 2509                    /*
> 2510                     * the commit roots are read only
> 2511                     * so we always do read locks
> 2512                     */
> 2513                    b = root->commit_root;
> 2514                    extent_buffer_get(b);
> 2515                    level = btrfs_header_level(b);
> 2516                    if (!p->skip_locking)
> 2517                            btrfs_tree_read_lock(b);
> 
> so it's the extent_buffer_get() call, the offset of ->refs field is 120 = 0x78,
> matches "NULL pointer dereference at 0000000000000078". So root->commit_root
> is NULL.
> 
> If we look what happens in disk-io.c::close_ctree:
> 
> 3476         fs_info->closing = 2;
> 3477         smp_mb();
> ...
> 3486         free_root_pointers(fs_info, 1);
> 3487
> 3488         btrfs_free_block_groups(fs_info);
> 3489
> 3490         del_fs_roots(fs_info);
> 3491
> 3492         iput(fs_info->btree_inode);
> 3493
> 3494         btrfs_stop_workers(&fs_info->generic_worker);
> ...
> 3507         btrfs_stop_workers(&fs_info->caching_workers);
> 
> Line 3477 assures that caching thread will exit the main loop when it sees
> fs_closing > 1, but if it's past this check yet has to do some work, and
> close_tree() calls free_root_pointers(), bang. As we can see the caching thread
> goes down later.
> 
> What I see here is a use-after-free that has been undetected so far and only
> exposed by patch 7.
> 
> This diff looks like the fix (on top of patch 8):
> 
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3486,14 +3486,14 @@ int close_ctree(struct btrfs_root *root)
>                        percpu_counter_sum(&fs_info->delalloc_bytes));
>         }
> 
> -       free_root_pointers(fs_info, 1);
> -
>         btrfs_free_block_groups(fs_info);
> 
>         del_fs_roots(fs_info);
> 
>         iput(fs_info->btree_inode);
> 
> +       free_root_pointers(fs_info, 1);
> +
>         btrfs_stop_workers(&fs_info->generic_worker);
>         btrfs_stop_workers(&fs_info->fixup_workers);
>         btrfs_stop_workers(&fs_info->delalloc_workers);
> ---
> 
> 
> david

Thanks for tracking it Dave, I'm trying to reproduce it here.

thanks,
liubo
