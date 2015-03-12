Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60556 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbbCLIPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 04:15:15 -0400
MIME-Version: 1.0
Message-ID: <trinity-81564b1d-6368-4aa8-aaac-3ed3ee583b5c-1426148112807@3capp-mailcom-bs09>
From: "Mark Connor" <markc44@gmx.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs_delayed_qgroup_accounting crashes from 3.13 up to 3.19
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Mar 2015 09:15:12 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

We have a btrfs based backup system where files getting rsynced daily from different servers to this backup server.

I keep getting these type of errors in the kernel log, what is the cause of this and will this be different with the 4.0RC kernel?

This is something related to the quota:


[Wed Mar 11 20:16:47 2015] WARNING: CPU: 2 PID: 2617 at /build/linux-50mAO0/linux-3.16.7-ckt4/fs/btrfs/qgroup.c:1353 btrfs_delayed_qgroup_accounting+0x47a/0xa
c0 [btrfs]()
[Wed Mar 11 20:16:47 2015] Modules linked in: veth xt_nat xt_tcpudp xt_addrtype xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_de
frag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables bridge stp llc aufs(C) fuse usb_storage sg joydev hid_generic ast ttm usbhid hid drm_kms_helper d
rm x86_pkg_temp_thermal btrfs intel_powerclamp coretemp kvm_intel kvm xor crct10dif_pclmul crc32_pclmul raid6_pq crc32c_intel ghash_clmulni_intel aesni_intel
igb sb_edac dca i2c_algo_bit tpm_tis aes_x86_64 edac_core i2c_i801 i2c_core lrw gf128mul mei_me glue_helper mei e1000e ipmi_si iTCO_wdt iTCO_vendor_support pt
p pps_core ehci_pci ehci_hcd usbcore lpc_ich shpchp usb_common evdev pcspkr mfd_core ablk_helper cryptd tpm ipmi_msghandler processor wmi thermal_sys button e
xt4 crc16 mbcache jbd2 raid1 md_mod sd_mod sr_mod cdrom crc_t10dif crct10dif_common isci libsas ahci libahci libata scsi_transport_sas scsi_mod dm_mirror dm_r
egion_hash dm_log dm_mod
[Wed Mar 11 20:16:47 2015] CPU: 2 PID: 2617 Comm: btrfs-transacti Tainted: G        WC    3.16.0-0.bpo.4-amd64 #1 Debian 3.16.7-ckt4-3~bpo70+1
[Wed Mar 11 20:16:47 2015] Hardware name: LENOVO ThinkServer RD440   /ThinkServer RD440, BIOS A0TS66A 01/24/2014
[Wed Mar 11 20:16:47 2015]  0000000000000000 ffffffffa05c3e80 ffffffff81543593 0000000000000000
[Wed Mar 11 20:16:47 2015]  ffffffff8106deec ffff8802db9b2318 ffff88046af70000 ffff8802db9b22c0
[Wed Mar 11 20:16:47 2015]  ffff880078693788 ffffffffffffffff ffffffffa05a480a ffff88045ddfbd74
[Wed Mar 11 20:16:47 2015] Call Trace:
[Wed Mar 11 20:16:47 2015]  [<ffffffff81543593>] ? dump_stack+0x41/0x51
[Wed Mar 11 20:16:47 2015]  [<ffffffff8106deec>] ? warn_slowpath_common+0x8c/0xc0
[Wed Mar 11 20:16:47 2015]  [<ffffffffa05a480a>] ? btrfs_delayed_qgroup_accounting+0x47a/0xac0 [btrfs]
[Wed Mar 11 20:16:47 2015]  [<ffffffffa052f9c6>] ? btrfs_run_delayed_refs+0x236/0x2a0 [btrfs]
[Wed Mar 11 20:16:47 2015]  [<ffffffffa0540846>] ? btrfs_commit_transaction+0x46/0xa50 [btrfs]
[Wed Mar 11 20:16:47 2015]  [<ffffffffa053e755>] ? transaction_kthread+0x1d5/0x250 [btrfs]
[Wed Mar 11 20:16:47 2015]  [<ffffffffa053e580>] ? open_ctree+0x1f20/0x1f20 [btrfs]
[Wed Mar 11 20:16:47 2015]  [<ffffffff81090541>] ? kthread+0xc1/0xe0
[Wed Mar 11 20:16:47 2015]  [<ffffffff81090480>] ? flush_kthread_worker+0xb0/0xb0
[Wed Mar 11 20:16:47 2015]  [<ffffffff815499bc>] ? ret_from_fork+0x7c/0xb0
[Wed Mar 11 20:16:47 2015]  [<ffffffff81090480>] ? flush_kthread_worker+0xb0/0xb0
[Wed Mar 11 20:16:47 2015] ---[ end trace 36ffcbc6fdff8b0f ]---
[Wed Mar 11 20:29:57 2015] ------------[ cut here ]------------


[Thu Mar 12 07:39:55 2015] ------------[ cut here ]------------
[Thu Mar 12 07:39:55 2015] WARNING: CPU: 1 PID: 2616 at /build/linux-50mAO0/linux-3.16.7-ckt4/fs/btrfs/qgroup.c:1353 btrfs_delayed_qgroup_accounting+0x47a/0xa
c0 [btrfs]()
[Thu Mar 12 07:39:55 2015] Modules linked in: veth xt_nat xt_tcpudp xt_addrtype xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_de
frag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables bridge stp llc aufs(C) fuse usb_storage sg joydev hid_generic ast ttm usbhid hid drm_kms_helper d
rm x86_pkg_temp_thermal btrfs intel_powerclamp coretemp kvm_intel kvm xor crct10dif_pclmul crc32_pclmul raid6_pq crc32c_intel ghash_clmulni_intel aesni_intel
igb sb_edac dca i2c_algo_bit tpm_tis aes_x86_64 edac_core i2c_i801 i2c_core lrw gf128mul mei_me glue_helper mei e1000e ipmi_si iTCO_wdt iTCO_vendor_support pt
p pps_core ehci_pci ehci_hcd usbcore lpc_ich shpchp usb_common evdev pcspkr mfd_core ablk_helper cryptd tpm ipmi_msghandler processor wmi thermal_sys button e
xt4 crc16 mbcache jbd2 raid1 md_mod sd_mod sr_mod cdrom crc_t10dif crct10dif_common isci libsas ahci libahci libata scsi_transport_sas scsi_mod dm_mirror dm_r
egion_hash dm_log dm_mod
[Thu Mar 12 07:39:55 2015] CPU: 1 PID: 2616 Comm: btrfs-cleaner Tainted: G        WC    3.16.0-0.bpo.4-amd64 #1 Debian 3.16.7-ckt4-3~bpo70+1
[Thu Mar 12 07:39:55 2015] Hardware name: LENOVO ThinkServer RD440   /ThinkServer RD440, BIOS A0TS66A 01/24/2014
[Thu Mar 12 07:39:55 2015]  0000000000000000 ffffffffa05c3e80 ffffffff81543593 0000000000000000
[Thu Mar 12 07:39:55 2015]  ffffffff8106deec ffff88026b210d18 ffff88046af70000 ffff88026b210cc0
[Thu Mar 12 07:39:55 2015]  ffff8800791e4e48 ffffffffffffffff ffffffffa05a480a ffff88045ddf7d04
[Thu Mar 12 07:39:55 2015] Call Trace:
[Thu Mar 12 07:39:55 2015]  [<ffffffff81543593>] ? dump_stack+0x41/0x51
[Thu Mar 12 07:39:55 2015]  [<ffffffff8106deec>] ? warn_slowpath_common+0x8c/0xc0
[Thu Mar 12 07:39:55 2015]  [<ffffffffa05a480a>] ? btrfs_delayed_qgroup_accounting+0x47a/0xac0 [btrfs]
[Thu Mar 12 07:39:55 2015]  [<ffffffffa052f9c6>] ? btrfs_run_delayed_refs+0x236/0x2a0 [btrfs]
[Thu Mar 12 07:39:55 2015]  [<ffffffffa052b16d>] ? walk_up_tree+0xcd/0x1f0 [btrfs]
[Thu Mar 12 07:39:55 2015]  [<ffffffffa054046c>] ? btrfs_should_end_transaction+0x4c/0x90 [btrfs]
[Thu Mar 12 07:39:55 2015]  [<ffffffffa052dfe1>] ? btrfs_drop_snapshot+0x441/0x790 [btrfs]
[Thu Mar 12 07:39:55 2015]  [<ffffffff81545c8e>] ? __schedule+0x2de/0x770
[Thu Mar 12 07:39:55 2015]  [<ffffffffa0542155>] ? btrfs_clean_one_deleted_snapshot+0xc5/0x110 [btrfs]
[Thu Mar 12 07:39:55 2015]  [<ffffffffa0539350>] ? cleaner_kthread+0x120/0x180 [btrfs]
[Thu Mar 12 07:39:55 2015]  [<ffffffffa0539230>] ? btree_readpage_end_io_hook+0x2c0/0x2c0 [btrfs]
[Thu Mar 12 07:39:55 2015]  [<ffffffff81090541>] ? kthread+0xc1/0xe0
[Thu Mar 12 07:39:55 2015]  [<ffffffff81090480>] ? flush_kthread_worker+0xb0/0xb0
[Thu Mar 12 07:39:55 2015]  [<ffffffff815499bc>] ? ret_from_fork+0x7c/0xb0
[Thu Mar 12 07:39:55 2015]  [<ffffffff81090480>] ? flush_kthread_worker+0xb0/0xb0
[Thu Mar 12 07:39:55 2015] ---[ end trace 36ffcbc6fdff8b14 ]---
[Thu Mar 12 07:41:04 2015] ------------[ cut here ]------------


I don't want to copy in more, they are all look similar, something related to the qgroup. It cannot be a hardware error because we moved the backup system to a brand new server and it's doing the exact same thing on the new server with more cpu cores, ram and different raid controller.

My btrfs-tools is from the backports:
Btrfs v3.14.1

The system is the latest Debian Wheezy (running 3.16.0-0.bpo.4-amd64 at the moment).


Thanks
 
