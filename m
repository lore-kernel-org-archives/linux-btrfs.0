Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32941 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752918AbdBGGKH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 01:10:07 -0500
To: btrfs <linux-btrfs@vger.kernel.org>, Anand Jain <anand.jain@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: btrfs/125 deadlock using nospace_cache or space_cache=v2
Message-ID: <0daf31e9-d666-5044-f9a9-fcf54576a144@cn.fujitsu.com>
Date: Tue, 7 Feb 2017 14:09:52 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

I found that btrfs/125 test case can only pass if we enabled space cache.

If using nospace_cache or space_cache=v2 mount option, it will get 
blocked forever with the following callstack(the only blocked process):

[11382.046978] btrfs           D11128  6705   6057 0x00000000
[11382.047356] Call Trace:
[11382.047668]  __schedule+0x2d4/0xae0
[11382.047956]  schedule+0x3d/0x90
[11382.048283]  btrfs_start_ordered_extent+0x160/0x200 [btrfs]
[11382.048630]  ? wake_atomic_t_function+0x60/0x60
[11382.048958]  btrfs_wait_ordered_range+0x113/0x210 [btrfs]
[11382.049360]  btrfs_relocate_block_group+0x260/0x2b0 [btrfs]
[11382.049703]  btrfs_relocate_chunk+0x51/0xf0 [btrfs]
[11382.050073]  btrfs_balance+0xaa9/0x1610 [btrfs]
[11382.050404]  ? btrfs_ioctl_balance+0x3a0/0x3b0 [btrfs]
[11382.050739]  btrfs_ioctl_balance+0x3a0/0x3b0 [btrfs]
[11382.051109]  btrfs_ioctl+0xbe7/0x27f0 [btrfs]
[11382.051430]  ? trace_hardirqs_on+0xd/0x10
[11382.051747]  ? free_object+0x74/0xa0
[11382.052084]  ? debug_object_free+0xf2/0x130
[11382.052413]  do_vfs_ioctl+0x94/0x710
[11382.052750]  ? enqueue_hrtimer+0x160/0x160
[11382.053090]  ? do_nanosleep+0x71/0x130
[11382.053431]  SyS_ioctl+0x79/0x90
[11382.053735]  entry_SYSCALL_64_fastpath+0x18/0xad
[11382.054570] RIP: 0033:0x7f397d7a6787

I also found in the test case, we only have 3 continuous data extents,
whose sizes are 1M, 68.5M and 31.5M respectively.

Original data block group:
0       1M                     64M    69.5M                  101M   128M
| Ext A |     Extent B(68.5M)         |    Extent C(31.5M)   |


While relocation write them in 4 extents:
0~1M            :same as Extent A.         (1st)
1M~68.3438M     :smaller than Extent B     (2nd)
68.3438M~69.5M  :tail part of Extent B     (3rd)
69.5M~ 101M     :same as Extent C.         (4th)

However only ordered extent of (3rd) and (4th) get finished.
While ordered extent of (1st) and (2nd) never reached finish_ordered_io().

So relocation will wait for no one to finish the these two ordered 
extent, and get blocked.

Did you experienced the same bug submitting the test case?
Is there any known fix for it?

Thanks,
Qu


