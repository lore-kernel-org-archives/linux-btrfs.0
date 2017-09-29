Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0077.outbound.protection.outlook.com ([104.47.116.77]:33429
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750996AbdI2GTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 02:19:43 -0400
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: WARNING: CPU: 1 PID: 13825 at fs/btrfs/backref.c:1255
 find_parent_nodes+0xb5c/0x1310
Date: Fri, 29 Sep 2017 06:19:39 +0000
Message-ID: <MEXPR01MB21685133310C60FDF290C5559E7E0@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <MEXPR01MB21685844276703C92357944C9E7E0@MEXPR01MB2168.ausprd01.prod.outlook.com>
In-Reply-To: <MEXPR01MB21685844276703C92357944C9E7E0@MEXPR01MB2168.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Just ran into this warning while running deduplication. There were 10's of thousands of them over a 24hr period. No other problems were reported.
Filesystem is raid1, freshly converted from single. Zstd compression.  4.14.0-rc2 kernel


Sep 28 14:57:06 home kernel: ------------[ cut here ]------------
Sep 28 14:57:06 home kernel: WARNING: CPU: 1 PID: 13825 at fs/btrfs/backref.c:1255 find_parent_nodes+0xb5c/0x1310
Sep 28 14:57:06 home kernel: Modules linked in: l2tp_netlink l2tp_core udp_tunnel ip6_udp_tunnel cls_u32 sch_htb sch_sfq nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_sane nf_conntrack_sip ts_kmp nf_conntrack_amanda nf_conntrack_snmp nf_conntrack_h323 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_ftp nf_conntrack_irc xt_NETMAP xt_TCPMSS xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah
Sep 28 14:57:06 home kernel:  iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd auth_rpcgss oid_registry nfs_acl binfmt_misc dm_cache_smq dm_cache dm_persistent_data dm_bufio dm_bio_prison k10temp hwmon_vid intel_powerclamp coretemp pcbc iTCO_wdt iTCO_vendor_support aesni_intel crypto_simd cryptd glue_helper pcspkr i2c_i801 lpc_ich mfd_core xts aes_x86_64 cbc sha512_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ixgb macvlan igb dca i2c_algo_bit e1000 atl1c fuse nfs lockd grace sunrpc dm_mirror dm_region_hash dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration usbhid xhci_plat_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox megaraid_mm megaraid mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase
Sep 28 14:57:06 home kernel:  sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix ahci libahci xhci_pci ehci_pci r8169 xhci_hcd mii ehci_hcd
Sep 28 14:57:06 home kernel: CPU: 1 PID: 13825 Comm: crawl Not tainted 4.14.0-rc2 #2
Sep 28 14:57:06 home kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 4101 05/09/2013
Sep 28 14:57:06 home kernel: task: ffff8803dde96140 task.stack: ffffc90018f90000
Sep 28 14:57:06 home kernel: RIP: 0010:find_parent_nodes+0xb5c/0x1310
Sep 28 14:57:06 home kernel: RSP: 0018:ffffc90018f93b30 EFLAGS: 00010286
Sep 28 14:57:06 home kernel: RAX: 00000000ffffffff RBX: ffff8803f8453318 RCX: 0000000000000001
Sep 28 14:57:06 home kernel: RDX: 0000000000000000 RSI: ffff88040b9ca338 RDI: ffff8802c831bec8
Sep 28 14:57:06 home kernel: RBP: ffffc90018f93c50 R08: ffff8803bb36d4e0 R09: 0000000000000000
Sep 28 14:57:06 home kernel: R10: ffff8802c831bec8 R11: ffffc90018f93bf0 R12: 0000000000000001
Sep 28 14:57:06 home kernel: R13: ffffc90018f93c10 R14: ffff8803fc295ac0 R15: ffff8802c831bec8
Sep 28 14:57:06 home kernel: FS:  00007f5dd2ca5700(0000) GS:ffff88041ec40000(0000) knlGS:0000000000000000
Sep 28 14:57:06 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 28 14:57:06 home kernel: CR2: 00007f8a30efc000 CR3: 000000034037a005 CR4: 00000000001606a0
Sep 28 14:57:06 home kernel: Call Trace:
Sep 28 14:57:06 home kernel:  btrfs_find_all_roots_safe+0x91/0x100
Sep 28 14:57:06 home kernel:  ? btrfs_find_all_roots_safe+0x91/0x100
Sep 28 14:57:06 home kernel:  ? extent_same_check_offsets+0x70/0x70
Sep 28 14:57:06 home kernel:  iterate_extent_inodes+0x1d1/0x260
Sep 28 14:57:06 home kernel:  iterate_inodes_from_logical+0x7d/0xa0
Sep 28 14:57:06 home kernel:  ? iterate_inodes_from_logical+0x7d/0xa0
Sep 28 14:57:06 home kernel:  ? extent_same_check_offsets+0x70/0x70
Sep 28 14:57:06 home kernel:  btrfs_ioctl+0x8aa/0x23a0
Sep 28 14:57:06 home kernel:  ? generic_file_read_iter+0x322/0x7d0
Sep 28 14:57:06 home kernel:  ? _copy_to_user+0x26/0x30
Sep 28 14:57:06 home kernel:  ? cp_new_stat+0x108/0x120
Sep 28 14:57:06 home kernel:  do_vfs_ioctl+0x8d/0x5b0
Sep 28 14:57:06 home kernel:  ? do_vfs_ioctl+0x8d/0x5b0
Sep 28 14:57:06 home kernel:  ? SyS_newfstat+0x35/0x50
Sep 28 14:57:06 home kernel:  SyS_ioctl+0x3c/0x70
Sep 28 14:57:06 home kernel:  entry_SYSCALL_64_fastpath+0x13/0x94
Sep 28 14:57:06 home kernel: RIP: 0033:0x7f5dd2f8afd7
Sep 28 14:57:06 home kernel: RSP: 002b:00007f5dd2ca25c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Sep 28 14:57:06 home kernel: RAX: ffffffffffffffda RBX: 00007f5dcc38f0e0 RCX: 00007f5dd2f8afd7
Sep 28 14:57:06 home kernel: RDX: 00007f5dd2ca2698 RSI: 00000000c0389424 RDI: 0000000000000003
Sep 28 14:57:06 home kernel: RBP: 0000000000000030 R08: 0000000000000000 R09: 00007ffe8b102080
Sep 28 14:57:06 home kernel: R10: 00007f5dcc3e0870 R11: 0000000000000246 R12: 00007f5dcc4e0090
Sep 28 14:57:06 home kernel: R13: 0000000000000040 R14: 00007f5dcc000020 R15: 00007f5dcc000038
Sep 28 14:57:06 home kernel: Code: ff ff ff 6a 00 49 8d 7f 20 4c 89 d6 6a 01 8d 48 01 e8 09 ec ff ff 48 83 c4 18 85 c0 0f 85 7f 03 00 00 49 83 c5 09 e9 62 ff ff ff <0f> ff 4d 85 f6 0f 85 63 f9 ff ff e9 22 f9 ff ff 41 8b 47 34 85 
Sep 28 14:57:06 home kernel: ---[ end trace f89f3f2862680e34 ]---
Sep 28 14:57:06 home kernel: ------------[ cut here ]------------
Sep 28 14:57:06 home kernel: WARNING: CPU: 2 PID: 13825 at fs/btrfs/backref.c:1255 find_parent_nodes+0xb5c/0x1310
Sep 28 14:57:06 home kernel: Modules linked in: l2tp_netlink l2tp_core udp_tunnel ip6_udp_tunnel cls_u32 sch_htb sch_sfq nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_sane nf_conntrack_sip ts_kmp nf_conntrack_amanda nf_conntrack_snmp nf_conntrack_h323 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_ftp nf_conntrack_irc xt_NETMAP xt_TCPMSS xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah
Sep 28 14:57:06 home kernel:  iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd auth_rpcgss oid_registry nfs_acl binfmt_misc dm_cache_smq dm_cache dm_persistent_data dm_bufio dm_bio_prison k10temp hwmon_vid intel_powerclamp coretemp pcbc iTCO_wdt iTCO_vendor_support aesni_intel crypto_simd cryptd glue_helper pcspkr i2c_i801 lpc_ich mfd_core xts aes_x86_64 cbc sha512_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ixgb macvlan igb dca i2c_algo_bit e1000 atl1c fuse nfs lockd grace sunrpc dm_mirror dm_region_hash dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration usbhid xhci_plat_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox megaraid_mm megaraid mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase
Sep 28 14:57:06 home kernel:  sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix ahci libahci xhci_pci ehci_pci r8169 xhci_hcd mii ehci_hcd
Sep 28 14:57:06 home kernel: CPU: 2 PID: 13825 Comm: crawl Tainted: G        W       4.14.0-rc2 #2
Sep 28 14:57:06 home kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 4101 05/09/2013
Sep 28 14:57:06 home kernel: task: ffff8803dde96140 task.stack: ffffc90018f90000
Sep 28 14:57:06 home kernel: RIP: 0010:find_parent_nodes+0xb5c/0x1310
Sep 28 14:57:06 home kernel: RSP: 0018:ffffc90018f93b30 EFLAGS: 00010286
Sep 28 14:57:06 home kernel: RAX: 00000000ffffffff RBX: ffff88013ebc7528 RCX: ffff88013ebc7580
Sep 28 14:57:06 home kernel: RDX: 0000000000000000 RSI: ffff8804052515d8 RDI: ffff88013ebc8790
Sep 28 14:57:06 home kernel: RBP: ffffc90018f93c50 R08: ffff88013ebcbea0 R09: 0000000000000000
Sep 28 14:57:06 home kernel: R10: ffff88013ebc7f78 R11: ffffc90018f93bf0 R12: 0000000000000001
Sep 28 14:57:06 home kernel: R13: ffffc90018f93c10 R14: ffff8803fc15d9a0 R15: ffff88013ebc8790
Sep 28 14:57:06 home kernel: FS:  00007f5dd2ca5700(0000) GS:ffff88041ec80000(0000) knlGS:0000000000000000
Sep 28 14:57:06 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 28 14:57:06 home kernel: CR2: 00007f5dcc883000 CR3: 000000034037a001 CR4: 00000000001606a0
Sep 28 14:57:06 home kernel: Call Trace:
Sep 28 14:57:06 home kernel:  btrfs_find_all_roots_safe+0x91/0x100
Sep 28 14:57:06 home kernel:  ? btrfs_find_all_roots_safe+0x91/0x100
Sep 28 14:57:06 home kernel:  ? extent_same_check_offsets+0x70/0x70
Sep 28 14:57:06 home kernel:  iterate_extent_inodes+0x1d1/0x260
Sep 28 14:57:06 home kernel:  iterate_inodes_from_logical+0x7d/0xa0
Sep 28 14:57:06 home kernel:  ? iterate_inodes_from_logical+0x7d/0xa0
Sep 28 14:57:06 home kernel:  ? extent_same_check_offsets+0x70/0x70
Sep 28 14:57:06 home kernel:  btrfs_ioctl+0x8aa/0x23a0
Sep 28 14:57:06 home kernel:  ? generic_file_read_iter+0x322/0x7d0
Sep 28 14:57:06 home kernel:  ? _copy_to_user+0x26/0x30
Sep 28 14:57:06 home kernel:  ? cp_new_stat+0x108/0x120
Sep 28 14:57:06 home kernel:  do_vfs_ioctl+0x8d/0x5b0
Sep 28 14:57:06 home kernel:  ? do_vfs_ioctl+0x8d/0x5b0
Sep 28 14:57:06 home kernel:  ? SyS_newfstat+0x35/0x50
Sep 28 14:57:06 home kernel:  SyS_ioctl+0x3c/0x70
Sep 28 14:57:06 home kernel:  entry_SYSCALL_64_fastpath+0x13/0x94
Sep 28 14:57:06 home kernel: RIP: 0033:0x7f5dd2f8afd7
Sep 28 14:57:06 home kernel: RSP: 002b:00007f5dd2ca25c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Sep 28 14:57:06 home kernel: RAX: ffffffffffffffda RBX: 00007f5dd2ca2cd0 RCX: 00007f5dd2f8afd7
Sep 28 14:57:06 home kernel: RDX: 00007f5dd2ca2698 RSI: 00000000c0389424 RDI: 0000000000000003
Sep 28 14:57:06 home kernel: RBP: 00007f5dcc884610 R08: 0000000000000000 R09: 00007ffe8b102080
Sep 28 14:57:06 home kernel: R10: 00007f5dcc4bc920 R11: 0000000000000246 R12: 00007f5dd2ca2fb0
Sep 28 14:57:06 home kernel: R13: 00007f5dd2ca2c90 R14: 00007f5dd2ca2c60 R15: 000000000048cd10
Sep 28 14:57:06 home kernel: Code: ff ff ff 6a 00 49 8d 7f 20 4c 89 d6 6a 01 8d 48 01 e8 09 ec ff ff 48 83 c4 18 85 c0 0f 85 7f 03 00 00 49 83 c5 09 e9 62 ff ff ff <0f> ff 4d 85 f6 0f 85 63 f9 ff ff e9 22 f9 ff ff 41 8b 47 34 85 
Sep 28 14:57:06 home kernel: ---[ end trace f89f3f2862680e35 ]---
Sep 28 14:57:08 home kernel: ------------[ cut here ]------------
Sep 28 14:57:08 home kernel: WARNING: CPU: 4 PID: 13825 at fs/btrfs/backref.c:1255 find_parent_nodes+0xb5c/0x1310
Sep 28 14:57:08 home kernel: Modules linked in: l2tp_netlink l2tp_core udp_tunnel ip6_udp_tunnel cls_u32 sch_htb sch_sfq nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_sane nf_conntrack_sip ts_kmp nf_conntrack_amanda nf_conntrack_snmp nf_conntrack_h323 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_ftp nf_conntrack_irc xt_NETMAP xt_TCPMSS xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah
Sep 28 14:57:08 home kernel:  iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd auth_rpcgss oid_registry nfs_acl binfmt_misc dm_cache_smq dm_cache dm_persistent_data dm_bufio dm_bio_prison k10temp hwmon_vid intel_powerclamp coretemp pcbc iTCO_wdt iTCO_vendor_support aesni_intel crypto_simd cryptd glue_helper pcspkr i2c_i801 lpc_ich mfd_core xts aes_x86_64 cbc sha512_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ixgb macvlan igb dca i2c_algo_bit e1000 atl1c fuse nfs lockd grace sunrpc dm_mirror dm_region_hash dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration usbhid xhci_plat_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox megaraid_mm megaraid mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase
Sep 28 14:57:08 home kernel:  sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix ahci libahci xhci_pci ehci_pci r8169 xhci_hcd mii ehci_hcd
Sep 28 14:57:08 home kernel: CPU: 4 PID: 13825 Comm: crawl Tainted: G        W       4.14.0-rc2 #2
Sep 28 14:57:08 home kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 4101 05/09/2013
Sep 28 14:57:08 home kernel: task: ffff8803dde96140 task.stack: ffffc90018f90000
Sep 28 14:57:08 home kernel: RIP: 0010:find_parent_nodes+0xb5c/0x1310
Sep 28 14:57:08 home kernel: RSP: 0018:ffffc90018f93b30 EFLAGS: 00010286
Sep 28 14:57:08 home kernel: RAX: 00000000ffffffff RBX: ffff880340fe4c08 RCX: ffff880340fe4c08
Sep 28 14:57:08 home kernel: RDX: ffff880340fe4c08 RSI: ffff8803f92b30f8 RDI: ffff8802c831baa8
Sep 28 14:57:08 home kernel: RBP: ffffc90018f93c50 R08: ffff8803dd6f68e0 R09: 0000000000000000
Sep 28 14:57:08 home kernel: R10: ffff88024d5fc058 R11: ffffc90018f93bf0 R12: 0000000000000001
Sep 28 14:57:08 home kernel: R13: ffffc90018f93c10 R14: ffff8803fbed97c0 R15: ffff8803f8453478
Sep 28 14:57:08 home kernel: FS:  00007f5dd2ca5700(0000) GS:ffff88041ed00000(0000) knlGS:0000000000000000
Sep 28 14:57:08 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 28 14:57:08 home kernel: CR2: 00007f8a302f4000 CR3: 000000034037a005 CR4: 00000000001606a0
Sep 28 14:57:08 home kernel: Call Trace:
Sep 28 14:57:08 home kernel:  btrfs_find_all_roots_safe+0x91/0x100
Sep 28 14:57:08 home kernel:  ? btrfs_find_all_roots_safe+0x91/0x100
Sep 28 14:57:08 home kernel:  ? extent_same_check_offsets+0x70/0x70
Sep 28 14:57:08 home kernel:  iterate_extent_inodes+0x1d1/0x260
Sep 28 14:57:08 home kernel:  iterate_inodes_from_logical+0x7d/0xa0
Sep 28 14:57:08 home kernel:  ? iterate_inodes_from_logical+0x7d/0xa0
Sep 28 14:57:08 home kernel:  ? extent_same_check_offsets+0x70/0x70
Sep 28 14:57:08 home kernel:  btrfs_ioctl+0x8aa/0x23a0
Sep 28 14:57:08 home kernel:  ? generic_file_read_iter+0x322/0x7d0
Sep 28 14:57:08 home kernel:  do_vfs_ioctl+0x8d/0x5b0
Sep 28 14:57:08 home kernel:  ? do_vfs_ioctl+0x8d/0x5b0
Sep 28 14:57:08 home kernel:  ? vfs_read+0x116/0x130
Sep 28 14:57:08 home kernel:  SyS_ioctl+0x3c/0x70
Sep 28 14:57:08 home kernel:  entry_SYSCALL_64_fastpath+0x13/0x94
Sep 28 14:57:08 home kernel: RIP: 0033:0x7f5dd2f8afd7
Sep 28 14:57:08 home kernel: RSP: 002b:00007f5dd2ca2bc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Sep 28 14:57:08 home kernel: RAX: ffffffffffffffda RBX: 00000000000000c2 RCX: 00007f5dd2f8afd7
Sep 28 14:57:08 home kernel: RDX: 00007f5dd2ca2c98 RSI: 00000000c0389424 RDI: 0000000000000003
Sep 28 14:57:08 home kernel: RBP: 00007f5dd2ca3550 R08: 0000000000000000 R09: 00007ffe8b102080
Sep 28 14:57:08 home kernel: R10: 00007f5dcc7516a0 R11: 0000000000000246 R12: 000000000000c000
Sep 28 14:57:08 home kernel: R13: 00007f5dd2ca3960 R14: 00007f5dd2ca4180 R15: 00007f5dd2ca3cb0
Sep 28 14:57:08 home kernel: Code: ff ff ff 6a 00 49 8d 7f 20 4c 89 d6 6a 01 8d 48 01 e8 09 ec ff ff 48 83 c4 18 85 c0 0f 85 7f 03 00 00 49 83 c5 09 e9 62 ff ff ff <0f> ff 4d 85 f6 0f 85 63 f9 ff ff e9 22 f9 ff ff 41 8b 47 34 85 
Sep 28 14:57:08 home kernel: ---[ end trace f89f3f2862680e36 ]---
