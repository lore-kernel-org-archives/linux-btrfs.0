Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33198 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753450AbcJIDVK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Oct 2016 23:21:10 -0400
Received: by mail-qk0-f182.google.com with SMTP id n189so73715750qke.0
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Oct 2016 20:20:31 -0700 (PDT)
Received: from [192.168.69.106] (cpe-142-105-3-123.nyc.res.rr.com. [142.105.3.123])
        by smtp.gmail.com with ESMTPSA id a94sm9514693qkh.11.2016.10.08.20.20.27
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Oct 2016 20:20:28 -0700 (PDT)
From: Asif Youssuff <yoasif@gmail.com>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.0 \(3226\))
Subject: kernel BUG at /build/linux-R0TiM8/linux-4.4.0/fs/btrfs/volumes.c:5509
Message-Id: <DCA900EE-E823-4000-A6EF-43DA73AC29DA@gmail.com>
Date: Sat, 8 Oct 2016 23:20:26 -0400
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

I have a raid10 array that occasionally causes the kernel to write kernel bug messages and to take down the router that this machine is plugged into. 

It’s a pretty standard install of Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-38-generic x86_64); the only kernel taint is the ZFS on Linux package that is in available in the Ubuntu repos. 

Mount options are: noatime,compress-force=lzo,space_cache

Please let me know if I can provide additional information to help. The issue is logged on bugzilla at:

	https://bugzilla.kernel.org/show_bug.cgi?id=177081

dmesg output follows:

[89563.409316] ------------[ cut here ]------------
[89563.409829] kernel BUG at /build/linux-R0TiM8/linux-4.4.0/fs/btrfs/volumes.c:5509!
[89563.410339] invalid opcode: 0000 [#1] SMP
[89563.410830] Modules linked in: xt_mark xt_nat veth xt_addrtype br_netfilter aufs xt_conntrack ipt_REJECT nf_reject_ipv4 ebtable_filter ebtables ip6table_filter ip6_tables xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack xt_tcpudp bridge stp llc iptable_filter ip_tables x_tables zram lz4_compress binfmt_misc zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zavl(PO) drbg ansi_cprng dm_crypt ipmi_ssif intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd joydev input_leds mei_me lpc_ich mei ipmi_si 8250_fintek ipmi_msghandler mac_hid ie31200_edac shpchp tpm_crb edac_core acpi_pad kvm_intel kvm irqbypass autofs4
[89563.414092]  btrfs xor raid6_pq hid_generic usbhid hid uas ast usb_storage ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops igb e1000e dca ahci drm ptp mpt3sas libahci i2c_algo_bit raid_class pps_core scsi_transport_sas fjes video
[89563.415809] CPU: 6 PID: 12096 Comm: kworker/u16:10 Tainted: P           O    4.4.0-38-generic #57-Ubuntu
[89563.416401] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 04/24/2015
[89563.417007] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[89563.417596] task: ffff8803eb148dc0 ti: ffff88014e874000 task.ti: ffff88014e874000
[89563.418191] RIP: 0010:[<ffffffffc0315e56>]  [<ffffffffc0315e56>] __btrfs_map_block+0xe26/0x1180 [btrfs]
[89563.418806] RSP: 0018:ffff88014e877a88  EFLAGS: 00010296
[89563.419403] RAX: 00000000dd213b80 RBX: 0000000000000008 RCX: 0000000000000008
[89563.420012] RDX: 0000000000000002 RSI: 0000000000007000 RDI: 0000000000000002
[89563.420609] RBP: ffff88014e877b70 R08: 00007e1b47c00000 R09: 00000000dd213b80
[89563.421206] R10: 0000000000010000 R11: 00000000dfef0000 R12: 00000000dd213b83
[89563.421797] R13: 0000000000009000 R14: ffff88014e877bb0 R15: 0000000000000000
[89563.422387] FS:  0000000000000000(0000) GS:ffff88081fd80000(0000) knlGS:0000000000000000
[89563.422976] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[89563.423560] CR2: 00007fc361432000 CR3: 0000000001e0a000 CR4: 00000000001406e0
[89563.424154] Stack:
[89563.424737]  ffff8807fb42cc28 ffff88014e877ab8 ffff88014e877a88 0000000000000000
[89563.425333]  ffff88014e877b20 ffffffffc02b8e0d 0000000000000000 000000000000dfef
[89563.425924]  00000000000037fb ffff8807fb430ee0 ffff880100000000 0000000000000000
[89563.426532] Call Trace:
[89563.427136]  [<ffffffffc02b8e0d>] ? btrfs_printk+0x8d/0xf0 [btrfs]
[89563.427740]  [<ffffffffc0316722>] btrfs_map_bio+0x82/0x320 [btrfs]
[89563.428328]  [<ffffffff811ebe4f>] ? kmem_cache_alloc+0x19f/0x1f0
[89563.428944]  [<ffffffffc02e1a98>] ? btrfs_bio_wq_end_io+0x28/0x70 [btrfs]
[89563.429539]  [<ffffffffc0333709>] btrfs_submit_compressed_read+0x319/0x4c0 [btrfs]
[89563.430137]  [<ffffffffc02eaf81>] btrfs_submit_bio_hook+0x1a1/0x1b0 [btrfs]
[89563.430727]  [<ffffffffc03098dc>] ? btrfs_create_repair_bio+0xdc/0x100 [btrfs]
[89563.431320]  [<ffffffffc0309db7>] end_bio_extent_readpage+0x4b7/0x5b0 [btrfs]
[89563.431910]  [<ffffffffc0309900>] ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[89563.432493]  [<ffffffff813bb0df>] bio_endio+0x3f/0x60
[89563.433059]  [<ffffffffc02df3bc>] end_workqueue_fn+0x3c/0x40 [btrfs]
[89563.433628]  [<ffffffffc031ae9a>] btrfs_scrubparity_helper+0xca/0x2f0 [btrfs]
[89563.434199]  [<ffffffffc031b1ae>] btrfs_endio_helper+0xe/0x10 [btrfs]
[89563.434758]  [<ffffffff8109a395>] process_one_work+0x165/0x480
[89563.435312]  [<ffffffff8109a6fb>] worker_thread+0x4b/0x4c0
[89563.435864]  [<ffffffff8109a6b0>] ? process_one_work+0x480/0x480
[89563.436413]  [<ffffffff810a08d8>] kthread+0xd8/0xf0
[89563.436980]  [<ffffffff810a0800>] ? kthread_create_on_node+0x1e0/0x1e0
[89563.437526]  [<ffffffff81830a8f>] ret_from_fork+0x3f/0x70
[89563.438067]  [<ffffffff810a0800>] ? kthread_create_on_node+0x1e0/0x1e0
[89563.438600] Code: 40 ff ff ff 4c 8b 95 38 ff ff ff 48 89 85 58 ff ff ff e9 fe f3 ff ff f7 c7 00 01 00 00 b8 02 00 00 00 44 0f 45 d0 e9 f6 f8 ff ff <0f> 0b bb f4 ff ff ff e9 b7 fa ff ff be 6a 16 00 00 48 c7 c7 e0
[89563.439700] RIP  [<ffffffffc0315e56>] __btrfs_map_block+0xe26/0x1180 [btrfs]
[89563.440233]  RSP <ffff88014e877a88>
[89563.442706] ---[ end trace d34ac9264111b8fa ]—

Thanks!