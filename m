Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34457 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223AbbFVLgD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 07:36:03 -0400
Received: by wgqq4 with SMTP id q4so13793059wgq.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 04:36:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi75OK8ofM7p0SqUsy8WhW3ZveQ_3NMtQCAchmHnUP7KoPg@mail.gmail.com>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
 <CAJCQCtQFyCEn3kdeYOrOyk_vqekNH_MiOyA=WSOxLCoQS6PV1w@mail.gmail.com> <CAGqmi75OK8ofM7p0SqUsy8WhW3ZveQ_3NMtQCAchmHnUP7KoPg@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 22 Jun 2015 14:35:22 +0300
Message-ID: <CAGqmi757StwNda-8y-zvjB-8cVrWLd=R8xuZnvzdwhhmxbTuXw@mail.gmail.com>
Subject: Re: RAID1: system stability
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, logs, i did release disk /dev/sde1 and get:
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
00 00 00 08 00
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
error, dev sde, sector 287140096
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
SubCode(0x0011) cb_idx mptscsih_io_done
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] FAILED
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] CDB:
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
00 00 00 08 00
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
error, dev sde, sector 287140096
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Buffer I/O error on dev
sde1, logical block 35892256, async page read
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
SubCode(0x0011) cb_idx mptscsih_io_done
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
SubCode(0x0011) cb_idx mptscsih_io_done
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] FAILED
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] CDB:
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
00 00 00 08 00
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
error, dev sde, sector 287140096
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Buffer I/O error on dev
sde1, logical block 35892256, async page read
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
SubCode(0x0011) cb_idx mptscsih_io_done
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
SubCode(0x0011) cb_idx mptscsih_io_done
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] FAILED
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] CDB:
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
00 00 00 08 00
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
error, dev sde, sector 287140096
Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Buffer I/O error on dev
sde1, logical block 35892256, async page read
Jun 22 14:28:41 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
SubCode(0x0011) cb_idx mptscsih_io_done
Jun 22 14:28:41 srv-lab-ceph-node-01 kernel:  end_device-0:0:6:
mptsas: ioc0: removing ssp device: fw_channel 0, fw_id 16, phy
5,sas_addr 0x5000cca00d0514bd
Jun 22 14:28:41 srv-lab-ceph-node-01 kernel:  phy-0:0:9: mptsas: ioc0:
delete phy 5, phy-obj (0xffff880449541400)
Jun 22 14:28:41 srv-lab-ceph-node-01 kernel:  port-0:0:6: mptsas:
ioc0: delete port 6, sas_addr (0x5000cca00d0514bd)
Jun 22 14:28:41 srv-lab-ceph-node-01 kernel: scsi target0:0:5: mptsas:
ioc0: delete device: fw_channel 0, fw_id 16, phy 5, sas_addr
0x5000cca00d0514bd
Jun 22 14:28:44 srv-lab-ceph-node-01 kernel: BTRFS: lost page write
due to I/O error on /dev/sde1
Jun 22 14:28:44 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:28:44 srv-lab-ceph-node-01 kernel: BTRFS: lost page write
due to I/O error on /dev/sde1
Jun 22 14:28:44 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 11, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 12, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
errs: wr 13, rd 0, flush 0, corrupt 0, gen 0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: BTRFS info (device
md127): csum failed ino 1039 extent 390332416 csum 2059524288 wanted
343582415 mirror 0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: BUG: unable to handle
kernel paging request at ffff87fa7ff53430
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: IP: [<ffffffffc04709d9>]
__btrfs_map_block+0x2d9/0x1180 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: PGD 0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: Oops: 0000 [#1] SMP
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: Modules linked in: 8021q
garp mrp stp llc binfmt_misc amdkfd amd_iommu_v2 radeon ttm
drm_kms_helper ipmi_ssif coretemp gpio_ich drm kvm_intel serio_raw
i5000_edac kvm ipmi_si lpc_ich edac_core ioatdma joydev i2c_algo_bit
8250_fintek mac_hid ipmi_msghandler i5k_amb dca shpchp bonding autofs4
btrfs ses enclosure raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx mptsas mptscsih xor hid_generic raid6_pq
raid1 usbhid e1000e mptbase raid0 psmouse ptp hid multipath
scsi_transport_sas pps_core linear
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: CPU: 1 PID: 2411 Comm:
kworker/u16:16 Not tainted 3.19.0-21-generic #21-Ubuntu
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: Hardware name: Intel
S5000VSA/S5000VSA, BIOS S5000.86B.15.00.0101.110920101604 11/09/2010
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: Workqueue: btrfs-endio
btrfs_endio_helper [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: task: ffff8803ef8ae220
ti: ffff8803efbe4000 task.ti: ffff8803efbe4000
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: RIP:
0010:[<ffffffffc04709d9>]  [<ffffffffc04709d9>]
__btrfs_map_block+0x2d9/0x1180 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: RSP:
0018:ffff8803efbe79d8  EFLAGS: 00010287
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: RAX: 0000000000010000
RBX: ffff88009a80dd00 RCX: 0000000000001533
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: RDX: ffff87fa7ff53428
RSI: ffff88009a80dd70 RDI: 000000009a869e00
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: RBP: ffff8803efbe7ab8
R08: 000000000000c000 R09: ffff88009a80dd00
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: R10: 000000000000c000
R11: 0000000000000002 R12: 000000009a869e00
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: R13: ffff880403566420
R14: ffff880448e20000 R15: 0000000000000001
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: FS:
0000000000000000(0000) GS:ffff88045fc40000(0000)
knlGS:0000000000000000
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: CR2: ffff87fa7ff53430
CR3: 000000034f878000 CR4: 00000000000407e0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: Stack:
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  0000000000000000
0000000000001000 ffff8803efbe7a28 000000000000c000
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  0000000000000001
0000000000010000 0000000015340000 0000000000000000
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  0000000000001534
0000000000001533 ffff880448e20dd0 0000000000000000
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: Call Trace:
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc0420afa>] ?
btrfs_free_path+0x2a/0x40 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc0476b5d>]
btrfs_map_bio+0x7d/0x530 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc0493982>]
btrfs_submit_compressed_read+0x332/0x4d0 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc044df51>]
btrfs_submit_bio_hook+0x1c1/0x1d0 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff8137cc6e>] ?
bio_add_page+0x5e/0x70
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc046be79>] ?
btrfs_create_repair_bio+0xe9/0x110 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc046c38a>]
end_bio_extent_readpage+0x4ea/0x5e0 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc046bea0>] ?
btrfs_create_repair_bio+0x110/0x110 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff8137f1eb>]
bio_endio+0x6b/0xa0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff811d5bce>] ?
kmem_cache_free+0x1be/0x200
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff8137f232>]
bio_endio_nodec+0x12/0x20
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc0440f3f>]
end_workqueue_fn+0x3f/0x50 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc047b4e2>]
normal_work_helper+0xc2/0x2b0 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffffc047b7a2>]
btrfs_endio_helper+0x12/0x20 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff8108fc98>]
process_one_work+0x158/0x430
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff810907db>]
worker_thread+0x5b/0x530
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff81090780>] ?
rescuer_thread+0x3a0/0x3a0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff81095879>]
kthread+0xc9/0xe0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff810957b0>] ?
kthread_create_on_node+0x1c0/0x1c0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff817cae18>]
ret_from_fork+0x58/0x90
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  [<ffffffff810957b0>] ?
kthread_create_on_node+0x1c0/0x1c0
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: Code: 8d 68 ff ff ff 7e
3f 0f 1f 00 49 63 c4 4d 89 d0 41 83 c4 01 48 8d 04 40 48 83 c6 18 48
8d 14 c5 20 00 00 00 49 63 45 10 4c 01 ea <4c> 03 42 08 48 0f af c1 4c
01 c0 48 89 46 e8 48 8b 02 48 89 46
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: RIP  [<ffffffffc04709d9>]
__btrfs_map_block+0x2d9/0x1180 [btrfs]
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel:  RSP <ffff8803efbe79d8>
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: CR2: ffff87fa7ff53430
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: ---[ end trace
f8af5955ebefcf19 ]---
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: BUG: unable to handle
kernel paging request at ffffffffffffffd8
Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: IP: [<ffffffff81095f80>]
kthread_data+0x10/0x20

-- 
Have a nice day,
Timofey.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
