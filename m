Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35066 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751463Ab3JAGWl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 02:22:41 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50918 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VQtLy-001twE-Jj
	for linux-btrfs@vger.kernel.org; Tue, 01 Oct 2013 00:22:38 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs debug warning unlinked orphans, 3.12.0-0.rc3
Message-Id: <23E1ABD1-38E5-4257-A3E2-4A4E57EFE446@colorremedies.com>
Date: Tue, 1 Oct 2013 00:22:37 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have no idea if this is a problem or not so I'm reporting it in case it is. Non-critical throway test system. Warning occurs with kernel 3.12.0-0.rc3.git0.1.fc21.x86_64

 

1.
Fedora 20 alpha installation, with boot root home on subvolumes. Autodefrag is not used by the installer.
The file system is created with and system installed with:
kernel-3.11.0-300.fc20.x86_64
btrfs-progs-0.20.rc1.20130917git194aa4a-1.fc20.x86_64

2.
Before rebooting, changed /etc/fstab to include autodefrag.
Reboot, which includes switch to kernel 3.12.0-0.rc3.git0.1.fc21.x86_64
Mount state is rw,relatime,seclabel,space_cache,autodefrag

dmesg reports

[   15.480651] btrfs: device label fedora_f20s devid 1 transid 47 /dev/sda5
[   15.491746] btrfs: device label fedora_f20s devid 1 transid 47 /dev/sda5
[   15.571815] btrfs: device label fedora_f20s devid 1 transid 47 /dev/sda5


3.
yum update, ~750MB of updates
Warning occurs during the updating. This is the complete segment from dmesg.


[13167.297795] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[13363.105253] btrfs: device label fedora_f20s devid 1 transid 199 /dev/sda5
[13471.491365] BTRFS debug (device sda5): unlinked 5 orphans
[13478.878836] BTRFS debug (device sda5): unlinked 360 orphans
[13591.757985] ------------[ cut here ]------------
[13591.758009] WARNING: CPU: 1 PID: 8600 at fs/btrfs/inode.c:7998 btrfs_rename+0x157/0x730 [btrfs]()
[13591.758043] Modules linked in: binfmt_misc fuse ebtable_nat nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables bnep nls_utf8 hfsplus coretemp kvm_intel kvm b43 snd_hda_codec_realtek snd_hda_intel snd_hda_codec bcma snd_hwdep snd_seq snd_seq_device microcode mac80211 cfg80211 snd_pcm iTCO_wdt iTCO_vendor_support snd_page_alloc uvcvideo snd_timer applesmc ssb snd input_polldev btusb i2c_i801 videobuf2_vmalloc videobuf2_memops videobuf2_core lpc_ich bcm5974 mmc_core soundcore sky2 bluetooth hid_appleir videodev media mfd_core apple_bl rfkill shpchp acpi_cpufreq
[13591.758081]  nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs libcrc32c xor raid6_pq nouveau mxm_wmi wmi i2c_algo_bit drm_kms_helper firewire_ohci ata_generic ttm pata_acpi firewire_core crc_itu_t drm i2c_core video
[13591.758099] CPU: 1 PID: 8600 Comm: mv Tainted: G        W    3.12.0-0.rc3.git0.1.fc21.x86_64 #1
[13591.758101] Hardware name: Apple Inc. MacBookPro4,1/Mac-F42C89C8, BIOS    MBP41.88Z.00C1.B03.0802271651 02/27/08
[13591.758103]  0000000000000009 ffff88000bd19c78 ffffffff8165e6e4 0000000000000000
[13591.758106]  ffff88000bd19cb0 ffffffff810683ed ffff88000c9f3a40 0000000000000100
[13591.758109]  0000000000000000 ffff88000c9c9e08 ffff88000c9f3a01 ffff88000bd19cc0
[13591.758111] Call Trace:
[13591.758119]  [<ffffffff8165e6e4>] dump_stack+0x45/0x56
[13591.758124]  [<ffffffff810683ed>] warn_slowpath_common+0x7d/0xa0
[13591.758126]  [<ffffffff810684ca>] warn_slowpath_null+0x1a/0x20
[13591.758140]  [<ffffffffa0226287>] btrfs_rename+0x157/0x730 [btrfs]
[13591.758144]  [<ffffffff811bacfa>] vfs_rename+0x33a/0x470
[13591.758146]  [<ffffffff811bb1b9>] SYSC_renameat+0x389/0x430
[13591.758149]  [<ffffffff811bd351>] ? user_path_at+0x11/0x20
[13591.758153]  [<ffffffff811b1d62>] ? SYSC_newlstat+0x22/0x40
[13591.758155]  [<ffffffff811bdc0e>] SyS_renameat+0xe/0x10
[13591.758157]  [<ffffffff811bdc2b>] SyS_rename+0x1b/0x20
[13591.758162]  [<ffffffff8166d6a9>] system_call_fastpath+0x16/0x1b
[13591.758163] ---[ end trace 36ebd831d74ca650 ]---
[13616.544255] ------------[ cut here ]------------
[13616.544291] WARNING: CPU: 1 PID: 8608 at fs/btrfs/inode.c:7998 btrfs_rename+0x157/0x730 [btrfs]()
[13616.544293] Modules linked in: binfmt_misc fuse ebtable_nat nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables bnep nls_utf8 hfsplus coretemp kvm_intel kvm b43 snd_hda_codec_realtek snd_hda_intel snd_hda_codec bcma snd_hwdep snd_seq snd_seq_device microcode mac80211 cfg80211 snd_pcm iTCO_wdt iTCO_vendor_support snd_page_alloc uvcvideo snd_timer applesmc ssb snd input_polldev btusb i2c_i801 videobuf2_vmalloc videobuf2_memops videobuf2_core lpc_ich bcm5974 mmc_core soundcore sky2 bluetooth hid_appleir videodev media mfd_core apple_bl rfkill shpchp acpi_cpufreq
[13616.544330]  nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs libcrc32c xor raid6_pq nouveau mxm_wmi wmi i2c_algo_bit drm_kms_helper firewire_ohci ata_generic ttm pata_acpi firewire_core crc_itu_t drm i2c_core video
[13616.544347] CPU: 1 PID: 8608 Comm: mv Tainted: G        W    3.12.0-0.rc3.git0.1.fc21.x86_64 #1
[13616.544349] Hardware name: Apple Inc. MacBookPro4,1/Mac-F42C89C8, BIOS    MBP41.88Z.00C1.B03.0802271651 02/27/08
[13616.544351]  0000000000000009 ffff88000bd63c78 ffffffff8165e6e4 0000000000000000
[13616.544354]  ffff88000bd63cb0 ffffffff810683ed ffff88000c9f3a40 0000000000000100
[13616.544356]  0000000000000000 ffff88000c9c9e08 ffff88000c9f3a01 ffff88000bd63cc0
[13616.544359] Call Trace:
[13616.544366]  [<ffffffff8165e6e4>] dump_stack+0x45/0x56
[13616.544370]  [<ffffffff810683ed>] warn_slowpath_common+0x7d/0xa0
[13616.544373]  [<ffffffff810684ca>] warn_slowpath_null+0x1a/0x20
[13616.544387]  [<ffffffffa0226287>] btrfs_rename+0x157/0x730 [btrfs]
[13616.544390]  [<ffffffff811bacfa>] vfs_rename+0x33a/0x470
[13616.544393]  [<ffffffff811bb1b9>] SYSC_renameat+0x389/0x430
[13616.544396]  [<ffffffff811bd351>] ? user_path_at+0x11/0x20
[13616.544399]  [<ffffffff811b1d62>] ? SYSC_newlstat+0x22/0x40
[13616.544402]  [<ffffffff811bdc0e>] SyS_renameat+0xe/0x10
[13616.544404]  [<ffffffff811bdc2b>] SyS_rename+0x1b/0x20
[13616.544407]  [<ffffffff8166d6a9>] system_call_fastpath+0x16/0x1b
[13616.544409] ---[ end trace 36ebd831d74ca651 ]---
[13720.422719] BTRFS debug (device sda5): unlinked 360 orphans
[13727.309658] BTRFS debug (device sda5): unlinked 5 orphans



Chris Murphy