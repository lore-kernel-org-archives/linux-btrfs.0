Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50008 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbbEET4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 15:56:11 -0400
Date: Tue, 5 May 2015 12:56:10 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Manana <fdmanana@gmail.com>
Subject: Re: 3.19.6: __btrfs_free_extent:5987: errno=-2 No such entry
Message-ID: <20150505195610.GE23216@merlins.org>
References: <20150502141102.GB1809@merlins.org> <20150501210013.GH13624@merlins.org> <20150429232130.GA23814@merlins.org> <20150502163010.GK13624@merlins.org> <20150505063215.GA28387@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150505063215.GA28387@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 04, 2015 at 11:32:15PM -0700, Marc MERLIN wrote:
> Ok, so I ran btrfs check --repair on it with btrfs 4.0 and got this:
> http://marc.merlins.org/tmp/repair.txt
> 
> Many lines of 
> root 62006 inode 454222 errors 400, nbytes wrong
> root 62006 inode 454223 errors 400, nbytes wrong
> root 62006 inode 9680874 errors 400, nbytes wrong
> and
> reset isize for dir 28434 root 394
> reset isize for dir 37282 root 394
> reset isize for dir 37712 root 394
> 
> Not sure when/how I picked those up, but I guess repair was able to handle
> them.
> 
> But what do they mean? Does size wrong mean that I have files that got reset
> with less data that they had before?

Mmmh, it looks like repair may have made my FS worse, or uncovered more
problems that just caused my FS to go read only after 4H of use :-/

Can someone tell me if this state is fixable or if I need to destroy the FS
and start over?
[17159.103764] ------------[ cut here ]------------
[17159.103775] WARNING: CPU: 6 PID: 506 at fs/btrfs/extent-tree.c:5981 __btrfs_free_extent+0x3a3/0x81a()
[17159.103777] Modules linked in: cx231xx_alsa cx25840 cx231xx videobuf_vmalloc tveeprom cx2341x rc_core videobuf_core i2c_mux nls_utf8 nls_cp437 vfat fat uas usb_storage rpcsec_gss_krb5 nfsv4 ctr ccm ipt_REJECT nf_reject_ipv4 xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle ip6table_filter ip6_tables ebtable_nat ebtables rfcomm bnep pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables bridge stp llc autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ecryptfs configs ppdev parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t uvcvideo videobuf2_vmalloc videobuf2_memops btusb videobuf2_core v4l2_common bluetooth videodev media joydev arc4 intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek kvm_intel snd_hda_codec_generic kvm iwlmvm snd_hda_codec_hdmi mac80211 crct10dif_pclmul crc32_pclmul iTCO_wdt rtsx_pci_ms snd_hda_intel ghash_clmulni_intel iTCO_vendor_support snd_hda_controller memstick rtsx_pci_sdmmc iwlwifi snd_hda_codec snd_pcm_oss snd_hwdep psmouse microcode serio_raw snd_mixer_oss pcspkr i2c_i801 thinkpad_acpi snd_pcm cfg80211 sg tpm_tis rtsx_pci lpc_ich nvram rfkill snd_seq_midi ac tpm wmi battery snd_seq_midi_event ehci_pci xhci_pci ehci_hcd xhci_hcd snd_rawmidi snd_seq snd_seq_device usbcore snd_timer usb_common snd ie31200_edac soundcore edac_core shpchp intel_smartconnect evdev processor sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts crc32c_intel aesni_intel aes_x86_64 e1000e glue_helper lrw gf128mul ptp ablk_helper cryptd pps_core thermal
[17159.103982] CPU: 6 PID: 506 Comm: btrfs-cleaner Tainted: G        W  OE  3.19.6-amd64-i915-volpreempt-s20150421rc3 #2
[17159.103984] Hardware name: LENOVO 20BECT0/20BECT0, BIOS GMET28WW (1.08 ) 09/18/2013
[17159.103986]  0000000000000009 ffff88040669fac8 ffffffff81677ec0 00000000000072d2
[17159.103991]  0000000000000000 ffff88040669fb08 ffffffff810556a7 a800000049e19ce0
[17159.103998]  ffffffff8122ca7d ffff8803d20b6020 00000000fffffffe 0000000000000000
[17159.104003] Call Trace:
[17159.104009]  [<ffffffff81677ec0>] dump_stack+0x45/0x57
[17159.104013]  [<ffffffff810556a7>] warn_slowpath_common+0xa1/0xbb
[17159.104016]  [<ffffffff8122ca7d>] ? __btrfs_free_extent+0x3a3/0x81a
[17159.104018]  [<ffffffff81055764>] warn_slowpath_null+0x1a/0x1c
[17159.104021]  [<ffffffff8122ca7d>] __btrfs_free_extent+0x3a3/0x81a
[17159.104024]  [<ffffffff812323ce>] __btrfs_run_delayed_refs+0xaee/0xc22
[17159.104027]  [<ffffffff81230858>] ? btrfs_free_tree_block+0x18c/0x1c7
[17159.104030]  [<ffffffff81234190>] btrfs_run_delayed_refs+0x6d/0x19e
[17159.104032]  [<ffffffff81230c13>] ? walk_up_tree+0x72/0xf9
[17159.104036]  [<ffffffff81241af6>] btrfs_should_end_transaction+0x52/0x5b
[17159.104038]  [<ffffffff81232d1f>] btrfs_drop_snapshot+0x36f/0x696
[17159.104042]  [<ffffffff81287651>] ? btrfs_kill_all_delayed_nodes+0x43/0xbd
[17159.104046]  [<ffffffff8167ab1a>] ? __schedule+0x472/0x505
[17159.104049]  [<ffffffff81241f3c>] btrfs_clean_one_deleted_snapshot+0xce/0xdb
[17159.104052]  [<ffffffff8123b7c1>] cleaner_kthread+0x112/0x146
[17159.104056]  [<ffffffff8123b6af>] ? atomic_add_unless.constprop.53+0x24/0x24
[17159.104059]  [<ffffffff8106d296>] kthread+0xae/0xb6
[17159.104061]  [<ffffffff8106d1e8>] ? __kthread_parkme+0x61/0x61
[17159.104064]  [<ffffffff8167d818>] ret_from_fork+0x58/0x90
[17159.104068]  [<ffffffff8106d1e8>] ? __kthread_parkme+0x61/0x61
[17159.104070] ---[ end trace d372a2208cf37cec ]---
[17159.104073] BTRFS info (device dm-0): leaf 49860935680 total ptrs 141 free space 5497
[17159.104075]  item 0 key (317305278464 168 77824) itemoff 16246 itemsize 37
[17159.104077]          extent refs 1 gen 1899084 flags 1
[17159.104078]          shared data backref parent 230381830144 count 1
[17159.104080]  item 1 key (317305356288 168 69632) itemoff 16209 itemsize 37
[17159.104082]          extent refs 1 gen 1899084 flags 1
[17159.104083]          shared data backref parent 230381830144 count 1
[17159.104086]  item 2 key (317305757696 168 4096) itemoff 16130 itemsize 79
[17159.104087]          extent refs 3 gen 1899084 flags 1
[17159.104089]          extent data backref root 392 objectid 11041142 offset 421888 count 1
[17159.104090]          shared data backref parent 491878858752 count 1
[17159.104092]          shared data backref parent 327213531136 count 1
(...)
[17159.104836]  item 139 key (317355589632 168 16384) itemoff 9059 itemsize 37
[17159.104837]          extent refs 1 gen 681 flags 1
[17159.104838]          shared data backref parent 230518226944 count 1
[17159.104840]  item 140 key (317356175360 168 49152) itemoff 9022 itemsize 37
[17159.104841]          extent refs 1 gen 1639904 flags 1
[17159.104842]          shared data backref parent 919346233344 count 1
[17159.104844] BTRFS error (device dm-0): unable to find ref byte nr 317317357568 parent 0 root 70041  owner 24331 offset 0
[17159.104846] ------------[ cut here ]------------
[17159.104850] WARNING: CPU: 6 PID: 506 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0x52/0x113()
[17159.104851] BTRFS: Transaction aborted (error -2)
[17159.104852] Modules linked in: cx231xx_alsa cx25840 cx231xx videobuf_vmalloc tveeprom cx2341x rc_core videobuf_core i2c_mux nls_utf8 nls_cp437 vfat fat uas usb_storage rpcsec_gss_krb5 nfsv4 ctr ccm ipt_REJECT nf_reject_ipv4 xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle ip6table_filter ip6_tables ebtable_nat ebtables rfcomm bnep pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables bridge stp llc autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ecryptfs configs ppdev parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t uvcvideo videobuf2_vmalloc videobuf2_memops btusb videobuf2_core v4l2_common bluetooth videodev media joydev arc4 intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek kvm_intel snd_hda_codec_generic kvm iwlmvm snd_hda_codec_hdmi mac80211 crct10dif_pclmul crc32_pclmul iTCO_wdt rtsx_pci_ms snd_hda_intel ghash_clmulni_intel iTCO_vendor_support snd_hda_controller memstick rtsx_pci_sdmmc iwlwifi snd_hda_codec snd_pcm_oss snd_hwdep psmouse microcode serio_raw snd_mixer_oss pcspkr i2c_i801 thinkpad_acpi snd_pcm cfg80211 sg tpm_tis rtsx_pci lpc_ich nvram rfkill snd_seq_midi ac tpm wmi battery snd_seq_midi_event ehci_pci xhci_pci ehci_hcd xhci_hcd snd_rawmidi snd_seq snd_seq_device usbcore snd_timer usb_common snd ie31200_edac soundcore edac_core shpchp intel_smartconnect evdev processor sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts crc32c_intel aesni_intel aes_x86_64 e1000e glue_helper lrw gf128mul ptp ablk_helper cryptd pps_core thermal
[17159.105040] CPU: 6 PID: 506 Comm: btrfs-cleaner Tainted: G        W  OE  3.19.6-amd64-i915-volpreempt-s20150421rc3 #2
[17159.105042] Hardware name: LENOVO 20BECT0/20BECT0, BIOS GMET28WW (1.08 ) 09/18/2013
[17159.105043]  0000000000000009 ffff88040669fa38 ffffffff81677ec0 00000000000080e2
[17159.105050]  ffff88040669fa88 ffff88040669fa78 ffffffff810556a7 ffff88040669fa98
[17159.105055]  ffffffff8121e95d 00000000fffffffe ffff88040748b800 ffff880103c7b598
[17159.105059] Call Trace:
[17159.105062]  [<ffffffff81677ec0>] dump_stack+0x45/0x57
[17159.105065]  [<ffffffff810556a7>] warn_slowpath_common+0xa1/0xbb
[17159.105068]  [<ffffffff8121e95d>] ? __btrfs_abort_transaction+0x52/0x113
[17159.105070]  [<ffffffff81055707>] warn_slowpath_fmt+0x46/0x48
[17159.105073]  [<ffffffff8121e95d>] __btrfs_abort_transaction+0x52/0x113
[17159.105075]  [<ffffffff8122ced6>] __btrfs_free_extent+0x7fc/0x81a
[17159.105078]  [<ffffffff812323ce>] __btrfs_run_delayed_refs+0xaee/0xc22
[17159.105081]  [<ffffffff81230858>] ? btrfs_free_tree_block+0x18c/0x1c7
[17159.105083]  [<ffffffff81234190>] btrfs_run_delayed_refs+0x6d/0x19e
[17159.105086]  [<ffffffff81230c13>] ? walk_up_tree+0x72/0xf9
[17159.105089]  [<ffffffff81241af6>] btrfs_should_end_transaction+0x52/0x5b
[17159.105091]  [<ffffffff81232d1f>] btrfs_drop_snapshot+0x36f/0x696
[17159.105095]  [<ffffffff81287651>] ? btrfs_kill_all_delayed_nodes+0x43/0xbd
[17159.105098]  [<ffffffff8167ab1a>] ? __schedule+0x472/0x505
[17159.105100]  [<ffffffff81241f3c>] btrfs_clean_one_deleted_snapshot+0xce/0xdb
[17159.105103]  [<ffffffff8123b7c1>] cleaner_kthread+0x112/0x146
[17159.105105]  [<ffffffff8123b6af>] ? atomic_add_unless.constprop.53+0x24/0x24
[17159.105107]  [<ffffffff8106d296>] kthread+0xae/0xb6
[17159.105110]  [<ffffffff8106d1e8>] ? __kthread_parkme+0x61/0x61
[17159.105113]  [<ffffffff8167d818>] ret_from_fork+0x58/0x90
[17159.105115]  [<ffffffff8106d1e8>] ? __kthread_parkme+0x61/0x61
[17159.105116] ---[ end trace d372a2208cf37ced ]---
[17159.105118] BTRFS: error (device dm-0) in __btrfs_free_extent:5987: errno=-2 No such entry
[17159.105120] BTRFS info (device dm-0): forced readonly
[17159.105123] BTRFS: error (device dm-0) in btrfs_run_delayed_refs:2792: errno=-2 No such entry

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
