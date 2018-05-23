Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:43365 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbeEWPxt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 11:53:49 -0400
Received: by mail-vk0-f66.google.com with SMTP id x191-v6so13434530vke.10
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 08:53:48 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180522174723.13620-2-josef@toxicpanda.com>
References: <20180522174723.13620-1-josef@toxicpanda.com> <20180522174723.13620-2-josef@toxicpanda.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 23 May 2018 16:53:47 +0100
Message-ID: <CAL3q7H7aR3tXZVbK-TCAJ9ayXVa4+jvkoiH4W5ZGspKSd2xpBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: always wait on ordered extents at fsync time
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 6:47 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> From: Josef Bacik <jbacik@fb.com>
>
> There's a priority inversion that exists currently with btrfs fsync.  In
> some cases we will collect outstanding ordered extents onto a list and
> only wait on them at the very last second.  However this "very last
> second" falls inside of a transaction handle, so if we are in a lower
> priority cgroup we can end up holding the transaction open for longer
> than needed, so if a high priority cgroup is also trying to fsync()
> it'll see latency.
>
> Fix this by getting rid of all of the logged extents magic and simply
> wait on ordered extent before we star the tree log stuff.  This code has
> changed a lot since I first wrote it and really isn't the performance
> win it was originally because of the things we had to do around getting
> the right checksums.  Killing all of this makes our lives easier and
> gets rid of the priority inversion.

Much easier!

>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good to me.
Happy to see all that complexity go away and knowing it no longer
offers any benefit.

> ---
>  fs/btrfs/file.c              |  56 ++-------------
>  fs/btrfs/ordered-data.c      | 123 --------------------------------
>  fs/btrfs/ordered-data.h      |  20 +-----
>  fs/btrfs/tree-log.c          | 166 ++++---------------------------------------
>  include/trace/events/btrfs.h |   1 -
>  5 files changed, 19 insertions(+), 347 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 5772f0cbedef..2b1c36612384 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2069,53 +2069,12 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>         atomic_inc(&root->log_batch);
>         full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>                              &BTRFS_I(inode)->runtime_flags);
> +
>         /*
> -        * We might have have had more pages made dirty after calling
> -        * start_ordered_ops and before acquiring the inode's i_mutex.
> +        * We have to do this here to avoid the priority inversion of waiting on
> +        * IO of a lower priority task while holding a transaciton open.
>          */
> -       if (full_sync) {
> -               /*
> -                * For a full sync, we need to make sure any ordered operations
> -                * start and finish before we start logging the inode, so that
> -                * all extents are persisted and the respective file extent
> -                * items are in the fs/subvol btree.
> -                */
> -               ret = btrfs_wait_ordered_range(inode, start, len);
> -       } else {
> -               /*
> -                * Start any new ordered operations before starting to log the
> -                * inode. We will wait for them to finish in btrfs_sync_log().
> -                *
> -                * Right before acquiring the inode's mutex, we might have new
> -                * writes dirtying pages, which won't immediately start the
> -                * respective ordered operations - that is done through the
> -                * fill_delalloc callbacks invoked from the writepage and
> -                * writepages address space operations. So make sure we start
> -                * all ordered operations before starting to log our inode. Not
> -                * doing this means that while logging the inode, writeback
> -                * could start and invoke writepage/writepages, which would call
> -                * the fill_delalloc callbacks (cow_file_range,
> -                * submit_compressed_extents). These callbacks add first an
> -                * extent map to the modified list of extents and then create
> -                * the respective ordered operation, which means in
> -                * tree-log.c:btrfs_log_inode() we might capture all existing
> -                * ordered operations (with btrfs_get_logged_extents()) before
> -                * the fill_delalloc callback adds its ordered operation, and by
> -                * the time we visit the modified list of extent maps (with
> -                * btrfs_log_changed_extents()), we see and process the extent
> -                * map they created. We then use the extent map to construct a
> -                * file extent item for logging without waiting for the
> -                * respective ordered operation to finish - this file extent
> -                * item points to a disk location that might not have yet been
> -                * written to, containing random data - so after a crash a log
> -                * replay will make our inode have file extent items that point
> -                * to disk locations containing invalid data, as we returned
> -                * success to userspace without waiting for the respective
> -                * ordered operation to finish, because it wasn't captured by
> -                * btrfs_get_logged_extents().
> -                */
> -               ret = start_ordered_ops(inode, start, end);
> -       }
> +       ret = btrfs_wait_ordered_range(inode, start, len);
>         if (ret) {
>                 inode_unlock(inode);
>                 goto out;
> @@ -2240,13 +2199,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>                                 goto out;
>                         }
>                 }
> -               if (!full_sync) {
> -                       ret = btrfs_wait_ordered_range(inode, start, len);
> -                       if (ret) {
> -                               btrfs_end_transaction(trans);
> -                               goto out;
> -                       }
> -               }
>                 ret = btrfs_commit_transaction(trans);
>         } else {
>                 ret = btrfs_end_transaction(trans);
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 6db8bb2f2c28..88f858baf87d 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -427,129 +427,6 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
>         return ret == 0;
>  }
>
> -/* Needs to either be called under a log transaction or the log_mutex */
> -void btrfs_get_logged_extents(struct btrfs_inode *inode,
> -                             struct list_head *logged_list,
> -                             const loff_t start,
> -                             const loff_t end)
> -{
> -       struct btrfs_ordered_inode_tree *tree;
> -       struct btrfs_ordered_extent *ordered;
> -       struct rb_node *n;
> -       struct rb_node *prev;
> -
> -       tree = &inode->ordered_tree;
> -       spin_lock_irq(&tree->lock);
> -       n = __tree_search(&tree->tree, end, &prev);
> -       if (!n)
> -               n = prev;
> -       for (; n; n = rb_prev(n)) {
> -               ordered = rb_entry(n, struct btrfs_ordered_extent, rb_node);
> -               if (ordered->file_offset > end)
> -                       continue;
> -               if (entry_end(ordered) <= start)
> -                       break;
> -               if (test_and_set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags))
> -                       continue;
> -               list_add(&ordered->log_list, logged_list);
> -               refcount_inc(&ordered->refs);
> -       }
> -       spin_unlock_irq(&tree->lock);
> -}
> -
> -void btrfs_put_logged_extents(struct list_head *logged_list)
> -{
> -       struct btrfs_ordered_extent *ordered;
> -
> -       while (!list_empty(logged_list)) {
> -               ordered = list_first_entry(logged_list,
> -                                          struct btrfs_ordered_extent,
> -                                          log_list);
> -               list_del_init(&ordered->log_list);
> -               btrfs_put_ordered_extent(ordered);
> -       }
> -}
> -
> -void btrfs_submit_logged_extents(struct list_head *logged_list,
> -                                struct btrfs_root *log)
> -{
> -       int index = log->log_transid % 2;
> -
> -       spin_lock_irq(&log->log_extents_lock[index]);
> -       list_splice_tail(logged_list, &log->logged_list[index]);
> -       spin_unlock_irq(&log->log_extents_lock[index]);
> -}
> -
> -void btrfs_wait_logged_extents(struct btrfs_trans_handle *trans,
> -                              struct btrfs_root *log, u64 transid)
> -{
> -       struct btrfs_ordered_extent *ordered;
> -       int index = transid % 2;
> -
> -       spin_lock_irq(&log->log_extents_lock[index]);
> -       while (!list_empty(&log->logged_list[index])) {
> -               struct inode *inode;
> -               ordered = list_first_entry(&log->logged_list[index],
> -                                          struct btrfs_ordered_extent,
> -                                          log_list);
> -               list_del_init(&ordered->log_list);
> -               inode = ordered->inode;
> -               spin_unlock_irq(&log->log_extents_lock[index]);
> -
> -               if (!test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags) &&
> -                   !test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags)) {
> -                       u64 start = ordered->file_offset;
> -                       u64 end = ordered->file_offset + ordered->len - 1;
> -
> -                       WARN_ON(!inode);
> -                       filemap_fdatawrite_range(inode->i_mapping, start, end);
> -               }
> -               wait_event(ordered->wait, test_bit(BTRFS_ORDERED_IO_DONE,
> -                                                  &ordered->flags));
> -
> -               /*
> -                * In order to keep us from losing our ordered extent
> -                * information when committing the transaction we have to make
> -                * sure that any logged extents are completed when we go to
> -                * commit the transaction.  To do this we simply increase the
> -                * current transactions pending_ordered counter and decrement it
> -                * when the ordered extent completes.
> -                */
> -               if (!test_bit(BTRFS_ORDERED_COMPLETE, &ordered->flags)) {
> -                       struct btrfs_ordered_inode_tree *tree;
> -
> -                       tree = &BTRFS_I(inode)->ordered_tree;
> -                       spin_lock_irq(&tree->lock);
> -                       if (!test_bit(BTRFS_ORDERED_COMPLETE, &ordered->flags)) {
> -                               set_bit(BTRFS_ORDERED_PENDING, &ordered->flags);
> -                               atomic_inc(&trans->transaction->pending_ordered);
> -                       }
> -                       spin_unlock_irq(&tree->lock);
> -               }
> -               btrfs_put_ordered_extent(ordered);
> -               spin_lock_irq(&log->log_extents_lock[index]);
> -       }
> -       spin_unlock_irq(&log->log_extents_lock[index]);
> -}
> -
> -void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid)
> -{
> -       struct btrfs_ordered_extent *ordered;
> -       int index = transid % 2;
> -
> -       spin_lock_irq(&log->log_extents_lock[index]);
> -       while (!list_empty(&log->logged_list[index])) {
> -               ordered = list_first_entry(&log->logged_list[index],
> -                                          struct btrfs_ordered_extent,
> -                                          log_list);
> -               list_del_init(&ordered->log_list);
> -               spin_unlock_irq(&log->log_extents_lock[index]);
> -               btrfs_put_ordered_extent(ordered);
> -               spin_lock_irq(&log->log_extents_lock[index]);
> -       }
> -       spin_unlock_irq(&log->log_extents_lock[index]);
> -}
> -
>  /*
>   * used to drop a reference on an ordered extent.  This will free
>   * the extent if the last reference is dropped
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 3be443fb3001..b2d3f6a091f7 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -54,15 +54,11 @@ struct btrfs_ordered_sum {
>  #define BTRFS_ORDERED_UPDATED_ISIZE 7 /* indicates whether this ordered extent
>                                        * has done its due diligence in updating
>                                        * the isize. */
> -#define BTRFS_ORDERED_LOGGED_CSUM 8 /* We've logged the csums on this ordered
> -                                      ordered extent */
> -#define BTRFS_ORDERED_TRUNCATED 9 /* Set when we have to truncate an extent */
> +#define BTRFS_ORDERED_TRUNCATED 8 /* Set when we have to truncate an extent */
>
> -#define BTRFS_ORDERED_LOGGED 10 /* Set when we've waited on this ordered extent
> -                                * in the logging code. */
> -#define BTRFS_ORDERED_PENDING 11 /* We are waiting for this ordered extent to
> +#define BTRFS_ORDERED_PENDING 9 /* We are waiting for this ordered extent to
>                                   * complete in the current transaction. */
> -#define BTRFS_ORDERED_REGULAR 12 /* Regular IO for COW */
> +#define BTRFS_ORDERED_REGULAR 10 /* Regular IO for COW */
>
>  struct btrfs_ordered_extent {
>         /* logical offset in the file */
> @@ -193,16 +189,6 @@ u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
>                                const u64 range_start, const u64 range_len);
>  u64 btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
>                               const u64 range_start, const u64 range_len);
> -void btrfs_get_logged_extents(struct btrfs_inode *inode,
> -                             struct list_head *logged_list,
> -                             const loff_t start,
> -                             const loff_t end);
> -void btrfs_put_logged_extents(struct list_head *logged_list);
> -void btrfs_submit_logged_extents(struct list_head *logged_list,
> -                                struct btrfs_root *log);
> -void btrfs_wait_logged_extents(struct btrfs_trans_handle *trans,
> -                              struct btrfs_root *log, u64 transid);
> -void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid);
>  int __init ordered_data_init(void);
>  void __cold ordered_data_exit(void);
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 43758e30aa7a..ab9461a07fc6 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2936,7 +2936,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>         /* bail out if we need to do a full commit */
>         if (btrfs_need_log_full_commit(fs_info, trans)) {
>                 ret = -EAGAIN;
> -               btrfs_free_logged_extents(log, log_transid);
>                 mutex_unlock(&root->log_mutex);
>                 goto out;
>         }
> @@ -2954,7 +2953,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>         if (ret) {
>                 blk_finish_plug(&plug);
>                 btrfs_abort_transaction(trans, ret);
> -               btrfs_free_logged_extents(log, log_transid);
>                 btrfs_set_log_full_commit(fs_info, trans);
>                 mutex_unlock(&root->log_mutex);
>                 goto out;
> @@ -3008,7 +3006,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>                         goto out;
>                 }
>                 btrfs_wait_tree_log_extents(log, mark);
> -               btrfs_free_logged_extents(log, log_transid);
>                 mutex_unlock(&log_root_tree->log_mutex);
>                 ret = -EAGAIN;
>                 goto out;
> @@ -3026,7 +3023,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>         if (atomic_read(&log_root_tree->log_commit[index2])) {
>                 blk_finish_plug(&plug);
>                 ret = btrfs_wait_tree_log_extents(log, mark);
> -               btrfs_wait_logged_extents(trans, log, log_transid);
>                 wait_log_commit(log_root_tree,
>                                 root_log_ctx.log_transid);
>                 mutex_unlock(&log_root_tree->log_mutex);
> @@ -3051,7 +3047,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>         if (btrfs_need_log_full_commit(fs_info, trans)) {
>                 blk_finish_plug(&plug);
>                 btrfs_wait_tree_log_extents(log, mark);
> -               btrfs_free_logged_extents(log, log_transid);
>                 mutex_unlock(&log_root_tree->log_mutex);
>                 ret = -EAGAIN;
>                 goto out_wake_log_root;
> @@ -3064,7 +3059,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>         if (ret) {
>                 btrfs_set_log_full_commit(fs_info, trans);
>                 btrfs_abort_transaction(trans, ret);
> -               btrfs_free_logged_extents(log, log_transid);
>                 mutex_unlock(&log_root_tree->log_mutex);
>                 goto out_wake_log_root;
>         }
> @@ -3074,11 +3068,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>                                                   EXTENT_NEW | EXTENT_DIRTY);
>         if (ret) {
>                 btrfs_set_log_full_commit(fs_info, trans);
> -               btrfs_free_logged_extents(log, log_transid);
>                 mutex_unlock(&log_root_tree->log_mutex);
>                 goto out_wake_log_root;
>         }
> -       btrfs_wait_logged_extents(trans, log, log_transid);
>
>         btrfs_set_super_log_root(fs_info->super_for_commit,
>                                  log_root_tree->node->start);
> @@ -3163,14 +3155,6 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
>                                   EXTENT_DIRTY | EXTENT_NEW | EXTENT_NEED_WAIT);
>         }
>
> -       /*
> -        * We may have short-circuited the log tree with the full commit logic
> -        * and left ordered extents on our list, so clear these out to keep us
> -        * from leaking inodes and memory.
> -        */
> -       btrfs_free_logged_extents(log, 0);
> -       btrfs_free_logged_extents(log, 1);
> -
>         free_extent_buffer(log->node);
>         kfree(log);
>  }
> @@ -4082,127 +4066,30 @@ static int extent_cmp(void *priv, struct list_head *a, struct list_head *b)
>         return 0;
>  }
>
> -static int wait_ordered_extents(struct btrfs_trans_handle *trans,
> -                               struct inode *inode,
> -                               struct btrfs_root *root,
> -                               const struct extent_map *em,
> -                               const struct list_head *logged_list,
> -                               bool *ordered_io_error)
> +static int log_extent_csums(struct btrfs_trans_handle *trans,
> +                           struct btrfs_inode *inode,
> +                           struct btrfs_root *root,
> +                           const struct extent_map *em)
>  {
>         struct btrfs_fs_info *fs_info = root->fs_info;
> -       struct btrfs_ordered_extent *ordered;
>         struct btrfs_root *log = root->log_root;
> -       u64 mod_start = em->mod_start;
> -       u64 mod_len = em->mod_len;
> -       const bool skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
>         u64 csum_offset;
>         u64 csum_len;
>         LIST_HEAD(ordered_sums);
>         int ret = 0;
>
> -       *ordered_io_error = false;
> -
> -       if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
> +       if (inode->flags & BTRFS_INODE_NODATASUM ||
> +           test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
>             em->block_start == EXTENT_MAP_HOLE)
>                 return 0;
>
> -       /*
> -        * Wait far any ordered extent that covers our extent map. If it
> -        * finishes without an error, first check and see if our csums are on
> -        * our outstanding ordered extents.
> -        */
> -       list_for_each_entry(ordered, logged_list, log_list) {
> -               struct btrfs_ordered_sum *sum;
> -
> -               if (!mod_len)
> -                       break;
> -
> -               if (ordered->file_offset + ordered->len <= mod_start ||
> -                   mod_start + mod_len <= ordered->file_offset)
> -                       continue;
> -
> -               if (!test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags) &&
> -                   !test_bit(BTRFS_ORDERED_IOERR, &ordered->flags) &&
> -                   !test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags)) {
> -                       const u64 start = ordered->file_offset;
> -                       const u64 end = ordered->file_offset + ordered->len - 1;
> -
> -                       WARN_ON(ordered->inode != inode);
> -                       filemap_fdatawrite_range(inode->i_mapping, start, end);
> -               }
> -
> -               wait_event(ordered->wait,
> -                          (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags) ||
> -                           test_bit(BTRFS_ORDERED_IOERR, &ordered->flags)));
> -
> -               if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags)) {
> -                       /*
> -                        * Clear the AS_EIO/AS_ENOSPC flags from the inode's
> -                        * i_mapping flags, so that the next fsync won't get
> -                        * an outdated io error too.
> -                        */
> -                       filemap_check_errors(inode->i_mapping);
> -                       *ordered_io_error = true;
> -                       break;
> -               }
> -               /*
> -                * We are going to copy all the csums on this ordered extent, so
> -                * go ahead and adjust mod_start and mod_len in case this
> -                * ordered extent has already been logged.
> -                */
> -               if (ordered->file_offset > mod_start) {
> -                       if (ordered->file_offset + ordered->len >=
> -                           mod_start + mod_len)
> -                               mod_len = ordered->file_offset - mod_start;
> -                       /*
> -                        * If we have this case
> -                        *
> -                        * |--------- logged extent ---------|
> -                        *       |----- ordered extent ----|
> -                        *
> -                        * Just don't mess with mod_start and mod_len, we'll
> -                        * just end up logging more csums than we need and it
> -                        * will be ok.
> -                        */
> -               } else {
> -                       if (ordered->file_offset + ordered->len <
> -                           mod_start + mod_len) {
> -                               mod_len = (mod_start + mod_len) -
> -                                       (ordered->file_offset + ordered->len);
> -                               mod_start = ordered->file_offset +
> -                                       ordered->len;
> -                       } else {
> -                               mod_len = 0;
> -                       }
> -               }
> -
> -               if (skip_csum)
> -                       continue;
> -
> -               /*
> -                * To keep us from looping for the above case of an ordered
> -                * extent that falls inside of the logged extent.
> -                */
> -               if (test_and_set_bit(BTRFS_ORDERED_LOGGED_CSUM,
> -                                    &ordered->flags))
> -                       continue;
> -
> -               list_for_each_entry(sum, &ordered->list, list) {
> -                       ret = btrfs_csum_file_blocks(trans, log, sum);
> -                       if (ret)
> -                               break;
> -               }
> -       }
> -
> -       if (*ordered_io_error || !mod_len || ret || skip_csum)
> -               return ret;
> -
> +       /* If we're compressed we have to save the entire range of csums. */
>         if (em->compress_type) {
>                 csum_offset = 0;
>                 csum_len = max(em->block_len, em->orig_block_len);
>         } else {
> -               csum_offset = mod_start - em->start;
> -               csum_len = mod_len;
> +               csum_offset = em->mod_start - em->start;
> +               csum_len = em->mod_len;
>         }
>
>         /* block start is already adjusted for the file extent offset. */
> @@ -4230,7 +4117,6 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>                           struct btrfs_inode *inode, struct btrfs_root *root,
>                           const struct extent_map *em,
>                           struct btrfs_path *path,
> -                         const struct list_head *logged_list,
>                           struct btrfs_log_ctx *ctx)
>  {
>         struct btrfs_root *log = root->log_root;
> @@ -4242,18 +4128,11 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>         u64 block_len;
>         int ret;
>         int extent_inserted = 0;
> -       bool ordered_io_err = false;
>
> -       ret = wait_ordered_extents(trans, &inode->vfs_inode, root, em,
> -                       logged_list, &ordered_io_err);
> +       ret = log_extent_csums(trans, inode, root, em);
>         if (ret)
>                 return ret;
>
> -       if (ordered_io_err) {
> -               ctx->io_err = -EIO;
> -               return ctx->io_err;
> -       }
> -
>         btrfs_init_map_token(&token);
>
>         ret = __btrfs_drop_extents(trans, log, &inode->vfs_inode, path, em->start,
> @@ -4324,7 +4203,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>                                      struct btrfs_root *root,
>                                      struct btrfs_inode *inode,
>                                      struct btrfs_path *path,
> -                                    struct list_head *logged_list,
>                                      struct btrfs_log_ctx *ctx,
>                                      const u64 start,
>                                      const u64 end)
> @@ -4400,20 +4278,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>         }
>
>         list_sort(NULL, &extents, extent_cmp);
> -       btrfs_get_logged_extents(inode, logged_list, logged_start, logged_end);
> -       /*
> -        * Some ordered extents started by fsync might have completed
> -        * before we could collect them into the list logged_list, which
> -        * means they're gone, not in our logged_list nor in the inode's
> -        * ordered tree. We want the application/user space to know an
> -        * error happened while attempting to persist file data so that
> -        * it can take proper action. If such error happened, we leave
> -        * without writing to the log tree and the fsync must report the
> -        * file data write error and not commit the current transaction.
> -        */
> -       ret = filemap_check_errors(inode->vfs_inode.i_mapping);
> -       if (ret)
> -               ctx->io_err = ret;
>  process:
>         while (!list_empty(&extents)) {
>                 em = list_entry(extents.next, struct extent_map, list);
> @@ -4432,8 +4296,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>
>                 write_unlock(&tree->lock);
>
> -               ret = log_one_extent(trans, inode, root, em, path, logged_list,
> -                                    ctx);
> +               ret = log_one_extent(trans, inode, root, em, path, ctx);
>                 write_lock(&tree->lock);
>                 clear_em_logging(tree, em);
>                 free_extent_map(em);
> @@ -4815,7 +4678,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>         struct btrfs_key min_key;
>         struct btrfs_key max_key;
>         struct btrfs_root *log = root->log_root;
> -       LIST_HEAD(logged_list);
>         u64 last_extent = 0;
>         int err = 0;
>         int ret;
> @@ -5145,7 +5007,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>         }
>         if (fast_search) {
>                 ret = btrfs_log_changed_extents(trans, root, inode, dst_path,
> -                                               &logged_list, ctx, start, end);
> +                                               ctx, start, end);
>                 if (ret) {
>                         err = ret;
>                         goto out_unlock;
> @@ -5196,10 +5058,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>         inode->last_log_commit = inode->last_sub_trans;
>         spin_unlock(&inode->lock);
>  out_unlock:
> -       if (unlikely(err))
> -               btrfs_put_logged_extents(&logged_list);
> -       else
> -               btrfs_submit_logged_extents(&logged_list, log);
>         mutex_unlock(&inode->log_mutex);
>
>         btrfs_free_path(path);
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 29f9b14412ad..b3c246353f8e 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -433,7 +433,6 @@ DEFINE_EVENT(
>                 { (1 << BTRFS_ORDERED_DIRECT),          "DIRECT"        }, \
>                 { (1 << BTRFS_ORDERED_IOERR),           "IOERR"         }, \
>                 { (1 << BTRFS_ORDERED_UPDATED_ISIZE),   "UPDATED_ISIZE" }, \
> -               { (1 << BTRFS_ORDERED_LOGGED_CSUM),     "LOGGED_CSUM"   }, \
>                 { (1 << BTRFS_ORDERED_TRUNCATED),       "TRUNCATED"     })
>
>
> --
> 2.14.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
