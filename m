Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:40234 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbbLKRXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 12:23:22 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.80)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1a7RPd-00078b-0s
	for linux-btrfs@vger.kernel.org; Fri, 11 Dec 2015 18:23:21 +0100
Date: Fri, 11 Dec 2015 18:23:20 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Transaction aborted (error -17) during balance
Message-ID: <20151211172320.GQ17936@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

during a balance on my main notebook, I have received the following
call trace:

[ 1545.229672] ------------[ cut here ]------------
[ 1545.229688] WARNING: CPU: 4 PID: 5545 at /build/linux-eGTGmU/linux-4.3/fs/btrfs/extent-tree.c:2093 __btrfs_inc_extent_ref.isra.52+0x20e/0x280 [btrfs]()
[ 1545.229689] BTRFS: Transaction aborted (error -17)
[ 1545.229690] Modules linked in: ctr ccm tun rfcomm cpufreq_userspace binfmt_misc cpufreq_stats cpufreq_powersave cpufreq_conservative nf_conntrack_netlink nfnetlink bnep ip6table_filter ip6_tables xt_TCPMSS xt_tcpudp iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables bridge stp llc joydev arc4 iTCO_wdt iwldvm iTCO_vendor_support mac80211 snd_hda_codec_conexant intel_rapl snd_hda_codec_generic iosf_mbi x86_pkg_temp_thermal btusb intel_powerclamp btrtl snd_hda_intel iwlwifi btbcm kvm_intel snd_hda_codec btintel kvm snd_hda_core psmouse bluetooth snd_hwdep snd_pcm_oss pcspkr serio_raw i2c_i801 sg cfg80211 snd_mixer_oss lpc_ich snd_pcm mfd_core snd_timer mei_me shpchp mei thinkpad_acpi nvram
[ 1545.229718]  tpm_tis snd tpm soundcore rfkill evdev battery ac processor coretemp loop drbd lru_cache libcrc32c parport_pc ppdev lp parport autofs4 btrfs xor raid6_pq ext4 crc16 mbcache jbd2 algif_skcipher af_alg dm_crypt dm_mod md_mod hid_generic hid_logitech_hidpp hid_logitech_dj usbhid hid sd_mod uas usb_storage crct10dif_pclmul crc32_pclmul crc32c_intel jitterentropy_rng sha256_ssse3 sha256_generic hmac drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper i915 ahci ablk_helper cryptd libahci sdhci_pci i2c_algo_bit libata ehci_pci drm_kms_helper sdhci ehci_hcd scsi_mod mmc_core e1000e usbcore ptp usb_common drm pps_core thermal wmi video button
[ 1545.229747] CPU: 4 PID: 5545 Comm: kworker/u16:1 Not tainted 4.3.0-trunk-amd64 #1 Debian 4.3-1~exp2
[ 1545.229747] Hardware name: LENOVO 4240CTO/4240CTO, BIOS 8AET63WW (1.43 ) 05/08/2013
[ 1545.229758] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 1545.229760]  ffffffffa0627250 ffffffff812c5319 ffff88020dc23ba0 ffffffff8106ebcd
[ 1545.229761]  ffff880406146000 ffff88020dc23bf0 ffff8803c90b9410 0000000000000000
[ 1545.229762]  0000000000000106 ffffffff8106ec4c ffffffffa0627420 ffffffff00000020
[ 1545.229764] Call Trace:
[ 1545.229768]  [<ffffffff812c5319>] ? dump_stack+0x40/0x57
[ 1545.229771]  [<ffffffff8106ebcd>] ? warn_slowpath_common+0x7d/0xb0
[ 1545.229772]  [<ffffffff8106ec4c>] ? warn_slowpath_fmt+0x4c/0x50
[ 1545.229778]  [<ffffffffa058bdc9>] ? insert_tree_block_ref+0x49/0x60 [btrfs]
[ 1545.229783]  [<ffffffffa058fc6e>] ? __btrfs_inc_extent_ref.isra.52+0x20e/0x280 [btrfs]
[ 1545.229789]  [<ffffffffa0594e77>] ? __btrfs_run_delayed_refs+0xc47/0x1050 [btrfs]
[ 1545.229792]  [<ffffffff8101d3b5>] ? sched_clock+0x5/0x10
[ 1545.229795]  [<ffffffff81094130>] ? check_preempt_curr+0x50/0x90
[ 1545.229797]  [<ffffffff81094184>] ? ttwu_do_wakeup+0x14/0xc0
[ 1545.229803]  [<ffffffffa0597e98>] ? btrfs_run_delayed_refs+0x78/0x2a0 [btrfs]
[ 1545.229808]  [<ffffffffa05980f2>] ? delayed_ref_async_start+0x32/0x80 [btrfs]
[ 1545.229816]  [<ffffffffa05daeb8>] ? btrfs_scrubparity_helper+0xc8/0x260 [btrfs]
[ 1545.229818]  [<ffffffff810851df>] ? process_one_work+0x19f/0x3d0
[ 1545.229819]  [<ffffffff8108545d>] ? worker_thread+0x4d/0x450
[ 1545.229821]  [<ffffffff81085410>] ? process_one_work+0x3d0/0x3d0
[ 1545.229822]  [<ffffffff8108af5d>] ? kthread+0xbd/0xe0
[ 1545.229824]  [<ffffffff8108aea0>] ? kthread_create_on_node+0x170/0x170
[ 1545.229827]  [<ffffffff81553d0f>] ? ret_from_fork+0x3f/0x70
[ 1545.229829]  [<ffffffff8108aea0>] ? kthread_create_on_node+0x170/0x170
[ 1545.229830] ---[ end trace 6671e30ac2882b40 ]---
[ 1545.229832] BTRFS: error (device dm-11) in __btrfs_inc_extent_ref:2093: errno=-17 Object already exists
[ 1545.229834] BTRFS info (device dm-11): forced readonly
[ 1545.229836] BTRFS: error (device dm-11) in btrfs_run_delayed_refs:2851: errno=-17 Object already exists

I have been trying to balance this filesystem for the better part of
the afternoon, with numerous freezes of my notebook. I was able to
finish the balance by not doing anything on the notebook while the
balance was running. I then proceeded to initiate a second rebalance
of the same filesystem "just to be sure", which led to a read-only
btrfs and me at least being able to obtain this trace.

This is a distribution kernel, I have debug symbols installed after
this log extrct was obtained. Is there a tool which can help to make
this trace useable?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
