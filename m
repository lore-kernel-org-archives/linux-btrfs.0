Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36489 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756028Ab3JHXfe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 19:35:34 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:54213 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VTgoN-002sgj-BG
	for linux-btrfs@vger.kernel.org; Tue, 08 Oct 2013 17:35:31 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: regression, can't move subvols into subvols, fs/btrfs/inode.c:8049 btrfs_rename
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <21B1A985-7936-41DF-ADDC-6583EC4EEB98@colorremedies.com>
Date: Tue, 8 Oct 2013 17:35:30 -0600
Message-Id: <77CAE6C6-C060-4245-BFA4-AAB577EB8B51@colorremedies.com>
References: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com> <21B1A985-7936-41DF-ADDC-6583EC4EEB98@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 8, 2013, at 4:29 PM, Chris Murphy <lists@colorremedies.com> wrote:

> So I think I need to go back to an older btrfs-progs. Or I need a new brain.

OK I'm losing it. New file system created with:

btrfs-progs-0.20.rc1.20130501git7854c8b-4.fc20.x86_64
3.11.3-301.fc20.x86_64

I still can't move a subvolume into a subvolume. Using identical syntax with a directory as target works OK. 

[root@f20s mnt]# mv subvol1 subvol2
mv: cannot move ‘subvol1’ to ‘subvol2/subvol1’: File exists

Same kernel message:

[ 2108.277456] ------------[ cut here ]------------
[ 2108.277532] WARNING: CPU: 0 PID: 2127 at fs/btrfs/inode.c:8049 btrfs_rename+0x157/0x740 [btrfs]()
[ 2108.277537] Modules linked in: nls_utf8 hfsplus fuse ebtable_nat nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle iptable_security iptable_raw nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables bnep coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support joydev applesmc input_polldev uvcvideo b43 videobuf2_vmalloc bcma mac80211 videobuf2_memops videobuf2_core microcode videodev snd_hda_codec_realtek media snd_hda_intel snd_hda_codec i2c_i801 snd_hwdep lpc_ich mfd_core snd_seq cfg80211 snd_seq_device bcm5974 snd_pcm btusb hid_appleir snd_page_alloc snd_timer snd soundcore
[ 2108.277641]  bluetooth rfkill shpchp apple_bl acpi_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd vfat fat squashfs btrfs libcrc32c xor zlib_deflate raid6_pq nouveau mxm_wmi wmi i2c_algo_bit firewire_ohci ata_generic pata_acpi firewire_core ssb crc_itu_t sky2 usb_storage drm_kms_helper mmc_core ttm drm i2c_core video sunrpc loop
[ 2108.277712] CPU: 0 PID: 2127 Comm: mv Tainted: G        W    3.11.3-301.fc20.x86_64 #1
[ 2108.277717] Hardware name: Apple Inc. MacBookPro4,1/Mac-F42C89C8, BIOS    MBP41.88Z.00C1.B03.0802271651 02/27/08
[ 2108.277721]  0000000000000009 ffff88013463bc78 ffffffff8164807b 0000000000000000
[ 2108.277731]  ffff88013463bcb0 ffffffff8106715d ffff88004e0c05d8 0000000000000100
[ 2108.277739]  0000000000000000 ffff88004e0c15f8 ffff8800b4ce9001 ffff88013463bcc0
[ 2108.277748] Call Trace:
[ 2108.277761]  [<ffffffff8164807b>] dump_stack+0x45/0x56
[ 2108.277771]  [<ffffffff8106715d>] warn_slowpath_common+0x7d/0xa0
[ 2108.277779]  [<ffffffff8106723a>] warn_slowpath_null+0x1a/0x20
[ 2108.277821]  [<ffffffffa02c36e7>] btrfs_rename+0x157/0x740 [btrfs]
[ 2108.277832]  [<ffffffff811b5b4f>] vfs_rename+0x16f/0x480
[ 2108.277840]  [<ffffffff811b61e1>] SYSC_renameat+0x381/0x420
[ 2108.277850]  [<ffffffff811b7f81>] ? user_path_at+0x11/0x20
[ 2108.277858]  [<ffffffff811ad092>] ? SYSC_newlstat+0x22/0x40
[ 2108.277867]  [<ffffffff811b87de>] SyS_renameat+0xe/0x10
[ 2108.277874]  [<ffffffff811b87fb>] SyS_rename+0x1b/0x20
[ 2108.277884]  [<ffffffff81657259>] system_call_fastpath+0x16/0x1b
[ 2108.277889] ---[ end trace c377166ca4c37375 ]