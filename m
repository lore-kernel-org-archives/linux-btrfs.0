Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62169 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbbBMXGi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 18:06:38 -0500
Received: by mail-ob0-f172.google.com with SMTP id nt9so25470205obb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 15:06:38 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 14 Feb 2015 00:06:37 +0100
Message-ID: <CAOQhA5Xpv=tgHmvvDp22pBtdoku1JOuuymUJZbPsMhPjn4MJ8g@mail.gmail.com>
Subject: Kernel bug when deleting snapshot?
From: Robert Mucina <robert.mucina@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I had a problem recently with segmentation fault when I tried to
remove device from pool ( see here
http://article.gmane.org/gmane.comp.file-systems.btrfs/42800 ) Since
then I scrubbed the pool and corrected some errors and upgraded kernel
to 3.18.7. I left device that couldn't be removed earlier in the pool.

Data is ok now, but there seems to be some kind of problem with
snapshots. Soon after mounting the pool I get this in dmesg... (before
this there's nothing out of ordinary or suspicious in there)


[   80.703249] ------------[ cut here ]------------
[   80.703267] WARNING: CPU: 0 PID: 794 at
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:862
btrfs_lookup_extent_info+0x4c9/0x4d0 [btrfs]()
[   80.703285] Modules linked in: rfcomm bnep bluetooth binfmt_misc
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp eeepc_wmi
asus_wmi kvm_intel sparse_keymap video kvm crct10dif_pclmul
snd_hda_codec_realtek snd_hda_codec_generic crc32_pclmul joydev
ghash_clmulni_intel snd_hda_intel snd_hda_controller snd_hda_codec
snd_hwdep aesni_intel snd_pcm aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd snd_seq_midi snd_seq_midi_event serio_raw
snd_rawmidi lpc_ich snd_seq snd_seq_device snd_timer snd 8250_fintek
tpm_infineon mac_hid soundcore mei_me mei shpchp parport_pc ppdev lp
nls_iso8859_1 parport btrfs xor raid6_pq hid_logitech_dj usbhid hid
radeon mxm_wmi i2c_algo_bit psmouse ttm firewire_ohci drm_kms_helper
ahci firewire_core libahci drm crc_itu_t r8169 mii wmi
[   80.703286] CPU: 0 PID: 794 Comm: btrfs-cleaner Not tainted
3.18.7-031807-generic #201502110759
[   80.703287] Hardware name: System manufacturer System Product
Name/P8P67-M PRO, BIOS 0708 03/08/2011
[   80.703288]  000000000000035e ffff8804f487fbc8 ffffffff817a6c79
0000000000000286
[   80.703289]  0000000000000000 ffff8804f487fc08 ffffffff81074c0c
ffff8804e14b1d88
[   80.703290]  ffff8804e6371000 ffff8804fcde3cf0 ffff8804f48ca800
000010dac771c000
[   80.703291] Call Trace:
[   80.703295]  [<ffffffff817a6c79>] dump_stack+0x46/0x58
[   80.703298]  [<ffffffff81074c0c>] warn_slowpath_common+0x8c/0xc0
[   80.703300]  [<ffffffff81074c5a>] warn_slowpath_null+0x1a/0x20
[   80.703307]  [<ffffffffc067d379>]
btrfs_lookup_extent_info+0x4c9/0x4d0 [btrfs]
[   80.703308]  [<ffffffff8108ad64>] ? wake_up_worker+0x24/0x30
[   80.703311]  [<ffffffff811d3225>] ? kmem_cache_alloc+0x35/0x1f0
[   80.703317]  [<ffffffffc067dd1b>] walk_down_proc+0x1ab/0x300 [btrfs]
[   80.703323]  [<ffffffffc068105c>] walk_down_tree+0x6c/0x100 [btrfs]
[   80.703330]  [<ffffffffc0683ee4>] ? btrfs_drop_snapshot+0x64/0x810 [btrfs]
[   80.703336]  [<ffffffffc0684251>] btrfs_drop_snapshot+0x3d1/0x810 [btrfs]
[   80.703348]  [<ffffffffc06867c0>] ?
btrfs_delete_unused_bgs+0x160/0x270 [btrfs]
[   80.703350]  [<ffffffff810b4a53>] ? __wake_up+0x53/0x70
[   80.703373]  [<ffffffffc0698089>]
btrfs_clean_one_deleted_snapshot+0xc9/0x130 [btrfs]
[   80.703380]  [<ffffffffc068fd74>] cleaner_kthread+0x134/0x190 [btrfs]
[   80.703386]  [<ffffffffc068fc40>] ?
btrfs_destroy_all_delalloc_inodes+0x120/0x120 [btrfs]
[   80.703388]  [<ffffffff81093b29>] kthread+0xc9/0xe0
[   80.703389]  [<ffffffff81093a60>] ? flush_kthread_worker+0x90/0x90
[   80.703391]  [<ffffffff817b447c>] ret_from_fork+0x7c/0xb0
[   80.703392]  [<ffffffff81093a60>] ? flush_kthread_worker+0x90/0x90
[   80.703393] ---[ end trace b7c28f2707556628 ]---
[   80.703410] ------------[ cut here ]------------
[   80.703411] kernel BUG at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:7733!
[   80.703412] invalid opcode: 0000 [#1] SMP
[   80.703424] Modules linked in: rfcomm bnep bluetooth binfmt_misc
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp eeepc_wmi
asus_wmi kvm_intel sparse_keymap video kvm crct10dif_pclmul
snd_hda_codec_realtek snd_hda_codec_generic crc32_pclmul joydev
ghash_clmulni_intel snd_hda_intel snd_hda_controller snd_hda_codec
snd_hwdep aesni_intel snd_pcm aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd snd_seq_midi snd_seq_midi_event serio_raw
snd_rawmidi lpc_ich snd_seq snd_seq_device snd_timer snd 8250_fintek
tpm_infineon mac_hid soundcore mei_me mei shpchp parport_pc ppdev lp
nls_iso8859_1 parport btrfs xor raid6_pq hid_logitech_dj usbhid hid
radeon mxm_wmi i2c_algo_bit psmouse ttm firewire_ohci drm_kms_helper
ahci firewire_core libahci drm crc_itu_t r8169 mii wmi
[   80.703425] CPU: 0 PID: 794 Comm: btrfs-cleaner Tainted: G        W
     3.18.7-031807-generic #201502110759
[   80.703434] Hardware name: System manufacturer System Product
Name/P8P67-M PRO, BIOS 0708 03/08/2011
[   80.703434] task: ffff8804fd063200 ti: ffff8804f487c000 task.ti:
ffff8804f487c000
[   80.703440] RIP: 0010:[<ffffffffc067de6b>]  [<ffffffffc067de6b>]
walk_down_proc+0x2fb/0x300 [btrfs]
[   80.703441] RSP: 0018:ffff8804f487fcd8  EFLAGS: 00010246
[   80.703442] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000001c64
[   80.703443] RDX: 0000000000001c63 RSI: 0000000000000000 RDI: 000000000001d890
[   80.703443] RBP: ffff8804f487fd28 R08: ffffea0013f378c0 R09: ffffffffc066cffa
[   80.703444] R10: 0000000000000003 R11: ffff8804e6371000 R12: ffff8800344d0b40
[   80.703444] R13: ffff8804fcde3ea0 R14: ffff8804f54a7068 R15: ffff8804f48ca800
[   80.703445] FS:  0000000000000000(0000) GS:ffff88051f400000(0000)
knlGS:0000000000000000
[   80.703446] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   80.703446] CR2: 00007f0fb2c0421c CR3: 0000000004c16000 CR4: 00000000000407f0
[   80.703447] Stack:
[   80.703447]  ffff8800344d0b98 0000000000000201 ffff8804e6371000
ffffffff00000003
[   80.703448]  ffff8804f487fd68 ffff8804fcde3ea0 ffff8804fcde3ea0
0000000000000003
[   80.703449]  ffff8800344d0b40 ffff8804f48ca800 ffff8804f487fd88
ffffffffc068105c
[   80.703449] Call Trace:
[   80.703456]  [<ffffffffc068105c>] walk_down_tree+0x6c/0x100 [btrfs]
[   80.703469]  [<ffffffffc0683ee4>] ? btrfs_drop_snapshot+0x64/0x810 [btrfs]
[   80.703475]  [<ffffffffc0684251>] btrfs_drop_snapshot+0x3d1/0x810 [btrfs]
[   80.703481]  [<ffffffffc06867c0>] ?
btrfs_delete_unused_bgs+0x160/0x270 [btrfs]
[   80.703482]  [<ffffffff810b4a53>] ? __wake_up+0x53/0x70
[   80.703496]  [<ffffffffc0698089>]
btrfs_clean_one_deleted_snapshot+0xc9/0x130 [btrfs]
[   80.703503]  [<ffffffffc068fd74>] cleaner_kthread+0x134/0x190 [btrfs]
[   80.703509]  [<ffffffffc068fc40>] ?
btrfs_destroy_all_delalloc_inodes+0x120/0x120 [btrfs]
[   80.703510]  [<ffffffff81093b29>] kthread+0xc9/0xe0
[   80.703511]  [<ffffffff81093a60>] ? flush_kthread_worker+0x90/0x90
[   80.703512]  [<ffffffff817b447c>] ret_from_fork+0x7c/0xb0
[   80.703513]  [<ffffffff81093a60>] ? flush_kthread_worker+0x90/0x90
[   80.703529] Code: 4c 89 f7 e8 98 35 05 00 e9 3a ff ff ff 0f 1f 00
4c 89 f7 e8 f8 32 05 00 e9 2a ff ff ff 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b
0f 0b 0f 0b <0f> 0b 0f 1f 00 66 66 66 66 90 55 48 89 e5 53 bb 01 00 00
00 48
[   80.703534] RIP  [<ffffffffc067de6b>] walk_down_proc+0x2fb/0x300 [btrfs]
[   80.703535]  RSP <ffff8804f487fcd8>
[   80.703536] ---[ end trace b7c28f2707556629 ]---


I could use some advice here. It seems to me that because of this I
can't properly unmount the pool. Forcing umount doesn't help, verbose
umount produces neither console output nor dmesg output, it just hangs
although I can see that mountpoint is empty.

Thoughts anyone?

Regards
Robert
