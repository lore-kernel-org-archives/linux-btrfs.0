Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51844 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3BET1Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 14:27:25 -0500
Received: by mail-ie0-f171.google.com with SMTP id 10so746581ied.30
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Feb 2013 11:27:25 -0800 (PST)
MIME-Version: 1.0
From: Marguerite Su <i@marguerite.su>
Date: Wed, 6 Feb 2013 03:27:04 +0800
Message-ID: <CAK0PdAkGdGWg8TzrDK0hRgcrqqkTF7XrcOHX2wh_7DLG3G0CLA@mail.gmail.com>
Subject: btrfs: Error removing orphan entry, stopping orphan cleanup. could
 not do orphan cleanup -22
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I got a kernel crash or something said this.

I see it attach a dump, so it seems btrfs devs are the only group who
can read it...

Feb 05 19:00:19 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:19 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649882 /dev/sda5
Feb 05 19:00:19 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:19 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:19 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:19 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:19 linux-sclt.site postfix/master[665]: daemon started --
version 2.8.13, configuration /etc/postfix
Feb 05 19:00:20 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:20 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:20 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:20 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:20 linux-sclt.site kernel: Pid: 1038, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:20 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:20 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:20 linux-sclt.site kernel:  [<00007f8095a89f4a>] 0x7f8095a89f49
Feb 05 19:00:20 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3ef3 ]---
Feb 05 19:00:20 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:20 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:20 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:22 linux-sclt.site mount[1038]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:22 linux-sclt.site mount[1038]: missing codepage or
helper program, or other error
Feb 05 19:00:22 linux-sclt.site mount[1038]: In some cases useful info
is found in syslog - try
Feb 05 19:00:22 linux-sclt.site mount[1038]: dmesg | tail or so
Feb 05 19:00:22 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:22 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:22 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:22 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:22 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:22 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649884 /dev/sda5
Feb 05 19:00:22 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:22 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:22 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:22 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:22 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Activating via systemd: service name='org.freedesktop.ConsoleKit'
unit='console-kit-daemon.service'
Feb 05 19:00:22 linux-sclt.site dbus[486]: [system] Activating via
systemd: service name='org.freedesktop.ConsoleKit'
unit='console-kit-daemon.service'
Feb 05 19:00:22 linux-sclt.site systemd[1]: Starting Console Manager...
Feb 05 19:00:22 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Successfully activated service 'org.freedesktop.ConsoleKit'
Feb 05 19:00:22 linux-sclt.site dbus[486]: [system] Successfully
activated service 'org.freedesktop.ConsoleKit'
Feb 05 19:00:22 linux-sclt.site systemd[1]: Started Console Manager.
Feb 05 19:00:23 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:23 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:23 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:23 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:23 linux-sclt.site kernel: Pid: 1070, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:23 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:23 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:23 linux-sclt.site kernel:  [<00007fd01339ff4a>] 0x7fd01339ff49
Feb 05 19:00:23 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3ef4 ]---
Feb 05 19:00:23 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:23 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:23 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:25 linux-sclt.site mount[1070]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:25 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:25 linux-sclt.site mount[1070]: missing codepage or
helper program, or other error
Feb 05 19:00:25 linux-sclt.site mount[1070]: In some cases useful info
is found in syslog - try
Feb 05 19:00:25 linux-sclt.site mount[1070]: dmesg | tail or so
Feb 05 19:00:25 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:25 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:25 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:25 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:25 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649886 /dev/sda5
Feb 05 19:00:25 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:25 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:25 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:25 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:26 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:26 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:26 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:26 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:26 linux-sclt.site kernel: Pid: 1262, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:26 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:26 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:26 linux-sclt.site kernel:  [<00007f5e3c22bf4a>] 0x7f5e3c22bf49
Feb 05 19:00:26 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3ef5 ]---
Feb 05 19:00:26 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:26 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:26 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:27 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:27 linux-sclt.site mount[1262]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:27 linux-sclt.site mount[1262]: missing codepage or
helper program, or other error
Feb 05 19:00:27 linux-sclt.site mount[1262]: In some cases useful info
is found in syslog - try
Feb 05 19:00:27 linux-sclt.site mount[1262]: dmesg | tail or so
Feb 05 19:00:27 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:27 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:27 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:27 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:27 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649888 /dev/sda5
Feb 05 19:00:27 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:27 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:27 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:27 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:28 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:28 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:28 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:28 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:28 linux-sclt.site kernel: Pid: 1285, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:28 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:28 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:28 linux-sclt.site kernel:  [<00007ffbe7205f4a>] 0x7ffbe7205f49
Feb 05 19:00:28 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3ef6 ]---
Feb 05 19:00:28 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:28 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:28 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:29 linux-sclt.site mount[1285]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:29 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:29 linux-sclt.site mount[1285]: missing codepage or
helper program, or other error
Feb 05 19:00:29 linux-sclt.site mount[1285]: In some cases useful info
is found in syslog - try
Feb 05 19:00:29 linux-sclt.site mount[1285]: dmesg | tail or so
Feb 05 19:00:29 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:29 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:29 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:29 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:30 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649890 /dev/sda5
Feb 05 19:00:30 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:30 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:30 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:30 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:30 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:30 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:30 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:30 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:30 linux-sclt.site kernel: Pid: 1302, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:30 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:30 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:30 linux-sclt.site kernel:  [<00007f19cd527f4a>] 0x7f19cd527f49
Feb 05 19:00:30 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3ef7 ]---
Feb 05 19:00:30 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:30 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:30 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:32 linux-sclt.site mount[1302]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:32 linux-sclt.site mount[1302]: missing codepage or
helper program, or other error
Feb 05 19:00:32 linux-sclt.site mount[1302]: In some cases useful info
is found in syslog - try
Feb 05 19:00:32 linux-sclt.site mount[1302]: dmesg | tail or so
Feb 05 19:00:32 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:32 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:32 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:32 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:32 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:32 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649892 /dev/sda5
Feb 05 19:00:32 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:32 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:32 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:32 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:32 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:32 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:32 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:32 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:32 linux-sclt.site kernel: Pid: 1319, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:32 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:32 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:32 linux-sclt.site kernel:  [<00007f9e7463df4a>] 0x7f9e7463df49
Feb 05 19:00:32 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3ef8 ]---
Feb 05 19:00:32 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:32 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:32 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:34 linux-sclt.site mount[1319]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:34 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:34 linux-sclt.site mount[1319]: missing codepage or
helper program, or other error
Feb 05 19:00:34 linux-sclt.site mount[1319]: In some cases useful info
is found in syslog - try
Feb 05 19:00:34 linux-sclt.site mount[1319]: dmesg | tail or so
Feb 05 19:00:34 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:34 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:34 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:34 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:34 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649894 /dev/sda5
Feb 05 19:00:34 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:34 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:34 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:34 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:34 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:34 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:34 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:34 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:34 linux-sclt.site kernel: Pid: 1336, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:34 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:34 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:34 linux-sclt.site kernel:  [<00007f5505540f4a>] 0x7f5505540f49
Feb 05 19:00:34 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3ef9 ]---
Feb 05 19:00:34 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:34 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:34 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:36 linux-sclt.site mount[1336]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:36 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:36 linux-sclt.site mount[1336]: missing codepage or
helper program, or other error
Feb 05 19:00:36 linux-sclt.site mount[1336]: In some cases useful info
is found in syslog - try
Feb 05 19:00:36 linux-sclt.site mount[1336]: dmesg | tail or so
Feb 05 19:00:36 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:36 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:36 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:36 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:36 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649896 /dev/sda5
Feb 05 19:00:36 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:36 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:36 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:36 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:37 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:37 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:37 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:37 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:37 linux-sclt.site kernel: Pid: 1353, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:37 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:37 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:37 linux-sclt.site kernel:  [<00007fcbb387bf4a>] 0x7fcbb387bf49
Feb 05 19:00:37 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3efa ]---
Feb 05 19:00:37 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:37 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:37 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:38 linux-sclt.site mount[1353]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:38 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:38 linux-sclt.site mount[1353]: missing codepage or
helper program, or other error
Feb 05 19:00:38 linux-sclt.site mount[1353]: In some cases useful info
is found in syslog - try
Feb 05 19:00:38 linux-sclt.site mount[1353]: dmesg | tail or so
Feb 05 19:00:38 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:38 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:38 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:38 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:38 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649898 /dev/sda5
Feb 05 19:00:38 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:38 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:38 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:38 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:38 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:38 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:38 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:38 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:38 linux-sclt.site kernel: Pid: 1379, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:38 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:38 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:38 linux-sclt.site kernel:  [<00007fdf9267ef4a>] 0x7fdf9267ef49
Feb 05 19:00:38 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3efb ]---
Feb 05 19:00:38 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:38 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:38 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:40 linux-sclt.site mount[1379]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:40 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:40 linux-sclt.site mount[1379]: missing codepage or
helper program, or other error
Feb 05 19:00:40 linux-sclt.site mount[1379]: In some cases useful info
is found in syslog - try
Feb 05 19:00:40 linux-sclt.site mount[1379]: dmesg | tail or so
Feb 05 19:00:40 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:40 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:40 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:40 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:40 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649900 /dev/sda5
Feb 05 19:00:40 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:40 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:40 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:40 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:40 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:40 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:40 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:40 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:40 linux-sclt.site kernel: Pid: 1396, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:40 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:40 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:40 linux-sclt.site kernel:  [<00007f8d4f36cf4a>] 0x7f8d4f36cf49
Feb 05 19:00:40 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3efc ]---
Feb 05 19:00:40 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:40 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:40 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:42 linux-sclt.site mount[1396]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:42 linux-sclt.site mount[1396]: missing codepage or
helper program, or other error
Feb 05 19:00:42 linux-sclt.site mount[1396]: In some cases useful info
is found in syslog - try
Feb 05 19:00:42 linux-sclt.site mount[1396]: dmesg | tail or so
Feb 05 19:00:42 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:42 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:42 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:42 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:42 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:42 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649902 /dev/sda5
Feb 05 19:00:42 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:42 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:42 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:42 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:43 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:43 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:43 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:43 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:43 linux-sclt.site kernel: Pid: 1413, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:43 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:43 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:43 linux-sclt.site kernel:  [<00007f39934fcf4a>] 0x7f39934fcf49
Feb 05 19:00:43 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3efd ]---
Feb 05 19:00:43 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:43 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:43 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:44 linux-sclt.site mount[1413]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:44 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:44 linux-sclt.site mount[1413]: missing codepage or
helper program, or other error
Feb 05 19:00:44 linux-sclt.site mount[1413]: In some cases useful info
is found in syslog - try
Feb 05 19:00:44 linux-sclt.site mount[1413]: dmesg | tail or so
Feb 05 19:00:44 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:44 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:44 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:44 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:44 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649904 /dev/sda5
Feb 05 19:00:44 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:44 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:44 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:44 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:44 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:44 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:44 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:44 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:44 linux-sclt.site kernel: Pid: 1430, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:44 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:44 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:44 linux-sclt.site kernel:  [<00007feb7933cf4a>] 0x7feb7933cf49
Feb 05 19:00:44 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3efe ]---
Feb 05 19:00:44 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:44 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:44 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:47 linux-sclt.site mount[1430]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:47 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:47 linux-sclt.site mount[1430]: missing codepage or
helper program, or other error
Feb 05 19:00:47 linux-sclt.site mount[1430]: In some cases useful info
is found in syslog - try
Feb 05 19:00:47 linux-sclt.site mount[1430]: dmesg | tail or so
Feb 05 19:00:47 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:47 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:47 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:47 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:47 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649906 /dev/sda5
Feb 05 19:00:47 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:47 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:47 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:47 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:47 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:47 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:47 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:47 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:47 linux-sclt.site kernel: Pid: 1460, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:47 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:47 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:47 linux-sclt.site kernel:  [<00007fa9461a9f4a>] 0x7fa9461a9f49
Feb 05 19:00:47 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3eff ]---
Feb 05 19:00:47 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:47 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:47 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:49 linux-sclt.site mount[1460]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:49 linux-sclt.site mount[1460]: missing codepage or
helper program, or other error
Feb 05 19:00:49 linux-sclt.site mount[1460]: In some cases useful info
is found in syslog - try
Feb 05 19:00:49 linux-sclt.site mount[1460]: dmesg | tail or so
Feb 05 19:00:49 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:49 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:49 linux-sclt.site kdm[1458]: :0[1458]: Cannot update
authorization file in home dir /home/marguerite
Feb 05 19:00:49 linux-sclt.site kdm[743]: :0[743]:
pam_unix(xdm-np:session): session closed for user marguerite
Feb 05 19:00:49 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:49 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:49 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:49 linux-sclt.site NetworkManager[496]: <info> (wlan0):
device state change: activated -> disconnected (reason
'connection-removed') [100 30 38]
Feb 05 19:00:49 linux-sclt.site NetworkManager[496]: <info> (wlan0):
deactivating device (reason 'connection-removed') [38]
Feb 05 19:00:49 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649908 /dev/sda5
Feb 05 19:00:49 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:49 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:49 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:49 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:49 linux-sclt.site NetworkManager[496]: <info> (wlan0):
canceled DHCP transaction, DHCP client pid 770
Feb 05 19:00:49 linux-sclt.site avahi-daemon[478]: Withdrawing address
record for 192.168.1.106 on wlan0.
Feb 05 19:00:49 linux-sclt.site avahi-daemon[478]: Leaving mDNS
multicast group on interface wlan0.IPv4 with address 192.168.1.106.
Feb 05 19:00:49 linux-sclt.site avahi-daemon[478]: Interface
wlan0.IPv4 no longer relevant for mDNS.
Feb 05 19:00:49 linux-sclt.site kernel: wlan0: deauthenticating from
00:e5:41:3a:ed:e3 by local choice (reason=3)
Feb 05 19:00:49 linux-sclt.site NetworkManager[496]: <info> Clearing
nscd hosts cache.
Feb 05 19:00:49 linux-sclt.site kernel: cfg80211: Calling CRDA to
update world regulatory domain
Feb 05 19:00:49 linux-sclt.site kernel: cfg80211: World regulatory
domain updated:
Feb 05 19:00:49 linux-sclt.site kernel: cfg80211:   (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 05 19:00:49 linux-sclt.site kernel: cfg80211:   (2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 05 19:00:49 linux-sclt.site kernel: cfg80211:   (2457000 KHz -
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 05 19:00:49 linux-sclt.site kernel: cfg80211:   (2474000 KHz -
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 05 19:00:49 linux-sclt.site kernel: cfg80211:   (5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 05 19:00:49 linux-sclt.site kernel: cfg80211:   (5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 05 19:00:49 linux-sclt.site NetworkManager[496]: sent
invalidate(hosts) request, exiting
Feb 05 19:00:49 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Activating service name='org.freedesktop.nm_dispatcher' (using
servicehelper)
Feb 05 19:00:49 linux-sclt.site dbus[486]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Feb 05 19:00:49 linux-sclt.site NetworkManager[496]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Feb 05 19:00:49 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Successfully activated service 'org.freedesktop.nm_dispatcher'
Feb 05 19:00:49 linux-sclt.site dbus[486]: [system] Successfully
activated service 'org.freedesktop.nm_dispatcher'
Feb 05 19:00:49 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:49 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:49 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:49 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:49 linux-sclt.site kernel: Pid: 1480, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:49 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:49 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:49 linux-sclt.site kernel:  [<00007f60144b6f4a>] 0x7f60144b6f49
Feb 05 19:00:49 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3f00 ]---
Feb 05 19:00:49 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:49 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:49 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:50 linux-sclt.site mount[1480]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:50 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:50 linux-sclt.site mount[1480]: missing codepage or
helper program, or other error
Feb 05 19:00:50 linux-sclt.site mount[1480]: In some cases useful info
is found in syslog - try
Feb 05 19:00:50 linux-sclt.site mount[1480]: dmesg | tail or so
Feb 05 19:00:50 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:50 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:50 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:50 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:50 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649910 /dev/sda5
Feb 05 19:00:50 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:50 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:50 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:50 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:51 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:51 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:51 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:51 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:51 linux-sclt.site kernel: Pid: 1633, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:51 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:51 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:51 linux-sclt.site kernel:  [<00007f61d8bedf4a>] 0x7f61d8bedf49
Feb 05 19:00:51 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3f01 ]---
Feb 05 19:00:51 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:51 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:51 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:52 linux-sclt.site mount[1633]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:52 linux-sclt.site mount[1633]: missing codepage or
helper program, or other error
Feb 05 19:00:52 linux-sclt.site mount[1633]: In some cases useful info
is found in syslog - try
Feb 05 19:00:52 linux-sclt.site mount[1633]: dmesg | tail or so
Feb 05 19:00:52 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:52 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:52 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:52 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:52 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:52 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649912 /dev/sda5
Feb 05 19:00:52 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:52 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:52 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:52 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:52 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:52 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:52 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:52 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:52 linux-sclt.site kernel: Pid: 1651, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:52 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:52 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:52 linux-sclt.site kernel:  [<00007fdf0c995f4a>] 0x7fdf0c995f49
Feb 05 19:00:52 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3f02 ]---
Feb 05 19:00:52 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:52 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:52 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:54 linux-sclt.site mount[1651]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:54 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:54 linux-sclt.site mount[1651]: missing codepage or
helper program, or other error
Feb 05 19:00:54 linux-sclt.site mount[1651]: In some cases useful info
is found in syslog - try
Feb 05 19:00:54 linux-sclt.site mount[1651]: dmesg | tail or so
Feb 05 19:00:54 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:54 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:54 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:54 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:54 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649914 /dev/sda5
Feb 05 19:00:54 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:54 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:54 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:54 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:55 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:55 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:55 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:55 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:55 linux-sclt.site kernel: Pid: 1669, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:55 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:55 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:55 linux-sclt.site kernel:  [<00007ffaf71d2f4a>] 0x7ffaf71d2f49
Feb 05 19:00:55 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3f03 ]---
Feb 05 19:00:55 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:55 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:55 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:55 linux-sclt.site mount[1669]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:55 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:55 linux-sclt.site mount[1669]: missing codepage or
helper program, or other error
Feb 05 19:00:55 linux-sclt.site mount[1669]: In some cases useful info
is found in syslog - try
Feb 05 19:00:55 linux-sclt.site mount[1669]: dmesg | tail or so
Feb 05 19:00:55 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:55 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:55 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:55 linux-sclt.site systemd[1]: Mounting /home...
Feb 05 19:00:55 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649916 /dev/sda5
Feb 05 19:00:55 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:00:55 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:00:55 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:00:55 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:00:56 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:00:56 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:00:56 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:00:56 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:00:56 linux-sclt.site kernel: Pid: 1686, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:00:56 linux-sclt.site kernel: Call Trace:
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:00:56 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:00:56 linux-sclt.site kernel:  [<00007fb6bf2aff4a>] 0x7fb6bf2aff49
Feb 05 19:00:56 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3f04 ]---
Feb 05 19:00:56 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:00:56 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:00:56 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:00:57 linux-sclt.site mount[1686]: mount: wrong fs type, bad
option, bad superblock on /dev/sda5,
Feb 05 19:00:57 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:00:57 linux-sclt.site mount[1686]: missing codepage or
helper program, or other error
Feb 05 19:00:57 linux-sclt.site mount[1686]: In some cases useful info
is found in syslog - try
Feb 05 19:00:57 linux-sclt.site mount[1686]: dmesg | tail or so
Feb 05 19:00:57 linux-sclt.site systemd[1]: home.mount mount process
exited, code=exited status=32
Feb 05 19:00:57 linux-sclt.site systemd[1]: Failed to mount /home.
Feb 05 19:00:57 linux-sclt.site systemd[1]: Unit home.mount entered failed state
Feb 05 19:00:58 linux-sclt.site systemd-logind[483]: Removed session 1.
Feb 05 19:01:04 linux-sclt.site kdm[1713]: :0[1713]:
pam_unix(xdm:session): session opened for user root by (uid=0)
Feb 05 19:01:04 linux-sclt.site systemd-logind[483]: New session 3 of user root.
Feb 05 19:01:04 linux-sclt.site systemd-logind[483]: Linked
/tmp/.X11-unix/X0 to /run/user/0/X11-display.
Feb 05 19:01:04 linux-sclt.site checkproc[1792]: checkproc: can not
get session id for process 1874!
Feb 05 19:01:10 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Activating via systemd: service name='org.freedesktop.UPower'
unit='upower.service'
Feb 05 19:01:10 linux-sclt.site dbus[486]: [system] Activating via
systemd: service name='org.freedesktop.UPower' unit='upower.service'
Feb 05 19:01:10 linux-sclt.site systemd[1]: Starting Daemon for power
management...
Feb 05 19:01:10 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Successfully activated service 'org.freedesktop.UPower'
Feb 05 19:01:10 linux-sclt.site dbus[486]: [system] Successfully
activated service 'org.freedesktop.UPower'
Feb 05 19:01:10 linux-sclt.site systemd[1]: Started Daemon for power management.
Feb 05 19:01:11 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Activating via systemd: service name='org.freedesktop.UDisks2'
unit='udisks2.service'
Feb 05 19:01:11 linux-sclt.site dbus[486]: [system] Activating via
systemd: service name='org.freedesktop.UDisks2' unit='udisks2.service'
Feb 05 19:01:11 linux-sclt.site systemd[1]: Starting Disk Manager...
Feb 05 19:01:11 linux-sclt.site udisksd[1883]: udisks daemon version
2.0.0 starting
Feb 05 19:01:11 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Successfully activated service 'org.freedesktop.UDisks2'
Feb 05 19:01:11 linux-sclt.site dbus[486]: [system] Successfully
activated service 'org.freedesktop.UDisks2'
Feb 05 19:01:11 linux-sclt.site systemd[1]: Started Disk Manager.
Feb 05 19:01:11 linux-sclt.site udisksd[1883]: Acquired the name
org.freedesktop.UDisks2 on the system message bus
Feb 05 19:01:11 linux-sclt.site kernel: EXT4-fs (sda2): re-mounted.
Opts: acl,user_xattr,commit=0
Feb 05 19:01:21 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Activating via systemd: service name='org.bluez'
unit='dbus-org.bluez.service'
Feb 05 19:01:21 linux-sclt.site dbus[486]: [system] Activating via
systemd: service name='org.bluez' unit='dbus-org.bluez.service'
Feb 05 19:01:21 linux-sclt.site dbus[486]: [system] Activation via
systemd failed for unit 'dbus-org.bluez.service': Unit
dbus-org.bluez.service failed to load: No such file or directory. See
system logs and 'systemctl status dbus-org.bluez.service' for details.
Feb 05 19:01:21 linux-sclt.site pulseaudio[1985]: [pulseaudio]
bluetooth-util.c: org.bluez.Manager.ListAdapters() failed:
org.freedesktop.systemd1.LoadFailed: Unit dbus-org.bluez.service
failed to load: No such file or directory. See system logs and
'systemctl status dbus-org.bluez.service' for details.
Feb 05 19:01:22 linux-sclt.site polkitd[534]: Registered
Authentication Agent for unix-session:3 (system bus name :1.32
[/usr/lib64/kde4/libexec/polkit-kde-authentication-agent-1], object
path /org/kde/PolicyKit1/AuthenticationAgent, locale POSIX)
Feb 05 19:01:22 linux-sclt.site pulseaudio[2003]: [pulseaudio] pid.c:
Daemon already running.
Feb 05 19:01:25 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Activation via systemd failed for unit 'dbus-org.bluez.service': Unit
dbus-org.bluez.service failed to load: No such file or directory. See
system logs and 'systemctl status dbus-org.bluez.service' for details.
Feb 05 19:05:57 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649918 /dev/sda5
Feb 05 19:05:57 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:05:58 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:05:58 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:05:58 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:05:58 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:05:58 linux-sclt.site kernel: Pid: 2095, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:05:58 linux-sclt.site kernel: Call Trace:
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffffa0095b17>]
open_ctree+0x18b7/0x1be0 [btrfs]
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffffa006df57>]
btrfs_mount+0x567/0x640 [btrfs]
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff81172cc5>]
mount_fs+0x45/0x1d0
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff8118c523>]
vfs_kern_mount+0x73/0x120
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff8118cea3>]
do_kern_mount+0x53/0x110
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff8118ea44>]
do_mount+0x334/0x900
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:05:58 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:05:58 linux-sclt.site kernel:  [<00007ff7b3b67f4a>] 0x7ff7b3b67f49
Feb 05 19:05:58 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3f05 ]---
Feb 05 19:05:58 linux-sclt.site kernel: BTRFS: inode 295 still on the
orphan list
Feb 05 19:05:58 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:05:58 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:06:00 linux-sclt.site kernel: btrfs: open_ctree failed
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) starting connection 'NETGEAR'
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0/wireless): connection 'NETGEAR' requires no security.  No
secrets needed.
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Config:
added 'ssid' value 'NETGEAR'
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Config:
added 'scan_ssid' value '1'
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Config:
added 'key_mgmt' value 'NONE'
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> Config:
set interface ap_scan to 1
Feb 05 19:06:46 linux-sclt.site NetworkManager[496]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Feb 05 19:06:48 linux-sclt.site kernel: wlan0: authenticate with
00:e5:41:3a:ed:e3
Feb 05 19:06:48 linux-sclt.site kernel: wlan0: send auth to
00:e5:41:3a:ed:e3 (try 1/3)
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Feb 05 19:06:48 linux-sclt.site kernel: wlan0: authenticated
Feb 05 19:06:48 linux-sclt.site kernel: iwl3945 0000:03:00.0 wlan0:
disabling HT as WMM/QoS is not supported by the AP
Feb 05 19:06:48 linux-sclt.site kernel: iwl3945 0000:03:00.0 wlan0:
disabling VHT as WMM/QoS is not supported by the AP
Feb 05 19:06:48 linux-sclt.site kernel: wlan0: associate with
00:e5:41:3a:ed:e3 (try 1/3)
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Feb 05 19:06:48 linux-sclt.site kernel: wlan0: RX AssocResp from
00:e5:41:3a:ed:e3 (capab=0x401 status=0 aid=2)
Feb 05 19:06:48 linux-sclt.site kernel: wlan0: associated
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> (wlan0):
supplicant interface state: associating -> completed
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'NETGEAR'.
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> dhclient
started with pid 2196
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Feb 05 19:06:48 linux-sclt.site dhclient[2196]: Internet Systems
Consortium DHCP Client 4.2.5
Feb 05 19:06:48 linux-sclt.site dhclient[2196]: Copyright 2004-2013
Internet Systems Consortium.
Feb 05 19:06:48 linux-sclt.site dhclient[2196]: All rights reserved.
Feb 05 19:06:48 linux-sclt.site dhclient[2196]: For info, please visit
https://www.isc.org/software/dhcp/
Feb 05 19:06:48 linux-sclt.site dhclient[2196]:
Feb 05 19:06:48 linux-sclt.site NetworkManager[496]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Feb 05 19:06:48 linux-sclt.site dhclient[2196]: Listening on
LPF/wlan0/00:1b:77:c4:51:c7
Feb 05 19:06:48 linux-sclt.site dhclient[2196]: Sending on
LPF/wlan0/00:1b:77:c4:51:c7
Feb 05 19:06:48 linux-sclt.site dhclient[2196]: Sending on   Socket/fallback
Feb 05 19:06:48 linux-sclt.site dhclient[2196]: DHCPREQUEST on wlan0
to 255.255.255.255 port 67
Feb 05 19:06:49 linux-sclt.site dhclient[2196]: DHCPACK from 192.168.1.1
Feb 05 19:06:49 linux-sclt.site dhclient[2196]: bound to 192.168.1.106
-- renewal in 42880 seconds.
Feb 05 19:06:49 linux-sclt.site NetworkManager[496]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Feb 05 19:06:49 linux-sclt.site NetworkManager[496]: <info>   address
192.168.1.106
Feb 05 19:06:49 linux-sclt.site NetworkManager[496]: <info>   prefix
24 (255.255.255.0)
Feb 05 19:06:49 linux-sclt.site NetworkManager[496]: <info>   gateway
192.168.1.1
Feb 05 19:06:49 linux-sclt.site NetworkManager[496]: <info>   hostname
'linux-sclt'
Feb 05 19:06:49 linux-sclt.site NetworkManager[496]: <info>
nameserver '192.168.1.1'
Feb 05 19:06:49 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Feb 05 19:06:49 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Feb 05 19:06:49 linux-sclt.site avahi-daemon[478]: Joining mDNS
multicast group on interface wlan0.IPv4 with address 192.168.1.106.
Feb 05 19:06:49 linux-sclt.site avahi-daemon[478]: New relevant
interface wlan0.IPv4 for mDNS.
Feb 05 19:06:49 linux-sclt.site avahi-daemon[478]: Registering new
address record for 192.168.1.106 on wlan0.IPv4.
Feb 05 19:06:50 linux-sclt.site NetworkManager[496]: <info> (wlan0):
device state change: ip-config -> activated (reason 'none') [70 100 0]
Feb 05 19:06:50 linux-sclt.site NetworkManager[496]: <info> Clearing
nscd hosts cache.
Feb 05 19:06:50 linux-sclt.site NetworkManager[496]: sent
invalidate(hosts) request, exiting
Feb 05 19:06:50 linux-sclt.site NetworkManager[496]: <info> Policy set
'NETGEAR' (wlan0) as default for IPv4 routing and DNS.
Feb 05 19:06:50 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) successful, device activated.
Feb 05 19:06:50 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Activating service name='org.freedesktop.nm_dispatcher' (using
servicehelper)
Feb 05 19:06:50 linux-sclt.site dbus[486]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Feb 05 19:06:50 linux-sclt.site NetworkManager[496]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Feb 05 19:06:50 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Successfully activated service 'org.freedesktop.nm_dispatcher'
Feb 05 19:06:50 linux-sclt.site dbus[486]: [system] Successfully
activated service 'org.freedesktop.nm_dispatcher'
Feb 05 19:06:50 linux-sclt.site if-up.d/21-dhcpcd-hook-samba[2276]: No
dhcpcd info nor dhclient leases file found for wlan0.
Feb 05 19:06:50 linux-sclt.site nm-dispatcher.action[2207]: Script
'/etc/NetworkManager/dispatcher.d/nfs' exited with error status 2.
Feb 05 19:07:19 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Activating service name='org.freedesktop.PackageKit' (using
servicehelper)
Feb 05 19:07:19 linux-sclt.site dbus[486]: [system] Activating service
name='org.freedesktop.PackageKit' (using servicehelper)
Feb 05 19:07:20 linux-sclt.site dbus-daemon[486]: dbus[486]: [system]
Successfully activated service 'org.freedesktop.PackageKit'
Feb 05 19:07:20 linux-sclt.site dbus[486]: [system] Successfully
activated service 'org.freedesktop.PackageKit'
Feb 05 19:07:55 linux-sclt.site kernel: device fsid
559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid 1 transid 649920 /dev/sda5
Feb 05 19:07:55 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:07:55 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:07:55 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:07:55 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:08:03 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:08:03 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:08:03 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:08:03 linux-sclt.site kernel: btrfs: disk space caching is enabled
Feb 05 19:08:03 linux-sclt.site kernel: ------------[ cut here ]------------
Feb 05 19:08:03 linux-sclt.site kernel: WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.1/linux-3.7/fs/btrfs/inode.c:2427
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]()
Feb 05 19:08:03 linux-sclt.site kernel: Hardware name: 8889CG1
Feb 05 19:08:03 linux-sclt.site kernel: Modules linked in: af_packet
cpufreq_conservative cpufreq_userspace cpufreq_powersave fuse
snd_hda_codec_analog snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device iTCO_wdt
acpi_cpufreq iTCO_vendor_support mperf coretemp arc4 snd pcmcia btusb
kvm_intel lpc_ich mfd_core pcspkr kvm nvidia(PO) sr_mod i2c_i801
joydev iwl3945 yenta_socket iwlegacy pcmcia_rsrc sg wmi pcmcia_core
cdrom mac80211 snd_page_alloc bluetooth cfg80211 soundcore e1000e
video ac rfkill microcode battery button autofs4 btrfs zlib_deflate
libcrc32c thermal processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_acpi ata_piix
Feb 05 19:08:03 linux-sclt.site kernel: Pid: 2544, comm: mount
Tainted: P        W  O 3.7.1-1-desktop #1
Feb 05 19:08:03 linux-sclt.site kernel: Call Trace:
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffff81004818>]
dump_trace+0x88/0x300
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffff8158a54c>]
dump_stack+0x69/0x6f
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffff81045269>]
warn_slowpath_common+0x79/0xc0
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffffa00a33fc>]
btrfs_orphan_cleanup+0xac/0x3f0 [btrfs]
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffffa0092858>]
btrfs_cleanup_fs_roots+0x68/0x90 [btrfs]
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffffa006ec2a>]
btrfs_remount+0x19a/0x250 [btrfs]
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffff8117101f>]
__do_remount_sb+0x7f/0x1c0
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffff8118ecc3>]
do_mount+0x5b3/0x900
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffff8118f0a8>]
sys_mount+0x98/0xf0
Feb 05 19:08:03 linux-sclt.site kernel:  [<ffffffff8159e12d>]
system_call_fastpath+0x1a/0x1f
Feb 05 19:08:03 linux-sclt.site kernel:  [<00007f369234ff4a>] 0x7f369234ff49
Feb 05 19:08:03 linux-sclt.site kernel: ---[ end trace 224f363d8b5f3f06 ]---
Feb 05 19:08:03 linux-sclt.site kernel: btrfs: Error removing orphan
entry, stopping orphan cleanup
Feb 05 19:08:03 linux-sclt.site kernel: btrfs: could not do orphan cleanup -22
Feb 05 19:08:12 linux-sclt.site kernel: btrfs: use lzo compression
Feb 05 19:08:12 linux-sclt.site kernel: btrfs: enabling auto defrag
Feb 05 19:08:12 linux-sclt.site kernel: btrfs: enabling inode map caching
Feb 05 19:08:12 linux-sclt.site kernel: btrfs: disk space caching is enabled

Thanks and have a nice day

Marguerite
