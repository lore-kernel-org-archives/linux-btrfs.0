Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36237 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbbFQJVM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 05:21:12 -0400
Received: by wicnd19 with SMTP id nd19so22300289wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 02:21:10 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 17 Jun 2015 12:20:30 +0300
Message-ID: <CAGqmi74U2Q5ZUHW_YtzjmSRTkx1Mo38gFpqZkOR03mmOrVyX_g@mail.gmail.com>
Subject: Re: RAID1: system stability
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Upd:
i've try do removing disk by 'right' way:
# echo 1 > /sys/block/sdf/device/delete

All okay and system don't crush immediately on 'sync' call and can
work some time without problem, but after some call, which i can
repeat by:
  # apt-get update
testing system get kernel crush (on which i delete one of raid1 btrfs
device), i've get following dmesg:
----
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: Modules linked in: 8021q
garp mrp stp llc binfmt_misc gpio_ich coretemp kvm_intel lpc_ich
ipmi_ssif kvm amdkfd amd_iommu_v2 serio_raw radeon ttm i5000_edac
drm_kms_helper drm edac_core i2c_algo_bit i5k_amb ioatdma dca shpchp
8250_fintek joydev mac_hid ipmi_si ipmi_msghandler bonding autofs4
btrfs xor raid6_pq ses enclosure hid_generic psmouse usbhid hid mptsas
mptscsih e1000e mptbase scsi_transport_sas ptp pps_core
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: CPU: 3 PID: 99 Comm:
kworker/u16:4 Not tainted 4.0.4-040004-generic #201505171336
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: Hardware name: Intel
S5000VSA/S5000VSA, BIOS S5000.86B.15.00.0101.110920101604 11/09/2010
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: Workqueue: btrfs-endio
btrfs_endio_helper [btrfs]
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: task: ffff88009ab31400
ti: ffff88009ab40000 task.ti: ffff88009ab40000
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: RIP:
0010:[<ffffffffc0477d50>]  [<ffffffffc0477d50>]
repair_io_failure+0x1c0/0x200 [btrfs]
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: RSP:
0018:ffff88009ab43bb8  EFLAGS: 00010206
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: RAX: 0000000000000000
RBX: ffff88009b1d3f30 RCX: ffff88009b53f9c0
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: RDX: ffff88044902f400
RSI: 0000000000000000 RDI: ffff88009b53f9c0
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: RBP: ffff88009ab43c18
R08: 0000000000000000 R09: 0000000000000000
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: R10: ffff880448c1b090
R11: 0000000000000000 R12: 0000000039070000
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: R13: ffff880439599e68
R14: 0000000000001000 R15: ffff88009a860000
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: FS:
0000000000000000(0000) GS:ffff88045fcc0000(0000)
knlGS:0000000000000000
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: CR2: 00007f640a27e675
CR3: 0000000098b4b000 CR4: 00000000000407e0
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: Stack:
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  0000000000000000
000000009a860de0 ffffea0002644380 00000003d2ee8000
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  0000000000008000
ffff88009b53f9c0 ffff88009ab43c18 ffff88009b1d3f30
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  ffff88044c44a3c0
ffff88009b0c1190 0000000000000000 ffff88009a860000
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: Call Trace:
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffffc0477f30>]
clean_io_failure+0x1a0/0x1b0 [btrfs]
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffffc0478218>]
end_bio_extent_readpage+0x2d8/0x3d0 [btrfs]
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff8137b2c3>]
bio_endio+0x53/0xa0
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff8137b322>]
bio_endio_nodec+0x12/0x20
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffffc044efb8>]
end_workqueue_fn+0x48/0x60 [btrfs]
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffffc0488b2e>]
normal_work_helper+0x7e/0x1b0 [btrfs]
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffffc0488d32>]
btrfs_endio_helper+0x12/0x20 [btrfs]
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff81092204>]
process_one_work+0x144/0x490
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff81092c6e>]
worker_thread+0x11e/0x450
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff81092b50>] ?
create_worker+0x1f0/0x1f0
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff81098999>]
kthread+0xc9/0xe0
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff810988d0>] ?
flush_kthread_worker+0x90/0x90
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff817f08d8>]
ret_from_fork+0x58/0x90
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  [<ffffffff810988d0>] ?
flush_kthread_worker+0x90/0x90
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: Code: 44 00 00 4c 89 ef
e8 b0 34 f0 c0 31 f6 4c 89 e7 e8 06 05 01 00 ba fb ff ff ff e9 c7 fe
ff ff ba fb ff ff ff e9 bd fe ff ff 0f 0b <0f> 0b 49 8b 4c 24 30 48 8b
b3 58 fe ff ff 48 83 c1 10 48 85 f6
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: RIP  [<ffffffffc0477d50>]
repair_io_failure+0x1c0/0x200 [btrfs]
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel:  RSP <ffff88009ab43bb8>
Jun 17 12:00:41 srv-lab-ceph-node-01 kernel: ---[ end trace
0361c6fdca5f7ee2 ]---
---

Another test case:
i've delete device:
echo 1 > /sys/block/sdf/device/delete
after i reinsert this device (remove and insert again in server)
Server found sdg device, all that okay but kernel crush with following
stuck trace:
---
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: kernel BUG at
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2057!
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: invalid opcode: 0000 [#1] SMP
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: Modules linked in: 8021q
garp mrp stp llc binfmt_misc gpio_ich coretemp kvm_intel amdkfd
amd_iommu_v2 ipmi_ssif kvm radeon lpc_ich serio_raw ttm i5000_edac
edac_core drm_kms_helper drm i5k_amb ioatdma i2c_algo_bit joydev
8250_fintek ipmi_si dca ipmi_msghandler mac_hid shpchp bonding autofs4
btrfs xor raid6_pq ses enclosure hid_generic psmouse mptsas usbhid
mptscsih hid mptbase scsi_transport_sas e1000e ptp pps_core
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: CPU: 2 PID: 72 Comm:
kworker/u16:2 Not tainted 4.0.4-040004-generic #201505171336
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: Hardware name: Intel
S5000VSA/S5000VSA, BIOS S5000.86B.15.00.0101.110920101604 11/09/2010
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: Workqueue: btrfs-endio
btrfs_endio_helper [btrfs]
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: task: ffff88044d215a00
ti: ffff880449b1c000 task.ti: ffff880449b1c000
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: RIP:
0010:[<ffffffffc02a9d50>]  [<ffffffffc02a9d50>]
repair_io_failure+0x1c0/0x200 [btrfs]
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: RSP:
0018:ffff880449b1fbb8  EFLAGS: 00010206
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: RAX: 0000000000000000
RBX: ffff88044c3ac308 RCX: ffff88044c5ef3c0
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: RDX: ffff880449117400
RSI: 0000000000000000 RDI: ffff88044c5ef3c0
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: RBP: ffff880449b1fc18
R08: 0000000000000000 R09: 0000000000000000
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: R10: ffff880448ce0090
R11: 0000000000000000 R12: 000000003999a000
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: R13: ffff88043999a568
R14: 0000000000001000 R15: ffff880449510000
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: FS:
0000000000000000(0000) GS:ffff88045fc80000(0000)
knlGS:0000000000000000
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: CR2: 00007fbfbe12cf00
CR3: 0000000449b4e000 CR4: 00000000000407e0
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: Stack:
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  0000000000000000
0000000049510de0 ffffea0010f40540 00000003f7ed4000
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  000000000000c000
ffff88044c5ef3c0 ffff880449b1fc18 ffff88044c3ac308
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  ffff88044b1acc80
ffff880448dcbfa0 0000000000000000 ffff880449510000
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: Call Trace:
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffffc02a9f30>]
clean_io_failure+0x1a0/0x1b0 [btrfs]
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffffc02aa218>]
end_bio_extent_readpage+0x2d8/0x3d0 [btrfs]
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff8137b2c3>]
bio_endio+0x53/0xa0
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff8137b322>]
bio_endio_nodec+0x12/0x20
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffffc0280fb8>]
end_workqueue_fn+0x48/0x60 [btrfs]
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffffc02bab2e>]
normal_work_helper+0x7e/0x1b0 [btrfs]
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffffc02bad32>]
btrfs_endio_helper+0x12/0x20 [btrfs]
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff81092204>]
process_one_work+0x144/0x490
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff81092c6e>]
worker_thread+0x11e/0x450
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff81092b50>] ?
create_worker+0x1f0/0x1f0
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff81098999>]
kthread+0xc9/0xe0
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff810988d0>] ?
flush_kthread_worker+0x90/0x90
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff817f08d8>]
ret_from_fork+0x58/0x90
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  [<ffffffff810988d0>] ?
flush_kthread_worker+0x90/0x90
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: Code: 44 00 00 4c 89 ef
e8 b0 14 0d c1 31 f6 4c 89 e7 e8 06 05 01 00 ba fb ff ff ff e9 c7 fe
ff ff ba fb ff ff ff e9 bd fe ff ff 0f 0b <0f> 0b 49 8b 4c 24 30 48 8b
b3 58 fe ff ff 48 83 c1 10 48 85 f6
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: RIP  [<ffffffffc02a9d50>]
repair_io_failure+0x1c0/0x200 [btrfs]
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel:  RSP <ffff880449b1fbb8>
Jun 17 12:08:35 srv-lab-ceph-node-01 kernel: ---[ end trace
90ec36112ab1f744 ]---

P.S. I just think about case where i have 2 slots for disk in server,
and i want replace one disk, which failed (overheated and just
'burned' or something else) without server downtime
-- 
Have a nice day,
Timofey.
