Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:53664 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbcC3GWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 02:22:04 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1al9Vx-0006sW-9s
	for linux-btrfs@vger.kernel.org; Wed, 30 Mar 2016 08:22:01 +0200
Date: Wed, 30 Mar 2016 08:22:01 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: "bad metadata" not fixed by btrfs repair
Message-ID: <20160330062201.GF9342@torres.zugschlus.de>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <20160328184237.GA10135@torres.zugschlus.de>
 <21f3d8f6-3447-109f-d21e-0e7a696c94e2@mokrynskyi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <21f3d8f6-3447-109f-d21e-0e7a696c94e2@mokrynskyi.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 28, 2016 at 09:51:43PM +0300, Nazar Mokrynskyi wrote:
> However, despite those messages everything seems to work fine.

In my case, trying to balance the filesystem results in a the balance
not finishing in hours, I/O performance going way down during the
balance, and a plethora of kernel traces showing up in the syslog:

Mar 22 22:37:08 fan kernel: [  429.488415] ------------[ cut here ]------------
Mar 22 22:37:08 fan kernel: [  429.488455] WARNING: CPU: 5 PID: 3899 at fs/btrfs/extent-tree.c:7897 btrfs_alloc_tree_block+0xeb/0x3d6 [btrfs]()
Mar 22 22:37:08 fan kernel: [  429.488456] BTRFS: block rsv returned -28
Mar 22 22:37:08 fan kernel: [  429.488458] Modules linked in: dummy ebtable_filter ebtables ip6table_filter ip6_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative kvm_amd kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic amd64_edac_mod input_leds edac_mce_amd pcspkr snd_hda_codec_hdmi snd_cmipci k10temp edac_core snd_mpu401_uart snd_opl3_lib snd_rawmidi snd_hda_intel snd_seq_device snd_hda_codec i2c_piix4 snd_hda_core acpi_cpufreq asus_atk0110 snd_hwdep tpm_tis evdev sg snd_pcm_oss tpm snd_mixer_oss snd_pcm snd_timer snd soundcore shpchp processor iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc hwmon_vid autofs4 crc32c_generic btrfs xor raid6_pq ext4 crc16 mbcache jbd2 hmac sha256_ssse3 sha256_generic drbg ansi_cprng xts gf128mul algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid usb_storage sr_mod sd_mod cdrom ohci_pci r8169 mii xhci_pci amdkfd xhci_hcd ohci_hcd ehci_pci ehci_hcd radeon ahci i2c_algo_bit libahci ttm libata drm_kms_helper sym53c8xx scsi_transport_spi drm usbcore scsi_mod usb_common i2c_core button
Mar 22 22:37:08 fan kernel: [  429.488507] CPU: 5 PID: 3899 Comm: btrfs Tainted: G        W       4.4.5-zgws1 #2
Mar 22 22:37:08 fan kernel: [  429.488508] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Mar 22 22:37:08 fan kernel: [  429.488510]  000000000000005b ffffffff811dd418 ffff8805f57fb890 0000000000000009
Mar 22 22:37:08 fan kernel: [  429.488512]  ffffffff81051e21 ffffffffa04cb29f ffff8805bbf46f00 ffff8805f57fb8e8
Mar 22 22:37:08 fan kernel: [  429.488514]  ffff8800b2390000 ffff88053c63d020 ffffffff81051e79 ffffffffa053e65b
Mar 22 22:37:08 fan kernel: [  429.488516] Call Trace:
Mar 22 22:37:08 fan kernel: [  429.488523]  [<ffffffff811dd418>] ? dump_stack+0x5a/0x6f
Mar 22 22:37:08 fan kernel: [  429.488526]  [<ffffffff81051e21>] ? warn_slowpath_common+0x8e/0xa3
Mar 22 22:37:08 fan kernel: [  429.488537]  [<ffffffffa04cb29f>] ? btrfs_alloc_tree_block+0xeb/0x3d6 [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488539]  [<ffffffff81051e79>] ? warn_slowpath_fmt+0x43/0x4b
Mar 22 22:37:08 fan kernel: [  429.488551]  [<ffffffffa04f50e7>] ? set_extent_buffer_dirty+0x76/0x82 [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488562]  [<ffffffffa04cb29f>] ? btrfs_alloc_tree_block+0xeb/0x3d6 [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488572]  [<ffffffffa04ba93c>] ? generic_bin_search.constprop.37+0xf0/0x128 [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488581]  [<ffffffffa04b967a>] ? __btrfs_cow_block+0xdf/0x443 [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488591]  [<ffffffffa04b9b0a>] ? btrfs_cow_block+0xd9/0x143 [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488602]  [<ffffffffa0517654>] ? do_relocation+0x255/0x3ad [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488612]  [<ffffffffa04bf02b>] ? block_rsv_add_bytes+0x43/0x4a [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488622]  [<ffffffffa04ca230>] ? btrfs_block_rsv_refill+0x6e/0x7f [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488634]  [<ffffffffa05187c7>] ? relocate_tree_blocks+0x2ee/0x42c [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488645]  [<ffffffffa0519e4d>] ? relocate_block_group+0x27a/0x4ab [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488656]  [<ffffffffa051a1b0>] ? btrfs_relocate_block_group+0x132/0x25a [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488668]  [<ffffffffa04f9180>] ? btrfs_relocate_chunk.isra.35+0x3c/0xad [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488680]  [<ffffffffa04fa96c>] ? btrfs_balance+0xd23/0xd8f [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488691]  [<ffffffffa05037a6>] ? btrfs_ioctl_balance+0x233/0x2ae [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488703]  [<ffffffffa0506152>] ? btrfs_ioctl+0x1234/0x2699 [btrfs]
Mar 22 22:37:08 fan kernel: [  429.488706]  [<ffffffff811329bc>] ? mem_cgroup_charge_statistics.isra.30+0x22/0x4f
Mar 22 22:37:08 fan kernel: [  429.488708]  [<ffffffff811363ea>] ? mem_cgroup_commit_charge+0x8a/0xaa
Mar 22 22:37:08 fan kernel: [  429.488711]  [<ffffffff810f56bb>] ? __lru_cache_add+0x19/0x38
Mar 22 22:37:08 fan kernel: [  429.488713]  [<ffffffff8110a1fb>] ? set_pte_at+0x5/0x8
Mar 22 22:37:08 fan kernel: [  429.488715]  [<ffffffff8110daf2>] ? handle_mm_fault+0x488/0xea5
Mar 22 22:37:08 fan kernel: [  429.488717]  [<ffffffff81149d98>] ? do_vfs_ioctl+0x3ad/0x424
Mar 22 22:37:08 fan kernel: [  429.488719]  [<ffffffff81149d98>] ? do_vfs_ioctl+0x3ad/0x424
Mar 22 22:37:08 fan kernel: [  429.488721]  [<ffffffff81149e5c>] ? SyS_ioctl+0x4d/0x6f
Mar 22 22:37:08 fan kernel: [  429.488724]  [<ffffffff8140dcae>] ? entry_SYSCALL_64_fastpath+0x12/0x6d
Mar 22 22:37:08 fan kernel: [  429.488725] ---[ end trace 63ee8891bd9de879 ]---

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
