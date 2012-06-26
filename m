Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38864 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab2FZUHM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 16:07:12 -0400
Received: by weyu7 with SMTP id u7so214753wey.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 13:07:11 -0700 (PDT)
MIME-Version: 1.0
From: Chester <somethingsome2000@gmail.com>
Date: Tue, 26 Jun 2012 15:06:50 -0500
Message-ID: <CAAE6i0jGqbOcRbhEYQiLdSUyxaKkFZKQTqb82shaSYdF9jFEqg@mail.gmail.com>
Subject: btrfs volume suddenly becomes read-only
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was using my computer normally when suddenly my btrfs volume became read-only.
This is on Chris' for-linus branch (latest commit cb77fcd88)

Here's the relevant excerpt from dmesg

[   50.877500] r8169 0000:01:00.0: eth1: link up
[   50.880296] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   60.959215] eth1: no IPv6 routers present
[ 1904.463247] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[ 1904.463258] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[ 1904.600647] atkbd serio0: Unknown key pressed (translated set 2,
code 0xab on isa0060/serio0).
[ 1904.600658] atkbd serio0: Use 'setkeycodes e02b <keycode>' to make it known.
[ 3937.267547] TCP: TCP: Possible SYN flooding on port 62600. Sending
cookies.  Check SNMP counters.
[36277.691827] btrfs: run_one_delayed_ref returned -17
[36277.691836] ------------[ cut here ]------------
[36277.691852] WARNING: at fs/btrfs/super.c:221
__btrfs_abort_transaction+0x40/0x9d()
[36277.691858] Hardware name: HP Pavilion dv6 Notebook PC
[36277.691862] btrfs: Transaction aborted
[36277.691866] Modules linked in: radeon ttm drm_kms_helper drm
i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect psmouse hp_accel
lis3lv02d ehci_hcd xhci_hcd snd_hda_codec_idt snd_hda_codec_hdmi
snd_hda_intel snd_hda_codec r8169 brcmsmac bcma brcmutil cordic
[36277.691913] Pid: 4491, comm: btrfs-endio-wri Not tainted
3.4.0-00091-gcb77fcd #1
[36277.691919] Call Trace:
[36277.691933]  [<ffffffff8106382f>] warn_slowpath_common+0x7e/0x96
[36277.691942]  [<ffffffff810638db>] warn_slowpath_fmt+0x41/0x43
[36277.691952]  [<ffffffff8125e626>] __btrfs_abort_transaction+0x40/0x9d
[36277.691963]  [<ffffffff8126dd55>] btrfs_run_delayed_refs+0x267/0x34b
[36277.691972]  [<ffffffff8111e2f3>] ? virt_to_head_page+0x9/0x2c
[36277.691982]  [<ffffffff8127c241>] __btrfs_end_transaction+0x7f/0x21b
[36277.691991]  [<ffffffff8127c426>] btrfs_end_transaction+0x10/0x12
[36277.692000]  [<ffffffff812810c0>] btrfs_finish_ordered_io+0x295/0x2e5
[36277.692010]  [<ffffffff8167ce58>] ? schedule_timeout+0x9c/0xb6
[36277.692019]  [<ffffffff8106eb22>] ? usleep_range+0x3d/0x3d
[36277.692028]  [<ffffffff81281120>] finish_ordered_fn+0x10/0x12
[36277.692036]  [<ffffffff812a3256>] worker_loop+0x169/0x4a3
[36277.692046]  [<ffffffff812a30ed>] ? btrfs_queue_worker+0x283/0x283
[36277.692054]  [<ffffffff8107d0c0>] kthread+0x86/0x8e
[36277.692064]  [<ffffffff81685c64>] kernel_thread_helper+0x4/0x10
[36277.692072]  [<ffffffff8107d03a>] ? kthread_freezable_should_stop+0x43/0x43
[36277.692081]  [<ffffffff81685c60>] ? gs_change+0x13/0x13
[36277.692087] ---[ end trace fe73a333f7c68c2e ]---
[36277.692094] BTRFS error (device sda6) in
btrfs_run_delayed_refs:2454: Object already exists
[36277.692100] btrfs is forced readonly
[36560.933113] SysRq : Keyboard mode set to system default
[36563.123600] SysRq : Show Blocked State
[36563.123615]   task                        PC stack   pid father

sysrq w was empty
