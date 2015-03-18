Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35908 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbbCRLzw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 07:55:52 -0400
Received: by iegc3 with SMTP id c3so36106167ieg.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 04:55:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1426624683-3085-5-git-send-email-jbacik@fb.com>
References: <1426624683-3085-1-git-send-email-jbacik@fb.com>
	<1426624683-3085-5-git-send-email-jbacik@fb.com>
Date: Wed, 18 Mar 2015 11:55:50 +0000
Message-ID: <CAL3q7H4FfiXrx750zsXQiqVKR_TBJnHLWzmQKroCKLqBk0pxuQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] Btrfs: fix outstanding_extents accounting in DIO
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2015 at 8:38 PM, Josef Bacik <jbacik@fb.com> wrote:
> We are keeping track of how many extents we need to reserve properly based on
> the amount we want to write, but we were still incrementing outstanding_extents
> if we wrote less than what we requested.  This isn't quite right since we will
> be limited to our max extent size.  So instead lets do something horrible!  Keep
> track of how many outstanding_extents we reserved, and decrement each time we
> allocate an extent.  If we use our entire reserve make sure to jack up
> outstanding_extents on the inode so the accounting works out properly.  Thanks,
>
> Reported-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
Tested-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/inode.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3717b3d..aa1fb53 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7239,7 +7239,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>         u64 start = iblock << inode->i_blkbits;
>         u64 lockstart, lockend;
>         u64 len = bh_result->b_size;
> -       u64 orig_len = len;
> +       u64 *outstanding_extents = NULL;
>         int unlock_bits = EXTENT_LOCKED;
>         int ret = 0;
>
> @@ -7251,6 +7251,16 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>         lockstart = start;
>         lockend = start + len - 1;
>
> +       if (current->journal_info) {
> +               /*
> +                * Need to pull our outstanding extents and set journal_info to NULL so
> +                * that anything that needs to check if there's a transction doesn't get
> +                * confused.
> +                */
> +               outstanding_extents = current->journal_info;
> +               current->journal_info = NULL;
> +       }
> +
>         /*
>          * If this errors out it's because we couldn't invalidate pagecache for
>          * this range and we need to fallback to buffered.
> @@ -7374,11 +7384,20 @@ unlock:
>                 if (start + len > i_size_read(inode))
>                         i_size_write(inode, start + len);
>
> -               if (len < orig_len) {
> +               /*
> +                * If we have an outstanding_extents count still set then we're
> +                * within our reservation, otherwise we need to adjust our inode
> +                * counter appropriately.
> +                */
> +               if (*outstanding_extents) {
> +                       (*outstanding_extents)--;
> +               } else {
>                         spin_lock(&BTRFS_I(inode)->lock);
>                         BTRFS_I(inode)->outstanding_extents++;
>                         spin_unlock(&BTRFS_I(inode)->lock);
>                 }
> +
> +               current->journal_info = outstanding_extents;
>                 btrfs_free_reserved_data_space(inode, len);
>         }
>
> @@ -7402,6 +7421,8 @@ unlock:
>  unlock_err:
>         clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
>                          unlock_bits, 1, 0, &cached_state, GFP_NOFS);
> +       if (outstanding_extents)
> +               current->journal_info = outstanding_extents;
>         return ret;
>  }
>
> @@ -8101,6 +8122,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
>  {
>         struct file *file = iocb->ki_filp;
>         struct inode *inode = file->f_mapping->host;
> +       u64 outstanding_extents = 0;
>         size_t count = 0;
>         int flags = 0;
>         bool wakeup = true;
> @@ -8138,6 +8160,16 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
>                 ret = btrfs_delalloc_reserve_space(inode, count);
>                 if (ret)
>                         goto out;
> +               outstanding_extents = div64_u64(count +
> +                                               BTRFS_MAX_EXTENT_SIZE - 1,
> +                                               BTRFS_MAX_EXTENT_SIZE);
> +
> +               /*
> +                * We need to know how many extents we reserved so that we can
> +                * do the accounting properly if we go over the number we
> +                * originally calculated.  Abuse current->journal_info for this.
> +                */
> +               current->journal_info = &outstanding_extents;
>         } else if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
>                                      &BTRFS_I(inode)->runtime_flags)) {
>                 inode_dio_done(inode);
> @@ -8150,6 +8182,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
>                         iter, offset, btrfs_get_blocks_direct, NULL,
>                         btrfs_submit_direct, flags);
>         if (rw & WRITE) {
> +               current->journal_info = NULL;
>                 if (ret < 0 && ret != -EIOCBQUEUED)
>                         btrfs_delalloc_release_space(inode, count);
>                 else if (ret >= 0 && (size_t)ret < count)
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
