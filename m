Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E07C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 22:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B3720656
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 22:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ioTLbsKD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfANWcz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 17:32:55 -0500
Received: from mail-it1-f180.google.com ([209.85.166.180]:56052 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfANWcy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 17:32:54 -0500
Received: by mail-it1-f180.google.com with SMTP id m62so2112508ith.5
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 14:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1Zyb+cJBzvg+ppqlWDxj2vK50cFDjd0au3TnmDrQa1A=;
        b=ioTLbsKDoP/7wAELDmPwLcZ7htUYbDiXmlLCcXQULfp2rZmTjNg4OEJyuHBhcUHcBm
         5hKxfXCdoNnXxQT2ZYteFXp0F+sLQcBJbjKDdRh7Zn4eyr+pRv21hs4gfpAP2gIcnPHc
         sA4Sr+473pWK/CFlhrzXQJ5WgFcGfZG0QbbBwxpmd1TidoJSJdTHXafoShLTnxfP207p
         GWIgZM4U0iT80borDEA0BaR0I3wUdORaVIGIc0gA+RHJJJkH72Dm4gAqd51l56rxmtXe
         RxSxvDunKKotiu2W7qJhmyc0wB94gPUuE1qlSOMaABkE2ONgdymq8GQZ/MMtq0+brUnw
         brmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1Zyb+cJBzvg+ppqlWDxj2vK50cFDjd0au3TnmDrQa1A=;
        b=ogkvY6qgn8TcgkSlhItDS7P3B06lXCQB6WqWgn307VPe73myAi1I7OXHAWBfesv6Bm
         qZ1jy4cio9Jb0KA4fEQF6M6Gz45X4Z/qnPXfx59itpMK4enOnrVoYdRHgxNR9R2Ud6U+
         FcjNX+Kl++gfDZP0iwpL5N7odiNb3y74flG8VmTRkmza3kC2sHWYcBZTw9OaRtWyGP6Z
         JEB92UWo5zXfytZgb2P+TNgieVfurykB11eMuid6qe3UnY2ieIgUoda6NcZgkc3LQLXW
         wLLq2NnYRNzIBUgdLxaW6Pj4TZ0OeOe+tEwp8ApLfNc5CdywZM0sLyjoDo5jd39VD3Y6
         U5xA==
X-Gm-Message-State: AJcUukd493KXEjdgNf6YnQuip0/+Vwqgc4GTiZdCQbXiUHHrzS05PD6K
        oJzVsaEOyEevACZos5m/9N+6sQU/kndzgDZkdIrEzCXP
X-Google-Smtp-Source: ALg8bN7971tvdQcFgqHA8DrUAaw7b9K5CjPJucoK8U9TkN946ip2GYmxEsqsTR3oXLDqt9Yf+Xo6MUz81+JhFYRxRo0=
X-Received: by 2002:a02:6915:: with SMTP id e21mr472358jac.142.1547505169261;
 Mon, 14 Jan 2019 14:32:49 -0800 (PST)
MIME-Version: 1.0
From:   Artem Mygaiev <joculator@gmail.com>
Date:   Tue, 15 Jan 2019 00:32:38 +0200
Message-ID: <CAJwc6KvbjmmhdCcF8QBeD7xF3259MtZ4+6C1yBZ11UOz-g1EmA@mail.gmail.com>
Subject: btrfs RAID5 corrupted fs restore? data is OK
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello

I am running Ubuntu Server 16.04 LTS with HWE stack (4.18 kernel).
System is running on 2 protected SSDs in RAID1 mode, separate SSD
assigned for swap and media download / processing cache and main data
storage partition (read intense but not write intense, archive-like)
is 32TB RAID5 btrfs (4x 8TB HDDs) mounted with following command:
UUID=d2dfdbd4-a161-4ab9-85ef-3594e3a078b4       /mnt/Library    btrfs
 defaults,degraded,noatime,nodiratime            0       0

Recently I have started getting errors with my btrfs filesystem
resulting it being mounted in ro mode. I have checked the data (I have
checksums stored for all files, some are checked against cloud copies)
and weirdly enough it was not corrupted. Of course, I cannot normally
work with it while FS is in ro mode. I wonder can I do something with
this without complete re-creating of btrfs filesystem. Note that disks
seem to be physically fine - SMART reports no errors. Please see
details below (I am sorry for the huge log, but I donno which part is
useful)

~$ btrfs --version
btrfs-progs v4.16.1

~$ uname -a
Linux kilimanjaro 4.18.0-13-generic #14~18.04.1-Ubuntu SMP Thu Dec 6
14:09:52 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

~$ sudo btrfs filesystem show
Label: none  uuid: d2dfdbd4-a161-4ab9-85ef-3594e3a078b4
        Total devices 4 FS bytes used 8.93TiB
        devid    1 size 7.28TiB used 3.03TiB path /dev/sdf
        devid    2 size 7.28TiB used 3.03TiB path /dev/sde
        devid    3 size 7.28TiB used 3.03TiB path /dev/sdc
        devid    4 size 7.28TiB used 3.03TiB path /dev/sdd

~$ btrfs fi df /mnt/Library/
Data, RAID5: total=9.08TiB, used=32.97GiB
System, RAID5: total=96.00MiB, used=0.00B
Metadata, RAID5: total=12.38GiB, used=6.53MiB
GlobalReserve, single: total=512.00MiB, used=80.00KiB

~$ sudo dmesg
[    4.281851] BTRFS info (device sdf): allowing degraded mounts
[    4.281852] BTRFS info (device sdf): disk space caching is enabled
[    4.281853] BTRFS info (device sdf): has skinny extents
[    4.427649] BTRFS info (device sdf): bdev /dev/sdf errs: wr 0, rd
0, flush 0, corrupt 1, gen 0
[    4.555937] BTRFS info (device sdf): checking UUID tree
[   35.829971] WARNING: CPU: 2 PID: 636 at
/build/linux-hwe-jDoxDp/linux-hwe-4.18.0/fs/btrfs/locking.c:230
btrfs_tree_lock+0x203/0x220 [btrfs]
[   35.829974] Modules linked in: bonding nls_iso8859_1
snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp
eeepc_wmi kvm_intel ppdev asus_wmi wmi_bmof sparse_keymap mxm_wmi kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
aesni_intel aes_x86_64 crypto_simd cryptd glue_helper intel_cstate
intel_rapl_perf snd_hda_codec_realtek input_leds snd_hda_codec_generic
joydev snd_hda_intel snd_hda_codec snd_hda_core parport_pc snd_hwdep
snd_pcm mei_me snd_timer mei snd soundcore mac_hid acpi_pad wmi
ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt nf_conntrack_ipv6
nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 xt_comment xt_multiport
xt_limit xt_tcpudp xt_addrtype ipt_MASQUERADE iptable_nat nf_nat_ipv4
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack ip6table_filter
sch_fq_codel ip6_tables
[   35.830059]  nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack nct6775 iptable_filter
bpfilter hwmon_vid coretemp lp parport ip_tables x_tables autofs4
btrfs xor zstd_compress raid6_pq libcrc32c hid_generic usbhid hid
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm
ipmi_devintf r8169 ahci ipmi_msghandler mii libahci video
[   35.830113] CPU: 2 PID: 636 Comm: btrfs-cleaner Not tainted
4.18.0-13-generic #14~18.04.1-Ubuntu
[   35.830115] Hardware name: System manufacturer System Product
Name/B150M-A, BIOS 3805 05/16/2018
[   35.830163] RIP: 0010:btrfs_tree_lock+0x203/0x220 [btrfs]
[   35.830165] Code: 8b 04 25 00 5c 01 00 8b 80 a8 08 00 00 89 43 40
48 8b 45 e0 65 48 33 04 25 28 00 00 00 75 16 48 83 c4 30 5b 41 5c 41
5d 5d c3 <0f> 0b e9 32 fe ff ff 0f 0b eb c1 e8 4d 64 c2 e9 0f 1f 00 66
2e 0f
[   35.830244] RSP: 0018:ffffabd6421e3ad0 EFLAGS: 00010246
[   35.830249] RAX: 000000000000027c RBX: ffff93e2dfc14578 RCX: 00000000000f83bd
[   35.830251] RDX: ffff93dec0000000 RSI: 0000000000000000 RDI: ffff93e2dfc14578
[   35.830254] RBP: ffffabd6421e3b18 R08: ffff93e2ddbbc6d8 R09: ffff93e2dfc14578
[   35.830256] R10: 0000000000000040 R11: 0000000000000000 R12: 0000000000004000
[   35.830259] R13: ffff93e2dff6b000 R14: ffff93e2e2a20000 R15: ffff93e2dfc14578
[   35.830263] FS:  0000000000000000(0000) GS:ffff93e2fd900000(0000)
knlGS:0000000000000000
[   35.830266] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.830269] CR2: 00007fe218b000c8 CR3: 000000036bc0a004 CR4: 00000000003606e0
[   35.830271] Call Trace:
[   35.830312]  btrfs_alloc_tree_block+0x17e/0x4b0 [btrfs]
[   35.830342]  __btrfs_cow_block+0x119/0x550 [btrfs]
[   35.830372]  btrfs_cow_block+0xdf/0x1a0 [btrfs]
[   35.830399]  btrfs_search_slot+0x33b/0x9e0 [btrfs]
[   35.830409]  ? kmem_cache_alloc+0x1a1/0x1d0
[   35.830454]  btrfs_update_device+0x77/0x1d0 [btrfs]
[   35.830495]  btrfs_remove_chunk+0x2a4/0x8c0 [btrfs]
[   35.830531]  btrfs_delete_unused_bgs+0x34e/0x3f0 [btrfs]
[   35.830568]  cleaner_kthread+0x148/0x170 [btrfs]
[   35.830575]  kthread+0x121/0x140
[   35.830608]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
[   35.830614]  ? kthread_create_worker_on_cpu+0x70/0x70
[   35.830621]  ret_from_fork+0x35/0x40
[   35.830626] ---[ end trace 15cb60d2d3e26d46 ]---
[   66.735057] WARNING: CPU: 1 PID: 637 at
/build/linux-hwe-jDoxDp/linux-hwe-4.18.0/fs/btrfs/extent-tree.c:6944
__btrfs_free_extent.isra.68+0x1fd/0xdd0 [btrfs]
[   66.735059] Modules linked in: bonding nls_iso8859_1
snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp
eeepc_wmi kvm_intel ppdev asus_wmi wmi_bmof sparse_keymap mxm_wmi kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
aesni_intel aes_x86_64 crypto_simd cryptd glue_helper intel_cstate
intel_rapl_perf snd_hda_codec_realtek input_leds snd_hda_codec_generic
joydev snd_hda_intel snd_hda_codec snd_hda_core parport_pc snd_hwdep
snd_pcm mei_me snd_timer mei snd soundcore mac_hid acpi_pad wmi
ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt nf_conntrack_ipv6
nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 xt_comment xt_multiport
xt_limit xt_tcpudp xt_addrtype ipt_MASQUERADE iptable_nat nf_nat_ipv4
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack ip6table_filter
sch_fq_codel ip6_tables
[   66.735145]  nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack nct6775 iptable_filter
bpfilter hwmon_vid coretemp lp parport ip_tables x_tables autofs4
btrfs xor zstd_compress raid6_pq libcrc32c hid_generic usbhid hid
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm
ipmi_devintf r8169 ahci ipmi_msghandler mii libahci video
[   66.735199] CPU: 1 PID: 637 Comm: btrfs-transacti Tainted: G
W         4.18.0-13-generic #14~18.04.1-Ubuntu
[   66.735201] Hardware name: System manufacturer System Product
Name/B150M-A, BIOS 3805 05/16/2018
[   66.735234] RIP: 0010:__btrfs_free_extent.isra.68+0x1fd/0xdd0 [btrfs]
[   66.735236] Code: 75 10 48 89 d9 48 c7 45 a0 00 00 00 00 e8 bb bc
ff ff 41 89 c5 58 5a 45 85 ed 0f 84 82 00 00 00 41 83 fd fe 0f 85 03
ff ff ff <0f> 0b 49 8b 3f e8 a9 d9 00 00 4c 8b 4d 10 4c 8b 85 78 ff ff
ff 4c
[   66.735316] RSP: 0018:ffffabd641fdfc60 EFLAGS: 00010246
[   66.735320] RAX: 00000000fffffffe RBX: 0000145e9b5c4000 RCX: 0000000000000000
[   66.735323] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   66.735326] RBP: ffffabd641fdfd08 R08: ffff93e2df10f620 R09: 000000000000018f
[   66.735328] R10: 0000000000000000 R11: ffffabd641fdfbcc R12: ffff93e2e2a20000
[   66.735331] R13: 00000000fffffffe R14: 0000000000000000 R15: ffff93e2df10f620
[   66.735334] FS:  0000000000000000(0000) GS:ffff93e2fd880000(0000)
knlGS:0000000000000000
[   66.735337] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.735340] CR2: 00007f59f30e7600 CR3: 000000036bc0a001 CR4: 00000000003606e0
[   66.735342] Call Trace:
[   66.735379]  ? cleanup_ref_head+0x446/0x5f0 [btrfs]
[   66.735428]  ? btrfs_merge_delayed_refs+0x2fa/0x360 [btrfs]
[   66.735459]  __btrfs_run_delayed_refs+0x37e/0xbf0 [btrfs]
[   66.735495]  btrfs_run_delayed_refs+0xf8/0x1b0 [btrfs]
[   66.735535]  btrfs_commit_transaction+0x42/0x8a0 [btrfs]
[   66.735571]  ? start_transaction+0xa0/0x3e0 [btrfs]
[   66.735606]  transaction_kthread+0x14b/0x170 [btrfs]
[   66.735614]  kthread+0x121/0x140
[   66.735647]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[   66.735653]  ? kthread_create_worker_on_cpu+0x70/0x70
[   66.735660]  ret_from_fork+0x35/0x40
[   66.735665] ---[ end trace 15cb60d2d3e26d47 ]---
[   66.735674] BTRFS info (device sdf): leaf 22039754768384 gen
1016765 total ptrs 229 free space 5008 owner 2
[   66.735679]  item 0 key (22039754702848 169 1) itemoff 16250 itemsize 33
[   66.735681]          extent refs 1 gen 1016765 flags 2
[   66.735683]          ref#0: tree block backref root 4
[   66.735689]  item 1 key (22039754702848 192 1107296256) itemoff
16226 itemsize 24
[   66.735692]          block group used 0 chunk_objectid 256 flags 132
[   66.735695]  item 2 key (22039754719232 169 0) itemoff 16193 itemsize 33
[   66.735698]          extent refs 1 gen 1016765 flags 2
[   66.735699]          ref#0: tree block backref root 4
[   66.735704]  item 3 key (22039754735616 169 1) itemoff 16160 itemsize 33
[   66.735706]          extent refs 1 gen 1016765 flags 2
[   66.735708]          ref#0: tree block backref root 2
[   66.735712]  item 4 key (22039754752000 169 0) itemoff 16127 itemsize 33
[   66.735714]          extent refs 1 gen 1016765 flags 2
[   66.735715]          ref#0: tree block backref root 2
[   66.735720]  item 5 key (22039754768384 169 0) itemoff 16094 itemsize 33
[   66.735722]          extent refs 1 gen 1016765 flags 2
[   66.735723]          ref#0: tree block backref root 2
[   66.735728]  item 6 key (22040861999104 192 3221225472) itemoff
16070 itemsize 24
[   66.735730]          block group used 0 chunk_objectid 256 flags 129
[   66.735733]  item 7 key (22044083224576 192 3221225472) itemoff
16046 itemsize 24
[   66.735736]          block group used 0 chunk_objectid 256 flags 129
[   66.735739]  item 8 key (22047304450048 192 3221225472) itemoff
16022 itemsize 24
[   66.735741]          block group used 0 chunk_objectid 256 flags 129
[   66.735744]  item 9 key (22050525675520 192 3221225472) itemoff
15998 itemsize 24
[   66.735746]          block group used 0 chunk_objectid 256 flags 129
[   66.735750]  item 10 key (22053746900992 192 3221225472) itemoff
15974 itemsize 24
[   66.735752]          block group used 0 chunk_objectid 256 flags 129
[   66.735755]  item 11 key (22056968126464 192 3221225472) itemoff
15950 itemsize 24
[   66.735757]          block group used 0 chunk_objectid 256 flags 129
[   66.735760]  item 12 key (22060189351936 192 3221225472) itemoff
15926 itemsize 24
[   66.735762]          block group used 0 chunk_objectid 256 flags 129
[   66.735765]  item 13 key (22063410577408 192 3221225472) itemoff
15902 itemsize 24
[   66.735767]          block group used 0 chunk_objectid 256 flags 129
[   66.735771]  item 14 key (22066631802880 192 3221225472) itemoff
15878 itemsize 24
[   66.735773]          block group used 0 chunk_objectid 256 flags 129
[   66.735776]  item 15 key (22069853028352 192 3221225472) itemoff
15854 itemsize 24
[   66.735778]          block group used 0 chunk_objectid 256 flags 129
[   66.735781]  item 16 key (22073074253824 192 3221225472) itemoff
15830 itemsize 24
[   66.735783]          block group used 0 chunk_objectid 256 flags 129
[   66.735786]  item 17 key (22076295479296 192 3221225472) itemoff
15806 itemsize 24
[   66.735788]          block group used 0 chunk_objectid 256 flags 129
[   66.735791]  item 18 key (22079516704768 192 3221225472) itemoff
15782 itemsize 24
[   66.735793]          block group used 0 chunk_objectid 256 flags 129
[   66.735797]  item 19 key (22082737930240 192 3221225472) itemoff
15758 itemsize 24
[   66.735799]          block group used 0 chunk_objectid 256 flags 129
[   66.735802]  item 20 key (22085959155712 192 3221225472) itemoff
15734 itemsize 24
[   66.735804]          block group used 0 chunk_objectid 256 flags 129
[   66.735807]  item 21 key (22089180381184 192 3221225472) itemoff
15710 itemsize 24
[   66.735809]          block group used 0 chunk_objectid 256 flags 129
[   66.735812]  item 22 key (22092401606656 192 3221225472) itemoff
15686 itemsize 24
[   66.735814]          block group used 0 chunk_objectid 256 flags 129
[   66.735817]  item 23 key (22095622832128 192 3221225472) itemoff
15662 itemsize 24
[   66.735820]          block group used 0 chunk_objectid 256 flags 129
[   66.735823]  item 24 key (22098844057600 192 3221225472) itemoff
15638 itemsize 24
[   66.735825]          block group used 0 chunk_objectid 256 flags 129
[   66.735828]  item 25 key (22102065283072 192 3221225472) itemoff
15614 itemsize 24
[   66.735830]          block group used 0 chunk_objectid 256 flags 129
[   66.735833]  item 26 key (22105286508544 192 3221225472) itemoff
15590 itemsize 24
[   66.735835]          block group used 0 chunk_objectid 256 flags 129
[   66.735838]  item 27 key (22108507734016 192 3221225472) itemoff
15566 itemsize 24
[   66.735840]          block group used 0 chunk_objectid 256 flags 129
[   66.735844]  item 28 key (22111728959488 192 3221225472) itemoff
15542 itemsize 24
[   66.735846]          block group used 0 chunk_objectid 256 flags 129
[   66.735849]  item 29 key (22114950184960 192 3221225472) itemoff
15518 itemsize 24
[   66.735851]          block group used 0 chunk_objectid 256 flags 129
[   66.735854]  item 30 key (22118171410432 192 3221225472) itemoff
15494 itemsize 24
[   66.735856]          block group used 0 chunk_objectid 256 flags 129
[   66.735859]  item 31 key (22121392635904 192 3221225472) itemoff
15470 itemsize 24
[   66.735861]          block group used 0 chunk_objectid 256 flags 129
[   66.735864]  item 32 key (22124613861376 192 3221225472) itemoff
15446 itemsize 24
[   66.735866]          block group used 0 chunk_objectid 256 flags 129
[   66.735870]  item 33 key (22127835086848 192 3221225472) itemoff
15422 itemsize 24
[   66.735872]          block group used 0 chunk_objectid 256 flags 129
[   66.735875]  item 34 key (22131056312320 192 3221225472) itemoff
15398 itemsize 24
[   66.735877]          block group used 0 chunk_objectid 256 flags 129
[   66.735880]  item 35 key (22134277537792 192 3221225472) itemoff
15374 itemsize 24
[   66.735882]          block group used 0 chunk_objectid 256 flags 129
[   66.735885]  item 36 key (22137498763264 192 3221225472) itemoff
15350 itemsize 24
[   66.735887]          block group used 0 chunk_objectid 256 flags 129
[   66.735891]  item 37 key (22140719988736 192 3221225472) itemoff
15326 itemsize 24
[   66.735893]          block group used 0 chunk_objectid 256 flags 129
[   66.735896]  item 38 key (22143941214208 192 3221225472) itemoff
15302 itemsize 24
[   66.735898]          block group used 0 chunk_objectid 256 flags 129
[   66.735901]  item 39 key (22147162439680 192 3221225472) itemoff
15278 itemsize 24
[   66.735903]          block group used 0 chunk_objectid 256 flags 129
[   66.735906]  item 40 key (22150383665152 192 3221225472) itemoff
15254 itemsize 24
[   66.735908]          block group used 0 chunk_objectid 256 flags 129
[   66.735912]  item 41 key (22153604890624 192 3221225472) itemoff
15230 itemsize 24
[   66.735914]          block group used 0 chunk_objectid 256 flags 129
[   66.735917]  item 42 key (22156826116096 192 3221225472) itemoff
15206 itemsize 24
[   66.735919]          block group used 0 chunk_objectid 256 flags 129
[   66.735922]  item 43 key (22160047341568 192 3221225472) itemoff
15182 itemsize 24
[   66.735924]          block group used 0 chunk_objectid 256 flags 129
[   66.735927]  item 44 key (22163268567040 192 3221225472) itemoff
15158 itemsize 24
[   66.735929]          block group used 0 chunk_objectid 256 flags 129
[   66.735933]  item 45 key (22166489792512 192 3221225472) itemoff
15134 itemsize 24
[   66.735935]          block group used 0 chunk_objectid 256 flags 129
[   66.735938]  item 46 key (22169711017984 192 3221225472) itemoff
15110 itemsize 24
[   66.735940]          block group used 0 chunk_objectid 256 flags 129
[   66.735943]  item 47 key (22172932243456 192 3221225472) itemoff
15086 itemsize 24
[   66.735945]          block group used 0 chunk_objectid 256 flags 129
[   66.735948]  item 48 key (22176153468928 192 3221225472) itemoff
15062 itemsize 24
[   66.735950]          block group used 0 chunk_objectid 256 flags 129
[   66.735954]  item 49 key (22179374694400 192 3221225472) itemoff
15038 itemsize 24
[   66.735956]          block group used 0 chunk_objectid 256 flags 129
[   66.735959]  item 50 key (22182595919872 192 3221225472) itemoff
15014 itemsize 24
[   66.735961]          block group used 0 chunk_objectid 256 flags 129
[   66.735964]  item 51 key (22185817145344 192 3221225472) itemoff
14990 itemsize 24
[   66.735966]          block group used 0 chunk_objectid 256 flags 129
[   66.735969]  item 52 key (22189038370816 192 3221225472) itemoff
14966 itemsize 24
[   66.735971]          block group used 0 chunk_objectid 256 flags 129
[   66.735974]  item 53 key (22192259596288 192 3221225472) itemoff
14942 itemsize 24
[   66.735976]          block group used 0 chunk_objectid 256 flags 129
[   66.735980]  item 54 key (22195480821760 192 3221225472) itemoff
14918 itemsize 24
[   66.735982]          block group used 0 chunk_objectid 256 flags 129
[   66.735985]  item 55 key (22198702047232 192 3221225472) itemoff
14894 itemsize 24
[   66.735987]          block group used 0 chunk_objectid 256 flags 129
[   66.735990]  item 56 key (22201923272704 192 3221225472) itemoff
14870 itemsize 24
[   66.735992]          block group used 0 chunk_objectid 256 flags 129
[   66.735995]  item 57 key (22205144498176 192 3221225472) itemoff
14846 itemsize 24
[   66.735997]          block group used 0 chunk_objectid 256 flags 129
[   66.736001]  item 58 key (22208365723648 192 3221225472) itemoff
14822 itemsize 24
[   66.736003]          block group used 0 chunk_objectid 256 flags 129
[   66.736006]  item 59 key (22211586949120 192 3221225472) itemoff
14798 itemsize 24
[   66.736008]          block group used 0 chunk_objectid 256 flags 129
[   66.736011]  item 60 key (22214808174592 192 3221225472) itemoff
14774 itemsize 24
[   66.736013]          block group used 0 chunk_objectid 256 flags 129
[   66.736016]  item 61 key (22218029400064 192 3221225472) itemoff
14750 itemsize 24
[   66.736018]          block group used 0 chunk_objectid 256 flags 129
[   66.736021]  item 62 key (22221250625536 192 3221225472) itemoff
14726 itemsize 24
[   66.736024]          block group used 0 chunk_objectid 256 flags 129
[   66.736027]  item 63 key (22224471851008 192 3221225472) itemoff
14702 itemsize 24
[   66.736029]          block group used 0 chunk_objectid 256 flags 129
[   66.736032]  item 64 key (22227693076480 192 3221225472) itemoff
14678 itemsize 24
[   66.736034]          block group used 0 chunk_objectid 256 flags 129
[   66.736037]  item 65 key (22230914301952 192 3221225472) itemoff
14654 itemsize 24
[   66.736039]          block group used 0 chunk_objectid 256 flags 129
[   66.736042]  item 66 key (22234135527424 192 3221225472) itemoff
14630 itemsize 24
[   66.736044]          block group used 0 chunk_objectid 256 flags 129
[   66.736047]  item 67 key (22237356752896 192 3221225472) itemoff
14606 itemsize 24
[   66.736050]          block group used 0 chunk_objectid 256 flags 129
[   66.736053]  item 68 key (22240577978368 192 3221225472) itemoff
14582 itemsize 24
[   66.736055]          block group used 0 chunk_objectid 256 flags 129
[   66.736058]  item 69 key (22243799203840 192 3221225472) itemoff
14558 itemsize 24
[   66.736060]          block group used 0 chunk_objectid 256 flags 129
[   66.736063]  item 70 key (22247020429312 192 3221225472) itemoff
14534 itemsize 24
[   66.736065]          block group used 0 chunk_objectid 256 flags 129
[   66.736068]  item 71 key (22250241654784 192 3221225472) itemoff
14510 itemsize 24
[   66.736070]          block group used 0 chunk_objectid 256 flags 129
[   66.736073]  item 72 key (22253462880256 192 3221225472) itemoff
14486 itemsize 24
[   66.736076]          block group used 0 chunk_objectid 256 flags 129
[   66.736079]  item 73 key (22256684105728 192 3221225472) itemoff
14462 itemsize 24
[   66.736081]          block group used 0 chunk_objectid 256 flags 129
[   66.736084]  item 74 key (22259905331200 192 3221225472) itemoff
14438 itemsize 24
[   66.736086]          block group used 0 chunk_objectid 256 flags 129
[   66.736089]  item 75 key (22263126556672 192 3221225472) itemoff
14414 itemsize 24
[   66.736091]          block group used 0 chunk_objectid 256 flags 129
[   66.736094]  item 76 key (22266347782144 192 3221225472) itemoff
14390 itemsize 24
[   66.736096]          block group used 0 chunk_objectid 256 flags 129
[   66.736100]  item 77 key (22269569007616 192 3221225472) itemoff
14366 itemsize 24
[   66.736102]          block group used 0 chunk_objectid 256 flags 129
[   66.736105]  item 78 key (22272790233088 192 3221225472) itemoff
14342 itemsize 24
[   66.736107]          block group used 0 chunk_objectid 256 flags 129
[   66.736110]  item 79 key (22276011458560 192 3221225472) itemoff
14318 itemsize 24
[   66.736112]          block group used 0 chunk_objectid 256 flags 129
[   66.736115]  item 80 key (22279232684032 192 1107296256) itemoff
14294 itemsize 24
[   66.736117]          block group used 0 chunk_objectid 256 flags 132
[   66.736120]  item 81 key (22280339980288 192 3221225472) itemoff
14270 itemsize 24
[   66.736123]          block group used 0 chunk_objectid 256 flags 129
[   66.736126]  item 82 key (22283561205760 192 3221225472) itemoff
14246 itemsize 24
[   66.736128]          block group used 0 chunk_objectid 256 flags 129
[   66.736131]  item 83 key (22286782431232 192 3221225472) itemoff
14222 itemsize 24
[   66.736133]          block group used 0 chunk_objectid 256 flags 129
[   66.736136]  item 84 key (22290003656704 192 3221225472) itemoff
14198 itemsize 24
[   66.736138]          block group used 0 chunk_objectid 256 flags 129
[   66.736141]  item 85 key (22293224882176 192 3221225472) itemoff
14174 itemsize 24
[   66.736143]          block group used 0 chunk_objectid 256 flags 129
[   66.736146]  item 86 key (22296446107648 192 3221225472) itemoff
14150 itemsize 24
[   66.736149]          block group used 0 chunk_objectid 256 flags 129
[   66.736152]  item 87 key (22299667333120 192 3221225472) itemoff
14126 itemsize 24
[   66.736154]          block group used 0 chunk_objectid 256 flags 129
[   66.736157]  item 88 key (22302888558592 192 3221225472) itemoff
14102 itemsize 24
[   66.736159]          block group used 0 chunk_objectid 256 flags 129
[   66.736162]  item 89 key (22306109784064 192 3221225472) itemoff
14078 itemsize 24
[   66.736164]          block group used 0 chunk_objectid 256 flags 129
[   66.736168]  item 90 key (22309331009536 192 3221225472) itemoff
14054 itemsize 24
[   66.736170]          block group used 0 chunk_objectid 256 flags 129
[   66.736173]  item 91 key (22312552235008 192 3221225472) itemoff
14030 itemsize 24
[   66.736175]          block group used 0 chunk_objectid 256 flags 129
[   66.736178]  item 92 key (22315773460480 192 3221225472) itemoff
14006 itemsize 24
[   66.736180]          block group used 0 chunk_objectid 256 flags 129
[   66.736183]  item 93 key (22318994685952 192 3221225472) itemoff
13982 itemsize 24
[   66.736185]          block group used 0 chunk_objectid 256 flags 129
[   66.736188]  item 94 key (22322215911424 192 3221225472) itemoff
13958 itemsize 24
[   66.736190]          block group used 0 chunk_objectid 256 flags 129
[   66.736194]  item 95 key (22325437136896 192 3221225472) itemoff
13934 itemsize 24
[   66.736196]          block group used 0 chunk_objectid 256 flags 129
[   66.736199]  item 96 key (22328658362368 192 3221225472) itemoff
13910 itemsize 24
[   66.736201]          block group used 0 chunk_objectid 256 flags 129
[   66.736204]  item 97 key (22331879587840 192 3221225472) itemoff
13886 itemsize 24
[   66.736206]          block group used 0 chunk_objectid 256 flags 129
[   66.736209]  item 98 key (22335100813312 192 3221225472) itemoff
13862 itemsize 24
[   66.736211]          block group used 0 chunk_objectid 256 flags 129
[   66.736215]  item 99 key (22338322038784 192 3221225472) itemoff
13838 itemsize 24
[   66.736217]          block group used 0 chunk_objectid 256 flags 129
[   66.736220]  item 100 key (22341543264256 192 3221225472) itemoff
13814 itemsize 24
[   66.736222]          block group used 0 chunk_objectid 256 flags 129
[   66.736225]  item 101 key (22344764489728 192 3221225472) itemoff
13790 itemsize 24
[   66.736227]          block group used 0 chunk_objectid 256 flags 129
[   66.736231]  item 102 key (22347985715200 192 3221225472) itemoff
13766 itemsize 24
[   66.736233]          block group used 0 chunk_objectid 256 flags 129
[   66.736236]  item 103 key (22351206940672 192 3221225472) itemoff
13742 itemsize 24
[   66.736238]          block group used 0 chunk_objectid 256 flags 129
[   66.736241]  item 104 key (22354428166144 192 3221225472) itemoff
13718 itemsize 24
[   66.736243]          block group used 0 chunk_objectid 256 flags 129
[   66.736246]  item 105 key (22357649391616 192 3221225472) itemoff
13694 itemsize 24
[   66.736249]          block group used 0 chunk_objectid 256 flags 129
[   66.736252]  item 106 key (22360870617088 192 3221225472) itemoff
13670 itemsize 24
[   66.736254]          block group used 0 chunk_objectid 256 flags 129
[   66.736257]  item 107 key (22364091842560 192 3221225472) itemoff
13646 itemsize 24
[   66.736259]          block group used 0 chunk_objectid 256 flags 129
[   66.736262]  item 108 key (22367313068032 192 3221225472) itemoff
13622 itemsize 24
[   66.736264]          block group used 0 chunk_objectid 256 flags 129
[   66.736267]  item 109 key (22370534293504 192 3221225472) itemoff
13598 itemsize 24
[   66.736270]          block group used 0 chunk_objectid 256 flags 129
[   66.736273]  item 110 key (22373755518976 192 3221225472) itemoff
13574 itemsize 24
[   66.736275]          block group used 0 chunk_objectid 256 flags 129
[   66.736278]  item 111 key (22376976744448 192 3221225472) itemoff
13550 itemsize 24
[   66.736280]          block group used 0 chunk_objectid 256 flags 129
[   66.736283]  item 112 key (22380197969920 192 3221225472) itemoff
13526 itemsize 24
[   66.736285]          block group used 0 chunk_objectid 256 flags 129
[   66.736288]  item 113 key (22383419195392 192 3221225472) itemoff
13502 itemsize 24
[   66.736291]          block group used 0 chunk_objectid 256 flags 129
[   66.736294]  item 114 key (22386640420864 192 3221225472) itemoff
13478 itemsize 24
[   66.736296]          block group used 0 chunk_objectid 256 flags 129
[   66.736299]  item 115 key (22389861646336 192 3221225472) itemoff
13454 itemsize 24
[   66.736301]          block group used 0 chunk_objectid 256 flags 129
[   66.736304]  item 116 key (22393082871808 192 3221225472) itemoff
13430 itemsize 24
[   66.736306]          block group used 0 chunk_objectid 256 flags 129
[   66.736309]  item 117 key (22396304097280 169 0) itemoff 13397 itemsize 33
[   66.736312]          extent refs 1 gen 945361 flags 2
[   66.736313]          ref#0: tree block backref root 1
[   66.736318]  item 118 key (22396304097280 192 1107296256) itemoff
13373 itemsize 24
[   66.736320]          block group used 16384 chunk_objectid 256 flags 132
[   66.736323]  item 119 key (22397411393536 192 1107296256) itemoff
13349 itemsize 24
[   66.736325]          block group used 0 chunk_objectid 256 flags 132
[   66.736328]  item 120 key (22398518689792 192 1107296256) itemoff
13325 itemsize 24
[   66.736330]          block group used 0 chunk_objectid 256 flags 132
[   66.736334]  item 121 key (22399625986048 192 1107296256) itemoff
13301 itemsize 24
[   66.736336]          block group used 0 chunk_objectid 256 flags 132
[   66.736339]  item 122 key (22400733282304 192 3221225472) itemoff
13277 itemsize 24
[   66.736341]          block group used 0 chunk_objectid 256 flags 129
[   66.736344]  item 123 key (22403954507776 192 3221225472) itemoff
13253 itemsize 24
[   66.736346]          block group used 0 chunk_objectid 256 flags 129
[   66.736349]  item 124 key (22407175733248 192 3221225472) itemoff
13229 itemsize 24
[   66.736351]          block group used 0 chunk_objectid 256 flags 129
[   66.736355]  item 125 key (22410396958720 192 3221225472) itemoff
13205 itemsize 24
[   66.736357]          block group used 0 chunk_objectid 256 flags 129
[   66.736360]  item 126 key (22413618184192 192 3221225472) itemoff
13181 itemsize 24
[   66.736362]          block group used 0 chunk_objectid 256 flags 129
[   66.736365]  item 127 key (22416839409664 192 3221225472) itemoff
13157 itemsize 24
[   66.736367]          block group used 0 chunk_objectid 256 flags 129
[   66.736370]  item 128 key (22420060635136 192 3221225472) itemoff
13133 itemsize 24
[   66.736372]          block group used 0 chunk_objectid 256 flags 129
[   66.736375]  item 129 key (22423281860608 192 3221225472) itemoff
13109 itemsize 24
[   66.736377]          block group used 0 chunk_objectid 256 flags 129
[   66.736381]  item 130 key (22426503086080 192 3221225472) itemoff
13085 itemsize 24
[   66.736383]          block group used 0 chunk_objectid 256 flags 129
[   66.736386]  item 131 key (22429724311552 192 3221225472) itemoff
13061 itemsize 24
[   66.736388]          block group used 0 chunk_objectid 256 flags 129
[   66.736391]  item 132 key (22432945537024 192 3221225472) itemoff
13037 itemsize 24
[   66.736393]          block group used 0 chunk_objectid 256 flags 129
[   66.736396]  item 133 key (22436166762496 192 3221225472) itemoff
13013 itemsize 24
[   66.736398]          block group used 0 chunk_objectid 256 flags 129
[   66.736402]  item 134 key (22439387987968 192 3221225472) itemoff
12989 itemsize 24
[   66.736404]          block group used 0 chunk_objectid 256 flags 129
[   66.736407]  item 135 key (22442609213440 192 3221225472) itemoff
12965 itemsize 24
[   66.736409]          block group used 0 chunk_objectid 256 flags 129
[   66.736412]  item 136 key (22445830438912 192 3221225472) itemoff
12941 itemsize 24
[   66.736414]          block group used 0 chunk_objectid 256 flags 129
[   66.736417]  item 137 key (22449051664384 192 3221225472) itemoff
12917 itemsize 24
[   66.736419]          block group used 0 chunk_objectid 256 flags 129
[   66.736423]  item 138 key (22452272889856 192 3221225472) itemoff
12893 itemsize 24
[   66.736425]          block group used 0 chunk_objectid 256 flags 129
[   66.736428]  item 139 key (22455494115328 192 3221225472) itemoff
12869 itemsize 24
[   66.736430]          block group used 0 chunk_objectid 256 flags 129
[   66.736433]  item 140 key (22458715340800 192 3221225472) itemoff
12845 itemsize 24
[   66.736435]          block group used 0 chunk_objectid 256 flags 129
[   66.736438]  item 141 key (22461936566272 192 3221225472) itemoff
12821 itemsize 24
[   66.736440]          block group used 0 chunk_objectid 256 flags 129
[   66.736443]  item 142 key (22465157791744 192 3221225472) itemoff
12797 itemsize 24
[   66.736446]          block group used 0 chunk_objectid 256 flags 129
[   66.736449]  item 143 key (22468379017216 192 3221225472) itemoff
12773 itemsize 24
[   66.736451]          block group used 0 chunk_objectid 256 flags 129
[   66.736454]  item 144 key (22471600242688 192 3221225472) itemoff
12749 itemsize 24
[   66.736456]          block group used 0 chunk_objectid 256 flags 129
[   66.736459]  item 145 key (22474821468160 192 3221225472) itemoff
12725 itemsize 24
[   66.736461]          block group used 0 chunk_objectid 256 flags 129
[   66.736464]  item 146 key (22478042693632 192 3221225472) itemoff
12701 itemsize 24
[   66.736467]          block group used 0 chunk_objectid 256 flags 129
[   66.736470]  item 147 key (22481263919104 192 3221225472) itemoff
12677 itemsize 24
[   66.736472]          block group used 0 chunk_objectid 256 flags 129
[   66.736475]  item 148 key (22484485144576 192 3221225472) itemoff
12653 itemsize 24
[   66.736477]          block group used 0 chunk_objectid 256 flags 129
[   66.736480]  item 149 key (22487706370048 192 3221225472) itemoff
12629 itemsize 24
[   66.736482]          block group used 0 chunk_objectid 256 flags 129
[   66.736486]  item 150 key (22490927595520 192 3221225472) itemoff
12605 itemsize 24
[   66.736488]          block group used 0 chunk_objectid 256 flags 129
[   66.736491]  item 151 key (22494148820992 192 3221225472) itemoff
12581 itemsize 24
[   66.736493]          block group used 0 chunk_objectid 256 flags 129
[   66.736496]  item 152 key (22497370046464 192 3221225472) itemoff
12557 itemsize 24
[   66.736498]          block group used 0 chunk_objectid 256 flags 129
[   66.736501]  item 153 key (22500591271936 192 3221225472) itemoff
12533 itemsize 24
[   66.736503]          block group used 0 chunk_objectid 256 flags 129
[   66.736506]  item 154 key (22503812497408 192 3221225472) itemoff
12509 itemsize 24
[   66.736509]          block group used 0 chunk_objectid 256 flags 129
[   66.736512]  item 155 key (22507033722880 192 3221225472) itemoff
12485 itemsize 24
[   66.736514]          block group used 0 chunk_objectid 256 flags 129
[   66.736517]  item 156 key (22510254948352 192 3221225472) itemoff
12461 itemsize 24
[   66.736520]          block group used 0 chunk_objectid 256 flags 129
[   66.736525]  item 157 key (22513476173824 192 3221225472) itemoff
12437 itemsize 24
[   66.736528]          block group used 0 chunk_objectid 256 flags 129
[   66.736532]  item 158 key (22516697399296 192 3221225472) itemoff
12413 itemsize 24
[   66.736535]          block group used 0 chunk_objectid 256 flags 129
[   66.736540]  item 159 key (22519918624768 192 3221225472) itemoff
12389 itemsize 24
[   66.736543]          block group used 0 chunk_objectid 256 flags 129
[   66.736547]  item 160 key (22523139850240 192 3221225472) itemoff
12365 itemsize 24
[   66.736550]          block group used 0 chunk_objectid 256 flags 129
[   66.736554]  item 161 key (22526361075712 192 3221225472) itemoff
12341 itemsize 24
[   66.736557]          block group used 0 chunk_objectid 256 flags 129
[   66.736561]  item 162 key (22529582301184 192 3221225472) itemoff
12317 itemsize 24
[   66.736564]          block group used 0 chunk_objectid 256 flags 129
[   66.736569]  item 163 key (22532803526656 192 3221225472) itemoff
12293 itemsize 24
[   66.736572]          block group used 0 chunk_objectid 256 flags 129
[   66.736576]  item 164 key (22536024752128 192 3221225472) itemoff
12269 itemsize 24
[   66.736579]          block group used 0 chunk_objectid 256 flags 129
[   66.736584]  item 165 key (22539245977600 192 3221225472) itemoff
12245 itemsize 24
[   66.736587]          block group used 0 chunk_objectid 256 flags 129
[   66.736591]  item 166 key (22542467203072 192 3221225472) itemoff
12221 itemsize 24
[   66.736593]          block group used 0 chunk_objectid 256 flags 129
[   66.736596]  item 167 key (22545688428544 192 3221225472) itemoff
12197 itemsize 24
[   66.736598]          block group used 0 chunk_objectid 256 flags 129
[   66.736601]  item 168 key (22548909654016 192 3221225472) itemoff
12173 itemsize 24
[   66.736604]          block group used 0 chunk_objectid 256 flags 129
[   66.736607]  item 169 key (22552130879488 192 3221225472) itemoff
12149 itemsize 24
[   66.736609]          block group used 0 chunk_objectid 256 flags 129
[   66.736612]  item 170 key (22555352104960 192 3221225472) itemoff
12125 itemsize 24
[   66.736614]          block group used 0 chunk_objectid 256 flags 129
[   66.736617]  item 171 key (22558573330432 192 3221225472) itemoff
12101 itemsize 24
[   66.736620]          block group used 0 chunk_objectid 256 flags 129
[   66.736623]  item 172 key (22561794555904 192 3221225472) itemoff
12077 itemsize 24
[   66.736625]          block group used 0 chunk_objectid 256 flags 129
[   66.736628]  item 173 key (22565015781376 192 3221225472) itemoff
12053 itemsize 24
[   66.736630]          block group used 0 chunk_objectid 256 flags 129
[   66.736633]  item 174 key (22568237006848 192 3221225472) itemoff
12029 itemsize 24
[   66.736635]          block group used 0 chunk_objectid 256 flags 129
[   66.736638]  item 175 key (22571458232320 192 3221225472) itemoff
12005 itemsize 24
[   66.736640]          block group used 0 chunk_objectid 256 flags 129
[   66.736644]  item 176 key (22574679457792 192 3221225472) itemoff
11981 itemsize 24
[   66.736646]          block group used 0 chunk_objectid 256 flags 129
[   66.736649]  item 177 key (22577900683264 192 3221225472) itemoff
11957 itemsize 24
[   66.736651]          block group used 0 chunk_objectid 256 flags 129
[   66.736654]  item 178 key (22581121908736 192 3221225472) itemoff
11933 itemsize 24
[   66.736656]          block group used 0 chunk_objectid 256 flags 129
[   66.736659]  item 179 key (22584343134208 192 3221225472) itemoff
11909 itemsize 24
[   66.736661]          block group used 0 chunk_objectid 256 flags 129
[   66.736664]  item 180 key (22587564359680 192 3221225472) itemoff
11885 itemsize 24
[   66.736666]          block group used 0 chunk_objectid 256 flags 129
[   66.736670]  item 181 key (22590785585152 192 3221225472) itemoff
11861 itemsize 24
[   66.736672]          block group used 0 chunk_objectid 256 flags 129
[   66.736675]  item 182 key (22594006810624 192 3221225472) itemoff
11837 itemsize 24
[   66.736677]          block group used 0 chunk_objectid 256 flags 129
[   66.736680]  item 183 key (22597228036096 192 3221225472) itemoff
11813 itemsize 24
[   66.736682]          block group used 0 chunk_objectid 256 flags 129
[   66.736685]  item 184 key (22600449261568 192 3221225472) itemoff
11789 itemsize 24
[   66.736687]          block group used 0 chunk_objectid 256 flags 129
[   66.736691]  item 185 key (22603670487040 192 3221225472) itemoff
11765 itemsize 24
[   66.736693]          block group used 0 chunk_objectid 256 flags 129
[   66.736696]  item 186 key (22606891712512 192 3221225472) itemoff
11741 itemsize 24
[   66.736698]          block group used 0 chunk_objectid 256 flags 129
[   66.736701]  item 187 key (22610112937984 192 3221225472) itemoff
11717 itemsize 24
[   66.736703]          block group used 0 chunk_objectid 256 flags 129
[   66.736706]  item 188 key (22613334163456 192 3221225472) itemoff
11693 itemsize 24
[   66.736708]          block group used 0 chunk_objectid 256 flags 129
[   66.736712]  item 189 key (22616555388928 192 3221225472) itemoff
11669 itemsize 24
[   66.736714]          block group used 0 chunk_objectid 256 flags 129
[   66.736717]  item 190 key (22619776614400 192 3221225472) itemoff
11645 itemsize 24
[   66.736719]          block group used 0 chunk_objectid 256 flags 129
[   66.736722]  item 191 key (22622997839872 192 3221225472) itemoff
11621 itemsize 24
[   66.736724]          block group used 0 chunk_objectid 256 flags 129
[   66.736727]  item 192 key (22626219065344 192 3221225472) itemoff
11597 itemsize 24
[   66.736729]          block group used 0 chunk_objectid 256 flags 129
[   66.736732]  item 193 key (22629440290816 192 3221225472) itemoff
11573 itemsize 24
[   66.736735]          block group used 0 chunk_objectid 256 flags 129
[   66.736738]  item 194 key (22632661516288 192 3221225472) itemoff
11549 itemsize 24
[   66.736740]          block group used 0 chunk_objectid 256 flags 129
[   66.736743]  item 195 key (22635882741760 192 3221225472) itemoff
11525 itemsize 24
[   66.736745]          block group used 0 chunk_objectid 256 flags 129
[   66.736748]  item 196 key (22639103967232 192 3221225472) itemoff
11501 itemsize 24
[   66.736750]          block group used 0 chunk_objectid 256 flags 129
[   66.736753]  item 197 key (22642325192704 192 3221225472) itemoff
11477 itemsize 24
[   66.736756]          block group used 0 chunk_objectid 256 flags 129
[   66.736759]  item 198 key (22645546418176 192 3221225472) itemoff
11453 itemsize 24
[   66.736761]          block group used 0 chunk_objectid 256 flags 129
[   66.736764]  item 199 key (22648767643648 192 3221225472) itemoff
11429 itemsize 24
[   66.736766]          block group used 0 chunk_objectid 256 flags 129
[   66.736769]  item 200 key (22651988869120 192 3221225472) itemoff
11405 itemsize 24
[   66.736771]          block group used 0 chunk_objectid 256 flags 129
[   66.736774]  item 201 key (22655210094592 192 3221225472) itemoff
11381 itemsize 24
[   66.736776]          block group used 0 chunk_objectid 256 flags 129
[   66.736779]  item 202 key (22658431320064 192 3221225472) itemoff
11357 itemsize 24
[   66.736782]          block group used 0 chunk_objectid 256 flags 129
[   66.736785]  item 203 key (22661652545536 192 3221225472) itemoff
11333 itemsize 24
[   66.736787]          block group used 0 chunk_objectid 256 flags 129
[   66.736790]  item 204 key (22664873771008 192 3221225472) itemoff
11309 itemsize 24
[   66.736792]          block group used 0 chunk_objectid 256 flags 129
[   66.736795]  item 205 key (22668094996480 192 3221225472) itemoff
11285 itemsize 24
[   66.736797]          block group used 0 chunk_objectid 256 flags 129
[   66.736800]  item 206 key (22671316221952 192 3221225472) itemoff
11261 itemsize 24
[   66.736802]          block group used 0 chunk_objectid 256 flags 129
[   66.736805]  item 207 key (22674537447424 192 3221225472) itemoff
11237 itemsize 24
[   66.736808]          block group used 0 chunk_objectid 256 flags 129
[   66.736811]  item 208 key (22677758672896 192 3221225472) itemoff
11213 itemsize 24
[   66.736813]          block group used 0 chunk_objectid 256 flags 129
[   66.736816]  item 209 key (22680979898368 192 3221225472) itemoff
11189 itemsize 24
[   66.736818]          block group used 0 chunk_objectid 256 flags 129
[   66.736821]  item 210 key (22684201123840 192 3221225472) itemoff
11165 itemsize 24
[   66.736823]          block group used 0 chunk_objectid 256 flags 129
[   66.736826]  item 211 key (22687422349312 192 3221225472) itemoff
11141 itemsize 24
[   66.736829]          block group used 0 chunk_objectid 256 flags 129
[   66.736832]  item 212 key (22690643574784 192 3221225472) itemoff
11117 itemsize 24
[   66.736834]          block group used 0 chunk_objectid 256 flags 129
[   66.736837]  item 213 key (22693864800256 192 3221225472) itemoff
11093 itemsize 24
[   66.736839]          block group used 0 chunk_objectid 256 flags 129
[   66.736842]  item 214 key (22697086025728 192 3221225472) itemoff
11069 itemsize 24
[   66.736844]          block group used 0 chunk_objectid 256 flags 129
[   66.736847]  item 215 key (22700307251200 192 3221225472) itemoff
11045 itemsize 24
[   66.736849]          block group used 0 chunk_objectid 256 flags 129
[   66.736853]  item 216 key (22703528476672 192 3221225472) itemoff
11021 itemsize 24
[   66.736855]          block group used 0 chunk_objectid 256 flags 129
[   66.736858]  item 217 key (22706749702144 192 3221225472) itemoff
10997 itemsize 24
[   66.736860]          block group used 0 chunk_objectid 256 flags 129
[   66.736863]  item 218 key (22709970927616 192 3221225472) itemoff
10973 itemsize 24
[   66.736865]          block group used 0 chunk_objectid 256 flags 129
[   66.736868]  item 219 key (22713192153088 192 3221225472) itemoff
10949 itemsize 24
[   66.736870]          block group used 0 chunk_objectid 256 flags 129
[   66.736874]  item 220 key (22716413378560 192 3221225472) itemoff
10925 itemsize 24
[   66.736876]          block group used 0 chunk_objectid 256 flags 129
[   66.736879]  item 221 key (22719634604032 192 3221225472) itemoff
10901 itemsize 24
[   66.736881]          block group used 0 chunk_objectid 256 flags 129
[   66.736884]  item 222 key (22722855829504 192 3221225472) itemoff
10877 itemsize 24
[   66.736886]          block group used 0 chunk_objectid 256 flags 129
[   66.736889]  item 223 key (22726077054976 192 3221225472) itemoff
10853 itemsize 24
[   66.736891]          block group used 0 chunk_objectid 256 flags 129
[   66.736895]  item 224 key (22729298280448 192 3221225472) itemoff
10829 itemsize 24
[   66.736897]          block group used 0 chunk_objectid 256 flags 129
[   66.736900]  item 225 key (22732519505920 192 3221225472) itemoff
10805 itemsize 24
[   66.736902]          block group used 0 chunk_objectid 256 flags 129
[   66.736905]  item 226 key (22735740731392 192 3221225472) itemoff
10781 itemsize 24
[   66.736907]          block group used 0 chunk_objectid 256 flags 129
[   66.736910]  item 227 key (22738961956864 192 3221225472) itemoff
10757 itemsize 24
[   66.736912]          block group used 0 chunk_objectid 256 flags 129
[   66.736915]  item 228 key (22742183182336 192 3221225472) itemoff
10733 itemsize 24
[   66.736917]          block group used 0 chunk_objectid 256 flags 129
[   66.736923] BTRFS error (device sdf): unable to find ref byte nr
22396565995520 parent 0 root 4  owner 1 offset 0
[   66.737023] ------------[ cut here ]------------
[   66.737025] BTRFS: Transaction aborted (error -2)
[   66.737084] WARNING: CPU: 1 PID: 637 at
/build/linux-hwe-jDoxDp/linux-hwe-4.18.0/fs/btrfs/extent-tree.c:6950
__btrfs_free_extent.isra.68+0x254/0xdd0 [btrfs]
[   66.737085] Modules linked in: bonding nls_iso8859_1
snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp
eeepc_wmi kvm_intel ppdev asus_wmi wmi_bmof sparse_keymap mxm_wmi kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
aesni_intel aes_x86_64 crypto_simd cryptd glue_helper intel_cstate
intel_rapl_perf snd_hda_codec_realtek input_leds snd_hda_codec_generic
joydev snd_hda_intel snd_hda_codec snd_hda_core parport_pc snd_hwdep
snd_pcm mei_me snd_timer mei snd soundcore mac_hid acpi_pad wmi
ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt nf_conntrack_ipv6
nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 xt_comment xt_multiport
xt_limit xt_tcpudp xt_addrtype ipt_MASQUERADE iptable_nat nf_nat_ipv4
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack ip6table_filter
sch_fq_codel ip6_tables
[   66.737178]  nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack nct6775 iptable_filter
bpfilter hwmon_vid coretemp lp parport ip_tables x_tables autofs4
btrfs xor zstd_compress raid6_pq libcrc32c hid_generic usbhid hid
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm
ipmi_devintf r8169 ahci ipmi_msghandler mii libahci video
[   66.737239] CPU: 1 PID: 637 Comm: btrfs-transacti Tainted: G
W         4.18.0-13-generic #14~18.04.1-Ubuntu
[   66.737241] Hardware name: System manufacturer System Product
Name/B150M-A, BIOS 3805 05/16/2018
[   66.737273] RIP: 0010:__btrfs_free_extent.isra.68+0x254/0xdd0 [btrfs]
[   66.737275] Code: 48 8b 45 90 48 8b 40 50 f0 48 0f ba a8 10 ce 00
00 02 0f 92 c0 84 c0 41 59 75 11 44 89 ee 48 c7 c7 f0 26 2c c0 e8 2c
41 c8 e9 <0f> 0b 48 8b 7d 90 b9 fe ff ff ff ba 26 1b 00 00 48 c7 c6 40
5c 2b
[   66.737355] RSP: 0018:ffffabd641fdfc60 EFLAGS: 00010282
[   66.737359] RAX: 0000000000000000 RBX: 0000145e9b5c4000 RCX: 0000000000000006
[   66.737361] RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffff93e2fd8964b0
[   66.737364] RBP: ffffabd641fdfd08 R08: 00000000000005cd R09: 0000000000000004
[   66.737366] R10: 0000000000000002 R11: 0000000000000001 R12: ffff93e2e2a20000
[   66.737369] R13: 00000000fffffffe R14: 0000000000000000 R15: ffff93e2df10f620
[   66.737372] FS:  0000000000000000(0000) GS:ffff93e2fd880000(0000)
knlGS:0000000000000000
[   66.737375] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.737378] CR2: 00007f59f30e7600 CR3: 000000036bc0a001 CR4: 00000000003606e0
[   66.737380] Call Trace:
[   66.737413]  ? cleanup_ref_head+0x446/0x5f0 [btrfs]
[   66.737460]  ? btrfs_merge_delayed_refs+0x2fa/0x360 [btrfs]
[   66.737492]  __btrfs_run_delayed_refs+0x37e/0xbf0 [btrfs]
[   66.737526]  btrfs_run_delayed_refs+0xf8/0x1b0 [btrfs]
[   66.737564]  btrfs_commit_transaction+0x42/0x8a0 [btrfs]
[   66.737596]  ? start_transaction+0xa0/0x3e0 [btrfs]
[   66.737630]  transaction_kthread+0x14b/0x170 [btrfs]
[   66.737636]  kthread+0x121/0x140
[   66.737667]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[   66.737673]  ? kthread_create_worker_on_cpu+0x70/0x70
[   66.737679]  ret_from_fork+0x35/0x40
[   66.737683] ---[ end trace 15cb60d2d3e26d48 ]---
[   66.737689] BTRFS: error (device sdf) in __btrfs_free_extent:6950:
errno=-2 No such entry
[   66.737769] BTRFS info (device sdf): forced readonly
[   66.737775] BTRFS: error (device sdf) in
btrfs_run_delayed_refs:3057: errno=-2 No such entry
[  242.863552] INFO: task btrfs-cleaner:636 blocked for more than 120 seconds.
[  242.863625]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  242.863694] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.863766] btrfs-cleaner   D    0   636      2 0x80000000
[  242.863772] Call Trace:
[  242.863786]  __schedule+0x2b7/0x880
[  242.863794]  schedule+0x2c/0x80
[  242.863855]  btrfs_tree_lock+0x13b/0x220 [btrfs]
[  242.863862]  ? wait_woken+0x80/0x80
[  242.863902]  btrfs_alloc_tree_block+0x17e/0x4b0 [btrfs]
[  242.863935]  __btrfs_cow_block+0x119/0x550 [btrfs]
[  242.863967]  btrfs_cow_block+0xdf/0x1a0 [btrfs]
[  242.863998]  btrfs_search_slot+0x33b/0x9e0 [btrfs]
[  242.864007]  ? kmem_cache_alloc+0x1a1/0x1d0
[  242.864056]  btrfs_update_device+0x77/0x1d0 [btrfs]
[  242.864102]  btrfs_remove_chunk+0x2a4/0x8c0 [btrfs]
[  242.864140]  btrfs_delete_unused_bgs+0x34e/0x3f0 [btrfs]
[  242.864179]  cleaner_kthread+0x148/0x170 [btrfs]
[  242.864186]  kthread+0x121/0x140
[  242.864222]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
[  242.864228]  ? kthread_create_worker_on_cpu+0x70/0x70
[  242.864234]  ret_from_fork+0x35/0x40
[  242.864240] INFO: task btrfs-transacti:637 blocked for more than 120 seconds.
[  242.864308]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  242.864376] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.864447] btrfs-transacti D    0   637      2 0x80000000
[  242.864451] Call Trace:
[  242.864459]  __schedule+0x2b7/0x880
[  242.864465]  ? tracing_record_taskinfo+0x13/0xb0
[  242.864471]  schedule+0x2c/0x80
[  242.864511]  btrfs_cleanup_transaction+0x51e/0x550 [btrfs]
[  242.864518]  ? try_to_wake_up+0x59/0x450
[  242.864557]  ? start_transaction+0xa0/0x3e0 [btrfs]
[  242.864562]  ? wait_woken+0x80/0x80
[  242.864598]  transaction_kthread+0x15b/0x170 [btrfs]
[  242.864604]  kthread+0x121/0x140
[  242.864636]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[  242.864642]  ? kthread_create_worker_on_cpu+0x70/0x70
[  242.864647]  ret_from_fork+0x35/0x40
[  363.698813] INFO: task btrfs-cleaner:636 blocked for more than 120 seconds.
[  363.698891]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  363.698960] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.699031] btrfs-cleaner   D    0   636      2 0x80000000
[  363.699037] Call Trace:
[  363.699051]  __schedule+0x2b7/0x880
[  363.699059]  schedule+0x2c/0x80
[  363.699115]  btrfs_tree_lock+0x13b/0x220 [btrfs]
[  363.699122]  ? wait_woken+0x80/0x80
[  363.699160]  btrfs_alloc_tree_block+0x17e/0x4b0 [btrfs]
[  363.699191]  __btrfs_cow_block+0x119/0x550 [btrfs]
[  363.699219]  btrfs_cow_block+0xdf/0x1a0 [btrfs]
[  363.699247]  btrfs_search_slot+0x33b/0x9e0 [btrfs]
[  363.699256]  ? kmem_cache_alloc+0x1a1/0x1d0
[  363.699303]  btrfs_update_device+0x77/0x1d0 [btrfs]
[  363.699347]  btrfs_remove_chunk+0x2a4/0x8c0 [btrfs]
[  363.699384]  btrfs_delete_unused_bgs+0x34e/0x3f0 [btrfs]
[  363.699421]  cleaner_kthread+0x148/0x170 [btrfs]
[  363.699428]  kthread+0x121/0x140
[  363.699460]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
[  363.699467]  ? kthread_create_worker_on_cpu+0x70/0x70
[  363.699472]  ret_from_fork+0x35/0x40
[  363.699479] INFO: task btrfs-transacti:637 blocked for more than 120 seconds.
[  363.699546]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  363.699615] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.699685] btrfs-transacti D    0   637      2 0x80000000
[  363.699690] Call Trace:
[  363.699697]  __schedule+0x2b7/0x880
[  363.699703]  ? tracing_record_taskinfo+0x13/0xb0
[  363.699710]  schedule+0x2c/0x80
[  363.699747]  btrfs_cleanup_transaction+0x51e/0x550 [btrfs]
[  363.699754]  ? try_to_wake_up+0x59/0x450
[  363.699790]  ? start_transaction+0xa0/0x3e0 [btrfs]
[  363.699796]  ? wait_woken+0x80/0x80
[  363.699829]  transaction_kthread+0x15b/0x170 [btrfs]
[  363.699836]  kthread+0x121/0x140
[  363.699865]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[  363.699871]  ? kthread_create_worker_on_cpu+0x70/0x70
[  363.699877]  ret_from_fork+0x35/0x40
[  484.541242] INFO: task btrfs-cleaner:636 blocked for more than 120 seconds.
[  484.541316]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  484.541384] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  484.541455] btrfs-cleaner   D    0   636      2 0x80000000
[  484.541462] Call Trace:
[  484.541476]  __schedule+0x2b7/0x880
[  484.541483]  schedule+0x2c/0x80
[  484.541545]  btrfs_tree_lock+0x13b/0x220 [btrfs]
[  484.541552]  ? wait_woken+0x80/0x80
[  484.541592]  btrfs_alloc_tree_block+0x17e/0x4b0 [btrfs]
[  484.541625]  __btrfs_cow_block+0x119/0x550 [btrfs]
[  484.541657]  btrfs_cow_block+0xdf/0x1a0 [btrfs]
[  484.541688]  btrfs_search_slot+0x33b/0x9e0 [btrfs]
[  484.541697]  ? kmem_cache_alloc+0x1a1/0x1d0
[  484.541747]  btrfs_update_device+0x77/0x1d0 [btrfs]
[  484.541794]  btrfs_remove_chunk+0x2a4/0x8c0 [btrfs]
[  484.541832]  btrfs_delete_unused_bgs+0x34e/0x3f0 [btrfs]
[  484.541871]  cleaner_kthread+0x148/0x170 [btrfs]
[  484.541878]  kthread+0x121/0x140
[  484.541914]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
[  484.541920]  ? kthread_create_worker_on_cpu+0x70/0x70
[  484.541926]  ret_from_fork+0x35/0x40
[  484.541932] INFO: task btrfs-transacti:637 blocked for more than 120 seconds.
[  484.542000]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  484.542068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  484.542138] btrfs-transacti D    0   637      2 0x80000000
[  484.542143] Call Trace:
[  484.542151]  __schedule+0x2b7/0x880
[  484.542157]  ? tracing_record_taskinfo+0x13/0xb0
[  484.542163]  schedule+0x2c/0x80
[  484.542203]  btrfs_cleanup_transaction+0x51e/0x550 [btrfs]
[  484.542211]  ? try_to_wake_up+0x59/0x450
[  484.542250]  ? start_transaction+0xa0/0x3e0 [btrfs]
[  484.542255]  ? wait_woken+0x80/0x80
[  484.542291]  transaction_kthread+0x15b/0x170 [btrfs]
[  484.542297]  kthread+0x121/0x140
[  484.542330]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[  484.542336]  ? kthread_create_worker_on_cpu+0x70/0x70
[  484.542341]  ret_from_fork+0x35/0x40
[  605.343679] INFO: task btrfs-cleaner:636 blocked for more than 120 seconds.
[  605.343753]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  605.345663] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  605.347572] btrfs-cleaner   D    0   636      2 0x80000000
[  605.347578] Call Trace:
[  605.347622]  __schedule+0x2b7/0x880
[  605.347632]  schedule+0x2c/0x80
[  605.347696]  btrfs_tree_lock+0x13b/0x220 [btrfs]
[  605.347722]  ? wait_woken+0x80/0x80
[  605.347778]  btrfs_alloc_tree_block+0x17e/0x4b0 [btrfs]
[  605.347832]  __btrfs_cow_block+0x119/0x550 [btrfs]
[  605.347883]  btrfs_cow_block+0xdf/0x1a0 [btrfs]
[  605.347926]  btrfs_search_slot+0x33b/0x9e0 [btrfs]
[  605.347937]  ? kmem_cache_alloc+0x1a1/0x1d0
[  605.347994]  btrfs_update_device+0x77/0x1d0 [btrfs]
[  605.348058]  btrfs_remove_chunk+0x2a4/0x8c0 [btrfs]
[  605.348119]  btrfs_delete_unused_bgs+0x34e/0x3f0 [btrfs]
[  605.348169]  cleaner_kthread+0x148/0x170 [btrfs]
[  605.348178]  kthread+0x121/0x140
[  605.348217]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
[  605.348228]  ? kthread_create_worker_on_cpu+0x70/0x70
[  605.348236]  ret_from_fork+0x35/0x40
[  605.348245] INFO: task btrfs-transacti:637 blocked for more than 120 seconds.
[  605.349861]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  605.350355] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  605.350851] btrfs-transacti D    0   637      2 0x80000000
[  605.350853] Call Trace:
[  605.350855]  __schedule+0x2b7/0x880
[  605.350857]  ? tracing_record_taskinfo+0x13/0xb0
[  605.350859]  schedule+0x2c/0x80
[  605.350868]  btrfs_cleanup_transaction+0x51e/0x550 [btrfs]
[  605.350870]  ? try_to_wake_up+0x59/0x450
[  605.350880]  ? start_transaction+0xa0/0x3e0 [btrfs]
[  605.350881]  ? wait_woken+0x80/0x80
[  605.350890]  transaction_kthread+0x15b/0x170 [btrfs]
[  605.350891]  kthread+0x121/0x140
[  605.350899]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[  605.350901]  ? kthread_create_worker_on_cpu+0x70/0x70
[  605.350902]  ret_from_fork+0x35/0x40
[  726.119549] INFO: task btrfs-cleaner:636 blocked for more than 120 seconds.
[  726.121517]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  726.123508] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  726.124825] btrfs-cleaner   D    0   636      2 0x80000000
[  726.124826] Call Trace:
[  726.124831]  __schedule+0x2b7/0x880
[  726.124833]  schedule+0x2c/0x80
[  726.124850]  btrfs_tree_lock+0x13b/0x220 [btrfs]
[  726.124852]  ? wait_woken+0x80/0x80
[  726.124861]  btrfs_alloc_tree_block+0x17e/0x4b0 [btrfs]
[  726.124869]  __btrfs_cow_block+0x119/0x550 [btrfs]
[  726.124876]  btrfs_cow_block+0xdf/0x1a0 [btrfs]
[  726.124883]  btrfs_search_slot+0x33b/0x9e0 [btrfs]
[  726.124886]  ? kmem_cache_alloc+0x1a1/0x1d0
[  726.124897]  btrfs_update_device+0x77/0x1d0 [btrfs]
[  726.124908]  btrfs_remove_chunk+0x2a4/0x8c0 [btrfs]
[  726.124917]  btrfs_delete_unused_bgs+0x34e/0x3f0 [btrfs]
[  726.124926]  cleaner_kthread+0x148/0x170 [btrfs]
[  726.124928]  kthread+0x121/0x140
[  726.124937]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
[  726.124938]  ? kthread_create_worker_on_cpu+0x70/0x70
[  726.124940]  ret_from_fork+0x35/0x40
[  726.124942] INFO: task btrfs-transacti:637 blocked for more than 120 seconds.
[  726.125451]       Tainted: G        W         4.18.0-13-generic
#14~18.04.1-Ubuntu
[  726.125963] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  726.126479] btrfs-transacti D    0   637      2 0x80000000
[  726.126480] Call Trace:
[  726.126482]  __schedule+0x2b7/0x880
[  726.126484]  ? tracing_record_taskinfo+0x13/0xb0
[  726.126486]  schedule+0x2c/0x80
[  726.126495]  btrfs_cleanup_transaction+0x51e/0x550 [btrfs]
[  726.126497]  ? try_to_wake_up+0x59/0x450
[  726.126506]  ? start_transaction+0xa0/0x3e0 [btrfs]
[  726.126507]  ? wait_woken+0x80/0x80
[  726.126516]  transaction_kthread+0x15b/0x170 [btrfs]
[  726.126517]  kthread+0x121/0x140
[  726.126525]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[  726.126526]  ? kthread_create_worker_on_cpu+0x70/0x70
[  726.126528]  ret_from_fork+0x35/0x40

After some time I see more errors in dmesg:

[81010.451068] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81010.484457] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81010.484463] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81010.485344] BTRFS critical (device sdf): unable to find logical
144149573654306816 length 4096
[81010.485402] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81010.486237] BTRFS info (device sdf): no csum found for inode
13730923 start 1619419136
[81010.487260] BTRFS critical (device sdf): unable to find logical
144149573654306816 length 4096
[81010.487829] BTRFS critical (device sdf): unable to find logical
144149573654306816 length 4096
[81018.175523] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81018.175529] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.176332] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.177151] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81018.177155] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.177882] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.179645] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81018.179650] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.180239] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.180679] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81018.180681] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.181053] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.181440] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81018.181442] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81018.181779] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.023350] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81464.023357] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.023968] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.024500] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81464.024504] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.025100] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.026150] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81464.026155] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.026638] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.027097] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81464.027101] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.027524] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.027948] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81464.027952] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81464.028385] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.700173] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81685.700179] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.700525] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.700840] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81685.700842] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.701127] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.702415] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81685.702420] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.702669] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.703231] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81685.703235] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.703433] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.703606] BTRFS info (device sdf): no csum found for inode
13730923 start 1619410944
[81685.703608] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096
[81685.703772] BTRFS critical (device sdf): unable to find logical
144149573654298624 length 4096

Any help is appreciated.

Best regards,
Artem Mygaiev
