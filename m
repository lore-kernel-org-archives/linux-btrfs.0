Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49045C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 23:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 028A3218D3
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 23:30:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ip7f5Jme"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfCVXao (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 19:30:44 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46670 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfCVXan (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 19:30:43 -0400
Received: by mail-oi1-f196.google.com with SMTP id x188so2966232oia.13
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2019 16:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GAxxWTLZXUabxpBuWoaR7m2kV2iHhVtwz1Gj8WD1joo=;
        b=Ip7f5JmeizzdTkW3jtwv4d6DbA/Ar3ZXCPsROBGxqCRy8OAGy6KNvtwEwebY4oqJct
         u9xLZfh/tx0HreQFf7DYu7p5dos3iUlltqLZh9qGJ8eNPOwyh1ISAT69JjfQQ9tdBaEr
         s6/lIWLoWpzV+38QMyt7MXBcWkMaS+hK0ALaJxp3S7Org260L8mE4HYuePeyeBUeZz/r
         FQLve9smk7ISYEysJdSIWsn009XH+xC8XAwWcKLNMk9vfBJiSQXiqE/Er3Gv95w0LzBz
         eLMAN6A8zK4vdTZtAa4kxqa2stf5xmtUJu9MqSLmtRrYnn/mk4iFHWr/Kk3Pm0gH8vxq
         Neaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GAxxWTLZXUabxpBuWoaR7m2kV2iHhVtwz1Gj8WD1joo=;
        b=G1lxrb0p+hi92mwQqkb5USHQjdBsK9BvTihXbm/lGiPHKnO+LWBrX6DVzVtAtP7IGE
         q3bC2pb2wy83JX6sJdE4mgWqZE5M5Z//WjFYPJ739GnZSP882Y9+hajvBniPOFIWxQX4
         BzP83cPsXsGfU1+CGB1g20WujF6T1ahVtPAQ2GkCStTHFQfQN8co58JlZ93q1XrmbLKG
         vnsG5V54id4DnN/kHNlqab+byICLZq9sVQ8NZnY+mf30zcVv5ZW7QVQPvg3e6YymPkcp
         LRqqgah0a9GYXS/IzyP9MViJwOPcPZyuGe/+FBHTvq/JhTGcGmWRjRKE5xm4AbdWSkGW
         JwUg==
X-Gm-Message-State: APjAAAW6g/n132Ebs+SbZF7RWV3gpBDNpUKwnwh6bYoSpgMPfLCOZIsf
        MVbDmb8kEPviTOlMjJZGdKTHiGZGyFxQIPtY0YlndG3+k/0=
X-Google-Smtp-Source: APXvYqwb5Zy6lnR/fQuo99lPbY9QkmJIRPWf6qwkTG+muFvqt9S6LWEjbvZYKRzXOZ/yL/eoI70cFqwQuHLvqZ2ssXM=
X-Received: by 2002:aca:eb55:: with SMTP id j82mr2997002oih.178.1553297442278;
 Fri, 22 Mar 2019 16:30:42 -0700 (PDT)
MIME-Version: 1.0
From:   Jan Alexander Steffens <jan.steffens@gmail.com>
Date:   Sat, 23 Mar 2019 00:30:31 +0100
Message-ID: <CAMQ-g0dAT1Fa_RZuDmGVk-9ZgHERx1XdrfZ46UFJxYSbNFkX=w@mail.gmail.com>
Subject: btrfs-cleaner crashes freeing delayed node (5.0.3)
To:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

we have a build server here that accumulated lots of uncleaned subvolumes.
Snapshots containing build roots are frequently created and destroyed.
There's also a borg backup script which creates and destroys a
snapshot of the root subvolume.
We noticed this only after a reboot for a kernel upgrade, after which
the cleaner almost ground the system to a halt.

The server has a single RAID1 btrfs covering two unpartitioned HDDs.

After letting the cleaner do its job, I started some balance
operations (the same as in
https://github.com/kdave/btrfsmaintenance/blob/master/btrfs-balance.sh).
During these operation, btrfs raised two warnings:

Mar 22 12:52:04 soyuz kernel: WARNING: CPU: 0 PID: 21260 at
fs/btrfs/relocation.c:4298 btrfs_relocate_block_group+0x1ee/0x210
[btrfs]
Mar 22 12:52:04 soyuz kernel: Modules linked in: lz4 lz4_compress zram
tcp_diag inet_diag devlink nf_tables_set nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nft_ct nft_chain_nat_ipv6 nft_chain_nat_ipv4 nf_tables
ip6table_nat nf_nat_ipv6 ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat_ipv4 nf_nat iptable_mangle
iptable_raw iptable_security nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nfnetlink ip6table_filter ip6_tables
iptable_filter intel_rapl x86_pkg_temp_thermal intel_powerclamp i915
coretemp kvm_intel kvmgt vfio_mdev mdev vfio_iommu_type1 vfio kvm
crct10dif_pclmul crc32_pclmul irqbypass ghash_clmulni_intel
i2c_algo_bit aesni_intel drm_kms_helper aes_x86_64 drm crypto_simd
cryptd intel_gtt agpgart glue_helper e1000e syscopyarea sysfillrect
sysimgblt fb_sys_fops ppdev parport_pc psmouse intel_cstate mei_wdt
evdev pcspkr mei_me parport iTCO_wdt intel_uncore iTCO_vendor_support
mei pcc_cpufreq intel_rapl_perf i2c_i801 wmi
Mar 22 12:52:04 soyuz kernel: intel_pch_thermal mac_hid ie31200_edac
vboxnetflt(OE) vboxnetadp(OE) vboxpci(OE) vboxdrv(OE) ip_tables
x_tables btrfs libcrc32c crc32c_generic xor raid6_pq sd_mod serio_raw
atkbd libps2 ahci libahci libata xhci_pci scsi_mod xhci_hcd
crc32c_intel i8042 serio
Mar 22 12:52:04 soyuz kernel: CPU: 0 PID: 21260 Comm: btrfs Tainted: G
OE 5.0.3-arch1-1-ARCH #1
Mar 22 12:52:04 soyuz kernel: Hardware name: FUJITSU /D3417-B2, BIOS
V5.0.0.12 R1.8.0.SR.1 for D3417-B2x 05/16/2017
Mar 22 12:52:04 soyuz kernel: RIP:
0010:btrfs_relocate_block_group+0x1ee/0x210 [btrfs]
Mar 22 12:52:04 soyuz kernel: Code: 10 0f 84 99 fe ff ff 0f 0b e9 92
fe ff ff 48 89 ef bd e6 ff ff ff e8 b1 70 f8 ff e9 95 fe ff ff bd fe
ff ff ff e9 8b fe ff ff <0f> 0b eb ca 0f 0b eb bf 48 89 ef bd f4 ff ff
ff e8 8d 70 f8 ff e9
Mar 22 12:52:04 soyuz kernel: RSP: 0018:ffffa56fc745fbd8 EFLAGS: 00010206
Mar 22 12:52:04 soyuz kernel: RAX: ffff96c261d28c00 RBX:
ffff96bbb1770800 RCX: 0000000000000000
Mar 22 12:52:04 soyuz kernel: RDX: 0000000000000000 RSI:
ffff96b398c228c0 RDI: ffff96c267390388
Mar 22 12:52:04 soyuz kernel: RBP: 0000000000000000 R08:
0000000000000001 R09: ffffffffc04809be
Mar 22 12:52:04 soyuz kernel: R10: ffffd9e5b6393b80 R11:
0000000000000000 R12: ffff96c267390000
Mar 22 12:52:04 soyuz kernel: R13: 0000000000000000 R14:
ffff96c267390388 R15: ffffffffc04bd9f9
Mar 22 12:52:04 soyuz kernel: FS: 00007f0a8b8a78c0(0000)
GS:ffff96c26e200000(0000) knlGS:0000000000000000
Mar 22 12:52:04 soyuz kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 22 12:52:04 soyuz kernel: CR2: 00007f5ea6544130 CR3:
0000000107ff8003 CR4: 00000000003606f0
Mar 22 12:52:04 soyuz kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Mar 22 12:52:04 soyuz kernel: DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Mar 22 12:52:04 soyuz kernel: Call Trace:
Mar 22 12:52:04 soyuz kernel: btrfs_relocate_chunk+0x31/0xa0 [btrfs]
Mar 22 12:52:04 soyuz kernel: btrfs_balance+0x7b3/0xf00 [btrfs]
Mar 22 12:52:04 soyuz kernel: ? mem_cgroup_event_ratelimit.isra.11+0x36/0xa0
Mar 22 12:52:04 soyuz kernel: btrfs_ioctl_balance+0x36a/0x380 [btrfs]
Mar 22 12:52:04 soyuz kernel: ? mem_cgroup_commit_charge+0x7a/0x4d0
Mar 22 12:52:04 soyuz kernel: btrfs_ioctl+0x1559/0x2ce0 [btrfs]
Mar 22 12:52:04 soyuz kernel: ? __lru_cache_add+0x75/0xa0
Mar 22 12:52:04 soyuz kernel: ? _raw_spin_unlock+0x16/0x30
Mar 22 12:52:04 soyuz kernel: ? __handle_mm_fault+0x96b/0x1610
Mar 22 12:52:04 soyuz kernel: ? do_vfs_ioctl+0xa4/0x630
Mar 22 12:52:04 soyuz kernel: do_vfs_ioctl+0xa4/0x630
Mar 22 12:52:04 soyuz kernel: ? handle_mm_fault+0x10a/0x250
Mar 22 12:52:04 soyuz kernel: ? syscall_trace_enter+0x1d3/0x2d0
Mar 22 12:52:04 soyuz kernel: ksys_ioctl+0x60/0x90
Mar 22 12:52:04 soyuz kernel: __x64_sys_ioctl+0x16/0x20
Mar 22 12:52:04 soyuz kernel: do_syscall_64+0x5b/0x170
Mar 22 12:52:04 soyuz kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
Mar 22 12:52:04 soyuz kernel: RIP: 0033:0x7f0a8b99c80b
Mar 22 12:52:04 soyuz kernel: Code: 0f 1e fa 48 8b 05 55 b6 0c 00 64
c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e
fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 25 b6 0c
00 f7 d8 64 89 01 48
Mar 22 12:52:04 soyuz kernel: RSP: 002b:00007fff74b566d8 EFLAGS:
00000246 ORIG_RAX: 0000000000000010
Mar 22 12:52:04 soyuz kernel: RAX: ffffffffffffffda RBX:
0000000000000001 RCX: 00007f0a8b99c80b
Mar 22 12:52:04 soyuz kernel: RDX: 00007fff74b56770 RSI:
00000000c4009420 RDI: 0000000000000003
Mar 22 12:52:04 soyuz kernel: RBP: 0000000000000003 R08:
0000000000000003 R09: 0000000000000078
Mar 22 12:52:04 soyuz kernel: R10: 0000557f128d5010 R11:
0000000000000246 R12: 00007fff74b57108
Mar 22 12:52:04 soyuz kernel: R13: 0000000000000001 R14:
00007fff74b56770 R15: 00007fff74b5775c
Mar 22 12:52:04 soyuz kernel: ---[ end trace 43e4e47e6a74df08 ]---

and

Mar 22 12:52:04 soyuz kernel: WARNING: CPU: 5 PID: 305 at
fs/btrfs/extent-tree.c:125 btrfs_put_block_group+0x4b/0x50 [btrfs]
Mar 22 12:52:04 soyuz kernel: Modules linked in: lz4 lz4_compress zram
tcp_diag inet_diag devlink nf_tables_set nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nft_ct nft_chain_nat_ipv6 nft_chain_nat_ipv4 nf_tables
ip6table_nat nf_nat_ipv6 ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat_ipv4 nf_nat iptable_mangle
iptable_raw iptable_security nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nfnetlink ip6table_filter ip6_tables
iptable_filter intel_rapl x86_pkg_temp_thermal intel_powerclamp i915
coretemp kvm_intel kvmgt vfio_mdev mdev vfio_iommu_type1 vfio kvm
crct10dif_pclmul crc32_pclmul irqbypass ghash_clmulni_intel
i2c_algo_bit aesni_intel drm_kms_helper aes_x86_64 drm crypto_simd
cryptd intel_gtt agpgart glue_helper e1000e syscopyarea sysfillrect
sysimgblt fb_sys_fops ppdev parport_pc psmouse intel_cstate mei_wdt
evdev pcspkr mei_me parport iTCO_wdt intel_uncore iTCO_vendor_support
mei pcc_cpufreq intel_rapl_perf i2c_i801 wmi
Mar 22 12:52:04 soyuz kernel: intel_pch_thermal mac_hid ie31200_edac
vboxnetflt(OE) vboxnetadp(OE) vboxpci(OE) vboxdrv(OE) ip_tables
x_tables btrfs libcrc32c crc32c_generic xor raid6_pq sd_mod serio_raw
atkbd libps2 ahci libahci libata xhci_pci scsi_mod xhci_hcd
crc32c_intel i8042 serio
Mar 22 12:52:04 soyuz kernel: CPU: 5 PID: 305 Comm: btrfs-cleaner
Tainted: G W OE 5.0.3-arch1-1-ARCH #1
Mar 22 12:52:04 soyuz kernel: Hardware name: FUJITSU /D3417-B2, BIOS
V5.0.0.12 R1.8.0.SR.1 for D3417-B2x 05/16/2017
Mar 22 12:52:04 soyuz kernel: RIP: 0010:btrfs_put_block_group+0x4b/0x50 [btrfs]
Mar 22 12:52:04 soyuz kernel: Code: 01 00 00 48 85 c0 75 1e 48 89 fb
48 8b bf d8 00 00 00 e8 88 6b 24 e7 48 89 df 5b e9 7f 6b 24 e7 5b c3
0f 0b eb cf 0f 0b eb de <0f> 0b eb ce 90 0f 1f 44 00 00 41 55 41 54 4c
8d a7 80 00 00 00 55
Mar 22 12:52:04 soyuz kernel: RSP: 0018:ffffa56fc7157e58 EFLAGS: 00010206
Mar 22 12:52:04 soyuz kernel: RAX: ffff96c262e30000 RBX:
ffff96c261d28d20 RCX: 0000000000000000
Mar 22 12:52:04 soyuz kernel: RDX: ffff96c262e30000 RSI:
ffffffffa84aa890 RDI: ffff96c261d28c00
Mar 22 12:52:04 soyuz kernel: RBP: ffff96c261d28c00 R08:
0000000000000000 R09: ffffa56fc7157dd8
Mar 22 12:52:04 soyuz kernel: R10: 0000000000000000 R11:
0000000000001000 R12: ffff96c263cf9c00
Mar 22 12:52:04 soyuz kernel: R13: ffff96c261d28c40 R14:
ffff96c263cf9cd0 R15: ffff96c267390000
Mar 22 12:52:04 soyuz kernel: FS: 0000000000000000(0000)
GS:ffff96c26e340000(0000) knlGS:0000000000000000
Mar 22 12:52:04 soyuz kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 22 12:52:04 soyuz kernel: CR2: 00007fd0501117a0 CR3:
000000066340e005 CR4: 00000000003606e0
Mar 22 12:52:04 soyuz kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Mar 22 12:52:04 soyuz kernel: DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Mar 22 12:52:04 soyuz kernel: Call Trace:
Mar 22 12:52:04 soyuz kernel: btrfs_delete_unused_bgs+0x2ff/0x460 [btrfs]
Mar 22 12:52:04 soyuz kernel: ? preempt_count_add+0x79/0xb0
Mar 22 12:52:04 soyuz kernel: ? btrfs_destroy_pinned_extent+0x110/0x110 [btrfs]
Mar 22 12:52:04 soyuz kernel: cleaner_kthread+0x128/0x130 [btrfs]
Mar 22 12:52:04 soyuz kernel: kthread+0x112/0x130
Mar 22 12:52:04 soyuz kernel: ? kthread_park+0x80/0x80
Mar 22 12:52:04 soyuz kernel: ret_from_fork+0x35/0x40
Mar 22 12:52:04 soyuz kernel: ---[ end trace 43e4e47e6a74df09 ]---

Later on, long after the balance operations finished, the
btrfs-cleaner thread crashed:

Mar 22 22:18:29 soyuz kernel: ------------[ cut here ]------------
Mar 22 22:18:29 soyuz kernel: kernel BUG at mm/slub.c:305!
Mar 22 22:18:29 soyuz kernel: invalid opcode: 0000 [#1] PREEMPT SMP PTI
Mar 22 22:18:31 soyuz kernel: CPU: 6 PID: 305 Comm: btrfs-cleaner
Tainted: G W OE 5.0.3-arch1-1-ARCH #1
Mar 22 22:18:31 soyuz kernel: Hardware name: FUJITSU /D3417-B2, BIOS
V5.0.0.12 R1.8.0.SR.1 for D3417-B2x 05/16/2017
Mar 22 22:18:31 soyuz kernel: RIP: 0010:__slab_free+0x1e4/0x380
Mar 22 22:18:31 soyuz kernel: Code: 4c 89 ff e8 7e d8 5f 00 48 8b 54
24 18 48 8b 74 24 20 48 89 04 24 e9 ba fe ff ff e8 e6 fb ff ff 85 c0
0f 85 56 fe ff ff eb ad <0f> 0b 48 89 54 24 08 48 89 74 24 10 48 89 4c
24 18 bf 01 00 00 00
Mar 22 22:18:31 soyuz kernel: RSP: 0000:ffffa56fc7157d70 EFLAGS: 00010246
Mar 22 22:18:31 soyuz kernel: RAX: ffff96b7c058f4b8 RBX:
ffff96b7c058f4b8 RCX: ffff96b7c058f4b8
Mar 22 22:18:31 soyuz kernel: RDX: 00000000001a000c RSI:
ffff96b7c058f4b8 RDI: ffff96c265ff2c00
Mar 22 22:18:31 soyuz kernel: RBP: ffffa56fc7157e08 R08:
0000000000000001 R09: ffffffffc0484831
Mar 22 22:18:31 soyuz kernel: R10: ffffa56fc7157de0 R11:
ffff96bc5e372be0 R12: ffffd9e595016380
Mar 22 22:18:31 soyuz kernel: R13: ffff96c265ff2c00 R14:
ffff96b7c058f4b8 R15: ffffa56fc7157e40
Mar 22 22:18:31 soyuz kernel: FS: 0000000000000000(0000)
GS:ffff96c26e380000(0000) knlGS:0000000000000000
Mar 22 22:18:31 soyuz kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 22 22:18:31 soyuz kernel: CR2: 00007fa6a0b331e0 CR3:
0000000ee3b60002 CR4: 00000000003606e0
Mar 22 22:18:31 soyuz kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Mar 22 22:18:31 soyuz kernel: DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Mar 22 22:18:31 soyuz kernel: Call Trace:
Mar 22 22:18:31 soyuz kernel: ? radix_tree_node_ctor+0x40/0x40
Mar 22 22:18:31 soyuz kernel: ? delete_node+0x37/0x1f0
Mar 22 22:18:31 soyuz kernel: ? radix_tree_delete_item+0x39/0xc0
Mar 22 22:18:31 soyuz kernel: kmem_cache_free+0x1d3/0x200
Mar 22 22:18:31 soyuz kernel: btrfs_kill_all_delayed_nodes+0xb1/0x100 [btrfs]
Mar 22 22:18:31 soyuz kernel: ? btrfs_destroy_pinned_extent+0x110/0x110 [btrfs]
Mar 22 22:18:31 soyuz kernel: btrfs_clean_one_deleted_snapshot+0x7c/0xf0 [btrfs]
Mar 22 22:18:31 soyuz kernel: cleaner_kthread+0x10d/0x130 [btrfs]
Mar 22 22:18:31 soyuz kernel: kthread+0x112/0x130
Mar 22 22:18:31 soyuz kernel: ? kthread_park+0x80/0x80
Mar 22 22:18:31 soyuz kernel: ret_from_fork+0x35/0x40
Mar 22 22:18:31 soyuz kernel: Modules linked in: lz4 lz4_compress zram
tcp_diag inet_diag devlink nf_tables_set nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nft_ct nft_chain_nat_ipv6 nft_chain_nat_ipv4 nf_tables
ip6table_nat nf_nat_ipv6 ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat_ipv4 nf_nat iptable_mangle
iptable_raw iptable_security nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nfnetlink ip6table_filter ip6_tables
iptable_filter intel_rapl x86_pkg_temp_thermal intel_powerclamp i915
coretemp kvm_intel kvmgt vfio_mdev mdev vfio_iommu_type1 vfio kvm
crct10dif_pclmul crc32_pclmul irqbypass ghash_clmulni_intel
i2c_algo_bit aesni_intel drm_kms_helper aes_x86_64 drm crypto_simd
cryptd intel_gtt agpgart glue_helper e1000e syscopyarea sysfillrect
sysimgblt fb_sys_fops ppdev parport_pc psmouse intel_cstate mei_wdt
evdev pcspkr mei_me parport iTCO_wdt intel_uncore iTCO_vendor_support
mei pcc_cpufreq intel_rapl_perf i2c_i801 wmi
Mar 22 22:18:31 soyuz kernel: intel_pch_thermal mac_hid ie31200_edac
vboxnetflt(OE) vboxnetadp(OE) vboxpci(OE) vboxdrv(OE) ip_tables
x_tables btrfs libcrc32c crc32c_generic xor raid6_pq sd_mod serio_raw
atkbd libps2 ahci libahci libata xhci_pci scsi_mod xhci_hcd
crc32c_intel i8042 serio
Mar 22 22:18:31 soyuz kernel: ---[ end trace 43e4e47e6a74df0a ]---
Mar 22 22:18:31 soyuz kernel: RIP: 0010:__slab_free+0x1e4/0x380
Mar 22 22:18:31 soyuz kernel: Code: 4c 89 ff e8 7e d8 5f 00 48 8b 54
24 18 48 8b 74 24 20 48 89 04 24 e9 ba fe ff ff e8 e6 fb ff ff 85 c0
0f 85 56 fe ff ff eb ad <0f> 0b 48 89 54 24 08 48 89 74 24 10 48 89 4c
24 18 bf 01 00 00 00
Mar 22 22:18:31 soyuz kernel: RSP: 0000:ffffa56fc7157d70 EFLAGS: 00010246
Mar 22 22:18:31 soyuz kernel: RAX: ffff96b7c058f4b8 RBX:
ffff96b7c058f4b8 RCX: ffff96b7c058f4b8
Mar 22 22:18:31 soyuz kernel: RDX: 00000000001a000c RSI:
ffff96b7c058f4b8 RDI: ffff96c265ff2c00
Mar 22 22:18:31 soyuz kernel: RBP: ffffa56fc7157e08 R08:
0000000000000001 R09: ffffffffc0484831
Mar 22 22:18:31 soyuz kernel: R10: ffffa56fc7157de0 R11:
ffff96bc5e372be0 R12: ffffd9e595016380
Mar 22 22:18:31 soyuz kernel: R13: ffff96c265ff2c00 R14:
ffff96b7c058f4b8 R15: ffffa56fc7157e40
Mar 22 22:18:31 soyuz kernel: FS: 0000000000000000(0000)
GS:ffff96c26e380000(0000) knlGS:0000000000000000
Mar 22 22:18:31 soyuz kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 22 22:18:31 soyuz kernel: CR2: 00007fa6a0b331e0 CR3:
0000000ee3b60002 CR4: 00000000003606e0
Mar 22 22:18:31 soyuz kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Mar 22 22:18:31 soyuz kernel: DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400

I'll reboot the system now to get the cleaner going again. Any suggestions?

Greetings,
Jan Steffens
Arch Linux
