Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34927 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab3FEO6L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 10:58:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UkFA8-0008Bi-Bq
	for linux-btrfs@vger.kernel.org; Wed, 05 Jun 2013 16:58:08 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 16:58:08 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 16:58:08 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs raid1 on 16TB goes read-only after "btrfs: block rsv returned
 -28"
Date: Wed, 05 Jun 2013 15:57:42 +0100
Message-ID: <konjl0$r06$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Devs,

I have x4 4TB HDDs formatted with:

mkfs.btrfs -L bu-16TB_0 -d raid1 -m raid1 /dev/sd[cdef]


/etc/fstab mounts with the options:

noatime,noauto,space_cache,inode_cache


All on kernel 3.8.13.


Upon using rsync to copy some heavily hardlinked backups from ReiserFS,
I've seen:


The following "block rsv returned -28" is repeated 7 times until there
is a call trace for:

"WARNING: at fs/btrfs/super.c:256 __btrfs_abort_transaction+0x3d/0xad()".

Then, the mount is set read-only.


How to fix or debug?

Thanks,
Martin



kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/btrfs/extent-tree.c:6372
btrfs_alloc_free_block+0xd3/0x29c()
kernel: Hardware name: GA-MA790FX-DS5
kernel: btrfs: block rsv returned -28
kernel: Modules linked in: raid456 async_raid6_recov async_memcpy
async_pq async_xor xor async_tx raid6_pq act_police cls_basic cls_flow
cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress
sch_sfq xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_LOG xt_time
xt_connlimit xt_realm xt_addrtype xt_comment xt_recent xt_policy xt_nat
ipt_ULOG ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set
ip_set nf_nat
_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_conntrack_tftp
nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp
nf_conntrack_pptp nf_
conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_tcpmss xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG
nfnetlink_log xt_multiport xt_mar
k xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp
xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_i
pv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables
x_tables bridge stp llc rtc snd_hda_codec_realtek fbcon bitblit
softcursor font nouveau video mxm_wmi cfbfillrect cfbimgblt cfbcopyarea
i2c_algo_bit evdev d
rm_kms_helper snd_hda_intel ttm snd_hda_codec drm i2c_piix4 pcspkr
snd_pcm serio_raw snd_page_alloc snd_timer k8temp snd i2c_core processor
button thermal_sys sky2 wmi backlight fb fbdev pata_acpi firewire_ohci
firewire_cor
e pata_atiixp usbhid pata_jmicron sata_sil24
kernel: Pid: 10980, comm: btrfs-transacti Not tainted 3.8.13-gentoo #1
kernel: Call Trace:
kernel: [<ffffffff811e6600>] ? btrfs_init_new_buffer+0xef/0xf6
kernel: [<ffffffff810289c8>] ? warn_slowpath_common+0x78/0x8c
kernel: [<ffffffff81028a74>] ? warn_slowpath_fmt+0x45/0x4a
kernel: [<ffffffff81278f2c>] ? ___ratelimit+0xc4/0xd0
kernel: [<ffffffff811e66da>] ? btrfs_alloc_free_block+0xd3/0x29c
kernel: [<ffffffff811d68e5>] ? __btrfs_cow_block+0x136/0x454
kernel: [<ffffffff811f0d47>] ? btrfs_buffer_uptodate+0x40/0x56
kernel: [<ffffffff811d6d8c>] ? btrfs_cow_block+0x132/0x19d
kernel: [<ffffffff811da606>] ? btrfs_search_slot+0x2f5/0x624
kernel: [<ffffffff811dbc5a>] ? btrfs_insert_empty_items+0x5c/0xaf
kernel: [<ffffffff811e5089>] ? run_clustered_refs+0x852/0x8e6
kernel: [<ffffffff811e4d20>] ? run_clustered_refs+0x4e9/0x8e6
kernel: [<ffffffff811e7f6b>] ? btrfs_run_delayed_refs+0x10d/0x289
kernel: [<ffffffff811f4ec6>] ? btrfs_commit_transaction+0x3a5/0x93c
kernel: [<ffffffff810427f0>] ? abort_exclusive_wait+0x79/0x79
kernel: [<ffffffff811f5a8c>] ? start_transaction+0x311/0x408
kernel: [<ffffffff811eed7e>] ? transaction_kthread+0xd1/0x16d
kernel: [<ffffffff811eecad>] ? btrfs_alloc_root+0x34/0x34
kernel: [<ffffffff810420b3>] ? kthread+0xad/0xb5
kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
kernel: [<ffffffff814315ac>] ? ret_from_fork+0x7c/0xb0
kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
kernel: ---[ end trace b584e8ceb642293f ]---
kernel: ------------[ cut here ]------------



kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/btrfs/super.c:256
__btrfs_abort_transaction+0x3d/0xad()
kernel: Hardware name: GA-MA790FX-DS5
kernel: btrfs: Transaction aborted
kernel: Modules linked in: raid456 async_raid6_recov async_memcpy
async_pq async_xor xor async_tx raid6_pq act_police cls_basic cls_flow
cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress
sch_sfq xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_LOG xt_time
xt_connlimit xt_realm xt_addrtype xt_comment xt_recent xt_policy xt_nat
ipt_ULOG ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set
ip_set nf_nat
_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_conntrack_tftp
nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp
nf_conntrack_pptp nf_
conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_tcpmss xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG
nfnetlink_log xt_multiport xt_mar
k xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp
xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_i
pv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables
x_tables bridge stp llc rtc snd_hda_codec_realtek fbcon bitblit
softcursor font nouveau video mxm_wmi cfbfillrect cfbimgblt cfbcopyarea
i2c_algo_bit evdev d
rm_kms_helper snd_hda_intel ttm snd_hda_codec drm i2c_piix4 pcspkr
snd_pcm serio_raw snd_page_alloc snd_timer k8temp snd i2c_core processor
button thermal_sys sky2 wmi backlight fb fbdev pata_acpi firewire_ohci
firewire_cor
e pata_atiixp usbhid pata_jmicron sata_sil24
kernel: Pid: 10980, comm: btrfs-transacti Tainted: G        W
3.8.13-gentoo #1
kernel: Call Trace:
kernel: [<ffffffff811d3600>] ? btrfs_printk+0x12/0xc2
kernel: [<ffffffff810289c8>] ? warn_slowpath_common+0x78/0x8c
kernel: [<ffffffff81028a74>] ? warn_slowpath_fmt+0x45/0x4a
kernel: [<ffffffff811d5e00>] ? btrfs_release_path+0x5e/0x79
kernel: [<ffffffff811d36ed>] ? __btrfs_abort_transaction+0x3d/0xad
kernel: [<ffffffff811ed97b>] ? btrfs_save_ino_cache+0x1d4/0x348
kernel: [<ffffffff8142ce4c>] ? commit_fs_roots.isra.25+0xa1/0x14a
kernel: [<ffffffff81237a0f>] ? btrfs_scrub_pause+0xd5/0xe4
kernel: [<ffffffff811f4f1a>] ? btrfs_commit_transaction+0x3f9/0x93c
kernel: [<ffffffff810427f0>] ? abort_exclusive_wait+0x79/0x79
kernel: [<ffffffff811f5a8c>] ? start_transaction+0x311/0x408
kernel: [<ffffffff811eed7e>] ? transaction_kthread+0xd1/0x16d
kernel: [<ffffffff811eecad>] ? btrfs_alloc_root+0x34/0x34
kernel: [<ffffffff810420b3>] ? kthread+0xad/0xb5
kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
kernel: [<ffffffff814315ac>] ? ret_from_fork+0x7c/0xb0
kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
kernel: ---[ end trace b584e8ceb6422945 ]---
kernel: BTRFS error (device sdf) in btrfs_save_ino_cache:471: error 28
kernel: btrfs is forced readonly
kernel: BTRFS warning (device sdf): Skipping commit of aborted transaction.
kernel: BTRFS error (device sdf) in cleanup_transaction:1391: error 28



