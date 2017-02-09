Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41582 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752446AbdBIBbD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 20:31:03 -0500
Subject: Re: [PATCH] btrfs: qgroup: Move half of the qgroup accounting time
 out of commit trans
To: <fdmanana@gmail.com>
References: <20170208015607.5184-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H5Liqsb6CVxRe-RWAa+NC38wGeK1KMDPCRKVR-yMGQj5A@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6bb5cb8c-a511-3362-9def-c7cceb937502@cn.fujitsu.com>
Date: Thu, 9 Feb 2017 09:21:30 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5Liqsb6CVxRe-RWAa+NC38wGeK1KMDPCRKVR-yMGQj5A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/08/2017 10:09 PM, Filipe Manana wrote:
> On Wed, Feb 8, 2017 at 1:56 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Just as Filipe pointed out, the most time consuming part of qgroup is
>> btrfs_qgroup_account_extents() and
>> btrfs_qgroup_prepare_account_extents().
>
> there's an "and" so the "is" should be "are" and "part" should be "parts".
>
>> Which both call btrfs_find_all_roots() to get old_roots and new_roots
>> ulist.
>>
>> However for old_roots, we don't really need to calculate it at transaction
>> commit time.
>>
>> This patch moves the old_roots accounting part out of
>> commit_transaction(), so at least we won't block transaction too long.
>
> Doing stuff inside btrfs_commit_transaction() is only bad if it's
> within the critical section, that is, after setting the transaction's
> state to TRANS_STATE_COMMIT_DOING and before setting the state to
> TRANS_STATE_UNBLOCKED. This should be explained somehow in the
> changelog.

In this context, only critical section is under concern

>
>>
>> But please note that, this won't speedup qgroup overall, it just moves
>> half of the cost out of commit_transaction().
>>
>> Cc: Filipe Manana <fdmanana@suse.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/delayed-ref.c | 20 ++++++++++++++++----
>>  fs/btrfs/qgroup.c      | 33 ++++++++++++++++++++++++++++++---
>>  fs/btrfs/qgroup.h      | 14 ++++++++++++++
>>  3 files changed, 60 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index ef724a5..0ee927e 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -550,13 +550,14 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>                      struct btrfs_delayed_ref_node *ref,
>>                      struct btrfs_qgroup_extent_record *qrecord,
>>                      u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
>> -                    int action, int is_data)
>> +                    int action, int is_data, int *qrecord_inserted_ret)
>>  {
>>         struct btrfs_delayed_ref_head *existing;
>>         struct btrfs_delayed_ref_head *head_ref = NULL;
>>         struct btrfs_delayed_ref_root *delayed_refs;
>>         int count_mod = 1;
>>         int must_insert_reserved = 0;
>> +       int qrecord_inserted = 0;
>>
>>         /* If reserved is provided, it must be a data extent. */
>>         BUG_ON(!is_data && reserved);
>> @@ -623,6 +624,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>                 if(btrfs_qgroup_trace_extent_nolock(fs_info,
>>                                         delayed_refs, qrecord))
>>                         kfree(qrecord);
>> +               else
>> +                       qrecord_inserted = 1;
>>         }
>>
>>         spin_lock_init(&head_ref->lock);
>> @@ -650,6 +653,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>                 atomic_inc(&delayed_refs->num_entries);
>>                 trans->delayed_ref_updates++;
>>         }
>> +       if (qrecord_inserted_ret)
>> +               *qrecord_inserted_ret = qrecord_inserted;
>>         return head_ref;
>>  }
>>
>> @@ -779,6 +784,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>         struct btrfs_delayed_ref_head *head_ref;
>>         struct btrfs_delayed_ref_root *delayed_refs;
>>         struct btrfs_qgroup_extent_record *record = NULL;
>> +       int qrecord_inserted;
>>
>>         BUG_ON(extent_op && extent_op->is_data);
>>         ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
>> @@ -806,12 +812,15 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>          * the spin lock
>>          */
>>         head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
>> -                                       bytenr, num_bytes, 0, 0, action, 0);
>> +                                       bytenr, num_bytes, 0, 0, action, 0,
>> +                                       &qrecord_inserted);
>>
>>         add_delayed_tree_ref(fs_info, trans, head_ref, &ref->node, bytenr,
>>                              num_bytes, parent, ref_root, level, action);
>>         spin_unlock(&delayed_refs->lock);
>>
>> +       if (qrecord_inserted)
>> +               return btrfs_qgroup_trace_extent_post(fs_info, record);
>>         return 0;
>>
>>  free_head_ref:
>> @@ -836,6 +845,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>         struct btrfs_delayed_ref_head *head_ref;
>>         struct btrfs_delayed_ref_root *delayed_refs;
>>         struct btrfs_qgroup_extent_record *record = NULL;
>> +       int qrecord_inserted;
>>
>>         BUG_ON(extent_op && !extent_op->is_data);
>>         ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
>> @@ -870,13 +880,15 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>          */
>>         head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
>>                                         bytenr, num_bytes, ref_root, reserved,
>> -                                       action, 1);
>> +                                       action, 1, &qrecord_inserted);
>>
>>         add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
>>                                    num_bytes, parent, ref_root, owner, offset,
>>                                    action);
>>         spin_unlock(&delayed_refs->lock);
>>
>> +       if (qrecord_inserted)
>> +               return btrfs_qgroup_trace_extent_post(fs_info, record);
>>         return 0;
>>  }
>>
>> @@ -899,7 +911,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>>
>>         add_delayed_ref_head(fs_info, trans, &head_ref->node, NULL, bytenr,
>>                              num_bytes, 0, 0, BTRFS_UPDATE_DELAYED_HEAD,
>> -                            extent_op->is_data);
>> +                            extent_op->is_data, NULL);
>>
>>         spin_unlock(&delayed_refs->lock);
>>         return 0;
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 662821f..971cce15 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1446,8 +1446,9 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
>>         while (node) {
>>                 record = rb_entry(node, struct btrfs_qgroup_extent_record,
>>                                   node);
>> -               ret = btrfs_find_all_roots(NULL, fs_info, record->bytenr, 0,
>> -                                          &record->old_roots);
>> +               if (WARN_ON(!record->old_roots))
>> +                       ret = btrfs_find_all_roots(NULL, fs_info,
>> +                                       record->bytenr, 0, &record->old_roots);
>>                 if (ret < 0)
>>                         break;
>>                 if (qgroup_to_skip)
>> @@ -1486,6 +1487,28 @@ int btrfs_qgroup_trace_extent_nolock(struct btrfs_fs_info *fs_info,
>>         return 0;
>>  }
>>
>> +int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
>> +                                  struct btrfs_qgroup_extent_record *qrecord)
>> +{
>> +       struct ulist *old_root;
>> +       u64 bytenr = qrecord->bytenr;
>> +       int ret;
>> +
>> +       ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       /*
>> +        * Here we don't need to get the lock of
>> +        * trans->transcation->delayed_refs, since inserted qrecord won't
>
> transcation -> transaction
>
>> +        * be deleted, only qrecord->node may be modified (new qrecord insert)
>> +        *
>> +        * So modifying qrecord->old_roots is safe here
>> +        */
>> +       qrecord->old_roots = old_root;
>> +       return 0;
>> +}
>> +
>>  int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
>>                 struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
>>                 gfp_t gfp_flag)
>> @@ -1506,7 +1529,11 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
>>         delayed_refs = &trans->transaction->delayed_refs;
>>         record->bytenr = bytenr;
>>         record->num_bytes = num_bytes;
>> -       record->old_roots = NULL;
>> +       ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &record->old_roots);
>> +       if (ret < 0) {
>> +               kfree(record);
>> +               return ret;
>> +       }
>>
>>         spin_lock(&delayed_refs->lock);
>>         ret = btrfs_qgroup_trace_extent_nolock(fs_info, delayed_refs, record);
>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>> index 416ae8e..f7086a3 100644
>> --- a/fs/btrfs/qgroup.h
>> +++ b/fs/btrfs/qgroup.h
>> @@ -98,6 +98,10 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
>>   *
>>   * No lock version, caller must acquire delayed ref lock and allocate memory.
>>   *
>> + * NOTE: To reduce time consumed at commit_trans time, we must call
>> + * btrfs_qgroup_trace_extent_post() to balance half of the account time
>> + * if record is inserted successfully.
>
> So this comment is misleading and offers little value because:
>
> 1) What is commit_trans? It's not a word nor de we have anything named
> like that - we have btrfs_commit_transaction(), or you can say "at
> transaction commit time".

Just to save several letters, I'll chose the latter expression.

>
> 2) Why is it bad to do things at btrfs_transaction_commit()? It's only
> bad depending on where during the commit it's done. And that where is
> between setting the transaction's state to TRANS_STATE_COMMIT_DOING
> and before setting the state to TRANS_STATE_UNBLOCKED. We do other
> heavy stuff inside btrfs_commit_transaction(), but outside that
> critical section and that's ok (like starting the writes for the space
> caches for example). So if you want to keep a comment to help
> understand things, just make sure it's really informative and explains
> the problem the code tries to solve or avoid.\
>
> Now I haven't looked at the code nor tested the patch, so this is a
> review just of the comments and changelog from taking a quick look at
> the patch.
>
> Thanks.
>
>
>> + *
>>   * Return 0 for success insert
>>   * Return >0 for existing record, caller can free @record safely.
>>   * Error is not possible
>> @@ -108,6 +112,16 @@ int btrfs_qgroup_trace_extent_nolock(
>>                 struct btrfs_qgroup_extent_record *record);
>>
>>  /*
>> + * Post handler after qgroup_trace_extent_nolock().
>> + *
>> + * To balance half of the accounting out of commit_trans().
>> + * Can sleep. So can't be called at the same context of
>> + * qgroup_trace_extent_nolock()
>> + */
>> +int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
>> +                                  struct btrfs_qgroup_extent_record *qrecord);
>> +
>> +/*
>>   * Inform qgroup to trace one dirty extent, specified by @bytenr and
>>   * @num_bytes.
>>   * So qgroup can account it at commit trans time.
>> --
>> 2.9.3
>>
>>
>>
>
>
>


