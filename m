Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56922 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLZNhj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 08:37:39 -0500
Received: from merkaba.localnet (ppp-88-217-104-169.dynamic.mnet-online.de [88.217.104.169])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 5473DC5
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Dec 2014 14:36:53 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS free space handling still needs more work: Hangs again
Date: Fri, 26 Dec 2014 14:37:36 +0100
Message-ID: <3738341.y7uRQFcLJH@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

First: Have a merry christmas and enjoy a quiet time in these days.

Second: At a time you feel like it, here is a little rant, but also a bug
report:




























I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RAID with
space_cache, skinny meta data extents ‚Äì are these a problem? ‚Äì and
compress=lzo:

merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
        Total devices 2 FS bytes used 144.41GiB
        devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msata-home
        devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sata-home

Btrfs v3.17
merkaba:~> btrfs fi df /home
Data, RAID1: total=154.97GiB, used=141.12GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=5.00GiB, used=3.29GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


And I had hangs with BTRFS again. This time as I wanted to install tax
return software in Virtualbox¬¥d Windows XP VM (which I use once a year
cause I know no tax return software for Linux which would be suitable for
Germany and I frankly don¬¥t care about the end of security cause all
surfing and other network access I will do from the Linux box and I only
run the VM behind a firewall).


And thus I try the balance dance again:

merkaba:~> btrfs balance start -dusage=5 -musage=5 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#1> btrfs balance start -dusage=5 -musage=5 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#1> btrfs balance start -dusage=5 /home          
Done, had to relocate 0 out of 164 chunks
merkaba:~> btrfs balance start -dusage=10 /home
Done, had to relocate 0 out of 164 chunks
merkaba:~> btrfs balance start -dusage=20 /home
Done, had to relocate 0 out of 164 chunks
merkaba:~> btrfs balance start -dusage=30 /home
Done, had to relocate 0 out of 164 chunks
merkaba:~> btrfs balance start -dusage=40 /home
Done, had to relocate 0 out of 164 chunks
merkaba:~> btrfs balance start -dusage=50 /home
Done, had to relocate 0 out of 164 chunks
merkaba:~> btrfs balance start -dusage=60 /home
Done, had to relocate 0 out of 164 chunks
merkaba:~> btrfs balance start -dusage=70 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#1> btrfs balance start -dusage=70 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#1> btrfs balance start -dusage=70 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#1> btrfs balance start -dusage=65 /home
Done, had to relocate 0 out of 164 chunks
merkaba:~> btrfs balance start -dusage=67 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#1> btrfs balance start -musage=10 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#1> btrfs balance start -musage=05 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail


Okay, not really, ey?



But

merkaba:~> btrfs balance start /home

works.

So I am rebalancing everything basically, without need I bet, so causing
more churn to SSDs than is needed.


Otherwise alternative would be to make BTRFS larger I bet.


Well this is still not what I would consider stable. So I will still
recommend: If you want to use BTRFS on a server and estimate 25 GiB of
usage, make drive at least 50GiB big or even 100GiB to be on the safe
side. Like I recommended for SLES 11 SP 2/3 BTRFS deployments ‚Äì but
hey, there say meanwhile "don¬¥t" as in "just don¬¥t use it at all and use SLES
12 instead, cause BTRFS with 3.0 kernel with a ton of snapper snapshots
is really not asking for anything even near to production or enterprise
reliability" (if you need proof, I think I still have a snapshot of a SLES
11 SP3 VM that broke over night due to me having installed an LDAP server
for preparing some training slides). Even 3.12 kernel seems daring regarding
BTRFS, unless SUSE actively backports fixes.


In kernel log the failed attempts look like this:

[  209.783437] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  210.116416] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  210.455479] BTRFS info (device dm-3): 1 enospc errors during balance
[  212.915690] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  213.291634] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  213.654145] BTRFS info (device dm-3): 1 enospc errors during balance
[  219.219584] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  219.531864] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  222.721234] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  223.084007] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  226.418100] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  226.730118] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  230.218590] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  230.559232] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  233.979952] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  234.320569] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  237.672101] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  237.961171] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  241.262757] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  241.594655] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  244.783861] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  245.095942] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
[  245.418042] BTRFS info (device dm-3): relocating block group 500198014976 flags 17
[  245.544153] BTRFS info (device dm-3): relocating block group 496997761024 flags 17
[  245.644254] BTRFS info (device dm-3): relocating block group 495924019200 flags 17
[  246.281001] BTRFS info (device dm-3): relocating block group 488407826432 flags 17
[  246.449939] BTRFS info (device dm-3): relocating block group 431499509760 flags 17
[  246.561724] BTRFS info (device dm-3): relocating block group 411804106752 flags 17
[  246.723997] BTRFS info (device dm-3): relocating block group 409656623104 flags 17
[  251.770469] BTRFS info (device dm-3): 7 enospc errors during balance




My expection for a *stable* and *production quality* filesystem would be:

I never ever get hangs with one kworker running on 100% of one Sandybridge
core *for minutes* in a production filesystem and thats about it.

Especially for a filesystem that claims to still have a good amount of free
space:

merkaba:~> LANG=C df -hT /home
Filesystem             Type   Size  Used Avail Use% Mounted on
/dev/mapper/msata-home btrfs  160G  146G   25G  86% /home

(yeah, these don¬¥t add up, I account this to compression, but hey, who knows)


In kernel log I have things like this, but some earlier time and these I have
not yet perceived as hangs:

Dec 23 23:33:26 merkaba kernel: [23040.621678] ------------[ cut here ]------------
Dec 23 23:33:26 merkaba kernel: [23040.621792] WARNING: CPU: 3 PID: 308 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empt
y+0x2d/0x2f [btrfs]()
Dec 23 23:33:26 merkaba kernel: [23040.621796] Modules linked in: mmc_block ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c snd
_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device hid_generic hid_pl ff_memless usbhid hid nls_utf8 nls_cp437 vfat fat uas usb_stor
age bnep bluetooth binfmt_misc cpufreq_userspace cpufreq_stats pci_stub cpufreq_powersave vboxpci(O) cpufreq_conservative vboxnetadp(O)
 vboxnetflt(O) vboxdrv(O) ext4 crc16 mbcache jbd2 intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32
_pclmul ghash_clmulni_intel snd_hda_codec_hdmi iwldvm aesni_intel snd_hda_codec_conexant mac80211 aes_x86_64 snd_hda_codec_generic lrw 
gf128mul glue_helper ablk_helper cryptd psmouse snd_hda_intel serio_raw iwlwifi pcspkr lpc_ich snd_hda_controller i2c_i801 mfd_core snd
_hda_codec snd_hwdep cfg80211 snd_pcm snd_timer shpchp thinkpad_acpi nvram snd soundcore rfkill battery ac tpm_tis tpm processor evdev 
joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microc
ode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom crc32c_intel ahci firewire_ohci libahci sata_sil24 e1000e libata ptp 
sdhci_pci ehci_pci sdhci firewire_core ehci_hcd crc_itu_t pps_core mmc_core scsi_mod usbcore usb_common thermal
Dec 23 23:33:26 merkaba kernel: [23040.621978] CPU: 3 PID: 308 Comm: btrfs-transacti Tainted: G        W  O   3.18.0-tp520 #14
Dec 23 23:33:26 merkaba kernel: [23040.621982] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
Dec 23 23:33:26 merkaba kernel: [23040.621985]  0000000000000009 ffff8804044c7d88 ffffffff814a516e 0000000080000000
Dec 23 23:33:26 merkaba kernel: [23040.621992]  0000000000000000 ffff8804044c7dc8 ffffffff8103f83e ffff8804044c7db8
Dec 23 23:33:26 merkaba kernel: [23040.621999]  ffffffffc04bd5a1 ffff880037590800 ffff8800a599c320 0000000000000000
Dec 23 23:33:26 merkaba kernel: [23040.622006] Call Trace:
Dec 23 23:33:26 merkaba kernel: [23040.622026]  [<ffffffff814a516e>] dump_stack+0x4f/0x7c
Dec 23 23:33:26 merkaba kernel: [23040.622034]  [<ffffffff8103f83e>] warn_slowpath_common+0x7c/0x96
Dec 23 23:33:26 merkaba kernel: [23040.622104]  [<ffffffffc04bd5a1>] ? btrfs_assert_delayed_root_empty+0x2d/0x2f [btrfs]
Dec 23 23:33:26 merkaba kernel: [23040.622111]  [<ffffffff8103f8ec>] warn_slowpath_null+0x15/0x17
Dec 23 23:33:26 merkaba kernel: [23040.622164]  [<ffffffffc04bd5a1>] btrfs_assert_delayed_root_empty+0x2d/0x2f [btrfs]
Dec 23 23:33:26 merkaba kernel: [23040.622211]  [<ffffffffc047a830>] btrfs_commit_transaction+0x394/0x8bc [btrfs]
Dec 23 23:33:26 merkaba kernel: [23040.622254]  [<ffffffffc0476dd5>] transaction_kthread+0xf9/0x1af [btrfs]
Dec 23 23:33:26 merkaba kernel: [23040.622295]  [<ffffffffc0476cdc>] ? btrfs_cleanup_transaction+0x43a/0x43a [btrfs]
Dec 23 23:33:26 merkaba kernel: [23040.622305]  [<ffffffff8105697c>] kthread+0xb2/0xba
Dec 23 23:33:26 merkaba kernel: [23040.622312]  [<ffffffff814a0000>] ? dcbnl_newmsg+0x14/0xa8
Dec 23 23:33:26 merkaba kernel: [23040.622317]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
Dec 23 23:33:26 merkaba kernel: [23040.622324]  [<ffffffff814a9f6c>] ret_from_fork+0x7c/0xb0
Dec 23 23:33:26 merkaba kernel: [23040.622329]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
Dec 23 23:33:26 merkaba kernel: [23040.622334] ---[ end trace 90db5b1c7067cf1d ]---
Dec 23 23:33:56 merkaba kernel: [23070.671999] ------------[ cut here ]------------


Dec 23 23:33:56 merkaba kernel: [23070.671999] ------------[ cut here ]------------
Dec 23 23:33:56 merkaba kernel: [23070.672064] WARNING: CPU: 3 PID: 308 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empt
y+0x2d/0x2f [btrfs]()
Dec 23 23:33:56 merkaba kernel: [23070.672067] Modules linked in: mmc_block ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device hid_generic hid_pl ff_memless usbhid hid nls_utf8 nls_cp437 vfat fat uas usb_storage bnep bluetooth binfmt_misc cpufreq_userspace cpufreq_stats pci_stub cpufreq_powersave vboxpci(O) cpufreq_conservative vboxnetadp(O) vboxnetflt(O) vboxdrv(O) ext4 crc16 mbcache jbd2 intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_hdmi iwldvm aesni_intel snd_hda_codec_conexant mac80211 aes_x86_64 snd_hda_codec_generic lrw gf128mul glue_helper ablk_helper cryptd psmouse snd_hda_intel serio_raw iwlwifi pcspkr lpc_ich snd_hda_controller i2c_i801 mfd_core snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_timer shpchp thinkpad_acpi nvram snd soundcore rfkill battery ac tpm_tis tpm processor evdev joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microcode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom crc32c_intel ahci firewire_ohci libahci sata_sil24 e1000e libata ptp sdhci_pci ehci_pci sdhci firewire_core ehci_hcd crc_itu_t pps_core mmc_core scsi_mod usbcore usb_common thermal
Dec 23 23:33:56 merkaba kernel: [23070.672193] CPU: 3 PID: 308 Comm: btrfs-transacti Tainted: G        W  O   3.18.0-tp520 #14
Dec 23 23:33:56 merkaba kernel: [23070.672196] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
Dec 23 23:33:56 merkaba kernel: [23070.672200]  0000000000000009 ffff8804044c7d88 ffffffff814a516e 0000000080000000
Dec 23 23:33:56 merkaba kernel: [23070.672205]  0000000000000000 ffff8804044c7dc8 ffffffff8103f83e ffff8804044c7db8
Dec 23 23:33:56 merkaba kernel: [23070.672209]  ffffffffc04bd5a1 ffff880037590800 ffff8802cd6e50a0 0000000000000000
Dec 23 23:33:56 merkaba kernel: [23070.672214] Call Trace:
Dec 23 23:33:56 merkaba kernel: [23070.672222]  [<ffffffff814a516e>] dump_stack+0x4f/0x7c
Dec 23 23:33:56 merkaba kernel: [23070.672229]  [<ffffffff8103f83e>] warn_slowpath_common+0x7c/0x96
Dec 23 23:33:56 merkaba kernel: [23070.672264]  [<ffffffffc04bd5a1>] ? btrfs_assert_delayed_root_empty+0x2d/0x2f [btrfs]
Dec 23 23:33:56 merkaba kernel: [23070.672270]  [<ffffffff8103f8ec>] warn_slowpath_null+0x15/0x17
Dec 23 23:33:56 merkaba kernel: [23070.672301]  [<ffffffffc04bd5a1>] btrfs_assert_delayed_root_empty+0x2d/0x2f [btrfs]
Dec 23 23:33:56 merkaba kernel: [23070.672330]  [<ffffffffc047a830>] btrfs_commit_transaction+0x394/0x8bc [btrfs]
Dec 23 23:33:56 merkaba kernel: [23070.672357]  [<ffffffffc0476dd5>] transaction_kthread+0xf9/0x1af [btrfs]
Dec 23 23:33:56 merkaba kernel: [23070.672383]  [<ffffffffc0476cdc>] ? btrfs_cleanup_transaction+0x43a/0x43a [btrfs]
Dec 23 23:33:56 merkaba kernel: [23070.672389]  [<ffffffff8105697c>] kthread+0xb2/0xba
Dec 23 23:33:56 merkaba kernel: [23070.672395]  [<ffffffff814a0000>] ? dcbnl_newmsg+0x14/0xa8
Dec 23 23:33:56 merkaba kernel: [23070.672399]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
Dec 23 23:33:56 merkaba kernel: [23070.672405]  [<ffffffff814a9f6c>] ret_from_fork+0x7c/0xb0
Dec 23 23:33:56 merkaba kernel: [23070.672409]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
Dec 23 23:33:56 merkaba kernel: [23070.672412] ---[ end trace 90db5b1c7067cf1e ]---
Dec 23 23:34:26 merkaba kernel: [23100.709530] ------------[ cut here ]------------


The recent hangings today are not in the log, I was upset enough to
forcefully switch of the machine. Tax returns are not my all time favorite,
but tax returns with hanging filesystems is no fun at all.


I will upgrade to 3.19 with 3.19-rc2.

Lets see what this balance will do.

It currently is here:

merkaba:~> btrfs balance status /home
Balance on '/home' is running
32 out of about 164 chunks balanced (53 considered),  80% left

merkaba:~> btrfs fi df /home
Data, RAID1: total=154.97GiB, used=142.10GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=5.00GiB, used=3.33GiB
GlobalReserve, single: total=512.00MiB, used=254.31MiB


So for once, we are told not to balance needlessly, but then in order for
stable operation I need to balance nonetheless?

Well lets see how it will improve things. Last time it did. Considerably.
BTRFS only had these hang problems with 3.15 and 3.16 if trees allocated
all remaining space. So I expect it to downsize these trees are to there is
some device space being freed to allocatable again.

Next I will also defrag the Windows VM image just as an additional safety
net.


Okay, doing something else now as the BTRFS will sort things out hopefully.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
