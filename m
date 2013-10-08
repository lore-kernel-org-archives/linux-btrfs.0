Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:6961 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754632Ab3JHV61 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 17:58:27 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:54040 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VTfIO-002Gne-Ou
	for linux-btrfs@vger.kernel.org; Tue, 08 Oct 2013 15:58:24 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Subject: regression, can't move subvols into subvols
Message-Id: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com>
Date: Tue, 8 Oct 2013 15:58:23 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't think this is expected, is it? I can no longer move a subvolume into another subvolume. I can move a subvolume into a directory. This happens with 3.11.3, and 3.12 rc4. I'm not sure yet when the regression first appeared.

Example move subvol to subvol, where home is a subvolume that contains files, and f20inprogress is a newly created (empty) subvolume.

[root@f20s btrfs]# mv home f20inprogress
mv: cannot move ‘home’ to ‘f20inprogress/home’: File exists

[ 1505.577231] ------------[ cut here ]------------
[ 1505.577270] WARNING: CPU: 1 PID: 2958 at fs/btrfs/inode.c:8049 btrfs_rename+0x157/0x740 [btrfs]()
[ 1505.577272] Modules linked in: nls_utf8 isofs fuse ebtable_nat nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle iptable_security iptable_raw nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables bnep b43 snd_hda_codec_realtek snd_hda_intel coretemp snd_hda_codec kvm_intel bcma snd_hwdep mac80211 kvm uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core cfg80211 videodev iTCO_wdt joydev applesmc iTCO_vendor_support i2c_i801 media input_polldev microcode hid_appleir btusb bcm5974 bluetooth snd_seq rfkill snd_seq_device lpc_ich snd_pcm mfd_core snd_page_alloc snd_timer
[ 1505.577307]  snd apple_bl shpchp soundcore acpi_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd vfat fat squashfs btrfs libcrc32c xor zlib_deflate raid6_pq nouveau firewire_ohci mxm_wmi firewire_core ssb wmi i2c_algo_bit ata_generic pata_acpi drm_kms_helper usb_storage crc_itu_t sky2 ttm mmc_core drm i2c_core video sunrpc loop
[ 1505.577333] CPU: 1 PID: 2958 Comm: mv Tainted: G        W    3.11.3-301.fc20.x86_64 #1
[ 1505.577334] Hardware name: Apple Inc. MacBookPro4,1/Mac-F42C89C8, BIOS    MBP41.88Z.00C1.B03.0802271651 02/27/08
[ 1505.577336]  0000000000000009 ffff8800ba46fc78 ffffffff8164807b 0000000000000000
[ 1505.577339]  ffff8800ba46fcb0 ffffffff8106715d ffff8801009b15f8 0000000000000100
[ 1505.577342]  0000000000000000 ffff8801009b09e0 ffff8800a8586a01 ffff8800ba46fcc0
[ 1505.577345] Call Trace:
[ 1505.577351]  [<ffffffff8164807b>] dump_stack+0x45/0x56
[ 1505.577354]  [<ffffffff8106715d>] warn_slowpath_common+0x7d/0xa0
[ 1505.577357]  [<ffffffff8106723a>] warn_slowpath_null+0x1a/0x20
[ 1505.577370]  [<ffffffffa02d16e7>] btrfs_rename+0x157/0x740 [btrfs]
[ 1505.577374]  [<ffffffff811b5b4f>] vfs_rename+0x16f/0x480
[ 1505.577377]  [<ffffffff811b61e1>] SYSC_renameat+0x381/0x420
[ 1505.577380]  [<ffffffff811b7f81>] ? user_path_at+0x11/0x20
[ 1505.577383]  [<ffffffff811ad092>] ? SYSC_newlstat+0x22/0x40
[ 1505.577386]  [<ffffffff811b87de>] SyS_renameat+0xe/0x10
[ 1505.577388]  [<ffffffff811b87fb>] SyS_rename+0x1b/0x20
[ 1505.577392]  [<ffffffff81657259>] system_call_fastpath+0x16/0x1b
[ 1505.577394] ---[ end trace 84e316366ba447b6 ]---



Chris Murphy