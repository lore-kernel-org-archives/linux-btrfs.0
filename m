Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48499 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaBKPgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 10:36:49 -0500
Received: from merkaba.localnet (unknown [91.221.105.244])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 9EC90C5
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 16:35:59 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: [3.14-rc1] BUG: soft lockup - CPU#1 stuck for 22s with 255 GiB BTRFS with only 6 GiB free
Date: Tue, 11 Feb 2014 16:36:43 +0100
Message-ID: <16006080.zeFsK4Kcpx@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Today I started getting those on 3.14-rc. One core as displayed as 100%
system CPU. I rebooted cause the system didn´t respond consistently to
user input anymore.

I "solved" this by adding about the last 13,5 GiB of free space on this
Intel SSD 320 to it:

merkaba:~> df -hT /home
Dateisystem    Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/dm-1      btrfs  254G    243G  6,6G   98% /home
merkaba:~> btrfs filesystem resize max /home
Resize '/home' of 'max'
merkaba:~> df -hT /home
Dateisystem    Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/dm-1      btrfs  267G    243G   21G   93% /home



In the weeks and months before this with BTRFS having about 8-9 GiB free I
already saw btrfs-delalloc thread in D state for longer amounts of time and
the machine locking up for some seconds.

Is that considered a bug or is this somehow expected behaviour when a BTRFS
runs almost full? I´d tend to see this as a bug :)

A scrub completed successfully.

A fstrim on that volume takes very long with indicates highly fragmented free
space, aged filesystem to me as on a freshly created and restored from backup
/home its almost instantly.


Free space figures after adding 13,5 GiB to it:

#> ./btrfs fi df /home
Disk size:               266.99GB
Disk allocated:          254.52GB
Disk unallocated:         12.47GB
Used:                    240.90GB
Free (Estimated):         21.89GB       (Max: 22.08GB, min: 15.85GB)
Data to disk ratio:          98 %

(seems BTRFS already took another 1 GiB chunk after adding free space to it.)



#> merkaba:… btrfs-progs-unstable> ./btrfs fi disk-usage /home
Data,Single: Size:246.49GB, Used:238.94GB
   /dev/dm-1      246.49GB

Metadata,Single: Size:8.00MB, Used:0.00
   /dev/dm-1        8.00MB

Metadata,DUP: Size:4.00GB, Used:1.96GB
   /dev/dm-1        8.00GB

System,Single: Size:4.00MB, Used:0.00
   /dev/dm-1        4.00MB

System,DUP: Size:8.00MB, Used:48.00KB
   /dev/dm-1       16.00MB

Unallocated:
   /dev/dm-1       12.47GB



Huh, I thought I used Metadata, Single, but maybe I didn´t. So that would be
an option to gain another GiB.

#> ./btrfs device disk-usage /home
/dev/dm-1         266.99GB
   Data,Single:            246.49GB
   Metadata,Single:          8.00MB
   Metadata,DUP:             8.00GB
   System,Single:            4.00MB
   System,DUP:              16.00MB
   Unallocated:             12.47GB



Mount options:

merkaba:~> grep "/home " /proc/mounts
/dev/dm-1 /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0



Here is an excerpt of syslog. I copied the whole syslog. So I can pull out more context.



Feb 11 15:56:02 merkaba kernel: [ 2136.447054] BUG: soft lockup - CPU#1 stuck for 22s! [btrfs-transacti:1621]
Feb 11 15:56:02 merkaba kernel: [ 2136.447057] Modules linked in: bnep rfcomm bluetooth 6lowpan_iphc ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtabl
es x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) binfmt_misc vboxdrv(O) uinput ext4 crc16
 mbcache jbd2 sbs sbshc joydev hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs dm_crypt snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generi
c snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm thinkpad_acpi nvram intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_seq_m
idi kvm snd_seq_midi_event iwldvm snd_rawmidi mac80211 snd_seq microcode psmouse serio_raw pcspkr snd_seq_device snd_timer iwlwifi snd i2c_i801 cfg80211 lpc_ich mfd_core s
oundcore rfkill ac tpm_tis tpm battery evdev processor btrfs xor raid6_pq md_mod dm_mirror dm_region_hash dm_log dm_mod sg sd_mod sr_mod crc_t10dif cdrom crct10dif_pclmul 
crc32_pclmul crc32c_intel ghash_clmulni_intel ahci aesni_intel ehci_pci libahci sata_sil24 aes_x86_64 lrw ehci_hcd gf128mul glue_helper sdhci_pci ablk_helper cryptd libata
 sdhci mmc_core scsi_mod firewire_ohci firewire_core crc_itu_t usbcore usb_common thermal e1000e ptp pps_core
Feb 11 15:56:02 merkaba kernel: [ 2136.447128] CPU: 1 PID: 1621 Comm: btrfs-transacti Tainted: G      D    O 3.14.0-rc1-tp520+ #44
Feb 11 15:56:02 merkaba kernel: [ 2136.447129] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
Feb 11 15:56:02 merkaba kernel: [ 2136.447131] task: ffff8800371f6140 ti: ffff8800cf36e000 task.ti: ffff8800cf36e000
Feb 11 15:56:02 merkaba kernel: [ 2136.447132] RIP: 0010:[<ffffffff8107035b>]  [<ffffffff8107035b>] do_raw_spin_lock+0x15/0x21
Feb 11 15:56:02 merkaba kernel: [ 2136.447138] RSP: 0000:ffff8800cf36fd30  EFLAGS: 00000297
Feb 11 15:56:02 merkaba kernel: [ 2136.447139] RAX: 000000000000c2c1 RBX: ffffffff81113171 RCX: 0000000000000000
Feb 11 15:56:02 merkaba kernel: [ 2136.447140] RDX: 00000000000000c2 RSI: 0000000000008050 RDI: ffff8802123fd340
Feb 11 15:56:02 merkaba kernel: [ 2136.447142] RBP: ffff8800cf36fd30 R08: 000000000001af40 R09: 0000000000000000
Feb 11 15:56:02 merkaba kernel: [ 2136.447143] R10: 0000000000000040 R11: 0000000000000060 R12: ffffea000337b140
Feb 11 15:56:02 merkaba kernel: [ 2136.447144] R13: ffff88021e29af80 R14: 0000000000b98da9 R15: ffff880211212600
Feb 11 15:56:02 merkaba kernel: [ 2136.447145] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
Feb 11 15:56:02 merkaba kernel: [ 2136.447146] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 11 15:56:02 merkaba kernel: [ 2136.447148] CR2: 00007f0ff8006850 CR3: 0000000001a0b000 CR4: 00000000000407e0
Feb 11 15:56:02 merkaba kernel: [ 2136.447149] Stack:
Feb 11 15:56:02 merkaba kernel: [ 2136.447149]  ffff8800cf36fd48 ffffffff8144182f ffff8802123fd340 ffff8800cf36fda0
Feb 11 15:56:02 merkaba kernel: [ 2136.447152]  ffffffffa029dc76 ffff8800cf36fd90 ffffffffa025244b 0000000000000000
Feb 11 15:56:02 merkaba kernel: [ 2136.447154]  0000003d70cd8000 ffff8800372b1a00 0000003d70cd8000 ffff88020e0b4000
Feb 11 15:56:02 merkaba kernel: [ 2136.447156] Call Trace:
Feb 11 15:56:02 merkaba kernel: [ 2136.447162]  [<ffffffff8144182f>] _raw_spin_lock+0x1a/0x1d
Feb 11 15:56:02 merkaba kernel: [ 2136.447182]  [<ffffffffa029dc76>] __btrfs_add_free_space+0x47/0x2bd [btrfs]
Feb 11 15:56:02 merkaba kernel: [ 2136.447193]  [<ffffffffa025244b>] ? block_group_cache_tree_search+0xb7/0xc5 [btrfs]
Feb 11 15:56:02 merkaba kernel: [ 2136.447204]  [<ffffffffa0256b9c>] unpin_extent_range.isra.54+0xa2/0x194 [btrfs]
Feb 11 15:56:02 merkaba kernel: [ 2136.447216]  [<ffffffffa02598e2>] btrfs_finish_extent_commit+0xa9/0xb9 [btrfs]
Feb 11 15:56:02 merkaba kernel: [ 2136.447229]  [<ffffffffa026a46e>] btrfs_commit_transaction+0x6cc/0x83c [btrfs]
Feb 11 15:56:02 merkaba kernel: [ 2136.447241]  [<ffffffffa0266887>] transaction_kthread+0xf3/0x1a6 [btrfs]
Feb 11 15:56:02 merkaba kernel: [ 2136.447253]  [<ffffffffa0266794>] ? btrfs_cleanup_transaction+0x429/0x429 [btrfs]
Feb 11 15:56:02 merkaba kernel: [ 2136.447255]  [<ffffffff810536e7>] kthread+0xa9/0xb1
Feb 11 15:56:02 merkaba kernel: [ 2136.447257]  [<ffffffff8105363e>] ? __kthread_parkme+0x5c/0x5c
Feb 11 15:56:02 merkaba kernel: [ 2136.447259]  [<ffffffff8144617c>] ret_from_fork+0x7c/0xb0
Feb 11 15:56:02 merkaba kernel: [ 2136.447261]  [<ffffffff8105363e>] ? __kthread_parkme+0x5c/0x5c
Feb 11 15:56:02 merkaba kernel: [ 2136.447262] Code: 14 44 81 48 89 e5 72 0c 31 c0 48 81 ff 34 1b 44 81 0f 92 c0 5d c3 55 b8 00 01 00 00 48 89 e5 f0 66 0f c1 07 0f b6 d4 38 c2 74 0a <8a> 07 38 d0 74 04 f3 90 eb f6 5d c3 55 48 89 e5 f0 ff 07 5d c3 




Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
