Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53845 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935321AbeBUOPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 09:15:43 -0500
Subject: Re: [PATCH] btrfs: Fix locking during DIO read
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Liu Bo <bo.li.liu@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <1519213303-2802-1-git-send-email-nborisov@suse.com>
 <CAL3q7H4aiNyzgtDoziTXYkwuSggUAF+b9uLTWcm15GQSigp1_w@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <de457af6-6a9c-43f4-b9c6-429b69deec77@suse.com>
Date: Wed, 21 Feb 2018 16:15:38 +0200
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4aiNyzgtDoziTXYkwuSggUAF+b9uLTWcm15GQSigp1_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.02.2018 15:51, Filipe Manana wrote:
> On Wed, Feb 21, 2018 at 11:41 AM, Nikolay Borisov <nborisov@suse.com> wrote:
>> Currently the DIO read cases uses a botched idea from ext4 to ensure
>> that DIO reads don't race with truncate. The idea is that if we have a
>> pending truncate we set BTRFS_INODE_READDIO_NEED_LOCK which in turn
>> forces the dio read case to fallback to inode_locking to prevent
>> read/truncate races. Unfortunately this is subtly broken for at least
>> 2 reasons:
>>
>> 1. inode_dio_begin in btrfs_direct_IO is called outside of inode_lock
>> (for the read case). This means that there is no ordering guarantee
>> between the invocation of inode_dio_wait and the increment of
>> i_dio_count in btrfs_direct_IO in the tread case.
> 
> Also, looking at this changelog, the diff and the code, why is it a
> problem not calling inode_dio_begin without the inode lock in the dio
> read path?
> The truncate path calls inode_dio_wait after setting the bit
> BTRFS_INODE_READDIO_NEED_LOCK and before clearing it.
> Assuming the functions to set and clear that bit are correct, I don't
> see what problem this brings.

Assume you have a truncate and a dio READ in parallel. So the following 
execution is possible: 
 
T1:                                                           T2:                                                                              
btrfs_setattr                                            
 set_bit(BTRFS_INODE_READDIO_NEED_LOCK)
 inode_dio_wait (reads i_dio_count)                        btrfs_direct_IO   						 
 clear_bit(BTRFS_INODE_READDIO_NEED_LOCK)                  inode_dio_begin (inc's i_dio_count) 

Since we have no ordering between beginning a dio and waiting for it then 
truncate can assume there isn't any pending dio. At the same time 
btrfs_direct_IO will increment i_dio_count but won't see BTRFS_INODE_READDIO_NEED_LOCK
ever being set and so will proceed servicing the read.  


> 
> Have you observed any issue in practice? Or can you show a diagram
> that points a sequence of concurrent steps leading to a problem?
> 
>>
>> 2. The memory barriers used in btrfs_inode_(block|resume)_unlocked_dio
>> are not really paired with the reader side - the test_bit in
>> btrfs_direct_IO, since the latter is missing a memory barrier.
> 
> Which memory barrier is missing?
> Both btrfs_inode_block_unlocked_dio() and
> btrfs_inode_resume_unlocked_dio() have memory barriers, and I think
> they are even not needed.

I discussed this piece of code with Peter Zijlstra and so if we take the 
2 memory barriers in btrfs_setattr size they *could* be optimised as 
follows: 

1. btrfs_inode_block_unlocked_dio() - it can lose it's smp_mb by virtue
of set_task_state (called from inode_dio_wait->prepare_to_wait) already including a full 
smp_mb. 

2. btrfs_inode_resume_unlocked_dio() - the clear bit in that function can be 
replaced by clear_bit_unlock. 

However, as you can see those barriers only order the setting of the 
flag respective to inode_dio_wait, they have no implication about 
when those writes are going to be seen by the test_bit in btrfs_direct_IO.

The situation we must avoid is T1 (truncate) sitting in schedule() and T2
not seeing the BTRFS_INODE_READDIO_NEED_LOCK bit set, thus missing a wake up.


Let alone the following comment of inode_dio_wait:

* Must be called under a lock that serializes taking new references            
* to i_dio_count, usually by inode->i_mutex. 





> Why do you think they are needed?
> 
>> Furthermore,
>> the actual sleeping condition that needs ordering to prevent live-locks/
>> missed wakeups is the modification/read of i_dio_count. So in this case
>> the waker(T2) needs to make the condition false _BEFORE_ doing a test.
>>
>> The interraction between the two threads roughly looks like:
>>
>> T1(truncate):                                    T2(btrfs_direct_IO):
>> set_bit(BTRFS_INODE_READDIO_NEED_LOCK)             if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK))
>> if (atomic_read())                                  if (atomic_dec_and_test(&inode->i_dio_count)
>>   schedule()                                            wake_up_bit
>> clear_bit(BTRFS_INODE_READDIO_NEED_LOCK)
>>
>> Without the ordering between the test_bit in T2 and setting the bit in
>> T1 (due to a missing pairing barrier in T2) it's possible that T1 goes
>> to sleep in schedule and T2 misses the bit set, resulting in missing the
>> wake up.
> 
> set_bit and test_bit are atomic. I don't understand from that sequence
> diagram how the wakeup is missed.

They may be atomic but atomicity says absolutely nothing about ordering. And the 
memory barriers are only on the write side (truncate) and the test_bit on the 
read side (btrfs_diect_IO) doesn't have any code which says anything about 
the order in which i_dio_count is read and test_bis is executed. 

> 
>>
>> In any case all of this is VERY subtle. So fix it by simply making
>> the DIO READ case take inode_lock_shared. This ensure that we can have
>> DIO reads in parallel at the same time we are protected against
>> concurrent modification of the target file. This way we closely mimic
>> what ext4 codes does and simplify this mess.
>>
>> Multiple xfstest runs didn't show any regressions.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/btrfs_inode.h | 17 -----------------
>>  fs/btrfs/inode.c       | 34 ++++++++++++++++++++--------------
>>  2 files changed, 20 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
>> index f527e99c9f8d..3519e49d4ef0 100644
>> --- a/fs/btrfs/btrfs_inode.h
>> +++ b/fs/btrfs/btrfs_inode.h
>> @@ -329,23 +329,6 @@ struct btrfs_dio_private {
>>                         blk_status_t);
>>  };
>>
>> -/*
>> - * Disable DIO read nolock optimization, so new dio readers will be forced
>> - * to grab i_mutex. It is used to avoid the endless truncate due to
>> - * nonlocked dio read.
>> - */
>> -static inline void btrfs_inode_block_unlocked_dio(struct btrfs_inode *inode)
>> -{
>> -       set_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
>> -       smp_mb();
>> -}
>> -
>> -static inline void btrfs_inode_resume_unlocked_dio(struct btrfs_inode *inode)
>> -{
>> -       smp_mb__before_atomic();
>> -       clear_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
>> -}
>> -
>>  static inline void btrfs_print_data_csum_error(struct btrfs_inode *inode,
>>                 u64 logical_start, u32 csum, u32 csum_expected, int mirror_num)
>>  {
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 491a7397f6fa..9c43257e6e11 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -5149,10 +5149,13 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
>>                 /* we don't support swapfiles, so vmtruncate shouldn't fail */
>>                 truncate_setsize(inode, newsize);
>>
>> -               /* Disable nonlocked read DIO to avoid the end less truncate */
>> -               btrfs_inode_block_unlocked_dio(BTRFS_I(inode));
>> +               /*
>> +                * Truncate after all in-flight dios are finished, new ones
>> +                * will block on inode_lock. This only matters for AIO requests
>> +                * since DIO READ is performed under inode_shared_lock and
>> +                * write under exclusive lock.
>> +                */
>>                 inode_dio_wait(inode);
>> -               btrfs_inode_resume_unlocked_dio(BTRFS_I(inode));
>>
>>                 ret = btrfs_truncate(inode);
>>                 if (ret && inode->i_nlink) {
>> @@ -8669,15 +8672,12 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>         loff_t offset = iocb->ki_pos;
>>         size_t count = 0;
>>         int flags = 0;
>> -       bool wakeup = true;
>>         bool relock = false;
>>         ssize_t ret;
>>
>>         if (check_direct_IO(fs_info, iter, offset))
>>                 return 0;
>>
>> -       inode_dio_begin(inode);
>> -
>>         /*
>>          * The generic stuff only does filemap_write_and_wait_range, which
>>          * isn't enough if we've written compressed pages to this area, so
>> @@ -8691,6 +8691,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>                                          offset + count - 1);
>>
>>         if (iov_iter_rw(iter) == WRITE) {
>> +
>> +               inode_dio_begin(inode);
>> +
>>                 /*
>>                  * If the write DIO is beyond the EOF, we need update
>>                  * the isize, but it is protected by i_mutex. So we can
>> @@ -8720,11 +8723,13 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>                 dio_data.unsubmitted_oe_range_end = (u64)offset;
>>                 current->journal_info = &dio_data;
>>                 down_read(&BTRFS_I(inode)->dio_sem);
>> -       } else if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
>> -                                    &BTRFS_I(inode)->runtime_flags)) {
>> -               inode_dio_end(inode);
>> -               flags = DIO_LOCKING | DIO_SKIP_HOLES;
>> -               wakeup = false;
>> +       } else {
>> +               /*
>> +                * In DIO READ case locking the inode in shared mode ensures
>> +                * we are protected against parallel writes/truncates
>> +                */
>> +               inode_lock_shared(inode);
>> +               inode_dio_begin(inode);
>>         }
>>
>>         ret = __blockdev_direct_IO(iocb, inode,
>> @@ -8755,10 +8760,11 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>                         btrfs_delalloc_release_space(inode, data_reserved,
>>                                         offset, count - (size_t)ret);
>>                 btrfs_delalloc_release_extents(BTRFS_I(inode), count);
>> -       }
>> +       } else
>> +               inode_unlock_shared(inode);
>>  out:
>> -       if (wakeup)
>> -               inode_dio_end(inode);
>> +       inode_dio_end(inode);
>> +
>>         if (relock)
>>                 inode_lock(inode);
>>
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
