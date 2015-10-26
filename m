Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34186 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbbJZI2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 04:28:33 -0400
Received: by iody8 with SMTP id y8so23002882iod.1
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 01:28:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <562DE365.2080602@cn.fujitsu.com>
References: <1445839879-17716-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1445839879-17716-2-git-send-email-quwenruo@cn.fujitsu.com>
	<CAL3q7H49cV5J1ADSbs77aaQ8Q+yQYiSzXNkWrx-pKO3s3xsoiw@mail.gmail.com>
	<562DE365.2080602@cn.fujitsu.com>
Date: Mon, 26 Oct 2015 08:28:32 +0000
Message-ID: <CAL3q7H53x4hb+d+w9nnHHaSOT+gtF3qTa1wz0JogxXMKghsqEA@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs: Cleanup no_quota parameter
From: Filipe Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 26, 2015 at 8:25 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Filipe Manana wrote on 2015/10/26 08:14 +0000:
>>
>> On Mon, Oct 26, 2015 at 6:11 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>> No_quota parameter for delayed_ref related function are meaningless
>>> after 4.2-rc1, as any new delayed_ref_head will cause qgroup to scan
>>> extent for its rfer/excl change without checking no_quota flag.
>>>
>>> So this patch will clean them up.
>>
>>
>> Hi Qu,
>>
>> I already send a patch for this yesterday:
>> https://patchwork.kernel.org/patch/7481901/
>
>
> Sorry, I didn't notice the patch also removed no_quota...
>
>>
>> This is more than a cleanup, it fixes several bugs. The most important
>> is crashes (BUG_ON) when running delayed references, mostly triggered
>> during balance. The second one is a deadlock in the clone ioctl
>> (reported at http://www.spinics.net/lists/linux-btrfs/msg45844.html).
>>
>> The use of no_quota was also buggy in at least 2 places:
>>
>>      1) At delayed-refs.c:btrfs_add_delayed_tree_ref() - we were setting
>>         no_quota to 0 instead of 1 when the following condition was true:
>>         is_fstree(ref_root) || !fs_info->quota_enabled
>>
>>      2) At extent-tree.c:__btrfs_inc_extent_ref() - we were attempting to
>>         reset a node's no_quota when the condition
>> "!is_fstree(root_objectid)
>>         || !root->fs_info->quota_enabled" was true but we did it only in
>>         an unused local stack variable, that is, we never reset the
>> no_quota
>>         value in the node itself.
>>
>> I want to get this to stable, together with the other delayed
>> references fix, as a lot of people are unable to run balance as of
>> kernel 4.2+.
>
>
> Sorry again for the regression I brought in 4.2.
> The rework for delayed_ref implement is not important at all, and in fact
> new qgroup accounting could work completely well without them.
>
>> I'll update the changelog to reflect the clone ioctl deadlock issue,
>> which I previously forgot.
>>
>> thanks
>>
>
> That would be great.
>
> BTW what about split the patch into no_quota cleanup and other fixes?

No point in doing that. Fixing the balance regression requires
removing the whole no_quota thing, fixing those 2 bugs it had alone,
won't fix the problem leading to the BUG_ON.

> It's not that obvious if they are all put into one patch.
>
> Thanks,
> Qu
>
>
>>
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>   fs/btrfs/ctree.h       |  4 ++--
>>>   fs/btrfs/delayed-ref.c | 26 ++++++----------------
>>>   fs/btrfs/delayed-ref.h |  7 ++----
>>>   fs/btrfs/extent-tree.c | 45 ++++++++++++++-----------------------
>>>   fs/btrfs/file.c        | 10 ++++-----
>>>   fs/btrfs/inode.c       |  4 ++--
>>>   fs/btrfs/ioctl.c       | 60
>>> +-------------------------------------------------
>>>   fs/btrfs/relocation.c  | 16 ++++++--------
>>>   fs/btrfs/tree-log.c    |  2 +-
>>>   9 files changed, 43 insertions(+), 131 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index bc3c711..3fa3c3b 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -3422,7 +3422,7 @@ int btrfs_set_disk_extent_flags(struct
>>> btrfs_trans_handle *trans,
>>>   int btrfs_free_extent(struct btrfs_trans_handle *trans,
>>>                        struct btrfs_root *root,
>>>                        u64 bytenr, u64 num_bytes, u64 parent, u64
>>> root_objectid,
>>> -                     u64 owner, u64 offset, int no_quota);
>>> +                     u64 owner, u64 offset);
>>>
>>>   int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64
>>> len,
>>>                                 int delalloc);
>>> @@ -3435,7 +3435,7 @@ int btrfs_finish_extent_commit(struct
>>> btrfs_trans_handle *trans,
>>>   int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>>                           struct btrfs_root *root,
>>>                           u64 bytenr, u64 num_bytes, u64 parent,
>>> -                        u64 root_objectid, u64 owner, u64 offset, int
>>> no_quota);
>>> +                        u64 root_objectid, u64 owner, u64 offset);
>>>
>>>   int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans,
>>>                                     struct btrfs_root *root);
>>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>>> index bd9b63b..449974f 100644
>>> --- a/fs/btrfs/delayed-ref.c
>>> +++ b/fs/btrfs/delayed-ref.c
>>> @@ -292,8 +292,7 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle
>>> *trans,
>>>          exist = list_entry(href->ref_list.prev, struct
>>> btrfs_delayed_ref_node,
>>>                             list);
>>>          /* No need to compare bytenr nor is_head */
>>> -       if (exist->type != ref->type || exist->no_quota != ref->no_quota
>>> ||
>>> -           exist->seq != ref->seq)
>>> +       if (exist->type != ref->type || exist->seq != ref->seq)
>>>                  goto add_tail;
>>>
>>>          if ((exist->type == BTRFS_TREE_BLOCK_REF_KEY ||
>>> @@ -526,7 +525,7 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>>                       struct btrfs_delayed_ref_head *head_ref,
>>>                       struct btrfs_delayed_ref_node *ref, u64 bytenr,
>>>                       u64 num_bytes, u64 parent, u64 ref_root, int level,
>>> -                    int action, int no_quota)
>>> +                    int action)
>>>   {
>>>          struct btrfs_delayed_tree_ref *full_ref;
>>>          struct btrfs_delayed_ref_root *delayed_refs;
>>> @@ -548,7 +547,6 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>>          ref->action = action;
>>>          ref->is_head = 0;
>>>          ref->in_tree = 1;
>>> -       ref->no_quota = no_quota;
>>>          ref->seq = seq;
>>>
>>>          full_ref = btrfs_delayed_node_to_tree_ref(ref);
>>> @@ -581,7 +579,7 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>>                       struct btrfs_delayed_ref_head *head_ref,
>>>                       struct btrfs_delayed_ref_node *ref, u64 bytenr,
>>>                       u64 num_bytes, u64 parent, u64 ref_root, u64 owner,
>>> -                    u64 offset, int action, int no_quota)
>>> +                    u64 offset, int action)
>>>   {
>>>          struct btrfs_delayed_data_ref *full_ref;
>>>          struct btrfs_delayed_ref_root *delayed_refs;
>>> @@ -604,7 +602,6 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>>          ref->action = action;
>>>          ref->is_head = 0;
>>>          ref->in_tree = 1;
>>> -       ref->no_quota = no_quota;
>>>          ref->seq = seq;
>>>
>>>          full_ref = btrfs_delayed_node_to_data_ref(ref);
>>> @@ -635,17 +632,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info
>>> *fs_info,
>>>                                 struct btrfs_trans_handle *trans,
>>>                                 u64 bytenr, u64 num_bytes, u64 parent,
>>>                                 u64 ref_root,  int level, int action,
>>> -                              struct btrfs_delayed_extent_op *extent_op,
>>> -                              int no_quota)
>>> +                              struct btrfs_delayed_extent_op *extent_op)
>>>   {
>>>          struct btrfs_delayed_tree_ref *ref;
>>>          struct btrfs_delayed_ref_head *head_ref;
>>>          struct btrfs_delayed_ref_root *delayed_refs;
>>>          struct btrfs_qgroup_extent_record *record = NULL;
>>>
>>> -       if (!is_fstree(ref_root) || !fs_info->quota_enabled)
>>> -               no_quota = 0;
>>> -
>>>          BUG_ON(extent_op && extent_op->is_data);
>>>          ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
>>>          if (!ref)
>>> @@ -674,8 +667,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info
>>> *fs_info,
>>>                                          bytenr, num_bytes, action, 0);
>>>
>>>          add_delayed_tree_ref(fs_info, trans, head_ref, &ref->node,
>>> bytenr,
>>> -                                  num_bytes, parent, ref_root, level,
>>> action,
>>> -                                  no_quota);
>>> +                            num_bytes, parent, ref_root, level, action);
>>>          spin_unlock(&delayed_refs->lock);
>>>
>>>          return 0;
>>> @@ -696,17 +688,13 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info
>>> *fs_info,
>>>                                 u64 bytenr, u64 num_bytes,
>>>                                 u64 parent, u64 ref_root,
>>>                                 u64 owner, u64 offset, int action,
>>> -                              struct btrfs_delayed_extent_op *extent_op,
>>> -                              int no_quota)
>>> +                              struct btrfs_delayed_extent_op *extent_op)
>>>   {
>>>          struct btrfs_delayed_data_ref *ref;
>>>          struct btrfs_delayed_ref_head *head_ref;
>>>          struct btrfs_delayed_ref_root *delayed_refs;
>>>          struct btrfs_qgroup_extent_record *record = NULL;
>>>
>>> -       if (!is_fstree(ref_root) || !fs_info->quota_enabled)
>>> -               no_quota = 0;
>>> -
>>>          BUG_ON(extent_op && !extent_op->is_data);
>>>          ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
>>>          if (!ref)
>>> @@ -742,7 +730,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info
>>> *fs_info,
>>>
>>>          add_delayed_data_ref(fs_info, trans, head_ref, &ref->node,
>>> bytenr,
>>>                                     num_bytes, parent, ref_root, owner,
>>> offset,
>>> -                                  action, no_quota);
>>> +                                  action);
>>>          spin_unlock(&delayed_refs->lock);
>>>
>>>          return 0;
>>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>>> index d4c41e2..f9cf234 100644
>>> --- a/fs/btrfs/delayed-ref.h
>>> +++ b/fs/btrfs/delayed-ref.h
>>> @@ -68,7 +68,6 @@ struct btrfs_delayed_ref_node {
>>>
>>>          unsigned int action:8;
>>>          unsigned int type:8;
>>> -       unsigned int no_quota:1;
>>>          /* is this node still in the rbtree? */
>>>          unsigned int is_head:1;
>>>          unsigned int in_tree:1;
>>> @@ -244,15 +243,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info
>>> *fs_info,
>>>                                 struct btrfs_trans_handle *trans,
>>>                                 u64 bytenr, u64 num_bytes, u64 parent,
>>>                                 u64 ref_root, int level, int action,
>>> -                              struct btrfs_delayed_extent_op *extent_op,
>>> -                              int no_quota);
>>> +                              struct btrfs_delayed_extent_op
>>> *extent_op);
>>>   int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>>                                 struct btrfs_trans_handle *trans,
>>>                                 u64 bytenr, u64 num_bytes,
>>>                                 u64 parent, u64 ref_root,
>>>                                 u64 owner, u64 offset, int action,
>>> -                              struct btrfs_delayed_extent_op *extent_op,
>>> -                              int no_quota);
>>> +                              struct btrfs_delayed_extent_op
>>> *extent_op);
>>>   int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
>>>                                       struct btrfs_trans_handle *trans,
>>>                                       u64 ref_root, u64 bytenr, u64
>>> num_bytes);
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 92fdbc6..d47b11d 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -95,8 +95,7 @@ static int alloc_reserved_tree_block(struct
>>> btrfs_trans_handle *trans,
>>>                                       struct btrfs_root *root,
>>>                                       u64 parent, u64 root_objectid,
>>>                                       u64 flags, struct btrfs_disk_key
>>> *key,
>>> -                                    int level, struct btrfs_key *ins,
>>> -                                    int no_quota);
>>> +                                    int level, struct btrfs_key *ins);
>>>   static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>>>                            struct btrfs_root *extent_root, u64 flags,
>>>                            int force);
>>> @@ -2073,8 +2072,7 @@ int btrfs_discard_extent(struct btrfs_root *root,
>>> u64 bytenr,
>>>   int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>>                           struct btrfs_root *root,
>>>                           u64 bytenr, u64 num_bytes, u64 parent,
>>> -                        u64 root_objectid, u64 owner, u64 offset,
>>> -                        int no_quota)
>>> +                        u64 root_objectid, u64 owner, u64 offset)
>>>   {
>>>          int ret;
>>>          struct btrfs_fs_info *fs_info = root->fs_info;
>>> @@ -2086,12 +2084,12 @@ int btrfs_inc_extent_ref(struct
>>> btrfs_trans_handle *trans,
>>>                  ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
>>>                                          num_bytes,
>>>                                          parent, root_objectid,
>>> (int)owner,
>>> -                                       BTRFS_ADD_DELAYED_REF, NULL,
>>> no_quota);
>>> +                                       BTRFS_ADD_DELAYED_REF, NULL);
>>>          } else {
>>>                  ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
>>>                                          num_bytes,
>>>                                          parent, root_objectid, owner,
>>> offset,
>>> -                                       BTRFS_ADD_DELAYED_REF, NULL,
>>> no_quota);
>>> +                                       BTRFS_ADD_DELAYED_REF, NULL);
>>>          }
>>>          return ret;
>>>   }
>>> @@ -2112,15 +2110,11 @@ static int __btrfs_inc_extent_ref(struct
>>> btrfs_trans_handle *trans,
>>>          u64 num_bytes = node->num_bytes;
>>>          u64 refs;
>>>          int ret;
>>> -       int no_quota = node->no_quota;
>>>
>>>          path = btrfs_alloc_path();
>>>          if (!path)
>>>                  return -ENOMEM;
>>>
>>> -       if (!is_fstree(root_objectid) || !root->fs_info->quota_enabled)
>>> -               no_quota = 1;
>>> -
>>>          path->reada = 1;
>>>          path->leave_spinning = 1;
>>>          /* this will setup the path even if it fails to insert the back
>>> ref */
>>> @@ -2355,8 +2349,7 @@ static int run_delayed_tree_ref(struct
>>> btrfs_trans_handle *trans,
>>>                                                  parent, ref_root,
>>>                                                  extent_op->flags_to_set,
>>>                                                  &extent_op->key,
>>> -                                               ref->level, &ins,
>>> -                                               node->no_quota);
>>> +                                               ref->level, &ins);
>>>          } else if (node->action == BTRFS_ADD_DELAYED_REF) {
>>>                  ret = __btrfs_inc_extent_ref(trans, root, node,
>>>                                               parent, ref_root,
>>> @@ -3178,7 +3171,7 @@ static int __btrfs_mod_ref(struct
>>> btrfs_trans_handle *trans,
>>>          int level;
>>>          int ret = 0;
>>>          int (*process_func)(struct btrfs_trans_handle *, struct
>>> btrfs_root *,
>>> -                           u64, u64, u64, u64, u64, u64, int);
>>> +                           u64, u64, u64, u64, u64, u64);
>>>
>>>
>>>          if (btrfs_test_is_dummy_root(root))
>>> @@ -3219,15 +3212,14 @@ static int __btrfs_mod_ref(struct
>>> btrfs_trans_handle *trans,
>>>                          key.offset -= btrfs_file_extent_offset(buf, fi);
>>>                          ret = process_func(trans, root, bytenr,
>>> num_bytes,
>>>                                             parent, ref_root,
>>> key.objectid,
>>> -                                          key.offset, 1);
>>> +                                          key.offset);
>>>                          if (ret)
>>>                                  goto fail;
>>>                  } else {
>>>                          bytenr = btrfs_node_blockptr(buf, i);
>>>                          num_bytes = root->nodesize;
>>>                          ret = process_func(trans, root, bytenr,
>>> num_bytes,
>>> -                                          parent, ref_root, level - 1,
>>> 0,
>>> -                                          1);
>>> +                                          parent, ref_root, level - 1,
>>> 0);
>>>                          if (ret)
>>>                                  goto fail;
>>>                  }
>>> @@ -6417,7 +6409,6 @@ static int __btrfs_free_extent(struct
>>> btrfs_trans_handle *trans,
>>>          int extent_slot = 0;
>>>          int found_extent = 0;
>>>          int num_to_del = 1;
>>> -       int no_quota = node->no_quota;
>>>          u32 item_size;
>>>          u64 refs;
>>>          u64 bytenr = node->bytenr;
>>> @@ -6426,9 +6417,6 @@ static int __btrfs_free_extent(struct
>>> btrfs_trans_handle *trans,
>>>          bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
>>>                                                   SKINNY_METADATA);
>>>
>>> -       if (!info->quota_enabled || !is_fstree(root_objectid))
>>> -               no_quota = 1;
>>> -
>>>          path = btrfs_alloc_path();
>>>          if (!path)
>>>                  return -ENOMEM;
>>> @@ -6754,7 +6742,7 @@ void btrfs_free_tree_block(struct
>>> btrfs_trans_handle *trans,
>>>                                          buf->start, buf->len,
>>>                                          parent, root->root_key.objectid,
>>>                                          btrfs_header_level(buf),
>>> -                                       BTRFS_DROP_DELAYED_REF, NULL, 0);
>>> +                                       BTRFS_DROP_DELAYED_REF, NULL);
>>>                  BUG_ON(ret); /* -ENOMEM */
>>>          }
>>>
>>> @@ -6802,7 +6790,7 @@ out:
>>>   /* Can return -ENOMEM */
>>>   int btrfs_free_extent(struct btrfs_trans_handle *trans, struct
>>> btrfs_root *root,
>>>                        u64 bytenr, u64 num_bytes, u64 parent, u64
>>> root_objectid,
>>> -                     u64 owner, u64 offset, int no_quota)
>>> +                     u64 owner, u64 offset)
>>>   {
>>>          int ret;
>>>          struct btrfs_fs_info *fs_info = root->fs_info;
>>> @@ -6825,13 +6813,13 @@ int btrfs_free_extent(struct btrfs_trans_handle
>>> *trans, struct btrfs_root *root,
>>>                  ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
>>>                                          num_bytes,
>>>                                          parent, root_objectid,
>>> (int)owner,
>>> -                                       BTRFS_DROP_DELAYED_REF, NULL,
>>> no_quota);
>>> +                                       BTRFS_DROP_DELAYED_REF, NULL);
>>>          } else {
>>>                  ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
>>>                                                  num_bytes,
>>>                                                  parent, root_objectid,
>>> owner,
>>>                                                  offset,
>>> BTRFS_DROP_DELAYED_REF,
>>> -                                               NULL, no_quota);
>>> +                                               NULL);
>>>          }
>>>          return ret;
>>>   }
>>> @@ -7676,8 +7664,7 @@ static int alloc_reserved_tree_block(struct
>>> btrfs_trans_handle *trans,
>>>                                       struct btrfs_root *root,
>>>                                       u64 parent, u64 root_objectid,
>>>                                       u64 flags, struct btrfs_disk_key
>>> *key,
>>> -                                    int level, struct btrfs_key *ins,
>>> -                                    int no_quota)
>>> +                                    int level, struct btrfs_key *ins)
>>>   {
>>>          int ret;
>>>          struct btrfs_fs_info *fs_info = root->fs_info;
>>> @@ -7767,7 +7754,7 @@ int btrfs_alloc_reserved_file_extent(struct
>>> btrfs_trans_handle *trans,
>>>          ret = btrfs_add_delayed_data_ref(root->fs_info, trans,
>>> ins->objectid,
>>>                                           ins->offset, 0,
>>>                                           root_objectid, owner, offset,
>>> -                                        BTRFS_ADD_DELAYED_EXTENT, NULL,
>>> 0);
>>> +                                        BTRFS_ADD_DELAYED_EXTENT, NULL);
>>>          return ret;
>>>   }
>>>
>>> @@ -7981,7 +7968,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct
>>> btrfs_trans_handle *trans,
>>>                                                   ins.objectid,
>>> ins.offset,
>>>                                                   parent, root_objectid,
>>> level,
>>>
>>> BTRFS_ADD_DELAYED_EXTENT,
>>> -                                                extent_op, 0);
>>> +                                                extent_op);
>>>                  if (ret)
>>>                          goto out_free_delayed;
>>>          }
>>> @@ -8530,7 +8517,7 @@ skip:
>>>                          }
>>>                  }
>>>                  ret = btrfs_free_extent(trans, root, bytenr, blocksize,
>>> parent,
>>> -                               root->root_key.objectid, level - 1, 0,
>>> 0);
>>> +                               root->root_key.objectid, level - 1, 0);
>>>                  BUG_ON(ret); /* -ENOMEM */
>>>          }
>>>          btrfs_tree_unlock(next);
>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>> index 1243205..381be79 100644
>>> --- a/fs/btrfs/file.c
>>> +++ b/fs/btrfs/file.c
>>> @@ -847,7 +847,7 @@ next_slot:
>>>                                                  disk_bytenr, num_bytes,
>>> 0,
>>>                                                  root->root_key.objectid,
>>>                                                  new_key.objectid,
>>> -                                               start - extent_offset,
>>> 1);
>>> +                                               start - extent_offset);
>>>                                  BUG_ON(ret); /* -ENOMEM */
>>>                          }
>>>                          key.offset = start;
>>> @@ -925,7 +925,7 @@ delete_extent_item:
>>>                                                  disk_bytenr, num_bytes,
>>> 0,
>>>                                                  root->root_key.objectid,
>>>                                                  key.objectid, key.offset
>>> -
>>> -                                               extent_offset, 0);
>>> +                                               extent_offset);
>>>                                  BUG_ON(ret); /* -ENOMEM */
>>>                                  inode_sub_bytes(inode,
>>>                                                  extent_end -
>>> key.offset);
>>> @@ -1204,7 +1204,7 @@ again:
>>>
>>>                  ret = btrfs_inc_extent_ref(trans, root, bytenr,
>>> num_bytes, 0,
>>>                                             root->root_key.objectid,
>>> -                                          ino, orig_offset, 1);
>>> +                                          ino, orig_offset);
>>>                  BUG_ON(ret); /* -ENOMEM */
>>>
>>>                  if (split == start) {
>>> @@ -1231,7 +1231,7 @@ again:
>>>                  del_nr++;
>>>                  ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
>>>                                          0, root->root_key.objectid,
>>> -                                       ino, orig_offset, 0);
>>> +                                       ino, orig_offset);
>>>                  BUG_ON(ret); /* -ENOMEM */
>>>          }
>>>          other_start = 0;
>>> @@ -1248,7 +1248,7 @@ again:
>>>                  del_nr++;
>>>                  ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
>>>                                          0, root->root_key.objectid,
>>> -                                       ino, orig_offset, 0);
>>> +                                       ino, orig_offset);
>>>                  BUG_ON(ret); /* -ENOMEM */
>>>          }
>>>          if (del_nr == 0) {
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index a018e47..e8b7bc3 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -2595,7 +2595,7 @@ again:
>>>          ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
>>>                          new->disk_len, 0,
>>>                          backref->root_id, backref->inum,
>>> -                       new->file_pos, 0);      /* start - extent_offset
>>> */
>>> +                       new->file_pos);         /* start - extent_offset
>>> */
>>>          if (ret) {
>>>                  btrfs_abort_transaction(trans, root, ret);
>>>                  goto out_free_path;
>>> @@ -4541,7 +4541,7 @@ delete:
>>>                          ret = btrfs_free_extent(trans, root,
>>> extent_start,
>>>                                                  extent_num_bytes, 0,
>>>
>>> btrfs_header_owner(leaf),
>>> -                                               ino, extent_offset, 0);
>>> +                                               ino, extent_offset);
>>>                          BUG_ON(ret);
>>>                          if (btrfs_should_throttle_delayed_refs(trans,
>>> root))
>>>                                  btrfs_async_run_delayed_refs(root,
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 7ed033a..da6ccdf 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -3206,41 +3206,6 @@ out:
>>>          return ret;
>>>   }
>>>
>>> -/* Helper to check and see if this root currently has a ref on the given
>>> disk
>>> - * bytenr.  If it does then we need to update the quota for this root.
>>> This
>>> - * doesn't do anything if quotas aren't enabled.
>>> - */
>>> -static int check_ref(struct btrfs_trans_handle *trans, struct btrfs_root
>>> *root,
>>> -                    u64 disko)
>>> -{
>>> -       struct seq_list tree_mod_seq_elem =
>>> SEQ_LIST_INIT(tree_mod_seq_elem);
>>> -       struct ulist *roots;
>>> -       struct ulist_iterator uiter;
>>> -       struct ulist_node *root_node = NULL;
>>> -       int ret;
>>> -
>>> -       if (!root->fs_info->quota_enabled)
>>> -               return 1;
>>> -
>>> -       btrfs_get_tree_mod_seq(root->fs_info, &tree_mod_seq_elem);
>>> -       ret = btrfs_find_all_roots(trans, root->fs_info, disko,
>>> -                                  tree_mod_seq_elem.seq, &roots);
>>> -       if (ret < 0)
>>> -               goto out;
>>> -       ret = 0;
>>> -       ULIST_ITER_INIT(&uiter);
>>> -       while ((root_node = ulist_next(roots, &uiter))) {
>>> -               if (root_node->val == root->objectid) {
>>> -                       ret = 1;
>>> -                       break;
>>> -               }
>>> -       }
>>> -       ulist_free(roots);
>>> -out:
>>> -       btrfs_put_tree_mod_seq(root->fs_info, &tree_mod_seq_elem);
>>> -       return ret;
>>> -}
>>> -
>>>   static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
>>>                                       struct inode *inode,
>>>                                       u64 endoff,
>>> @@ -3501,7 +3466,6 @@ static int btrfs_clone(struct inode *src, struct
>>> inode *inode,
>>>          int ret;
>>>          int no_quota;
>>>          const u64 len = olen_aligned;
>>> -       u64 last_disko = 0;
>>>          u64 last_dest_end = destoff;
>>>
>>>          ret = -ENOMEM;
>>> @@ -3699,35 +3663,13 @@ process_slot:
>>>                                  btrfs_set_file_extent_num_bytes(leaf,
>>> extent,
>>>                                                                  datal);
>>>
>>> -                               /*
>>> -                                * We need to look up the roots that
>>> point at
>>> -                                * this bytenr and see if the new root
>>> does.  If
>>> -                                * it does not we need to make sure we
>>> update
>>> -                                * quotas appropriately.
>>> -                                */
>>> -                               if (disko && root != BTRFS_I(src)->root
>>> &&
>>> -                                   disko != last_disko) {
>>> -                                       no_quota = check_ref(trans, root,
>>> -                                                            disko);
>>> -                                       if (no_quota < 0) {
>>> -
>>> btrfs_abort_transaction(trans,
>>> -
>>> root,
>>> -
>>> ret);
>>> -
>>> btrfs_end_transaction(trans,
>>> -
>>> root);
>>> -                                               ret = no_quota;
>>> -                                               goto out;
>>> -                                       }
>>> -                               }
>>> -
>>>                                  if (disko) {
>>>                                          inode_add_bytes(inode, datal);
>>>                                          ret =
>>> btrfs_inc_extent_ref(trans, root,
>>>                                                          disko, diskl, 0,
>>>
>>> root->root_key.objectid,
>>>
>>> btrfs_ino(inode),
>>> -                                                       new_key.offset -
>>> datao,
>>> -                                                       no_quota);
>>> +                                                       new_key.offset -
>>> datao);
>>>                                          if (ret) {
>>>
>>> btrfs_abort_transaction(trans,
>>>
>>> root,
>>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>>> index a7dc456..b4ca545 100644
>>> --- a/fs/btrfs/relocation.c
>>> +++ b/fs/btrfs/relocation.c
>>> @@ -1716,7 +1716,7 @@ int replace_file_extents(struct btrfs_trans_handle
>>> *trans,
>>>                  ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
>>>                                             num_bytes, parent,
>>>                                             btrfs_header_owner(leaf),
>>> -                                          key.objectid, key.offset, 1);
>>> +                                          key.objectid, key.offset);
>>>                  if (ret) {
>>>                          btrfs_abort_transaction(trans, root, ret);
>>>                          break;
>>> @@ -1724,7 +1724,7 @@ int replace_file_extents(struct btrfs_trans_handle
>>> *trans,
>>>
>>>                  ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
>>>                                          parent,
>>> btrfs_header_owner(leaf),
>>> -                                       key.objectid, key.offset, 1);
>>> +                                       key.objectid, key.offset);
>>>                  if (ret) {
>>>                          btrfs_abort_transaction(trans, root, ret);
>>>                          break;
>>> @@ -1900,23 +1900,21 @@ again:
>>>
>>>                  ret = btrfs_inc_extent_ref(trans, src, old_bytenr,
>>> blocksize,
>>>                                          path->nodes[level]->start,
>>> -                                       src->root_key.objectid, level -
>>> 1, 0,
>>> -                                       1);
>>> +                                       src->root_key.objectid, level -
>>> 1, 0);
>>>                  BUG_ON(ret);
>>>                  ret = btrfs_inc_extent_ref(trans, dest, new_bytenr,
>>> blocksize,
>>>                                          0, dest->root_key.objectid,
>>> level - 1,
>>> -                                       0, 1);
>>> +                                       0);
>>>                  BUG_ON(ret);
>>>
>>>                  ret = btrfs_free_extent(trans, src, new_bytenr,
>>> blocksize,
>>>                                          path->nodes[level]->start,
>>> -                                       src->root_key.objectid, level -
>>> 1, 0,
>>> -                                       1);
>>> +                                       src->root_key.objectid, level -
>>> 1, 0);
>>>                  BUG_ON(ret);
>>>
>>>                  ret = btrfs_free_extent(trans, dest, old_bytenr,
>>> blocksize,
>>>                                          0, dest->root_key.objectid,
>>> level - 1,
>>> -                                       0, 1);
>>> +                                       0);
>>>                  BUG_ON(ret);
>>>
>>>                  btrfs_unlock_up_safe(path, 0);
>>> @@ -2745,7 +2743,7 @@ static int do_relocation(struct btrfs_trans_handle
>>> *trans,
>>>                                                  node->eb->start,
>>> blocksize,
>>>                                                  upper->eb->start,
>>>
>>> btrfs_header_owner(upper->eb),
>>> -                                               node->level, 0, 1);
>>> +                                               node->level, 0);
>>>                          BUG_ON(ret);
>>>
>>>                          ret = btrfs_drop_subtree(trans, root, eb,
>>> upper->eb);
>>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>>> index 1fffe88..323e12c 100644
>>> --- a/fs/btrfs/tree-log.c
>>> +++ b/fs/btrfs/tree-log.c
>>> @@ -693,7 +693,7 @@ static noinline int replay_one_extent(struct
>>> btrfs_trans_handle *trans,
>>>                                  ret = btrfs_inc_extent_ref(trans, root,
>>>                                                  ins.objectid,
>>> ins.offset,
>>>                                                  0,
>>> root->root_key.objectid,
>>> -                                               key->objectid, offset,
>>> 0);
>>> +                                               key->objectid, offset);
>>>                                  if (ret)
>>>                                          goto out;
>>>                          } else {
>>> --
>>> 2.6.2
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
