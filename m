Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caladan.c-14.de ([78.47.48.217]:35326 "EHLO Caladan.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751521AbaIFVBN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 6 Sep 2014 17:01:13 -0400
Received: from localhost (HSI-KBW-109-193-071-016.hsi7.kabel-badenwuerttemberg.de [109.193.71.16])
	by Caladan.localdomain (Postfix) with ESMTPSA id 854FB764D3
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Sep 2014 20:54:19 +0000 (UTC)
Date: Sat, 6 Sep 2014 22:54:17 +0200
From: Simon Thelen <btrfs@c-14.de>
To: linux-btrfs@vger.kernel.org
Subject: Cannot remount root subvolume read-only.
Message-ID: <20140906205417.GA1919@anonymous>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Whenever I try to remount the root subvolume of my btrfs filesystem as
read-only `mount -o remount,ro /', I get an error 'mount: / is busy' and
the first time I execute the command I also get the following stack
trace in dmesg:
[  +0.724055] ------------[ cut here ]------------
[  +0.000011] WARNING: CPU: 2 PID: 711 at fs/sync.c:55 sync_filesystem+0x97/0xa0()
[  +0.000002] Modules linked in: snd_hda_codec_idt snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_controller wmi snd_hda_codec snd_hwdep
[  +0.000012] CPU: 2 PID: 711 Comm: mount Tainted: G          I   3.16.1-gentoo #1
[  +0.000002] Hardware name: Hewlett-Packard HP ENVY 17 Notebook PC/1966, BIOS F.11 04/19/2013
[  +0.000002]  0000000000000009 ffff880252467c60 ffffffff81852400 0000000000000000
[  +0.000004]  ffff880252467c98 ffffffff810a3488 ffff88007fbf2000 0000000000000001
[  +0.000003]  0000000070808001 ffff8802551c9000 ffff880252467dcc ffff880252467ca8
[  +0.000003] Call Trace:
[  +0.000010]  [<ffffffff81852400>] dump_stack+0x45/0x56
[  +0.000006]  [<ffffffff810a3488>] warn_slowpath_common+0x78/0xa0
[  +0.000004]  [<ffffffff810a3565>] warn_slowpath_null+0x15/0x20
[  +0.000003]  [<ffffffff811cfc37>] sync_filesystem+0x97/0xa0
[  +0.000007]  [<ffffffff8127c46e>] btrfs_remount+0x7e/0x4c0
[  +0.000007]  [<ffffffff8115a36b>] ? free_pages.part.70+0x3b/0x40
[  +0.000006]  [<ffffffff811bfbdd>] ? vfs_kern_mount+0x8d/0x110
[  +0.000004]  [<ffffffff8127d153>] btrfs_mount+0x8a3/0x9b0
[  +0.000005]  [<ffffffff81194e23>] ? alloc_pages_current+0xa3/0x170
[  +0.000006]  [<ffffffff811a6ab4>] mount_fs+0x34/0x1b0
[  +0.000004]  [<ffffffff811bfbb2>] vfs_kern_mount+0x62/0x110
[  +0.000004]  [<ffffffff811c22ce>] do_mount+0x22e/0xac0
[  +0.000003]  [<ffffffff81156de9>] ? __get_free_pages+0x9/0x40
[  +0.000003]  [<ffffffff811c1f41>] ? copy_mount_options+0x31/0x150
[  +0.000003]  [<ffffffff811c2e5e>] SyS_mount+0x7e/0xc0
[  +0.000006]  [<ffffffff8185c092>] system_call_fastpath+0x16/0x1b
[  +0.000002] ---[ end trace 29fb4471bc9e3c49 ]---

Is this a known issue? I've searched the wiki and the bugtracker but
can't find anything related.

Some additional information. I've already checked to make sure that I
don't have any files open for writing on the root filesystem using fuser
+ lsof, as well as trying to remount the root filesystem as read-only
when it is already read-only.
Remounting the filesystem as read-write works, but you cannot remount it
as read-only afterwards either.

I've tested this behavior on two of my computers with identical results,
both are running kernel 3.16.1 on a single hard drive with data in
single mode and metadata in dup mode. Both are raw btrfs on luks.

-- 
Simon Thelen
