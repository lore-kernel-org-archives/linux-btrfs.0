Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39388 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965244AbcCONmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 09:42:11 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afpEf-0002KV-6U
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 14:42:09 +0100
Date: Tue, 15 Mar 2016 14:42:09 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160315134209.GP2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
 <CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
 <20160314200546.GG2334@torres.zugschlus.de>
 <20160315132932.GO2334@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160315132932.GO2334@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 02:29:32PM +0100, Marc Haber wrote:
> After umounting and btrfs check the block device, things seem to be
> fine now

But, umounting the btrfs seemed to trigger the following kernel traces:

Mar 15 14:21:30 fan kernel: [92308.377104] ------------[ cut here ]------------
Mar 15 14:21:30 fan kernel: [92308.377135] WARNING: CPU: 5 PID: 28243 at fs/btrfs/extent-tree.c:5380 bt
rfs_free_block_groups+0x1bc/0x36f [btrfs]()
Mar 15 14:21:30 fan kernel: [92308.377137] Modules linked in: vhost_net vhost macvtap macvlan tun iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp dummy ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative bridge stp llc snd_cmipci snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi kvm_amd snd_mpu401_uart snd_opl3_lib snd_rawmidi kvm snd_hda_intel snd_seq_device snd_hda_codec snd_hda_core snd_hwdep amd64_edac_mod snd_pcm_oss edac_mce_amd irqbypass input_leds snd_mixer_oss pcspkr k10temp edac_core snd_pcm snd_timer snd i2c_piix4 asus_atk0110 soundcore acpi_cpufreq tpm_tis tpm sg processor evdev shpchp hwmon_vid autofs4 crc32c_generic btrfs xor raid6_pq ext4 crc16 mbcache jbd2 hmac sha256_ssse3 sha256_generic drbg ansi_cprng xts gf128mul algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid usb_storage sr_mod sd_mod cdrom ohci_pci r8169 mii amdkfd radeon i2c_algo_bit ahci ttm sym53c8xx libahci xhci_pci scsi_transport_spi drm_kms_helper ohci_hcd ehci_pci xhci_hcd libata ehci_hcd drm usbcore scsi_mod usb_common i2c_core button
Mar 15 14:21:30 fan kernel: [92308.377203] CPU: 5 PID: 28243 Comm: umount Not tainted 4.4.5-zgws1 #2
Mar 15 14:21:30 fan kernel: [92308.377205] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Mar 15 14:21:30 fan kernel: [92308.377207]  000000000000005b ffffffff811dd418 0000000000000000 0000000000000009
Mar 15 14:21:30 fan kernel: [92308.377210]  ffffffff81051e21 ffffffffa047a147 ffff880600a28000 0000000000000000
Mar 15 14:21:30 fan kernel: [92308.377212]  ffff880600a28080 ffff8805af7eea00 ffffffffa047a147 ffff880600a28000
Mar 15 14:21:30 fan kernel: [92308.377215] Call Trace:
Mar 15 14:21:30 fan kernel: [92308.377221]  [<ffffffff811dd418>] ? dump_stack+0x5a/0x6f
Mar 15 14:21:30 fan kernel: [92308.377224]  [<ffffffff81051e21>] ? warn_slowpath_common+0x8e/0xa3
Mar 15 14:21:30 fan kernel: [92308.377239]  [<ffffffffa047a147>] ? btrfs_free_block_groups+0x1bc/0x36f[btrfs]
Mar 15 14:21:30 fan kernel: [92308.377252]  [<ffffffffa047a147>] ? btrfs_free_block_groups+0x1bc/0x36f[btrfs]
Mar 15 14:21:30 fan kernel: [92308.377267]  [<ffffffffa0487c72>] ? close_ctree+0x1e6/0x2f2 [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377271]  [<ffffffff8113dfd9>] ? generic_shutdown_super+0x64/0xdf
Mar 15 14:21:30 fan kernel: [92308.377273]  [<ffffffff8113e181>] ? kill_anon_super+0x9/0xe
Mar 15 14:21:30 fan kernel: [92308.377285]  [<ffffffffa04660db>] ? btrfs_kill_super+0xd/0x16 [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377288]  [<ffffffff8113e286>] ? deactivate_locked_super+0x2f/0x56
Mar 15 14:21:30 fan kernel: [92308.377291]  [<ffffffff81152aff>] ? cleanup_mnt+0x4f/0x6b
Mar 15 14:21:30 fan kernel: [92308.377293]  [<ffffffff81066ab7>] ? task_work_run+0x5d/0x71
Mar 15 14:21:30 fan kernel: [92308.377296]  [<ffffffff810036dc>] ? prepare_exit_to_usermode+0x70/0x99
Mar 15 14:21:30 fan kernel: [92308.377300]  [<ffffffff8140de08>] ? int_ret_from_sys_call+0x25/0x8f
Mar 15 14:21:30 fan kernel: [92308.377302] ---[ end trace 18c6bb90b0c6c689 ]---

Mar 15 14:21:30 fan kernel: [92308.377303] ------------[ cut here ]------------
Mar 15 14:21:30 fan kernel: [92308.377318] WARNING: CPU: 5 PID: 28243 at fs/btrfs/extent-tree.c:5381 btrfs_free_block_groups+0x1d7/0x36f [btrfs]()
Mar 15 14:21:30 fan kernel: [92308.377319] Modules linked in: vhost_net vhost macvtap macvlan tun iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp dummy ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative bridge stp llc snd_cmipci snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi kvm_amd snd_mpu401_uart snd_opl3_lib snd_rawmidi kvm snd_hda_intel snd_seq_device snd_hda_codec snd_hda_core snd_hwdep amd64_edac_mod snd_pcm_oss edac_mce_amd irqbypass input_leds snd_mixer_oss pcspkr k10temp edac_core snd_pcm snd_timer snd i2c_piix4 asus_atk0110 soundcore acpi_cpufreq tpm_tis tpm sg processor evdev shpchp hwmon_vid autofs4 crc32c_generic btrfs xor raid6_pq ext4 crc16 mbcache jbd2 hmac sha256_ssse3 sha256_generic drbg ansi_cprng xts gf128mul algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid usb_storage sr_mod sd_mod cdrom ohci_pci r8169 mii amdkfd radeon i2c_algo_bit ahci ttm sym53c8xx libahci xhci_pci scsi_transport_spi drm_kms_helper ohci_hcd ehci_pci xhci_hcd libata ehci_hcd drm usbcore scsi_mod usb_common i2c_core button
Mar 15 14:21:30 fan kernel: [92308.377362] CPU: 5 PID: 28243 Comm: umount Tainted: G        W       4.4.5-zgws1 #2
Mar 15 14:21:30 fan kernel: [92308.377364] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Mar 15 14:21:30 fan kernel: [92308.377365]  000000000000005b ffffffff811dd418 0000000000000000 0000000000000009
Mar 15 14:21:30 fan kernel: [92308.377367]  ffffffff81051e21 ffffffffa047a162 ffff880600a28000 0000000000000000
Mar 15 14:21:30 fan kernel: [92308.377369]  ffff880600a28080 ffff8805af7eea00 ffffffffa047a162 ffff880600a28000
Mar 15 14:21:30 fan kernel: [92308.377372] Call Trace:
Mar 15 14:21:30 fan kernel: [92308.377374]  [<ffffffff811dd418>] ? dump_stack+0x5a/0x6f
Mar 15 14:21:30 fan kernel: [92308.377377]  [<ffffffff81051e21>] ? warn_slowpath_common+0x8e/0xa3
Mar 15 14:21:30 fan kernel: [92308.377390]  [<ffffffffa047a162>] ? btrfs_free_block_groups+0x1d7/0x36f [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377404]  [<ffffffffa047a162>] ? btrfs_free_block_groups+0x1d7/0x36f [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377419]  [<ffffffffa0487c72>] ? close_ctree+0x1e6/0x2f2 [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377421]  [<ffffffff8113dfd9>] ? generic_shutdown_super+0x64/0xdf
Mar 15 14:21:30 fan kernel: [92308.377423]  [<ffffffff8113e181>] ? kill_anon_super+0x9/0xe
Mar 15 14:21:30 fan kernel: [92308.377435]  [<ffffffffa04660db>] ? btrfs_kill_super+0xd/0x16 [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377438]  [<ffffffff8113e286>] ? deactivate_locked_super+0x2f/0x56
Mar 15 14:21:30 fan kernel: [92308.377440]  [<ffffffff81152aff>] ? cleanup_mnt+0x4f/0x6b
Mar 15 14:21:30 fan kernel: [92308.377442]  [<ffffffff81066ab7>] ? task_work_run+0x5d/0x71
Mar 15 14:21:30 fan kernel: [92308.377444]  [<ffffffff810036dc>] ? prepare_exit_to_usermode+0x70/0x99
Mar 15 14:21:30 fan kernel: [92308.377446]  [<ffffffff8140de08>] ? int_ret_from_sys_call+0x25/0x8f
Mar 15 14:21:30 fan kernel: [92308.377448] ---[ end trace 18c6bb90b0c6c68a ]---

Mar 15 14:21:30 fan kernel: [92308.377455] ------------[ cut here ]------------
Mar 15 14:21:30 fan kernel: [92308.377469] WARNING: CPU: 5 PID: 28243 at fs/btrfs/extent-tree.c:9595 btrfs_free_block_groups+0x34f/0x36f [btrfs]()
Mar 15 14:21:30 fan kernel: [92308.377471] Modules linked in: vhost_net vhost macvtap macvlan tun iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp dummy ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative bridge stp llc snd_cmipci snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi kvm_amd snd_mpu401_uart snd_opl3_lib snd_rawmidi kvm snd_hda_intel snd_seq_device snd_hda_codec snd_hda_core snd_hwdep amd64_edac_mod snd_pcm_oss edac_mce_amd irqbypass input_leds snd_mixer_oss pcspkr k10temp edac_core snd_pcm snd_timer snd i2c_piix4 asus_atk0110 soundcore acpi_cpufreq tpm_tis tpm sg processor evdev shpchp hwmon_vid autofs4 crc32c_generic btrfs xor raid6_pq ext4 crc16 mbcache jbd2 hmac sha256_ssse3 sha256_generic drbg ansi_cprng xts gf128mul algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid usb_storage sr_mod sd_mod cdrom ohci_pci r8169 mii amdkfd radeon i2c_algo_bit ahci ttm sym53c8xx libahci xhci_pci scsi_transport_spi drm_kms_helper ohci_hcd ehci_pci xhci_hcd libata ehci_hcd drm usbcore scsi_mod usb_common i2c_core button
Mar 15 14:21:30 fan kernel: [92308.377514] CPU: 5 PID: 28243 Comm: umount Tainted: G        W       4.4.5-zgws1 #2
Mar 15 14:21:30 fan kernel: [92308.377515] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Mar 15 14:21:30 fan kernel: [92308.377517]  000000000000005b ffffffff811dd418 0000000000000000 0000000000000009
Mar 15 14:21:30 fan kernel: [92308.377519]  ffffffff81051e21 ffffffffa047a2da ffff880600a28000 ffff8806173f6e88
Mar 15 14:21:30 fan kernel: [92308.377521]  0000000000000038 0000000000000000 ffffffffa047a2da ffff880600a28000
Mar 15 14:21:30 fan kernel: [92308.377523] Call Trace:
Mar 15 14:21:30 fan kernel: [92308.377525]  [<ffffffff811dd418>] ? dump_stack+0x5a/0x6f
Mar 15 14:21:30 fan kernel: [92308.377528]  [<ffffffff81051e21>] ? warn_slowpath_common+0x8e/0xa3
Mar 15 14:21:30 fan kernel: [92308.377542]  [<ffffffffa047a2da>] ? btrfs_free_block_groups+0x34f/0x36f [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377555]  [<ffffffffa047a2da>] ? btrfs_free_block_groups+0x34f/0x36f [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377570]  [<ffffffffa0487c72>] ? close_ctree+0x1e6/0x2f2 [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377573]  [<ffffffff8113dfd9>] ? generic_shutdown_super+0x64/0xdf
Mar 15 14:21:30 fan kernel: [92308.377574]  [<ffffffff8113e181>] ? kill_anon_super+0x9/0xe
Mar 15 14:21:30 fan kernel: [92308.377587]  [<ffffffffa04660db>] ? btrfs_kill_super+0xd/0x16 [btrfs]
Mar 15 14:21:30 fan kernel: [92308.377589]  [<ffffffff8113e286>] ? deactivate_locked_super+0x2f/0x56
Mar 15 14:21:30 fan kernel: [92308.377591]  [<ffffffff81152aff>] ? cleanup_mnt+0x4f/0x6b
Mar 15 14:21:30 fan kernel: [92308.377593]  [<ffffffff81066ab7>] ? task_work_run+0x5d/0x71
Mar 15 14:21:30 fan kernel: [92308.377596]  [<ffffffff810036dc>] ? prepare_exit_to_usermode+0x70/0x99
Mar 15 14:21:30 fan kernel: [92308.377598]  [<ffffffff8140de08>] ? int_ret_from_sys_call+0x25/0x8f
Mar 15 14:21:30 fan kernel: [92308.377600] ---[ end trace 18c6bb90b0c6c68b ]---
Mar 15 14:21:30 fan kernel: [92308.377601] BTRFS: space_info 4 has 20608794624 free, is not full
Mar 15 14:21:30 fan kernel: [92308.377604] BTRFS: space_info total=23085449216, used=2476654592, pinned=0, reserved=0, may_use=25769803776, readonly=0

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
