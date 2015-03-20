Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35459 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbbCTFAJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 01:00:09 -0400
Received: by pdbop1 with SMTP id op1so97519230pdb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 22:00:09 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by mx.google.com with ESMTPSA id ce1sm5726851pdb.34.2015.03.19.22.00.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2015 22:00:08 -0700 (PDT)
Date: Fri, 20 Mar 2015 12:59:01 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: WARNING at fs/btrfs/super.c:260 __btrfs_abort_transaction
Message-ID: <20150320045900.GA16812@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Filling a dm/lvm snapshot triggered this btrfs WARNING, kernel is 4.0-rc3+

I'm working a xfstests case but this simple script could reproduce

--- cut ---
#!/bin/bash
dev=/dev/sda5
mnt=/mnt/test
vgname=testvg
lvname=testlv
snap=snap

vgcreate -f $vgname $dev
lvcreate -L 256M -n $lvname $vgname

mkfs -t btrfs /dev/mapper/$vgname-$lvname

lvcreate -s -L 4M -n $snap $vgname/$lvname

mount /dev/mapper/$vgname-snap $mnt

dd if=/dev/zero of=$mnt/testfile bs=1M count=5
umount $mnt >/dev/null 2>&1

vgremove -f $vgname
pvremove -f $dev
--- cut ---

The same script can trigger warning on ext4 too, I'll file another bug
report to ext4 list.

Thanks,
Eryu Guan


[150646.284481] device-mapper: snapshots: Invalidating snapshot: Unable to allocate exception.
[150646.292271] btrfs_dev_stat_print_on_error: 1028 callbacks suppressed
[150646.294338] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
[150646.296578] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
[150646.299203] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
[150646.302141] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
[150646.303165] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
[150646.304364] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
[150646.305474] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
[150646.308789] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
[150646.310997] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
[150646.312739] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
[150646.331472] BTRFS: error (device dm-3) in btrfs_commit_transaction:2019: errno=-5 IO failure (Error while writing out transaction)
[150646.334251] BTRFS info (device dm-3): forced readonly
[150646.335365] BTRFS warning (device dm-3): Skipping commit of aborted transaction.
[150646.336955] ------------[ cut here ]------------
[150646.338003] WARNING: CPU: 3 PID: 19036 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0x54/0x130 [btrfs]()
[150646.340094] Modules linked in: arc4 md4 nls_utf8 cifs rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache nfsd auth_rpcgss nfs_acl lockd grace sunrpc ext4 mbcache jbd2 btrfs xor raid6_pq dm_snapshot dm_bufio dm_mod ppdev parport_pc i2c_piix4 parport i2c_core pcspkr serio_raw acpi_cpufreq xfs sd_mod ata_generic pata_acpi 8139too ata_piix 8139cp libata mii virtio_pci virtio virtio_ring floppy
[150646.345100] CPU: 3 PID: 19036 Comm: umount Tainted: G        W       4.0.0-rc3+ #16
[150646.345748] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[150646.346254]  0000000000000000 00000000bc933968 ffff8800358c7b98 ffffffff816c1fda
[150646.346937]  0000000000000000 ffff8800358c7bf0 ffff8800358c7bd8 ffffffff81077f1a
[150646.347630]  ffff8800358c7c28 ffff88003570c000 ffff8800d8a24800 00000000fffffffb
[150646.348334] Call Trace:
[150646.348561]  [<ffffffff816c1fda>] dump_stack+0x45/0x57
[150646.349036]  [<ffffffff81077f1a>] warn_slowpath_common+0x8a/0xc0
[150646.349544]  [<ffffffff81077fa5>] warn_slowpath_fmt+0x55/0x70
[150646.350070]  [<ffffffffa02bf4e4>] __btrfs_abort_transaction+0x54/0x130 [btrfs]
[150646.350702]  [<ffffffffa02ed9c4>] cleanup_transaction+0x84/0x2d0 [btrfs]
[150646.351295]  [<ffffffffa02bf1d5>] ? btrfs_printk+0x95/0x110 [btrfs]
[150646.351845]  [<ffffffff810bb4d0>] ? prepare_to_wait_event+0xf0/0xf0
[150646.352399]  [<ffffffff810baf28>] ? __wake_up+0x48/0x60
[150646.352866]  [<ffffffffa02ee761>] btrfs_commit_transaction+0x2c1/0xa50 [btrfs]
[150646.353500]  [<ffffffffa02b9c49>] btrfs_sync_fs+0x59/0x110 [btrfs]
[150646.354064]  [<ffffffff81227aa2>] sync_filesystem+0x82/0xb0
[150646.354542]  [<ffffffff811f79c4>] generic_shutdown_super+0x34/0x100
[150646.355102]  [<ffffffff811f7d46>] kill_anon_super+0x16/0x30
[150646.355581]  [<ffffffffa02bf038>] btrfs_kill_super+0x18/0x120 [btrfs]
[150646.356158]  [<ffffffff811f8129>] deactivate_locked_super+0x49/0x80
[150646.356703]  [<ffffffff811f875e>] deactivate_super+0x4e/0x70
[150646.357210]  [<ffffffff81215b33>] cleanup_mnt+0x43/0x90
[150646.357659]  [<ffffffff8111cb26>] ? __audit_syscall_exit+0x1e6/0x280
[150646.358230]  [<ffffffff81215bd2>] __cleanup_mnt+0x12/0x20
[150646.358703]  [<ffffffff810957b7>] task_work_run+0xb7/0xf0
[150646.359190]  [<ffffffff81014c6d>] do_notify_resume+0x8d/0xa0
[150646.359677]  [<ffffffff816c96e3>] int_signal+0x12/0x17
[150646.360148] ---[ end trace 3134000b65e864ce ]---
[150646.360549] BTRFS: error (device dm-3) in cleanup_transaction:1678: errno=-5 IO failure
[150646.361254] BTRFS info (device dm-3): delayed_refs has NO entry
[150646.755585] BTRFS info (device sda5): disk space caching is enabled
