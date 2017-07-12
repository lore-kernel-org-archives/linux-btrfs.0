Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932555AbdGLClx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 22:41:53 -0400
Subject: Re: [RFC PATCH] btrfs: qgroup: Fix hang when using inode_cache and
 qgroup
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170531080845.3033-1-quwenruo@cn.fujitsu.com>
 <028e9fff-fccf-a02a-32a6-3a39694f9d16@suse.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c81b3524-0ed7-a27f-4708-58fc2d3472a9@gmx.com>
Date: Wed, 12 Jul 2017 10:41:20 +0800
MIME-Version: 1.0
In-Reply-To: <028e9fff-fccf-a02a-32a6-3a39694f9d16@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2017年06月06日 01:38, Goldwyn Rodrigues 写道:
> 
> 
> On 05/31/2017 03:08 AM, Qu Wenruo wrote:
>> Commit 48a89bc4f2ce ("btrfs: qgroups: Retry after commit on getting EDQUOT")
>> is causing hang, with the following backtrace:
>>
>> Call Trace:
>>   __schedule+0x374/0xaf0
>>   schedule+0x3d/0x90
>>   wait_for_commit+0x4a/0x80 [btrfs]
>>   ? wake_atomic_t_function+0x60/0x60
>>   btrfs_commit_transaction+0xe0/0xa10 [btrfs]  <<< Here
>>   ? start_transaction+0xad/0x510 [btrfs]
>>   qgroup_reserve+0x1f0/0x350 [btrfs]
>>   btrfs_qgroup_reserve_data+0xf8/0x2f0 [btrfs]
>>   ? _raw_spin_unlock+0x27/0x40
>>   btrfs_check_data_free_space+0x6d/0xb0 [btrfs]
>>   btrfs_delalloc_reserve_space+0x25/0x70 [btrfs]
>>   btrfs_save_ino_cache+0x402/0x650 [btrfs]
>>   commit_fs_roots+0xb7/0x170 [btrfs]
>>   btrfs_commit_transaction+0x425/0xa10 [btrfs] <<< And here
>>   qgroup_reserve+0x1f0/0x350 [btrfs]
>>   btrfs_qgroup_reserve_data+0xf8/0x2f0 [btrfs]
>>   ? _raw_spin_unlock+0x27/0x40
>>   btrfs_check_data_free_space+0x6d/0xb0 [btrfs]
>>   btrfs_delalloc_reserve_space+0x25/0x70 [btrfs]
>>   btrfs_direct_IO+0x1c5/0x3b0 [btrfs]
>>   generic_file_direct_write+0xab/0x150
>>   btrfs_file_write_iter+0x243/0x530 [btrfs]
>>   __vfs_write+0xc9/0x120
>>   vfs_write+0xcb/0x1f0
>>   SyS_pwrite64+0x79/0x90
>>   entry_SYSCALL_64_fastpath+0x18/0xad
>>
>> The problem is that, inode_cache will be written in commit_fs_roots(),
>> which is called in btrfs_commit_transaction().
>>
>> And when it fails to reserve enough data space, qgroup_reserve() will
>> try to call btrfs_commit_transaction() again, then we are waiting for
>> ourselves.
>>
>> The patch will introduce can_retry parameter for qgroup_reserve(),
>> allowing related callers to avoid deadly commit transaction deadlock.
>>
>> Now for space cache inode, we will not allow qgroup retry, so it will
>> not cause deadlock.
>>
>> Fixes: 48a89bc4f2ce ("btrfs: qgroups: Retry after commit on getting EDQUOT")
>> Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> Commit  48a89bc4f2ce ("btrfs: qgroups: Retry after commit on getting EDQUOT")
>> is not only causing such deadlock, but also screwing up qgroup reserved
>> space for even generic test cases.
>>
>> I'm afraid we may need to revert that commit if we can't find a good way
>> to fix the newly caused qgroup meta reserved space underflow.
>> (Unlike old bug which is qgroup data reserved space underflow, this time
>> the commit is causing new metadata space underflow).
> 
> I tried the same with direct I/O and have the same results. I run into
> underflows often. By reverting the patch, we are avoiding the problem
> not resolving it. The numbers don't add up and the point is to find out
> where the numbers are getting lost (or counted in excess). I will
> continue investigating on this front.

What about moving the transaction commit to other thread?
E.g btrfs-transaction kernel thread.

I know this won't solve the problem as pinpoin as your solution.
We need to info btrfs-transaction thread to commit transcation before 
it's too late.
So we need a threshold mechanism for it to commit transaction in advance.

I think the possibility to encounter such problem can be hugely reduced.
And we can avoid any possible dead lock.

How do you think about this idea?

Thanks,
Qu

> 
> By ignoring the warning (unset BTRFS_DEBUG) and continuing during
> overflow, we are just avoiding the problem. It does not show up in dmesg
> any longer.
> 
> 
