Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24074 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbcD0PTR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 11:19:17 -0400
Subject: Re: [PATCH] Btrfs: fix qgroup accounting when snapshotting
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>,
        <mfasheh@suse.de>
References: <1461680685-2432-1-git-send-email-jbacik@fb.com>
 <1d9f9fed-8f31-04fc-66d3-41ce77ff6a94@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <8d0fb4f5-9701-b2e1-172e-e60bd178b2f3@fb.com>
Date: Wed, 27 Apr 2016 11:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <1d9f9fed-8f31-04fc-66d3-41ce77ff6a94@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/2016 09:19 PM, Qu Wenruo wrote:
>
>
> Josef Bacik wrote on 2016/04/26 10:24 -0400:
>> The new qgroup stuff needs the quota accounting to be run before doing
>> the
>> inherit, unfortunately they need the commit root switch to happen at a
>> specific
>> time for this to work properly.  Fix this by delaying the inherit
>> until after we
>> do the qgroup accounting, and remove the inherit and accounting dance in
>> create_pending_snapshot.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>  fs/btrfs/transaction.c | 51
>> ++++++++++++++++++++++++++++++--------------------
>>  fs/btrfs/transaction.h |  1 +
>>  2 files changed, 32 insertions(+), 20 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 7c7671d..aa3025a 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -1353,6 +1353,7 @@ static noinline int
>> create_pending_snapshot(struct btrfs_trans_handle *trans,
>>      pending->error = btrfs_find_free_objectid(tree_root, &objectid);
>>      if (pending->error)
>>          goto no_free_objectid;
>> +    pending->objectid = objectid;
>>
>>      /*
>>       * Make qgroup to skip current new snapshot's qgroupid, as it is
>> @@ -1559,24 +1560,6 @@ static noinline int
>> create_pending_snapshot(struct btrfs_trans_handle *trans,
>>          btrfs_abort_transaction(trans, root, ret);
>>          goto fail;
>>      }
>> -
>> -    /*
>> -     * account qgroup counters before qgroup_inherit()
>> -     */
>> -    ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
>> -    if (ret)
>> -        goto fail;
>> -    ret = btrfs_qgroup_account_extents(trans, fs_info);
>> -    if (ret)
>> -        goto fail;
>> -    ret = btrfs_qgroup_inherit(trans, fs_info,
>> -                   root->root_key.objectid,
>> -                   objectid, pending->inherit);
>> -    if (ret) {
>> -        btrfs_abort_transaction(trans, root, ret);
>> -        goto fail;
>> -    }
>> -
>>  fail:
>>      pending->error = ret;
>>  dir_item_existed:
>> @@ -1599,15 +1582,35 @@ no_free_objectid:
>>  static noinline int create_pending_snapshots(struct
>> btrfs_trans_handle *trans,
>>                           struct btrfs_fs_info *fs_info)
>>  {
>> +    struct btrfs_pending_snapshot *pending;
>> +    struct list_head *head = &trans->transaction->pending_snapshots;
>> +    int ret = 0;
>> +
>> +    list_for_each_entry(pending, head, list) {
>> +        ret = create_pending_snapshot(trans, fs_info, pending);
>> +        if (ret)
>> +            break;
>> +    }
>> +    return ret;
>> +}
>> +
>> +static noinline int inherit_pending_snapshots(struct
>> btrfs_trans_handle *trans,
>> +                          struct btrfs_fs_info *fs_info)
>> +{
>>      struct btrfs_pending_snapshot *pending, *next;
>>      struct list_head *head = &trans->transaction->pending_snapshots;
>>      int ret = 0;
>>
>>      list_for_each_entry_safe(pending, next, head, list) {
>> +        struct btrfs_root *root = pending->root;
>>          list_del(&pending->list);
>> -        ret = create_pending_snapshot(trans, fs_info, pending);
>> -        if (ret)
>> +        ret = btrfs_qgroup_inherit(trans, fs_info,
>> +                       root->root_key.objectid,
>> +                       pending->objectid, pending->inherit);
>
> It's too late to call qgroup_inherit() here.
> As we already inserted DIR_ITEM into parent_root.
>
> This will cause qgroup difference, if parent_root is also the src_root.
>
>
> But your fix provides a very potential fix method.
> If we didn't do the DIR_ITEM insert in create_pending_snapshot, but do
> the insert after all qgroup_inherit() is done,
> the problem may have a better fix.
>
> Although I am still concerning about the DIR_ITEM insert.
> As we still need to account them, and since we must run qgroup
> accounting before qgroup_inherit(), I'm afraid we still need to do the
> commit hack though.
>

Ugh I forgot about that.  It would be nice to use the tree mod log here, 
but the rework makes that tricky.  Basically we'd need to delay any 
modifications to the extent tree until after we do the inherit, so do 
btrfs_get_tree_mod_seq() and store it in the pending, and then do the 
inherit, and then put the seq and re-run the delayed refs and the qgroup 
accounting.

This is hard because this will keep us from running delayed refs, and we 
do btrfs_run_delayed_refs(-1) a few times in between so we'd deadlock 
because we would find delayed refs on the tree still.

I'm not sure how to fix this without undoing what we have and going 
back.  I'll think about it some more.  Thanks,

Josef

