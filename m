Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44469 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbbEOJaM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 05:30:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YtBwT-0004yi-2L
	for linux-btrfs@vger.kernel.org; Fri, 15 May 2015 11:30:05 +0200
Received: from 78-22-129-174.access.telenet.be ([78.22.129.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 11:30:05 +0200
Received: from fhimpe by 78-22-129-174.access.telenet.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 11:30:05 +0200
To: linux-btrfs@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: BTRFS: Transaction aborted (error -5) on 3.19.7
Date: Fri, 15 May 2015 09:26:09 +0000 (UTC)
Message-ID: <mj4e3g$so9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On my system with Linux 3.19.7, my /home btrfs file system was suddenly
mounted read-only, and I found underneath errors in the kernel log.

Is this a known problem with a fix available?

Should I run something like btrfs check --repair?

I'm using snapper on this file system to regularly make snapshots.

[  431.785656] BTRFS (device dm-2): parent transid verify failed on 32628736 wanted 80487 found 342631
[  431.785905] BTRFS (device dm-2): parent transid verify failed on 32628736 wanted 80487 found 342631
[  431.785927] ------------[ cut here ]------------
[  431.785967] WARNING: CPU: 3 PID: 1837 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120 [btrfs]()
[  431.785970] BTRFS: Transaction aborted (error -5)
[  431.785972] Modules linked in: ebtable_filter ebtables iptable_filter ip_tables binfmt_misc cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative nf_log_ipv6 nf_log_common xt_recent ip6table_nat nf_nat_ipv6 nf_nat xt_comment ip6t_REJECT nf_reject_ipv6 xt_addrtype xt_mark ip6table_mangle nf_conntrack_snmp xt_tcpudp xt_CT ip6table_raw xt_multiport nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack xt_NFLOG nfnetlink_log xt_LOG nf_conntrack_tftp nf_conntrack_sip nf_conntrack_sane nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nfnetlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp ts_kmp nf_conntrack_amanda nf_conntrack nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace
[  431.786169]  fscache sunrpc ip6table_filter ip6_tables x_tables rc_pinnacle_pctv_hd em28xx_rc tda18271 cxd2820r em28xx_dvb dvb_core em28xx tveeprom v4l2_common videodev media nct6775 hwmon_vid uas usb_storage joydev hid_generic hid_logitech_hidpp hid_logitech_dj usbhid hid ext4 crc16 mbcache jbd2 x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul amdkfd iTCO_wdt ghash_clmulni_intel iTCO_vendor_support evdev aesni_intel radeon aes_x86_64 lrw gf128mul glue_helper ttm ablk_helper cryptd drm_kms_helper pcspkr psmouse serio_raw sr_mod cdrom snd_hda_codec_realtek snd_hda_codec_generic sg snd_hda_codec_hdmi battery drm 8250_fintek i2c_algo_bit nuvoton_cir tpm_tis rc_core intel_smartconnect tpm video button snd_hda_intel snd_hda_controller snd_hda_codec i2c_i801 snd_hwdep
[  431.786652]  lpc_ich snd_pcm snd_timer snd soundcore mei_me xhci_pci ie31200_edac ehci_pci processor mei mfd_core xhci_hcd ehci_hcd i2c_core edac_core usbcore usb_common thermal_sys netconsole configfs r8169 mii fuse autofs4 btrfs xor raid6_pq dm_mod sd_mod crc32c_intel ahci libahci libata scsi_mod shpchp
[  431.786956] CPU: 3 PID: 1837 Comm: btrfs-cleaner Not tainted 3.19.7-desktop #7
[  431.786959] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H77 Pro4/MVP, BIOS P1.70 08/07/2013
[  431.786963]  0000000000000000 ffffffffa01ace32 ffffffff81562073 ffff8800c4c5fa78
[  431.786970]  ffffffff8106cee1 ffff8804154acbb0 00000000fffffffb ffff8804161f7000
[  431.786977]  ffffffffa01ab5f0 0000000000001766 ffffffff8106cf5a ffffffffa01af9d8
[  431.787087] Call Trace:
[  431.787101]  [<ffffffff81562073>] ? dump_stack+0x40/0x50
[  431.787108]  [<ffffffff8106cee1>] ? warn_slowpath_common+0x81/0xb0
[  431.787115]  [<ffffffff8106cf5a>] ? warn_slowpath_fmt+0x4a/0x50
[  431.787135]  [<ffffffffa0100a2b>] ? __btrfs_abort_transaction+0x4b/0x120 [btrfs]
[  431.787149]  [<ffffffffa011380f>] ? __btrfs_free_extent+0x30f/0xc60 [btrfs]
[  431.787166]  [<ffffffffa0176bad>] ? find_ref_head+0x5d/0x80 [btrfs]
[  431.787182]  [<ffffffffa0118d6b>] ? __btrfs_run_delayed_refs+0x42b/0x1250 [btrfs]
[  431.787196]  [<ffffffffa011a08d>] ? btrfs_free_tree_block+0x10d/0x250 [btrfs]
[  431.787212]  [<ffffffffa011ddfd>] ? btrfs_run_delayed_refs.part.66+0x6d/0x270 [btrfs]
[  431.787226]  [<ffffffffa011a7c0>] ? walk_up_tree+0xd0/0x1f0 [btrfs]
[  431.787241]  [<ffffffffa012e071>] ? btrfs_should_end_transaction+0x41/0x80 [btrfs]
[  431.787258]  [<ffffffffa011c49c>] ? btrfs_drop_snapshot+0x46c/0x880 [btrfs]
[  431.787274]  [<ffffffffa0183518>] ? btrfs_kill_all_delayed_nodes+0xd8/0xf0 [btrfs]
[  431.787288]  [<ffffffffa011f1e8>] ? btrfs_delete_unused_bgs+0x58/0x270 [btrfs]
[  431.787305]  [<ffffffffa012e570>] ? btrfs_clean_one_deleted_snapshot+0xb0/0x100 [btrfs]
[  431.787320]  [<ffffffffa0126c0c>] ? cleaner_kthread+0x15c/0x1b0 [btrfs]
[  431.787335]  [<ffffffffa0126ab0>] ? check_leaf+0x360/0x360 [btrfs]
[  431.787342]  [<ffffffff8108af83>] ? kthread+0xd3/0xf0
[  431.787349]  [<ffffffff8101d3b5>] ? sched_clock+0x5/0x10
[  431.787354]  [<ffffffff8108aeb0>] ? kthread_create_on_node+0x180/0x180
[  431.787360]  [<ffffffff81568518>] ? ret_from_fork+0x58/0x90
[  431.787365]  [<ffffffff8108aeb0>] ? kthread_create_on_node+0x180/0x180
[  431.787370] ---[ end trace 21d173b18a39a524 ]---
[  431.787376] BTRFS: error (device dm-2) in __btrfs_free_extent:5990: errno=-5 IO failure
[  431.787381] BTRFS info (device dm-2): forced readonly
[  431.787387] BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2792: errno=-5 IO failure

-- 
Frederik Himpe

