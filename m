From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: [3.2.1] kernel BUG at fs/btrfs/disk-io.c:2835!
Date: Wed, 25 Jan 2012 10:27:01 +0000
Message-ID: <20120125102701.GA27648@Pilar.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I want to report a btrfs bug that happened this morning on kernel 3.2.1.

I was copying a +5 GB file between two external usb harddisks, one
formated with btrfs (the source) and the other with ext4 (the destination).

In the meantime I decided to compile the 3.3-rc1 kernel with the output
dir on the ext4 external harddisk. After some time I started to get
many I/O errors coming from the ext4 drive (sdc1) on dmesg, e.g.:

Buffer I/O error on device sdc1, logical block 3084285

After that it looks like the ext4 HD was unmounted automatically and
the btrfs HD made this BUG:

 usb 2-1: USB disconnect, device number 2
 EXT4-fs error (device sdc1): ext4_find_entry:935: inode #109051908: comm bash: reading directory lblock 0
 EXT4-fs error (device sdc1): ext4_find_entry:935: inode #109051905: comm bash: reading directory lblock 0
 EXT4-fs error (device sdc1): ext4_find_entry:935: inode #2: comm umount: reading directory lblock 0
 lost page write due to I/O error on sdb1
 lost page write due to I/O error on sdb1
 lost page write due to I/O error on sdb1
 btrfs: 1 errors while writing supers
 ------------[ cut here ]------------
 kernel BUG at /home/mafra/linux-2.6/fs/btrfs/disk-io.c:2835!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU 2
 Modules linked in: loop af_packet snd_pcm_oss snd_mixer_oss microcode arc4 sr_mod cdrom sg ath9k mac80211 uvcvideo i2c_i801 ath9k_common ath9k_hw ath cfg80211 sony_laptop rfkill radeon ttm drm_kms_helper drm i2c_algo_bit

 Pid: 17579, comm: umount Not tainted 3.2.1+ #68 Sony Corporation VPCEB4X1E/VAIO
 RIP: 0010:[<ffffffff811b4689>]  [<ffffffff811b4689>] write_all_supers+0x879/0x880
 RSP: 0018:ffff88011198dca8  EFLAGS: 00010292
 RAX: 000000000000003a RBX: ffff8800b4b378b8 RCX: 00000000000010a5
 RDX: 00000000000004c2 RSI: 0000000000000046 RDI: ffffffff81b0c880
 RBP: ffff88011198dd08 R08: 0000000000000000 R09: 0000000000000000
 R10: 000000000000000a R11: 0000000000000001 R12: ffff88011198dcd0
 R13: ffff8800b4b378b8 R14: ffff8800acf88000 R15: ffff8801046a7400
 FS:  00007f89586087e0(0000) GS:ffff880117c80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00007f8957d47fc0 CR3: 000000011199e000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process umount (pid: 17579, threadinfo ffff88011198c000, task ffff880106eb4940)
 Stack:
  ffff8800b4b37840 0000000000000000 0000000100000000 ffff880100000001
  0000000000000001 ffff8800b4b378b8 ffff88011198dd08 ffff88011263fe80
  ffff8801046a7400 ffff880105618540 ffff88011198dd78 ffff88011263fef8
 Call Trace:
  [<ffffffff811b469e>] write_ctree_super+0xe/0x10
  [<ffffffff811b9778>] btrfs_commit_transaction+0x6a8/0x870
  [<ffffffff811b8a8a>] ? join_transaction+0x24a/0x280
  [<ffffffff810611f0>] ? wake_up_bit+0x40/0x40
  [<ffffffff81195a57>] btrfs_sync_fs+0x47/0x70
  [<ffffffff811029be>] __sync_filesystem+0x5e/0x90
  [<ffffffff81102a53>] sync_filesystem+0x43/0x60
  [<ffffffff810dc226>] generic_shutdown_super+0x36/0xe0
  [<ffffffff810dc361>] kill_anon_super+0x11/0x20
  [<ffffffff810dc715>] deactivate_locked_super+0x45/0x80
  [<ffffffff810dd115>] deactivate_super+0x45/0x60
  [<ffffffff810f753d>] mntput_no_expire+0x9d/0xf0
  [<ffffffff810f837a>] sys_umount+0x6a/0x380
  [<ffffffff814e6e7b>] system_call_fastpath+0x16/0x1b
  Code: 33 00 e9 7e fd ff ff 44 89 ce 48 c7 c7 80 a4 78 81 31 c0 e8 04 ea 32 00 0f 0b 8b 75 b8 48 c7 c7 80 a4 78 81 31 c0 e8 f1 e9 32 00 <0f>
0b 0f 1f 44 00 00 55 48 89 f7 89 d6 48 89 e5 e8 72 f7 ff ff
 RIP  [<ffffffff811b4689>] write_all_supers+0x879/0x880
  RSP <ffff88011198dca8>
 ---[ end trace 37039e5aca9c365c ]---
 SysRq : Emergency Remount R/O


I will move to testing 3.3-rc1 now, is this bug already fixed there?
