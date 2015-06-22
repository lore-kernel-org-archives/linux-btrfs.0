Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33215 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbbFVLq3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 07:46:29 -0400
Received: by wiwl6 with SMTP id l6so34460419wiw.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 04:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi757StwNda-8y-zvjB-8cVrWLd=R8xuZnvzdwhhmxbTuXw@mail.gmail.com>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
 <CAJCQCtQFyCEn3kdeYOrOyk_vqekNH_MiOyA=WSOxLCoQS6PV1w@mail.gmail.com>
 <CAGqmi75OK8ofM7p0SqUsy8WhW3ZveQ_3NMtQCAchmHnUP7KoPg@mail.gmail.com> <CAGqmi757StwNda-8y-zvjB-8cVrWLd=R8xuZnvzdwhhmxbTuXw@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 22 Jun 2015 14:45:48 +0300
Message-ID: <CAGqmi77RmK-44oheSEbd8Jwk4RfKhJLerOmLubk6YV27stbhsw@mail.gmail.com>
Subject: Re: RAID1: system stability
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And again if i've try
echo 1 > /sys/block/sdf/device/delete

Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: ------------[ cut here
]------------
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: kernel BUG at
/build/buildd/linux-3.19.0/fs/btrfs/extent_io.c:2056!
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: invalid opcode: 0000 [#1] SMP
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: Modules linked in: 8021q
garp mrp stp llc binfmt_misc ipmi_ssif amdkfd amd_iommu_v2 gpio_ich
radeon ttm drm_kms_helper lpc_ich coretemp drm kvm_intel kvm
i5000_edac i2c_algo_bit edac_core i5k_amb shpchp ipmi_si serio_raw
8250_fintek ioatdma dca joydev mac_hid ipmi_msghandler bonding autofs4
btrfs ses enclosure raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq hid_generic raid1 e1000e
raid0 usbhid mptsas mptscsih multipath psmouse hid mptbase ptp
scsi_transport_sas pps_core linear
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: CPU: 0 PID: 1150 Comm:
kworker/u16:12 Not tainted 3.19.0-21-generic #21-Ubuntu
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: Hardware name: Intel
S5000VSA/S5000VSA, BIOS S5000.86B.15.00.0101.110920101604 11/09/2010
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: Workqueue: btrfs-endio
btrfs_endio_helper [btrfs]
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: task: ffff88044c603110
ti: ffff88044b4b8000 task.ti: ffff88044b4b8000
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: RIP:
0010:[<ffffffffc043fa80>]  [<ffffffffc043fa80>]
repair_io_failure+0x1a0/0x220 [btrfs]
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: RSP:
0018:ffff88044b4bbba8  EFLAGS: 00010202
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: RAX: 0000000000000000
RBX: 0000000000001000 RCX: 0000000000000000
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: RDX: 0000000000000000
RSI: ffff880449841b08 RDI: ffff880449841a80
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: RBP: ffff88044b4bbc08
R08: 0000000000109000 R09: ffff880449841a80
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: R10: 0000000000009000
R11: 0000000000000002 R12: ffff8803fa878068
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: R13: ffff880448f5d000
R14: ffff88044cde8d28 R15: 0000000524f09000
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: FS:
0000000000000000(0000) GS:ffff88045fc00000(0000)
knlGS:0000000000000000
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: CR2: 00007fdcef9cafb8
CR3: 0000000001c13000 CR4: 00000000000407f0
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: Stack:
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  ffff880448f5d100
0000000000001000 000000004b4bbbd8 ffffea000fb66d40
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  0000000000007000
ffff880449841a80 ffff88044b4bbc08 ffff880439a44b58
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  0000000000001000
ffff880448f5d000 ffff88044cde8d28 ffff88044cde8bf0
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: Call Trace:
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffffc043fd7c>]
clean_io_failure+0x19c/0x1b0 [btrfs]
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffffc04401b0>]
end_bio_extent_readpage+0x310/0x5e0 [btrfs]
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff811d5795>] ?
__slab_free+0xa5/0x320
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff8101e74a>] ?
native_sched_clock+0x2a/0x90
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff8137f1eb>]
bio_endio+0x6b/0xa0
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff811d5bce>] ?
kmem_cache_free+0x1be/0x200
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff8137f232>]
bio_endio_nodec+0x12/0x20
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffffc0414f3f>]
end_workqueue_fn+0x3f/0x50 [btrfs]
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffffc044f4e2>]
normal_work_helper+0xc2/0x2b0 [btrfs]
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffffc044f7a2>]
btrfs_endio_helper+0x12/0x20 [btrfs]
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff8108fc98>]
process_one_work+0x158/0x430
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff810907db>]
worker_thread+0x5b/0x530
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff81090780>] ?
rescuer_thread+0x3a0/0x3a0
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff81095879>]
kthread+0xc9/0xe0
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff810957b0>] ?
kthread_create_on_node+0x1c0/0x1c0
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff817cae18>]
ret_from_fork+0x58/0x90
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  [<ffffffff810957b0>] ?
kthread_create_on_node+0x1c0/0x1c0
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: Code: f4 fe ff ff 0f 1f
80 00 00 00 00 0f 0b 66 0f 1f 44 00 00 4c 89 e7 e8 e0 e4 f3 c0 41 b9
fb ff ff ff e9 d2 fe ff ff 0f 1f 44 00 00 <0f> 0b 66 0f 1f 44 00 00 4c
89 e7 e8 c0 e4 f3 c0 31 f6 4c 89 ef
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel: RIP  [<ffffffffc043fa80>]
repair_io_failure+0x1a0/0x220 [btrfs]
Jun 22 14:44:16 srv-lab-ceph-node-01 kernel:  RSP <ffff88044b4bbba8>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
