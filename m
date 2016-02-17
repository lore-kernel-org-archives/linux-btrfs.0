Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:34980 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030335AbcBQOd1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 09:33:27 -0500
Received: by mail-qg0-f46.google.com with SMTP id y89so12710597qge.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 06:33:27 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 17 Feb 2016 15:33:26 +0100
Message-ID: <CAH4oapeNxzNgLy6X9x4u3hueWf9t+Xfu7P7f51Vb3h0TgyeZhQ@mail.gmail.com>
Subject: btrfs_orphan_cleanup
From: Pavol Cupka <pavol.cupka@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

after boot I am seeing this in dmesg


[   23.874698] BTRFS info (device sda1): enabling auto defrag
[   23.874702] BTRFS info (device sda1): disk space caching is enabled
[   26.074456] Adding 4193276k swap on /dev/sda4.  Priority:-1
extents:1 across:4193276k
[   26.242940] ------------[ cut here ]------------
[   26.242953] WARNING: CPU: 1 PID: 1863 at fs/btrfs/inode.c:3443
btrfs_orphan_cleanup+0x2d1/0x420()
[   26.242955] Modules linked in: vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) tun nvidia(PO) cdc_ether usbnet mii cdc_acm cdc_wdm iwldvm
iwlwifi intel_agp intel_gtt efivarfs
[   26.242977] CPU: 1 PID: 1863 Comm: mount Tainted: P        W  O
4.1.7-hardened-r1 #3
[   26.242979] Hardware name: Dell Inc. Latitude E6510/0N5KHN, BIOS
A16 12/05/2013
[   26.242982]  ffffffff81c113c4 ffffc90001633918 ffffffff819d1e43
ffffffff81e3a0f8
[   26.242986]  0000000000000000 ffffc90001633958 ffffffff8107cf25
ffff88021f57f800
[   26.242989]  ffff88021f57f800 ffff880222c39e10 ffff8802217d74e0
0000000000000000
[   26.242993] Call Trace:
[   26.243004]  [<ffffffff819d1e43>] dump_stack+0x45/0x5d
[   26.243012]  [<ffffffff8107cf25>] warn_slowpath_common+0x85/0xd0
[   26.243016]  [<ffffffff8107d025>] warn_slowpath_null+0x15/0x20
[   26.243019]  [<ffffffff8133f4f1>] btrfs_orphan_cleanup+0x2d1/0x420
[   26.243023]  [<ffffffff8133f9c0>] btrfs_lookup_dentry+0x380/0x530
[   26.243027]  [<ffffffff8133fb81>] btrfs_lookup+0x11/0x50
[   26.243033]  [<ffffffff811bb1fc>] lookup_real+0x2c/0x80
[   26.243036]  [<ffffffff811bbd4e>] __lookup_hash+0x2e/0x40
[   26.243041]  [<ffffffff811c187e>] path_lookupat+0x88e/0xd10
[   26.243048]  [<ffffffff8144574e>] ? idr_get_empty_slot+0x1be/0x4e0
[   26.243056]  [<ffffffff8119f4bc>] ? kmem_cache_alloc+0x2c/0x150
[   26.243058]  [<ffffffff811c2adf>] ? getname_kernel+0x2f/0x130
[   26.243060]  [<ffffffff811c1d1f>] filename_lookup+0x1f/0x100
[   26.243062]  [<ffffffff811c2f82>] vfs_path_lookup+0x62/0xc0
[   26.243065]  [<ffffffff8122a3be>] ? proc_alloc_inum+0x2e/0xb0
[   26.243069]  [<ffffffff81464b7b>] ? __list_add+0x1b/0x40
[   26.243073]  [<ffffffff811d88eb>] mount_subtree+0x3b/0x90
[   26.243075]  [<ffffffff811a0bb8>] ? kfree+0x38/0x180
[   26.243079]  [<ffffffff81303e93>] btrfs_mount+0x273/0x970
[   26.243081]  [<ffffffff811b3aaf>] mount_fs+0x3f/0x1a0
[   26.243085]  [<ffffffff811710e0>] ? __alloc_percpu+0x10/0x20
[   26.243087]  [<ffffffff811d4123>] vfs_kern_mount+0x63/0x120
[   26.243089]  [<ffffffff811d7587>] do_mount+0x557/0xdc0
[   26.243091]  [<ffffffff81199c65>] ? alloc_pages_current+0x95/0x120
[   26.243094]  [<ffffffff81154b09>] ? __get_free_pages+0x9/0xb0
[   26.243096]  [<ffffffff811d6e75>] ? copy_mount_options+0x35/0x1c0
[   26.243098]  [<ffffffff811d83aa>] SyS_mount+0x8a/0xf0
[   26.243101]  [<ffffffff819dba4b>] system_call_fastpath+0x12/0x79
[   26.243102] ---[ end trace 666fc5daa976e384 ]---
[   26.243108] BTRFS error (device sda1): Error removing orphan entry,
stopping orphan cleanup
[   26.243110] BTRFS error (device sda1): could not do orphan cleanup -22

Linux  4.1.7-hardened-r1 #3 SMP Thu Dec 24 14:19:04 CET 2015 x86_64
Intel(R) Core(TM) i7 CPU M 640 @ 2.80GHz GenuineIntel GNU/Linux
btrfs-progs v4.3.1

Is there something I can do about it?

Thank you in advance
Pavol
