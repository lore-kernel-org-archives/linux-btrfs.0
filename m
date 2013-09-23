Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35782 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3IWMyY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 08:54:24 -0400
Date: Mon, 23 Sep 2013 14:54:17 +0200
From: Mathieu Chouquet-Stringer <ml2news@free.fr>
To: linux-btrfs@vger.kernel.org
Subject: Failure to remove snapshot with 3.12* and FS switches to read-only
Message-ID: <20130923125417.GA3413@wasting>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

	Hello,

My system is configured to do FS snapshots when I upgrade packages.  I
have a cron job which runs at night to delete these snapshots.  Its goal
is to keep 10 snapshots maximum, one per day if possible.

This works perfectly with 3.11.1 but fails miserably with anything post
3.11.

With a pre 3.12 (3.11.0-10050-g3711d86), this is what happens:

WARNING: CPU: 7 PID: 3991 at fs/btrfs/uuid-tree.c:171 btrfs_uuid_tree_rem+0x1ec/0x210 [btrfs]()
Modules linked in: tcp_lp fuse ebtable_nat xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat bridge iptable_mangle stp llc nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter rfcomm ip6_tables bnep arc4 iwldvm mac80211 vfat fat snd_hda_codec_realtek x86_pkg_temp_thermal coretemp kvm_intel snd_hda_intel snd_hda_codec kvm uvcvideo snd_hwdep snd_seq crc32_pclmul cdc_mbim iwlwifi crc32c_intel videobuf2_vmalloc snd_seq_device videobuf2_memops cdc_ncm ghash_clmulni_intel videobuf2_core snd_pcm usbnet iTCO_wdt iTCO_vendor_support btusb sdhci_pci videodev bluetooth media cfg80211 cdc_acm cdc_wdm mii e1000e sdhci
 snd_page_alloc thinkpad_acpi tpm_tis mmc_core snd_timer tpm microcode snd tpm_bios serio_raw mei_me lpc_ich i2c_i801 ptp rfkill wmi mfd_core mei shpchp pps_core soundcore pcspkr uinput binfmt_misc btrfs libcrc32c xor raid6_pq dm_crypt i915 i2c_algo_bit drm_kms_helper drm firewire_ohci firewire_core crct10dif_pclmul i2c_core crc_itu_t video
CPU: 7 PID: 3991 Comm: btrfs Tainted: G        W    3.11.0-10050-g3711d86 #2
Hardware name: LENOVO 2392CTO/2392CTO, BIOS G4ET94WW (2.54 ) 05/23/2013
 0000000000000009 ffff8802bba0bc58 ffffffff8163cdcf 0000000000000000
 ffff8802bba0bc90 ffffffff81065c9d ffff88007faad3c0 ffff8800c517cb00
 0000000000000000 ffff8802904a2618 ffff88036cd91000 ffff8802bba0bca0
Call Trace:
 [<ffffffff8163cdcf>] dump_stack+0x45/0x56
 [<ffffffff81065c9d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81065d7a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa02021cc>] btrfs_uuid_tree_rem+0x1ec/0x210 [btrfs]
 [<ffffffffa0175016>] ? btrfs_free_path+0x26/0x30 [btrfs]
 [<ffffffffa01cf573>] ? btrfs_insert_orphan_item+0x63/0x80 [btrfs]
 [<ffffffffa01ca023>] btrfs_ioctl_snap_destroy+0x523/0x630 [btrfs]
 [<ffffffffa01cd371>] btrfs_ioctl+0xe61/0x2790 [btrfs]
 [<ffffffff8164711c>] ? __do_page_fault+0x20c/0x540
 [<ffffffff8116a8d7>] ? do_mmap_pgoff+0x357/0x3e0
 [<ffffffff811b4d5d>] do_vfs_ioctl+0x2dd/0x4b0
 [<ffffffff811b4fb1>] SyS_ioctl+0x81/0xa0
 [<ffffffff8164745e>] ? do_page_fault+0xe/0x10
 [<ffffffff8164bad9>] system_call_fastpath+0x16/0x1b
---[ end trace 99eb746a9ff7c964 ]---
------------[ cut here ]------------
WARNING: CPU: 7 PID: 3991 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x11d/0x130 [btrfs]()
btrfs: Transaction aborted (error -22)
Modules linked in: tcp_lp fuse ebtable_nat xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat bridge iptable_mangle stp llc nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter rfcomm ip6_tables bnep arc4 iwldvm mac80211 vfat fat snd_hda_codec_realtek x86_pkg_temp_thermal coretemp kvm_intel snd_hda_intel snd_hda_codec kvm uvcvideo snd_hwdep snd_seq crc32_pclmul cdc_mbim iwlwifi crc32c_intel videobuf2_vmalloc snd_seq_device videobuf2_memops cdc_ncm ghash_clmulni_intel videobuf2_core snd_pcm usbnet iTCO_wdt iTCO_vendor_support btusb sdhci_pci videodev bluetooth media cfg80211 cdc_acm cdc_wdm mii e1000e sdhci
 snd_page_alloc thinkpad_acpi tpm_tis mmc_core snd_timer tpm microcode snd tpm_bios serio_raw mei_me lpc_ich i2c_i801 ptp rfkill wmi mfd_core mei shpchp pps_core soundcore pcspkr uinput binfmt_misc btrfs libcrc32c xor raid6_pq dm_crypt i915 i2c_algo_bit drm_kms_helper drm firewire_ohci firewire_core crct10dif_pclmul i2c_core crc_itu_t video
CPU: 7 PID: 3991 Comm: btrfs Tainted: G        W    3.11.0-10050-g3711d86 #2
Hardware name: LENOVO 2392CTO/2392CTO, BIOS G4ET94WW (2.54 ) 05/23/2013
 0000000000000009 ffff8802bba0bc48 ffffffff8163cdcf ffff8802bba0bc90
 ffff8802bba0bc80 ffffffff81065c9d 00000000ffffffea ffff880401bc2000
 ffff88003fe7d280 ffffffffa020b830 00000000000008cc ffff8802bba0bce0
Call Trace:
 [<ffffffff8163cdcf>] dump_stack+0x45/0x56
 [<ffffffff81065c9d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81065d0c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffffa0171b3d>] __btrfs_abort_transaction+0x11d/0x130 [btrfs]
 [<ffffffffa01ca10a>] btrfs_ioctl_snap_destroy+0x60a/0x630 [btrfs]
 [<ffffffffa01cd371>] btrfs_ioctl+0xe61/0x2790 [btrfs]
 [<ffffffff8164711c>] ? __do_page_fault+0x20c/0x540
 [<ffffffff8116a8d7>] ? do_mmap_pgoff+0x357/0x3e0
 [<ffffffff811b4d5d>] do_vfs_ioctl+0x2dd/0x4b0
 [<ffffffff811b4fb1>] SyS_ioctl+0x81/0xa0
 [<ffffffff8164745e>] ? do_page_fault+0xe/0x10
 [<ffffffff8164bad9>] system_call_fastpath+0x16/0x1b
---[ end trace 99eb746a9ff7c965 ]---
BTRFS error (device dm-1) in btrfs_ioctl_snap_destroy:2252: errno=-22 unknown
BTRFS info (device dm-1): forced readonly

And with 3.12-rc1 (3.12.0-rc1-00273-g2457aaf), I get the same thing:

WARNING: CPU: 5 PID: 8364 at fs/btrfs/uuid-tree.c:171 btrfs_uuid_tree_rem+0x1ec/0x210 [btrfs]()
Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd sunrpc fscache fuse ebtable_nat xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 bridge stp llc iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables rfcomm ip6table_filter ip6_tables bnep arc4 iwldvm mac80211 vfat snd_hda_codec_realtek fat snd_hda_intel snd_hda_codec uvcvideo snd_hwdep snd_seq videobuf2_vmalloc iwlwifi snd_seq_device videobuf2_memops snd_pcm iTCO_wdt videobuf2_core iTCO_vendor_support x86_pkg_temp_thermal cdc_mbim coretemp videodev kvm_intel kvm cfg80211 btusb cdc_ncm e1000e snd_page_alloc sdhci_pci media bluetooth
 snd_timer sdhci thinkpad_acpi cdc_wdm cdc_acm usbnet snd mmc_core mii rfkill mei_me ptp microcode tpm_tis i2c_i801 serio_raw wmi pcspkr pps_core soundcore tpm lpc_ich mei tpm_bios shpchp mfd_core uinput binfmt_misc btrfs libcrc32c xor raid6_pq dm_crypt i915 i2c_algo_bit drm_kms_helper drm crct10dif_pclmul crc32_pclmul crc32c_intel firewire_ohci firewire_core ghash_clmulni_intel crc_itu_t i2c_core video
CPU: 5 PID: 8364 Comm: btrfs Tainted: G        W    3.12.0-rc1-00273-g2457aaf #1
Hardware name: LENOVO 2392CTO/2392CTO, BIOS G4ET94WW (2.54 ) 05/23/2013
 0000000000000009 ffff88028992bc58 ffffffff8163d04f 0000000000000000
 ffff88028992bc90 ffffffff81065c9d ffff8800c0cf6000 ffff8800ad07a800
 0000000000000000 ffff8803a5bed678 ffff8802898e5000 ffff88028992bca0
Call Trace:
 [<ffffffff8163d04f>] dump_stack+0x45/0x56
 [<ffffffff81065c9d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81065d7a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa02331cc>] btrfs_uuid_tree_rem+0x1ec/0x210 [btrfs]
 [<ffffffffa01a6016>] ? btrfs_free_path+0x26/0x30 [btrfs]
 [<ffffffffa0200573>] ? btrfs_insert_orphan_item+0x63/0x80 [btrfs]
 [<ffffffffa01fb023>] btrfs_ioctl_snap_destroy+0x523/0x630 [btrfs]
 [<ffffffffa01fe371>] btrfs_ioctl+0xe61/0x2790 [btrfs]
 [<ffffffff8164739c>] ? __do_page_fault+0x20c/0x540
 [<ffffffff8116a967>] ? do_mmap_pgoff+0x357/0x3e0
 [<ffffffff811b4d7d>] do_vfs_ioctl+0x2dd/0x4b0
 [<ffffffff811b4fd1>] SyS_ioctl+0x81/0xa0
 [<ffffffff816476de>] ? do_page_fault+0xe/0x10
 [<ffffffff8164bce9>] system_call_fastpath+0x16/0x1b
---[ end trace 9cdf8449ae3d9eb3 ]---
------------[ cut here ]------------
WARNING: CPU: 5 PID: 8364 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x11d/0x130 [btrfs]()
btrfs: Transaction aborted (error -22)
Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd sunrpc fscache fuse ebtable_nat xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 bridge stp llc iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables rfcomm ip6table_filter ip6_tables bnep arc4 iwldvm mac80211 vfat snd_hda_codec_realtek fat snd_hda_intel snd_hda_codec uvcvideo snd_hwdep snd_seq videobuf2_vmalloc iwlwifi snd_seq_device videobuf2_memops snd_pcm iTCO_wdt videobuf2_core iTCO_vendor_support x86_pkg_temp_thermal cdc_mbim coretemp videodev kvm_intel kvm cfg80211 btusb cdc_ncm e1000e snd_page_alloc sdhci_pci media bluetooth
 snd_timer sdhci thinkpad_acpi cdc_wdm cdc_acm usbnet snd mmc_core mii rfkill mei_me ptp microcode tpm_tis i2c_i801 serio_raw wmi pcspkr pps_core soundcore tpm lpc_ich mei tpm_bios shpchp mfd_core uinput binfmt_misc btrfs libcrc32c xor raid6_pq dm_crypt i915 i2c_algo_bit drm_kms_helper drm crct10dif_pclmul crc32_pclmul crc32c_intel firewire_ohci firewire_core ghash_clmulni_intel crc_itu_t i2c_core video
CPU: 5 PID: 8364 Comm: btrfs Tainted: G        W    3.12.0-rc1-00273-g2457aaf #1
Hardware name: LENOVO 2392CTO/2392CTO, BIOS G4ET94WW (2.54 ) 05/23/2013
 0000000000000009 ffff88028992bc48 ffffffff8163d04f ffff88028992bc90
 ffff88028992bc80 ffffffff81065c9d 00000000ffffffea ffff8804010b6000
 ffff880406c363c0 ffffffffa023c830 00000000000008cc ffff88028992bce0
Call Trace:
 [<ffffffff8163d04f>] dump_stack+0x45/0x56
 [<ffffffff81065c9d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81065d0c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffffa01a2b3d>] __btrfs_abort_transaction+0x11d/0x130 [btrfs]
 [<ffffffffa01fb10a>] btrfs_ioctl_snap_destroy+0x60a/0x630 [btrfs]
 [<ffffffffa01fe371>] btrfs_ioctl+0xe61/0x2790 [btrfs]
 [<ffffffff8164739c>] ? __do_page_fault+0x20c/0x540
 [<ffffffff8116a967>] ? do_mmap_pgoff+0x357/0x3e0
 [<ffffffff811b4d7d>] do_vfs_ioctl+0x2dd/0x4b0
 [<ffffffff811b4fd1>] SyS_ioctl+0x81/0xa0
 [<ffffffff816476de>] ? do_page_fault+0xe/0x10
 [<ffffffff8164bce9>] system_call_fastpath+0x16/0x1b
---[ end trace 9cdf8449ae3d9eb4 ]---
BTRFS error (device dm-1) in btrfs_ioctl_snap_destroy:2252: errno=-22 unknown
BTRFS info (device dm-1): forced readonly

I haven't yet tried to reproduce it manually but can certainly do so.
Note my FS is clean as a scrub doesn't return any error.

If I can do anything to help, let me know.

Cheers,

-- 
Mathieu Chouquet-Stringer                               m+btrfs@thi.eu.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
