Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vps01.asselman.com ([79.170.94.25]:37949 "EHLO
	vps01.asselman.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbcAVK6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 05:58:38 -0500
Received: from [10.250.150.21] (unknown [89.146.58.193])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by vps01.asselman.com (Postfix) with ESMTPSA id BCDD5300577
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 11:50:18 +0100 (CET)
From: Jeroen Asselman <jeroen@asselman.com>
Content-Type: text/plain; charset=us-ascii
Subject: Bad metadata / Incorrect global backref count
Message-Id: <6319302C-E745-4274-86BA-10FE457A511C@asselman.com>
Date: Fri, 22 Jan 2016 11:50:18 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I seem to have a problem with my btrfs volume, my filesystem got remounted readonly with an error.
This is not a converted filesystem. The volume has about 16k+ snapshots (automatically created using snapbtr), I think I created the volume in Januari 2015.


Jan 20 22:00:14 streamlet kernel: ------------[ cut here ]------------
Jan 20 22:00:14 streamlet kernel: WARNING: CPU: 1 PID: 4964 at /usr/src/linux-4.1.12-gentoo/fs/btrfs/extent-tree.c:6226 __btrfs_free_extent+0x3a9/0x843()
Jan 20 22:00:14 streamlet kernel: Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 cls_u32 cls_flow cls_fw sch_sfq sch_prio sch_tbf xt_nat ip6table_nat nf_nat_ipv6 ip6t_REJECT nf_reject_ipv6 ip6table_mangle ip6table_raw nf_log_ipv6 ip6table_filter ip6_tables xt_recent xt_comment iptable_nat nf_nat_ipv4 ipt_REJECT nf_reject_ipv4 xt_addrtype xt_mark iptable_mangle xt_TCPMSS xt_CT iptable_raw xt_multiport xt_conntrack xt_NFLOG xt_LOG nf_log_ipv4 nf_log_common nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_nat nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
Jan 20 22:00:14 streamlet kernel:  nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp iptable_filter w83627ehf hwmon_vid ipmi_devintf ipmi_si ipmi_msghandler pppoe pppox ppp_generic slhc 8021q binfmt_misc tun bcache coretemp pl2303 ftdi_sio e1000e usbserial ptp pps_core parport_pc parport acpi_cpufreq processor [last unloaded: microcode]
Jan 20 22:00:14 streamlet kernel: CPU: 1 PID: 4964 Comm: btrfs-cleaner Not tainted 4.1.12-gentoo #1
Jan 20 22:00:14 streamlet kernel: Hardware name: Supermicro X7SPA-HF/X7SPA-HF, BIOS 1.1b       12/31/10  
Jan 20 22:00:14 streamlet kernel:  0000000000000000 0000000000000009 ffffffff8153608f 0000000000000000
Jan 20 22:00:14 streamlet kernel:  ffffffff8105c014 b4000000b13a1740 ffffffff81213d0b 00000000fffffffe
Jan 20 22:00:14 streamlet kernel:  00000000fffffffe ffff880088c9d5a0 000000b13a174000 000000b17e9f8000
Jan 20 22:00:14 streamlet kernel: Call Trace:
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8153608f>] ? dump_stack+0x40/0x50
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8105c014>] ? warn_slowpath_common+0x99/0xb2
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81213d0b>] ? __btrfs_free_extent+0x3a9/0x843
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81213d0b>] ? __btrfs_free_extent+0x3a9/0x843
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81264036>] ? btrfs_merge_delayed_refs+0x197/0x1af
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81219846>] ? __btrfs_run_delayed_refs+0xac9/0xc66
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8121b631>] ? btrfs_run_delayed_refs+0x61/0x189
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81217fe1>] ? walk_up_tree+0x85/0xf7
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81228d3d>] ? btrfs_should_end_transaction+0x48/0x56
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8121a22c>] ? btrfs_drop_snapshot+0x364/0x658
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81076a43>] ? finish_task_switch+0x5b/0xab
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81537400>] ? __schedule+0x2af/0x476
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81229128>] ? btrfs_clean_one_deleted_snapshot+0x9b/0xa5
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81222b64>] ? cleaner_kthread+0xff/0x125
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81222a65>] ? btree_writepages+0x56/0x56
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81071aa8>] ? kthread+0x9a/0xa2
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81070000>] ? __task_pid_nr_ns+0x21/0x4b
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81071a0e>] ? __kthread_parkme+0x57/0x57
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81539d12>] ? ret_from_fork+0x42/0x70
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81071a0e>] ? __kthread_parkme+0x57/0x57
Jan 20 22:00:14 streamlet kernel: ---[ end trace 8ecb608839ff984b ]---
Jan 20 22:00:14 streamlet kernel: BTRFS info (device bcache1): leaf 2857340420096 total ptrs 271 free space 7297
Jan 20 22:00:14 streamlet kernel: \x09item 0 key (761182732288 169 1) itemoff 16250 itemsize 33
Jan 20 22:00:14 streamlet kernel: \x09\x09extent refs 1 gen 425829 flags 258
Jan 20 22:00:14 streamlet kernel: \x09\x09tree block backref root 9699
Jan 20 22:00:14 streamlet kernel: \x09item 1 key (761182748672 169 0) itemoff 16217 itemsize 33
Jan 20 22:00:14 streamlet kernel: \x09\x09extent refs 1 gen 511759 flags 258
Jan 20 22:00:14 streamlet kernel: \x09\x09shared block backref parent 761182453760
Jan 20 22:00:14 streamlet kernel: \x09item 2 key (761182781440 169 0) itemoff 16184 itemsize 33
Jan 20 22:00:14 streamlet kernel: \x09\x09extent refs 1 gen 374945 flags 258
Jan 20 22:00:14 streamlet kernel: \x09\x09shared block backref parent 761294651392
< lots and lots more >
Jan 20 22:00:14 streamlet kernel: \x09\x09shared block backref
Jan 20 22:00:14 streamlet kernel: \x09item 270 key (761183813632 182 761073188864) itemoff 14072 itemsize 0
Jan 20 22:00:14 streamlet kernel: \x09\x09shared block backref
Jan 20 22:00:14 streamlet kernel: BTRFS error (device bcache1): unable to find ref byte nr 761183813632 parent 762333593600 root 2690  owner 0 offset 0
Jan 20 22:00:14 streamlet kernel: ------------[ cut here ]------------
Jan 20 22:00:14 streamlet kernel: WARNING: CPU: 1 PID: 4964 at /usr/src/linux-4.1.12-gentoo/fs/btrfs/super.c:260 __btrfs_abort_transaction+0x46/0x104()
Jan 20 22:00:14 streamlet kernel: BTRFS: Transaction aborted (error -2)
Jan 20 22:00:14 streamlet kernel: Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 cls_u32 cls_flow cls_fw sch_sfq sch_prio sch_tbf xt_nat ip6table_nat nf_nat_ipv6 ip6t_REJECT nf_reject_ipv6 ip6table_mangle ip6table_raw nf_log_ipv6 ip6table_filter ip6_tables xt_recent xt_comment iptable_nat nf_nat_ipv4 ipt_REJECT nf_reject_ipv4 xt_addrtype xt_mark iptable_mangle xt_TCPMSS xt_CT iptable_raw xt_multiport xt_conntrack xt_NFLOG xt_LOG nf_log_ipv4 nf_log_common nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_nat nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
Jan 20 22:00:14 streamlet kernel:  nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp iptable_filter w83627ehf hwmon_vid ipmi_devintf ipmi_si ipmi_msghandler pppoe pppox ppp_generic slhc 8021q binfmt_misc tun bcache coretemp pl2303 ftdi_sio e1000e usbserial ptp pps_core parport_pc parport acpi_cpufreq processor [last unloaded: microcode]
Jan 20 22:00:14 streamlet kernel: CPU: 1 PID: 4964 Comm: btrfs-cleaner Tainted: G        W       4.1.12-gentoo #1
Jan 20 22:00:14 streamlet kernel: Hardware name: Supermicro X7SPA-HF/X7SPA-HF, BIOS 1.1b       12/31/10  
Jan 20 22:00:14 streamlet kernel:  0000000000000000 0000000000000009 ffffffff8153608f ffff8800aa58bad8
Jan 20 22:00:14 streamlet kernel:  ffffffff8105c014 ffff8800aa58baf0 ffffffff812060b8 ffffffff816e5ac2
Jan 20 22:00:14 streamlet kernel:  00000000fffffffe ffff8800b0ecfb00 ffffffff81573b40 0000000000001858
Jan 20 22:00:14 streamlet kernel: Call Trace:
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8153608f>] ? dump_stack+0x40/0x50
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8105c014>] ? warn_slowpath_common+0x99/0xb2
Jan 20 22:00:14 streamlet kernel:  [<ffffffff812060b8>] ? __btrfs_abort_transaction+0x46/0x104
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8105c073>] ? warn_slowpath_fmt+0x46/0x4c
Jan 20 22:00:14 streamlet kernel:  [<ffffffff812060b8>] ? __btrfs_abort_transaction+0x46/0x104
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81213d60>] ? __btrfs_free_extent+0x3fe/0x843
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81264036>] ? btrfs_merge_delayed_refs+0x197/0x1af
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81219846>] ? __btrfs_run_delayed_refs+0xac9/0xc66
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8121b631>] ? btrfs_run_delayed_refs+0x61/0x189
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81217fe1>] ? walk_up_tree+0x85/0xf7
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81228d3d>] ? btrfs_should_end_transaction+0x48/0x56
Jan 20 22:00:14 streamlet kernel:  [<ffffffff8121a22c>] ? btrfs_drop_snapshot+0x364/0x658
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81076a43>] ? finish_task_switch+0x5b/0xab
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81537400>] ? __schedule+0x2af/0x476
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81229128>] ? btrfs_clean_one_deleted_snapshot+0x9b/0xa5
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81222b64>] ? cleaner_kthread+0xff/0x125
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81222a65>] ? btree_writepages+0x56/0x56
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81071aa8>] ? kthread+0x9a/0xa2
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81070000>] ? __task_pid_nr_ns+0x21/0x4b
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81071a0e>] ? __kthread_parkme+0x57/0x57
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81539d12>] ? ret_from_fork+0x42/0x70
Jan 20 22:00:14 streamlet kernel:  [<ffffffff81071a0e>] ? __kthread_parkme+0x57/0x57
Jan 20 22:00:14 streamlet kernel: ---[ end trace 8ecb608839ff984c ]---
Jan 20 22:00:14 streamlet kernel: BTRFS: error (device bcache1) in __btrfs_free_extent:6232: errno=-2 No such entry
Jan 20 22:00:14 streamlet kernel: BTRFS info (device bcache1): forced readonly
Jan 20 22:00:14 streamlet kernel: BTRFS: error (device bcache1) in btrfs_run_delayed_refs:2821: errno=-2 No such entry


btrfsck -p gives me the following output

.. lots more of bad metadata ...
bad metadata [761107972096, 761107988480) crossing stripe boundary
bad metadata [761110659072, 761110675456) crossing stripe boundary
bad metadata [761173442560, 761173458944) crossing stripe boundary
Backref 761183813632 parent 762333560832 not referenced back 0x55eea0474ff0
Backref 761183813632 parent 762333593600 root 762333593600 not found in extent tree
Incorrect global backref count on 761183813632 found 1360 wanted 1359
backpointer mismatch on [761183813632 16384]
bad metadata [761198084096, 761198100480) crossing stripe boundary
bad metadata [761211650048, 761211666432) crossing stripe boundary
bad metadata [761222922240, 761222938624) crossing stripe boundary
.. lots more of bad metadata ...
checking free space cache [o]
checking fs roots [o]
checking csums
checking root refs
found 3478410000554 bytes used err is 0
total csum bytes: 2591003688
total tree bytes: 6232145920
total fs tree bytes: 2885287936
total extent tree bytes: 560168960
btree space waste bytes: 1086677424
file data blocks allocated: 8673027702784
 referenced 7125404991488

Linux streamlet 4.1.12-gentoo #1 SMP Sun Jan 17 13:39:02 CET 2016 x86_64 Intel(R) Atom(TM) CPU D510 @ 1.66GHz GenuineIntel GNU/Linux

btrfs-progs v4.4

# btrfs fi show /mnt/data
Label: 'data'  uuid: 1fb13642-17e0-4062-85e5-d25ac9ca1a5b
	Total devices 1 FS bytes used 3.16TiB
	devid    1 size 3.64TiB used 3.19TiB path /dev/bcache1


# btrfs fi df /mnt/data
Data, single: total=3.17TiB, used=3.16TiB
System, DUP: total=32.00MiB, used=384.00KiB
Metadata, DUP: total=7.00GiB, used=5.80GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

