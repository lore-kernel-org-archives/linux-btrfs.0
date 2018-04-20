Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33466 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751130AbeDTRda (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 13:33:30 -0400
Subject: Re: [PATCH] btrfs: add chattr support for send/receive
To: <fdmanana@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Omar Sandoval <osandov@osandov.com>, <kernel-team@fb.com>
References: <20180417233936.30629-1-hmclauchlan@fb.com>
 <CAL3q7H5fMuctTj_xt+-NNE=O5GV1oR6kmK37PuTQ3y2mHCPLOQ@mail.gmail.com>
From: Howard McLauchlan <hmclauchlan@fb.com>
Message-ID: <ee7ae8a6-6491-8753-b9cf-cc99f0330676@fb.com>
Date: Fri, 20 Apr 2018 10:33:21 -0700
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5fMuctTj_xt+-NNE=O5GV1oR6kmK37PuTQ3y2mHCPLOQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/18/2018 01:15 AM, Filipe Manana wrote:
> On Wed, Apr 18, 2018 at 12:39 AM, Howard McLauchlan <hmclauchlan@fb.com> wrote:
>> Presently btrfs send/receive does not propagate inode attribute flags;
>> all chattr operations are effectively discarded upon transmission.
>>
>> This patch adds kernel support for inode attribute flags. Userspace
>> support can be found under the commit:
>>
>>     btrfs-progs: add chattr support for send/receive
>>
>> An associated xfstest can be found at:
>>
>>     btrfs: add verify chattr support for send/receive test
>>
>> A caveat is that a user with an updated kernel (aware of chattrs) and an
>> older version of btrfs-progs (unaware of chattrs) will fail to receive
>> if a chattr is included in the send stream.
> So we do have several things missing in send besides attribute flags,
> like hole punching for example (there's a list on the wiki).
> We can't just add a new command and introduce such caveat every time
> we implement one of the missing and desired features.
>
> In 2014, while wanting to implement some of those features, I
> introduced a way to bump the send stream version with room (commands)
> for all those missing features, so that all could be implemented later
> without adding further backward incompatibility between kernel
> versions btrfs-progs versions.
> Some of the threads for reference:
>
> https://patchwork.kernel.org/patch/4021491/
> https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_linux-2Dbtrfs_msg35169.html&d=DwIFaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=UA4c4GV4shA70-jKB4kwcF99U6K6bzKVYdicFvu-DtQ&m=pWSiTBXI54TJfXnctkAeLJUbyIs9VZqupmGKs8JsETE&s=rsgeLq1QeHGaRs6xIXtGcGV-UgjCuqnWMATCw_KaxY8&e=
>
> It never took off, and honestly I don't remember why as no one add
> more comments on the latest versions of the kernel and btrfs-progs
> patchsets.
Thanks for the heads up, I'll go dig up your patches and try to get them working on 4.17

Howard

>
>> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
>> ---
>> Based on 4.17-rc1
>>
>>  fs/btrfs/ctree.h |   2 +
>>  fs/btrfs/ioctl.c |   2 +-
>>  fs/btrfs/send.c  | 176 +++++++++++++++++++++++++++++++++++++++--------
>>  fs/btrfs/send.h  |   2 +
>>  4 files changed, 154 insertions(+), 28 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 5474ef14d6e6..a0dc6a8a37eb 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1436,6 +1436,8 @@ struct btrfs_map_token {
>>         unsigned long offset;
>>  };
>>
>> +unsigned int btrfs_flags_to_ioctl(unsigned int flags);
>> +
>>  #define BTRFS_BYTES_TO_BLKS(fs_info, bytes) \
>>                                 ((bytes) >> (fs_info)->sb->s_blocksize_bits)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 632e26d6f7ce..36ce1e589f9e 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -106,7 +106,7 @@ static unsigned int btrfs_mask_flags(umode_t mode, unsigned int flags)
>>  /*
>>   * Export inode flags to the format expected by the FS_IOC_GETFLAGS ioctl.
>>   */
>> -static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
>> +unsigned int btrfs_flags_to_ioctl(unsigned int flags)
>>  {
>>         unsigned int iflags = 0;
>>
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index 221e5cdb060b..da521a5a1843 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -101,6 +101,13 @@ struct send_ctx {
>>         u64 cur_inode_last_extent;
>>         u64 cur_inode_next_write_offset;
>>
>> +       /*
>> +        * state for chattr purposes
>> +        */
>> +       u64 cur_inode_flip_flags;
>> +       u64 cur_inode_receive_flags;
>> +       int receive_flags_valid;
>> +
>>         u64 send_progress;
>>
>>         struct list_head new_refs;
>> @@ -798,7 +805,7 @@ static int send_rmdir(struct send_ctx *sctx, struct fs_path *path)
>>   */
>>  static int __get_inode_info(struct btrfs_root *root, struct btrfs_path *path,
>>                           u64 ino, u64 *size, u64 *gen, u64 *mode, u64 *uid,
>> -                         u64 *gid, u64 *rdev)
>> +                         u64 *gid, u64 *rdev, u64 *flags)
>>  {
>>         int ret;
>>         struct btrfs_inode_item *ii;
>> @@ -828,6 +835,8 @@ static int __get_inode_info(struct btrfs_root *root, struct btrfs_path *path,
>>                 *gid = btrfs_inode_gid(path->nodes[0], ii);
>>         if (rdev)
>>                 *rdev = btrfs_inode_rdev(path->nodes[0], ii);
>> +       if (flags)
>> +               *flags = btrfs_inode_flags(path->nodes[0], ii);
>>
>>         return ret;
>>  }
>> @@ -835,7 +844,7 @@ static int __get_inode_info(struct btrfs_root *root, struct btrfs_path *path,
>>  static int get_inode_info(struct btrfs_root *root,
>>                           u64 ino, u64 *size, u64 *gen,
>>                           u64 *mode, u64 *uid, u64 *gid,
>> -                         u64 *rdev)
>> +                         u64 *rdev, u64 *flags)
>>  {
>>         struct btrfs_path *path;
>>         int ret;
>> @@ -844,7 +853,7 @@ static int get_inode_info(struct btrfs_root *root,
>>         if (!path)
>>                 return -ENOMEM;
>>         ret = __get_inode_info(root, path, ino, size, gen, mode, uid, gid,
>> -                              rdev);
>> +                              rdev, flags);
>>         btrfs_free_path(path);
>>         return ret;
>>  }
>> @@ -1233,7 +1242,7 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
>>          * accept clones from these extents.
>>          */
>>         ret = __get_inode_info(found->root, bctx->path, ino, &i_size, NULL, NULL,
>> -                              NULL, NULL, NULL);
>> +                              NULL, NULL, NULL, NULL);
>>         btrfs_release_path(bctx->path);
>>         if (ret < 0)
>>                 return ret;
>> @@ -1593,7 +1602,7 @@ static int get_cur_inode_state(struct send_ctx *sctx, u64 ino, u64 gen)
>>         u64 right_gen;
>>
>>         ret = get_inode_info(sctx->send_root, ino, NULL, &left_gen, NULL, NULL,
>> -                       NULL, NULL);
>> +                       NULL, NULL, NULL);
>>         if (ret < 0 && ret != -ENOENT)
>>                 goto out;
>>         left_ret = ret;
>> @@ -1602,7 +1611,7 @@ static int get_cur_inode_state(struct send_ctx *sctx, u64 ino, u64 gen)
>>                 right_ret = -ENOENT;
>>         } else {
>>                 ret = get_inode_info(sctx->parent_root, ino, NULL, &right_gen,
>> -                               NULL, NULL, NULL, NULL);
>> +                               NULL, NULL, NULL, NULL, NULL);
>>                 if (ret < 0 && ret != -ENOENT)
>>                         goto out;
>>                 right_ret = ret;
>> @@ -1771,7 +1780,7 @@ static int get_first_ref(struct btrfs_root *root, u64 ino,
>>
>>         if (dir_gen) {
>>                 ret = get_inode_info(root, parent_dir, NULL, dir_gen, NULL,
>> -                                    NULL, NULL, NULL);
>> +                                    NULL, NULL, NULL, NULL);
>>                 if (ret < 0)
>>                         goto out;
>>         }
>> @@ -1844,7 +1853,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>>          */
>>         if (sctx->parent_root && dir != BTRFS_FIRST_FREE_OBJECTID) {
>>                 ret = get_inode_info(sctx->parent_root, dir, NULL, &gen, NULL,
>> -                                    NULL, NULL, NULL);
>> +                                    NULL, NULL, NULL, NULL);
>>                 if (ret < 0 && ret != -ENOENT)
>>                         goto out;
>>                 if (ret) {
>> @@ -1872,7 +1881,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>>         if (other_inode > sctx->send_progress ||
>>             is_waiting_for_move(sctx, other_inode)) {
>>                 ret = get_inode_info(sctx->parent_root, other_inode, NULL,
>> -                               who_gen, who_mode, NULL, NULL, NULL);
>> +                               who_gen, who_mode, NULL, NULL, NULL, NULL);
>>                 if (ret < 0)
>>                         goto out;
>>
>> @@ -1912,7 +1921,7 @@ static int did_overwrite_ref(struct send_ctx *sctx,
>>
>>         if (dir != BTRFS_FIRST_FREE_OBJECTID) {
>>                 ret = get_inode_info(sctx->send_root, dir, NULL, &gen, NULL,
>> -                                    NULL, NULL, NULL);
>> +                                    NULL, NULL, NULL, NULL);
>>                 if (ret < 0 && ret != -ENOENT)
>>                         goto out;
>>                 if (ret) {
>> @@ -1935,7 +1944,7 @@ static int did_overwrite_ref(struct send_ctx *sctx,
>>         }
>>
>>         ret = get_inode_info(sctx->send_root, ow_inode, NULL, &gen, NULL, NULL,
>> -                       NULL, NULL);
>> +                       NULL, NULL, NULL);
>>         if (ret < 0)
>>                 goto out;
>>
>> @@ -2502,6 +2511,39 @@ static int send_chown(struct send_ctx *sctx, u64 ino, u64 gen, u64 uid, u64 gid)
>>         return ret;
>>  }
>>
>> +static int send_chattr(struct send_ctx *sctx, u64 ino, u64 gen, u64 flags)
>> +{
>> +       struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
>> +       int ret = 0;
>> +       int __flags;
>> +       struct fs_path *p;
>> +
>> +       __flags = btrfs_flags_to_ioctl(flags);
>> +
>> +       btrfs_debug(fs_info, "send_chattr %llu flags=%llu", ino, flags);
>> +
>> +       p = fs_path_alloc();
>> +       if (!p)
>> +               return -ENOMEM;
>> +
>> +       ret = begin_cmd(sctx, BTRFS_SEND_C_CHATTR);
>> +       if (ret < 0)
>> +               goto out;
>> +
>> +       ret = get_cur_path(sctx, ino, gen, p);
>> +       if (ret < 0)
>> +               goto out;
>> +       TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
>> +       TLV_PUT_U64(sctx, BTRFS_SEND_A_CHATTR, __flags);
>> +
>> +       ret = send_cmd(sctx);
>> +
>> +tlv_put_failure:
>> +out:
>> +       fs_path_free(p);
>> +       return ret;
>> +}
>> +
>>  static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
>>  {
>>         struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
>> @@ -2583,7 +2625,7 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
>>
>>         if (ino != sctx->cur_ino) {
>>                 ret = get_inode_info(sctx->send_root, ino, NULL, &gen, &mode,
>> -                                    NULL, NULL, &rdev);
>> +                                    NULL, NULL, &rdev, NULL);
>>                 if (ret < 0)
>>                         goto out;
>>         } else {
>> @@ -3299,7 +3341,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>>                  * The parent inode might have been deleted in the send snapshot
>>                  */
>>                 ret = get_inode_info(sctx->send_root, cur->dir, NULL,
>> -                                    NULL, NULL, NULL, NULL, NULL);
>> +                                    NULL, NULL, NULL, NULL, NULL, NULL);
>>                 if (ret == -ENOENT) {
>>                         ret = 0;
>>                         continue;
>> @@ -3469,11 +3511,11 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
>>         }
>>
>>         ret = get_inode_info(sctx->parent_root, di_key.objectid, NULL,
>> -                            &left_gen, NULL, NULL, NULL, NULL);
>> +                            &left_gen, NULL, NULL, NULL, NULL, NULL);
>>         if (ret < 0)
>>                 goto out;
>>         ret = get_inode_info(sctx->send_root, di_key.objectid, NULL,
>> -                            &right_gen, NULL, NULL, NULL, NULL);
>> +                            &right_gen, NULL, NULL, NULL, NULL, NULL);
>>         if (ret < 0) {
>>                 if (ret == -ENOENT)
>>                         ret = 0;
>> @@ -3617,7 +3659,7 @@ static int is_ancestor(struct btrfs_root *root,
>>                         }
>>
>>                         ret = get_inode_info(root, parent, NULL, &parent_gen,
>> -                                            NULL, NULL, NULL, NULL);
>> +                                            NULL, NULL, NULL, NULL, NULL);
>>                         if (ret < 0)
>>                                 goto out;
>>                         ret = check_ino_in_path(root, ino1, ino1_gen,
>> @@ -3707,7 +3749,7 @@ static int wait_for_parent_move(struct send_ctx *sctx,
>>
>>                         ret = get_inode_info(sctx->parent_root, ino, NULL,
>>                                              &parent_ino_gen, NULL, NULL, NULL,
>> -                                            NULL);
>> +                                            NULL, NULL);
>>                         if (ret < 0)
>>                                 goto out;
>>                         if (ino_gen == parent_ino_gen) {
>> @@ -4184,7 +4226,7 @@ static int record_ref(struct btrfs_root *root, u64 dir, struct fs_path *name,
>>                 return -ENOMEM;
>>
>>         ret = get_inode_info(root, dir, NULL, &gen, NULL, NULL,
>> -                       NULL, NULL);
>> +                       NULL, NULL, NULL);
>>         if (ret < 0)
>>                 goto out;
>>
>> @@ -4272,7 +4314,7 @@ static int __find_iref(int num, u64 dir, int index,
>>                  * else matches.
>>                  */
>>                 ret = get_inode_info(ctx->root, dir, NULL, &dir_gen, NULL,
>> -                                    NULL, NULL, NULL);
>> +                                    NULL, NULL, NULL, NULL);
>>                 if (ret)
>>                         return ret;
>>                 if (dir_gen != ctx->dir_gen)
>> @@ -4316,7 +4358,7 @@ static int __record_changed_new_ref(int num, u64 dir, int index,
>>         struct send_ctx *sctx = ctx;
>>
>>         ret = get_inode_info(sctx->send_root, dir, NULL, &dir_gen, NULL,
>> -                            NULL, NULL, NULL);
>> +                            NULL, NULL, NULL, NULL);
>>         if (ret)
>>                 return ret;
>>
>> @@ -4339,7 +4381,7 @@ static int __record_changed_deleted_ref(int num, u64 dir, int index,
>>         struct send_ctx *sctx = ctx;
>>
>>         ret = get_inode_info(sctx->parent_root, dir, NULL, &dir_gen, NULL,
>> -                            NULL, NULL, NULL);
>> +                            NULL, NULL, NULL, NULL);
>>         if (ret)
>>                 return ret;
>>
>> @@ -4915,7 +4957,7 @@ static int send_clone(struct send_ctx *sctx,
>>
>>         if (clone_root->root == sctx->send_root) {
>>                 ret = get_inode_info(sctx->send_root, clone_root->ino, NULL,
>> -                               &gen, NULL, NULL, NULL, NULL);
>> +                               &gen, NULL, NULL, NULL, NULL, NULL);
>>                 if (ret < 0)
>>                         goto out;
>>                 ret = get_cur_path(sctx, clone_root->ino, gen, p);
>> @@ -5777,9 +5819,11 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>>         u64 right_mode;
>>         u64 right_uid;
>>         u64 right_gid;
>> +       u64 left_flags;
>>         int need_chmod = 0;
>>         int need_chown = 0;
>>         int need_truncate = 1;
>> +       int need_chattr = 0;
>>         int pending_move = 0;
>>         int refs_processed = 0;
>>
>> @@ -5787,7 +5831,6 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>>                                               &refs_processed);
>>         if (ret < 0)
>>                 goto out;
>> -
>>         /*
>>          * We have processed the refs and thus need to advance send_progress.
>>          * Now, calls to get_cur_xxx will take the updated refs of the current
>> @@ -5805,11 +5848,67 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>>
>>         if (sctx->cur_ino == 0 || sctx->cur_inode_deleted)
>>                 goto out;
>> +
>> +       /*
>> +        * If possible, we want to know what flags are set for this inode on the
>> +        * receiving end.
>> +        */
>> +       if (sctx->parent_root && !sctx->receive_flags_valid) {
>> +               ret = get_inode_info(sctx->parent_root, sctx->cur_ino, NULL,
>> +                                    NULL, NULL, NULL, NULL, NULL,
>> +                                    &sctx->cur_inode_receive_flags);
>> +               if (ret < 0)
>> +                       goto out;
>> +               sctx->receive_flags_valid = 1;
>> +       }
>> +
>> +       /*
>> +        * The change is going to modify data and the inode already exists
>> +        * !at_end prevents unnecessary chattr.
>> +        */
>> +       if (!at_end && sctx->parent_root && !sctx->cur_inode_new &&
>> +           (sctx->cmp_key->type == BTRFS_EXTENT_DATA_KEY ||
>> +           sctx->cmp_key->type == BTRFS_XATTR_ITEM_KEY)) {
>> +
>> +               ret = get_inode_info(sctx->send_root, sctx->cur_ino, NULL, NULL,
>> +                               NULL, NULL, NULL, NULL, &left_flags);
>> +               if (ret < 0)
>> +                       goto out;
>> +               /*
>> +                * We check against the receive flags first; then check against
>> +                * the left flags to see if we can save a chattr later on
>> +                */
>> +               if (sctx->cur_inode_receive_flags & BTRFS_INODE_IMMUTABLE) {
>> +                       sctx->cur_inode_flip_flags |= (left_flags &
>> +                                                      BTRFS_INODE_IMMUTABLE);
>> +                       left_flags &= ~BTRFS_INODE_IMMUTABLE;
>> +                       need_chattr = 1;
>> +               }
>> +               if (sctx->cur_inode_receive_flags & BTRFS_INODE_APPEND) {
>> +                       sctx->cur_inode_flip_flags |= (left_flags &
>> +                                                      BTRFS_INODE_APPEND);
>> +                       left_flags &= ~BTRFS_INODE_APPEND;
>> +                       need_chattr = 1;
>> +               }
>> +               if (need_chattr) {
>> +                       need_chattr = 0;
>> +                       ret = send_chattr(sctx, sctx->cur_ino,
>> +                                         sctx->cur_inode_gen, left_flags);
>> +                       if (ret < 0)
>> +                               goto out;
>> +                       /*
>> +                        * left_flags is now an accurate rep of what the
>> +                        * receiving inode's flags are
>> +                        */
>> +                       sctx->cur_inode_receive_flags = left_flags;
>> +               }
>> +       }
>> +
>>         if (!at_end && sctx->cmp_key->objectid == sctx->cur_ino)
>>                 goto out;
>>
>>         ret = get_inode_info(sctx->send_root, sctx->cur_ino, NULL, NULL,
>> -                       &left_mode, &left_uid, &left_gid, NULL);
>> +                       &left_mode, &left_uid, &left_gid, NULL, &left_flags);
>>         if (ret < 0)
>>                 goto out;
>>
>> @@ -5819,12 +5918,14 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>>                         need_chmod = 1;
>>                 if (sctx->cur_inode_next_write_offset == sctx->cur_inode_size)
>>                         need_truncate = 0;
>> +               if (left_flags)
>> +                       need_chattr = 1;
>>         } else {
>>                 u64 old_size;
>>
>>                 ret = get_inode_info(sctx->parent_root, sctx->cur_ino,
>>                                 &old_size, NULL, &right_mode, &right_uid,
>> -                               &right_gid, NULL);
>> +                               &right_gid, NULL, NULL);
>>                 if (ret < 0)
>>                         goto out;
>>
>> @@ -5897,6 +5998,27 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>>                         goto out;
>>         }
>>
>> +       /*
>> +        * At this point, if we toggled stuff earlier, untoggle it
>> +        * force a chattr and fix the flags
>> +        */
>> +       if (sctx->cur_inode_flip_flags) {
>> +               left_flags |= sctx->cur_inode_flip_flags;
>> +       }
>> +
>> +       /*
>> +        * We either need a chattr because this inode is new, or we need to make
>> +        * a change due to a discrepancy between left_flags and receive_flags
>> +        */
>> +       if (need_chattr || (sctx->cur_inode_receive_flags != left_flags)) {
>> +               ret = send_chattr(sctx, sctx->cur_ino, sctx->cur_inode_gen,
>> +                                 left_flags);
>> +               if (ret < 0)
>> +                       goto out;
>> +       }
>> +       sctx->cur_inode_flip_flags = 0;
>> +       sctx->cur_inode_receive_flags = 0;
>> +       sctx->receive_flags_valid = 0;
>>  out:
>>         return ret;
>>  }
>> @@ -6198,12 +6320,12 @@ static int dir_changed(struct send_ctx *sctx, u64 dir)
>>         int ret;
>>
>>         ret = get_inode_info(sctx->send_root, dir, NULL, &new_gen, NULL, NULL,
>> -                            NULL, NULL);
>> +                            NULL, NULL, NULL);
>>         if (ret)
>>                 return ret;
>>
>>         ret = get_inode_info(sctx->parent_root, dir, NULL, &orig_gen, NULL,
>> -                            NULL, NULL, NULL);
>> +                            NULL, NULL, NULL, NULL);
>>         if (ret)
>>                 return ret;
>>
>> diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
>> index ead397f7034f..b6e6dcc3db70 100644
>> --- a/fs/btrfs/send.h
>> +++ b/fs/btrfs/send.h
>> @@ -77,6 +77,7 @@ enum btrfs_send_cmd {
>>
>>         BTRFS_SEND_C_END,
>>         BTRFS_SEND_C_UPDATE_EXTENT,
>> +       BTRFS_SEND_C_CHATTR,
>>         __BTRFS_SEND_C_MAX,
>>  };
>>  #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
>> @@ -114,6 +115,7 @@ enum {
>>         BTRFS_SEND_A_CLONE_PATH,
>>         BTRFS_SEND_A_CLONE_OFFSET,
>>         BTRFS_SEND_A_CLONE_LEN,
>> +       BTRFS_SEND_A_CHATTR,
>>
>>         __BTRFS_SEND_A_MAX,
>>  };
>> --
>> 2.17.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

