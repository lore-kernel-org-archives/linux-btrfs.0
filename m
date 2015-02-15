Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail14.tpgi.com.au ([203.12.160.182]:58840 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbbBOEkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Feb 2015 23:40:24 -0500
Received: from office.waterlogic.com.au (14-203-212-247.tpgi.com.au [14.203.212.247])
	by mail14.tpgi.com.au (envelope-from paul@pauljones.id.au) (8.14.3/8.14.3) with ESMTP id t1F4eJSZ000565
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 15:40:21 +1100
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Error while balancing
Date: Sun, 15 Feb 2015 04:40:17 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F645940D1E920@Server.waterlogic.com.au>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The below error was obtained while running a balance with a slightly flakey disk (SSD).
I had to powercycle the server to get it to reboot, and mounting with skip_balance made it stop ok.
I copied the data to another filesystem and recreated the faulty one, but surprisingly there were no errors while copying the files

This is about all I could find before the errors started

Feb 14 19:18:59 vm-server kernel: BTRFS: checksum error at logical 734897631232 on dev /dev/sdg1, sector 720162808, root 5, inode 4835, offset 1546301440, length 4096, links 1 (path: vm/win-server.raw)
Feb 14 19:18:59 vm-server kernel: BTRFS: bdev /dev/sdg1 errs: wr 0, rd 0, flush 0, corrupt 8, gen 0
Feb 14 19:18:59 vm-server kernel: BTRFS: unable to fixup (regular) error at logical 734897631232 on dev /dev/sdg1

While running balance the following happened: (about 30 times per second - I did a grep for one minute of /var/log/message and it was 96 MB!)

Feb 14 21:08:04 vm-server kernel: BTRFS info (device sdb1): found 2023 extents
Feb 14 21:08:15 vm-server kernel: BTRFS info (device sdb1): found 2023 extents
Feb 14 21:08:15 vm-server kernel: BTRFS info (device sdb1): relocating block group 827959803904 flags 17
Feb 14 21:08:24 vm-server kernel: BTRFS info (device sdb1): found 14383 extents
Feb 14 21:08:42 vm-server kernel: BTRFS info (device sdb1): found 14383 extents
Feb 14 21:08:42 vm-server kernel: BTRFS info (device sdb1): relocating block group 826886062080 flags 17
Feb 14 21:08:53 vm-server kernel: BTRFS info (device sdb1): found 18344 extents
Feb 14 21:09:13 vm-server kernel: BTRFS info (device sdb1): found 18344 extents
Feb 14 21:09:13 vm-server kernel: BTRFS info (device sdb1): relocating block group 825812320256 flags 20
Feb 14 21:09:13 vm-server kernel: ------------[ cut here ]------------
Feb 14 21:09:13 vm-server kernel: WARNING: CPU: 1 PID: 10863 at fs/btrfs/relocation.c:925 build_backref_tree+0x5ca/0xe82()
Feb 14 21:09:13 vm-server kernel: Modules linked in: vhost_net vhost macvtap macvlan xt_TCPMSS xt_REDIRECT nf_nat_redirect cls_u32 sch_htb sch_sfq nf_conntrack_sip nf_conntrack_ftp nf_conntrack_sane ts_kmp nf_conntrack_amanda nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netbios_ns nf_conntrack_snmp nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_h323 nf_conntrack_irc xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd lockd grace sunrpc x86_pkg_temp_thermal coretemp pcspkr microcode r8169 i2c_i801 mii fan thermal battery processor xts gf128mul aes_x86_64 cbc sha512_generic fuse dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration sl811_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox usbhid megaraid_mm megaraid sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix ahci libahci ehci_pci ehci_hcd
Feb 14 21:09:13 vm-server kernel: CPU: 1 PID: 10863 Comm: btrfs Not tainted 3.19.0-gentoo #1
Feb 14 21:09:13 vm-server kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 3808 05/10/2012
Feb 14 21:09:13 vm-server kernel: 0000000000000009 ffff88058b313918 ffffffff8154306a 0000000080000000
Feb 14 21:09:13 vm-server kernel: 0000000000000000 ffff88058b313958 ffffffff81065bf3 0000000000001000
Feb 14 21:09:13 vm-server kernel: ffffffff81216991 ffff880602b23800 0000000000000001 ffff88060279b800
Feb 14 21:09:13 vm-server kernel: Call Trace:
Feb 14 21:09:13 vm-server kernel: [<ffffffff8154306a>] dump_stack+0x4f/0x7b
Feb 14 21:09:13 vm-server kernel: [<ffffffff81065bf3>] warn_slowpath_common+0x97/0xb1
Feb 14 21:09:13 vm-server kernel: [<ffffffff81216991>] ? build_backref_tree+0x5ca/0xe82
Feb 14 21:09:13 vm-server kernel: [<ffffffff81065ca1>] warn_slowpath_null+0x15/0x17
Feb 14 21:09:13 vm-server kernel: [<ffffffff81216991>] build_backref_tree+0x5ca/0xe82
Feb 14 21:09:13 vm-server kernel: [<ffffffff811ce112>] ? free_root_pointers+0x56/0x56
Feb 14 21:09:13 vm-server kernel: [<ffffffff81217d3b>] relocate_tree_blocks+0x1a1/0x4d9
Feb 14 21:09:13 vm-server kernel: [<ffffffff81289f6a>] ? debug_smp_processor_id+0x17/0x19
Feb 14 21:09:13 vm-server kernel: [<ffffffff8121364b>] ? tree_insert+0x48/0x4c
Feb 14 21:09:13 vm-server kernel: [<ffffffff8121626a>] ? add_tree_block+0x13c/0x166
Feb 14 21:09:13 vm-server kernel: [<ffffffff812190df>] relocate_block_group+0x29c/0x4de
Feb 14 21:09:13 vm-server kernel: [<ffffffff8121947a>] btrfs_relocate_block_group+0x159/0x26e
Feb 14 21:09:13 vm-server kernel: [<ffffffff811f6c19>] btrfs_relocate_chunk.isra.37+0x35/0xaa
Feb 14 21:09:13 vm-server kernel: [<ffffffff811f8283>] btrfs_balance+0xa94/0xc49
Feb 14 21:09:13 vm-server kernel: [<ffffffff812944ad>] ? __percpu_counter_add+0x8c/0xa5
Feb 14 21:09:13 vm-server kernel: [<ffffffff811fe278>] btrfs_ioctl_balance+0x239/0x2b2
Feb 14 21:09:13 vm-server kernel: [<ffffffff810e17e9>] ? __lru_cache_add+0x6d/0x82
Feb 14 21:09:13 vm-server kernel: [<ffffffff81203029>] btrfs_ioctl+0xf20/0x2357
Feb 14 21:09:13 vm-server kernel: [<ffffffff8105d2b2>] ? __do_page_fault+0x2f6/0x41f
Feb 14 21:09:13 vm-server kernel: [<ffffffff81122b2f>] do_vfs_ioctl+0x367/0x421
Feb 14 21:09:13 vm-server kernel: [<ffffffff81122c22>] SyS_ioctl+0x39/0x61
Feb 14 21:09:13 vm-server kernel: [<ffffffff81548d12>] system_call_fastpath+0x12/0x17
Feb 14 21:09:13 vm-server kernel: ---[ end trace 487c38a475fdc11b ]---
Feb 14 21:09:14 vm-server kernel: ------------[ cut here ]------------
Feb 14 21:09:14 vm-server kernel: WARNING: CPU: 1 PID: 10863 at fs/btrfs/relocation.c:925 build_backref_tree+0x5ca/0xe82()
Feb 14 21:09:14 vm-server kernel: Modules linked in: vhost_net vhost macvtap macvlan xt_TCPMSS xt_REDIRECT nf_nat_redirect cls_u32 sch_htb sch_sfq nf_conntrack_sip nf_conntrack_ftp nf_conntrack_sane ts_kmp nf_conntrack_amanda nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netbios_ns nf_conntrack_snmp nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_h323 nf_conntrack_irc xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd lockd grace sunrpc x86_pkg_temp_thermal coretemp pcspkr microcode r8169 i2c_i801 mii fan thermal battery processor xts gf128mul aes_x86_64 cbc sha512_generic fuse dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration sl811_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox usbhid megaraid_mm megaraid sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix ahci libahci ehci_pci ehci_hcd
Feb 14 21:09:14 vm-server kernel: CPU: 1 PID: 10863 Comm: btrfs Tainted: G        W      3.19.0-gentoo #1
Feb 14 21:09:14 vm-server kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 3808 05/10/2012
Feb 14 21:09:14 vm-server kernel: 0000000000000009 ffff88058b313918 ffffffff8154306a 0000000080000000
Feb 14 21:09:14 vm-server kernel: 0000000000000000 ffff88058b313958 ffffffff81065bf3 0000000000001000
Feb 14 21:09:14 vm-server kernel: ffffffff81216991 ffff880602b23800 0000000000000001 ffff88060279b800
Feb 14 21:09:14 vm-server kernel: Call Trace:
Feb 14 21:09:14 vm-server kernel: [<ffffffff8154306a>] dump_stack+0x4f/0x7b
Feb 14 21:09:14 vm-server kernel: [<ffffffff81065bf3>] warn_slowpath_common+0x97/0xb1
Feb 14 21:09:14 vm-server kernel: [<ffffffff81216991>] ? build_backref_tree+0x5ca/0xe82
Feb 14 21:09:14 vm-server kernel: [<ffffffff81065ca1>] warn_slowpath_null+0x15/0x17
Feb 14 21:09:14 vm-server kernel: [<ffffffff81216991>] build_backref_tree+0x5ca/0xe82
Feb 14 21:09:14 vm-server kernel: [<ffffffff811ce112>] ? free_root_pointers+0x56/0x56
Feb 14 21:09:14 vm-server kernel: [<ffffffff81217d3b>] relocate_tree_blocks+0x1a1/0x4d9
Feb 14 21:09:14 vm-server kernel: [<ffffffff81289f6a>] ? debug_smp_processor_id+0x17/0x19
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121364b>] ? tree_insert+0x48/0x4c
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121626a>] ? add_tree_block+0x13c/0x166
Feb 14 21:09:14 vm-server kernel: [<ffffffff812190df>] relocate_block_group+0x29c/0x4de
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121947a>] btrfs_relocate_block_group+0x159/0x26e
Feb 14 21:09:14 vm-server kernel: [<ffffffff811f6c19>] btrfs_relocate_chunk.isra.37+0x35/0xaa
Feb 14 21:09:14 vm-server kernel: [<ffffffff811f8283>] btrfs_balance+0xa94/0xc49
Feb 14 21:09:14 vm-server kernel: [<ffffffff812944ad>] ? __percpu_counter_add+0x8c/0xa5
Feb 14 21:09:14 vm-server kernel: [<ffffffff811fe278>] btrfs_ioctl_balance+0x239/0x2b2
Feb 14 21:09:14 vm-server kernel: [<ffffffff810e17e9>] ? __lru_cache_add+0x6d/0x82
Feb 14 21:09:14 vm-server kernel: [<ffffffff81203029>] btrfs_ioctl+0xf20/0x2357
Feb 14 21:09:14 vm-server kernel: [<ffffffff8105d2b2>] ? __do_page_fault+0x2f6/0x41f
Feb 14 21:09:14 vm-server kernel: [<ffffffff81122b2f>] do_vfs_ioctl+0x367/0x421
Feb 14 21:09:14 vm-server kernel: [<ffffffff81122c22>] SyS_ioctl+0x39/0x61
Feb 14 21:09:14 vm-server kernel: [<ffffffff81548d12>] system_call_fastpath+0x12/0x17
Feb 14 21:09:14 vm-server kernel: ---[ end trace 487c38a475fdc11c ]---
Feb 14 21:09:14 vm-server kernel: ------------[ cut here ]------------
Feb 14 21:09:14 vm-server kernel: WARNING: CPU: 1 PID: 10863 at fs/btrfs/relocation.c:925 build_backref_tree+0x5ca/0xe82()
Feb 14 21:09:14 vm-server kernel: Modules linked in: vhost_net vhost macvtap macvlan xt_TCPMSS xt_REDIRECT nf_nat_redirect cls_u32 sch_htb sch_sfq nf_conntrack_sip nf_conntrack_ftp nf_conntrack_sane ts_kmp nf_conntrack_amanda nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netbios_ns nf_conntrack_snmp nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_h323 nf_conntrack_irc xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd lockd grace sunrpc x86_pkg_temp_thermal coretemp pcspkr microcode r8169 i2c_i801 mii fan thermal battery processor xts gf128mul aes_x86_64 cbc sha512_generic fuse dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration sl811_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox usbhid megaraid_mm megaraid sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix ahci libahci ehci_pci ehci_hcd
Feb 14 21:09:14 vm-server kernel: CPU: 1 PID: 10863 Comm: btrfs Tainted: G        W      3.19.0-gentoo #1
Feb 14 21:09:14 vm-server kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 3808 05/10/2012
Feb 14 21:09:14 vm-server kernel: 0000000000000009 ffff88058b313918 ffffffff8154306a 0000000080000000
Feb 14 21:09:14 vm-server kernel: 0000000000000000 ffff88058b313958 ffffffff81065bf3 0000000000001000
Feb 14 21:09:14 vm-server kernel: ffffffff81216991 ffff880602b23800 0000000000000001 ffff88060279b800
Feb 14 21:09:14 vm-server kernel: Call Trace:
Feb 14 21:09:14 vm-server kernel: [<ffffffff8154306a>] dump_stack+0x4f/0x7b
Feb 14 21:09:14 vm-server kernel: [<ffffffff81065bf3>] warn_slowpath_common+0x97/0xb1
Feb 14 21:09:14 vm-server kernel: [<ffffffff81216991>] ? build_backref_tree+0x5ca/0xe82
Feb 14 21:09:14 vm-server kernel: [<ffffffff81065ca1>] warn_slowpath_null+0x15/0x17
Feb 14 21:09:14 vm-server kernel: [<ffffffff81216991>] build_backref_tree+0x5ca/0xe82
Feb 14 21:09:14 vm-server kernel: [<ffffffff811ce112>] ? free_root_pointers+0x56/0x56
Feb 14 21:09:14 vm-server kernel: [<ffffffff81217d3b>] relocate_tree_blocks+0x1a1/0x4d9
Feb 14 21:09:14 vm-server kernel: [<ffffffff81289f6a>] ? debug_smp_processor_id+0x17/0x19
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121364b>] ? tree_insert+0x48/0x4c
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121626a>] ? add_tree_block+0x13c/0x166
Feb 14 21:09:14 vm-server kernel: [<ffffffff812190df>] relocate_block_group+0x29c/0x4de
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121947a>] btrfs_relocate_block_group+0x159/0x26e
Feb 14 21:09:14 vm-server kernel: [<ffffffff811f6c19>] btrfs_relocate_chunk.isra.37+0x35/0xaa
Feb 14 21:09:14 vm-server kernel: [<ffffffff811f8283>] btrfs_balance+0xa94/0xc49
Feb 14 21:09:14 vm-server kernel: [<ffffffff812944ad>] ? __percpu_counter_add+0x8c/0xa5
Feb 14 21:09:14 vm-server kernel: [<ffffffff811fe278>] btrfs_ioctl_balance+0x239/0x2b2
Feb 14 21:09:14 vm-server kernel: [<ffffffff810e17e9>] ? __lru_cache_add+0x6d/0x82
Feb 14 21:09:14 vm-server kernel: [<ffffffff81203029>] btrfs_ioctl+0xf20/0x2357
Feb 14 21:09:14 vm-server kernel: [<ffffffff8105d2b2>] ? __do_page_fault+0x2f6/0x41f
Feb 14 21:09:14 vm-server kernel: [<ffffffff81122b2f>] do_vfs_ioctl+0x367/0x421
Feb 14 21:09:14 vm-server kernel: [<ffffffff81122c22>] SyS_ioctl+0x39/0x61
Feb 14 21:09:14 vm-server kernel: [<ffffffff81548d12>] system_call_fastpath+0x12/0x17
Feb 14 21:09:14 vm-server kernel: ---[ end trace 487c38a475fdc11d ]---
Feb 14 21:09:14 vm-server kernel: ------------[ cut here ]------------
Feb 14 21:09:14 vm-server kernel: WARNING: CPU: 1 PID: 10863 at fs/btrfs/relocation.c:925 build_backref_tree+0x5ca/0xe82()
Feb 14 21:09:14 vm-server kernel: Modules linked in: vhost_net vhost macvtap macvlan xt_TCPMSS xt_REDIRECT nf_nat_redirect cls_u32 sch_htb sch_sfq nf_conntrack_sip nf_conntrack_ftp nf_conntrack_sane ts_kmp nf_conntrack_amanda nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netbios_ns nf_conntrack_snmp nf_conntrack_broadcast nf_conntrack_tftp nf_conntrack_h323 nf_conntrack_irc xt_CHECKSUM ipt_rpfilter xt_DSCP xt_dscp xt_statistic xt_CT xt_AUDIT xt_NFLOG xt_time xt_connlimit xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_defrag_ipv6 xt_CLASSIFY xt_mark xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy iptable_mangle xt_nat xt_multiport xt_conntrack ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_filter ip_tables nfsd lockd grace sunrpc x86_pkg_temp_thermal coretemp pcspkr microcode r8169 i2c_i801 mii fan thermal battery processor xts gf128mul aes_x86_64 cbc sha512_generic fuse dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration sl811_hcd ohci_pci ohci_hcd uhci_hcd usb_storage megaraid_sas megaraid_mbox usbhid megaraid_mm megaraid sata_inic162x ata_piix sata_nv sata_sil24 pata_jmicron pata_amd pata_mpiix ahci libahci ehci_pci ehci_hcd
Feb 14 21:09:14 vm-server kernel: CPU: 1 PID: 10863 Comm: btrfs Tainted: G        W      3.19.0-gentoo #1
Feb 14 21:09:14 vm-server kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LE, BIOS 3808 05/10/2012
Feb 14 21:09:14 vm-server kernel: 0000000000000009 ffff88058b313918 ffffffff8154306a 0000000080000000
Feb 14 21:09:14 vm-server kernel: 0000000000000000 ffff88058b313958 ffffffff81065bf3 0000000000001000
Feb 14 21:09:14 vm-server kernel: ffffffff81216991 ffff880602b23800 0000000000000001 ffff88060279b800
Feb 14 21:09:14 vm-server kernel: Call Trace:
Feb 14 21:09:14 vm-server kernel: [<ffffffff8154306a>] dump_stack+0x4f/0x7b
Feb 14 21:09:14 vm-server kernel: [<ffffffff81065bf3>] warn_slowpath_common+0x97/0xb1
Feb 14 21:09:14 vm-server kernel: [<ffffffff81216991>] ? build_backref_tree+0x5ca/0xe82
Feb 14 21:09:14 vm-server kernel: [<ffffffff81065ca1>] warn_slowpath_null+0x15/0x17
Feb 14 21:09:14 vm-server kernel: [<ffffffff81216991>] build_backref_tree+0x5ca/0xe82
Feb 14 21:09:14 vm-server kernel: [<ffffffff811ce112>] ? free_root_pointers+0x56/0x56
Feb 14 21:09:14 vm-server kernel: [<ffffffff81217d3b>] relocate_tree_blocks+0x1a1/0x4d9
Feb 14 21:09:14 vm-server kernel: [<ffffffff81289f6a>] ? debug_smp_processor_id+0x17/0x19
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121364b>] ? tree_insert+0x48/0x4c
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121626a>] ? add_tree_block+0x13c/0x166
Feb 14 21:09:14 vm-server kernel: [<ffffffff812190df>] relocate_block_group+0x29c/0x4de
Feb 14 21:09:14 vm-server kernel: [<ffffffff8121947a>] btrfs_relocate_block_group+0x159/0x26e
Feb 14 21:09:14 vm-server kernel: [<ffffffff811f6c19>] btrfs_relocate_chunk.isra.37+0x35/0xaa
Feb 14 21:09:14 vm-server kernel: [<ffffffff811f8283>] btrfs_balance+0xa94/0xc49
Feb 14 21:09:14 vm-server kernel: [<ffffffff812944ad>] ? __percpu_counter_add+0x8c/0xa5
Feb 14 21:09:14 vm-server kernel: [<ffffffff811fe278>] btrfs_ioctl_balance+0x239/0x2b2
Feb 14 21:09:14 vm-server kernel: [<ffffffff810e17e9>] ? __lru_cache_add+0x6d/0x82
Feb 14 21:09:14 vm-server kernel: [<ffffffff81203029>] btrfs_ioctl+0xf20/0x2357
Feb 14 21:09:14 vm-server kernel: [<ffffffff8105d2b2>] ? __do_page_fault+0x2f6/0x41f
Feb 14 21:09:14 vm-server kernel: [<ffffffff81122b2f>] do_vfs_ioctl+0x367/0x421
Feb 14 21:09:14 vm-server kernel: [<ffffffff81122c22>] SyS_ioctl+0x39/0x61
Feb 14 21:09:14 vm-server kernel: [<ffffffff81548d12>] system_call_fastpath+0x12/0x17
Feb 14 21:09:14 vm-server kernel: ---[ end trace 487c38a475fdc11e ]---

Linux vm-server 3.19.0-gentoo #1 SMP PREEMPT Wed Feb 11 16:48:13 AEDT 2015 x86_64 Intel(R) Core(TM) i7-2600K CPU @ 3.40GHz GenuineIntel GNU/Linux

Label: 'Root'  uuid: 58d27dbd-7c1e-4ef7-8d43-e93df1537b08
        Total devices 3 FS bytes used 14.85GiB
        devid    3 size 40.00GiB used 33.03GiB path /dev/sdf3
        devid    4 size 40.00GiB used 33.03GiB path /dev/sde3
        devid    6 size 40.00GiB used 0.00B path /dev/sdb2

Label: 'Storage'  uuid: 63ec312b-5f7a-4137-a8f0-e877d5a85902
        Total devices 2 FS bytes used 1.07TiB
        devid    1 size 3.64TiB used 1.08TiB path /dev/sdd1
        devid    2 size 3.64TiB used 1.08TiB path /dev/sdj1

Label: 'Backup'  uuid: 8149e719-022b-4a7a-8465-704e24ba7898
        Total devices 4 FS bytes used 1.11TiB
        devid    1 size 2.73TiB used 1.12TiB path /dev/sdc1
        devid    2 size 931.51GiB used 567.00GiB path /dev/sdi1
        devid    3 size 931.51GiB used 569.03GiB path /dev/sdh1
        devid    4 size 2.73TiB used 7.00GiB path /dev/sdg1

Label: 'Fast'  uuid: e15bab07-1fcf-48b1-92d5-a2609f0fe469
        Total devices 2 FS bytes used 293.71GiB
        devid    1 size 407.12GiB used 295.03GiB path /dev/sde1
        devid    3 size 407.12GiB used 295.03GiB path /dev/sdf1

Btrfs v3.18.2

