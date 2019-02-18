Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843D5C4360F
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3270B21738
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOxUPEx2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbfBRVT3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:19:29 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:37172 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbfBRVT1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 16:19:27 -0500
Received: by mail-ot1-f45.google.com with SMTP id b3so30679155otp.4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 13:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ZmHOnawWtE/a5uwhRHoY82iUlZHav8oUH2GH42NzZ7E=;
        b=pOxUPEx2p30FSom42uOJypY2JKjJ2kF+ms9HhjhgTZWBCqSf0HyUHuIpJZxexloAgP
         0uIMdvdfJZGrTEbVQ+jodLMgv16SoHaG104FqZFBdbRRcrnM6NCknCkkViVUPhZoc3C9
         dXE+iI7Rhaus/7k2tmxYLLAY4fJtNIABr6UdSDZ+mz4QT9Vhky8eM9+IC40IpC/5Rf18
         hyXzeuW+eLLHYIv4mAQlXBxmcdSWEOQ+R/iNp58mFWA4P8h9PWBedIUw47fAsiQMhzge
         y2wjkGghiA+HG/TyNA5A2qZozqTyKIBCXqmZtZlla5EtPdjs3A9P5nxewq8Vgocll2NV
         Z3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ZmHOnawWtE/a5uwhRHoY82iUlZHav8oUH2GH42NzZ7E=;
        b=Q3TioyftHEwtBpqw/uLiJpk/OdWoJ8H04hNreCV73LSlrCGbspbtba/raCmrBnSdYA
         V9tefjro3yE+JUMPFtSNcOOClizpW43NFMtWQX0pVVibhcPEzOxte0v4lKB5EghL5CuO
         PL7bcDXgC91mocJFc3ADwcjMUOPlL/Q/9vCgMBja7ZlT8f/hBM+A9jF8DtV9ZqGxEyN8
         jwhYkbiOeTLzoJK9fiH2A+eSGEWpmDA9ZhcCsWW8n0d8Wx4xaMjGnZa91cTgh5b4wfZn
         /uEuFJGrOwZH06eRQ0q54FOSCl9PbYYK3WAz0uZKIF6JsZo8v2il1W9WJ34psCOMncE2
         vWVA==
X-Gm-Message-State: AHQUAuYg8eG/rmR8Wwx+Q8qnbWVRMvbf/Nm5ufpk10iAW9FOZEr93mej
        PBIUnHJQgJ+X2dKuxcHpHDKX7DBiUfNnuuhwK5NvDuAY7Aw=
X-Google-Smtp-Source: AHgI3IbO1HhAU5aHDk5K2N2XUie8/dpnSARIKZjyI/DvrtQ/zSfAmnOiuA1WqR6BPPWawn7fAKgX4DP0FY48305LxUw=
X-Received: by 2002:a9d:5a09:: with SMTP id v9mr14951090oth.244.1550524766290;
 Mon, 18 Feb 2019 13:19:26 -0800 (PST)
MIME-Version: 1.0
From:   Rudolf Kastl <che666@gmail.com>
Date:   Mon, 18 Feb 2019 16:19:15 -0500
Message-ID: <CAAD7_rAwZR6j=SgZOCx3C8dRM=BUZJVHDzSmj5rWB21HyWtqSg@mail.gmail.com>
Subject: raid 1 filesystem corruption
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Any hints on how to recover is greatly appreciated.

uname -a:
Linux localhost-live 4.18.16-300.fc29.x86_64 #1 SMP Sat Oct 20
23:24:08 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version:
btrfs-progs v4.17.1

dmesg:
[   46.918149] BTRFS info (device sda2): disk space caching is enabled
[   46.918151] BTRFS info (device sda2): has skinny extents
[  147.509999] rfkill: input handler enabled
[  150.657962] BTRFS warning (device sda2): failed to resume balance: -4
[  151.541975] BTRFS error (device sda2): open_ctree failed
[  159.209490] rfkill: input handler disabled
[  290.624978] BTRFS info (device sda2): disk space caching is enabled
[  290.624981] BTRFS info (device sda2): has skinny extents
[  294.350986] BTRFS info (device sda2): checking UUID tree
[  294.350994] BTRFS info (device sda2): balance: resuming
[  297.425043] BTRFS info (device sda2): relocating block group
1075919716352 flags metadata|raid1
[  342.046679] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[  429.588813] WARNING: CPU: 5 PID: 155 at fs/btrfs/extent-tree.c:1680
lookup_inline_extent_backref+0x631/0x670 [btrfs]
[  429.588814] Modules linked in: scsi_dh_rdac scsi_dh_emc
scsi_dh_alua fcoe libfcoe libfc scsi_transport_fc iscsi_ibft
iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi mcryptd sha256_ssse3
dm_crypt vfat fat dm_round_robin raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx raid1 raid0 fuse devlink
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_mangle iptable_raw
iptable_security nf_conntrack ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables amdgpu chash gpu_sched arc4 ath9k
ath9k_common ath9k_hw snd_hda_codec_realtek
[  429.588845]  snd_hda_codec_generic snd_hda_codec_hdmi radeon
snd_hda_intel mac80211 edac_mce_amd snd_hda_codec kvm_amd snd_hda_core
kvm snd_hwdep snd_seq ath joydev cfg80211 i2c_algo_bit snd_seq_device
irqbypass snd_pcm ttm drm_kms_helper rfkill mxm_wmi snd_timer drm snd
soundcore fam15h_power sp5100_tco wmi i2c_piix4 k10temp pcc_cpufreq
acpi_cpufreq nls_utf8 isofs squashfs scsi_transport_iscsi dm_multipath
btrfs xor zstd_compress raid6_pq libcrc32c zstd_decompress xxhash
crct10dif_pclmul crc32_pclmul crc32c_intel firewire_ohci 8021q garp
firewire_core mrp stp uas ghash_clmulni_intel llc crc_itu_t r8169
usb_storage mii sunrpc loop
[  429.588876] CPU: 5 PID: 155 Comm: kworker/u16:3 Not tainted
4.18.16-300.fc29.x86_64 #1
[  429.588877] Hardware name: Gigabyte Technology Co., Ltd. To be
filled by O.E.M./990XA-UD3, BIOS FEh 10/29/2014
[  429.588897] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  429.588914] RIP: 0010:lookup_inline_extent_backref+0x631/0x670 [btrfs]
[  429.588915] Code: 48 8b 5c 24 30 44 8b 7c 24 3c 4c 8b 6c 24 40 e9
16 fe ff ff 48 8b 5c 24 30 b8 ea ff ff ff e9 5c fb ff ff 31 ed e9 1c
fc ff ff <0f> 0b b8 fb ff ff ff e9 49 fb ff ff 0f 0b 80 7c 24 56 bf 0f
87 3c
[  429.588936] RSP: 0018:ffffa54801e5bb48 EFLAGS: 00010202
[  429.588938] RAX: 0000000000000001 RBX: ffff8e96544da1c0 RCX: 0000000000000000
[  429.588938] RDX: 0000000000000008 RSI: 0000000000000001 RDI: ffff8e9620f61d88
[  429.588939] RBP: 0000000000000000 R08: ffffa54801e5bafc R09: 000000000000009c
[  429.588940] R10: ffff8e9340000000 R11: 0000000000000000 R12: 0000000000003000
[  429.588941] R13: 00000000ff1f1000 R14: ffff8e967894f138 R15: 000000000000000d
[  429.588942] FS:  0000000000000000(0000) GS:ffff8e977ed40000(0000)
knlGS:0000000000000000
[  429.588943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  429.588943] CR2: 00007f67c3a1f000 CR3: 000000022c20a000 CR4: 00000000000406e0
[  429.588944] Call Trace:
[  429.588964]  insert_inline_extent_backref+0x56/0xe0 [btrfs]
[  429.588982]  ? btrfs_mark_buffer_dirty+0x73/0xa0 [btrfs]
[  429.588998]  __btrfs_inc_extent_ref.isra.68+0x8d/0x260 [btrfs]
[  429.589015]  __btrfs_run_delayed_refs+0x820/0x1060 [btrfs]
[  429.589022]  ? __switch_to_asm+0x34/0x70
[  429.589024]  ? __switch_to_asm+0x34/0x70
[  429.589025]  ? __switch_to_asm+0x40/0x70
[  429.589026]  ? __switch_to_asm+0x34/0x70
[  429.589027]  ? __switch_to_asm+0x40/0x70
[  429.589029]  ? __switch_to_asm+0x34/0x70
[  429.589030]  ? __switch_to_asm+0x40/0x70
[  429.589031]  ? __switch_to_asm+0x34/0x70
[  429.589047]  btrfs_run_delayed_refs+0x78/0x180 [btrfs]
[  429.589064]  delayed_ref_async_start+0x81/0x90 [btrfs]
[  429.589083]  normal_work_helper+0xaa/0x2f0 [btrfs]
[  429.589087]  process_one_work+0x1a1/0x350
[  429.589089]  worker_thread+0x30/0x380
[  429.589091]  ? pwq_unbound_release_workfn+0xd0/0xd0
[  429.589093]  kthread+0x112/0x130
[  429.589094]  ? kthread_create_worker_on_cpu+0x70/0x70
[  429.589096]  ret_from_fork+0x22/0x40
[  429.589097] ---[ end trace a095d7d24ffdf81d ]---
[  429.589101] BTRFS: error (device sda2) in
btrfs_run_delayed_refs:3057: errno=-5 IO failure
[  429.589104] BTRFS info (device sda2): forced readonly
[  657.048842] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[  884.822145] BTRFS error (device sda2): cleaner transaction attach
returned -30
[  888.116936] BTRFS info (device sda2): disk space caching is enabled
[  888.116939] BTRFS info (device sda2): has skinny extents
[  972.059451] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 1013.071703] BTRFS info (device sda2): checking UUID tree
[ 1013.071712] BTRFS info (device sda2): balance: resuming
[ 1013.633041] BTRFS info (device sda2): relocating block group
1075919716352 flags metadata|raid1
[ 1035.037129] WARNING: CPU: 7 PID: 5493 at
fs/btrfs/extent-tree.c:1680 lookup_inline_extent_backref+0x631/0x670
[btrfs]
[ 1035.037130] Modules linked in: scsi_dh_rdac scsi_dh_emc
scsi_dh_alua fcoe libfcoe libfc scsi_transport_fc iscsi_ibft
iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi mcryptd sha256_ssse3
dm_crypt vfat fat dm_round_robin raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx raid1 raid0 fuse devlink
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_mangle iptable_raw
iptable_security nf_conntrack ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables amdgpu chash gpu_sched arc4 ath9k
ath9k_common ath9k_hw snd_hda_codec_realtek
[ 1035.037163]  snd_hda_codec_generic snd_hda_codec_hdmi radeon
snd_hda_intel mac80211 edac_mce_amd snd_hda_codec kvm_amd snd_hda_core
kvm snd_hwdep snd_seq ath joydev cfg80211 i2c_algo_bit snd_seq_device
irqbypass snd_pcm ttm drm_kms_helper rfkill mxm_wmi snd_timer drm snd
soundcore fam15h_power sp5100_tco wmi i2c_piix4 k10temp pcc_cpufreq
acpi_cpufreq nls_utf8 isofs squashfs scsi_transport_iscsi dm_multipath
btrfs xor zstd_compress raid6_pq libcrc32c zstd_decompress xxhash
crct10dif_pclmul crc32_pclmul crc32c_intel firewire_ohci 8021q garp
firewire_core mrp stp uas ghash_clmulni_intel llc crc_itu_t r8169
usb_storage mii sunrpc loop
[ 1035.037194] CPU: 7 PID: 5493 Comm: kworker/u16:2 Tainted: G
W         4.18.16-300.fc29.x86_64 #1
[ 1035.037195] Hardware name: Gigabyte Technology Co., Ltd. To be
filled by O.E.M./990XA-UD3, BIOS FEh 10/29/2014
[ 1035.037216] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 1035.037232] RIP: 0010:lookup_inline_extent_backref+0x631/0x670 [btrfs]
[ 1035.037233] Code: 48 8b 5c 24 30 44 8b 7c 24 3c 4c 8b 6c 24 40 e9
16 fe ff ff 48 8b 5c 24 30 b8 ea ff ff ff e9 5c fb ff ff 31 ed e9 1c
fc ff ff <0f> 0b b8 fb ff ff ff e9 49 fb ff ff 0f 0b 80 7c 24 56 bf 0f
87 3c
[ 1035.037254] RSP: 0018:ffffa5480775fb48 EFLAGS: 00010202
[ 1035.037256] RAX: 0000000000000001 RBX: ffff8e95901e0310 RCX: 0000000000000000
[ 1035.037256] RDX: 0000000000000008 RSI: 0000000000000001 RDI: ffff8e960ea7dea0
[ 1035.037257] RBP: 0000000000000000 R08: ffffa5480775fafc R09: 000000000000009c
[ 1035.037258] R10: ffff8e9340000000 R11: 0000000000000000 R12: 0000000000003000
[ 1035.037259] R13: 00000000ff1f1000 R14: ffff8e96b23a8208 R15: 000000000000000d
[ 1035.037260] FS:  0000000000000000(0000) GS:ffff8e977edc0000(0000)
knlGS:0000000000000000
[ 1035.037261] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1035.037262] CR2: 0000164bec47f2d0 CR3: 000000039115e000 CR4: 00000000000406e0
[ 1035.037263] Call Trace:
[ 1035.037283]  insert_inline_extent_backref+0x56/0xe0 [btrfs]
[ 1035.037301]  ? btrfs_mark_buffer_dirty+0x73/0xa0 [btrfs]
[ 1035.037316]  __btrfs_inc_extent_ref.isra.68+0x8d/0x260 [btrfs]
[ 1035.037333]  __btrfs_run_delayed_refs+0x820/0x1060 [btrfs]
[ 1035.037337]  ? __switch_to_asm+0x34/0x70
[ 1035.037339]  ? __switch_to_asm+0x34/0x70
[ 1035.037340]  ? __switch_to_asm+0x40/0x70
[ 1035.037341]  ? __switch_to_asm+0x34/0x70
[ 1035.037342]  ? __switch_to_asm+0x40/0x70
[ 1035.037344]  ? __switch_to_asm+0x34/0x70
[ 1035.037345]  ? __switch_to_asm+0x40/0x70
[ 1035.037346]  ? __switch_to_asm+0x34/0x70
[ 1035.037361]  btrfs_run_delayed_refs+0x78/0x180 [btrfs]
[ 1035.037378]  delayed_ref_async_start+0x81/0x90 [btrfs]
[ 1035.037397]  normal_work_helper+0xaa/0x2f0 [btrfs]
[ 1035.037401]  process_one_work+0x1a1/0x350
[ 1035.037403]  worker_thread+0x30/0x380
[ 1035.037405]  ? pwq_unbound_release_workfn+0xd0/0xd0
[ 1035.037407]  kthread+0x112/0x130
[ 1035.037409]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 1035.037410]  ret_from_fork+0x22/0x40
[ 1035.037412] ---[ end trace a095d7d24ffdf81e ]---
[ 1035.037416] BTRFS: error (device sda2) in
btrfs_run_delayed_refs:3057: errno=-5 IO failure
[ 1035.037419] BTRFS info (device sda2): forced readonly
[ 1287.060044] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 1307.357847] BTRFS error (device sda2): cleaner transaction attach
returned -30


btrfs check:
[root@localhost-live ~]# btrfs check /dev/sda2
Opening filesystem to check...
Checking filesystem on /dev/sda2
UUID: b1672f65-57c6-433b-8175-4ea29426c8c6
[1/7] checking root items
[2/7] checking extents
ref mismatch on [4263448576 12288] extent item 1, found 0
incorrect local backref count on 4263448576 root 265 owner 20398689
offset 0 found 0 wanted 1 back 0x55b303728e80
backref disk bytenr does not match extent record, bytenr=4263448576,
ref bytenr=0
backpointer mismatch on [4263448576 12288]
owner ref check failed [4263448576 12288]
ref mismatch on [4280225792 12288] extent item 0, found 1
data backref 4280225792 root 265 owner 20398689 offset 0 num_refs 0
not found in extent tree
incorrect local backref count on 4280225792 root 265 owner 20398689
offset 0 found 1 wanted 0 back 0x55b305599680
backpointer mismatch on [4280225792 12288]
ERROR: errors found in extent allocation tree or chunk allocation
[3/7] checking free space cache
[4/7] checking fs roots
root 265 inode 6722075 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 8192
root 265 inode 20398749 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 20398750 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 20399694 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 20399695 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 20399704 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 20399705 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 20399706 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 20399708 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 20399733 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 21077342 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 40960
root 265 inode 21077348 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 8192
root 265 inode 21158520 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 16384
root 265 inode 21158522 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 45056
root 265 inode 21249516 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 167936
root 265 inode 21249517 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 28672
root 265 inode 21249518 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 65536
root 265 inode 21249519 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 20480
root 265 inode 21292513 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 61440
    start: 69632, len: 61440
    start: 135168, len: 61440
    start: 200704, len: 61440
    start: 266240, len: 8192
    start: 278528, len: 12288
    start: 294912, len: 12288
    start: 311296, len: 4096
root 265 inode 21292514 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 8192
root 265 inode 21292515 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 8192
root 265 inode 21292516 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 8192
root 265 inode 21292517 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 12288
root 265 inode 21292519 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 8192
    start: 16384, len: 61440
    start: 81920, len: 12288
    start: 98304, len: 16384
root 265 inode 21292526 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 4096
root 265 inode 21292529 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 12288
root 265 inode 21292532 errors 100, file extent discount
Found file extent holes:
    start: 8192, len: 4096
    start: 20480, len: 4096
root 265 inode 21292535 errors 100, file extent discount
Found file extent holes:
    start: 8192, len: 4096
root 265 inode 21292539 errors 100, file extent discount
Found file extent holes:
    start: 8192, len: 4096
root 265 inode 21292541 errors 100, file extent discount
Found file extent holes:
    start: 8192, len: 8192
root 265 inode 21292563 errors 100, file extent discount
Found file extent holes:
    start: 16384, len: 4096
root 265 inode 21294020 errors 100, file extent discount
Found file extent holes:
    start: 4096, len: 28672
    start: 36864, len: 28672
    start: 69632, len: 28672
    start: 102400, len: 28672
    start: 135168, len: 28672
    start: 167936, len: 28672
    start: 200704, len: 28672
    start: 233472, len: 16384
root 265 inode 21294023 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 21294024 errors 100, file extent discount
Found file extent holes:
    start: 8192, len: 8192
    start: 24576, len: 28672
    start: 57344, len: 28672
    start: 90112, len: 12288
    start: 106496, len: 4096
    start: 118784, len: 28672
    start: 151552, len: 24576
root 265 inode 21294040 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 21294046 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 8192
root 265 inode 21294048 errors 100, file extent discount
Found file extent holes:
    start: 8192, len: 4096
    start: 16384, len: 8192
root 265 inode 21294052 errors 100, file extent discount
Found file extent holes:
    start: 69632, len: 12288
    start: 86016, len: 53248
root 265 inode 21294058 errors 100, file extent discount
Found file extent holes:
    start: 8192, len: 4096
    start: 16384, len: 4096
    start: 24576, len: 4096
    start: 36864, len: 32768
    start: 73728, len: 4096
    start: 81920, len: 61440
    start: 147456, len: 4096
root 265 inode 21294059 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 21294062 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 21294063 errors 100, file extent discount
Found file extent holes:
    start: 36864, len: 12288
root 265 inode 21294064 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 21294066 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
root 265 inode 21294067 errors 100, file extent discount
Found file extent holes:
    start: 0, len: 4096
ERROR: errors found in fs roots
found 1310761340928 bytes used, error(s) found
total csum bytes: 1273838524
total tree bytes: 5730992128
total fs tree bytes: 3982426112
total extent tree bytes: 295813120
btree space waste bytes: 911901620
file data blocks allocated: 1822835818496
 referenced 1294330966016
