Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43363 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3AVBMd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 20:12:33 -0500
Received: by mail-we0-f170.google.com with SMTP id r1so1866184wey.29
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 17:12:32 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Jan 2013 02:12:31 +0100
Message-ID: <CAMQ-g0fbP98XvWX6NyzKPrMCNzdi4vSJ3uo0D66Sg+MCcFm5FA@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/extent-tree.c:5223
From: Jan Steffens <jan.steffens@gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

our build server's scratch btrfs is seriously broken now. Shortly
after mount, btrfs-cleaner triggers a bug:

device label chroots devid 1 transid 47052 /dev/mapper/vg_brynhild-chroots
btrfs: use lzo compression
btrfs: disk space caching is enabled
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:5223!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: tun btrfs libcrc32c zlib_deflate coretemp kvm_intel
kvm r8169 crc32c_intel i2c_i801 wmi acpi_cpufreq mperf gpio_ich mii
microcode iTCO_wdt iTCO_vendor_support processor i7core_edac i2c_core
edac_core lpc_ich ext4 crc16 jbd2 mbcache dm_mod raid1 md_mod sd_mod
uhci_hcd ahci libahci libata ehci_hcd scsi_mod usbcore usb_common
CPU 2
Pid: 1163, comm: btrfs-cleaner Not tainted 3.7.3-1-ARCH #1 MSI
MS-7522/MSI X58 Pro-E (MS-7522)
RIP: 0010:[<ffffffffa064228c>]  [<ffffffffa064228c>]
__btrfs_free_extent+0x7cc/0x880 [btrfs]
RSP: 0018:ffff880231dc7b28  EFLAGS: 00010287
RAX: 0000000010000001 RBX: ffff88022279b000 RCX: ffff88021d64d000
RDX: 0000000000003000 RSI: 000000000000308d RDI: ffff88021dc82d70
RBP: ffff880231dc7bf8 R08: 0000000000003091 R09: ffff880231dc7a90
R10: 0000000000000000 R11: 0000000000000003 R12: 0000000000000001
R13: 000000000000004a R14: 000000000000305c R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88023fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000001646de8 CR3: 000000000180c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-cleaner (pid: 1163, threadinfo ffff880231dc6000, task
ffff8802249a8000)
Stack:
 0000000000000000 0000000000000973 000000000001264a 0000000000000000
 ffff880200000000 ffff8802226840c0 0000003500000001 ffff88021dc82d70
 ffff880228e25000 0100000100000001 000000055f618000 ffff880228e26000
Call Trace:
 [<ffffffffa06469f8>] run_clustered_refs+0x318/0xaf0 [btrfs]
 [<ffffffffa063d080>] ? block_group_cache_tree_search+0x90/0xd0 [btrfs]
 [<ffffffffa0698fc3>] ? find_ref_head+0x83/0xf0 [btrfs]
 [<ffffffffa0649f98>] btrfs_run_delayed_refs+0xc8/0x2f0 [btrfs]
 [<ffffffffa0659535>] btrfs_should_end_transaction+0x75/0x80 [btrfs]
 [<ffffffffa0648922>] btrfs_drop_snapshot+0x3b2/0x5c0 [btrfs]
 [<ffffffffa065b1f7>] btrfs_clean_old_snapshots+0xa7/0x150 [btrfs]
 [<ffffffffa0651a68>] cleaner_kthread+0xa8/0x120 [btrfs]
 [<ffffffffa06519c0>] ? btrfs_alloc_root+0x50/0x50 [btrfs]
 [<ffffffff8107b050>] kthread+0xc0/0xd0
 [<ffffffff81010000>] ? perf_trace_xen_mmu_set_pte_at+0xb0/0x100
 [<ffffffff8107af90>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814b426c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107af90>] ? kthread_freezable_should_stop+0x70/0x70
Code: ff 01 6c a0 e8 e6 52 a1 e0 e9 9c fc ff ff 0f 0b 0f 0b 48 8b 55
a0 48 8b 3b 48 8d 73 40 e8 e0 63 07 00 39 45 20 0f 84 71 fd ff ff <0f>
0b 0f 0b 48 8b 55 80 89 c6 48 c7 c7 20 1d 6c a0 31 c0 e8 2e
RIP  [<ffffffffa064228c>] __btrfs_free_extent+0x7cc/0x880 [btrfs]
 RSP <ffff880231dc7b28>
---[ end trace 28edb33d5f184428 ]---
note: btrfs-cleaner[1163] exited with preempt_count 2

Afterwards, an unreleased lock seems to cause process to hang all over.
The btrfs is located on LVM on an mdraid1. Typical usage involves a
lot of snapshotting and snapshot deleting.

The source is:
5221                 if (found_extent) {
5222                         BUG_ON(is_data && refs_to_drop !=
5223                                extent_data_ref_count(root, path, iref));
5224                         if (iref) {

If an umount is attempted before the cleaner crashes, umount crashes
instead, with the same backtrace.
Neither btrfs-zero-log nor -o recovery have any noticeable effect.
---

btrfs-find-root reports:

Super think's the tree root is at 77758464, chunk root 131072
Well block 9469952 seems great, but generation doesn't match,
have=46931, want=47052
Well block 63373312 seems great, but generation doesn't match,
have=46936, want=47052
Well block 64651264 seems great, but generation doesn't match,
have=46937, want=47052
Well block 65273856 seems great, but generation doesn't match,
have=46938, want=47052
Well block 66027520 seems great, but generation doesn't match,
have=46939, want=47052
Well block 67010560 seems great, but generation doesn't match,
have=46940, want=47052
Well block 73744384 seems great, but generation doesn't match,
have=46948, want=47052
Well block 77643776 seems great, but generation doesn't match,
have=46953, want=47052
Found tree root at 77758464
---

btrfsck fails with:

btrfsck: disk-io.c:441: find_and_setup_root: Assertion `!(ret)' failed.
---

btrfs-image fails with:

checksum verify failed on 65536 wanted 6DA0839F found 29
checksum verify failed on 65536 wanted 6DA0839F found 29
Csum didn't match
btrfs-image: btrfs-image.c:394: flush_pending: Assertion `!(!eb)' failed.
---

Complete kmsg of 3.6.11 (first triggered): http://sprunge.us/BIjB
Complete kmsg of 3.7.3: http://sprunge.us/XfDE
I've still got the broken filesystem (107G) for debugging and an
lrzip-compressed complete image of it, sized 32G, which I can send to
you, if needed.

Thanks,
Jan Steffens
