Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35626 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbLKRu7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 12:50:59 -0500
Received: by lfdl133 with SMTP id l133so83175167lfd.2
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2015 09:50:57 -0800 (PST)
Received: from desktop.raorg.org ([176.108.148.76])
        by smtp.gmail.com with ESMTPSA id k14sm3438857lfb.49.2015.12.11.09.50.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Dec 2015 09:50:56 -0800 (PST)
Date: Fri, 11 Dec 2015 20:50:55 +0300
From: Ivan Sizov <sivan606@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Will "btrfs check --repair" fix the mounting problem?
Message-ID: <566b0cff.pXiyzYE4dYIOt31+%sivan606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs crashes in few seconds after mounting RW.
If it's important: the volume was converted from ext4. "ext2_saved"
subvolume still presents.

dmesg:
[  625.998387] BTRFS info (device sda1): disk space caching is enabled
[  625.998392] BTRFS: has skinny extents
[  627.727708] BTRFS: checking UUID tree
[  708.514128] ------------[ cut here ]------------
[  708.514161] WARNING: CPU: 1 PID: 2263 at fs/btrfs/extent-tree.c:6255 __btrfs_free_extent.isra.68+0x8c8/0xd70 [btrfs]()
[  708.514164] Modules linked in: bnep bluetooth rfkill ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_broute bridge ebtable_filter ebtable_nat ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw ip6table_security ip6table_mangle ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_security iptable_mangle gpio_ich coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device lpc_ich snd_pcm snd_timer ppdev snd i2c_i801 mei_me mei soundcore parport_pc parport shpchp tpm_infineon tpm_tis tpm acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace isofs squashfs btrfs xor raid6_pq i915 hid_logitech_hidpp
[  708.514277]  8021q garp stp video llc mrp i2c_algo_bit drm_kms_helper r8169 uas crc32c_intel drm serio_raw mii hid_logitech_dj usb_storage scsi_dh_rdac scsi_dh_emc scsi_dh_alua sunrpc loop
[  708.514311] CPU: 1 PID: 2263 Comm: btrfs-transacti Not tainted 4.2.3-300.fc23.x86_64 #1
[  708.514315] Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
[  708.514319]  0000000000000000 00000000f50458a6 ffff880066b03ad8 ffffffff81771fca
[  708.514326]  0000000000000000 0000000000000000 ffff880066b03b18 ffffffff8109e4a6
[  708.514332]  0000000000000002 000000252f595000 00000000fffffffe 0000000000000000
[  708.514338] Call Trace:
[  708.514349]  [<ffffffff81771fca>] dump_stack+0x45/0x57
[  708.514359]  [<ffffffff8109e4a6>] warn_slowpath_common+0x86/0xc0
[  708.514365]  [<ffffffff8109e5da>] warn_slowpath_null+0x1a/0x20
[  708.514391]  [<ffffffffa0305628>] __btrfs_free_extent.isra.68+0x8c8/0xd70 [btrfs]
[  708.514429]  [<ffffffffa036da5a>] ? find_ref_head+0x5a/0x80 [btrfs]
[  708.514456]  [<ffffffffa03093c8>] __btrfs_run_delayed_refs+0x998/0x1080 [btrfs]
[  708.514477]  [<ffffffffa030c674>] btrfs_run_delayed_refs.part.73+0x74/0x270 [btrfs]
[  708.514496]  [<ffffffffa030c885>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
[  708.514518]  [<ffffffffa0320f26>] btrfs_commit_transaction+0x56/0xad0 [btrfs]
[  708.514541]  [<ffffffffa031c604>] transaction_kthread+0x214/0x230 [btrfs]
[  708.514564]  [<ffffffffa031c3f0>] ? btrfs_cleanup_transaction+0x500/0x500 [btrfs]
[  708.514569]  [<ffffffff810bc8a8>] kthread+0xd8/0xf0
[  708.514574]  [<ffffffff810bc7d0>] ? kthread_worker_fn+0x160/0x160
[  708.514581]  [<ffffffff81778d9f>] ret_from_fork+0x3f/0x70
[  708.514585]  [<ffffffff810bc7d0>] ? kthread_worker_fn+0x160/0x160
[  708.514588] ---[ end trace 6731111f3bf2295a ]---
[  708.514594] BTRFS info (device sda1): leaf 535035904 total ptrs 204 free space 4451
[  708.514598] 	item 0 key (159696797696 169 0) itemoff 16250 itemsize 33
[  708.514601] 		extent refs 1 gen 21134 flags 2
[  708.514604] 		tree block backref root 2
[  708.514609] 	item 1 key (159696830464 169 1) itemoff 16217 itemsize 33
[  708.514612] 		extent refs 1 gen 21134 flags 2
[  708.514615] 		tree block backref root 2
[  708.514619] 	item 2 key (159696846848 169 0) itemoff 16184 itemsize 33

*********** a lot of similar messages ***********

[  708.516923] 	item 203 key (159711268864 169 0) itemoff 9551 itemsize 33
[  708.516927] 		extent refs 1 gen 21082 flags 2
[  708.516930] 		tree block backref root 384
[  708.516937] BTRFS error (device sda1): unable to find ref byte nr 159708172288 parent 0 root 385  owner 2 offset 0
[  708.516944] ------------[ cut here ]------------
[  708.516975] WARNING: CPU: 1 PID: 2263 at fs/btrfs/extent-tree.c:6261 __btrfs_free_extent.isra.68+0x92f/0xd70 [btrfs]()
[  708.516979] BTRFS: Transaction aborted (error -2)
[  708.516982] Modules linked in: bnep bluetooth rfkill ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_broute bridge ebtable_filter ebtable_nat ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw ip6table_security ip6table_mangle ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_security iptable_mangle gpio_ich coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device lpc_ich snd_pcm snd_timer ppdev snd i2c_i801 mei_me mei soundcore parport_pc parport shpchp tpm_infineon tpm_tis tpm acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace isofs squashfs btrfs xor raid6_pq i915 hid_logitech_hidpp
[  708.517075]  8021q garp stp video llc mrp i2c_algo_bit drm_kms_helper r8169 uas crc32c_intel drm serio_raw mii hid_logitech_dj usb_storage scsi_dh_rdac scsi_dh_emc scsi_dh_alua sunrpc loop
[  708.517108] CPU: 1 PID: 2263 Comm: btrfs-transacti Tainted: G        W       4.2.3-300.fc23.x86_64 #1
[  708.517112] Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
[  708.517115]  0000000000000000 00000000f50458a6 ffff880066b03a78 ffffffff81771fca
[  708.517123]  0000000000000000 ffff880066b03ad0 ffff880066b03ab8 ffffffff8109e4a6
[  708.517129]  ffffffffa03a0349 000000252f595000 00000000fffffffe 0000000000000000
[  708.517135] Call Trace:
[  708.517143]  [<ffffffff81771fca>] dump_stack+0x45/0x57
[  708.517150]  [<ffffffff8109e4a6>] warn_slowpath_common+0x86/0xc0
[  708.517157]  [<ffffffff8109e535>] warn_slowpath_fmt+0x55/0x70
[  708.517186]  [<ffffffffa030568f>] __btrfs_free_extent.isra.68+0x92f/0xd70 [btrfs]
[  708.517226]  [<ffffffffa036da5a>] ? find_ref_head+0x5a/0x80 [btrfs]
[  708.517262]  [<ffffffffa03093c8>] __btrfs_run_delayed_refs+0x998/0x1080 [btrfs]
[  708.517288]  [<ffffffffa030c674>] btrfs_run_delayed_refs.part.73+0x74/0x270 [btrfs]
[  708.517317]  [<ffffffffa030c885>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
[  708.517351]  [<ffffffffa0320f26>] btrfs_commit_transaction+0x56/0xad0 [btrfs]
[  708.517382]  [<ffffffffa031c604>] transaction_kthread+0x214/0x230 [btrfs]
[  708.517411]  [<ffffffffa031c3f0>] ? btrfs_cleanup_transaction+0x500/0x500 [btrfs]
[  708.517419]  [<ffffffff810bc8a8>] kthread+0xd8/0xf0
[  708.517425]  [<ffffffff810bc7d0>] ? kthread_worker_fn+0x160/0x160
[  708.517432]  [<ffffffff81778d9f>] ret_from_fork+0x3f/0x70
[  708.517439]  [<ffffffff810bc7d0>] ? kthread_worker_fn+0x160/0x160
[  708.517444] ---[ end trace 6731111f3bf2295b ]---
[  708.517450] BTRFS: error (device sda1) in __btrfs_free_extent:6261: errno=-2 No such entry
[  708.517455] BTRFS info (device sda1): forced readonly
[  708.517464] BTRFS: error (device sda1) in btrfs_run_delayed_refs:2781: errno=-2 No such entry
[  708.517580] pending csums is 139264
[  841.017119] BTRFS error (device sda1): cleaner transaction attach returned -30


I checked the filesystem extents:

$ sudo btrfs check --subvol-extents 5 /dev/sda1
Print extent state for subvolume 5 on /dev/sda1
UUID: 6de5c663-bc65-4120-8cf6-5309fd25aa7e
checksum verify failed on 159708168192 found 3659C180 wanted 8EE67C14
checksum verify failed on 159708168192 found 3659C180 wanted 8EE67C14
bytenr mismatch, want=159708168192, have=16968404070778227820
ERROR: while mapping refs: -5
extent_io.c:582: free_extent_buffer: Assertion `eb->refs < 0` failed.
btrfs(+0x51e9e)[0x56283f4bde9e]
btrfs(free_extent_buffer+0xc0)[0x56283f4be9b0]
btrfs(btrfs_free_fs_root+0x11)[0x56283f4aef11]
btrfs(rb_free_nodes+0x21)[0x56283f4d7cc1]
btrfs(close_ctree+0x194)[0x56283f4b0214]
btrfs(cmd_check+0x486)[0x56283f49ace6]
btrfs(main+0x82)[0x56283f47fad2]
/lib64/libc.so.6(__libc_start_main+0xf0)[0x7f8cbea98580]
btrfs(_start+0x29)[0x56283f47fbd9]
$

Will "btrfs check --repair" fix my problem or make it worse?
Fedora 23. Installed (but now broken) system has 4.2.5 kernel. A live
CD has kernel 4.2.3 with btrfs-progs 4.2.2!
