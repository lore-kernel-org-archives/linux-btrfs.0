Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64753 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750937AbcDNBaW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Apr 2016 21:30:22 -0400
Subject: Re: [PATCH v2] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
To: <fdmanana@gmail.com>
References: <1460446522-1919-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H5k_NWHFwvVQSdDLr0Gsg+ENgG3QSd_24Vi0XU3NZ-OFg@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <570EF2A9.8090808@cn.fujitsu.com>
Date: Thu, 14 Apr 2016 09:30:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5k_NWHFwvVQSdDLr0Gsg+ENgG3QSd_24Vi0XU3NZ-OFg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/04/13 17:23 +0100:
> On Tue, Apr 12, 2016 at 8:35 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Current btrfs qgroup design implies a requirement that after calling
>> btrfs_qgroup_account_extents() there must be a commit root switch.
>>
>> Normally this is OK, as btrfs_qgroup_accounting_extents() is only called
>> inside btrfs_commit_transaction() just be commit_cowonly_roots().
>>
>> However there is a exception at create_pending_snapshot(), which will
>> call btrfs_qgroup_account_extents() but no any commit root switch.
>>
>> In case of creating a snapshot whose parent root is itself (create a
>> snapshot of fs tree), it will corrupt qgroup by the following trace:
>> (skipped unrelated data)
>> ======
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
>> ======
>>
>> The problem here is in first qgroup_account_extent(), the
>> nr_new_roots of the extent is 1, which means its reference got
>> increased, and qgroup increased its rfer and excl.
>>
>> But at second qgroup_account_extent(), its reference got decreased, but
>> between these two qgroup_account_extent(), there is no switch roots.
>> This leads to the same nr_old_roots, and this extent just got ignored by
>> qgroup, which means this extent is wrongly accounted.
>>
>> Fix it by call commit_cowonly_roots() after qgroup_account_extent() in
>> create_pending_snapshot(), with needed preparation.
>>
>> Reported-by: Mark Fasheh <mfasheh@suse.de>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> changelog:
>> v2:
>>    Fix a soft lockup caused by missing switch_commit_root() call.
>>    Fix a warning caused by dirty-but-not-committed root.
>>
>> Note:
>>    This may be the dirtiest hack I have ever done.
>
> I don't like it either. But, more importantly, I don't think this is
> correct. See below.
>
>>    As there are already several different judgment to check if a fs root
>>    should be updated. From root->last_trans to root->commit_root ==
>>    root->node.
>>
>>    With this patch, we must switch the root of at least related fs tree
>>    and extent tree to allow qgroup to call
>>    btrfs_qgroup_account_extents().
>>    But this will break some transid judgement, as transid is already
>>    updated to current transid.
>>    (maybe we need a special sub-transid for qgroup use only?)
>>
>>    As long as current qgroup use commit_root to determine old_roots,
>>    there is no better idea though.
>> ---
>>   fs/btrfs/transaction.c | 96 +++++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 71 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 43885e5..0f299a56 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -311,12 +311,13 @@ loop:
>>    * when the transaction commits
>>    */
>>   static int record_root_in_trans(struct btrfs_trans_handle *trans,
>> -                              struct btrfs_root *root)
>> +                              struct btrfs_root *root,
>> +                              int force)
>>   {
>> -       if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
>> -           root->last_trans < trans->transid) {
>> +       if ((test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
>> +           root->last_trans < trans->transid) || force) {
>>                  WARN_ON(root == root->fs_info->extent_root);
>> -               WARN_ON(root->commit_root != root->node);
>> +               WARN_ON(root->commit_root != root->node && !force);
>>
>>                  /*
>>                   * see below for IN_TRANS_SETUP usage rules
>> @@ -331,7 +332,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
>>                  smp_wmb();
>>
>>                  spin_lock(&root->fs_info->fs_roots_radix_lock);
>> -               if (root->last_trans == trans->transid) {
>> +               if (root->last_trans == trans->transid && !force) {
>>                          spin_unlock(&root->fs_info->fs_roots_radix_lock);
>>                          return 0;
>>                  }
>> @@ -402,7 +403,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
>>                  return 0;
>>
>>          mutex_lock(&root->fs_info->reloc_mutex);
>> -       record_root_in_trans(trans, root);
>> +       record_root_in_trans(trans, root, 0);
>>          mutex_unlock(&root->fs_info->reloc_mutex);
>>
>>          return 0;
>> @@ -1383,7 +1384,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>          dentry = pending->dentry;
>>          parent_inode = pending->dir;
>>          parent_root = BTRFS_I(parent_inode)->root;
>> -       record_root_in_trans(trans, parent_root);
>> +       record_root_in_trans(trans, parent_root, 0);
>>
>>          cur_time = current_fs_time(parent_inode->i_sb);
>>
>> @@ -1420,7 +1421,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>                  goto fail;
>>          }
>>
>> -       record_root_in_trans(trans, root);
>> +       record_root_in_trans(trans, root, 0);
>>          btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
>>          memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
>>          btrfs_check_and_init_root_item(new_root_item);
>> @@ -1516,6 +1517,62 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>                  goto fail;
>>          }
>>
>> +       /*
>> +        * Account qgroups before insert the dir item
>> +        * As such dir item insert will modify parent_root, which could be
>> +        * src root. If we don't do it now, wrong accounting may be inherited
>> +        * to snapshot qgroup.
>> +        *
>> +        * For reason locking tree_log_mutex, see btrfs_commit_transaction()
>> +        * comment
>> +        */
>> +       mutex_lock(&root->fs_info->tree_log_mutex);
>> +
>> +       ret = commit_fs_roots(trans, root);
>> +       if (ret) {
>> +               mutex_unlock(&root->fs_info->tree_log_mutex);
>> +               goto fail;
>> +       }
>> +
>> +       ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
>> +       if (ret < 0) {
>> +               mutex_unlock(&root->fs_info->tree_log_mutex);
>> +               goto fail;
>> +       }
>> +       ret = btrfs_qgroup_account_extents(trans, root->fs_info);
>> +       if (ret < 0) {
>> +               mutex_unlock(&root->fs_info->tree_log_mutex);
>> +               goto fail;
>> +       }
>> +       /*
>> +        * Now qgroup are all updated, we can inherit it to new qgroups
>> +        */
>> +       ret = btrfs_qgroup_inherit(trans, fs_info,
>> +                                  root->root_key.objectid,
>> +                                  objectid, pending->inherit);
>> +       if (ret < 0) {
>> +               mutex_unlock(&root->fs_info->tree_log_mutex);
>> +               goto fail;
>> +       }
>> +       /*
>> +        * qgroup_account_extents() must be followed by a
>> +        * switch_commit_roots(), or next qgroup_account_extents() will
>> +        * be corrupted
>> +        */
>> +       ret = commit_cowonly_roots(trans, root);
>> +       if (ret) {
>> +               mutex_unlock(&root->fs_info->tree_log_mutex);
>> +               goto fail;
>> +       }
>> +       /*
>> +        * Just like in btrfs_commit_transaction(), we need to
>> +        * switch_commit_roots().
>> +        * However this time we don't need to do a full one,
>> +        * excluding tree root and chunk root should be OK.
>> +        */
>> +       switch_commit_roots(trans->transaction, root->fs_info);
>
> This will undo commit 2b9dbef272b63c561aab0a5be34fd428f7b710f5 (Btrfs:
> keep dropped roots in cache until transaction commit). Won't it?
>
> So create_pending_snapshot() / create_pending_snapshots() are called
> at transaction commit before btrfs_qgroup_account_extents() is called.
> And with create_pending_snapshot() now calling switch_commit_roots()
> it means the roots for deleted snapshots and subvolumes are now gone
> before btrfs_qgroup_account_extents() gets called, so it can't do the
> correct calculations anymore for the cases described in that commit.
> That is, btrfs_qgroup_account_extents() must always be called before
> switch_commit_roots().
> Or did I miss something?

Wait a second, something seems strange.

As for normal routine, without creating any snapshot, 
qgroup_account_extents() is always called before switch_commit_roots().

That's to say, in commit_transaction(), qgroup doesn't account the roots 
deletion, and that roots deletion is accounted in next commit_transaction().

So unless I missed something, the original case seems OK.


And so is the current patch, which just moves the root deletion 
accounting into current transaction if we are creating snapshots.

In create_pending_snapshot() case, first btrfs_qgroup_account_extents() 
will account all the qgroup change happens in this transaction.
And then trigger a switch_commit_roots() which will then begin to delete 
dropped root.

Then we repeat create_pending_snapshot() or just return to 
btrfs_commit_transaction().
Either way, we will call btrfs_qgroup_account_extents() to reflect the 
root deletion.

Although there is still some difference.
As without this patch, root deletion is always accounted in next trans, 
while with this patch, root deletion is either accounted in current 
trans if we have pending snapshots, or accounted in next trans.

I'll still update the patch to v3 to make it behavior just as it was.

Thanks,
Qu



>
> We should have had a test case for that commit mentioned above, but
> that's another story...
>
>> +       mutex_unlock(&root->fs_info->tree_log_mutex);
>> +
>>          ret = btrfs_insert_dir_item(trans, parent_root,
>>                                      dentry->d_name.name, dentry->d_name.len,
>>                                      parent_inode, &key,
>> @@ -1527,6 +1584,12 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>                  goto fail;
>>          }
>>
>> +       /*
>> +        * Force parent root to be updated, as we recorded it before its
>> +        * last_trans == cur_transid
>> +        */
>> +       record_root_in_trans(trans, parent_root, 1);
>> +
>>          btrfs_i_size_write(parent_inode, parent_inode->i_size +
>>                                           dentry->d_name.len * 2);
>>          parent_inode->i_mtime = parent_inode->i_ctime =
>> @@ -1559,23 +1622,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>                  goto fail;
>>          }
>>
>> -       /*
>> -        * account qgroup counters before qgroup_inherit()
>> -        */
>> -       ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
>> -       if (ret)
>> -               goto fail;
>> -       ret = btrfs_qgroup_account_extents(trans, fs_info);
>> -       if (ret)
>> -               goto fail;
>> -       ret = btrfs_qgroup_inherit(trans, fs_info,
>> -                                  root->root_key.objectid,
>> -                                  objectid, pending->inherit);
>> -       if (ret) {
>> -               btrfs_abort_transaction(trans, root, ret);
>> -               goto fail;
>> -       }
>> -
>>   fail:
>>          pending->error = ret;
>>   dir_item_existed:
>> --
>> 2.8.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


