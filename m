Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48710 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaDDP75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 11:59:57 -0400
Received: by mail-lb0-f174.google.com with SMTP id u14so2621637lbd.19
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 08:59:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <533EC742.5050505@gmail.com>
References: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
	<533EC742.5050505@gmail.com>
Date: Fri, 4 Apr 2014 16:59:55 +0100
Message-ID: <CAL3q7H7_u093gpeZ_j+os5_ML+uwczS6wRhB2e-FLk_5ZD5Pww@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: send, add calculate data size flag to allow
 for progress estimation
From: Filipe David Manana <fdmanana@gmail.com>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 4, 2014 at 3:52 PM, Konstantinos Skarlatos
<k.skarlatos@gmail.com> wrote:
> On 4/4/2014 6:20 μμ, Filipe David Borba Manana wrote:
>>
>> This new send flag makes send calculate first the amount of new file data
>> (in bytes)
>> the send root has relatively to the parent root, or for the case of a
>> non-incremental
>> send, the total amount of file data we will send through the send stream.
>> In other words,
>> it computes the sum of the lengths of all write and clone operations that
>> will be sent
>> through the send stream.
>>
>> This data size value is sent in a new command, named
>> BTRFS_SEND_C_TOTAL_DATA_SIZE, that
>> immediately follows a BTRFS_SEND_C_SUBVOL or BTRFS_SEND_C_SNAPSHOT
>> command, and precedes
>> any command that changes a file or the filesystem hierarchy. Upon
>> receiving a write or
>> clone command, the receiving end can increment a counter by the data
>> length of that
>> command and therefore report progress by comparing the counter's value
>> with the data size
>> value received in the BTRFS_SEND_C_TOTAL_DATA_SIZE command.
>>
>> The approach is simple, before the normal operation of send, do a scan in
>> the file system
>> tree for new inodes and file extent items, just like in send's normal
>> operation, and keep
>> incrementing a counter with new inodes' size and the size of file extents
>> that are going
>> to be written or cloned. This is actually a simpler and more lightweight
>> tree scan/processing
>> than the one we do when sending the changes, as it doesn't process inode
>> references nor does
>> any lookups in the extent tree for example.
>>
>> After modifying btrfs-progs to understand this new command and report
>> progress, here's an
>> example (the -o flag tells btrfs send to pass the new flag to the kernel's
>> send ioctl):
>>
>>      $ btrfs send -o /mnt/sdd/base | btrfs receive /mnt/sdc
>>      At subvol /mnt/sdd/base
>>      At subvol base
>>      About to receive 9211507211 bytes
>>      Subvolume/snapshot /mnt/sdc//base, progress  24.73%, 2278015008 bytes
>> received (9211507211 total bytes)
>>
>>      $ btrfs send -o -p /mnt/sdd/base /mnt/sdd/incr | btrfs receive
>> /mnt/sdc
>>      At subvol /mnt/sdd/incr
>>      At snapshot incr
>>      About to receive 9211747739 bytes
>>      Subvolume/snapshot /mnt/sdc//incr, progress  63.42%, 5843024211 bytes
>> received (9211747739 total bytes)
>
> Hi, as a user of send i can say that this feature is very useful. Is it
> possible to add current speed indication (MB/sec)?

Yes, it is.

>
>
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>   fs/btrfs/send.c            | 194
>> +++++++++++++++++++++++++++++++++++++--------
>>   fs/btrfs/send.h            |   1 +
>>   include/uapi/linux/btrfs.h |  13 ++-
>>   3 files changed, 175 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index c81e0d9..fa378c7 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -81,7 +81,13 @@ struct clone_root {
>>   #define SEND_CTX_MAX_NAME_CACHE_SIZE 128
>>   #define SEND_CTX_NAME_CACHE_CLEAN_SIZE (SEND_CTX_MAX_NAME_CACHE_SIZE *
>> 2)
>>   +enum btrfs_send_phase {
>> +       SEND_PHASE_STREAM_CHANGES,
>> +       SEND_PHASE_COMPUTE_DATA_SIZE,
>> +};
>> +
>>   struct send_ctx {
>> +       enum btrfs_send_phase phase;
>>         struct file *send_filp;
>>         loff_t send_off;
>>         char *send_buf;
>> @@ -116,6 +122,7 @@ struct send_ctx {
>>         u64 cur_inode_last_extent;
>>         u64 send_progress;
>> +       u64 total_data_size;
>>         struct list_head new_refs;
>>         struct list_head deleted_refs;
>> @@ -687,6 +694,8 @@ static int send_rename(struct send_ctx *sctx,
>>   {
>>         int ret;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_rename %s -> %s\n", from->start, to->start);
>>         ret = begin_cmd(sctx, BTRFS_SEND_C_RENAME);
>> @@ -711,6 +720,8 @@ static int send_link(struct send_ctx *sctx,
>>   {
>>         int ret;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_link %s -> %s\n", path->start, lnk->start);
>>         ret = begin_cmd(sctx, BTRFS_SEND_C_LINK);
>> @@ -734,6 +745,8 @@ static int send_unlink(struct send_ctx *sctx, struct
>> fs_path *path)
>>   {
>>         int ret;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_unlink %s\n", path->start);
>>         ret = begin_cmd(sctx, BTRFS_SEND_C_UNLINK);
>> @@ -756,6 +769,8 @@ static int send_rmdir(struct send_ctx *sctx, struct
>> fs_path *path)
>>   {
>>         int ret;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_rmdir %s\n", path->start);
>>         ret = begin_cmd(sctx, BTRFS_SEND_C_RMDIR);
>> @@ -2286,6 +2301,9 @@ static int send_truncate(struct send_ctx *sctx, u64
>> ino, u64 gen, u64 size)
>>         int ret = 0;
>>         struct fs_path *p;
>>   +     if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
>> +               return 0;
>> +
>>   verbose_printk("btrfs: send_truncate %llu size=%llu\n", ino, size);
>>         p = fs_path_alloc();
>> @@ -2315,6 +2333,8 @@ static int send_chmod(struct send_ctx *sctx, u64
>> ino, u64 gen, u64 mode)
>>         int ret = 0;
>>         struct fs_path *p;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_chmod %llu mode=%llu\n", ino, mode);
>>         p = fs_path_alloc();
>> @@ -2344,6 +2364,8 @@ static int send_chown(struct send_ctx *sctx, u64
>> ino, u64 gen, u64 uid, u64 gid)
>>         int ret = 0;
>>         struct fs_path *p;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_chown %llu uid=%llu, gid=%llu\n", ino, uid,
>> gid);
>>         p = fs_path_alloc();
>> @@ -2379,6 +2401,8 @@ static int send_utimes(struct send_ctx *sctx, u64
>> ino, u64 gen)
>>         struct btrfs_key key;
>>         int slot;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_utimes %llu\n", ino);
>>         p = fs_path_alloc();
>> @@ -2441,6 +2465,8 @@ static int send_create_inode(struct send_ctx *sctx,
>> u64 ino)
>>         u64 mode;
>>         u64 rdev;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_create_inode %llu\n", ino);
>>         p = fs_path_alloc();
>> @@ -2588,6 +2614,8 @@ static int send_create_inode_if_needed(struct
>> send_ctx *sctx)
>>   {
>>         int ret;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>         if (S_ISDIR(sctx->cur_inode_mode)) {
>>                 ret = did_create_dir(sctx, sctx->cur_ino);
>>                 if (ret < 0)
>> @@ -2693,6 +2721,8 @@ static int orphanize_inode(struct send_ctx *sctx,
>> u64 ino, u64 gen,
>>         int ret;
>>         struct fs_path *orphan;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>         orphan = fs_path_alloc();
>>         if (!orphan)
>>                 return -ENOMEM;
>> @@ -3061,6 +3091,8 @@ static int apply_dir_move(struct send_ctx *sctx,
>> struct pending_dir_move *pm)
>>         int ret;
>>         u64 ancestor = 0;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>         name = fs_path_alloc();
>>         from_path = fs_path_alloc();
>>         if (!name || !from_path) {
>> @@ -3315,6 +3347,9 @@ static int process_recorded_refs(struct send_ctx
>> *sctx, int *pending_move)
>>         int is_orphan = 0;
>>         u64 last_dir_ino_rm = 0;
>>   +     if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
>> +               return 0;
>> +
>>   verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
>>         /*
>> @@ -3823,6 +3858,8 @@ static int process_all_refs(struct send_ctx *sctx,
>>         iterate_inode_ref_t cb;
>>         int pending_move = 0;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>         path = alloc_path_for_send();
>>         if (!path)
>>                 return -ENOMEM;
>> @@ -4142,6 +4179,8 @@ static int process_all_new_xattrs(struct send_ctx
>> *sctx)
>>         struct extent_buffer *eb;
>>         int slot;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>         path = alloc_path_for_send();
>>         if (!path)
>>                 return -ENOMEM;
>> @@ -4272,6 +4311,8 @@ static int send_write(struct send_ctx *sctx, u64
>> offset, u32 len)
>>         struct fs_path *p;
>>         ssize_t num_read = 0;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>         p = fs_path_alloc();
>>         if (!p)
>>                 return -ENOMEM;
>> @@ -4307,6 +4348,22 @@ out:
>>         return num_read;
>>   }
>>   +static int send_total_data_size(struct send_ctx *sctx, u64 data_size)
>> +{
>> +       int ret;
>> +
>> +       ret = begin_cmd(sctx, BTRFS_SEND_C_TOTAL_DATA_SIZE);
>> +       if (ret < 0)
>> +               goto out;
>> +
>> +       TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, data_size);
>> +       ret = send_cmd(sctx);
>> +
>> +tlv_put_failure:
>> +out:
>> +       return ret;
>> +}
>> +
>>   /*
>>    * Send a clone command to user space.
>>    */
>> @@ -4318,6 +4375,8 @@ static int send_clone(struct send_ctx *sctx,
>>         struct fs_path *p;
>>         u64 gen;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>   verbose_printk("btrfs: send_clone offset=%llu, len=%d, clone_root=%llu,
>> "
>>                "clone_inode=%llu, clone_offset=%llu\n", offset, len,
>>                 clone_root->root->objectid, clone_root->ino,
>> @@ -4376,6 +4435,8 @@ static int send_update_extent(struct send_ctx *sctx,
>>         int ret = 0;
>>         struct fs_path *p;
>>   +     ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
>> +
>>         p = fs_path_alloc();
>>         if (!p)
>>                 return -ENOMEM;
>> @@ -4407,6 +4468,11 @@ static int send_hole(struct send_ctx *sctx, u64
>> end)
>>         u64 len;
>>         int ret = 0;
>>   +     if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
>> +               sctx->total_data_size += end - offset;
>> +               return 0;
>> +       }
>> +
>>         p = fs_path_alloc();
>>         if (!p)
>>                 return -ENOMEM;
>> @@ -4470,6 +4536,12 @@ static int send_write_or_clone(struct send_ctx
>> *sctx,
>>                 goto out;
>>         }
>>   +     if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
>> +               if (offset < sctx->cur_inode_size)
>> +                       sctx->total_data_size += len;
>> +               goto out;
>> +       }
>> +
>>         if (clone_root && IS_ALIGNED(offset + len, bs)) {
>>                 ret = send_clone(sctx, offset, len, clone_root);
>>         } else if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA) {
>> @@ -4803,10 +4875,12 @@ static int process_extent(struct send_ctx *sctx,
>>                 }
>>         }
>>   -     ret = find_extent_clone(sctx, path, key->objectid, key->offset,
>> -                       sctx->cur_inode_size, &found_clone);
>> -       if (ret != -ENOENT && ret < 0)
>> -               goto out;
>> +       if (sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE) {
>> +               ret = find_extent_clone(sctx, path, key->objectid,
>> key->offset,
>> +                                       sctx->cur_inode_size,
>> &found_clone);
>> +               if (ret != -ENOENT && ret < 0)
>> +                       goto out;
>> +       }
>>         ret = send_write_or_clone(sctx, path, key, found_clone);
>>         if (ret)
>> @@ -4936,6 +5010,9 @@ static int finish_inode_if_needed(struct send_ctx
>> *sctx, int at_end)
>>         if (!at_end && sctx->cmp_key->objectid == sctx->cur_ino)
>>                 goto out;
>>   +     if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
>> +               goto truncate_inode;
>> +
>>         ret = get_inode_info(sctx->send_root, sctx->cur_ino, NULL, NULL,
>>                         &left_mode, &left_uid, &left_gid, NULL);
>>         if (ret < 0)
>> @@ -4958,6 +5035,7 @@ static int finish_inode_if_needed(struct send_ctx
>> *sctx, int at_end)
>>                         need_chmod = 1;
>>         }
>>   +truncate_inode:
>>         if (S_ISREG(sctx->cur_inode_mode)) {
>>                 if (need_send_hole(sctx)) {
>>                         if (sctx->cur_inode_last_extent == (u64)-1 ||
>> @@ -4997,7 +5075,8 @@ static int finish_inode_if_needed(struct send_ctx
>> *sctx, int at_end)
>>          * If other directory inodes depended on our current directory
>>          * inode's move/rename, now do their move/rename operations.
>>          */
>> -       if (!is_waiting_for_move(sctx, sctx->cur_ino)) {
>> +       if (sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE &&
>> +           !is_waiting_for_move(sctx, sctx->cur_ino)) {
>>                 ret = apply_children_dir_moves(sctx);
>>                 if (ret)
>>                         goto out;
>> @@ -5081,7 +5160,8 @@ static int changed_inode(struct send_ctx *sctx,
>>                                 sctx->left_path->nodes[0], left_ii);
>>                 sctx->cur_inode_rdev = btrfs_inode_rdev(
>>                                 sctx->left_path->nodes[0], left_ii);
>> -               if (sctx->cur_ino != BTRFS_FIRST_FREE_OBJECTID)
>> +               if (sctx->cur_ino != BTRFS_FIRST_FREE_OBJECTID &&
>> +                   sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE)
>>                         ret = send_create_inode_if_needed(sctx);
>>         } else if (result == BTRFS_COMPARE_TREE_DELETED) {
>>                 sctx->cur_inode_gen = right_gen;
>> @@ -5103,17 +5183,19 @@ static int changed_inode(struct send_ctx *sctx,
>>                         /*
>>                          * First, process the inode as if it was deleted.
>>                          */
>> -                       sctx->cur_inode_gen = right_gen;
>> -                       sctx->cur_inode_new = 0;
>> -                       sctx->cur_inode_deleted = 1;
>> -                       sctx->cur_inode_size = btrfs_inode_size(
>> +                       if (sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE) {
>> +                               sctx->cur_inode_gen = right_gen;
>> +                               sctx->cur_inode_new = 0;
>> +                               sctx->cur_inode_deleted = 1;
>> +                               sctx->cur_inode_size = btrfs_inode_size(
>>                                         sctx->right_path->nodes[0],
>> right_ii);
>> -                       sctx->cur_inode_mode = btrfs_inode_mode(
>> +                               sctx->cur_inode_mode = btrfs_inode_mode(
>>                                         sctx->right_path->nodes[0],
>> right_ii);
>> -                       ret = process_all_refs(sctx,
>> -                                       BTRFS_COMPARE_TREE_DELETED);
>> -                       if (ret < 0)
>> -                               goto out;
>> +                               ret = process_all_refs(sctx,
>> +
>> BTRFS_COMPARE_TREE_DELETED);
>> +                               if (ret < 0)
>> +                                       goto out;
>> +                       }
>>                         /*
>>                          * Now process the inode as if it was new.
>> @@ -5127,29 +5209,38 @@ static int changed_inode(struct send_ctx *sctx,
>>                                         sctx->left_path->nodes[0],
>> left_ii);
>>                         sctx->cur_inode_rdev = btrfs_inode_rdev(
>>                                         sctx->left_path->nodes[0],
>> left_ii);
>> -                       ret = send_create_inode_if_needed(sctx);
>> -                       if (ret < 0)
>> -                               goto out;
>> -
>> -                       ret = process_all_refs(sctx,
>> BTRFS_COMPARE_TREE_NEW);
>> -                       if (ret < 0)
>> -                               goto out;
>> +                       if (sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE) {
>> +                               ret = send_create_inode_if_needed(sctx);
>> +                               if (ret < 0)
>> +                                       goto out;
>> +                               ret = process_all_refs(sctx,
>> +
>> BTRFS_COMPARE_TREE_NEW);
>> +                               if (ret < 0)
>> +                                       goto out;
>> +                       }
>>                         /*
>>                          * Advance send_progress now as we did not get
>> into
>>                          * process_recorded_refs_if_needed in the new_gen
>> case.
>>                          */
>>                         sctx->send_progress = sctx->cur_ino + 1;
>>   -                     /*
>> -                        * Now process all extents and xattrs of the inode
>> as if
>> -                        * they were all new.
>> -                        */
>> -                       ret = process_all_extents(sctx);
>> -                       if (ret < 0)
>> -                               goto out;
>> -                       ret = process_all_new_xattrs(sctx);
>> -                       if (ret < 0)
>> -                               goto out;
>> +                       if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
>> +                               if (S_ISREG(sctx->cur_inode_mode))
>> +                                       sctx->total_data_size +=
>> +                                               sctx->cur_inode_size;
>> +                               /* TODO: maybe account for xattrs one day
>> too */
>> +                       } else {
>> +                               /*
>> +                                * Now process all extents and xattrs of
>> the
>> +                                * inode as if they were all new.
>> +                                */
>> +                               ret = process_all_extents(sctx);
>> +                               if (ret < 0)
>> +                                       goto out;
>> +                               ret = process_all_new_xattrs(sctx);
>> +                               if (ret < 0)
>> +                                       goto out;
>> +                       }
>>                 } else {
>>                         sctx->cur_inode_gen = left_gen;
>>                         sctx->cur_inode_new = 0;
>> @@ -5183,6 +5274,9 @@ static int changed_ref(struct send_ctx *sctx,
>>         BUG_ON(sctx->cur_ino != sctx->cmp_key->objectid);
>>   +     if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
>> +               return 0;
>> +
>>         if (!sctx->cur_inode_new_gen &&
>>             sctx->cur_ino != BTRFS_FIRST_FREE_OBJECTID) {
>>                 if (result == BTRFS_COMPARE_TREE_NEW)
>> @@ -5208,6 +5302,9 @@ static int changed_xattr(struct send_ctx *sctx,
>>         BUG_ON(sctx->cur_ino != sctx->cmp_key->objectid);
>>   +     if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
>> +               return 0;
>> +
>>         if (!sctx->cur_inode_new_gen && !sctx->cur_inode_deleted) {
>>                 if (result == BTRFS_COMPARE_TREE_NEW)
>>                         ret = process_new_xattr(sctx);
>> @@ -5317,6 +5414,8 @@ static int changed_cb(struct btrfs_root *left_root,
>>         if (result == BTRFS_COMPARE_TREE_SAME) {
>>                 if (key->type == BTRFS_INODE_REF_KEY ||
>>                     key->type == BTRFS_INODE_EXTREF_KEY) {
>> +                       if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
>> +                               return 0;
>>                         ret = compare_refs(sctx, left_path, key);
>>                         if (!ret)
>>                                 return 0;
>> @@ -5468,6 +5567,24 @@ out:
>>         return ret;
>>   }
>>   +static int compute_total_data_size(struct send_ctx *sctx)
>> +{
>> +       int ret;
>> +
>> +       sctx->total_data_size = 0;
>> +
>> +       if (sctx->parent_root) {
>> +               ret = btrfs_compare_trees(sctx->send_root,
>> sctx->parent_root,
>> +                                         changed_cb, sctx);
>> +               if (!ret)
>> +                       ret = finish_inode_if_needed(sctx, 1);
>> +       } else {
>> +               ret = full_send_tree(sctx);
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>>   static int send_subvol(struct send_ctx *sctx)
>>   {
>>         int ret;
>> @@ -5482,6 +5599,19 @@ static int send_subvol(struct send_ctx *sctx)
>>         if (ret < 0)
>>                 goto out;
>>   +     if (sctx->flags & BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE) {
>> +               sctx->phase = SEND_PHASE_COMPUTE_DATA_SIZE;
>> +               ret = compute_total_data_size(sctx);
>> +               if (ret < 0)
>> +                       goto out;
>> +               ret = send_total_data_size(sctx, sctx->total_data_size);
>> +               if (ret < 0)
>> +                       goto out;
>> +               sctx->phase = SEND_PHASE_STREAM_CHANGES;
>> +               sctx->cur_ino = 0;
>> +               sctx->send_progress = 0;
>> +       }
>> +
>>         if (sctx->parent_root) {
>>                 ret = btrfs_compare_trees(sctx->send_root,
>> sctx->parent_root,
>>                                 changed_cb, sctx);
>> diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
>> index 48d425a..febeb72 100644
>> --- a/fs/btrfs/send.h
>> +++ b/fs/btrfs/send.h
>> @@ -87,6 +87,7 @@ enum btrfs_send_cmd {
>>         BTRFS_SEND_C_END,
>>         BTRFS_SEND_C_UPDATE_EXTENT,
>> +       BTRFS_SEND_C_TOTAL_DATA_SIZE,
>>         __BTRFS_SEND_C_MAX,
>>   };
>>   #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index b4d6909..afc1529 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -464,10 +464,21 @@ struct btrfs_ioctl_received_subvol_args {
>>    */
>>   #define BTRFS_SEND_FLAG_OMIT_END_CMD          0x4
>>   +/*
>> + * Calculate the amount (in bytes) of new file data between the send and
>> + * parent snapshots, or in case of a full send, the total amount of file
>> data
>> + * we will send.
>> + * This corresponds to the sum of the data lengths of each write and
>> clone
>> + * commands that are sent through the send stream. The receiving end can
>> use
>> + * this information to compute progress.
>> + */
>> +#define BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE    0x8
>> +
>>   #define BTRFS_SEND_FLAG_MASK \
>>         (BTRFS_SEND_FLAG_NO_FILE_DATA | \
>>          BTRFS_SEND_FLAG_OMIT_STREAM_HEADER | \
>> -        BTRFS_SEND_FLAG_OMIT_END_CMD)
>> +        BTRFS_SEND_FLAG_OMIT_END_CMD | \
>> +        BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE)
>>     struct btrfs_ioctl_send_args {
>>         __s64 send_fd;                  /* in */
>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
