Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36762 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbbFIM4m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 08:56:42 -0400
Received: by igbpi8 with SMTP id pi8so11122496igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2015 05:56:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1433851471-11543-2-git-send-email-bo.li.liu@oracle.com>
References: <1433851471-11543-1-git-send-email-bo.li.liu@oracle.com>
	<1433851471-11543-2-git-send-email-bo.li.liu@oracle.com>
Date: Tue, 9 Jun 2015 13:56:41 +0100
Message-ID: <CAL3q7H6ULsBGUy=EEYZnHQqj8rhL_=1BLgC1MgB4=FUavz1EhQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] Btrfs: improve fsync for nocow file
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 9, 2015 at 1:04 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> If  we're overwriting an allocated file without changing timestamp
> and inode version, and the file is with NODATACOW, we don't have any metadata to
> commit, thus we can just flush the data device cache and go forward.
>
> However, if there's have any change on extents' disk bytenr, inode size,
> timestamp or inode version, we need to go through the normal btrfs_log_inode
> path.
>
> Test:
> ----------------------------
> 1. sysbench test of
> "1 file + 1 thread + bs=4k + size=40k + synchronous I/O mode + randomwrite +
> fsync_on_each_write",
> 2. loop device associated with tmpfs file
> 3.
>   - For btrfs, "-o nodatacow" and "-o noi_version" option
>   - For ext4 and xfs, no extra mount options
> ----------------------------
>
> Results:
> ----------------------------
> - btrfs:
> w/o: ~30Mb/sec
> w:   ~181Mb/sec
>
> - other filesystems: (both don't enable i_version by default)
> ext4:  203Mb/sec
> xfs:   212Mb/sec
> ----------------------------
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/btrfs_inode.h |  2 ++
>  fs/btrfs/disk-io.c     |  2 +-
>  fs/btrfs/disk-io.h     |  1 +
>  fs/btrfs/file.c        | 39 ++++++++++++++++++++++++++++++++++-----
>  fs/btrfs/inode.c       |  3 +++
>  5 files changed, 41 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 0ef5cc1..b36d87a 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -44,6 +44,8 @@
>  #define BTRFS_INODE_IN_DELALLOC_LIST           9
>  #define BTRFS_INODE_READDIO_NEED_LOCK          10
>  #define BTRFS_INODE_HAS_PROPS                  11
> +#define BTRFS_INODE_NOTIMESTAMP                        12
> +#define BTRFS_INODE_NOISIZE                    13
>  /*
>   * The following 3 bits are meant only for the btree inode.
>   * When any of them is set, it means an error happened while writing an
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2ef9a4b..de7fd94 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3343,7 +3343,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
>   * send an empty flush down to each device in parallel,
>   * then wait for them
>   */
> -static int barrier_all_devices(struct btrfs_fs_info *info)
> +int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>         struct list_head *head;
>         struct btrfs_device *dev;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index d4cbfee..2bc91fe 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -60,6 +60,7 @@ void close_ctree(struct btrfs_root *root);
>  int write_ctree_super(struct btrfs_trans_handle *trans,
>                       struct btrfs_root *root, int max_mirrors);
>  struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
> +int barrier_all_devices(struct btrfs_fs_info *info);
>  int btrfs_commit_super(struct btrfs_root *root);
>  struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
>                                             u64 bytenr);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 23b6e03..861c29f 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -519,8 +519,12 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
>          * the disk i_size.  There is no need to log the inode
>          * at this time.
>          */
> -       if (end_pos > isize)
> +       if (end_pos > isize) {
>                 i_size_write(inode, end_pos);
> +               clear_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
> +       } else {
> +               set_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
> +       }
>         return 0;
>  }
>
> @@ -1711,19 +1715,33 @@ out:
>  static void update_time_for_write(struct inode *inode)
>  {
>         struct timespec now;
> +       int sync_it = 0;
>
> -       if (IS_NOCMTIME(inode))
> +       if (IS_NOCMTIME(inode)) {
> +               set_bit(BTRFS_INODE_NOTIMESTAMP, &BTRFS_I(inode)->runtime_flags);
>                 return;
> +       }
>
>         now = current_fs_time(inode->i_sb);
> -       if (!timespec_equal(&inode->i_mtime, &now))
> +       if (!timespec_equal(&inode->i_mtime, &now)) {
>                 inode->i_mtime = now;
> +               sync_it = S_MTIME;
> +       }
>
> -       if (!timespec_equal(&inode->i_ctime, &now))
> +       if (!timespec_equal(&inode->i_ctime, &now)) {
>                 inode->i_ctime = now;
> +               sync_it |= S_CTIME;
> +       }
>
> -       if (IS_I_VERSION(inode))
> +       if (IS_I_VERSION(inode)) {
>                 inode_inc_iversion(inode);
> +               sync_it |= S_VERSION;
> +       }
> +
> +       if (!sync_it)
> +               set_bit(BTRFS_INODE_NOTIMESTAMP, &BTRFS_I(inode)->runtime_flags);
> +       else
> +               clear_bit(BTRFS_INODE_NOTIMESTAMP, &BTRFS_I(inode)->runtime_flags);
>  }
>
>  static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
> @@ -1987,6 +2005,17 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>                 goto out;
>         }
>
> +       if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) {
> +               if (test_and_clear_bit(BTRFS_INODE_NOTIMESTAMP,
> +                                       &BTRFS_I(inode)->runtime_flags) &&
> +                   test_and_clear_bit(BTRFS_INODE_NOISIZE,
> +                                       &BTRFS_I(inode)->runtime_flags)) {
> +                       barrier_all_devices(root->fs_info);
> +                       mutex_unlock(&inode->i_mutex);
> +                       goto out;

Hi Liu,

For the non-full sync case, what happens if an IO error happened
during writeback?
I don't see anything here that checks if an IO error happened and
return -EIO to user space if such error happened.
In other words, testing for the bit AS_EIO in the inode->i_mapping->flags.

thanks

> +               }
> +       }
> +
>         /*
>          * ok we haven't committed the transaction yet, lets do a commit
>          */
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0020b56..3d230e6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1384,6 +1384,7 @@ out_check:
>
>                 btrfs_release_path(path);
>                 if (cow_start != (u64)-1) {
> +                       clear_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
>                         ret = cow_file_range(inode, locked_page,
>                                              cow_start, found_key.offset - 1,
>                                              page_started, nr_written, 1);
> @@ -1426,6 +1427,7 @@ out_check:
>                                                 em->start + em->len - 1, 0);
>                         }
>                         type = BTRFS_ORDERED_PREALLOC;
> +                       clear_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
>                 } else {
>                         type = BTRFS_ORDERED_NOCOW;
>                 }
> @@ -1464,6 +1466,7 @@ out_check:
>         }
>
>         if (cow_start != (u64)-1) {
> +               clear_bit(BTRFS_INODE_NOISIZE, &BTRFS_I(inode)->runtime_flags);
>                 ret = cow_file_range(inode, locked_page, cow_start, end,
>                                      page_started, nr_written, 1);
>                 if (ret)
> --
> 2.1.0
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
