Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:37260 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab3EWVes (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 17:34:48 -0400
Received: from ipb4.telenor.se (ipb4.telenor.se [195.54.127.167])
	by smtprelay-b22.telenor.se (Postfix) with ESMTP id AAB22D99D
	for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 23:17:02 +0200 (CEST)
Received: from fredrik by rinnestam.se with local (Exim 4.80.1)
	(envelope-from <fredrik@rinnestam.se>)
	id 1UfcsQ-0004W3-Ow
	for linux-btrfs@vger.kernel.org; Thu, 23 May 2013 23:16:46 +0200
Date: Thu, 23 May 2013 23:16:46 +0200
From: Fredrik Rinnestam <fredrik@rinnestam.se>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG on balance, 3.10-rc2 skinny
Message-ID: <20130523211646.GA17318@zoidberg.obra.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Filesystem was created fairly recently under kernel 3.9 iirc.

Data, RAID0: total=2.51TB, used=2.49TB
System, RAID1: total=32.00MB, used=188.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=5.00GB, used=3.72GB

Total devices 2 FS bytes used 2.49TB
devid    1 size 2.73TB used 1.26TB path /dev/sdd
devid    2 size 2.73TB used 1.26TB path /dev/sdc

mount:
/dev/sdd on /home/fredrik type btrfs (rw,noatime,compress=lzo,space_cache)

log attached

-- 

Fredrik Rinnestam

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=btrfs

[16608.738909] btrfs: relocating block group 7988232323072 flags 9
[16615.765058] btrfs: found 3 extents
[16620.296989] ------------[ cut here ]------------
[16620.297009] kernel BUG at fs/btrfs/relocation.c:3296!
[16620.297025] invalid opcode: 0000 [#1] PREEMPT SMP 
[16620.297043] Modules linked in: auth_rpcgss oid_registry nfsv4 nfsv3 nfs lockd sunrpc loop fuse w83627ehf hwmon_vid snd_hda_codec_realtek btusb ath3k bluetooth kvm_intel kvm crc32c_intel aesni_intel evdev aes_x86_64 glue_helper lrw gf128mul ablk_helper snd_hda_intel r8169 snd_hda_codec mii snd_hwdep sr_mod firewire_ohci snd_pcm cdrom snd_page_alloc firewire_core snd_timer crc_itu_t snd xhci_hcd soundcore thermal fan 8250 serial_core rtc_cmos button
[16620.297256] CPU: 0 PID: 30752 Comm: btrfs Not tainted 3.10.0-rc2 #2
[16620.297276] Hardware name: System manufacturer System Product Name/P8P67 DELUXE, BIOS 3602 10/31/2012
[16620.297308] task: ffff880272015280 ti: ffff880101b4c000 task.ti: ffff880101b4c000
[16620.297332] RIP: 0010:[<ffffffff8118af95>]  [<ffffffff8118af95>] __add_tree_block+0xe8/0xfb
[16620.297364] RSP: 0018:ffff880101b4da88  EFLAGS: 00010287
[16620.297380] RAX: 00000731283b7000 RBX: ffff88040c41ae10 RCX: 0000000000000000
[16620.297403] RDX: 0000000000000011 RSI: ffff880007cd1684 RDI: ffff880101b4da78
[16620.297426] RBP: 0000000000000001 R08: ffff880101b4da78 R09: ffff8803c2d46988
[16620.297449] R10: 0000000000001000 R11: 0000160000000000 R12: 00000731283f4000
[16620.297472] R13: ffff880407879000 R14: ffff880101b4db60 R15: 0000000000001000
[16620.297495] FS:  00007f6018cd5740(0000) GS:ffff88041ec00000(0000) knlGS:0000000000000000
[16620.297522] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16620.297540] CR2: 00007f62954a4000 CR3: 0000000104447000 CR4: 00000000000407f0
[16620.297562] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[16620.297585] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[16620.297608] Stack:
[16620.297611]  ffff880101b4db77 00ffffff81164783 a900000731283b70 0000000000000000
[16620.297640]  0000000000001000 ffff88040c4907e0 ffff880407879000 0000000000000eba
[16620.297669]  ffff880101b4db60 ffff880003a71400 ffff880101b4db77 ffffffff8118b049
[16620.297697] Call Trace:
[16620.297704]  [<ffffffff8118b049>] ? add_data_references+0xa1/0x1af
[16620.297726]  [<ffffffff81164783>] ? btrfs_get_token_64+0x76/0xc6
[16620.297746]  [<ffffffff8118d318>] ? relocate_block_group+0x1f8/0x4db
[16620.297767]  [<ffffffff8118d73c>] ? btrfs_relocate_block_group+0x141/0x268
[16620.297790]  [<ffffffff8116f13d>] ? btrfs_relocate_chunk.isra.65+0x4b/0x398
[16620.297814]  [<ffffffff813fd010>] ? _raw_spin_unlock+0x1c/0x28
[16620.297832]  [<ffffffff81166fe8>] ? release_extent_buffer+0x90/0x97
[16620.297853]  [<ffffffff81171db2>] ? btrfs_balance+0x947/0xb11
[16620.297872]  [<ffffffff81177a19>] ? btrfs_ioctl_balance+0x228/0x2a4
[16620.297892]  [<ffffffff8117a4cb>] ? btrfs_ioctl+0xf32/0x18bf
[16620.297911]  [<ffffffff8102014d>] ? __do_page_fault+0x284/0x322
[16620.297931]  [<ffffffff810986b2>] ? vma_link+0x6e/0x8c
[16620.297948]  [<ffffffff810bb586>] ? vfs_ioctl+0x1e/0x31
[16620.297964]  [<ffffffff810bbd63>] ? do_vfs_ioctl+0x3b4/0x3f6
[16620.297983]  [<ffffffff810bbde1>] ? SyS_ioctl+0x3c/0x67
[16620.298000]  [<ffffffff813fdc52>] ? system_call_fastpath+0x16/0x1b
[16620.298019] Code: 4c 89 f7 31 ed e8 19 d1 ff ff 48 85 c0 75 1e e9 6e ff ff ff 4c 89 f1 48 89 da 4c 89 ef 48 8d 74 24 0f e8 80 e0 ff ff 89 c5 eb bd <0f> 0b 48 83 c4 28 89 e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 57 
[16620.298162] RIP  [<ffffffff8118af95>] __add_tree_block+0xe8/0xfb
[16620.298182]  RSP <ffff880101b4da88>
[16620.306795] ---[ end trace bdf9370f4dbb18f4 ]---


--82I3+IH0IqGh5yIs--
