Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:60937 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbeHBGnZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 02:43:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 02 Aug 2018 12:54:06 +0800
From: robbieko <robbieko@synology.com>
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix data lose with snapshot when nospace
In-Reply-To: <CAL3q7H5kYxPH8SE767T6mv4MPA_2mUvTB0=LPLRP=j3843rskg@mail.gmail.com>
References: <1532946072-31011-1-git-send-email-robbieko@synology.com>
 <CAL3q7H5FwG92wySYbMx4=2hgBFUcOX4X9CWhcaZCfTE7i4BeWQ@mail.gmail.com>
 <CAL3q7H5tcz-mufLoJLaxTE-V5=ZXLTp-KGTkjyTBx7xNUtKeqA@mail.gmail.com>
 <CAL3q7H6hS5pgcOJpzdtoRsUheSXrUuawB33Awxd=3vAUbUNnuw@mail.gmail.com>
 <a6e200a83b61fb9dd3b21109254640db@synology.com>
 <CAL3q7H5Rb0Sbr48rQqHE7xFEAoNe0vV-=drcW7LWrLQbuE8KtQ@mail.gmail.com>
 <a78c84ba173515bd8ddaed815b5ae4cf@synology.com>
 <CAL3q7H6+AB0Khh71mRvg+=OxeLnyQ_2fjp0NpVuVq_5sU+AXQA@mail.gmail.com>
 <CAL3q7H5kYxPH8SE767T6mv4MPA_2mUvTB0=LPLRP=j3843rskg@mail.gmail.com>
Message-ID: <cfc70c0a65a25f427969c64344c66e59@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe Manana 於 2018-08-02 01:55 寫到:
> On Wed, Aug 1, 2018 at 1:54 PM, Filipe Manana <fdmanana@gmail.com> 
> wrote:
>> On Wed, Aug 1, 2018 at 11:20 AM, robbieko <robbieko@synology.com> 
>> wrote:
>>> Filipe Manana 於 2018-07-31 19:33 寫到:
>>> 
>>>> On Tue, Jul 31, 2018 at 11:17 AM, robbieko <robbieko@synology.com> 
>>>> wrote:
>>>>> 
>>>>> Filipe Manana 於 2018-07-30 20:34 寫到:
>>>>> 
>>>>>> On Mon, Jul 30, 2018 at 12:28 PM, Filipe Manana 
>>>>>> <fdmanana@gmail.com>
>>>>>> wrote:
>>>>>>> 
>>>>>>> 
>>>>>>> On Mon, Jul 30, 2018 at 12:08 PM, Filipe Manana 
>>>>>>> <fdmanana@gmail.com>
>>>>>>> wrote:
>>>>>>>> 
>>>>>>>> 
>>>>>>>> On Mon, Jul 30, 2018 at 11:21 AM, robbieko 
>>>>>>>> <robbieko@synology.com>
>>>>>>>> wrote:
>>>>>>>>> 
>>>>>>>>> 
>>>>>>>>> From: Robbie Ko <robbieko@synology.com>
>>>>>>>>> 
>>>>>>>>> Commit e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
>>>>>>>>> modified the nocow writeback mechanism, if you create a 
>>>>>>>>> snapshot,
>>>>>>>>> it will always switch to cow writeback.
>>>>>>>>> 
>>>>>>>>> This will cause data loss when there is no space, because
>>>>>>>>> when the space is full, the write will not reserve any space, 
>>>>>>>>> only
>>>>>>>>> check if it can be nocow write.
>>>>>>>> 
>>>>>>>> 
>>>>>>>> 
>>>>>>>> This is a bit vague.
>>>>>>>> You need to mention where space reservation does not happen (at 
>>>>>>>> the
>>>>>>>> time of the write syscall) and why,
>>>>>>>> and that the snapshot happens before flushing IO (running 
>>>>>>>> dealloc).
>>>>>>>> Then when running dealloc we fallback
>>>>>>>> to COW and fail.
>>>>>>>> 
>>>>>>>> You also need to tell that although the write syscall did not 
>>>>>>>> return
>>>>>>>> an error, the writeback will
>>>>>>>> fail but a subsequent fsync on the file will return an error 
>>>>>>>> (ENOSPC)
>>>>>>>> because the writeback set the error
>>>>>>>> on the inode's mapping, so it's not completely a silent data 
>>>>>>>> loss, as
>>>>>>>> for buffered writes there's no guarantee
>>>>>>>> that if write syscall returns 0 the data will be persisted
>>>>>>>> successfully (that can only be guaranteed if a subsequent
>>>>>>>> fsync call returns 0).
>>>>>>>> 
>>>>>>>>> 
>>>>>>>>> So fix this by first flush the nocow data, and then switch to 
>>>>>>>>> the
>>>>>>>>> cow write.
>>>>>>> 
>>>>>>> 
>>>>>>> 
>>>>>>> I'm also not seeing how what you've done is better then we have 
>>>>>>> now
>>>>>>> using the root->will_be_snapshotted atomic,
>>>>>>> which is essentially used the same way as the new atomic you are
>>>>>>> adding, and forces the writeback code no nocow
>>>>>>> writes as well.
>>>>>> 
>>>>>> 
>>>>>> 
>>>>>> So what you have done can be made much more simple by flushing
>>>>>> delalloc before incrementing root->will_be_snapshotted instead of
>>>>>> after incrementing it:
>>>>>> 
>>>>>> https://friendpaste.com/2LY9eLAR9q0RoOtRK7VYmX
>>>>> 
>>>>> 
>>>>> There is no way to solve this problem in this modification.
>>>> 
>>>> 
>>>> It minimizes it. It only gives better guarantees that nocow buffered
>>>> writes that happened before calling the snapshot ioctl will not fall
>>>> back to cow,
>>>> not for the ones that happen while the call to the ioctl is 
>>>> happening.
>>>> 
>>>>> 
>>>>> When writing and create snapshot at the same time, the write will 
>>>>> not
>>>>> reserve space,
>>>>> and will not return to ENOSPC, because will_be_snapshotted is still 
>>>>> 0.
>>>>> So when writeback flush data, there will still be problems with 
>>>>> ENOSPC.
>>>> 
>>>> 
>>>> Which is precisely what I proposed does without adding a new atomic
>>>> and more changes.
>>>> It flushes delalloc before incrementing root->will_be_snapshotted, 
>>>> so
>>>> that previous buffered nocow writes will not fallback to cow mode 
>>>> (and
>>>> require data space allocation).
>>>> 
>>>> It only leaves a very tiny and very unlikely to hit (but not
>>>> impossible) time window where nocow writes will fallback
>>>> to cow mode - after calling start_delalloc_inodes() and before
>>>> incrementing root->will_be_snapshotted a new buffered write can 
>>>> comes
>>>> in and gets immediately flushed
>>>> because someone called fsync() on the file or the VM decided to
>>>> trigger writeback (due to memory pressure or some other reason).
>>>> 
>>> 
>>> It is very easy to reproduce. Not a tiny time.
>>> Because the time of start_delalloc_inodes will be very long.
>>> When the dirty page is reduced, the new write can continue
>>> to be written, and there is no reserve space.
>> 
>> I see now, thanks.
>>> 
>>> And these dirty pages are not necessarily flushed by
>>> start_delalloc_inodes because start_delalloc_inodes is
>>> checked from the front to the back, so when the new
>>> write is written to the previous position, it will not flush again.
>>> 
>>> So when start_delalloc_inodes is executed, will_be_snapshotted is 
>>> added,
>>> and all remaining dirty pages will be forced to turn to cow, all data 
>>> is
>>> loss.
>>> e.g. 16G RAM, dirty ratio 20%,  16*0.2 = 3.2 GB data loss.
>>> 
>>> Writing the inode that has been flushed will have the same problem.
>>> The inode that has been flushed will not be flushed for the second 
>>> time.
>>> 
>>> So you have better suggestions ？
>> 
>> Not efficient ones (introducing more locks).
>> This one if fine, but please write a changelog that mentions all these
>> details from your replies.
>> The original one does not explain in detail the problem nor the 
>> solution.
>> Some comments before incrementing both atomics and flushing delalloc
>> at ioctl.c would also be good to have.
>> 
>> And a test case for fstests too.
> 
> So the fstests test case I converted my testing script into a proper
> patch for fstests:
> 
> https://friendpaste.com/1oKSUHoZjp9OZtxDcK1Mey
> 

This test case is very good.

> Once you get a better title for the patch, I'll update the test's
> patch changelog  and submit it to fstests.
> Fails with current btrfs and passes with your patch (and with earlier
> proposal too).
> Let me know if it's ok for you. Thanks.
> 

I will rewrite the changelog and add comments,
then resend the patch v2.
And replace the titled to "Btrfs: fix data loss for nocow writes
after snapshot when low on data space"

Thanks.
Robbie Ko

>> 
>> Thanks.
>> 
>>> 
>>> 
>>>>> 
>>>>> The behavior I changed was to increase will_be_snapshotted first,
>>>>> so the following write must have a reserve space,
>>>>> otherwise it must be returned to ENOSPC.
>>>>> And then go to flush data and flush the diry page with nocow,
>>>>> When all the dirty pages are written back, then switch to cow mode.
>>>> 
>>>> 
>>>> And why did you wrote such a vague changelog? It misses all those
>>>> important and subtle details of the change.
>>>> 
>>>>> 
>>>>>> 
>>>>>> Just checked the code and failure to allocate space during 
>>>>>> writeback
>>>>>> after falling back to COW mode does indeed set
>>>>>> AS_ENOSPC on the inode's mapping, which makes fsync return ENOSPC
>>>>>> (through file_check_and_advance_wb_err()
>>>>>> and filemap_check_wb_err()).
>>>>>> 
>>>>>> Since fsync reports the error, I'm unsure to call it data loss but
>>>>>> rather an optimization to avoid ENOSPC for nocow writes when 
>>>>>> running
>>>>>> low on space.
>>>>>> 
>>>>> 
>>>>> If you do not use fsync, you will not find the data loss.
>>>> 
>>>> 
>>>> That's one of the reasons why fsync exists.
>>>> 
>>>>> I think that as long as the write returns successfully,
>>>>> the data must be written back to the disk at the end,
>>>>> otherwise it will be considered as data loss.
>>>> 
>>>> 
>>>> No filesystem gives you that guarantee, neither does POSIX or SUS.
>>>> Even for direct IO writes, you still need to call fsync to make sure
>>>> the writes will be seen after a power failure (metadata updates, 
>>>> super
>>>> block).
>>>> For buffered IO it's even more important. During writeback many 
>>>> things
>>>> can lead to failure, not just hardware problems, for example failure
>>>> to allocate memory or running out of space can happen.
>>>> 
>>>>> (Excluded, improper shutdown, IO error,)
>>>> 
>>>> 
>>>> Even with proper shutdown, you have no way to know if a write 
>>>> succeed
>>>> unless you call fsync, or you do something like evict page cache and
>>>> read from the file to check its contents, but that's not practical, 
>>>> or
>>>> do a direct IO read and check the content (not practical either). 
>>>> Even
>>>> calling sync() won't give you any guarantee (it returns void and has
>>>> no way to report writeback errors).
>>>> 
>>>> It's ok for a filesystem to try its best to make sure the write will
>>>> succeed in the write() syscall, but that alone is not a guarantee it
>>>> will not fail writeback.
>>>> 
>>>>> 
>>>>> 
>>>>>> 
>>>>>>> 
>>>>>>>> 
>>>>>>>> 
>>>>>>>> This seems easy to reproduce using deterministic steps.
>>>>>>>> Can you please write a test case for fstests?
>>>>>>>> 
>>>>>>>> Also the subject "Btrfs: fix data lose with snapshot when 
>>>>>>>> nospace",
>>>>>>>> besides the typo (lose -> loss), should be
>>>>>>>> more clear like for example "Btrfs: fix data loss for nocow 
>>>>>>>> writes
>>>>>>>> after snapshot when low on data space".
>>>>>>> 
>>>>>>> 
>>>>>>> 
>>>>>>> Also I'm not even sure if I would call it data loss.
>>>>>>> If there was no error returned from a subsequent fsync, I would
>>>>>>> definitely call it data loss.
>>>>>>> 
>>>>>>> So unless the fsync is not returning ENOSPC, I don't see anything 
>>>>>>> that
>>>>>>> needs to be fixed.
>>>>>>> 
>>>>>>>> 
>>>>>>>> Thanks.
>>>>>>>>> 
>>>>>>>>> 
>>>>>>>>> 
>>>>>>>>> Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
>>>>>>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>>>>>>> ---
>>>>>>>>>  fs/btrfs/ctree.h   |  1 +
>>>>>>>>>  fs/btrfs/disk-io.c |  1 +
>>>>>>>>>  fs/btrfs/inode.c   | 26 +++++---------------------
>>>>>>>>>  fs/btrfs/ioctl.c   |  6 ++++++
>>>>>>>>>  4 files changed, 13 insertions(+), 21 deletions(-)
>>>>>>>>> 
>>>>>>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>>>>>>> index 118346a..663ce05 100644
>>>>>>>>> --- a/fs/btrfs/ctree.h
>>>>>>>>> +++ b/fs/btrfs/ctree.h
>>>>>>>>> @@ -1277,6 +1277,7 @@ struct btrfs_root {
>>>>>>>>>         int send_in_progress;
>>>>>>>>>         struct btrfs_subvolume_writers *subv_writers;
>>>>>>>>>         atomic_t will_be_snapshotted;
>>>>>>>>> +       atomic_t snapshot_force_cow;
>>>>>>>>> 
>>>>>>>>>         /* For qgroup metadata reserved space */
>>>>>>>>>         spinlock_t qgroup_meta_rsv_lock;
>>>>>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>>>>>> index 205092d..5573916 100644
>>>>>>>>> --- a/fs/btrfs/disk-io.c
>>>>>>>>> +++ b/fs/btrfs/disk-io.c
>>>>>>>>> @@ -1216,6 +1216,7 @@ static void __setup_root(struct 
>>>>>>>>> btrfs_root
>>>>>>>>> *root,
>>>>>>>>> struct btrfs_fs_info *fs_info,
>>>>>>>>>         atomic_set(&root->log_batch, 0);
>>>>>>>>>         refcount_set(&root->refs, 1);
>>>>>>>>>         atomic_set(&root->will_be_snapshotted, 0);
>>>>>>>>> +       atomic_set(&root->snapshot_force_cow, 0);
>>>>>>>>>         root->log_transid = 0;
>>>>>>>>>         root->log_transid_committed = -1;
>>>>>>>>>         root->last_log_commit = 0;
>>>>>>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>>>>>>> index eba61bc..263b852 100644
>>>>>>>>> --- a/fs/btrfs/inode.c
>>>>>>>>> +++ b/fs/btrfs/inode.c
>>>>>>>>> @@ -1275,7 +1275,7 @@ static noinline int 
>>>>>>>>> run_delalloc_nocow(struct
>>>>>>>>> inode *inode,
>>>>>>>>>         u64 disk_num_bytes;
>>>>>>>>>         u64 ram_bytes;
>>>>>>>>>         int extent_type;
>>>>>>>>> -       int ret, err;
>>>>>>>>> +       int ret;
>>>>>>>>>         int type;
>>>>>>>>>         int nocow;
>>>>>>>>>         int check_prev = 1;
>>>>>>>>> @@ -1407,11 +1407,9 @@ static noinline int 
>>>>>>>>> run_delalloc_nocow(struct
>>>>>>>>> inode *inode,
>>>>>>>>>                          * if there are pending snapshots for 
>>>>>>>>> this
>>>>>>>>> root,
>>>>>>>>>                          * we fall into common COW way.
>>>>>>>>>                          */
>>>>>>>>> -                       if (!nolock) {
>>>>>>>>> -                               err =
>>>>>>>>> btrfs_start_write_no_snapshotting(root);
>>>>>>>>> -                               if (!err)
>>>>>>>>> -                                       goto out_check;
>>>>>>>>> -                       }
>>>>>>>>> +                       if (!nolock &&
>>>>>>>>> +
>>>>>>>>> unlikely(atomic_read(&root->snapshot_force_cow)))
>>>>>>>>> +                               goto out_check;
>>>>>>>>>                         /*
>>>>>>>>>                          * force cow if csum exists in the 
>>>>>>>>> range.
>>>>>>>>>                          * this ensure that csum for a given 
>>>>>>>>> extent
>>>>>>>>> are
>>>>>>>>> @@ -1420,9 +1418,6 @@ static noinline int 
>>>>>>>>> run_delalloc_nocow(struct
>>>>>>>>> inode *inode,
>>>>>>>>>                         ret = csum_exist_in_range(fs_info,
>>>>>>>>> disk_bytenr,
>>>>>>>>>                                                   num_bytes);
>>>>>>>>>                         if (ret) {
>>>>>>>>> -                               if (!nolock)
>>>>>>>>> -
>>>>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>>>>> -
>>>>>>>>>                                 /*
>>>>>>>>>                                  * ret could be -EIO if the 
>>>>>>>>> above
>>>>>>>>> fails
>>>>>>>>> to read
>>>>>>>>>                                  * metadata.
>>>>>>>>> @@ -1435,11 +1430,8 @@ static noinline int 
>>>>>>>>> run_delalloc_nocow(struct
>>>>>>>>> inode *inode,
>>>>>>>>>                                 WARN_ON_ONCE(nolock);
>>>>>>>>>                                 goto out_check;
>>>>>>>>>                         }
>>>>>>>>> -                       if (!btrfs_inc_nocow_writers(fs_info,
>>>>>>>>> disk_bytenr)) {
>>>>>>>>> -                               if (!nolock)
>>>>>>>>> -
>>>>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>>>>> +                       if (!btrfs_inc_nocow_writers(fs_info,
>>>>>>>>> disk_bytenr))
>>>>>>>>>                                 goto out_check;
>>>>>>>>> -                       }
>>>>>>>>>                         nocow = 1;
>>>>>>>>>                 } else if (extent_type == 
>>>>>>>>> BTRFS_FILE_EXTENT_INLINE) {
>>>>>>>>>                         extent_end = found_key.offset +
>>>>>>>>> @@ -1453,8 +1445,6 @@ static noinline int 
>>>>>>>>> run_delalloc_nocow(struct
>>>>>>>>> inode *inode,
>>>>>>>>>  out_check:
>>>>>>>>>                 if (extent_end <= start) {
>>>>>>>>>                         path->slots[0]++;
>>>>>>>>> -                       if (!nolock && nocow)
>>>>>>>>> -
>>>>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>>>>>                         if (nocow)
>>>>>>>>>                                 
>>>>>>>>> btrfs_dec_nocow_writers(fs_info,
>>>>>>>>> disk_bytenr);
>>>>>>>>>                         goto next_slot;
>>>>>>>>> @@ -1476,8 +1466,6 @@ static noinline int 
>>>>>>>>> run_delalloc_nocow(struct
>>>>>>>>> inode *inode,
>>>>>>>>>                                              end, page_started,
>>>>>>>>> nr_written, 1,
>>>>>>>>>                                              NULL);
>>>>>>>>>                         if (ret) {
>>>>>>>>> -                               if (!nolock && nocow)
>>>>>>>>> -
>>>>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>>>>>                                 if (nocow)
>>>>>>>>> 
>>>>>>>>> btrfs_dec_nocow_writers(fs_info,
>>>>>>>>> 
>>>>>>>>> disk_bytenr);
>>>>>>>>> @@ -1497,8 +1485,6 @@ static noinline int 
>>>>>>>>> run_delalloc_nocow(struct
>>>>>>>>> inode *inode,
>>>>>>>>>                                           ram_bytes,
>>>>>>>>> BTRFS_COMPRESS_NONE,
>>>>>>>>>                                           
>>>>>>>>> BTRFS_ORDERED_PREALLOC);
>>>>>>>>>                         if (IS_ERR(em)) {
>>>>>>>>> -                               if (!nolock && nocow)
>>>>>>>>> -
>>>>>>>>> btrfs_end_write_no_snapshotting(root);
>>>>>>>>>                                 if (nocow)
>>>>>>>>> 
>>>>>>>>> btrfs_dec_nocow_writers(fs_info,
>>>>>>>>> 
>>>>>>>>> disk_bytenr);
>>>>>>>>> @@ -1537,8 +1523,6 @@ static noinline int 
>>>>>>>>> run_delalloc_nocow(struct
>>>>>>>>> inode *inode,
>>>>>>>>>                                              
>>>>>>>>> EXTENT_CLEAR_DATA_RESV,
>>>>>>>>>                                              PAGE_UNLOCK |
>>>>>>>>> PAGE_SET_PRIVATE2);
>>>>>>>>> 
>>>>>>>>> -               if (!nolock && nocow)
>>>>>>>>> -                       btrfs_end_write_no_snapshotting(root);
>>>>>>>>>                 cur_offset = extent_end;
>>>>>>>>> 
>>>>>>>>>                 /*
>>>>>>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>>>>>>>> index b077544..43674ef 100644
>>>>>>>>> --- a/fs/btrfs/ioctl.c
>>>>>>>>> +++ b/fs/btrfs/ioctl.c
>>>>>>>>> @@ -761,6 +761,7 @@ static int create_snapshot(struct 
>>>>>>>>> btrfs_root
>>>>>>>>> *root,
>>>>>>>>> struct inode *dir,
>>>>>>>>>         struct btrfs_pending_snapshot *pending_snapshot;
>>>>>>>>>         struct btrfs_trans_handle *trans;
>>>>>>>>>         int ret;
>>>>>>>>> +       bool snapshot_force_cow = false;
>>>>>>>>> 
>>>>>>>>>         if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
>>>>>>>>>                 return -EINVAL;
>>>>>>>>> @@ -787,6 +788,9 @@ static int create_snapshot(struct 
>>>>>>>>> btrfs_root
>>>>>>>>> *root,
>>>>>>>>> struct inode *dir,
>>>>>>>>>         if (ret)
>>>>>>>>>                 goto dec_and_free;
>>>>>>>>> 
>>>>>>>>> +       atomic_inc(&root->snapshot_force_cow);
>>>>>>>>> +       snapshot_force_cow = true;
>>>>>>>>> +
>>>>>>>>>         btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
>>>>>>>>> 
>>>>>>>>>         btrfs_init_block_rsv(&pending_snapshot->block_rsv,
>>>>>>>>> @@ -851,6 +855,8 @@ static int create_snapshot(struct 
>>>>>>>>> btrfs_root
>>>>>>>>> *root,
>>>>>>>>> struct inode *dir,
>>>>>>>>>  fail:
>>>>>>>>>         btrfs_subvolume_release_metadata(fs_info,
>>>>>>>>> &pending_snapshot->block_rsv);
>>>>>>>>>  dec_and_free:
>>>>>>>>> +       if (snapshot_force_cow)
>>>>>>>>> +               atomic_dec(&root->snapshot_force_cow);
>>>>>>>>>         if (atomic_dec_and_test(&root->will_be_snapshotted))
>>>>>>>>>                 wake_up_var(&root->will_be_snapshotted);
>>>>>>>>>  free_pending:
>>>>>>>>> --
>>>>>>>>> 1.9.1
>>>>>>>>> 
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>> linux-btrfs"
>>>>>>>>> in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at  
>>>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>> 
>>>>>>>> 
>>>>>>>> 
>>>>>>>> 
>>>>>>>> 
>>>>>>>> --
>>>>>>>> Filipe David Manana,
>>>>>>>> 
>>>>>>>> “Whether you think you can, or you think you can't — you're 
>>>>>>>> right.”
>>>>>>> 
>>>>>>> 
>>>>>>> 
>>>>>>> 
>>>>>>> 
>>>>>>> --
>>>>>>> Filipe David Manana,
>>>>>>> 
>>>>>>> “Whether you think you can, or you think you can't — you're 
>>>>>>> right.”
>>>>> 
>>>>> 
>>>>> 
>>> 
>> 
>> 
>> 
>> --
>> Filipe David Manana,
>> 
>> “Whether you think you can, or you think you can't — you're right.”

