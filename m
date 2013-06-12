Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35970 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FLULD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 16:11:03 -0400
Received: by mail-ie0-f175.google.com with SMTP id a13so11030174iee.6
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 13:11:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518B56F1.40909@cn.fujitsu.com>
References: <51249468.6010004@cn.fujitsu.com>
	<CAOcd+r35uFwUsmRuLRR3eGkVcceP2QEimhrN7xxSnBzB-LWVyQ@mail.gmail.com>
	<512B3AE7.9090208@cn.fujitsu.com>
	<CAOcd+r2bKGSoyxSXtnDKH5d04kRT2qRpFAKX2Dz6As=Qc_fOtg@mail.gmail.com>
	<514FAD96.7040002@cn.fujitsu.com>
	<CAOcd+r1i+neaAb+3o6CSVboKK_P0WPrSoiPLGC8t0QeqFM-uAQ@mail.gmail.com>
	<CAOcd+r16WyKxpDchERq+cGcq1oaEk21BvDSKWBtLge6s3GU=xg@mail.gmail.com>
	<518B56F1.40909@cn.fujitsu.com>
Date: Wed, 12 Jun 2013 23:11:02 +0300
Message-ID: <CAOcd+r3t+_TCsUytsJn9CAK0=dLJ91_bPncw_q8A3n5hqnT2pQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs: fix the deadlock between the transaction
 start/attach and commit
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: miaox@cn.fujitsu.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Shyam Kaushik <shyam@zadarastorage.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

On Thu, May 9, 2013 at 10:57 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> Hi, Alex
>
> Could you try the following patchset?
>
>   git://github.com/miaoxie/linux-btrfs.git trans-commit-improve
>
> I think it can avoid the problem you said below.
>
> Note: this patchset is against chris's for-linus branch.

I reviewed the code starting from:
69aef69a1bc154 Btrfs: don't wait for all the writers circularly during
the transaction commit
until
2ce7935bf4cdf3 Btrfs: remove the time check in btrfs_commit_transaction()

It looks very good. Let me check if I understand the fix correctly:
# When transaction starts to commit, we want to wait only for external
writers (those that did ATTACH/START/USERSPACE)
# We guarantee at this point that no new external writers will hop on
the committing transaction, by setting ->blocked state, so we only
wait for existing extwriters to detach from transaction
# We do not care at this point for TRANS_JOIN etc, we let them hop on
if they want
# When all external writers have detached, we flush their delalloc and
then we prevent all the others to join (TRANS_JOIN etc)

# Previously, we had the do-while loop, that intended to do the same,
but it used num_writers, which counts both external writers and also
TRANS_JOIN. So the loop was racy because new joins prevented it from
completing.

Is my understanding correct?

I have some questions:
# Why was the do-while loop needed? Can we just delete the do-while
loop as it was before, call flush_all_pending stuffs(),  then set
trans_no_join and wait for all writers to detach? Is there some
correctness problem here?
Or we need to wait for external writers to detach before calling
flush_all_pending_stuffs() one last time?

# Why TRANS_ATTACH is considered external writer?

# Can I apply this fix to 3.8.x kernel (manually, of course)? Or some
additional things are needed that are missing in this kernel?

Thanks,
Alex.






>
> Thanks
> Miao
>
> On Wed, 10 Apr 2013 21:45:43 +0300, Alex Lyakas wrote:
>> Hi Miao,
>> I attempted to fix the issue by not joining a transaction that has
>> trans->in_commit set. I did something similar to what
>> wait_current_trans() does, but I did:
>>
>> smp_rmb();
>> if (cur_trans && cur_trans->in_commit) {
>> ...
>> wait_event(root->fs_info->transaction_wait,  !cur_trans->blocked);
>> ...
>>
>> I also had to change the order of setting in_commit and blocked in
>> btrfs_commit_transaction:
>>       trans->transaction->blocked = 1;
>>       trans->transaction->in_commit = 1;
>>       smp_wmb();
>> to make sure that if in_commit is set, then blocked cannot be 0,
>> because btrfs_commit_transaction haven't set it yet to 1.
>>
>> However, with this fix I observe two issues:
>> # With large trees and heavy commits, join_transaction() is delayed
>> sometimes by 1-3 seconds. This delays the host IO by too much.
>> # With this fix, I think too many transactions happen. Basically with
>> this fix, once transaction->in_commit is set, then I insist to open a
>> new transaction and not to join the current one. It has some bad
>> influence on host response times pattern, but I cannot exactly tell
>> why is that.
>>
>> Did you have other fix in mind?
>>
>> Without the fix, I observe sometimes commits that take like 80
>> seconds, out of which like 50 seconds are spent in the do-while loop
>> of btrfs_commit_transaction.
>>
>> Thanks,
>> Alex.
>>
>>
>>
>> On Mon, Mar 25, 2013 at 11:11 AM, Alex Lyakas
>> <alex.btrfs@zadarastorage.com> wrote:
>>> Hi Miao,
>>>
>>> On Mon, Mar 25, 2013 at 3:51 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>>> On Sun, 24 Mar 2013 13:13:22 +0200, Alex Lyakas wrote:
>>>>> Hi Miao,
>>>>> I am seeing another issue. Your fix prevents from TRANS_START to get
>>>>> in the way of a committing transaction. But it does not prevent from
>>>>> TRANS_JOIN. On the other hand, btrfs_commit_transaction has the
>>>>> following loop:
>>>>>
>>>>> do {
>>>>>     // attempt to do some useful stuff and/or sleep
>>>>> } while (atomic_read(&cur_trans->num_writers) > 1 ||
>>>>>                (should_grow && cur_trans->num_joined != joined));
>>>>>
>>>>> What I see is basically that new writers join the transaction, while
>>>>> btrfs_commit_transaction() does this loop. I see
>>>>> cur_trans->num_writers decreasing, but then it increases, then
>>>>> decreases etc. This can go for several seconds during heavy IO load.
>>>>> There is nothing to prevent new TRANS_JOIN writers coming and joining
>>>>> a transaction over and over, thus delaying transaction commit. The IO
>>>>> path uses TRANS_JOIN; for example run_delalloc_nocow() does that.
>>>>>
>>>>> Do you observe such behavior? Do you believe it's problematic?
>>>>
>>>> I know this behavior, there is no problem with it, the latter code
>>>> will prevent from TRANS_JOIN.
>>>>
>>>> 1672         spin_lock(&root->fs_info->trans_lock);
>>>> 1673         root->fs_info->trans_no_join = 1;
>>>> 1674         spin_unlock(&root->fs_info->trans_lock);
>>>> 1675         wait_event(cur_trans->writer_wait,
>>>> 1676                    atomic_read(&cur_trans->num_writers) == 1);
>>>>
>>> Yes, this code prevents anybody from joining, but before
>>> btrfs_commit_transaction() gets to this code, it may spend sometimes
>>> 10 seconds (in my tests) in the do-while loop, while new writers come
>>> and go. Basically, it is not deterministic when the do-while loop will
>>> exit, it depends on the IO pattern.
>>>
>>>> And if we block the TRANS_JOIN at the place you point out, the deadlock
>>>> will happen because we need deal with the ordered operations which will
>>>> use TRANS_JOIN here.
>>>>
>>>> (I am dealing with the problem you said above by adding a new type of
>>>> TRANS_* now)
>>>
>>> Thanks.
>>> Alex.
>>>
>>>
>>>>
>>>> Thanks
>>>> Miao
>>>>
>>>>> Thanks,
>>>>> Alex.
>>>>>
>>>>>
>>>>> On Mon, Feb 25, 2013 at 12:20 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>>>>> On sun, 24 Feb 2013 21:49:55 +0200, Alex Lyakas wrote:
>>>>>>> Hi Miao,
>>>>>>> can you please explain your solution a bit more.
>>>>>>>
>>>>>>> On Wed, Feb 20, 2013 at 11:16 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>>>>>>> Now btrfs_commit_transaction() does this
>>>>>>>>
>>>>>>>> ret = btrfs_run_ordered_operations(root, 0)
>>>>>>>>
>>>>>>>> which async flushes all inodes on the ordered operations list, it introduced
>>>>>>>> a deadlock that transaction-start task, transaction-commit task and the flush
>>>>>>>> workers waited for each other.
>>>>>>>> (See the following URL to get the detail
>>>>>>>>  http://marc.info/?l=linux-btrfs&m=136070705732646&w=2)
>>>>>>>>
>>>>>>>> As we know, if ->in_commit is set, it means someone is committing the
>>>>>>>> current transaction, we should not try to join it if we are not JOIN
>>>>>>>> or JOIN_NOLOCK, wait is the best choice for it. In this way, we can avoid
>>>>>>>> the above problem. In this way, there is another benefit: there is no new
>>>>>>>> transaction handle to block the transaction which is on the way of commit,
>>>>>>>> once we set ->in_commit.
>>>>>>>>
>>>>>>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>>>>>>> ---
>>>>>>>>  fs/btrfs/transaction.c |   17 ++++++++++++++++-
>>>>>>>>  1 files changed, 16 insertions(+), 1 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>>>>>>> index bc2f2d1..71b7e2e 100644
>>>>>>>> --- a/fs/btrfs/transaction.c
>>>>>>>> +++ b/fs/btrfs/transaction.c
>>>>>>>> @@ -51,6 +51,14 @@ static noinline void switch_commit_root(struct btrfs_root *root)
>>>>>>>>         root->commit_root = btrfs_root_node(root);
>>>>>>>>  }
>>>>>>>>
>>>>>>>> +static inline int can_join_transaction(struct btrfs_transaction *trans,
>>>>>>>> +                                      int type)
>>>>>>>> +{
>>>>>>>> +       return !(trans->in_commit &&
>>>>>>>> +                type != TRANS_JOIN &&
>>>>>>>> +                type != TRANS_JOIN_NOLOCK);
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>  /*
>>>>>>>>   * either allocate a new transaction or hop into the existing one
>>>>>>>>   */
>>>>>>>> @@ -86,6 +94,10 @@ loop:
>>>>>>>>                         spin_unlock(&fs_info->trans_lock);
>>>>>>>>                         return cur_trans->aborted;
>>>>>>>>                 }
>>>>>>>> +               if (!can_join_transaction(cur_trans, type)) {
>>>>>>>> +                       spin_unlock(&fs_info->trans_lock);
>>>>>>>> +                       return -EBUSY;
>>>>>>>> +               }
>>>>>>>>                 atomic_inc(&cur_trans->use_count);
>>>>>>>>                 atomic_inc(&cur_trans->num_writers);
>>>>>>>>                 cur_trans->num_joined++;
>>>>>>>> @@ -360,8 +372,11 @@ again:
>>>>>>>>
>>>>>>>>         do {
>>>>>>>>                 ret = join_transaction(root, type);
>>>>>>>> -               if (ret == -EBUSY)
>>>>>>>> +               if (ret == -EBUSY) {
>>>>>>>>                         wait_current_trans(root);
>>>>>>>> +                       if (unlikely(type == TRANS_ATTACH))
>>>>>>>> +                               ret = -ENOENT;
>>>>>>>> +               }
>>>>>>>
>>>>>>> So I understand that instead of incrementing num_writes and joining
>>>>>>> the current transaction, you do not join and wait for the current
>>>>>>> transaction to unblock.
>>>>>>
>>>>>> More specifically，TRANS_START、TRANS_USERSPACE and TRANS_ATTACH can not
>>>>>> join and just wait for the current transaction to unblock if ->in_commit
>>>>>> is set.
>>>>>>
>>>>>>> Which task in Josef's example
>>>>>>> http://marc.info/?l=linux-btrfs&m=136070705732646&w=2
>>>>>>> task 1, task 2 or task 3 is the one that will not join the
>>>>>>> transaction, but instead wait?
>>>>>>
>>>>>> Task1 will not join the transaction, in this way, async inode flush
>>>>>> won't run, and then task3 won't do anything.
>>>>>>
>>>>>> Before applying the patch:
>>>>>> Start/Attach_Trans_Task                 Commit_Task                     Flush_Worker
>>>>>> (Task1)                                 (Task2)                         (Task3)         -- the name in Josef's example
>>>>>> btrfs_start_transaction()
>>>>>>  |->may_wait_transaction()
>>>>>>  |  (return 0)
>>>>>>  |                                      btrfs_commit_transaction()
>>>>>>  |                                       |->set ->in_commit and
>>>>>>  |                                       |  blocked to 1
>>>>>>  |                                       |->wait writers to be 1
>>>>>>  |                                       |  (writers is 1)
>>>>>>  |->join_transaction()                   |
>>>>>>  |  (writers is 2)                       |
>>>>>>  |->btrfs_commit_transaction()           |
>>>>>>      |                                   |->set trans_no_join to 1
>>>>>>      |                                   |  (close join transaction)
>>>>>>      |->btrfs_run_ordered_operations     |
>>>>>>         (Those ordered operations        |
>>>>>>          are added when releasing        |
>>>>>>          file)                           |
>>>>>>          |->async inode flush()          |
>>>>>>          |->wait_flush_comlete()         |
>>>>>>                                          |                              work_loop()
>>>>>>                                          |                               |->run_work()
>>>>>>                                          |                                   |->btrfs_join_transaction()
>>>>>>                                          |                                       |->wait_current_trans()
>>>>>>                                          |->wait writers to be 1
>>>>>>
>>>>>> This three tasks waited for each other.
>>>>>>
>>>>>> After applying this patch:
>>>>>> Start/Attach_Trans_Task                 Commit_Task                     Flush_Worker
>>>>>> (Task1)                                 (Task2)                         (Task3)
>>>>>> btrfs_start_transaction()
>>>>>>  |->may_wait_transaction()
>>>>>>  |  (return 0)
>>>>>>  |                                      btrfs_commit_transaction()
>>>>>>  |                                       |->set ->in_commit and
>>>>>>  |                                       |  blocked to 1
>>>>>>  |                                       |->wait writers to be 1
>>>>>>  |                                       |  (writers is 1)
>>>>>>  |->join_transaction() fail              |
>>>>>>  |  (return -EBUSY, writers is still 1)  |
>>>>>>  |->wait_current_trans()                 |
>>>>>>                                          |->set trans_no_join to 1
>>>>>>                                          |  (close join transaction)
>>>>>>                                          |->wait writers to be 1
>>>>>>                                          |->continue committing
>>>>>>                                                                         (Task3 does nothing)
>>>>>>> Also, I think I don't fully understand Josef's example. What is
>>>>>>> preventing from async flushing to complete?
>>>>>>> Is task 3 waiting because trans_no_join is set?
>>>>>>> Is task 3 the one that actually does the delalloc flush?
>>>>>>
>>>>>> See above.
>>>>>>
>>>>>> Thanks
>>>>>> Miao
>>>>>>
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Alex.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>>         } while (ret == -EBUSY);
>>>>>>>>
>>>>>>>>         if (ret < 0) {
>>>>>>>> --
>>>>>>>> 1.6.5.2
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>>
>>>>>
>>>>
>>
>
