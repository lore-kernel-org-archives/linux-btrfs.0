Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:35846 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdCQEid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 00:38:33 -0400
Received: from [192.168.0.32] (adsl.bouton.name [82.234.193.23])
        by mail.bouton.name (Postfix) with ESMTP id C93ABBA56
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Mar 2017 05:32:43 +0100 (CET)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Subject: help : "bad tree block start" -> btrfs forced readonly
Message-ID: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
Date: Fri, 17 Mar 2017 05:32:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

our largest BTRFS filesystem is damaged but I'm unclear if it is
recoverable or not. This is a 20TB filesystem with ~13TB used in a
virtual machine using virtio-scsi backed by Ceph (Firefly 0.8.10).
The following messages have become more frequent :

fileserver kernel: sd 0:0:1:0: [sdb] tag#<number> abort

This can sometimes happen under heavy IO load and I didn't immediately
spot a new cause for them : a failing disk. Then I saw this after a
failed monthly scrub :

Mar 13 03:49:01 fileserver kernel: BTRFS: checksum error at logical
13373533028352 on dev /dev/sdb, sector 26004838336, root 257, inode
8155339, offset 131072, length 4096, links 1 (path: <damaged_file>)

This was surprising as I thought Ceph would not give back bad data. I
saw this kind too :

Mar  7 18:33:53 fileserver kernel: BTRFS warning (device sdb): csum
failed ino 8155339 off 1073152 csum 1108896639 expected csum 1374028982

The csum was always 1108896639 for different chunks so I suspect this is
the csum of a zero-filled block of data. So in case of timeouts maybe
virtio-scsi just returns a block full of zero. I actually tried to read
the affected files and saw Ceph OSD timeouts on the disk I was
suspecting of failing at the same time I got the IO error.
The disk is confirmed having relocated ~40 sectors in the same period
problems appeared, it is behind an HP SATA/SAS controller so it isn't
easy to get the whole SMART info.

I restored all files affected, launched another full scrub which passed
successfully but unfortunately the damaged got worse shortly after :

Mar 16 23:30:09 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:09 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:09 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:09 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:10 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:10 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:10 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:10 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:10 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:20 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:20 fileserver kernel: ------------[ cut here ]------------
Mar 16 23:30:20 fileserver kernel: WARNING: CPU: 2 PID: 3556 at
fs/btrfs/super.c:260 __btrfs_abort_transaction+0x46/0x110()
Mar 16 23:30:20 fileserver kernel: BTRFS: Transaction aborted (error -5)
Mar 16 23:30:20 fileserver kernel: Modules linked in: nfsd auth_rpcgss
oid_registry nfs_acl ipv6 binfmt_misc mousedev 8250 processor
crc32c_intel psmouse thermal_sys serial_core button dm_zero dm_thin_pool
dm_persistent_data dm_bio_prison dm_service_time dm_round_robin
dm_queue_length dm_multipath dm_log_userspace dm_delay virtio_console
xts gf128mul aes_x86_64 cbc sha512_generic sha256_generic sha1_generic
scsi_transport_iscsi fuse overlay xfs libcrc32c nfs lockd grace sunrpc
fscache jfs reiserfs multipath linear raid10 raid1 raid0 dm_raid raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx md_mod
dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash dm_log usbhid
xhci_pci xhci_hcd ohci_pci ohci_hcd uhci_hcd usb_storage ehci_pci
ehci_hcd usbcore usb_common sr_mod cdrom sg virtio_net
Mar 16 23:30:20 fileserver kernel: CPU: 2 PID: 3556 Comm:
btrfs-transacti Not tainted 4.1.15-gentoo-r1 #2
Mar 16 23:30:20 fileserver kernel: Hardware name: QEMU Standard PC
(i440FX + PIIX, 1996), BIOS
rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
Mar 16 23:30:20 fileserver kernel:  0000000000000000 ffffffff8163e153
ffffffff81518242 ffff88082c1ebd28
Mar 16 23:30:20 fileserver kernel:  ffffffff8104ab7c ffff88042f73b600
00000000fffffffb ffff88082c68c800
Mar 16 23:30:20 fileserver kernel:  ffffffff8154f9d0 00000000000004a4
ffffffff8104abf5 ffffffff81636528
Mar 16 23:30:20 fileserver kernel: Call Trace:
Mar 16 23:30:20 fileserver kernel:  [<ffffffff81518242>] ?
dump_stack+0x40/0x50
Mar 16 23:30:20 fileserver kernel:  [<ffffffff8104ab7c>] ?
warn_slowpath_common+0x7c/0xb0
Mar 16 23:30:20 fileserver kernel:  [<ffffffff8104abf5>] ?
warn_slowpath_fmt+0x45/0x50
Mar 16 23:30:20 fileserver kernel:  [<ffffffff81252096>] ?
__btrfs_abort_transaction+0x46/0x110
Mar 16 23:30:20 fileserver kernel:  [<ffffffff812d3e6e>] ?
__btrfs_run_delayed_items+0xde/0x1d0
Mar 16 23:30:20 fileserver kernel:  [<ffffffff81280068>] ?
btrfs_commit_transaction+0x2b8/0xa60
Mar 16 23:30:20 fileserver kernel:  [<ffffffff8128089b>] ?
start_transaction+0x8b/0x5a0
Mar 16 23:30:20 fileserver kernel:  [<ffffffff8127bd0d>] ?
transaction_kthread+0x1cd/0x240
Mar 16 23:30:20 fileserver kernel:  [<ffffffff8127bb40>] ?
btrfs_cleanup_transaction+0x530/0x530
Mar 16 23:30:20 fileserver kernel:  [<ffffffff81066e8c>] ? kthread+0xbc/0xe0
Mar 16 23:30:20 fileserver kernel:  [<ffffffff81066dd0>] ?
kthread_create_on_node+0x180/0x180
Mar 16 23:30:20 fileserver kernel:  [<ffffffff8151da22>] ?
ret_from_fork+0x42/0x70
Mar 16 23:30:20 fileserver kernel:  [<ffffffff81066dd0>] ?
kthread_create_on_node+0x180/0x180
Mar 16 23:30:20 fileserver kernel: ---[ end trace f03445c45d440372 ]---
Mar 16 23:30:20 fileserver kernel: BTRFS: error (device sdb) in
__btrfs_run_delayed_items:1188: errno=-5 IO failure
Mar 16 23:30:20 fileserver kernel: BTRFS info (device sdb): forced readonly
Mar 16 23:30:20 fileserver kernel: BTRFS warning (device sdb): Skipping
commit of aborted transaction.
Mar 16 23:30:20 fileserver kernel: BTRFS: error (device sdb) in
cleanup_transaction:1692: errno=-5 IO failure
Mar 16 23:30:22 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464
Mar 16 23:30:22 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415463870464

I removed the failing disk from the cluster and rebooted the server. The
filesystem mounted fine but some time later I got these :

Mar 17 03:49:48 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415464230912
Mar 17 03:49:48 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415464230912
Mar 17 03:49:48 fileserver kernel: BTRFS (device sdb): bad tree block
start 72340172838076673 3415464230912

The filesystem didn't remount readonly this time but I installed a new
kernel (4.9.6 with the r1 Gentoo patchset insteal of 4.1.15-r1) and
rebooted again. I have a snapshot of the full device at the time of each
reboot if it can help (I can relatively easily make rw copies and work
on them without affecting the ro snapshots) and an earlier one from 4
weeks ago.

Can someone please help me determine if I can save this filesystem and
how ? I suspect there isn't much damage in quantity (there were only a
handful of damaged sectors before the disk was removed). I'm just not
sure how I can check if the internal BTRFS structures are still sound
and won't create a snowball effect destroying much more.

It is still currently used in this state in production and I'm trying to
avoid a painful switch to a remote, slow snapshot from yesterday while
beginning a very long recovery from scratch (this is at least a 2 weeks
procedure maybe more).
I'll catch some sleep right now (it's 5:28 AM here) but I'll be able to
work on this in 3 or 4 hours.

Best regards,

Lionel
