Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4076 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1761881AbdEXDpL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 23:45:11 -0400
Subject: Re: [PATCH v5] qgroup: Retry after commit on getting EDQUOT
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20170327172957.2518-1-rgoldwyn@suse.de>
 <20170327173647.GQ4781@twin.jikos.cz>
 <08d582e0-3670-ade4-3a2a-da72829d3da0@suse.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e4b0f84c-2f5f-0a32-3678-2153f7aae181@cn.fujitsu.com>
Date: Wed, 24 May 2017 11:44:57 +0800
MIME-Version: 1.0
In-Reply-To: <08d582e0-3670-ade4-3a2a-da72829d3da0@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/28/2017 02:13 AM, Goldwyn Rodrigues wrote:
> 
> 
> On 03/27/2017 12:36 PM, David Sterba wrote:
>> On Mon, Mar 27, 2017 at 12:29:57PM -0500, Goldwyn Rodrigues wrote:
>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>
>>> We are facing the same problem with EDQUOT which was experienced with
>>> ENOSPC. Not sure if we require a full ticketing system such as ENOSPC, but
>>> here is a quick fix, which may be too big a hammer.
>>>
>>> Quotas are reserved during the start of an operation, incrementing
>>> qg->reserved. However, it is written to disk in a commit_transaction
>>> which could take as long as commit_interval. In the meantime there
>>> could be deletions which are not accounted for because deletions are
>>> accounted for only while committed (free_refroot). So, when we get
>>> a EDQUOT flush the data to disk and try again.
>>>
>>> This fixes fstests btrfs/139.

This patch is causing hang for inode_cache mount option.

Which can be easily triggered by btrfs/042 with inode_cache.

The callback trace will be:
Call Trace:
  __schedule+0x374/0xaf0
  schedule+0x3d/0x90
  wait_for_commit+0x4a/0x80 [btrfs]
  ? wake_atomic_t_function+0x60/0x60
  btrfs_commit_transaction+0xe0/0xa10 [btrfs]
  ? start_transaction+0xad/0x510 [btrfs]
  qgroup_reserve+0x1f0/0x350 [btrfs]
  btrfs_qgroup_reserve_data+0xf8/0x2f0 [btrfs]
  ? _raw_spin_unlock+0x27/0x40
  btrfs_check_data_free_space+0x6d/0xb0 [btrfs]
  btrfs_delalloc_reserve_space+0x25/0x70 [btrfs]
  btrfs_save_ino_cache+0x402/0x650 [btrfs]
  commit_fs_roots+0xb7/0x170 [btrfs]
  btrfs_commit_transaction+0x425/0xa10 [btrfs]
  qgroup_reserve+0x1f0/0x350 [btrfs]
  btrfs_qgroup_reserve_data+0xf8/0x2f0 [btrfs]
  ? _raw_spin_unlock+0x27/0x40
  btrfs_check_data_free_space+0x6d/0xb0 [btrfs]
  btrfs_delalloc_reserve_space+0x25/0x70 [btrfs]
  btrfs_direct_IO+0x1c5/0x3b0 [btrfs]
  generic_file_direct_write+0xab/0x150
  btrfs_file_write_iter+0x243/0x530 [btrfs]
  __vfs_write+0xc9/0x120
  vfs_write+0xcb/0x1f0
  SyS_pwrite64+0x79/0x90
  entry_SYSCALL_64_fastpath+0x18/0xad

We're calling btrfs_commit_transaction() inside btrfs_commit_transaction().

Which will definitely hang the system.

Any idea to fix it?

Thanks,
Qu

>>>
>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>> ---
>>> Changes since v1:
>>>   - Changed start_delalloc_roots() to start_delalloc_inode() to target
>>>     the root in question only to reduce the amount of flush to be done.
>>>   - Added wait_ordered_extents().
>>>
>>> Changes since v2:
>>>    - Revised patch header
>>>    - removed comment on combining conditions
>>>    - removed test case, to be done in fstests
>>>
>>> Changes sinve v3:
>>>    - testcase reinstated
>>>    - return value checks
>>>
>>> Changes since v4:
>>>   - removed testcase since btrfs/139 got incorporated in fstests
>>
>> The point was to keep the test inside the changelog as well.
> 
> 
> Yes, that was before we had btrfs/139 in fstest. I have put it in the
> patch header. However, if you really want the test script back, I can
> put it there. Let me know.
> 
> 


