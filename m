Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58144 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaBQKfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 05:35:43 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Dave <dave@thekilempire.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.14-rc1] BUG: soft lockup - CPU#1 stuck for 22s with 255 GiB BTRFS with only 6 GiB free
Date: Mon, 17 Feb 2014 11:35:41 +0100
Message-ID: <2243736.htmPCRf1EE@merkaba>
In-Reply-To: <CAAVQaYBurkq_OdE7K0vEoNhToFHYRQo5Y4bJE_Cx5J-awDh1ow@mail.gmail.com>
References: <16006080.zeFsK4Kcpx@merkaba> <CAAVQaYBurkq_OdE7K0vEoNhToFHYRQo5Y4bJE_Cx5J-awDh1ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 11. Februar 2014, 15:50:12 schrieb Dave:
> On Tue, Feb 11, 2014 at 10:36 AM, Martin Steigerwald
> 
> <Martin@lichtvoll.de> wrote:
> > Today I started getting those on 3.14-rc. One core as displayed as 100%
> > system CPU. I rebooted cause the system didn´t respond consistently to
> > user input anymore.
> 
> Does 3.14-rc1 have Joseph's delayed refs throttling code?  I had two
> separate machines that exhibited similar symptoms.  Chris's for-linus
> branch has a fix for this which solved my problems:
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus&id=27a377db745ed4d11b3b9b340756857cb8dde07f

I also got this now under 3.14-rc3 with almost 16 GiB left on heavy KMail /
Akonadi activity. 3.14-rc3 includes above commit.

As I now also got it with more free space and never saw this with upto
3.13 I think this is a regression.

Another trace:

Feb 17 11:22:38 merkaba kernel: [ 1816.159830] BUG: soft lockup - CPU#1 stuck for 22s! [btrfs-transacti:1618]
Feb 17 11:22:38 merkaba kernel: [ 1816.159834] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs libcrc32c rfcomm
 bnep bluetooth 6lowpan_iphc ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables cpufreq_userspace cpufreq_
stats cpufreq_powersave cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) binfmt_misc vboxdrv(O) uinput ext4 crc16 mbc
ache jbd2 sbs sbshc hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs dm_crypt joydev snd_hda_codec_hdmi snd_hda_codec
_conexant snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm intel_rapl x86_pkg_temp_thermal i
ntel_powerclamp thinkpad_acpi nvram coretemp kvm_intel snd_seq_midi kvm snd_seq_midi_event iwldvm mac80211 snd_rawmidi microcode snd_seq 
pcspkr psmouse iwlwifi serio_raw snd_seq_device snd_timer lpc_ich cfg80211 mfd_core i2c_i801 snd soundcore rfkill battery ac tpm_tis tpm 
evdev processor btrfs xor raid6_pq md_mod dm_mirror dm_region_hash dm_log dm_mod sg sr_mod cdrom sd_mod crc_t10dif hid_generic usbhid hid
 crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel firewire_ohci aesni_intel sdhci_pci aes_x86_64 lrw gf128mul sdhci glue_he
lper ablk_helper firewire_core mmc_core crc_itu_t sata_sil24 ahci ehci_pci libahci libata cryptd ehci_hcd scsi_mod usbcore e1000e usb_com
mon ptp pps_core thermal
Feb 17 11:22:38 merkaba kernel: [ 1816.159946] CPU: 1 PID: 1618 Comm: btrfs-transacti Tainted: G           O 3.14.0-rc3-tp520 #46
Feb 17 11:22:38 merkaba kernel: [ 1816.159948] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
Feb 17 11:22:38 merkaba kernel: [ 1816.159951] task: ffff88020ed19850 ti: ffff88020ed14000 task.ti: ffff88020ed14000
Feb 17 11:22:38 merkaba kernel: [ 1816.159953] RIP: 0010:[<ffffffff81070279>]  [<ffffffff81070279>] do_raw_spin_lock+0x15/0x21
Feb 17 11:22:38 merkaba kernel: [ 1816.159961] RSP: 0018:ffff88020ed15d30  EFLAGS: 00000297
Feb 17 11:22:38 merkaba kernel: [ 1816.159963] RAX: 0000000000003130 RBX: ffffffff8111239e RCX: 0000000000000000
Feb 17 11:22:38 merkaba kernel: [ 1816.159965] RDX: 0000000000000031 RSI: 0000000000008050 RDI: ffff880036dfc640
Feb 17 11:22:38 merkaba kernel: [ 1816.159967] RBP: ffff88020ed15d30 R08: 000000000001af40 R09: 0000000000000000
Feb 17 11:22:38 merkaba kernel: [ 1816.159969] R10: 0000000000000009 R11: 0000000000000008 R12: ffffea00058e2640
Feb 17 11:22:38 merkaba kernel: [ 1816.159971] R13: ffff88021e29af80 R14: 000000000193ecd5 R15: ffff88021135d900
Feb 17 11:22:38 merkaba kernel: [ 1816.159974] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
Feb 17 11:22:38 merkaba kernel: [ 1816.159976] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 17 11:22:38 merkaba kernel: [ 1816.159978] CR2: 00007fe3963e1000 CR3: 0000000001a0b000 CR4: 00000000000407e0
Feb 17 11:22:38 merkaba kernel: [ 1816.159979] Stack:
Feb 17 11:22:38 merkaba kernel: [ 1816.159981]  ffff88020ed15d48 ffffffff81441c6d ffff880036dfc640 ffff88020ed15da0
Feb 17 11:22:38 merkaba kernel: [ 1816.159985]  ffffffffa02d8c6c ffff88020ed15d90 ffffffffa028d46a 0000000000000000
Feb 17 11:22:38 merkaba kernel: [ 1816.159989]  0000003fe0a04000 ffff8800cf824c00 0000003fe0a04000 ffff880037232000
Feb 17 11:22:38 merkaba kernel: [ 1816.159993] Call Trace:
Feb 17 11:22:38 merkaba kernel: [ 1816.160000]  [<ffffffff81441c6d>] _raw_spin_lock+0x1a/0x1d
Feb 17 11:22:38 merkaba kernel: [ 1816.160031]  [<ffffffffa02d8c6c>] __btrfs_add_free_space+0x47/0x2bd [btrfs]
Feb 17 11:22:38 merkaba kernel: [ 1816.160048]  [<ffffffffa028d46a>] ? block_group_cache_tree_search+0xb7/0xc5 [btrfs]
Feb 17 11:22:38 merkaba kernel: [ 1816.160063]  [<ffffffffa0291bb9>] unpin_extent_range.isra.54+0xa2/0x194 [btrfs]
Feb 17 11:22:38 merkaba kernel: [ 1816.160080]  [<ffffffffa02948ff>] btrfs_finish_extent_commit+0xa9/0xb9 [btrfs]
Feb 17 11:22:38 merkaba kernel: [ 1816.160097]  [<ffffffffa02a548a>] btrfs_commit_transaction+0x6cc/0x83c [btrfs]
Feb 17 11:22:38 merkaba kernel: [ 1816.160114]  [<ffffffffa02a18a3>] transaction_kthread+0xf3/0x1a6 [btrfs]
Feb 17 11:22:38 merkaba kernel: [ 1816.160132]  [<ffffffffa02a17b0>] ? btrfs_cleanup_transaction+0x429/0x429 [btrfs]
Feb 17 11:22:38 merkaba kernel: [ 1816.160135]  [<ffffffff81053607>] kthread+0xa9/0xb1
Feb 17 11:22:38 merkaba kernel: [ 1816.160138]  [<ffffffff8105355e>] ? __kthread_parkme+0x5c/0x5c
Feb 17 11:22:38 merkaba kernel: [ 1816.160142]  [<ffffffff8144657c>] ret_from_fork+0x7c/0xb0
Feb 17 11:22:38 merkaba kernel: [ 1816.160145]  [<ffffffff8105355e>] ? __kthread_parkme+0x5c/0x5c
Feb 17 11:22:38 merkaba kernel: [ 1816.160147] Code: 18 44 81 48 89 e5 72 0c 31 c0 48 81 ff 72 1f 44 81 0f 92 c0 5d c3 55 b8 00 01 00 00 48 89 e5 f0 66 0f c1 07 0f b6 d4 38 c2 74 0a <8a> 07 38 d0 74 04 f3 90 eb f6 5d c3 55 48 89 e5 f0 ff 07 5d c3 

(I will save kern.log in case you need more context)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
