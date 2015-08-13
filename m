Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:46262 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbHMH0R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 03:26:17 -0400
Message-ID: <55CC4697.4080102@profihost.ag>
Date: Thu, 13 Aug 2015 09:26:15 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: fdmanana@suse.com, mfasheh@suse.de
Subject: 4.2-rc6: cp reflink call trace
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I'm getting the following trace on a daily basis when stacking a lot of
cp --reflink commands.

Somethinkg like:
File a 80GB

cp --reflink=always a b
modify b
cp --reflink=always b c
modify c
cp --reflink=always c d
modify d
...


[57623.099897] INFO: task cp:1319 blocked for more than 120 seconds.
[57623.179331]       Tainted: G        W  O   4.2-rc6 #1
[57623.259794] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[57623.343106] cp              D ffff88085fcd1cc0     0  1319   1237
0x00000002
[57623.425986]  ffff880040127798 0000000000000002 ffff880024590000
0000000000011cc0
[57623.507907]  ffff880040127fd8 0000000000011cc0 ffff880854018000
ffff880024590000
[57623.588682]  ffff880040127778 ffff8800401278b8 ffff8800401278c0
7fffffffffffffff
[57623.669714] Call Trace:
[57623.747413]  [<ffffffff815f7ef9>] schedule+0x29/0x70
[57623.821280]  [<ffffffff815fa91c>] schedule_timeout+0x1fc/0x260
[57623.894211]  [<ffffffff8108beaa>] ? __queue_delayed_work+0xaa/0x1a0
[57623.967373]  [<ffffffff8108b882>] ? try_to_grab_pending+0x102/0x150
[57624.042693]  [<ffffffff815f91a6>] wait_for_completion+0x96/0x100
[57624.113736]  [<ffffffff8109dd90>] ? try_to_wake_up+0x310/0x310
[57624.185449]  [<ffffffff811cbd86>] writeback_inodes_sb_nr+0x86/0xb0
[57624.255713]  [<ffffffffa01cd4a8>] flush_space+0x408/0x480 [btrfs]
[57624.321342]  [<ffffffffa01c7aa0>] ? btrfs_get_alloc_profile+0x30/0x40
[btrfs]
[57624.389582]  [<ffffffffa01c7b0f>] ? can_overcommit+0x5f/0x100 [btrfs]
[57624.454281]  [<ffffffffa01cd726>] reserve_metadata_bytes+0x206/0x490
[btrfs]
[57624.517303]  [<ffffffffa021cf34>] ?
btrfs_clear_lock_blocking_rw+0x54/0x100 [btrfs]
[57624.587297]  [<ffffffffa01cde78>] btrfs_block_rsv_add+0x38/0x60 [btrfs]
[57624.656038]  [<ffffffffa01bcd8b>] ? btrfs_search_slot+0x89b/0xa10 [btrfs]
[57624.722189]  [<ffffffffa01e2cf3>] start_transaction+0x473/0x5c0 [btrfs]
[57624.794538]  [<ffffffffa01e316b>] btrfs_start_transaction+0x1b/0x20
[btrfs]
[57624.865341]  [<ffffffffa0216c14>] btrfs_clone+0x5b4/0x1070 [btrfs]
[57624.935456]  [<ffffffffa0217b4f>] btrfs_ioctl_clone+0x47f/0x4f0 [btrfs]
[57625.004768]  [<ffffffff811b0ec6>] ? do_last.isra.62+0x286/0xce0
[57625.076043]  [<ffffffffa021beb1>] btrfs_ioctl+0x18e1/0x28f0 [btrfs]
[57625.144157]  [<ffffffff811b23be>] ? path_openat+0xbe/0x600
[57625.209512]  [<ffffffff810fbe12>] ? from_kgid+0x12/0x20
[57625.275033]  [<ffffffff810fbe2e>] ? from_kgid_munged+0xe/0x20
[57625.340483]  [<ffffffff811035fc>] ? acct_account_cputime+0x1c/0x20
[57625.403169]  [<ffffffff811b6539>] do_vfs_ioctl+0x439/0x500
[57625.463798]  [<ffffffff810a1b84>] ? vtime_account_user+0x44/0x60
[57625.520728]  [<ffffffff81011528>] ? syscall_trace_enter_phase1+0xf8/0x160
[57625.578309]  [<ffffffff811b664c>] SyS_ioctl+0x4c/0x90
[57625.635960]  [<ffffffff815fc01d>] ? int_check_syscall_exit_work+0x34/0x3d
[57625.694317]  [<ffffffff815fbdf2>] system_call_fastpath+0x12/0x17
