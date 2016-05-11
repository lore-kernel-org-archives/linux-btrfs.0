Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53628 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbcEKXeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 19:34:03 -0400
Subject: Re: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
To: Josef Bacik <jbacik@fb.com>, Mark Fasheh <mfasheh@suse.de>
References: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
 <571A697B.6050502@fb.com> <20160511165739.GH7633@wotan.suse.de>
 <754c27f2-4f00-da85-9a86-fe5f008a66c0@fb.com>
 <20160511195352.GI7633@wotan.suse.de>
 <beed8ba2-2d01-317b-5c9d-46c39745ed58@fb.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fdmanana@suse.com
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b158208f-16c5-a46c-b9ef-649e7af8d9e4@gmx.com>
Date: Thu, 12 May 2016 07:33:31 +0800
MIME-Version: 1.0
In-Reply-To: <beed8ba2-2d01-317b-5c9d-46c39745ed58@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/12/2016 04:30 AM, Josef Bacik wrote:
> On 05/11/2016 12:53 PM, Mark Fasheh wrote:
>> On Wed, May 11, 2016 at 09:59:52AM -0700, Josef Bacik wrote:
>>> On 05/11/2016 09:57 AM, Mark Fasheh wrote:
>>>> Hi Josef,
>>>>
>>>> On Fri, Apr 22, 2016 at 02:12:11PM -0400, Josef Bacik wrote:
>>>>> On 04/15/2016 05:08 AM, Qu Wenruo wrote:
>>>>>> Current btrfs qgroup design implies a requirement that after calling
>>>>>> btrfs_qgroup_account_extents() there must be a commit root switch.
>>>>>>
>>>>>> Normally this is OK, as btrfs_qgroup_accounting_extents() is only
>>>>>> called
>>>>>> inside btrfs_commit_transaction() just be commit_cowonly_roots().
>>>>>>
>>>>>> However there is a exception at create_pending_snapshot(), which will
>>>>>> call btrfs_qgroup_account_extents() but no any commit root switch.
>>>>>>
>>>>>> In case of creating a snapshot whose parent root is itself (create a
>>>>>> snapshot of fs tree), it will corrupt qgroup by the following trace:
>>>>>> (skipped unrelated data)
>>>>>> ======
>>>>>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384,
>>>>>> nr_old_roots = 0, nr_new_roots = 1
>>>>>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count
>>>>>> = 1, rfer = 0, excl = 0
>>>>>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count
>>>>>> = 1, rfer = 16384, excl = 16384
>>>>>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384,
>>>>>> nr_old_roots = 0, nr_new_roots = 0
>>>>>> ======
>>>>>>
>>>>>> The problem here is in first qgroup_account_extent(), the
>>>>>> nr_new_roots of the extent is 1, which means its reference got
>>>>>> increased, and qgroup increased its rfer and excl.
>>>>>>
>>>>>> But at second qgroup_account_extent(), its reference got
>>>>>> decreased, but
>>>>>> between these two qgroup_account_extent(), there is no switch roots.
>>>>>> This leads to the same nr_old_roots, and this extent just got
>>>>>> ignored by
>>>>>> qgroup, which means this extent is wrongly accounted.
>>>>>>
>>>>>> Fix it by call commit_cowonly_roots() after
>>>>>> qgroup_account_extent() in
>>>>>> create_pending_snapshot(), with needed preparation.
>>>>>>
>>>>>> Reported-by: Mark Fasheh <mfasheh@suse.de>
>>>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>>> ---
>>>>>> v2:
>>>>>>  Fix a soft lockup caused by missing switch_commit_root() call.
>>>>>>  Fix a warning caused by dirty-but-not-committed root.
>>>>>> v3:
>>>>>>  Fix a bug which will cause qgroup accounting for dropping snapshot
>>>>>>  wrong
>>>>>> v4:
>>>>>>  Fix a bug caused by non-cowed btree modification.
>>>>>>
>>>>>> To Filipe:
>>>>>>  I'm sorry I didn't wait for your reply on the dropped roots.
>>>>>>  I reverted back the version where we deleted dropped roots in
>>>>>>  switch_commit_roots().
>>>>>>
>>>>>>  As I think as long as we called
>>>>>> btrfs_qgroup_prepare_account_extents()
>>>>>>  and btrfs_qgroup_account_extents(), it should have already accounted
>>>>>>  extents for dropped roots, and then we are OK to drop them.
>>>>>>
>>>>>>  It would be very nice if you could point out what I missed.
>>>>>>  Thanks
>>>>>>  Qu
>>>>>> ---
>>>>>> fs/btrfs/transaction.c | 117
>>>>>> +++++++++++++++++++++++++++++++++++++++----------
>>>>>> 1 file changed, 93 insertions(+), 24 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>>>>> index 43885e5..92f8193 100644
>>>>>> --- a/fs/btrfs/transaction.c
>>>>>> +++ b/fs/btrfs/transaction.c
>>>>>> @@ -311,10 +311,11 @@ loop:
>>>>>>  * when the transaction commits
>>>>>>  */
>>>>>> static int record_root_in_trans(struct btrfs_trans_handle *trans,
>>>>>> -                   struct btrfs_root *root)
>>>>>> +                   struct btrfs_root *root,
>>>>>> +                   int force)
>>>>>> {
>>>>>> -    if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
>>>>>> -        root->last_trans < trans->transid) {
>>>>>> +    if ((test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
>>>>>> +        root->last_trans < trans->transid) || force) {
>>>>>>         WARN_ON(root == root->fs_info->extent_root);
>>>>>>         WARN_ON(root->commit_root != root->node);
>>>>>>
>>>>>> @@ -331,7 +332,7 @@ static int record_root_in_trans(struct
>>>>>> btrfs_trans_handle *trans,
>>>>>>         smp_wmb();
>>>>>>
>>>>>>         spin_lock(&root->fs_info->fs_roots_radix_lock);
>>>>>> -        if (root->last_trans == trans->transid) {
>>>>>> +        if (root->last_trans == trans->transid && !force) {
>>>>>>             spin_unlock(&root->fs_info->fs_roots_radix_lock);
>>>>>>             return 0;
>>>>>>         }
>>>>>> @@ -402,7 +403,7 @@ int btrfs_record_root_in_trans(struct
>>>>>> btrfs_trans_handle *trans,
>>>>>>         return 0;
>>>>>>
>>>>>>     mutex_lock(&root->fs_info->reloc_mutex);
>>>>>> -    record_root_in_trans(trans, root);
>>>>>> +    record_root_in_trans(trans, root, 0);
>>>>>>     mutex_unlock(&root->fs_info->reloc_mutex);
>>>>>>
>>>>>>     return 0;
>>>>>> @@ -1311,6 +1312,80 @@ int btrfs_defrag_root(struct btrfs_root *root)
>>>>>> }
>>>>>>
>>>>>> /*
>>>>>> + * Do all special snapshot related qgroup dirty hack.
>>>>>> + *
>>>>>> + * Will do all needed qgroup inherit and dirty hack like switch
>>>>>> commit
>>>>>> + * roots inside one transaction and write all btree into disk, to
>>>>>> make
>>>>>> + * qgroup works.
>>>>>> + */
>>>>>> +static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
>>>>>> +                   struct btrfs_root *src,
>>>>>> +                   struct btrfs_root *parent,
>>>>>> +                   struct btrfs_qgroup_inherit *inherit,
>>>>>> +                   u64 dst_objectid)
>>>>>> +{
>>>>>> +    struct btrfs_fs_info *fs_info = src->fs_info;
>>>>>> +    int ret;
>>>>>> +
>>>>>> +    /*
>>>>>> +     * We are going to commit transaction, see
>>>>>> btrfs_commit_transaction()
>>>>>> +     * comment for reason locking tree_log_mutex
>>>>>> +     */
>>>>>> +    mutex_lock(&fs_info->tree_log_mutex);
>>>>>> +
>>>>>> +    ret = commit_fs_roots(trans, src);
>>>>>> +    if (ret)
>>>>>> +        goto out;
>>>>>> +    ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
>>>>>> +    if (ret < 0)
>>>>>> +        goto out;
>>>>>> +    ret = btrfs_qgroup_account_extents(trans, fs_info);
>>>>>> +    if (ret < 0)
>>>>>> +        goto out;
>>>>>> +
>>>>>> +    /* Now qgroup are all updated, we can inherit it to new
>>>>>> qgroups */
>>>>>> +    ret = btrfs_qgroup_inherit(trans, fs_info,
>>>>>> +                   src->root_key.objectid, dst_objectid,
>>>>>> +                   inherit);
>>>>>> +    if (ret < 0)
>>>>>> +        goto out;
>>>>>> +
>>>>>> +    /*
>>>>>> +     * Now we do a simplified commit transaction, which will:
>>>>>> +     * 1) commit all subvolume and extent tree
>>>>>> +     *    To ensure all subvolume and extent tree have a valid
>>>>>> +     *    commit_root to accounting later insert_dir_item()
>>>>>> +     * 2) write all btree blocks onto disk
>>>>>> +     *    This is to make sure later btree modification will be
>>>>>> cowed
>>>>>> +     *    Or commit_root can be populated and cause wrong qgroup
>>>>>> numbers
>>>>>> +     * In this simplified commit, we don't really care about
>>>>>> other trees
>>>>>> +     * like chunk and root tree, as they won't affect qgroup.
>>>>>> +     * And we don't write super to avoid half committed status.
>>>>>> +     */
>>>>>> +    ret = commit_cowonly_roots(trans, src);
>>>>>> +    if (ret)
>>>>>> +        goto out;
>>>>>> +    switch_commit_roots(trans->transaction, fs_info);
>>>>>> +    ret = btrfs_write_and_wait_transaction(trans, src);
>>>>>> +    if (ret)
>>>>>> +        btrfs_std_error(fs_info, ret,
>>>>>> +            "Error while writing out transaction for qgroup");
>>>>>> +
>>>>>> +out:
>>>>>> +    mutex_unlock(&fs_info->tree_log_mutex);
>>>>>> +
>>>>>> +    /*
>>>>>> +     * Force parent root to be updated, as we recorded it before
>>>>>> so its
>>>>>> +     * last_trans == cur_transid.
>>>>>> +     * Or it won't be committed again onto disk after later
>>>>>> +     * insert_dir_item()
>>>>>> +     */
>>>>>> +    if (!ret)
>>>>>> +        record_root_in_trans(trans, parent, 1);
>>>>>> +    return ret;
>>>>>> +}
>>>>>
>>>>> NACK, holy shit we aren't adding a special transaction commit only
>>>>> for qgroup snapshots.  Figure out a different way.  Thanks,
>>>>
>>>>
>>>> Unfortunately I think we're going to have to swallow our pride on
>>>> this one :(
>>>>
>>>> Per our conversations on irc, and my detailed observations in this
>>>> e-mail:
>>>>
>>>> https://www.marc.info/?l=linux-btrfs&m=146257186311897&w=2
>>>>
>>>> It seems like we have a core problem in that root counting during
>>>> snapshot
>>>> create is unreliable and leads to corrupted qgroups. You add into
>>>> that the
>>>> poor assumptions made by the rest of the code (such as qgroup_inherit()
>>>> always marking dst->excl = node_size) and ti looks like we won't have a
>>>> proper fix until another qgroup rewrite.
>>>>
>>>> In the meantime, this would make qgroups numbers correct again. If
>>>> we drop a
>>>> single check in there to only run when qgroups are enabled, we can
>>>> mitigate
>>>> the performance impact. If I send that patch would you be ok to ACK
>>>> it this
>>>> time around?
>>>>
>>>
>>> Yeah as long as it's limited to only the qgroup case then I'm fine
>>> with it for now.  Thanks,
>>
>> Ok, here it goes. My xfstest for this issue is upstream now so I was
>> able to
>> run tests/btrfs/122 to verify that this still fixes the problem. Btw, so
>> that makes one drop snapshot test and two create snapshot tests for
>> qgroups
>> now. I'll make one for raid convert as that's broken too. Hopefully
>> then we
>> can be sure that this stuff doesn't break again.
>>
>> Btw, this is against Linux 4.5, let me know if you'd like it ported
>> forward.
>>     --Mark
>>
>> --
>> Mark Fasheh
>>
>>
>> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>
>> [PATCH] btrfs: qgroup: Fix qgroup accounting when creating snapshot
>>
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
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384,
>> nr_old_roots = 0, nr_new_roots = 1
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count =
>> 1, rfer = 0, excl = 0
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count =
>> 1, rfer = 16384, excl = 16384
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384,
>> nr_old_roots = 0, nr_new_roots = 0
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
>> Mark: I added a check at the top of qgroup_account_snapshot() to skip
>> this
>> code if qgroups are turned off. xfstest btrfs/122 exposes this problem.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
>> ---
>>  fs/btrfs/transaction.c | 129
>> ++++++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 105 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index b6031ce..21f6609 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -311,10 +311,11 @@ loop:
>>   * when the transaction commits
>>   */
>>  static int record_root_in_trans(struct btrfs_trans_handle *trans,
>> -                   struct btrfs_root *root)
>> +                   struct btrfs_root *root,
>> +                   int force)
>>  {
>> -    if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
>> -        root->last_trans < trans->transid) {
>> +    if ((test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
>> +        root->last_trans < trans->transid) || force) {
>>          WARN_ON(root == root->fs_info->extent_root);
>>          WARN_ON(root->commit_root != root->node);
>>
>> @@ -331,7 +332,7 @@ static int record_root_in_trans(struct
>> btrfs_trans_handle *trans,
>>          smp_wmb();
>>
>>          spin_lock(&root->fs_info->fs_roots_radix_lock);
>> -        if (root->last_trans == trans->transid) {
>> +        if (root->last_trans == trans->transid && !force) {
>>              spin_unlock(&root->fs_info->fs_roots_radix_lock);
>>              return 0;
>>          }
>> @@ -402,7 +403,7 @@ int btrfs_record_root_in_trans(struct
>> btrfs_trans_handle *trans,
>>          return 0;
>>
>>      mutex_lock(&root->fs_info->reloc_mutex);
>> -    record_root_in_trans(trans, root);
>> +    record_root_in_trans(trans, root, 0);
>>      mutex_unlock(&root->fs_info->reloc_mutex);
>>
>>      return 0;
>> @@ -1309,6 +1310,92 @@ int btrfs_defrag_root(struct btrfs_root *root)
>>  }
>>
>>  /*
>> + * Do all special snapshot related qgroup dirty hack.
>> + *
>> + * Will do all needed qgroup inherit and dirty hack like switch commit
>> + * roots inside one transaction and write all btree into disk, to make
>> + * qgroup works.
>> + */
>> +static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
>> +                   struct btrfs_root *src,
>> +                   struct btrfs_root *parent,
>> +                   struct btrfs_qgroup_inherit *inherit,
>> +                   u64 dst_objectid)
>> +{
>> +    struct btrfs_fs_info *fs_info = src->fs_info;
>> +    int ret;
>> +
>> +    /*
>> +     * Save some performance in the case that qgroups are not
>> +     * enabled. If this check races with the ioctl, rescan will
>> +     * kick in anyway.
>> +     */
>> +    mutex_lock(&fs_info->qgroup_ioctl_lock);
>> +    if (!fs_info->quota_enabled) {
>> +        mutex_unlock(&fs_info->qgroup_ioctl_lock);
>> +        return 0;
>> +    }
>> +    mutex_unlock(&fs_info->qgroup_ioctl_lock);
>> +
>> +    /*
>> +     * We are going to commit transaction, see
>> btrfs_commit_transaction()
>> +     * comment for reason locking tree_log_mutex
>> +     */
>> +    mutex_lock(&fs_info->tree_log_mutex);
>> +
>> +    ret = commit_fs_roots(trans, src);
>> +    if (ret)
>> +        goto out;
>> +    ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
>> +    if (ret < 0)
>> +        goto out;
>> +    ret = btrfs_qgroup_account_extents(trans, fs_info);
>> +    if (ret < 0)
>> +        goto out;
>> +
>> +    /* Now qgroup are all updated, we can inherit it to new qgroups */
>> +    ret = btrfs_qgroup_inherit(trans, fs_info,
>> +                   src->root_key.objectid, dst_objectid,
>> +                   inherit);
>> +    if (ret < 0)
>> +        goto out;
>> +
>> +    /*
>> +     * Now we do a simplified commit transaction, which will:
>> +     * 1) commit all subvolume and extent tree
>> +     *    To ensure all subvolume and extent tree have a valid
>> +     *    commit_root to accounting later insert_dir_item()
>> +     * 2) write all btree blocks onto disk
>> +     *    This is to make sure later btree modification will be cowed
>> +     *    Or commit_root can be populated and cause wrong qgroup numbers
>> +     * In this simplified commit, we don't really care about other trees
>> +     * like chunk and root tree, as they won't affect qgroup.
>> +     * And we don't write super to avoid half committed status.
>> +     */
>> +    ret = commit_cowonly_roots(trans, src);
>> +    if (ret)
>> +        goto out;
>> +    switch_commit_roots(trans->transaction, fs_info);
>> +    ret = btrfs_write_and_wait_transaction(trans, src);
>> +    if (ret)
>> +        btrfs_std_error(fs_info, ret,
>> +            "Error while writing out transaction for qgroup");
>> +
>> +out:
>> +    mutex_unlock(&fs_info->tree_log_mutex);
>> +
>> +    /*
>> +     * Force parent root to be updated, as we recorded it before so its
>> +     * last_trans == cur_transid.
>> +     * Or it won't be committed again onto disk after later
>> +     * insert_dir_item()
>> +     */
>> +    if (!ret)
>> +        record_root_in_trans(trans, parent, 1);
>> +    return ret;
>> +}
>> +
>> +/*
>>   * new snapshots need to be created at a very specific time in the
>>   * transaction commit.  This does the actual creation.
>>   *
>> @@ -1379,7 +1466,7 @@ static noinline int
>> create_pending_snapshot(struct btrfs_trans_handle *trans,
>>      dentry = pending->dentry;
>>      parent_inode = pending->dir;
>>      parent_root = BTRFS_I(parent_inode)->root;
>> -    record_root_in_trans(trans, parent_root);
>> +    record_root_in_trans(trans, parent_root, 0);
>>
>>      /*
>>       * insert the directory item
>> @@ -1414,7 +1501,7 @@ static noinline int
>> create_pending_snapshot(struct btrfs_trans_handle *trans,
>>          goto fail;
>>      }
>>
>> -    record_root_in_trans(trans, root);
>> +    record_root_in_trans(trans, root, 0);
>>      btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
>>      memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
>>      btrfs_check_and_init_root_item(new_root_item);
>> @@ -1510,6 +1597,17 @@ static noinline int
>> create_pending_snapshot(struct btrfs_trans_handle *trans,
>>          goto fail;
>>      }
>>
>> +    /*
>> +     * Do special qgroup accounting for snapshot, as we do some qgroup
>> +     * snapshot hack to do fast snapshot.
>> +     * To co-operate with that hack, we do hack again.
>> +     * Or snapshot will be greatly slowed down by a subtree qgroup
>> rescan
>> +     */
>> +    ret = qgroup_account_snapshot(trans, root, parent_root,
>> +                      pending->inherit, objectid);
>> +    if (ret < 0)
>> +        goto fail;
>> +
>>      ret = btrfs_insert_dir_item(trans, parent_root,
>>                      dentry->d_name.name, dentry->d_name.len,
>>                      parent_inode, &key,
>> @@ -1552,23 +1650,6 @@ static noinline int
>> create_pending_snapshot(struct btrfs_trans_handle *trans,
>>          goto fail;
>>      }
>>
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
>>
>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
>
> Thanks,
>
> Josef

Nice to hear that.

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
