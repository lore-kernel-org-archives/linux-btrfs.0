Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57102 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3FZRxC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 13:53:02 -0400
Received: by mail-wg0-f45.google.com with SMTP id j13so10764728wgh.12
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 10:53:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51BE6BA5.40809@cn.fujitsu.com>
References: <51249468.6010004@cn.fujitsu.com>
	<CAOcd+r35uFwUsmRuLRR3eGkVcceP2QEimhrN7xxSnBzB-LWVyQ@mail.gmail.com>
	<512B3AE7.9090208@cn.fujitsu.com>
	<CAOcd+r2bKGSoyxSXtnDKH5d04kRT2qRpFAKX2Dz6As=Qc_fOtg@mail.gmail.com>
	<514FAD96.7040002@cn.fujitsu.com>
	<CAOcd+r1i+neaAb+3o6CSVboKK_P0WPrSoiPLGC8t0QeqFM-uAQ@mail.gmail.com>
	<CAOcd+r16WyKxpDchERq+cGcq1oaEk21BvDSKWBtLge6s3GU=xg@mail.gmail.com>
	<518B56F1.40909@cn.fujitsu.com>
	<CAOcd+r3t+_TCsUytsJn9CAK0=dLJ91_bPncw_q8A3n5hqnT2pQ@mail.gmail.com>
	<51B937A9.3020906@cn.fujitsu.com>
	<CAOcd+r0986mL2FEC2tVTgNd0n1Lbc8FD=N9qPeAnd4h1QaxdAQ@mail.gmail.com>
	<51BE6BA5.40809@cn.fujitsu.com>
Date: Wed, 26 Jun 2013 20:53:00 +0300
Message-ID: <CAOcd+r1FhEGGOQX5f27aiFUKLyL00XSjuLddWJXHRsHjW8M0eg@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs: fix the deadlock between the transaction
 start/attach and commit
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: miaox@cn.fujitsu.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Shyam Kaushik <shyam@zadarastorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

On Mon, Jun 17, 2013 at 4:51 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On      sun, 16 Jun 2013 13:38:42 +0300, Alex Lyakas wrote:
>> Hi Miao,
>>
>> On Thu, Jun 13, 2013 at 6:08 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>> On wed, 12 Jun 2013 23:11:02 +0300, Alex Lyakas wrote:
>>>> I reviewed the code starting from:
>>>> 69aef69a1bc154 Btrfs: don't wait for all the writers circularly during
>>>> the transaction commit
>>>> until
>>>> 2ce7935bf4cdf3 Btrfs: remove the time check in btrfs_commit_transaction()
>>>>
>>>> It looks very good. Let me check if I understand the fix correctly:
>>>> # When transaction starts to commit, we want to wait only for external
>>>> writers (those that did ATTACH/START/USERSPACE)
>>>> # We guarantee at this point that no new external writers will hop on
>>>> the committing transaction, by setting ->blocked state, so we only
>>>> wait for existing extwriters to detach from transaction
>>
>> I have a doubt about this point with your new code. Example:
>> Task1 - external writer
>> Task2 - transaction kthread
>>
>> Task1                                                                   Task2
>> |start_transaction(TRANS_START)                           |
>> |-wait_current_trans(blocked=0, so it doesn't wait)     |
>> |-join_transaction()                                                  |
>> |--lock(trans_lock)                                                   |
>> |--can_join_transaction() YES                                  |
>> |
>>       |-btrfs_commit_transaction()
>> |
>>       |--blocked=1
>> |
>>       |--in_commit=1
>> |
>>       |--wait_event(extwriter== 0);
>> |
>>       |--btrfs_flush_all_pending_stuffs()
>> |                                                                            |
>> |--extwriter_counter_inc()                                         |
>> |--unlock(trans_lock)                                               |
>> |
>>       | lock(trans_lock)
>> |
>>       | trans_no_join=1
>>
>> Basically, the "blocked/in_commit" check is not synchronized with
>> joining a transaction. After checking "blocked", the external writer
>> may proceed and join the transaction. Right before joining, it calls
>> can_join_transaction(). But this function checks in_commit flag under
>> fs_info->trans_lock. But btrfs_commit_transaction() sets this flag not
>> under trans_lock, but under commit_lock, so checking this flag is not
>> synchronized.
>>
>> Or maybe I am wrong, because btrfs_commit_transaction() locks and
>> unlocks trans_lock to check for previous transaction, so by accident
>> there is no problem, and above scenario cannot happen?
>
> Your analysis at the last section is right, so the right process is:
>
> Task1                                                   Task2
> |start_transaction(TRANS_START)                         |
> |-wait_current_trans(blocked=0, so it doesn't wait)     |
> |-join_transaction()                                    |
> |--lock(trans_lock)                                     |
> |--can_join_transaction() YES                           |
> |                                                       |-btrfs_commit_transaction()
> |                                                       |--blocked=1
> |                                                       |--in_commit=1
> |--extwriter_counter_inc()                              |
> |--unlock(trans_lock)                                   |
> |                                                       |--lock(trans_lock)
> |                                                       |--...
> |                                                       |--unlock(trans_lock)
> |                                                       |--...
> |                                                       |--wait_event(extwriter== 0);
> |                                                       |--btrfs_flush_all_pending_stuffs()
>
> The problem you worried can not happen.
>
> Anyway, it is not good that the "blocked/in_commit" check is not synchronized with
> joining a transaction. So I modified the relative code in this patchset.
>

The four patches that we applied related to extwriters issue work very
good. They definitely solve the non-deterministic behavior while
waiting for the writers to detach. Thanks for addressing this issue.
One note is that the new behavior is perhaps less "friendly" to the
transaction join flow. With your fix, the committer unconditionally
sets "trans_no_join" and waits for old writers to detach. At this
point, new joins will block. While previously, the committer was
"finding a convenient spot" in the join pattern, when all writers have
detached (although it was non-deterministic when this will happen). So
perhaps some compromise can be done - like wait for 10sec until all
writers detach, and if not, just go ahead and set trans_no_join.

Thanks for your help!
Alex.


> Miao
