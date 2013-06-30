Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:46812 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab3F3IZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 04:25:08 -0400
Message-ID: <51CFEB61.1040008@jan-o-sch.net>
Date: Sun, 30 Jun 2013 10:25:05 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: hold the tree mod lock in __tree_mod_log_rewind
References: <1372562251-27123-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372562251-27123-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30.06.2013 05:17, Josef Bacik wrote:
> We need to hold the tree mod log lock in __tree_mod_log_rewind since we walk
> forward in the tree mod entries, otherwise we'll end up with random entries and
> trip the BUG_ON() at the front of __tree_mod_log_rewind.  This fixes the panics
> people were seeing when running
> 
> find /whatever -type f -exec btrfs fi defrag {} \;

This patch cannot help to solve the problem, as far as I've understood
what is going on. It does change timing, though, which presumably makes
it pass the current reproducer we're having.

On rewinding, iteration through the tree mod log rb-tree goes backwards
in time, which means that once we've found our staring point we cannot
be trapped by later additions. The old items we're rewinding towards
cannot be freed, because we've allocated a blocker element within the
tree and rewinding never goes beyond the allocated blocker. The blocker
element is allocated by btrfs_get_tree_mod_seq and mostly referred to as
time_seq within the other tree mod log functions in ctree.c. To sum up,
the added lock is not required.

The debug output I've analyzed so far shows that after we've rewinded
all REMOVE_WHILE_FREEING operations on a buffer, ordered consecutively
as expected, there comes another REMOVE_WHILE_FREEING with a sequence
number much further in the past for the same buffer (but that sequence
number is still higher than out time_seq rewind barrier at that point).
This must be a logical problem I've not completely understood so far,
but locking doesn't seem to be the right track.

Thanks,
-Jan


> Thansk,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/ctree.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index c32d03d..7921e1d 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1161,8 +1161,8 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
>   * time_seq).
>   */
>  static void
> -__tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
> -		      struct tree_mod_elem *first_tm)
> +__tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> +		      u64 time_seq, struct tree_mod_elem *first_tm)
>  {
>  	u32 n;
>  	struct rb_node *next;
> @@ -1172,6 +1172,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
>  	unsigned long p_size = sizeof(struct btrfs_key_ptr);
>  
>  	n = btrfs_header_nritems(eb);
> +	tree_mod_log_read_lock(fs_info);
>  	while (tm && tm->seq >= time_seq) {
>  		/*
>  		 * all the operations are recorded with the operator used for
> @@ -1226,6 +1227,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
>  		if (tm->index != first_tm->index)
>  			break;
>  	}
> +	tree_mod_log_read_unlock(fs_info);
>  	btrfs_set_header_nritems(eb, n);
>  }
>  
> @@ -1274,7 +1276,7 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  
>  	extent_buffer_get(eb_rewin);
>  	btrfs_tree_read_lock(eb_rewin);
> -	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
> +	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
>  	WARN_ON(btrfs_header_nritems(eb_rewin) >
>  		BTRFS_NODEPTRS_PER_BLOCK(fs_info->tree_root));
>  
> @@ -1350,7 +1352,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  		btrfs_set_header_generation(eb, old_generation);
>  	}
>  	if (tm)
> -		__tree_mod_log_rewind(eb, time_seq, tm);
> +		__tree_mod_log_rewind(root->fs_info, eb, time_seq, tm);
>  	else
>  		WARN_ON(btrfs_header_level(eb) != 0);
>  	WARN_ON(btrfs_header_nritems(eb) > BTRFS_NODEPTRS_PER_BLOCK(root));
> 
