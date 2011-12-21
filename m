From: Elric Milon <whirm@gmx.com>
Subject: kernel BUG at fs/btrfs/extent-tree.c:2287!
Date: Wed, 21 Dec 2011 14:33:37 +0100
Message-ID: <201112211433.37201.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

I'm getting a Kernel Bug when trying to delete some file in a btrfs while 
using 3.2.0-rc5.

Here's the kernel log:
[  676.672080] btrfs bad tree block start 0 40044687360
[  676.672233] btrfs bad tree block start 0 40044687360
[  676.672323] btrfs bad tree block start 0 40044687360
[  676.672399] btrfs bad tree block start 0 40044687360
[  676.672488] btrfs bad tree block start 0 40044687360
[  676.672562] btrfs bad tree block start 0 40044687360
[  676.672637] btrfs bad tree block start 0 40044687360
[  676.672679] ------------[ cut here ]------------
[  676.672726] kernel BUG at fs/btrfs/extent-tree.c:2287!
[  676.672769] invalid opcode: 0000 [#1] PREEMPT SMP 
[  676.672818] CPU 0 
[  676.672836] Modules linked in: bnep rfcomm pci_stub vboxpci(O) 
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc fuse btusb bluetooth 
usb_storage usbhid hid loop kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_idt 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq snd_timer snd_seq_device snd uhci_hcd sdhci_pci sdhci ehci_hcd 
mmc_core soundcore iTCO_wdt pcspkr snd_page_alloc mei(C) iTCO_vendor_support 
i2c_i801 usbcore usb_common tpm_tis tpm tpm_bios ac scsi_wait_scan thermal 
sd_mod crc_t10dif [last unloaded: scsi_wait_scan]
[  676.673377] 
[  676.673393] Pid: 5225, comm: rm Tainted: G         C O 3.2.0-rc5 #5 Dell 
Inc. Latitude E4300                  /0D201R
[  676.673484] RIP: 0010:[<ffffffff81201d19>]  [<ffffffff81201d19>] 
run_clustered_refs+0x638/0x678
[  676.673560] RSP: 0018:ffff8800a9b3bc28  EFLAGS: 00010282
[  676.673603] RAX: 00000000fffffffb RBX: ffff8800ad59a9c0 RCX: 
00000001801c0014
[  676.673653] RDX: 00000001801c0015 RSI: ffffea000458b100 RDI: 
0000000040120000
[  676.673653] RBP: ffff8800a9b3bd08 R08: ffff8801162c4b40 R09: 
00000001801c0001
[  676.673653] R10: 0000000000000000 R11: 0000000952d97000 R12: 
0000000000000000
[  676.673653] R13: ffff8800bdf01a80 R14: ffff88010354e000 R15: 
0000000000000000
[  676.673653] FS:  00007f2a7322e700(0000) GS:ffff88011bc00000(0000) 
knlGS:0000000000000000
[  676.673653] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  676.673653] CR2: 00000000008a40a8 CR3: 00000000bdc5f000 CR4: 
00000000000006f0
[  676.673653] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  676.673653] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  676.673653] Process rm (pid: 5225, threadinfo ffff8800a9b3a000, task 
ffff88001e906740)
[  676.673653] Stack:
[  676.673653]  0000000000034885 0000000000000000 ffff880000000001 
0000000000000000
[  676.673653]  ffff8800a9b3bc68 ffffffff810336f0 ffff8801161e1658 
ffff8800a9b3bd38
[  676.673653]  ffff8800a9b3bba8 0000000000000001 ffff8801161e1660 
0000000000000005
[  676.673653] Call Trace:
[  676.673653]  [<ffffffff810336f0>] ? get_parent_ip+0xf/0x40
[  676.673653]  [<ffffffff8123e641>] ? btrfs_find_ref_cluster+0xf6/0x137
[  676.673653]  [<ffffffff81201e25>] btrfs_run_delayed_refs+0xcc/0x17c
[  676.673653]  [<ffffffff811f5d3a>] ? btrfs_free_path+0x22/0x26
[  676.673653]  [<ffffffff8120fa5e>] __btrfs_end_transaction+0x98/0x1f3
[  676.673653]  [<ffffffff8120fbf0>] btrfs_end_transaction_throttle+0x13/0x15
[  676.673653]  [<ffffffff81211a56>] __unlink_end_trans+0x68/0x6d
[  676.673653]  [<ffffffff81216558>] btrfs_unlink+0x8a/0xa7
[  676.673653]  [<ffffffff810f5d83>] vfs_unlink+0x6f/0xbd
[  676.673653]  [<ffffffff810f5eba>] do_unlinkat+0xe9/0x173
[  676.673653]  [<ffffffff810e993b>] ? filp_close+0x69/0x75
[  676.673653]  [<ffffffff810f71d7>] sys_unlinkat+0x24/0x26
[  676.673653]  [<ffffffff8149dcbb>] system_call_fastpath+0x16/0x1b
[  676.673653] Code: 89 74 24 10 48 8b 73 48 48 89 74 24 08 48 8b 73 40 48 89 
34 24 48 8b 7d a0 4c 89 f6 e8 d4 c9 ff ff eb 04 0f 0b 0f 0b 85 c0 74 02 <0f> 
0b 48 89 df e8 d6 a5 ff ff 4c 89 e7 e8 aa 15 ee ff ff 45 94 
[  676.673653] RIP  [<ffffffff81201d19>] run_clustered_refs+0x638/0x678
[  676.673653]  RSP <ffff8800a9b3bc28>
[  676.714652] ---[ end trace 40a721fc91a71635 ]---


###############


Mount options are:
 rw,nosuid,relatime,compress=lzo,ssd,discard,space_cache,inode_cache

The FS is on LVM on a Vertex II SSD disk. 

If I run a scrub it aborts after reading 1.8GB and some more lines appear in 
the kernel log:

[ 1066.807925] btrfs bad tree block start 0 40044888064
[ 1066.808430] btrfs bad tree block start 0 40044888064
[ 1066.808523] btrfs bad tree block start 0 40044888064
[ 1066.808584] btrfs bad tree block start 0 40044888064
[ 1066.808674] btrfs bad tree block start 0 40044888064
[ 1066.808750] btrfs bad tree block start 0 40044888064
[ 1066.808822] btrfs bad tree block start 0 40044888064


Are there any patches I can try to see if they fix this?

I'm available to run some tests or provide more info if required.

Thanks.


-- 

Elric Milon
