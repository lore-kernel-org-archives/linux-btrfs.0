Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab3FQBuQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Jun 2013 21:50:16 -0400
Message-ID: <51BE6BA5.40809@cn.fujitsu.com>
Date: Mon, 17 Jun 2013 09:51:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Shyam Kaushik <shyam@zadarastorage.com>
Subject: Re: [PATCH 2/3] Btrfs: fix the deadlock between the transaction start/attach
 and commit
References: <51249468.6010004@cn.fujitsu.com> <CAOcd+r35uFwUsmRuLRR3eGkVcceP2QEimhrN7xxSnBzB-LWVyQ@mail.gmail.com> <512B3AE7.9090208@cn.fujitsu.com> <CAOcd+r2bKGSoyxSXtnDKH5d04kRT2qRpFAKX2Dz6As=Qc_fOtg@mail.gmail.com> <514FAD96.7040002@cn.fujitsu.com> <CAOcd+r1i+neaAb+3o6CSVboKK_P0WPrSoiPLGC8t0QeqFM-uAQ@mail.gmail.com> <CAOcd+r16WyKxpDchERq+cGcq1oaEk21BvDSKWBtLge6s3GU=xg@mail.gmail.com> <518B56F1.40909@cn.fujitsu.com> <CAOcd+r3t+_TCsUytsJn9CAK0=dLJ91_bPncw_q8A3n5hqnT2pQ@mail.gmail.com> <51B937A9.3020906@cn.fujitsu.com> <CAOcd+r0986mL2FEC2tVTgNd0n1Lbc8FD=N9qPeAnd4h1QaxdAQ@mail.gmail.com>
In-Reply-To: <CAOcd+r0986mL2FEC2tVTgNd0n1Lbc8FD=N9qPeAnd4h1QaxdAQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	sun, 16 Jun 2013 13:38:42 +0300, Alex Lyakas wrote:
> Hi Miao,
> 
> On Thu, Jun 13, 2013 at 6:08 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> On wed, 12 Jun 2013 23:11:02 +0300, Alex Lyakas wrote:
>>> I reviewed the code starting from:
>>> 69aef69a1bc154 Btrfs: don't wait for all the writers circularly during
>>> the transaction commit
>>> until
>>> 2ce7935bf4cdf3 Btrfs: remove the time check in btrfs_commit_transaction()
>>>
>>> It looks very good. Let me check if I understand the fix correctly:
>>> # When transaction starts to commit, we want to wait only for external
>>> writers (those that did ATTACH/START/USERSPACE)
>>> # We guarantee at this point that no new external writers will hop on
>>> the committing transaction, by setting ->blocked state, so we only
>>> wait for existing extwriters to detach from transaction
> 
> I have a doubt about this point with your new code. Example:
> Task1 - external writer
> Task2 - transaction kthread
> 
> Task1                                                                   Task2
> |start_transaction(TRANS_START)                           |
> |-wait_current_trans(blocked=0, so it doesn't wait)     |
> |-join_transaction()                                                  |
> |--lock(trans_lock)                                                   |
> |--can_join_transaction() YES                                  |
> |
>       |-btrfs_commit_transaction()
> |
>       |--blocked=1
> |
>       |--in_commit=1
> |
>       |--wait_event(extwriter== 0);
> |
>       |--btrfs_flush_all_pending_stuffs()
> |                                                                            |
> |--extwriter_counter_inc()                                         |
> |--unlock(trans_lock)                                               |
> |
>       | lock(trans_lock)
> |
>       | trans_no_join=1
> 
> Basically, the "blocked/in_commit" check is not synchronized with
> joining a transaction. After checking "blocked", the external writer
> may proceed and join the transaction. Right before joining, it calls
> can_join_transaction(). But this function checks in_commit flag under
> fs_info->trans_lock. But btrfs_commit_transaction() sets this flag not
> under trans_lock, but under commit_lock, so checking this flag is not
> synchronized.
> 
> Or maybe I am wrong, because btrfs_commit_transaction() locks and
> unlocks trans_lock to check for previous transaction, so by accident
> there is no problem, and above scenario cannot happen?

Your analysis at the last section is right, so the right process is:

Task1							Task2
|start_transaction(TRANS_START)				|
|-wait_current_trans(blocked=0, so it doesn't wait)	|
|-join_transaction()					|
|--lock(trans_lock)					|
|--can_join_transaction() YES				|
|							|-btrfs_commit_transaction()
|							|--blocked=1
|							|--in_commit=1
|--extwriter_counter_inc()				|
|--unlock(trans_lock)					|
|							|--lock(trans_lock)
|							|--...
|							|--unlock(trans_lock)
|							|--...
|							|--wait_event(extwriter== 0);
|							|--btrfs_flush_all_pending_stuffs()

The problem you worried can not happen.

Anyway, it is not good that the "blocked/in_commit" check is not synchronized with
joining a transaction. So I modified the relative code in this patchset.

Miao
