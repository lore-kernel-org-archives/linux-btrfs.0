Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sy3aus01on0079.outbound.protection.outlook.com ([104.47.117.79]:33856
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751589AbdIRIzd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 04:55:33 -0400
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at fs/btrfs/extent_io.c:1989
Date: Mon, 18 Sep 2017 08:55:29 +0000
Message-ID: <MEXPR01MB2168C2FE0ABD1B78F120044E9E630@MEXPR01MB2168.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi
 I have a system that crashed during a defrag, upon reboot I got the following trace while resuming the defrag.
Filesystem is BTRFS Raid1 on lvm+cache, kernel 4.13.2
Check --repair gives lots of warnings about parent transid verify failed, but otherwise completes without issue.

Ran scrub which seems to have fixed most of the issues without crashing:

scrub status for d844164a-239e-4f37-9126-d3b2f3ab72be
        scrub started at Mon Sep 18 15:59:05 2017 and finished after 02:04:00
        total bytes scrubbed: 2.22TiB with 22890 errors
        error details: verify=1078 csum=21812
        corrected errors: 22886, uncorrectable errors: 4, unverified errors: 0

I'll see how it goes when I use rsync to verify from the other backup.

Thanks,
Paul.

[   52.687705] BTRFS error (device dm-15): parent transid verify failed on 6822688718848 wanted 1044475 found 1044411
[   52.688346] BTRFS info (device dm-15): read error corrected: ino 0 off 6822688718848 (dev /dev/mapper/lvmB-backup--b sector 2340415488)
[   52.688401] BTRFS info (device dm-15): read error corrected: ino 0 off 6822688722944 (dev /dev/mapper/lvmB-backup--b sector 2340415496)
[   52.688451] BTRFS info (device dm-15): read error corrected: ino 0 off 6822688727040 (dev /dev/mapper/lvmB-backup--b sector 2340415504)
[   52.688501] BTRFS info (device dm-15): read error corrected: ino 0 off 6822688731136 (dev /dev/mapper/lvmB-backup--b sector 2340415512)
[   53.332383] BTRFS error (device dm-15): parent transid verify failed on 6522612940800 wanted 1044486 found 1042732
[   53.332668] BTRFS info (device dm-15): read error corrected: ino 0 off 6522612940800 (dev /dev/mapper/lvmB-backup--b sector 491844480)
[   53.332732] BTRFS info (device dm-15): read error corrected: ino 0 off 6522612944896 (dev /dev/mapper/lvmB-backup--b sector 491844488)
[   53.332794] BTRFS info (device dm-15): read error corrected: ino 0 off 6522612948992 (dev /dev/mapper/lvmB-backup--b sector 491844496)
[   53.332846] BTRFS info (device dm-15): read error corrected: ino 0 off 6522612953088 (dev /dev/mapper/lvmB-backup--b sector 491844504)
[   53.395581] BTRFS error (device dm-15): parent transid verify failed on 6823548452864 wanted 1044475 found 1044413
[   53.395979] BTRFS info (device dm-15): read error corrected: ino 0 off 6823548452864 (dev /dev/mapper/lvmB-backup--b sector 2342094656)
[   53.396054] BTRFS info (device dm-15): read error corrected: ino 0 off 6823548456960 (dev /dev/mapper/lvmB-backup--b sector 2342094664)
[   53.527429] BTRFS error (device dm-15): parent transid verify failed on 6823548583936 wanted 1044475 found 1044413
[   55.516066] br0: port 1(eth0) entered forwarding state
[   55.516068] br0: topology change detected, propagating
[   55.516101] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[  126.354423] BTRFS error (device dm-15): parent transid verify failed on 6522613661696 wanted 1044486 found 1043710
[  126.354696] repair_io_failure: 6 callbacks suppressed
[  126.354698] BTRFS info (device dm-15): read error corrected: ino 0 off 6522613661696 (dev /dev/mapper/lvmB-backup--b sector 491845888)
[  126.354765] BTRFS info (device dm-15): read error corrected: ino 0 off 6522613665792 (dev /dev/mapper/lvmB-backup--b sector 491845896)
[  126.354824] BTRFS info (device dm-15): read error corrected: ino 0 off 6522613669888 (dev /dev/mapper/lvmB-backup--b sector 491845904)
[  126.354886] BTRFS info (device dm-15): read error corrected: ino 0 off 6522613673984 (dev /dev/mapper/lvmB-backup--b sector 491845912)
[  126.484340] BTRFS error (device dm-15): parent transid verify failed on 6517401976832 wanted 1044482 found 1044204
[  126.484890] BTRFS info (device dm-15): read error corrected: ino 0 off 6517401976832 (dev /dev/mapper/lvmB-backup--b sector 798336768)
[  126.484939] BTRFS info (device dm-15): read error corrected: ino 0 off 6517401980928 (dev /dev/mapper/lvmB-backup--b sector 798336776)
[  126.484989] BTRFS info (device dm-15): read error corrected: ino 0 off 6517401985024 (dev /dev/mapper/lvmB-backup--b sector 798336784)
[  126.485040] BTRFS info (device dm-15): read error corrected: ino 0 off 6517401989120 (dev /dev/mapper/lvmB-backup--b sector 798336792)
[  126.667061] BTRFS error (device dm-15): parent transid verify failed on 6523036008448 wanted 1044486 found 1044206
[  126.667340] BTRFS info (device dm-15): read error corrected: ino 0 off 6523036008448 (dev /dev/mapper/lvm-backup--a sector 375252800)
[  126.667377] BTRFS info (device dm-15): read error corrected: ino 0 off 6523036012544 (dev /dev/mapper/lvm-backup--a sector 375252808)
[  126.828898] BTRFS error (device dm-15): parent transid verify failed on 6522547240960 wanted 1044486 found 1044206
[  126.829325] BTRFS error (device dm-15): parent transid verify failed on 6522547257344 wanted 1044486 found 1043052
[  126.831141] BTRFS error (device dm-15): parent transid verify failed on 6522547650560 wanted 1044486 found 1044206
[  126.846967] BTRFS error (device dm-15): parent transid verify failed on 6522470612992 wanted 1044457 found 1044206
[  127.189398] BTRFS error (device dm-15): parent transid verify failed on 4594090442752 wanted 1044480 found 1044432
[  127.189899] BTRFS error (device dm-15): parent transid verify failed on 4594090475520 wanted 1044480 found 1039157
[  127.190503] BTRFS error (device dm-15): parent transid verify failed on 4594090491904 wanted 1044480 found 1044432
[  131.372119] verify_parent_transid: 80 callbacks suppressed
[  131.372122] BTRFS error (device dm-15): parent transid verify failed on 6815879430144 wanted 1044473 found 1044169
[  131.373039] repair_io_failure: 350 callbacks suppressed
[  131.373041] BTRFS info (device dm-15): read error corrected: ino 0 off 6815879430144 (dev /dev/mapper/lvmB-backup--b sector 2327116096)
[  131.373176] BTRFS info (device dm-15): read error corrected: ino 0 off 6815879434240 (dev /dev/mapper/lvmB-backup--b sector 2327116104)
[  131.373302] BTRFS info (device dm-15): read error corrected: ino 0 off 6815879438336 (dev /dev/mapper/lvmB-backup--b sector 2327116112)
[  131.373438] BTRFS info (device dm-15): read error corrected: ino 0 off 6815879442432 (dev /dev/mapper/lvmB-backup--b sector 2327116120)
[  131.378081] BTRFS error (device dm-15): parent transid verify failed on 4594106400768 wanted 1044480 found 1039472
[  131.378404] BTRFS info (device dm-15): read error corrected: ino 0 off 4594106400768 (dev /dev/mapper/lvm-backup--a sector 387762752)
[  131.378441] BTRFS info (device dm-15): read error corrected: ino 0 off 4594106404864 (dev /dev/mapper/lvm-backup--a sector 387762760)
[  131.378577] BTRFS info (device dm-15): read error corrected: ino 0 off 4594106408960 (dev /dev/mapper/lvm-backup--a sector 387762768)
[  131.378614] BTRFS info (device dm-15): read error corrected: ino 0 off 4594106413056 (dev /dev/mapper/lvm-backup--a sector 387762776)
[  131.468158] BTRFS error (device dm-15): parent transid verify failed on 6516948828160 wanted 1044481 found 1044069
[  131.468271] BTRFS error (device dm-15): parent transid verify failed on 6516948795392 wanted 1044481 found 1039285
[  131.469242] BTRFS info (device dm-15): read error corrected: ino 0 off 6516948828160 (dev /dev/mapper/lvm-backup--a sector 315129280)
[  131.469260] BTRFS info (device dm-15): read error corrected: ino 0 off 6516948795392 (dev /dev/mapper/lvm-backup--a sector 315129216)
[  131.469417] BTRFS error (device dm-15): parent transid verify failed on 6516948811776 wanted 1044481 found 1044069
[  131.510220] BTRFS error (device dm-15): parent transid verify failed on 6517287829504 wanted 1044482 found 1043368
[  131.510966] BTRFS error (device dm-15): parent transid verify failed on 6517287862272 wanted 1044482 found 1043368
[  131.756488] BTRFS error (device dm-15): parent transid verify failed on 4592607641600 wanted 1044479 found 1006875
[  131.801195] BTRFS error (device dm-15): parent transid verify failed on 4592608034816 wanted 1044479 found 248480
[  131.895363] BTRFS error (device dm-15): parent transid verify failed on 6523168260096 wanted 1044486 found 1044169
[  136.376338] repair_io_failure: 86 callbacks suppressed
[  136.376343] BTRFS info (device dm-15): read error corrected: ino 0 off 6517887107072 (dev /dev/mapper/lvmB-backup--b sector 178527296)
[  136.376464] BTRFS info (device dm-15): read error corrected: ino 0 off 6517887111168 (dev /dev/mapper/lvmB-backup--b sector 178527304)
[  136.376559] BTRFS info (device dm-15): read error corrected: ino 0 off 6517887115264 (dev /dev/mapper/lvmB-backup--b sector 178527312)
[  136.376659] BTRFS info (device dm-15): read error corrected: ino 0 off 6517887119360 (dev /dev/mapper/lvmB-backup--b sector 178527320)
[  174.761517] BTRFS warning (device dm-15): csum failed root 7692 ino 534939 off 5639217152 csum 0xdbbb090f expected csum 0x74d6a9b2 mirror 0
[  174.761800] BTRFS warning (device dm-15): csum failed root 7692 ino 534939 off 5639217152 csum 0xdbbb090f expected csum 0x74d6a9b2 mirror 0
[  174.761838] BTRFS warning (device dm-15): csum failed root 7692 ino 534939 off 5639217152 csum 0xdbbb090f expected csum 0x74d6a9b2 mirror 0
[  174.761880] BTRFS warning (device dm-15): csum failed root 7692 ino 534939 off 5639217152 csum 0xdbbb090f expected csum 0x74d6a9b2 mirror 0
[  174.761924] BTRFS warning (device dm-15): csum failed root 7692 ino 534939 off 5639217152 csum 0xdbbb090f expected csum 0x74d6a9b2 mirror 0
[  174.761986] ------------[ cut here ]------------
[  174.761987] kernel BUG at fs/btrfs/extent_io.c:1989!
[  174.761989] invalid opcode: 0000 [#1] SMP
[  174.762034] Modules linked in: cls_u32 sch_htb sch_sfq nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_sane nf_conntrack_sip ts_kmp nf_conntrack_amanda nf_conntrack_snmp nf_conntrack_h323 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_ftp nf_conntrack_irc xt_NETMAP xt_TCPMSS xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
[  174.762144]  nf_nat
[  174.762145] ------------[ cut here ]------------
[  174.762145] kernel BUG at fs/btrfs/extent_io.c:1989!
[  174.762267] ------------[ cut here ]------------
[  174.762268] kernel BUG at fs/btrfs/extent_io.c:1989!
[  174.762334] ------------[ cut here ]------------
[  174.762335] kernel BUG at fs/btrfs/extent_io.c:1989!
[  174.762487]  iptable_filter ip_tables nfsd auth_rpcgss oid_registry nfs_acl binfmt_misc dm_cache_smq dm_cache dm_persistent_data dm_bufio dm_bio_prison k10temp intel_powerclamp coretemp pcbc hwmon_vid iTCO_wdt iTCO_vendor_support aesni_intel crypto_simd cryptd glue_helper pcspkr lpc_ich i2c_i801 mfd_core xts aes_x86_64 cbc sha512_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ixgb macvlan igb dca i2c_algo_bit e1000 atl1c fuse nfs lockd grace sunrpc dm_mirror dm_region_hash dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration xhci_plat_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox megaraid_mm megaraid mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix
[  174.762629]  usbhid ahci libahci xhci_pci r8169 ehci_pci xhci_hcd mii ehci_hcd
[  174.762682] CPU: 5 PID: 6683 Comm: kworker/u16:22 Not tainted 4.13.2-gentoo #5
[  174.762730] Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 4101 05/09/2013
[  174.762786] Workqueue: btrfs-endio btrfs_endio_helper
[  174.762833] task: ffff8803e315d240 task.stack: ffffc900008c4000
[  174.762883] RIP: 0010:repair_io_failure+0x1b5/0x200
[  174.762930] RSP: 0018:ffffc900008c7c78 EFLAGS: 00010246
[  174.762978] RAX: ffff8803b71ba480 RBX: 0000000000000000 RCX: 0000000000001000
[  174.763027] RDX: 0000000000000000 RSI: 000000000008299b RDI: ffff88040b124000
[  174.763075] RBP: ffffc900008c7cc8 R08: 00000002d14fa000 R09: ffffea000b182d40
[  174.763123] R10: ffffc900008c7b40 R11: 0000000000000000 R12: 0000000000000000
[  174.763171] R13: ffff8802e5d29628 R14: ffff88040b124000 R15: ffffea000b182d40
[  174.763220] FS:  0000000000000000(0000) GS:ffff88041ed40000(0000) knlGS:0000000000000000
[  174.763269] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  174.763316] CR2: 00000000005226e8 CR3: 0000000001a0a000 CR4: 00000000001406a0
[  174.763364] Call Trace:
[  174.763412]  ? get_chunk_map+0x39/0xd0
[  174.763460]  clean_io_failure+0x127/0x140
[  174.763507]  end_bio_extent_readpage+0x248/0x4c0
[  174.763556]  bio_endio+0x83/0x90
[  174.763604]  end_workqueue_fn+0x38/0x40
[  174.763651]  btrfs_worker_helper+0x191/0x1c0
[  174.763698]  btrfs_endio_helper+0x9/0x10
[  174.763746]  process_one_work+0x1b3/0x350
[  174.763794]  worker_thread+0x42/0x3e0
[  174.763841]  kthread+0x11a/0x130
[  174.763888]  ? process_one_work+0x350/0x350
[  174.763936]  ? kthread_create_on_node+0x40/0x40
[  174.763993]  ret_from_fork+0x22/0x30
[  174.764056] Code: 5f 44 e9 18 ff ff ff 48 8b 43 30 4d 89 f9 48 c7 c6 a8 2c 97 81 4c 89 ef 48 8b 4d b0 48 8b 55 b8 4c 8d 40 10 e8 7d 10 fb ff eb 8d <0f> 0b be 01 00 00 00 4c 89 ef 41 be fb ff ff ff e8 86 17 05 00
[  174.764146] RIP: repair_io_failure+0x1b5/0x200 RSP: ffffc900008c7c78
[  174.764195] invalid opcode: 0000 [#2] SMP
[  174.764211] ---[ end trace 4dcb71dfc5702cb7 ]---
[  174.764314] Modules linked in: cls_u32 sch_htb sch_sfq nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_sane nf_conntrack_sip ts_kmp nf_conntrack_amanda nf_conntrack_snmp nf_conntrack_h323 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_ftp nf_conntrack_irc xt_NETMAP xt_TCPMSS xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
[  174.764469]  nf_nat iptable_filter ip_tables nfsd auth_rpcgss oid_registry nfs_acl binfmt_misc dm_cache_smq dm_cache dm_persistent_data dm_bufio dm_bio_prison k10temp intel_powerclamp coretemp pcbc hwmon_vid iTCO_wdt iTCO_vendor_support aesni_intel crypto_simd cryptd glue_helper pcspkr lpc_ich i2c_i801 mfd_core xts aes_x86_64 cbc sha512_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ixgb macvlan igb dca i2c_algo_bit e1000 atl1c fuse nfs lockd grace sunrpc dm_mirror dm_region_hash dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration xhci_plat_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox megaraid_mm megaraid mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd
[  174.764628]  pata_mpiix usbhid ahci libahci xhci_pci r8169 ehci_pci xhci_hcd mii ehci_hcd
[  174.764632] CPU: 1 PID: 6673 Comm: kworker/u16:16 Tainted: G      D         4.13.2-gentoo #5
[  174.764633] Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 4101 05/09/2013
[  174.764634] Workqueue: btrfs-endio btrfs_endio_helper
[  174.764635] task: ffff88040cbd3040 task.stack: ffffc9000045c000
[  174.764636] RIP: 0010:repair_io_failure+0x1b5/0x200
[  174.764637] RSP: 0018:ffffc9000045fc78 EFLAGS: 00010246
[  174.764637] RAX: ffff8803dfd670c0 RBX: 0000000000000000 RCX: 0000000000001000
[  174.764638] RDX: 0000000000001000 RSI: 000000000008299b RDI: ffff88040b124000
[  174.764639] RBP: ffffc9000045fcc8 R08: 00000002d14fa000 R09: ffffea000b182d80
[  174.764640] R10: ffffc9000045fb40 R11: 0000000000000000 R12: 0000000000001000
[  174.764640] R13: ffff8802e5d29628 R14: ffff88040b124000 R15: ffffea000b182d80
[  174.764641] FS:  0000000000000000(0000) GS:ffff88041ec40000(0000) knlGS:0000000000000000
[  174.764641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  174.764642] CR2: 00007f0df9020000 CR3: 0000000001a0a000 CR4: 00000000001406a0
[  174.764643] Call Trace:
[  174.764644]  ? get_chunk_map+0x39/0xd0
[  174.764645]  clean_io_failure+0x127/0x140
[  174.764646]  end_bio_extent_readpage+0x248/0x4c0
[  174.764647]  bio_endio+0x83/0x90
[  174.764649]  end_workqueue_fn+0x38/0x40
[  174.764650]  btrfs_worker_helper+0x191/0x1c0
[  174.764651]  btrfs_endio_helper+0x9/0x10
[  174.764653]  process_one_work+0x1b3/0x350
[  174.764653]  worker_thread+0x42/0x3e0
[  174.764655]  kthread+0x11a/0x130
[  174.764655]  ? process_one_work+0x350/0x350
[  174.764657]  ? kthread_create_on_node+0x40/0x40
[  174.764658]  ret_from_fork+0x22/0x30
[  174.764659] Code: 5f 44 e9 18 ff ff ff 48 8b 43 30 4d 89 f9 48 c7 c6 a8 2c 97 81 4c 89 ef 48 8b 4d b0 48 8b 55 b8 4c 8d 40 10 e8 7d 10 fb ff eb 8d <0f> 0b be 01 00 00 00 4c 89 ef 41 be fb ff ff ff e8 86 17 05 00
[  174.764672] RIP: repair_io_failure+0x1b5/0x200 RSP: ffffc9000045fc78
[  174.764673] invalid opcode: 0000 [#3] SMP
[  174.764674] Modules linked in: cls_u32 sch_htb sch_sfq nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_sane nf_conntrack_sip ts_kmp
[  174.764677] ---[ end trace 4dcb71dfc5702cb8 ]---
[  174.764677]  nf_conntrack_amanda nf_conntrack_snmp nf_conntrack_h323 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_ftp nf_conntrack_irc xt_NETMAP xt_TCPMSS xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd auth_rpcgss oid_registry nfs_acl binfmt_misc dm_cache_smq dm_cache dm_persistent_data
[  174.764694]  dm_bufio dm_bio_prison k10temp intel_powerclamp coretemp pcbc hwmon_vid iTCO_wdt iTCO_vendor_support aesni_intel crypto_simd cryptd glue_helper pcspkr lpc_ich i2c_i801 mfd_core xts aes_x86_64 cbc sha512_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ixgb macvlan igb dca i2c_algo_bit e1000 atl1c fuse nfs lockd grace sunrpc dm_mirror dm_region_hash dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration xhci_plat_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox megaraid_mm megaraid mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix usbhid ahci libahci xhci_pci r8169 ehci_pci xhci_hcd mii ehci_hcd
[  174.764718] CPU: 3 PID: 53 Comm: kworker/u16:2 Tainted: G      D         4.13.2-gentoo #5
[  174.764718] Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 4101 05/09/2013
[  174.764720] Workqueue: btrfs-endio btrfs_endio_helper
[  174.764721] task: ffff88040cb62ec0 task.stack: ffffc900001f4000
[  174.764723] RIP: 0010:repair_io_failure+0x1b5/0x200
[  174.764724] RSP: 0018:ffffc900001f7c78 EFLAGS: 00010246
[  174.764725] RAX: ffff8802e0013fc0 RBX: 0000000000000000 RCX: 0000000000001000
[  174.764726] RDX: 0000000000002000 RSI: 000000000008299b RDI: ffff88040b124000
[  174.764727] RBP: ffffc900001f7cc8 R08: 00000002d14fa000 R09: ffffea000b182dc0
[  174.764727] R10: ffffc900001f7c18 R11: 0000000000000000 R12: 0000000000002000
[  174.764728] R13: ffff8802e5d29628 R14: ffff88040b124000 R15: ffffea000b182dc0
[  174.764729] FS:  0000000000000000(0000) GS:ffff88041ecc0000(0000) knlGS:0000000000000000
[  174.764730] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  174.764731] CR2: 0000000000523368 CR3: 0000000001a0a000 CR4: 00000000001406a0
[  174.764731] Call Trace:
[  174.764733]  ? get_chunk_map+0x39/0xd0
[  174.764735]  clean_io_failure+0x127/0x140
[  174.764736]  end_bio_extent_readpage+0x248/0x4c0
[  174.764738]  bio_endio+0x83/0x90
[  174.764739]  end_workqueue_fn+0x38/0x40
[  174.764740]  btrfs_worker_helper+0x191/0x1c0
[  174.764742]  btrfs_endio_helper+0x9/0x10
[  174.764743]  process_one_work+0x1b3/0x350
[  174.764744]  worker_thread+0x42/0x3e0
[  174.764746]  kthread+0x11a/0x130
[  174.764747]  ? process_one_work+0x350/0x350
[  174.764748]  ? kthread_create_on_node+0x40/0x40
[  174.764750]  ret_from_fork+0x22/0x30
[  174.764750] Code: 5f 44 e9 18 ff ff ff 48 8b 43 30 4d 89 f9 48 c7 c6 a8 2c 97 81 4c 89 ef 48 8b 4d b0 48 8b 55 b8 4c 8d 40 10 e8 7d 10 fb ff eb 8d <0f> 0b be 01 00 00 00 4c 89 ef 41 be fb ff ff ff e8 86 17 05 00
[  174.764768] RIP: repair_io_failure+0x1b5/0x200 RSP: ffffc900001f7c78
[  174.764769] invalid opcode: 0000 [#4] SMP
[  174.764769] Modules linked in: cls_u32 sch_htb sch_sfq nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_sane nf_conntrack_sip ts_kmp nf_conntrack_amanda nf_conntrack_snmp nf_conntrack_h323 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_tftp
[  174.764773] ---[ end trace 4dcb71dfc5702cb9 ]---
[  174.764773]  nf_conntrack_ftp nf_conntrack_irc xt_NETMAP xt_TCPMSS xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd auth_rpcgss oid_registry nfs_acl binfmt_misc dm_cache_smq dm_cache dm_persistent_data dm_bufio dm_bio_prison k10temp intel_powerclamp coretemp pcbc hwmon_vid iTCO_wdt iTCO_vendor_support aesni_intel
[  174.764791]  crypto_simd cryptd glue_helper pcspkr lpc_ich i2c_i801 mfd_core xts aes_x86_64 cbc sha512_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ixgb macvlan igb dca i2c_algo_bit e1000 atl1c fuse nfs lockd grace sunrpc dm_mirror dm_region_hash dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration xhci_plat_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox megaraid_mm megaraid mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix usbhid ahci libahci xhci_pci r8169 ehci_pci xhci_hcd mii ehci_hcd
[  174.764806] CPU: 7 PID: 4214 Comm: kworker/u16:12 Tainted: G      D         4.13.2-gentoo #5
[  174.764807] Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 4101 05/09/2013
[  174.764808] Workqueue: btrfs-endio btrfs_endio_helper
[  174.764808] task: ffff88040c282d00 task.stack: ffffc900166ec000
[  174.764809] RIP: 0010:repair_io_failure+0x1b5/0x200
[  174.764810] RSP: 0018:ffffc900166efc78 EFLAGS: 00010246
[  174.764810] RAX: ffff88040aa51c80 RBX: 0000000000000000 RCX: 0000000000001000
[  174.764811] RDX: 0000000000003000 RSI: 000000000008299b RDI: ffff88040b124000
[  174.764811] RBP: ffffc900166efcc8 R08: 00000002d14fa000 R09: ffffea000b182e00
[  174.764812] R10: ffffc900166efc18 R11: 0000000000000000 R12: 0000000000003000
[  174.764812] R13: ffff8802e5d29628 R14: ffff88040b124000 R15: ffffea000b182e00
[  174.764812] FS:  0000000000000000(0000) GS:ffff88041edc0000(0000) knlGS:0000000000000000
[  174.764813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  174.764813] CR2: 0000000000513000 CR3: 0000000001a0a000 CR4: 00000000001406a0
[  174.764814] Call Trace:
[  174.764815]  ? get_chunk_map+0x39/0xd0
[  174.764816]  clean_io_failure+0x127/0x140
[  174.764817]  end_bio_extent_readpage+0x248/0x4c0
[  174.764818]  bio_endio+0x83/0x90
[  174.764819]  end_workqueue_fn+0x38/0x40
[  174.764820]  btrfs_worker_helper+0x191/0x1c0
[  174.764821]  btrfs_endio_helper+0x9/0x10
[  174.764821]  process_one_work+0x1b3/0x350
[  174.764822]  worker_thread+0x42/0x3e0
[  174.764823]  kthread+0x11a/0x130
[  174.764824]  ? process_one_work+0x350/0x350
[  174.764825]  ? kthread_create_on_node+0x40/0x40
[  174.764826]  ret_from_fork+0x22/0x30
[  174.764827] Code: 5f 44 e9 18 ff ff ff 48 8b 43 30 4d 89 f9 48 c7 c6 a8 2c 97 81 4c 89 ef 48 8b 4d b0 48 8b 55 b8 4c 8d 40 10 e8 7d 10 fb ff eb 8d <0f> 0b be 01 00 00 00 4c 89 ef 41 be fb ff ff ff e8 86 17 05 00
[  174.764841] RIP: repair_io_failure+0x1b5/0x200 RSP: ffffc900166efc78
[  174.764844] ---[ end trace 4dcb71dfc5702cba ]---
