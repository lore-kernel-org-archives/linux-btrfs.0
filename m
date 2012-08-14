Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64722 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab2HNSU7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 14:20:59 -0400
Received: by weyx8 with SMTP id x8so476930wey.19
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 11:20:58 -0700 (PDT)
MIME-Version: 1.0
From: Peter Marheine <peter@taricorp.net>
Date: Tue, 14 Aug 2012 13:20:36 -0500
Message-ID: <CACvadSXOQK4ASWbocfnZnOAHbLa-Mr=j_0Dhw-ez_awddQNjRA@mail.gmail.com>
Subject: Hung I/O, Kernel BUG with corrupt leaf (bad key order)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm running btrfs in a 3-disk RAID1 configuration. After a hard
power-off, I'm seeing a lot of hung I/O tasks on this volume,
apparently due to a corrupt leaf. I first noticed the problem on
kernel 3.4.7, and it's persisted with 3.4.8. Relevant parts of the
kernel log follow.

[   85.179621] block group 38684065792 has an wrong amount of free space
[   85.179667] btrfs: failed to load free space cache for block group
38684065792
[  136.969477] btrfs: corrupt leaf, bad key order:
block=1478255230976,root=1, slot=26
[  136.998953] btrfs: corrupt leaf, bad key order:
block=1478255230976,root=1, slot=26
[  137.000492] btrfs: corrupt leaf, bad key order:
block=1478255230976,root=1, slot=26
[  137.000708] btrfs: corrupt leaf, bad key order:
block=1478255230976,root=1, slot=26
[  153.912922] btrfs: corrupt leaf, bad key order:
block=1478255230976,root=1, slot=26
[  153.913020] ------------[ cut here ]------------
[  153.913055] kernel BUG at fs/btrfs/inode.c:828!
[  153.913087] invalid opcode: 0000 [#1] PREEMPT SMP
[  153.913142] CPU 1
[  153.913155] Modules linked in: nfsd exportfs arc4 snd_hda_codec_idt
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm ath5k ath microcode i915
video i2c_algo_bit acpi_cpufreq drm_kms_helper mperf mac80211 cfg80211
i2c_i801 rfkill serio_raw drm processor evdev snd_page_alloc snd_timer
snd coretemp soundcore mei(C) psmouse pcspkr e1000e iTCO_wdt i2c_core
button iTCO_vendor_support intel_agp intel_gtt nfs nfs_acl lockd
auth_rpcgss sunrpc fscache dm_mod floppy btrfs crc32c libcrc32c
zlib_deflate ext4 crc16 jbd2 mbcache uhci_hcd ehci_hcd usbcore
usb_common sd_mod ahci libahci pata_marvell libata scsi_mod
[  153.913685]
[  153.913698] Pid: 325, comm: btrfs-transacti Tainted: G         C
3.4.8-1-ARCH #1                  /DG33TL
[  153.913767] RIP: 0010:[<ffffffffa0197cd0>]  [<ffffffffa0197cd0>]
cow_file_range+0x3d0/0x4b0 [btrfs]
[  153.913841] RSP: 0018:ffff8801a1fb1580  EFLAGS: 00010246
[  153.913873] RAX: ffff88019cd38000 RBX: ffff8801a1fb18e8 RCX: 000000000000ffff
[  153.913911] RDX: ffff88019d8bb800 RSI: ffffea00060d0040 RDI: ffff88017dff47f0
[  153.913951] RBP: ffff8801a1fb1640 R08: ffff8801a1fb18d4 R09: ffff8801a1fb18e8
[  153.913990] R10: 0000000000010000 R11: 0000000000000001 R12: 0000000000000000
[  153.914029] R13: 0000000000000000 R14: 0000000000001000 R15: ffff88017dff47f0
[  153.914068] FS:  0000000000000000(0000) GS:ffff8801abc80000(0000)
knlGS:0000000000000000
[  153.914112] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  153.914144] CR2: 00007f085106b000 CR3: 0000000198736000 CR4: 00000000000007e0
[  153.914182] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  153.914221] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  153.914261] Process btrfs-transacti (pid: 325, threadinfo
ffff8801a1fb0000, task ffff88019cd7b790)
[  153.914308] Stack:
[  153.914322]  0000000000000000 ffff880162624b60 0000000000000286
0000000000000003
[  153.914377]  000000000000ffff ffff88017dff4620 ffff8801a1fb15f0
ffffea00060d0040
[  153.914431]  ffff8801a1fb15f0 ffff88019d8bb800 ffff8801a09ad360
ffff8801a1fb18d4
[  153.914485] Call Trace:
[  153.914516]  [<ffffffffa01b687f>] ? free_extent_buffer+0x2f/0x70 [btrfs]
[  153.914565]  [<ffffffffa0198173>] run_delalloc_nocow+0x3c3/0x950 [btrfs]
[  153.914615]  [<ffffffffa0198a31>] run_delalloc_range+0x331/0x3a0 [btrfs]
[  153.914665]  [<ffffffffa01b52f1>] __extent_writepage+0x341/0x7c0 [btrfs]
[  153.914715]  [<ffffffffa01b5a52>]
extent_write_cache_pages.isra.26.constprop.44+0x2e2/0x3e0 [btrfs]
[  153.914775]  [<ffffffffa01b5da5>] extent_writepages+0x45/0x60 [btrfs]
[  153.914823]  [<ffffffffa0194330>] ? btrfs_writepage+0x70/0x70 [btrfs]
[  153.914871]  [<ffffffffa01b191e>] ? free_extent_state+0x1e/0x30 [btrfs]
[  153.914919]  [<ffffffffa0193338>] btrfs_writepages+0x28/0x30 [btrfs]
[  153.916201]  [<ffffffff81118082>] do_writepages+0x22/0x50
[  153.916315]  [<ffffffff8110d5fb>] __filemap_fdatawrite_range+0x5b/0x60
[  153.916315]  [<ffffffff8110d61f>] filemap_fdatawrite+0x1f/0x30
[  153.920013]  [<ffffffff8110d665>] filemap_write_and_wait+0x35/0x60
[  153.920013]  [<ffffffffa01cf622>] __btrfs_write_out_cache+0x792/0x9a0 [btrfs]
[  153.920013]  [<ffffffffa0175b25>] ? __find_space_info+0x85/0xa0 [btrfs]
[  153.920013]  [<ffffffffa017f28b>] ?
btrfs_run_delayed_refs+0x1cb/0x450 [btrfs]
[  153.920013]  [<ffffffffa01cf8c5>] btrfs_write_out_cache+0x95/0xf0 [btrfs]
[  153.920013]  [<ffffffffa017fa2f>]
btrfs_write_dirty_block_groups+0x51f/0x5f0 [btrfs]
[  153.920013]  [<ffffffffa01e9b2a>] commit_cowonly_roots+0xec/0x1c6 [btrfs]
[  153.920013]  [<ffffffffa0190895>]
btrfs_commit_transaction+0x575/0xaa0 [btrfs]
[  153.920013]  [<ffffffff81073b50>] ? abort_exclusive_wait+0xb0/0xb0
[  153.920013]  [<ffffffffa0188e15>] transaction_kthread+0x235/0x2b0 [btrfs]
[  153.920013]  [<ffffffffa0188be0>] ? btrfs_alloc_root+0x50/0x50 [btrfs]
[  153.920013]  [<ffffffff810731c3>] kthread+0x93/0xa0
[  153.920013]  [<ffffffff8146bfa4>] kernel_thread_helper+0x4/0x10
[  153.920013]  [<ffffffff81073130>] ? kthread_freezable_should_stop+0x70/0x70
[  153.920013]  [<ffffffff8146bfa0>] ? gs_change+0x13/0x13
[  153.920013] Code: ff 48 8b 75 88 48 8b 7d 80 41 89 c0 b9 a3 03 00
00 48 c7 c2 63 10 1f a0 41 89 c6 e8 ab 3e fd ff eb 2a 66 0f 1f 84 00
00 00 00 00 <0f> 0b 48 8b 75 88 48 8b 7d 80 41 89 c0 b9 7d 03 00 00 48
c7 c2
[  153.920013] RIP  [<ffffffffa0197cd0>] cow_file_range+0x3d0/0x4b0 [btrfs]
[  153.920013]  RSP <ffff8801a1fb1580>
[  153.920330] ---[ end trace 462486d382b33cae ]---

Btrfsck on this volume prints a lot of messages about incorrect
backrefs, and eventually fails out due to bad key ordering:

backpointer mismatch on [823847440384 1204224]
owner ref check failed [823847440384 1204224]
ref mismatch on [823848644608 1269760] extent item 1, found 0
Incorrect local backref count on 823848644608 root 5 owner 136598
offset 0 found 0 wanted 1 back 0xa6
cc9a0
backpointer mismatch on [823848644608 1269760]
owner ref check failed [823848644608 1269760]
ref mismatch on [823849914368 1662976] extent item 1, found 0
Incorrect local backref count on 823849914368 root 5 owner 136599
offset 0 found 0 wanted 1 back 0xa6
ccc00
backpointer mismatch on [823849914368 1662976]
owner ref check failed [823849914368 1662976]
ref mismatch on [823851577344 1585152] extent item 1, found 0
Incorrect local backref count on 823851577344 root 5 owner 136600
offset 0 found 0 wanted 1 back 0xa6
cd0c0
backpointer mismatch on [823851577344 1585152]
owner ref check failed [823851577344 1585152]
ref mismatch on [823853162496 1585152] extent item 1, found 0
Incorrect local backref count on 823853162496 root 5 owner 136601
offset 0 found 0 wanted 1 back 0xa6
cd580
backpointer mismatch on [823853162496 1585152]
owner ref check failed [823853162496 1585152]
ref mismatch on [823854747648 1777664] extent item 1, found 0
Incorrect local backref count on 823854747648 root 5 owner 136602
offset 0 found 0 wanted 1 back 0xa6cd450
backpointer mismatch on [823854747648 1777664]
owner ref check failed [823854747648 1777664]
owner ref check failed [1478255230976 4096]
Errors found in extent allocation tree
checking fs roots
bad key ordering 26 27
btrfsck: btrfsck.c:873: count_csum_range: Assertion `!(ret < 0)' failed.

Is there some way to fix this corruption? I noticed what looks like
the same problem in an earlier message on the list ("btrfs unmountable
after failed suspend", February 7), but with no resolution. I have
offline backups, but recovering those in their entirety will take some
time, so a solution that doesn't require wiping the entire FS would be
preferred.

-- 
Peter Marheine
