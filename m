Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33229 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbbC3T3W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 15:29:22 -0400
Received: by ignm3 with SMTP id m3so79333742ign.0
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 12:29:22 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5519A022.9090804@suse.com>
References: <5519A022.9090804@suse.com>
Date: Mon, 30 Mar 2015 20:29:22 +0100
Message-ID: <CAL3q7H6zDd1O3n+PqBMueDOsyuTo6rP7rqGzpD7+ZTckzUba7g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: add missing discards when unpinning extents with,
 -o discard
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 30, 2015 at 8:12 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> The block group removal patch adds an alternate path to forget extents
> other than btrfs_finish_extent_commit. As a result, any extents that would
> be freed when the block group is removed aren't discarded. In my
> test run, with a large copy of mixed sized files followed by removal, it
> left nearly 2/3 of extents undiscarded.
>
> As part of the extent removal review, I also added the discard call to
> btrfs_destroy_pinned_extent.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/disk-io.c     | 7 +++++++
>  fs/btrfs/extent-tree.c | 9 +++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 639f266..f7dfcf8 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4167,6 +4167,13 @@ again:
>                 if (ret)
>                         break;
>
> +               if (btrfs_test_opt(root, DISCARD)) {
> +                       ret = btrfs_discard_extent(root, start,
> +                                                  end + 1 - start, NULL);
> +                       if (ret)
> +                               break;
> +               }
> +

Jeff we can't do a discard here, specially if unpin ==
fs_info->pinned_extents, as explained in:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=678886bdc6378c1cbd5072da2c5a3035000214e3



>                 clear_extent_dirty(unpin, start, end, GFP_NOFS);
>                 btrfs_error_unpin_extent_range(root, start, end);
>                 cond_resched();
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0bf45b8..6a7ff46 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9630,6 +9630,15 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>                  * a BUG_ON() at btrfs_unpin_extent_range().
>                  */
>                 mutex_lock(&fs_info->unused_bg_unpin_mutex);
> +               if (btrfs_test_opt(root, DISCARD)) {
> +                       ret = btrfs_discard_extent(root, start, end + 1 - start,
> +                                                  NULL);
> +                       if (ret) {
> +                               mutex_unlock(&fs_info->unused_bg_unpin_mutex);
> +                               btrfs_set_block_group_rw(root, block_group);
> +                               goto end_trans;
> +                       }
> +               }

This isn't safe either for the similar reason as above. For example,
transaction N running, metadata bg X becomes empty and it's added to
fs_info->unused_bgs, cleaner kthread running and gets bg X from
fs_info->unused_bgs (running btrfs_delete_unused_bgs), does the
discard, power failure, reboot, superblock points to metadata extents
in the physical location of bg X that are now full of zeroes.

thanks

>                 ret = clear_extent_bits(&fs_info->freed_extents[0], start, end,
>                                   EXTENT_DIRTY, GFP_NOFS);
>                 if (ret) {
> --
> 1.8.5.6
>
>
> --
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
