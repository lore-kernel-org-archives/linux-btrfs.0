Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49238 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752968AbdKCQeq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 12:34:46 -0400
Date: Fri, 3 Nov 2017 17:34:44 +0100
From: Petr Janecek <janecek@ucw.cz>
To: linux-btrfs@vger.kernel.org
Subject: btrfs_cleaner lockdep warning in v4.9.56
Message-ID: <20171103163443.GA30483@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
      this warning happened during "btrfs subvolume remove" of a
readonly snapshot after the newest in the snapshot series was
"btrfs received".

[96857.000284] ------------[ cut here ]------------
[96857.000307] WARNING: CPU: 1 PID: 371 at kernel/locking/lockdep.c:704 register_lock_class+0x4c8/0x530
[96857.000322] Modules linked in: fuse vfat msdos fat dm_mod nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc xfs ipmi_watchdog libcrc32c raid1 iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm_intel kvm evdev irqbypass serio_raw hpilo hpwdt tpm_tis tpm_tis_core acpi_power_meter tpm button lpc_ich mfd_core md_mod ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler autofs4 btrfs xor raid6_pq sg sd_mod uas usb_storage crc32c_intel ahci libahci psmouse libata scsi_mod uhci_hcd xhci_pci xhci_hcd tg3 ptp pps_core libphy thermal ehci_pci ehci_hcd usbcore usb_common
[96857.000744] CPU: 1 PID: 371 Comm: btrfs-cleaner Not tainted 4.9.56 #13
[96857.000769] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 06/06/2014
[96857.000795]  ffffc90000a4fa48 ffffffff81309da5 0000000000000000 0000000000000000
[96857.000849]  ffffc90000a4fa88 ffffffff81059b7c 000002c000000004 0000000000000000
[96857.000901]  0000000000000000 ffffffff8234baf0 ffff880041fca450 0000000000000000
[96857.000954] Call Trace:
[96857.000979]  [<ffffffff81309da5>] dump_stack+0x67/0x92
[96857.001004]  [<ffffffff81059b7c>] __warn+0xcc/0xf0
[96857.001029]  [<ffffffff81059c58>] warn_slowpath_null+0x18/0x20
[96857.001054]  [<ffffffff810aa7b8>] register_lock_class+0x4c8/0x530
[96857.001080]  [<ffffffff810ad846>] __lock_acquire+0x76/0x7f0
[96857.001105]  [<ffffffff810ae40e>] lock_acquire+0xbe/0x1f0
[96857.001161]  [<ffffffffa02d4bc9>] ? btrfs_tree_lock+0x89/0x250 [btrfs]
[96857.001188]  [<ffffffff815afd03>] _raw_write_lock+0x33/0x50
[96857.001233]  [<ffffffffa02d4bc9>] ? btrfs_tree_lock+0x89/0x250 [btrfs]
[96857.001276]  [<ffffffffa02d4bc9>] btrfs_tree_lock+0x89/0x250 [btrfs]
[96857.001322]  [<ffffffffa02b9eda>] ? find_extent_buffer+0xda/0x1e0 [btrfs]
[96857.001367]  [<ffffffffa02b9e00>] ? release_extent_buffer+0xc0/0xc0 [btrfs]
[96857.001409]  [<ffffffffa0277da0>] do_walk_down+0xf0/0x930 [btrfs]
[96857.001450]  [<ffffffffa0278692>] walk_down_tree+0xb2/0xe0 [btrfs]
[96857.001491]  [<ffffffffa027b4b9>] btrfs_drop_snapshot+0x3a9/0x780 [btrfs]
[96857.001517]  [<ffffffff815af8e2>] ? _raw_spin_unlock+0x22/0x30
[96857.001561]  [<ffffffffa02f400d>] ? btrfs_kill_all_delayed_nodes+0xbd/0xd0 [btrfs]
[96857.001617]  [<ffffffffa029471d>] btrfs_clean_one_deleted_snapshot+0xad/0xe0 [btrfs]
[96857.001672]  [<ffffffffa028b11f>] cleaner_kthread+0x16f/0x1e0 [btrfs]
[96857.001713]  [<ffffffffa028afb0>] ? btree_invalidatepage+0xa0/0xa0 [btrfs]
[96857.001741]  [<ffffffff8107eef6>] kthread+0x116/0x130
[96857.001765]  [<ffffffff8107ede0>] ? kthread_park+0x60/0x60
[96857.001790]  [<ffffffff815b0207>] ret_from_fork+0x27/0x40
[96857.001814] ---[ end trace ff21435da4cc1bc5 ]---


Regards,

Petr

