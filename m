Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56308 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3FEPFx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jun 2013 11:05:53 -0400
Date: Wed, 5 Jun 2013 16:05:49 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 on 16TB goes read-only after "btrfs: block rsv
 returned -28"
Message-ID: <20130605150549.GP20133@carfax.org.uk>
References: <konjl0$r06$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h9WqFG8zn/Mwlkpe"
In-Reply-To: <konjl0$r06$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--h9WqFG8zn/Mwlkpe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2013 at 03:57:42PM +0100, Martin wrote:
> Dear Devs,
> 
> I have x4 4TB HDDs formatted with:
> 
> mkfs.btrfs -L bu-16TB_0 -d raid1 -m raid1 /dev/sd[cdef]
> 
> 
> /etc/fstab mounts with the options:
> 
> noatime,noauto,space_cache,inode_cache
> 
> 
> All on kernel 3.8.13.
> 
> 
> Upon using rsync to copy some heavily hardlinked backups from ReiserFS,
> I've seen:
> 
> 
> The following "block rsv returned -28" is repeated 7 times until there
> is a call trace for:

   This is ENOSPC. Can you post the output of "btrfs fi df
/mountpoint" and "btrfs fi show", please?

   Hugo.

> "WARNING: at fs/btrfs/super.c:256 __btrfs_abort_transaction+0x3d/0xad()".
> 
> Then, the mount is set read-only.
> 
> 
> How to fix or debug?
> 
> Thanks,
> Martin
> 
> 
> 
> kernel: ------------[ cut here ]------------
> kernel: WARNING: at fs/btrfs/extent-tree.c:6372
> btrfs_alloc_free_block+0xd3/0x29c()
> kernel: Hardware name: GA-MA790FX-DS5
> kernel: btrfs: block rsv returned -28
> kernel: Modules linked in: raid456 async_raid6_recov async_memcpy
> async_pq async_xor xor async_tx raid6_pq act_police cls_basic cls_flow
> cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress
> sch_sfq xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_LOG xt_time
> xt_connlimit xt_realm xt_addrtype xt_comment xt_recent xt_policy xt_nat
> ipt_ULOG ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set
> ip_set nf_nat
> _tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp
> nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_conntrack_tftp
> nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp
> nf_conntrack_pptp nf_
> conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
> nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323
> nf_conntrack_ftp xt_tcpmss xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG
> nfnetlink_log xt_multiport xt_mar
> k xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
> xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp
> xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
> nf_defrag_i
> pv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables
> x_tables bridge stp llc rtc snd_hda_codec_realtek fbcon bitblit
> softcursor font nouveau video mxm_wmi cfbfillrect cfbimgblt cfbcopyarea
> i2c_algo_bit evdev d
> rm_kms_helper snd_hda_intel ttm snd_hda_codec drm i2c_piix4 pcspkr
> snd_pcm serio_raw snd_page_alloc snd_timer k8temp snd i2c_core processor
> button thermal_sys sky2 wmi backlight fb fbdev pata_acpi firewire_ohci
> firewire_cor
> e pata_atiixp usbhid pata_jmicron sata_sil24
> kernel: Pid: 10980, comm: btrfs-transacti Not tainted 3.8.13-gentoo #1
> kernel: Call Trace:
> kernel: [<ffffffff811e6600>] ? btrfs_init_new_buffer+0xef/0xf6
> kernel: [<ffffffff810289c8>] ? warn_slowpath_common+0x78/0x8c
> kernel: [<ffffffff81028a74>] ? warn_slowpath_fmt+0x45/0x4a
> kernel: [<ffffffff81278f2c>] ? ___ratelimit+0xc4/0xd0
> kernel: [<ffffffff811e66da>] ? btrfs_alloc_free_block+0xd3/0x29c
> kernel: [<ffffffff811d68e5>] ? __btrfs_cow_block+0x136/0x454
> kernel: [<ffffffff811f0d47>] ? btrfs_buffer_uptodate+0x40/0x56
> kernel: [<ffffffff811d6d8c>] ? btrfs_cow_block+0x132/0x19d
> kernel: [<ffffffff811da606>] ? btrfs_search_slot+0x2f5/0x624
> kernel: [<ffffffff811dbc5a>] ? btrfs_insert_empty_items+0x5c/0xaf
> kernel: [<ffffffff811e5089>] ? run_clustered_refs+0x852/0x8e6
> kernel: [<ffffffff811e4d20>] ? run_clustered_refs+0x4e9/0x8e6
> kernel: [<ffffffff811e7f6b>] ? btrfs_run_delayed_refs+0x10d/0x289
> kernel: [<ffffffff811f4ec6>] ? btrfs_commit_transaction+0x3a5/0x93c
> kernel: [<ffffffff810427f0>] ? abort_exclusive_wait+0x79/0x79
> kernel: [<ffffffff811f5a8c>] ? start_transaction+0x311/0x408
> kernel: [<ffffffff811eed7e>] ? transaction_kthread+0xd1/0x16d
> kernel: [<ffffffff811eecad>] ? btrfs_alloc_root+0x34/0x34
> kernel: [<ffffffff810420b3>] ? kthread+0xad/0xb5
> kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
> kernel: [<ffffffff814315ac>] ? ret_from_fork+0x7c/0xb0
> kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
> kernel: ---[ end trace b584e8ceb642293f ]---
> kernel: ------------[ cut here ]------------
> 
> 
> 
> kernel: ------------[ cut here ]------------
> kernel: WARNING: at fs/btrfs/super.c:256
> __btrfs_abort_transaction+0x3d/0xad()
> kernel: Hardware name: GA-MA790FX-DS5
> kernel: btrfs: Transaction aborted
> kernel: Modules linked in: raid456 async_raid6_recov async_memcpy
> async_pq async_xor xor async_tx raid6_pq act_police cls_basic cls_flow
> cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress
> sch_sfq xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_LOG xt_time
> xt_connlimit xt_realm xt_addrtype xt_comment xt_recent xt_policy xt_nat
> ipt_ULOG ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set
> ip_set nf_nat
> _tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp
> nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_conntrack_tftp
> nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp
> nf_conntrack_pptp nf_
> conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
> nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323
> nf_conntrack_ftp xt_tcpmss xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG
> nfnetlink_log xt_multiport xt_mar
> k xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
> xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp
> xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
> nf_defrag_i
> pv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables
> x_tables bridge stp llc rtc snd_hda_codec_realtek fbcon bitblit
> softcursor font nouveau video mxm_wmi cfbfillrect cfbimgblt cfbcopyarea
> i2c_algo_bit evdev d
> rm_kms_helper snd_hda_intel ttm snd_hda_codec drm i2c_piix4 pcspkr
> snd_pcm serio_raw snd_page_alloc snd_timer k8temp snd i2c_core processor
> button thermal_sys sky2 wmi backlight fb fbdev pata_acpi firewire_ohci
> firewire_cor
> e pata_atiixp usbhid pata_jmicron sata_sil24
> kernel: Pid: 10980, comm: btrfs-transacti Tainted: G        W
> 3.8.13-gentoo #1
> kernel: Call Trace:
> kernel: [<ffffffff811d3600>] ? btrfs_printk+0x12/0xc2
> kernel: [<ffffffff810289c8>] ? warn_slowpath_common+0x78/0x8c
> kernel: [<ffffffff81028a74>] ? warn_slowpath_fmt+0x45/0x4a
> kernel: [<ffffffff811d5e00>] ? btrfs_release_path+0x5e/0x79
> kernel: [<ffffffff811d36ed>] ? __btrfs_abort_transaction+0x3d/0xad
> kernel: [<ffffffff811ed97b>] ? btrfs_save_ino_cache+0x1d4/0x348
> kernel: [<ffffffff8142ce4c>] ? commit_fs_roots.isra.25+0xa1/0x14a
> kernel: [<ffffffff81237a0f>] ? btrfs_scrub_pause+0xd5/0xe4
> kernel: [<ffffffff811f4f1a>] ? btrfs_commit_transaction+0x3f9/0x93c
> kernel: [<ffffffff810427f0>] ? abort_exclusive_wait+0x79/0x79
> kernel: [<ffffffff811f5a8c>] ? start_transaction+0x311/0x408
> kernel: [<ffffffff811eed7e>] ? transaction_kthread+0xd1/0x16d
> kernel: [<ffffffff811eecad>] ? btrfs_alloc_root+0x34/0x34
> kernel: [<ffffffff810420b3>] ? kthread+0xad/0xb5
> kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
> kernel: [<ffffffff814315ac>] ? ret_from_fork+0x7c/0xb0
> kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
> kernel: ---[ end trace b584e8ceb6422945 ]---
> kernel: BTRFS error (device sdf) in btrfs_save_ino_cache:471: error 28
> kernel: btrfs is forced readonly
> kernel: BTRFS warning (device sdf): Skipping commit of aborted transaction.
> kernel: BTRFS error (device sdf) in cleanup_transaction:1391: error 28
> 
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I'm all for giving people enough rope to shoot themselves in ---   
                       the foot -- Andreas Dilger                        

--h9WqFG8zn/Mwlkpe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUa9TzFheFHXiqx3kAQKmgQ//bIG2aQNBItR9OzJGFe49kOFkjo/wx/b7
v8U1OfAXeYd75blGXHKpVVHV0XysqHTDtr6Y1pVN1MdXN7UTHkX7UifhsrLvzIjs
En0ZlZjrzEutL8yCZtW+ZKDOEEF0no7/LoMMr3ZAFamvUqphm6h/O/pgjc18tu5U
ob/qThA7EOODHQ1zj9bifnsLF9YlXNbaI7mfLUbc5XZcmwsP3folh2qPrnP090F0
r0t7aKT8iUi2YWlAs5YIT0bbGx0sr+cShi5RRXdyRtOdFJ0hL+/pCAVLYGt+Kr1b
mSjx0ideRAsjE2jLtZaErqIqiaLSyRrmf9/6c5tEZl/GOqUy6t1WQ5p3kXfINdnN
dIVy8NFrnnVVTzqi+zHNrENHZNlJG9Gq8Kg1gGWSyO2EBFRmAYvyM80xJg0qzOh+
UmxwyT2p+ZiFMlAK2S00PgVMqKkh/GX6rIp4MBSnaLZbRNYd9aLckE5uhfmE9d9k
3yx5gQPCqIIIWX0SSVochqGNa6KsndOIMSUnCOaEB58oHLcAtXFFMotVH6hk6rML
El8BbOmHPoOpiODs6qOo2HNx9A5NQ2zRtu3zHBku1j8DgAlx2UM269g548TzwXIl
h4EfC2LcCjy+SKBuqU2aQiRzSfkKNptFoVJzJLK+5WHoiNxc44yfu1sXyYXTirej
YXyCi3KA5eU=
=Gnvh
-----END PGP SIGNATURE-----

--h9WqFG8zn/Mwlkpe--
