Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23469 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932188AbcLMDPc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 22:15:32 -0500
To: btrfs <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: v4.9-rc7 scrub kernel panic
Message-ID: <f6695ea9-4c2a-be31-ad62-a86164833642@cn.fujitsu.com>
Date: Tue, 13 Dec 2016 11:15:23 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

When testing Chris' for-linus-4.10 branch.

I found that even at the branch base, v4.9-rc7, btrfs can't pass
quite a lot of scrub tests, including btrfs/011 and btrfs/069.

The btrfs/069 will fail 100%, with the following back trace:

general protection fault: 0000 [#1] SMP
Modules linked in: btrfs(O) xor zlib_deflate raid6_pq 
x86_pkg_temp_thermal ext4 jbd2 mbcache e1000e efivarfs [last unloaded: 
btrfs]
CPU: 3 PID: 5300 Comm: kworker/u8:4 Tainted: G           O    4.9.0-rc7+ #20
Hardware name: FUJITSU ESPRIMO P720/D3221-A1, BIOS V4.6.5.4 R1.17.0 for 
D3221-A1x 03/06/2014
Workqueue: btrfs-endio-raid56 btrfs_endio_raid56_helper [btrfs]
task: ffff88008dbcb740 task.stack: ffffc90001230000
RIP: 0010:[<ffffffff813a2fa8>]  [<ffffffff813a2fa8>] 
generic_make_request_checks+0x198/0x5a0
RSP: 0018:ffffc90001233b08  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88007f963228 RCX: 0000000000000001
RDX: 0000000080000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6b6b
RBP: ffffc90001233b68 R08: 00000000868a9b14 R09: eab761b200000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000040
R13: 0000000000000004 R14: ffff88008dbc5a88 R15: 0000000000000010
FS:  0000000000000000(0000) GS:ffff880119e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000019c7058 CR3: 00000001150b4000 CR4: 00000000001406e0
Stack:
  0000000000000002 ffffffff813a4cff ffffffff00000000 0000000000000296
  0000000000000292 ffff88008dbcb740 ffffffff00000003 ffff88007f963228
  00000000ffffffff 0000000000000004 ffff88008dbc5a88 0000000000000010
Call Trace:
  [<ffffffff813a4cff>] ? generic_make_request+0xcf/0x290
  [<ffffffff813a4c54>] generic_make_request+0x24/0x290
  [<ffffffff813a4cff>] ? generic_make_request+0xcf/0x290
  [<ffffffff813a4f2e>] submit_bio+0x6e/0x120
  [<ffffffffa087279d>] ? page_in_rbio+0x4d/0x80 [btrfs]
  [<ffffffffa08737d0>] ? rbio_orig_end_io+0x80/0x80 [btrfs]
  [<ffffffffa0873e31>] finish_rmw+0x401/0x550 [btrfs]
  [<ffffffffa0874fc6>] validate_rbio_for_rmw+0x36/0x40 [btrfs]
  [<ffffffffa087504d>] raid_rmw_end_io+0x7d/0x90 [btrfs]
  [<ffffffff8139c536>] bio_endio+0x56/0x60
  [<ffffffffa07e6e5c>] end_workqueue_fn+0x3c/0x40 [btrfs]
  [<ffffffffa08285bf>] btrfs_scrubparity_helper+0xef/0x610 [btrfs]
  [<ffffffffa0828b9e>] btrfs_endio_raid56_helper+0xe/0x10 [btrfs]
  [<ffffffff810ec8df>] process_one_work+0x2af/0x720
  [<ffffffff810ec85b>] ? process_one_work+0x22b/0x720
  [<ffffffff810ecd9b>] worker_thread+0x4b/0x4f0
  [<ffffffff810ecd50>] ? process_one_work+0x720/0x720
  [<ffffffff810ecd50>] ? process_one_work+0x720/0x720
  [<ffffffff810f39d3>] kthread+0xf3/0x110
  [<ffffffff810f38e0>] ? kthread_park+0x60/0x60
  [<ffffffff81857647>] ret_from_fork+0x27/0x40
Code: 00 00 0f 1f 44 00 00 65 8b 05 9d 71 c6 7e 89 c0 48 0f a3 05 c3 13 
b8 00 0f 92 c3 0f 82 dd 02 00 00 bb 01 00 00 00 e9 8c 00 00 00 <48> 8b 
47 08 48 8b 40 50 48 c1 f8 09 48 85 c0 0f 84 99 fe ff ff
RIP  [<ffffffff813a2fa8>] generic_make_request_checks+0x198/0x5a0
  RSP <ffffc90001233b08>

Is this a known bug or a new one caused by the block layer change?

Thanks,
Qu


