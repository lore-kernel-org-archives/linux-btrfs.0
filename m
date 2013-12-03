Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65439 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3LCGAI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Dec 2013 01:00:08 -0500
Message-ID: <529D6F2B.50109@cn.fujitsu.com>
Date: Tue, 03 Dec 2013 13:42:03 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, bo.li.liu@oracle.com
CC: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org,
        ochmann@informatik.uni-bonn.de
Subject: Re: [PATCH v3] Btrfs: fix wrong super generation mismatch when scrubbing
 supers
References: <1386005619-7750-1-git-send-email-wangshilong1991@gmail.com> <20131203045729.GB18095@localhost.localdomain> <529D66DA.8060407@cn.fujitsu.com>
In-Reply-To: <529D66DA.8060407@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 03 Dec 2013 13:06:34 +0800, Wang Shilong wrote:
> Hi Liu,
> 
> On 12/03/2013 12:57 PM, Liu Bo wrote:
>> On Tue, Dec 03, 2013 at 01:33:39AM +0800, Wang Shilong wrote:
>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>
>>> We came a race condition when scrubbing superblocks, the story is:
>>>
>>> In commiting transaction, we will update last_trans_commited after
>>> writting superblocks. if a scrub start after writting superblocks
>>> and before last_trans_commited, generation mismatch happens!
>>>
>>> We fix it by protecting writting superblock and updating last_trans_commited
>>> with tree_log_mutex.
>>>
>>> Reported-by: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> ---
>>> Changelog:
>>>     v2->v3:move tree_log_mutex out of device_list_mutex.
>>>     v1->v2: use right way to fix the problem.
>>> ---
>>>   fs/btrfs/scrub.c       | 11 +++++++----
>>>   fs/btrfs/transaction.c | 13 ++++++++++---
>>>   2 files changed, 17 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>> index 561e2f1..a9ed102 100644
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -2887,6 +2887,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>>       }
>>>     +    mutex_lock(&fs_info->tree_log_mutex);
>>>       mutex_lock(&fs_info->fs_devices->device_list_mutex);
>>>       dev = btrfs_find_device(fs_info, devid, NULL, NULL);
>>>       if (!dev || (dev->missing && !is_dev_replace)) {
>>> @@ -2932,14 +2933,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>>>       atomic_inc(&fs_info->scrubs_running);
>>>       mutex_unlock(&fs_info->scrub_lock);
>>>   +    /*
>>> +     * holding tree_log_mutex we can avoid generation mismatch while
>>> +     * scrubbing superblocks, see comments in commiting transaction
>>> +     * when updating last_trans_commited.
>>> +     */
>>>       if (!is_dev_replace) {
>>> -        /*
>>> -         * by holding device list mutex, we can
>>> -         * kick off writing super in log tree sync.
>>> -         */
>>>           ret = scrub_supers(sctx, dev);
>>>       }
>>>       mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>>> +    mutex_unlock(&fs_info->tree_log_mutex);
>> IIRC, we already have btrfs_scrub_{pause, continue}() to avoid race
>> situations between committing transaction and scrub processes, why not use that
>> instead?
> btrfs_scrub_{pause,continue} can not stop the following case from happening:
> 
> thread 1 thread 2
> |->write_supers
> |->start scrub
> |->using last_trans_commited(not updated yet) when scrubbing supers
> generation in disk is up to date but in memory is not.
> |->updating last_trans_commited
> 
> Pleae correct me if i am wrong here. :-)

Moving btrfs_finish_extent_commit() into the log mutex may make the log tasks be blocked for
a lot time.

I think the better way to fix is prevent the scrubber from starting while the transaction
is being committed.(wait scrub_pause_req == 0 before scrubbing the super block)

Thanks
Miao

>>
>> (Actually I don't like adding another lock unless it's been proved necessary
>> and correct with lockdep.)
> Right, i should test if it can pass lockdep.
> 
> Thanks for comments.
> Wang
>>
>> thanks,
>> -liubo
>>
>>>         if (!ret)
>>>           ret = scrub_enumerate_chunks(sctx, dev, start, end,
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>> index c6a872a..052eb22 100644
>>> --- a/fs/btrfs/transaction.c
>>> +++ b/fs/btrfs/transaction.c
>>> @@ -1898,15 +1898,22 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>>           goto cleanup_transaction;
>>>       }
>>>   +    btrfs_finish_extent_commit(trans, root);
>>> +
>>> +    /*
>>> +     * we must gurantee last_trans_commited update is protected by
>>> +     * tree_log_mutex with write_ctree_super together, otherwise,
>>> +     * scubbing super will come in before updating last_trans_commited
>>> +     * and we will get generation mismatch when scrubbing superblocks.
>>> +     */
>>> +    root->fs_info->last_trans_committed = cur_trans->transid;
>>> +
>>>       /*
>>>        * the super is written, we can safely allow the tree-loggers
>>>        * to go about their business
>>>        */
>>>       mutex_unlock(&root->fs_info->tree_log_mutex);
>>>   -    btrfs_finish_extent_commit(trans, root);
>>> -
>>> -    root->fs_info->last_trans_committed = cur_trans->transid;
>>>       /*
>>>        * We needn't acquire the lock here because there is no other task
>>>        * which can change it.
>>> -- 
>>> 1.8.4
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

