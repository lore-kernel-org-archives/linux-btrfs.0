Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:53191 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab2G3T3E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 15:29:04 -0400
Date: Mon, 30 Jul 2012 15:29:00 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: segfault on mounting second device
Message-ID: <20120730192900.GA13956@localhost.localdomain>
References: <5016D17D.5070700@in.waw.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <5016D17D.5070700@in.waw.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2012 at 12:25:01PM -0600, Zbigniew Jędrzejewski-Szmek wrote:
> Hi,
> 
> I was trying to mount two-disk btrfs without the first disk (the setup is RAID1 data & metadata
> on two disks). Kernel is 3.5.0-6-generic from Ubuntu.
> 
> [  977.061470] device label HOME devid 2 transid 24686 /dev/sda3
> [  977.062992] btrfs: allowing degraded mounts
> [  977.063300] btrfs: disk space caching is enabled
> [  977.135840] btrfs: bdev (null) errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
> [  977.136228] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
> [  977.888055] [drm] nouveau 0000:00:0d.0: Setting dpms mode 1 on vga encoder (output 0)
> [  981.401171] BUG: unable to handle kernel NULL pointer dereference at 00000008
> [  981.401483] IP: [<c116bb82>] seq_escape+0x12/0xf0
> [  981.401752] *pdpt = 0000000034f97001 *pde = 0000000000000000 
> [  981.402384] Oops: 0000 [#1] SMP 
> [  981.402633] Modules linked in: netconsole configfs binfmt_misc arc4 snd_hda_codec_realtek nouveau mxm_wmi wmi snd_wavefront video ttm b43 snd_cs4236 drm_kms_helper drm i2c_algo_bit snd_opl3_lib snd_wss_lib bcma snd_hda_intel mac80211 snd_hda_codec cfg80211 snd_hwdep pcspkr snd_mpu401 snd_pcm snd_mpu401_uart snd_page_alloc snd_rawmidi evbug snd_timer snd_seq_device snd k8temp soundcore i2c_nforce2 parport_pc parport mac_hid w83627ehf hwmon_vid autofs4 btrfs libcrc32c zlib_deflate usbhid hid ssb forcedeth sata_sil pata_amd sata_nv [last unloaded: netconsole]
> [  981.404464] 
> [  981.404464] Pid: 1, comm: systemd Not tainted 3.5.0-6-generic #6-Ubuntu To Be Filled By O.E.M. To Be Filled By O.E.M./K8NF6G-VSTA
> [  981.404464] EIP: 0060:[<c116bb82>] EFLAGS: 00010286 CPU: 0
> [  981.404464] EIP is at seq_escape+0x12/0xf0
> [  981.404464] EAX: f703ca20 EBX: f73b2000 ECX: f862e8cb EDX: f703ca20
> [  981.404464] ESI: 00000002 EDI: 00000008 EBP: f4c79ebc ESP: f4c79ea0
> [  981.404464]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  981.404464] CR0: 80050033 CR2: 00000008 CR3: 34f94000 CR4: 000007f0
> [  981.404464] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  981.404464] DR6: ffff0ff0 DR7: 00000400
> [  981.404464] Process systemd (pid: 1, ti=f4c78000 task=f4c70000 task.ti=f4c78000)
> [  981.404464] Stack:
> [  981.404464]  00000073 f4c79ec8 c116bc0b f4c79ebc f73b2000 00000002 00000000 f4c79ed8
> [  981.404464]  f859c3ac f73b2000 f703ca20 f4531010 f703ca20 f6bd8c00 f4c79f20 c1184b03
> [  981.404464]  c177630e c1787722 00000029 00000014 00000000 00000022 c112473d fffbaa90
> [  981.404464] Call Trace:
> [  981.404464]  [<c116bc0b>] ? seq_escape+0x9b/0xf0
> [  981.404464]  [<f859c3ac>] btrfs_show_devname+0x8c/0xc0 [btrfs]
> [  981.404464]  [<c1184b03>] show_mountinfo+0x173/0x260
> [  981.404464]  [<c112473d>] ? handle_mm_fault+0x1dd/0x280
> [  981.404464]  [<c1168380>] m_show+0x10/0x20
> [  981.404464]  [<c116bee5>] seq_read+0xd5/0x3c0
> [  981.404464]  [<c116be10>] ? seq_lseek+0x150/0x150
> [  981.404464]  [<c114efe9>] vfs_read+0x89/0x160
> [  981.404464]  [<c116be10>] ? seq_lseek+0x150/0x150
> [  981.404464]  [<c114f0fd>] sys_read+0x3d/0x70
> [  981.404464]  [<c15c701f>] sysenter_do_call+0x12/0x28
> [  981.404464] Code: 83 c3 01 39 fb 76 d0 66 90 31 db 83 c4 08 89 d8 5b 5e 5f 5d c3 8d 74 26 00 55 89 e5 57 56 53 83 ec 10 3e 8d 74 26 00 89 d7 89 c2 <0f> b6 37 8b 5a 0c 89 45 e8 8b 00 89 4d ec 8b 4a 04 89 f2 01 c3 
> [  981.404464] EIP: [<c116bb82>] seq_escape+0x12/0xf0 SS:ESP 0068:f4c79ea0
> [  981.404464] CR2: 0000000000000008
> [  981.433876] [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encoder (output 0)
> [  981.437631] ---[ end trace ec2ba853e06fd789 ]---
> [  981.438875] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> [  981.438875] 
> [  981.439741] panic occurred, switching back to text console
> 
> To my untrained eye, it looks like first_dev->name->str is NULL.
> 
>         if (first_dev) {
>                 rcu_read_lock();
>                 name = rcu_dereference(first_dev->name);
>                 seq_escape(m, name->str, " \t\n\\");
>                 rcu_read_unlock();
>         } else {
> 
> Zbyszek

Hrm oops, I will fix that, thanks for reporting,

Josef
