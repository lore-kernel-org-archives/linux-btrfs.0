Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37099 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbHSNXE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 09:23:04 -0400
Received: by igui7 with SMTP id i7so5599311igu.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 06:23:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 19 Aug 2015 09:23:02 -0400
Message-ID: <CAJtFHUQukRC9m+Bq85CN7v_tCk6ybGvParax5ixcMJwKHRUFCQ@mail.gmail.com>
Subject: Kernel 4.1.4 btrfs forced read-only during rsync
From: E V <eliventer@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

linux 4.1.4 forced read-only during an rsync, complaining about lack
of space, with ~30TB free. Filesystem has 6 snapshots, basically 3
incremental rsync's of 2 different external filesystems. Not sure how
to proceed, balance -dusage=5 then try and remount, doesn't balance
need rw?

# btrfs file usage /mirror
Overall:
    Device size:                 140.07TiB
    Device allocated:            109.58TiB
    Device unallocated:           30.48TiB
    Device missing:                  0.00B
    Used:                        106.40TiB
    Free (estimated):             33.67TiB      (min: 18.42TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:109.32TiB, Used:106.13TiB
   /dev/sdb       22.36TiB
   /dev/sdc       22.36TiB
   /dev/sdd       32.26TiB
   /dev/sde       32.33TiB

Metadata,RAID1: Size:138.00GiB, Used:136.37GiB
   /dev/sdb       35.00GiB
   /dev/sdc       33.00GiB
   /dev/sdd      138.00GiB
   /dev/sde       70.00GiB

System,RAID1: Size:40.00MiB, Used:13.00MiB
   /dev/sdc        8.00MiB
   /dev/sdd       40.00MiB
   /dev/sde       32.00MiB

Unallocated:
   /dev/sdb        7.62TiB
   /dev/sdc        7.62TiB
   /dev/sdd        7.62TiB
   /dev/sde        7.62TiB

Aug 16 04:41:31 [1082957.226804] ------------[ cut here ]------------
Aug 16 04:41:31 [1082957.226817] BTRFS: error (device sdb) in
__btrfs_free_extent:6235: errno=-28 No space left
Aug 16 04:41:31 [1082957.226819] BTRFS info (device sdb): forced readonly
Aug 16 04:41:31 [1082957.226821] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
Aug 16 04:41:31 [1082957.226824] BTRFS: error (device sdb) in
__btrfs_free_extent:6235: errno=-28 No space left
Aug 16 04:41:31 [1082957.226826] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
Aug 16 04:41:31 [1082957.226834] BTRFS: error (device sdb) in
__btrfs_free_extent:6235: errno=-28 No space left
Aug 16 04:41:31 [1082957.226837] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
Aug 16 04:41:31 [1082957.226843] BTRFS: error (device sdb) in
__btrfs_free_extent:6235: errno=-28 No space left
Aug 16 04:41:31 [1082957.226847] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
Aug 16 04:41:31 [1082957.226850] BTRFS: error (device sdb) in
__btrfs_free_extent:6235: errno=-28 No space left
Aug 16 04:41:31 [1082957.226853] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
Aug 16 04:41:31 [1082957.226856] BTRFS: error (device sdb) in
__btrfs_free_extent:6235: errno=-28 No space left
Aug 16 04:41:31 [1082957.226858] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
Aug 16 04:41:31 [1082957.227456] WARNING: CPU: 2 PID: 23585 at
fs/btrfs/super.c:260 __btrfs_abort_transaction+0x46/0x104 [btrfs]()
Aug 16 04:41:31 [1082957.227506] BTRFS: Transaction aborted (error -28)
Aug 16 04:41:31 [1082957.227508] Modules linked in: nfsv3 nls_utf8
fuse ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs libcrc32c
ipmi_si mpt2sas raid_class scsi_transport_sas dell_rbu nfsd nfs_acl
auth_rpcgss oid_registry nfsv4 nfs lockd grace sunrpc fscache ext4
crc16 jbd2 ext2 coretemp crct10dif_pclmul ghash_clmulni_intel
aesni_intel joydev aes_x86_64 glue_helper lrw gf128mul ablk_helper
cryptd iTCO_wdt iTCO_vendor_support ipmi_devintf dcdbas evdev psmouse
serio_raw pcspkr i7core_edac ipmi_msghandler acpi_power_meter
edac_core lpc_ich mfd_core button processor thermal_sys loop ext3
mbcache jbd btrfs xor hid_generic usbhid hid raid6_pq sg sd_mod
crc32c_intel ehci_pci uhci_hcd megaraid_sas ehci_hcd ixgbe mdio
usbcore ptp usb_common scsi_mod pps_core bnx2 [last unloaded: ipmi_si]
Aug 16 04:41:31 [1082957.228004] CPU: 2 PID: 23585 Comm: kworker/u65:0
Tainted: G          I     4.1.4 #1
Aug 16 04:41:31 [1082957.228050] Hardware name: Dell Inc. PowerVault
DL2200/0DPRKF, BIOS 1.8.2 08/23/2011
Aug 16 04:41:31 [1082957.228120] Workqueue: btrfs-extent-refs
btrfs_extent_refs_helper [btrfs]
Aug 16 04:41:31 [1082957.228153]  0000000000000000 0000000000000009
ffffffff813a6b70 ffff880001a4fae8
Aug 16 04:41:31 [1082957.228208]  ffffffff810412ed ffffffff217f4000
ffffffffa0165516 ffff88061f644800
Aug 16 04:41:31 [1082957.228262]  00000000ffffffe4 ffff88047f8e54e8
ffffffffa01e8180 000000000000185b
Aug 16 04:41:31 [1082957.228317] Call Trace:
Aug 16 04:41:31 [1082957.228348]  [<ffffffff813a6b70>] ? dump_stack+0x40/0x50
Aug 16 04:41:31 [1082957.228380]  [<ffffffff810412ed>] ?
warn_slowpath_common+0x98/0xb0
Aug 16 04:41:31 [1082957.228423]  [<ffffffffa0165516>] ?
__btrfs_abort_transaction+0x46/0x104 [btrfs]
Aug 16 04:41:31 [1082957.228471]  [<ffffffff8104134a>] ?
warn_slowpath_fmt+0x45/0x4a
Aug 16 04:41:31 [1082957.228514]  [<ffffffffa0165516>] ?
__btrfs_abort_transaction+0x46/0x104 [btrfs]
Aug 16 04:41:31 [1082957.228575]  [<ffffffffa01736a3>] ?
__btrfs_free_extent+0x82d/0x841 [btrfs]
Aug 16 04:41:31 [1082957.228611]  [<ffffffff8110f481>] ?
__drain_alien_cache+0x54/0x68
Aug 16 04:41:31 [1082957.228662]  [<ffffffffa01c346d>] ?
btrfs_merge_delayed_refs+0x19f/0x1b6 [btrfs]
Aug 16 04:41:31 [1082957.228743]  [<ffffffffa0178dac>] ?
__btrfs_run_delayed_refs+0xad2/0xc70 [btrfs]
Aug 16 04:41:31 [1082957.228812]  [<ffffffffa017abaa>] ?
btrfs_run_delayed_refs+0x60/0x18a [btrfs]
Aug 16 04:41:31 [1082957.228874]  [<ffffffffa017ad07>] ?
delayed_ref_async_start+0x33/0x71 [btrfs]
Aug 16 04:41:31 [1082957.228941]  [<ffffffffa01add73>] ?
normal_work_helper+0xc4/0x1fb [btrfs]
Aug 16 04:41:31 [1082957.228974]  [<ffffffff8105c33b>] ?
finish_task_switch+0x5d/0xb5
Aug 16 04:41:31 [1082957.229005]  [<ffffffff81052917>] ?
process_one_work+0x15c/0x289
Aug 16 04:41:31 [1082957.229036]  [<ffffffff810531c0>] ?
worker_thread+0x1de/0x288
Aug 16 04:41:31 [1082957.229065]  [<ffffffff81052fe2>] ?
rescuer_thread+0x285/0x285
Aug 16 04:41:31 [1082957.229095]  [<ffffffff81056c75>] ? kthread+0xab/0xb3
Aug 16 04:41:31 [1082957.229123]  [<ffffffff81056bca>] ?
__kthread_parkme+0x5d/0x5d
Aug 16 04:41:31 [1082957.229154]  [<ffffffff813aa8d2>] ? ret_from_fork+0x42/0x70
Aug 16 04:41:31 [1082957.229183]  [<ffffffff81056bca>] ?
__kthread_parkme+0x5d/0x5d
Aug 16 04:41:31 [1082957.229212] ---[ end trace a391b0c670fce8c0 ]---
Aug 16 04:41:31 [1082957.229240] BTRFS: error (device sdb) in
__btrfs_free_extent:6235: errno=-28 No space left
Aug 16 04:41:31 [1082957.229289] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
Aug 16 04:41:31 [1082957.289141] BTRFS: error (device sdb) in
btrfs_start_dirty_block_groups:3509: errno=-28 No space left
Aug 16 04:41:31 [1082957.289196] BTRFS: error (device sdb) in
btrfs_start_dirty_block_groups:3509: errno=-28 No space left
Aug 16 04:41:31 [1082957.289245] BTRFS warning (device sdb): Skipping
commit of aborted transaction.
Aug 16 04:41:31 [1082957.289289] BTRFS: error (device sdb) in
cleanup_transaction:1692: errno=-5 IO failure
Aug 16 04:41:31 [1082957.548123] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-28 No space left
Aug 16 04:41:33 [1082960.119194] pending csums is 3145728
