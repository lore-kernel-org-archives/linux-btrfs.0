From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: block rsv returned -28 and btrfs_alloc_free_block backtrace on disk full
Date: Sat, 14 Apr 2012 13:52:27 +0200
Message-ID: <201204141352.27646.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

During rsync my external data disk (BTRFS) to the backup disk (BTRFS as=
=20
well) the backup volume run out of space cause I moved a directory and=20
rsync copied the new directory before deleting the old one.

rsync thus failed.

But I also got:


[   41.259894] device label daten devid 1 transid 33361 /dev/sdb2
[   41.260097] btrfs: use lzo compression
[   53.172584] device label daten-backup devid 1 transid 633=20
/dev/mapper/steigerwald-daten
[   53.172868] btrfs: use lzo compression
[   53.172870] btrfs: disk space caching is enabled
[  365.920667] Old style space inode found, converting.
[ 1764.569885] btrfs: block rsv returned -28
[ 1764.569887] ------------[ cut here ]------------
[ 1764.569911] WARNING: at /build/buildd-linux-2.6_3.3-1~experimental.1=
-
amd64-CF_xKk/linux-2.6-3.3/debian/build/source_amd64_none/fs/btrfs/exte=
nt-
tree.c:6170 btrfs_alloc_free_block+0xd7/0x2a6 [btrfs]()
[ 1764.569913] Hardware name: 42433WG
[ 1764.569914] Modules linked in: sata_sil24 ip6table_filter ip6_tables=
=20
iptable_filter ip_tables ebtable_nat ebtables x_tables binfmt_misc=20
acpi_cpufreq mperf cpufreq_stats cpufreq_userspace cpufreq_powersave=20
cpufreq_conservative snd_hda_codec_hdmi pci_stub snd_hda_codec_conexant=
=20
vboxpci(O) vboxnetadp(O) uinput vboxnetflt(O) vboxdrv(O) microcode=20
parport_pc ppdev lp parport nls_utf8 nls_cp437 vfat fat ext4 crc16 jbd2=
=20
mbcache arc4 snd_hda_intel iwlwifi i915 snd_hda_codec snd_hwdep snd_pcm=
_oss=20
snd_mixer_oss mac80211 snd_pcm snd_page_alloc snd_seq_midi=20
snd_seq_midi_event snd_rawmidi drm_kms_helper snd_seq drm thinkpad_acpi=
=20
joydev psmouse snd_seq_device snd_timer cfg80211 tpm_tis tpm nvram=20
serio_raw evdev snd tpm_bios pcspkr wmi battery ac video i2c_i801 iTCO_=
wdt=20
i2c_algo_bit kvm_intel i2c_core iTCO_vendor_support button processor=20
rfkill soundcore kvm sbs sbshc coretemp hdaps(O) tp_smapi(O)=20
thinkpad_ec(O) loop firewire_sbp2 autofs4 btrfs crc32c libcrc32c=20
zlib_deflate dm_mod raid10 raid456 async_raid6_recov async_memcpy async=
_pq=20
async_xor xor async_tx raid6_pq raid1 raid0 multipath linear md_mod usb=
hid=20
hid power_supply sr_mod sd_mod cdrom crc_t10dif sdhci_pci ahci sdhci=20
libahci mmc_core libata firewire_ohci thermal thermal_sys firewire_core=
=20
scsi_mod crc_itu_t ehci_hcd e1000e usbcore usb_common [last unloaded:=20
scsi_wait_scan]
[ 1764.569973] Pid: 4663, comm: btrfs-endio-wri Tainted: G        W  O=20
3.3.0-trunk-amd64 #1
[ 1764.569975] Call Trace:
[ 1764.569980]  [<ffffffff81038833>] ? warn_slowpath_common+0x78/0x8c
[ 1764.569989]  [<ffffffffa0204e37>] ? btrfs_alloc_free_block+0xd7/0x2a=
6=20
[btrfs]
[ 1764.569993]  [<ffffffff810bea51>] ? __set_page_dirty_nobuffers+0xbf/=
0xd8
[ 1764.570004]  [<ffffffffa022a1ef>] ? read_extent_buffer+0x94/0xed [bt=
rfs]
[ 1764.570011]  [<ffffffffa01f7caa>] ? __btrfs_cow_block+0x109/0x34e [b=
trfs]
[ 1764.570018]  [<ffffffffa01f7fe6>] ? btrfs_cow_block+0xf7/0x143 [btrf=
s]
[ 1764.570026]  [<ffffffffa01faa5c>] ? btrfs_search_slot+0x225/0x64e [b=
trfs]
[ 1764.570035]  [<ffffffffa0208a1a>] ? btrfs_lookup_csum+0x66/0x106 [bt=
rfs]
[ 1764.570044]  [<ffffffffa02096ea>] ? btrfs_csum_file_blocks+0xa4/0x4a=
a=20
[btrfs]
[ 1764.570054]  [<ffffffffa0213a20>] ? add_pending_csums.isra.32+0x34/0=
x50=20
[btrfs]
[ 1764.570064]  [<ffffffffa0216109>] ? btrfs_finish_ordered_io+0x207/0x=
29a=20
[btrfs]
[ 1764.570075]  [<ffffffffa022811a>] ? end_extent_writepage+0x47/0xcb [=
btrfs]
[ 1764.570084]  [<ffffffffa0228206>] ? end_bio_extent_writepage+0x68/0x=
90=20
[btrfs]
[ 1764.570094]  [<ffffffffa0231a62>] ? worker_loop+0x176/0x494 [btrfs]
[ 1764.570104]  [<ffffffffa02318ec>] ? btrfs_queue_worker+0x273/0x273 [=
btrfs]
[ 1764.570106]  [<ffffffff8105119e>] ? kthread+0x7d/0x85
[ 1764.570110]  [<ffffffff813585a4>] ? kernel_thread_helper+0x4/0x10
[ 1764.570112]  [<ffffffff81051121>] ? kthread_freezable_should_stop+0x=
3c/0x3c
[ 1764.570114]  [<ffffffff813585a0>] ? gs_change+0x13/0x13
[ 1764.570115] ---[ end trace 99344c773ac547f0 ]---
[ 1764.580005] btrfs: block rsv returned -28
[ 1764.580010] ------------[ cut here ]------------
[ 1764.580046] WARNING: at /build/buildd-linux-2.6_3.3-1~experimental.1=
-
amd64-CF_xKk/linux-2.6-3.3/debian/build/source_amd64_none/fs/btrfs/exte=
nt-
tree.c:6170 btrfs_alloc_free_block+0xd7/0x2a6 [btrfs]()
[ 1764.580052] Hardware name: 42433WG
[ 1764.580054] Modules linked in: sata_sil24 ip6table_filter ip6_tables=
=20
iptable_filter ip_tables ebtable_nat ebtables x_tables binfmt_misc=20
acpi_cpufreq mperf cpufreq_stats cpufreq_userspace cpufreq_powersave=20
cpufreq_conservative snd_hda_codec_hdmi pci_stub snd_hda_codec_conexant=
=20
vboxpci(O) vboxnetadp(O) uinput vboxnetflt(O) vboxdrv(O) microcode=20
parport_pc ppdev lp parport nls_utf8 nls_cp437 vfat fat ext4 crc16 jbd2=
=20
mbcache arc4 snd_hda_intel iwlwifi i915 snd_hda_codec snd_hwdep snd_pcm=
_oss=20
snd_mixer_oss mac80211 snd_pcm snd_page_alloc snd_seq_midi=20
snd_seq_midi_event snd_rawmidi drm_kms_helper snd_seq drm thinkpad_acpi=
=20
joydev psmouse snd_seq_device snd_timer cfg80211 tpm_tis tpm nvram=20
serio_raw evdev snd tpm_bios pcspkr wmi battery ac video i2c_i801 iTCO_=
wdt=20
i2c_algo_bit kvm_intel i2c_core iTCO_vendor_support button processor=20
rfkill soundcore kvm sbs sbshc coretemp hdaps(O) tp_smapi(O)=20
thinkpad_ec(O) loop firewire_sbp2 autofs4 btrfs crc32c libcrc32c=20
zlib_deflate dm_mod raid10 raid456 async_raid6_recov async_memcpy async=
_pq=20
async_xor xor async_tx raid6_pq raid1 raid0 multipath linear md_mod usb=
hid=20
hid power_supply sr_mod sd_mod cdrom crc_t10dif sdhci_pci ahci sdhci=20
libahci mmc_core libata firewire_ohci thermal thermal_sys firewire_core=
=20
scsi_mod crc_itu_t ehci_hcd e1000e usbcore usb_common [last unloaded:=20
scsi_wait_scan]
[ 1764.580142] Pid: 4742, comm: btrfs-endio-wri Tainted: G        W  O=20
3.3.0-trunk-amd64 #1
[ 1764.580144] Call Trace:
[ 1764.580148]  [<ffffffff81038833>] ? warn_slowpath_common+0x78/0x8c
[ 1764.580158]  [<ffffffffa0204e37>] ? btrfs_alloc_free_block+0xd7/0x2a=
6=20
[btrfs]
[ 1764.580172]  [<ffffffffa022a1ef>] ? read_extent_buffer+0x94/0xed [bt=
rfs]
[ 1764.580180]  [<ffffffffa01f7caa>] ? __btrfs_cow_block+0x109/0x34e [b=
trfs]
[ 1764.580189]  [<ffffffffa01f7fe6>] ? btrfs_cow_block+0xf7/0x143 [btrf=
s]
[ 1764.580198]  [<ffffffffa01faa5c>] ? btrfs_search_slot+0x225/0x64e [b=
trfs]
[ 1764.580209]  [<ffffffffa0208a1a>] ? btrfs_lookup_csum+0x66/0x106 [bt=
rfs]
[ 1764.580219]  [<ffffffffa02096ea>] ? btrfs_csum_file_blocks+0xa4/0x4a=
a=20
[btrfs]
[ 1764.580232]  [<ffffffffa0213a20>] ? add_pending_csums.isra.32+0x34/0=
x50=20
[btrfs]
[ 1764.580244]  [<ffffffffa0216109>] ? btrfs_finish_ordered_io+0x207/0x=
29a=20
[btrfs]
[ 1764.580257]  [<ffffffffa022811a>] ? end_extent_writepage+0x47/0xcb [=
btrfs]
[ 1764.580269]  [<ffffffffa0228206>] ? end_bio_extent_writepage+0x68/0x=
90=20
[btrfs]
[ 1764.580280]  [<ffffffffa0231a62>] ? worker_loop+0x176/0x494 [btrfs]
[ 1764.580292]  [<ffffffffa02318ec>] ? btrfs_queue_worker+0x273/0x273 [=
btrfs]
[ 1764.580295]  [<ffffffff8105119e>] ? kthread+0x7d/0x85
[ 1764.580298]  [<ffffffff813585a4>] ? kernel_thread_helper+0x4/0x10
[ 1764.580300]  [<ffffffff81051121>] ? kthread_freezable_should_stop+0x=
3c/0x3c
[ 1764.580303]  [<ffffffff813585a0>] ? gs_change+0x13/0x13
[ 1764.580305] ---[ end trace 99344c773ac547f1 ]---


I was puzzled cause rsync just told that the write failed, not that no=20
space was left on device.


Some space information - but after I already told the computer to delet=
e=20
the old directory from the backup in order to continue the backup and t=
he=20
delete was in progress:

merkaba:~> btrfs filesystem show
[=E2=80=A6]

Label: 'daten-backup'  uuid: [=E2=80=A6]
        Total devices 1 FS bytes used 295.05GB
        devid    1 size 450.00GB used 450.00GB path /dev/dm-7

Label: 'daten'  uuid: [=E2=80=A6]
        Total devices 1 FS bytes used 363.06GB
        devid    1 size 447.13GB used 447.13GB path /dev/sdb2
[=E2=80=A6]

Btrfs Btrfs v0.19

merkaba:~> btrfs filesystem df /mnt/amazon-daten=20
Data: total=3D428.61GB, used=3D362.39GB
System, DUP: total=3D8.00MB, used=3D56.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D9.25GB, used=3D681.96MB
Metadata: total=3D8.00MB, used=3D0.00

merkaba:~> btrfs filesystem df /mnt/steigerwald-daten=20
Data: total=3D431.22GB, used=3D269.81GB
System, DUP: total=3D8.00MB, used=3D56.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D9.38GB, used=3D489.48MB
Metadata: total=3D8.00MB, used=3D0.00

merkaba:~> cat /proc/version=20
Linux version 3.3.0-trunk-amd64 (Debian 3.3-1~experimental.1) (debian-
kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1 SMP T=
hu=20
Mar 22 18:02:10 UTC 2012

(which should be 3.3.0)

rsync is continuing just now.


Maybe that is the space reservation issue I read about here on the mail=
ing=20
list?

Anyway I just wanted to report it. If its already resolved, please tell=
=20
me.=20

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
