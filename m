Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33976 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936857AbdAFLwh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jan 2017 06:52:37 -0500
Received: by mail-io0-f196.google.com with SMTP id n85so39263093ioi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jan 2017 03:52:32 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 6 Jan 2017 11:45:46 +0000
Message-ID: <CAL3q7H4PgaJFnZPkgMMS5_9V3=3EJ8j1hbPZbBp+AcpYWQs2ww@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: Fix deadlock between direct IO and fast fsync
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 23, 2016 at 9:30 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> The following deadlock is seen when executing generic/113 test,
>
>  ---------------------------------------------------------+----------------------------------------------------
>   Direct I/O task                                           Fast fsync task
>  ---------------------------------------------------------+----------------------------------------------------
>   btrfs_direct_IO
>     __blockdev_direct_IO
>      do_blockdev_direct_IO
>       do_direct_IO
>        btrfs_get_blocks_direct
>         while (blocks needs to written)
>          get_more_blocks (first iteration)
>           btrfs_get_blocks_direct
>            btrfs_create_dio_extent
>              down_read(&BTRFS_I(inode) >dio_sem)
>              Create and add extent map and ordered extent
>              up_read(&BTRFS_I(inode) >dio_sem)
>                                                             btrfs_sync_file
>                                                               btrfs_log_dentry_safe
>                                                                btrfs_log_inode_parent
>                                                                 btrfs_log_inode
>                                                                  btrfs_log_changed_extents
>                                                                   down_write(&BTRFS_I(inode) >dio_sem)
>                                                                    Collect new extent maps and ordered extents
>                                                                     wait for ordered extent completion
>          get_more_blocks (second iteration)
>           btrfs_get_blocks_direct
>            btrfs_create_dio_extent
>              down_read(&BTRFS_I(inode) >dio_sem)
>  --------------------------------------------------------------------------------------------------------------
>
> In the above description, Btrfs direct I/O code path has not yet started
> submitting bios for file range covered by the initial ordered
> extent. Meanwhile, The fast fsync task obtains the write semaphore and
> waits for I/O on the ordered extent to get completed. However, the
> Direct I/O task is now blocked on obtaining the read semaphore.
>
> To resolve the deadlock, this commit modifies the Direct I/O code path
> to obtain the read semaphore before invoking
> __blockdev_direct_IO(). The semaphore is then given up after
> __blockdev_direct_IO() returns. This allows the Direct I/O code to
> complete I/O on all the ordered extents it creates.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

As pointed out by Liu Bo, this was known, discussed and with a
proposed fix in another older thread:
https://www.marc.info/?l=linux-btrfs&m=147998603528213&w=2

I was on vacations and waiting for Josef's feedback as well (cc'ed but
never replied) before making a change log and formalizing the proposed
patch in that thread.

>From my point of view, it's ok and you can have:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

thanks

> ---
>  fs/btrfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5ca88f0..f796037 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7325,7 +7325,6 @@ static struct extent_map *btrfs_create_dio_extent(struct inode *inode,
>         struct extent_map *em = NULL;
>         int ret;
>
> -       down_read(&BTRFS_I(inode)->dio_sem);
>         if (type != BTRFS_ORDERED_NOCOW) {
>                 em = create_pinned_em(inode, start, len, orig_start,
>                                       block_start, block_len, orig_block_len,
> @@ -7344,7 +7343,6 @@ static struct extent_map *btrfs_create_dio_extent(struct inode *inode,
>                 em = ERR_PTR(ret);
>         }
>   out:
> -       up_read(&BTRFS_I(inode)->dio_sem);
>
>         return em;
>  }
> @@ -8800,6 +8798,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>                 dio_data.unsubmitted_oe_range_start = (u64)offset;
>                 dio_data.unsubmitted_oe_range_end = (u64)offset;
>                 current->journal_info = &dio_data;
> +               down_read(&BTRFS_I(inode)->dio_sem);
>         } else if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
>                                      &BTRFS_I(inode)->runtime_flags)) {
>                 inode_dio_end(inode);
> @@ -8812,6 +8811,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>                                    iter, btrfs_get_blocks_direct, NULL,
>                                    btrfs_submit_direct, flags);
>         if (iov_iter_rw(iter) == WRITE) {
> +               up_read(&BTRFS_I(inode)->dio_sem);
>                 current->journal_info = NULL;
>                 if (ret < 0 && ret != -EIOCBQUEUED) {
>                         if (dio_data.reserve)
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
