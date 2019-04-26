Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABFAC43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 02:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC7A52084F
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 02:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="Kkx9jjtJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfDZCsG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 22:48:06 -0400
Received: from mail.synology.com ([211.23.38.101]:58657 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728983AbfDZCsG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 22:48:06 -0400
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id AEAD81FA636ED;
        Fri, 26 Apr 2019 10:47:59 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1556246879; bh=Hm5mdkj4DrAcMk7F5NJXGnktf7truEqOrLydUrV68wE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Kkx9jjtJs7HzSK4M/A7Yufj6phWjTorIpnAKCi0PdhZ6tAA0/zigNnJbm1MHsPy1F
         dCmkZm5VIfwsbmJCTJ/edz9d/67QDFDe7XB+pNz/Q0qanzvgrNi0jlCw+SzuE1sNNC
         iCoD8E7ZX6qeD8qosLz4EEVebAGhGSg2E3XsIgh8=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 26 Apr 2019 10:47:59 +0800
From:   robbieko <robbieko@synology.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     fdmanana@gmail.com, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
In-Reply-To: <cfcaf75e-7e89-cf1f-9293-6a022762f22c@gmx.com>
References: <1533522630-21758-1-git-send-email-robbieko@synology.com>
 <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com>
 <06b5b693-8017-7ec0-b17a-c723291f00c7@suse.com>
 <950b2924-9edd-d9d7-ace0-bc3e2ab07a6a@gmx.com>
 <CAL3q7H6-9mxYyzi8Y0N8Vvgf4qRgrqURqHASE_4Du-jLmywuBQ@mail.gmail.com>
 <cfcaf75e-7e89-cf1f-9293-6a022762f22c@gmx.com>
Message-ID: <20b22fc6cdc288ed9aaf0be1a6cdeb7b@synology.com>
X-Sender: robbieko@synology.com
User-Agent: Roundcube Webmail/1.1.2
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Qu Wenruo 於 2019-04-26 07:20 寫到:
> [snip]
>>>> 
>>>> 1. Serializing snapshots (acquiring write-side of the semaphore)
>>> 
>>> With the new btrfs_start_delalloc_snapshot() in
>>> btrfs_commit_transaction(), do we really need to do anything special 
>>> now?
>>> 
>>> Snapshot creation will only happen in btrfs_commit_transaction(), as
>>> long as all dirty inodes/pages are written before pending snapshots,
>>> we're completely fine.
>>> 
>>> Or did I miss something?
>> 
>> You missed the whole point of both patches.
>> 
>> The one I authored recently, is about ensuring we see ordered update
>> of an inode's disk_i_size / i_size.
>> That flushes delalloc a second time, during the transaction commit, to
>> ensure an ordered update of disk_i_size in case direct IO writes
>> happened during snapshotting.
>> btrfs/078 could detect this when not running with the no-holes feature
>> enabled, since fsck will report missing file extent items.
> 
> But that flush at commit time ensures all pages of the source snapshot
> to disk, killing the following old case:
> - preallocate
> - buffered write
>   at this timing, the write will be nodatacow
> - snapshot creation
>   now the write needs to be cowed
> - dirty page writeback happens
> 
> With your flush, snapshot creation will flush all its dirty pages 
> before
> the new snapshot is created.
> 
>> 
>> Robbie's patch is about making sure that buffered nodatacow writes
>> that happened before snapshotting (and success was returned to user
>> space), will not fail silently during the writeback triggered by
>> snapshot creation.
>> There's even a test case for this, btrfs/170, which I submitted.
>> 
>> So no, you can't simply revert Robbie's change, that will re-introduce
>> the bug it fixed.
> 
> With your patch, I see nothing need to be handled specially in a
> snapshot source. Thus we don't need Robbie patch after your more
> comprehensive fix.
> 
> Or did I miss something again?

If you revert my patch directly, when volume is full, when writing data,
it will check and try to use nocow to write, but if the data is still
in the page cache, it has not been written back to disk.
If snapshot is triggered, will_be_snapshotted will be set, and then 
flush
data, causing data to be unable to do nocow in run_delalloc_nocow,
can only be written back in cow way, but there is no extra space to use,
so that data loss.
Thanks.
Robbieko

> Thanks,
> Qu
> 
>> 
>> Thanks.
>> 
>>> 
>>> Thanks,
>>> Qu
>>> 
>>>> 
>>>> 2. Nocow writers simply acquire the readsize of the semaphore.
>>>> 
>>>> the will_be_snapshoted thing is very convoluted relying on a percpu
>>>> counter/waitqueue  to exclude snapshots from pending nocow writers. 
>>>> OTOH
>>>> it depends on atomic_t and an implicit wait queue thanks to wait_var
>>>> infrastructure to exclude nocow writers from pending snapshots. 
>>>> Filipe
>>>> had some concerns regarding performance but if the patch you 
>>>> mentioned
>>>> fixed all issues I'm all in favor of removing the code!
>>>> 
>>>> 
>>>>> 
>>>>> Thanks,
>>>>> Qu
>>>>> 
>>>>>> 
>>>>>> 1. It is incremented when we start to create a snapshot after
>>>>>> triggering writeback and before waiting for writeback to finish.
>>>>>> 
>>>>>> 2. This new atomic is now what is used by writeback (running 
>>>>>> delalloc)
>>>>>> to decide whether we need to fallback to COW or not. Because we
>>>>>> incremented this new atomic after triggering writeback in the 
>>>>>> snapshot
>>>>>> creation ioctl, we ensure that all buffered writes that happened
>>>>>> before snapshot creation will succeed and not fallback to COW
>>>>>> (which would make them fail with ENOSPC).
>>>>>> 
>>>>>> 3. The existing atomic, will_be_snapshotted, is kept because it is
>>>>>> used to force new buffered writes, that start after we started
>>>>>> snapshotting, to reserve data space even when NOCOW is possible.
>>>>>> This makes these writes fail early with ENOSPC when there's no
>>>>>> available space to allocate, preventing the unexpected behaviour
>>>>>> of writeback later failing with ENOSPC due to a fallback to COW 
>>>>>> mode.
>>>>>> 
>>>>>> Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
>>>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>>>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>>>>>> ---
>>>>>>  fs/btrfs/ctree.h   |  1 +
>>>>>>  fs/btrfs/disk-io.c |  1 +
>>>>>>  fs/btrfs/inode.c   | 26 +++++---------------------
>>>>>>  fs/btrfs/ioctl.c   | 16 ++++++++++++++++
>>>>>>  4 files changed, 23 insertions(+), 21 deletions(-)
>>>>>> 
>>>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>>>> index 118346a..663ce05 100644
>>>>>> --- a/fs/btrfs/ctree.h
>>>>>> +++ b/fs/btrfs/ctree.h
>>>>>> @@ -1277,6 +1277,7 @@ struct btrfs_root {
>>>>>>     int send_in_progress;
>>>>>>     struct btrfs_subvolume_writers *subv_writers;
>>>>>>     atomic_t will_be_snapshotted;
>>>>>> +   atomic_t snapshot_force_cow;
>>>>>> 
>>>>>>     /* For qgroup metadata reserved space */
>>>>>>     spinlock_t qgroup_meta_rsv_lock;
>>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>>> index 205092d..5573916 100644
>>>>>> --- a/fs/btrfs/disk-io.c
>>>>>> +++ b/fs/btrfs/disk-io.c
>>>>>> @@ -1216,6 +1216,7 @@ static void __setup_root(struct btrfs_root 
>>>>>> *root, struct btrfs_fs_info *fs_info,
>>>>>>     atomic_set(&root->log_batch, 0);
>>>>>>     refcount_set(&root->refs, 1);
>>>>>>     atomic_set(&root->will_be_snapshotted, 0);
>>>>>> +   atomic_set(&root->snapshot_force_cow, 0);
>>>>>>     root->log_transid = 0;
>>>>>>     root->log_transid_committed = -1;
>>>>>>     root->last_log_commit = 0;
>>>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>>>> index eba61bc..263b852 100644
>>>>>> --- a/fs/btrfs/inode.c
>>>>>> +++ b/fs/btrfs/inode.c
>>>>>> @@ -1275,7 +1275,7 @@ static noinline int 
>>>>>> run_delalloc_nocow(struct inode *inode,
>>>>>>     u64 disk_num_bytes;
>>>>>>     u64 ram_bytes;
>>>>>>     int extent_type;
>>>>>> -   int ret, err;
>>>>>> +   int ret;
>>>>>>     int type;
>>>>>>     int nocow;
>>>>>>     int check_prev = 1;
>>>>>> @@ -1407,11 +1407,9 @@ static noinline int 
>>>>>> run_delalloc_nocow(struct inode *inode,
>>>>>>                      * if there are pending snapshots for this 
>>>>>> root,
>>>>>>                      * we fall into common COW way.
>>>>>>                      */
>>>>>> -                   if (!nolock) {
>>>>>> -                           err = 
>>>>>> btrfs_start_write_no_snapshotting(root);
>>>>>> -                           if (!err)
>>>>>> -                                   goto out_check;
>>>>>> -                   }
>>>>>> +                   if (!nolock &&
>>>>>> +                           
>>>>>> unlikely(atomic_read(&root->snapshot_force_cow)))
>>>>>> +                           goto out_check;
>>>>>>                     /*
>>>>>>                      * force cow if csum exists in the range.
>>>>>>                      * this ensure that csum for a given extent 
>>>>>> are
>>>>>> @@ -1420,9 +1418,6 @@ static noinline int 
>>>>>> run_delalloc_nocow(struct inode *inode,
>>>>>>                     ret = csum_exist_in_range(fs_info, 
>>>>>> disk_bytenr,
>>>>>>                                               num_bytes);
>>>>>>                     if (ret) {
>>>>>> -                           if (!nolock)
>>>>>> -                                   
>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>> -
>>>>>>                             /*
>>>>>>                              * ret could be -EIO if the above 
>>>>>> fails to read
>>>>>>                              * metadata.
>>>>>> @@ -1435,11 +1430,8 @@ static noinline int 
>>>>>> run_delalloc_nocow(struct inode *inode,
>>>>>>                             WARN_ON_ONCE(nolock);
>>>>>>                             goto out_check;
>>>>>>                     }
>>>>>> -                   if (!btrfs_inc_nocow_writers(fs_info, 
>>>>>> disk_bytenr)) {
>>>>>> -                           if (!nolock)
>>>>>> -                                   
>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>> +                   if (!btrfs_inc_nocow_writers(fs_info, 
>>>>>> disk_bytenr))
>>>>>>                             goto out_check;
>>>>>> -                   }
>>>>>>                     nocow = 1;
>>>>>>             } else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>>>>>>                     extent_end = found_key.offset +
>>>>>> @@ -1453,8 +1445,6 @@ static noinline int 
>>>>>> run_delalloc_nocow(struct inode *inode,
>>>>>>  out_check:
>>>>>>             if (extent_end <= start) {
>>>>>>                     path->slots[0]++;
>>>>>> -                   if (!nolock && nocow)
>>>>>> -                           btrfs_end_write_no_snapshotting(root);
>>>>>>                     if (nocow)
>>>>>>                             btrfs_dec_nocow_writers(fs_info, 
>>>>>> disk_bytenr);
>>>>>>                     goto next_slot;
>>>>>> @@ -1476,8 +1466,6 @@ static noinline int 
>>>>>> run_delalloc_nocow(struct inode *inode,
>>>>>>                                          end, page_started, 
>>>>>> nr_written, 1,
>>>>>>                                          NULL);
>>>>>>                     if (ret) {
>>>>>> -                           if (!nolock && nocow)
>>>>>> -                                   
>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>>                             if (nocow)
>>>>>>                                     
>>>>>> btrfs_dec_nocow_writers(fs_info,
>>>>>>                                                             
>>>>>> disk_bytenr);
>>>>>> @@ -1497,8 +1485,6 @@ static noinline int 
>>>>>> run_delalloc_nocow(struct inode *inode,
>>>>>>                                       ram_bytes, 
>>>>>> BTRFS_COMPRESS_NONE,
>>>>>>                                       BTRFS_ORDERED_PREALLOC);
>>>>>>                     if (IS_ERR(em)) {
>>>>>> -                           if (!nolock && nocow)
>>>>>> -                                   
>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>>                             if (nocow)
>>>>>>                                     
>>>>>> btrfs_dec_nocow_writers(fs_info,
>>>>>>                                                             
>>>>>> disk_bytenr);
>>>>>> @@ -1537,8 +1523,6 @@ static noinline int 
>>>>>> run_delalloc_nocow(struct inode *inode,
>>>>>>                                          EXTENT_CLEAR_DATA_RESV,
>>>>>>                                          PAGE_UNLOCK | 
>>>>>> PAGE_SET_PRIVATE2);
>>>>>> 
>>>>>> -           if (!nolock && nocow)
>>>>>> -                   btrfs_end_write_no_snapshotting(root);
>>>>>>             cur_offset = extent_end;
>>>>>> 
>>>>>>             /*
>>>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>>>>> index b077544..331b495 100644
>>>>>> --- a/fs/btrfs/ioctl.c
>>>>>> +++ b/fs/btrfs/ioctl.c
>>>>>> @@ -761,6 +761,7 @@ static int create_snapshot(struct btrfs_root 
>>>>>> *root, struct inode *dir,
>>>>>>     struct btrfs_pending_snapshot *pending_snapshot;
>>>>>>     struct btrfs_trans_handle *trans;
>>>>>>     int ret;
>>>>>> +   bool snapshot_force_cow = false;
>>>>>> 
>>>>>>     if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
>>>>>>             return -EINVAL;
>>>>>> @@ -777,6 +778,11 @@ static int create_snapshot(struct btrfs_root 
>>>>>> *root, struct inode *dir,
>>>>>>             goto free_pending;
>>>>>>     }
>>>>>> 
>>>>>> +   /*
>>>>>> +    * Force new buffered writes to reserve space even when NOCOW 
>>>>>> is
>>>>>> +    * possible. This is to avoid later writeback (running 
>>>>>> dealloc)
>>>>>> +    * to fallback to COW mode and unexpectedly fail with ENOSPC.
>>>>>> +    */
>>>>>>     atomic_inc(&root->will_be_snapshotted);
>>>>>>     smp_mb__after_atomic();
>>>>>>     /* wait for no snapshot writes */
>>>>>> @@ -787,6 +793,14 @@ static int create_snapshot(struct btrfs_root 
>>>>>> *root, struct inode *dir,
>>>>>>     if (ret)
>>>>>>             goto dec_and_free;
>>>>>> 
>>>>>> +   /*
>>>>>> +    * All previous writes have started writeback in NOCOW mode, 
>>>>>> so now
>>>>>> +    * we force future writes to fallback to COW mode during 
>>>>>> snapshot
>>>>>> +    * creation.
>>>>>> +    */
>>>>>> +   atomic_inc(&root->snapshot_force_cow);
>>>>>> +   snapshot_force_cow = true;
>>>>>> +
>>>>>>     btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
>>>>>> 
>>>>>>     btrfs_init_block_rsv(&pending_snapshot->block_rsv,
>>>>>> @@ -851,6 +865,8 @@ static int create_snapshot(struct btrfs_root 
>>>>>> *root, struct inode *dir,
>>>>>>  fail:
>>>>>>     btrfs_subvolume_release_metadata(fs_info, 
>>>>>> &pending_snapshot->block_rsv);
>>>>>>  dec_and_free:
>>>>>> +   if (snapshot_force_cow)
>>>>>> +           atomic_dec(&root->snapshot_force_cow);
>>>>>>     if (atomic_dec_and_test(&root->will_be_snapshotted))
>>>>>>             wake_up_var(&root->will_be_snapshotted);
>>>>>>  free_pending:
>>>>>> 
>>>>> 
>> 
>> 
>> 

