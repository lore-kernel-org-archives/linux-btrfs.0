Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56587 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409Ab3JQUym (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Oct 2013 16:54:42 -0400
Received: by mail-ie0-f172.google.com with SMTP id tp5so5087398ieb.17
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Oct 2013 13:54:42 -0700 (PDT)
MIME-Version: 1.0
From: Chester <somethingsome2000@gmail.com>
Date: Thu, 17 Oct 2013 15:54:22 -0500
Message-ID: <CAAE6i0ibfsMT5ynHMVm_uxNze6bapeL4kmhVba5Tf-em2_V2nQ@mail.gmail.com>
Subject: dmesg filled with btrfs messages
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---------- Forwarded message ----------
From: Chester <somethingsome2000@gmail.com>
Date: Thu, Oct 17, 2013 at 3:51 PM
Subject: dmesg filled with btrfs messages
To: linux-btrfs <linux-btrfs@vger.kernel.org>


It's what looks like the same message repeated over and over again.
Here's my dmesg: Pasted below is an excerpt. The full netconsole log
is on pastebin http://pastebin.com/4dQGCL9U

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0 (root@NaviLaptop) (gcc version
4.6.4 (Funtoo 4.6.4-r2) ) #1 SMP Thu Oct 17 08:33:08 CDT 2013
[    0.000000] Command line: BOOT_IMAGE=/bzImage-3.11
rootflags=thread_pool=32,autodefrag,inode_cache,subvolid=258
radeon.modeset=1 radeon.audio=1 radeon.dpm=1 zswap.enabled=0
zswap.compressor=lz4hc funtoo-ati zram.num_devices=4 root=/dev/sda6
rootfstype=btrfs root=/dev/sda6
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfb3efff] usable


....

[24099.408977] ------------[ cut here ]------------
[24099.408999] WARNING: CPU: 2 PID: 19049 at fs/btrfs/inode.c:2206
record_one_backref+0x303/0x31b()
[24099.409002] Modules linked in: netconsole joydev evdev psmouse
ehci_pci ohci_hcd ehci_hcd xhci_hcd snd_hda_codec_idt
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec r8169 mii brcmsmac
cordic brcmutil bcma bnep bluetooth
[24099.409040] CPU: 2 PID: 19049 Comm: btrfs-endio-wri Tainted: G
  W    3.11.0 #1
[24099.409043] Hardware name: Hewlett-Packard HP Pavilion dv6 Notebook
PC/358B, BIOS F.21 09/13/2011
[24099.409046]  000000000000089e ffff880101b63ad8 ffffffff817c33f6
0000000000000027
[24099.409054]  0000000000000000 ffff880101b63b18 ffffffff8106b44d
0000160000000000
[24099.409060]  ffffffff812a9588 000000000000008f ffff88016c5b2240
ffff88012eac2600
[24099.409067] Call Trace:
[24099.409074]  [<ffffffff817c33f6>] dump_stack+0x46/0x58
[24099.409079]  [<ffffffff8106b44d>] warn_slowpath_common+0x7c/0x96
[24099.409083]  [<ffffffff812a9588>] ? record_one_backref+0x303/0x31b
[24099.409087]  [<ffffffff8106b47c>] warn_slowpath_null+0x15/0x17
[24099.409090]  [<ffffffff812a9588>] record_one_backref+0x303/0x31b
[24099.409096]  [<ffffffff812ede03>] ? ulist_free+0x1c/0x20
[24099.409210]  [<ffffffff812ed7cc>] iterate_extent_inodes+0x148/0x1dd
[24099.409213]  [<ffffffff812a9285>] ? btrfs_real_readdir+0x4b5/0x4b5
[24099.409216]  [<ffffffff812a9285>] ? btrfs_real_readdir+0x4b5/0x4b5
[24099.409220]  [<ffffffff812ed8e5>] iterate_inodes_from_logical+0x84/0x93
[24099.409224]  [<ffffffff812a7d8d>] record_extent_backrefs+0x5c/0xa2
[24099.409228]  [<ffffffff812b0054>] btrfs_finish_ordered_io+0x64c/0x788
[24099.409232]  [<ffffffff81074db9>] ? call_timer_fn+0xe3/0xe3
[24099.409235]  [<ffffffff812b01a0>] finish_ordered_fn+0x10/0x12
[24099.409239]  [<ffffffff812ca206>] worker_loop+0x169/0x49b
[24099.409242]  [<ffffffff812ca09d>] ? btrfs_queue_worker+0x27c/0x27c
[24099.409247]  [<ffffffff8108549c>] kthread+0x88/0x90
[24099.409251]  [<ffffffff81085414>] ? kthread_freezable_should_stop+0x3e/0x3e
[24099.409256]  [<ffffffff817d0aec>] ret_from_fork+0x7c/0xb0
[24099.409260]  [<ffffffff81085414>] ? kthread_freezable_should_stop+0x3e/0x3e
[24099.409262] ---[ end trace d8a7321b53f5ba9a ]---
[24099.409334] ------------[ cut here ]------------
[24099.409339] WARNING: CPU: 2 PID: 19049 at fs/btrfs/inode.c:2206
record_one_backref+0x303/0x31b()
[24099.409341] Modules linked in: netconsole joydev evdev psmouse
ehci_pci ohci_hcd ehci_hcd xhci_hcd snd_hda_codec_idt
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec r8169 mii brcmsmac
cordic brcmutil bcma bnep bluetooth
[24099.409427] CPU: 2 PID: 19049 Comm: btrfs-endio-wri Tainted: G
  W    3.11.0 #1
[24099.409429] Hardware name: Hewlett-Packard HP Pavilion dv6 Notebook
PC/358B, BIOS F.21 09/13/2011
[24099.409432]  000000000000089e ffff880101b63ad8 ffffffff817c33f6
000000000000008d
[24099.409439]  0000000000000000 ffff880101b63b18 ffffffff8106b44d
0000160000000000
[24099.409499]  ffffffff812a9588 0000000000000041 ffff88016c5b2240
ffff88012eac2500
[24099.409505] Call Trace:
[24099.409508]  [<ffffffff817c33f6>] dump_stack+0x46/0x58
[24099.409511]  [<ffffffff8106b44d>] warn_slowpath_common+0x7c/0x96
[24099.409623]  [<ffffffff812a9588>] ? record_one_backref+0x303/0x31b
[24099.409626]  [<ffffffff8106b47c>] warn_slowpath_null+0x15/0x17
[24099.409629]  [<ffffffff812a9588>] record_one_backref+0x303/0x31b
[24099.409633]  [<ffffffff812ede03>] ? ulist_free+0x1c/0x20
[24099.409636]  [<ffffffff812ed7cc>] iterate_extent_inodes+0x148/0x1dd
[24099.409640]  [<ffffffff812a9285>] ? btrfs_real_readdir+0x4b5/0x4b5
[24099.409643]  [<ffffffff812a9285>] ? btrfs_real_readdir+0x4b5/0x4b5
[24099.409646]  [<ffffffff812ed8e5>] iterate_inodes_from_logical+0x84/0x93
[24099.409650]  [<ffffffff812a7d8d>] record_extent_backrefs+0x5c/0xa2
[24099.409653]  [<ffffffff812b0054>] btrfs_finish_ordered_io+0x64c/0x788
[24099.409657]  [<ffffffff81074db9>] ? call_timer_fn+0xe3/0xe3
[24099.409660]  [<ffffffff812b01a0>] finish_ordered_fn+0x10/0x12
[24099.409721]  [<ffffffff812ca206>] worker_loop+0x169/0x49b
[24099.409725]  [<ffffffff812ca09d>] ? btrfs_queue_worker+0x27c/0x27c
[24099.409728]  [<ffffffff8108549c>] kthread+0x88/0x90
[24099.409732]  [<ffffffff81085414>] ? kthread_freezable_should_stop+0x3e/0x3e
[24099.409735]  [<ffffffff817d0aec>] ret_from_fork+0x7c/0xb0
[24099.409739]  [<ffffffff81085414>] ? kthread_freezable_should_stop+0x3e/0x3e
[24099.409742] ---[ end trace d8a7321b53f5ba9b ]---
[24099.540543] ------------[ cut here ]------------
[24099.540567] WARNING: CPU: 3 PID: 17571 at fs/btrfs/inode.c:2206
record_one_backref+0x303/0x31b()
[24099.540570] Modules linked in: netconsole joydev evdev psmouse
ehci_pci ohci_hcd ehci_hcd xhci_hcd snd_hda_codec_idt
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec r8169 mii brcmsmac
cordic brcmutil bcma bnep bluetooth
[24099.540606] CPU: 3 PID: 17571 Comm: btrfs-endio-wri Tainted: G
  W    3.11.0 #1
[24099.540608] Hardware name: Hewlett-Packard HP Pavilion dv6 Notebook
PC/358B, BIOS F.21 09/13/2011
[24099.540613]  000000000000089e ffff880167783ad8 ffffffff817c33f6
00000000000000f3
[24099.540625]  0000000000000000 ffff880167783b18 ffffffff8106b44d
0000160000000000
[24099.540659]  ffffffff812a9588 0000000000000092 ffff88019843ccf0
ffff880115643b00
[24099.540669] Call Trace:
[24099.540687]  [<ffffffff817c33f6>] dump_stack+0x46/0x58
[24099.540695]  [<ffffffff8106b44d>] warn_slowpath_common+0x7c/0x96
[24099.540700]  [<ffffffff812a9588>] ? record_one_backref+0x303/0x31b
[24099.540704]  [<ffffffff8106b47c>] warn_slowpath_null+0x15/0x17
[24099.540709]  [<ffffffff812a9588>] record_one_backref+0x303/0x31b
[24099.540716]  [<ffffffff812ede03>] ? ulist_free+0x1c/0x20
[24099.540721]  [<ffffffff812ed7cc>] iterate_extent_inodes+0x148/0x1dd
[24099.540725]  [<ffffffff812a9285>] ? btrfs_real_readdir+0x4b5/0x4b5
[24099.540729]  [<ffffffff812a9285>] ? btrfs_real_readdir+0x4b5/0x4b5
[24099.540742]  [<ffffffff812ed8e5>] iterate_inodes_from_logical+0x84/0x93
[24099.540746]  [<ffffffff812a7d8d>] record_extent_backrefs+0x5c/0xa2
[24099.540752]  [<ffffffff812b0054>] btrfs_finish_ordered_io+0x64c/0x788
[24099.540757]  [<ffffffff81074db9>] ? call_timer_fn+0xe3/0xe3
[24099.540761]  [<ffffffff812b01a0>] finish_ordered_fn+0x10/0x12
[24099.540765]  [<ffffffff812ca206>] worker_loop+0x169/0x49b
[24099.540769]  [<ffffffff812ca09d>] ? btrfs_queue_worker+0x27c/0x27c
[24099.540774]  [<ffffffff8108549c>] kthread+0x88/0x90
[24099.540779]  [<ffffffff81085414>] ? kthread_freezable_should_stop+0x3e/0x3e
[24099.540785]  [<ffffffff817d0aec>] ret_from_fork+0x7c/0xb0
[24099.540789]  [<ffffffff81085414>] ? kthread_freezable_should_stop+0x3e/0x3e
[24099.540793] ---[ end trace d8a7321b53f5ba9c ]---
[24249.404615] INFO: rcu_sched detected stalls on CPUs/tasks: {}
(detected by 1, t=15002 jiffies, g=2188820, c=2188819, q=86)
[24249.404637] INFO: Stall ended before state dump start
