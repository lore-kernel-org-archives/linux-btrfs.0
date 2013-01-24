Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab3AXQme (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 11:42:34 -0500
Date: Thu, 24 Jan 2013 17:42:29 +0100
From: David Sterba <dsterba@suse.cz>
To: chris.mason@fusionio.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: BUG in btrfs_set_item_key_safe
Message-ID: <20130124164229.GQ28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <508A2F3F.3030500@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <508A2F3F.3030500@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Oct 26, 2012 at 08:35:43AM +0200, Jan Schmidt wrote:
> while running extensive qgroup and tree mod log tests I got to the following
> BUG, which is probably not related to tree mod log:

I've left the fsx DIO tester overnight, after Josef identified the fix for the
csum mismatch bug, and found it crashed at the same point as Jan reported:

[80582.012720] ------------[ cut here ]------------
[80582.013045] kernel BUG at fs/btrfs/ctree.c:2945!
[80582.013045] invalid opcode: 0000 [#1] PREEMPT SMP
io_blk virtio_pci sr_mod 8139cp parport microcode virtio_ring floppy virtio sg pcspkr button i2c_piix4 cdrom processor thermal_sys scsi_dh_alua scsi_dh_emc scsi_dh_rdac scsi_dh_hp_sw scsi_dh ata_ge
neric ata_piix [last unloaded: btrfs]
[80582.013045] CPU 16
[80582.013045] Pid: 13045, comm: btrfs-endio-wri Tainted: G        W    3.8.0-rc4-desktop+ #54 Bochs Bochs
[80582.013045] RIP: 0010:[<ffffffffa0393a25>]  [<ffffffffa0393a25>] btrfs_set_item_key_safe+0x65/0x1e0 [btrfs]
[80582.013045] RSP: 0018:ffff880adb9d9ad8  EFLAGS: 00010206
[80582.013045] RAX: 000000000000006c RBX: ffff880adb9d9c18 RCX: 000000000000012e
[80582.013045] RDX: 0000000000016000 RSI: ffff880adeeee076 RDI: ffff880adb9d9af9
[80582.013045] RBP: ffff880adb9d9b38 R08: ffff880ae4cd9dc0 R09: 0000000000000000
[80582.013045] R10: ffff880bee7c0f40 R11: 0000000000000015 R12: 0000000000000001
[80582.013045] R13: ffff880add976c78 R14: ffff880adb9d9ae8 R15: ffff880be92301c0
[80582.013045] FS:  0000000000000000(0000) GS:ffff880c1f200000(0000) knlGS:0000000000000000
[80582.013045] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[80582.013045] CR2: ffffffffff600400 CR3: 0000000be6cb8000 CR4: 00000000000006e0
[80582.013045] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[80582.013045] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[80582.013045] Process btrfs-endio-wri (pid: 13045, threadinfo ffff880adb9d8000, task ffff880b301545c0)
[80582.013045] Stack:
[80582.013045]  ffff880bec37a000 ffff880b932a5170 000000000000012e 000000000160006c
[80582.013045]  ffff880adb9d9b00 ffffffffa03a1ad0 000000000000012e 0000000000010000
[80582.013045]  ffff880add976c78 ffff880be92301c0 0000000000016000 0000000000000f96
[80582.013045] Call Trace:
[80582.013045]  [<ffffffffa03a1ad0>] ? btrfs_inc_extent_ref+0x90/0xb0 [btrfs]
[80582.013045]  [<ffffffffa03cdc50>] __btrfs_drop_extents+0x530/0xb70 [btrfs]
[80582.013045]  [<ffffffffa03cecab>] btrfs_drop_extents+0x6b/0x90 [btrfs]
[80582.013045]  [<ffffffffa03bce1a>] insert_reserved_file_extent+0x8a/0x2a0 [btrfs]
[80582.013045]  [<ffffffffa03c0c6e>] btrfs_finish_ordered_io+0x39e/0x3e0 [btrfs]
[80582.013045]  [<ffffffffa03c0cc0>] finish_ordered_fn+0x10/0x20 [btrfs]
[80582.013045]  [<ffffffffa03e7205>] worker_loop+0x165/0x4c0 [btrfs]
[80582.013045]  [<ffffffffa03e70a0>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
[80582.013045]  [<ffffffffa03e70a0>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
[80582.013045]  [<ffffffff8106d026>] kthread+0xc6/0xd0
[80582.013045]  [<ffffffff8106cf60>] ? kthread_freezable_should_stop+0x70/0x70
[80582.013045]  [<ffffffff815f7a7c>] ret_from_fork+0x7c/0xb0
[80582.013045]  [<ffffffff8106cf60>] ? kthread_freezable_should_stop+0x70/0x70
[80582.013045] Code: 00 00 00 4c 89 ef 48 63 d2 4c 89 f6 48 8d 14 92 48 8d 54 92 65 e8 6c 0c 04 00 48 8b 0b 48 39 4d b0 48 8b 55 b9 0f b6 45 b8 76 0b <0f> 0b eb fe 0f 1f 80 00 00 00 00 72 1e 3a 43
08 77 ee 66 0f 1f
[80582.013045] RIP  [<ffffffffa0393a25>] btrfs_set_item_key_safe+0x65/0x1e0 [btrfs]
[80582.013045]  RSP <ffff880adb9d9ad8>
[80582.071249] ---[ end trace 5360a95c1506db85 ]---

The lines are shifted, but it's the same code:

2933 void btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
2934                              struct btrfs_root *root, struct btrfs_path *path,
2935                              struct btrfs_key *new_key)
2936 {
2937         struct btrfs_disk_key disk_key;
2938         struct extent_buffer *eb;
2939         int slot;
2940
2941         eb = path->nodes[0];
2942         slot = path->slots[0];
2943         if (slot > 0) {
2944                 btrfs_item_key(eb, &disk_key, slot - 1);
2945                 BUG_ON(comp_keys(&disk_key, new_key) >= 0);
^^^^
2946         }
2947         if (slot < btrfs_header_nritems(eb) - 1) {
2948                 btrfs_item_key(eb, &disk_key, slot + 1);
2949                 BUG_ON(comp_keys(&disk_key, new_key) <= 0);
2950         }
2951
2952         btrfs_cpu_key_to_disk(&disk_key, new_key);
2953         btrfs_set_item_key(eb, &disk_key, slot);
2954         btrfs_mark_buffer_dirty(eb);
2955         if (slot == 0)
2956                 fixup_low_keys(trans, root, path, &disk_key, 1);
2957 }

It was unexpected so I haven't put any debugging into config or code.
According to the timestamps, the test has been running for 16h 58m.

Test setup:
* kvm virtual machine with 48 cpus
* 48G memory (single bit ECC)
* 5x 136GB 15K SAS disks (virtio,cache=none)

filesystem was freshly created before the test as data/raid0 and
meta/radi0 and then converted via balance to data/single meta/single
(that was one of the reproducers of the csum problem).

balance log:

[19441.016374] btrfs: disk space caching is enabled
[19452.900668] btrfs: relocating block group 4332584960 flags 9
[19455.935676] btrfs: found 4 extents
[19456.247759] btrfs: found 4 extents
[19456.471688] btrfs: relocating block group 37683200 flags 12
[19459.345387] btrfs: found 16 extents
[19459.688217] btrfs: relocating block group 20971520 flags 10
[19460.194694] btrfs: found 1 extents
[19460.465852] btrfs: relocating block group 12582912 flags 1
[19463.829548] btrfs: found 1 extents
[19464.123115] btrfs: found 1 extents
[19464.512113] btrfs: relocating block group 4194304 flags 4
[19475.407355] btrfs: found 1 extents

# btrfs fi df /mnt/btrfs/
Data: total=3.00GiB, used=11.29MiB
System, RAID1: total=32.00MiB, used=4.00KiB
System: total=4.00MiB, used=0.00
Metadata, RAID1: total=2.00GiB, used=336.00KiB

# btrfs fi show
Label: none  uuid: a15e1f6c-0e19-420e-93e2-82b4aa072a47
        Total devices 5 FS bytes used 10.41MiB
        devid    1 size 136.70GiB used 1.04GiB path /dev/vda
        devid    2 size 136.70GiB used 2.00GiB path /dev/vdb
        devid    3 size 136.70GiB used 1.00GiB path /dev/vdc
        devid    4 size 136.70GiB used 1.03GiB path /dev/vdd
        devid    5 size 136.70GiB used 2.00GiB path /dev/vde

the sources used were cmason/for-linus (0d90060f330ef49a60f56df2d9439ba263c979d9)
plus https://patchwork.kernel.org/patch/2020661/ (Btrfs: put csums on the right ordered extent)
plus https://patchwork.kernel.org/patch/1987481/ (Btrfs: fix wrong max device number for single profile)

btrfs-debug-tree dumped the filesystem without problems, so it's an in-memory
issue.


david
