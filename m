Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wp261.webpack.hosteurope.de ([80.237.133.30]:55761 "EHLO
	wp261.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933442Ab2HXUze (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 16:55:34 -0400
Message-ID: <5037E470.9070508@harwarth.de>
Date: Fri, 24 Aug 2012 22:30:40 +0200
From: Stefan Harwarth <mailingliste@harwarth.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Unable to mount/restore partition after eSATA fail
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs people,

I've been using btrfs for 2 months or so. After an incident where 
apparently my eSATA connection got lost (according to syslog, see end of 
mail), the partition cannot be mounted anymore. Even worse, all btrfs 
tools report there is no btrfs filesystem on the partition (and 
parted/gdisk/... all show no filesystem indication at all for the 
partition). I have included the syslog excerpts from when the error 
happened and the syslog when I first retried to mount the volume.

I took a look at the raw data in the partition (dd if=/dev/sdb1 ...) and 
- which is not a good sign, I guess - the first non-null Bytes are 
around 6,4 MB from the start of the partition, and they do not look like 
file system information but more like a windows ISO which was stored on 
the drive. The HDD does not report any damages in the SMART-report.

Is there any chance to get the data back from the drive? It won't kill 
me if it's lost, but recovery would save me a hell lot of work.

Thanks in advance,

Stefan

First syslog when the error occured:

Aug  9 05:30:26 debian kernel: [23735.292560] sda: detected capacity 
change from 2000398934016 to 0
Aug  9 05:31:50 debian kernel: [23819.504883] lost page write due to I/O 
error on sda1
Aug  9 05:31:50 debian kernel: [23819.504944] lost page write due to I/O 
error on sda1
Aug  9 05:31:50 debian kernel: [23819.505007] end_request: I/O error, 
dev sda, sector 536872960
Aug  9 05:31:50 debian kernel: [23819.505049] lost page write due to I/O 
error on sda1
Aug  9 05:31:50 debian kernel: [23819.505058] btrfs: 1 errors while 
writing supers
Aug  9 05:31:50 debian kernel: [23819.505128] ------------[ cut here 
]------------
Aug  9 05:31:50 debian kernel: [23819.505164] kernel BUG at 
/build/buildd-linux-2.6_2.6.32-45-i386-yQfQSv/linux-2.6-2.6.32/debian/build/source_i386_none/fs/btrfs/disk-io.c:2302!
Aug  9 05:31:50 debian kernel: [23819.505243] invalid opcode: 0000 [#1] SMP
Aug  9 05:31:50 debian kernel: [23819.505281] last sysfs file: 
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/energy_full
Aug  9 05:31:50 debian kernel: [23819.505356] Modules linked in: btrfs 
zlib_deflate crc32c libcrc32c loop joydev i915 drm_kms_helper pcmcia 
thinkpad_acpi rfkill drm parport_pc snd_intel8x0 snd_ac97_codec ac97_bus 
led_class yenta_socket i2c_algo_bit snd_pcm i2c_i801 parport 
rsrc_nonstatic psmouse serio_raw snd_timer video pcmcia_core nvram 
pcspkr i2c_core output evdev snd rng_core soundcore battery ac processor 
button snd_page_alloc ext3 jbd mbcache ata_generic sd_mod crc_t10dif 
ata_piix uhci_hcd ahci sata_sil24 tg3 thermal ehci_hcd usbcore libata 
scsi_mod libphy thermal_sys nls_base [last unloaded: scsi_wait_scan]
Aug  9 05:31:50 debian kernel: [23819.505772]
Aug  9 05:31:50 debian kernel: [23819.505803] Pid: 775, comm: 
btrfs-transacti Not tainted (2.6.32-5-686 #1) 18714AG
Aug  9 05:31:50 debian kernel: [23819.505865] EIP: 0060:[<f8a27a8d>] 
EFLAGS: 00010282 CPU: 0
Aug  9 05:31:50 debian kernel: [23819.505935] EIP is at 
write_all_supers+0x20f/0x21f [btrfs]
Aug  9 05:31:50 debian kernel: [23819.505973] EAX: 0000003a EBX: 
f6f47658 ECX: f6773f18 EDX: f8a5e117
Aug  9 05:31:50 debian kernel: [23819.506014] ESI: 00000001 EDI: 
00000003 EBP: f6d22000 ESP: f6773f14
Aug  9 05:31:50 debian kernel: [23819.506054]  DS: 007b ES: 007b FS: 
00d8 GS: 00e0 SS: 0068
Aug  9 05:31:50 debian kernel: [23819.506095] Process btrfs-transacti 
(pid: 775, ti=f6772000 task=f6495980 task.ti=f6772000)
Aug  9 05:31:50 debian kernel: [23819.506157] Stack:
Aug  9 05:31:50 debian kernel: [23819.506184]  f8a5e117 00000001 
00000000 f66bd800 f6f47658 f6d22c2f 00000001 00000000
Aug  9 05:31:50 debian kernel: [23819.506239] <0> 00000000 f6d22d3a 
f6d22d4a f6f47600 f6991030 f6d22c2f f6d2375a f66bd800
Aug  9 05:31:50 debian kernel: [23819.506316] <0> f8a2a868 f6991030 
f6b2d04c 00000003 00000000 00000000 f6b2d064 f6b2d000
Aug  9 05:31:50 debian kernel: [23819.506412] Call Trace:
Aug  9 05:31:50 debian kernel: [23819.506473]  [<f8a2a868>] ? 
btrfs_commit_transaction+0x4c0/0x5a1 [btrfs]
Aug  9 05:31:50 debian kernel: [23819.506523]  [<c104432e>] ? 
autoremove_wake_function+0x0/0x2d
Aug  9 05:31:50 debian kernel: [23819.506588]  [<f8a26805>] ? 
transaction_kthread+0x133/0x19e [btrfs]
Aug  9 05:31:50 debian kernel: [23819.506634]  [<c1024a6f>] ? 
complete+0x28/0x36
Aug  9 05:31:50 debian kernel: [23819.506696]  [<f8a266d2>] ? 
transaction_kthread+0x0/0x19e [btrfs]
Aug  9 05:31:50 debian kernel: [23819.506739]  [<c10440fc>] ? 
kthread+0x61/0x66
Aug  9 05:31:50 debian kernel: [23819.506777]  [<c104409b>] ? 
kthread+0x0/0x66
Aug  9 05:31:50 debian kernel: [23819.506816]  [<c1003d47>] ? 
kernel_thread_helper+0x7/0x10
Aug  9 05:31:50 debian kernel: [23819.506853] Code: 75 c4 8b 54 24 04 8b 
82 14 01 00 00 8b 80 b8 1c 00 00 83 c0 44 e8 3f 6b 84 c8 3b 74 24 14 7e 
11 56 68 17 e1 a5 f8 e8 18 5c 84 c8 <0f> 0b 58 5a eb fe 83 c4 28 31 c0 
5b 5e 5f 5d c3 89 d0 89 ca e9
Aug  9 05:31:50 debian kernel: [23819.507072] EIP: [<f8a27a8d>] 
write_all_supers+0x20f/0x21f [btrfs] SS:ESP 0068:f6773f14
Aug  9 05:31:50 debian kernel: [23819.507474] ---[ end trace 
31cd148f196f7433 ]---


Second syslog when I first tried to remount the drive:

Aug 13 23:59:00 debian kernel: [435848.980197] BUG: unable to handle 
kernel NULL pointer dereference at 0000001c
Aug 13 23:59:00 debian kernel: [435848.980269] IP: [<f8a21d84>] 
btrfs_print_leaf+0xe/0x765 [btrfs]
Aug 13 23:59:00 debian kernel: [435848.980341] *pde = 00000000
Aug 13 23:59:00 debian kernel: [435848.980374] Oops: 0000 [#2] SMP
Aug 13 23:59:00 debian kernel: [435848.980410] last sysfs file: 
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/energy_full
Aug 13 23:59:00 debian kernel: [435848.980486] Modules linked in: btrfs 
zlib_deflate crc32c libcrc32c loop joydev i915 drm_kms_helper pcmcia 
thinkpad_acpi rfkill drm parport_pc snd_intel8x0 snd_ac97_codec ac97_bus 
led_class yenta_socket i2c_algo_bit snd_pcm i2c_i801 parport 
rsrc_nonstatic psmouse serio_raw snd_timer video pcmcia_core nvram 
pcspkr i2c_core output evdev snd rng_core soundcore battery ac processor 
button snd_page_alloc ext3 jbd mbcache ata_generic sd_mod crc_t10dif 
ata_piix uhci_hcd ahci sata_sil24 tg3 thermal ehci_hcd usbcore libata 
scsi_mod libphy thermal_sys nls_base [last unloaded: scsi_wait_scan]
Aug 13 23:59:00 debian kernel: [435848.980901]
Aug 13 23:59:00 debian kernel: [435848.980931] Pid: 8795, comm: umount 
Tainted: G      D    (2.6.32-5-686 #1) 18714AG
Aug 13 23:59:00 debian kernel: [435848.980995] EIP: 0060:[<f8a21d84>] 
EFLAGS: 00010292 CPU: 0
Aug 13 23:59:00 debian kernel: [435848.981057] EIP is at 
btrfs_print_leaf+0xe/0x765 [btrfs]
Aug 13 23:59:00 debian kernel: [435848.981095] EAX: f66be800 EBX: 
f66be800 ECX: c1ba0140 EDX: 00000000
Aug 13 23:59:00 debian kernel: [435848.981135] ESI: 00000000 EDI: 
f69f4000 EBP: 00000000 ESP: f629fcdc
Aug 13 23:59:00 debian kernel: [435848.981176]  DS: 007b ES: 007b FS: 
00d8 GS: 00e0 SS: 0068
Aug 13 23:59:00 debian kernel: [435848.981216] Process umount (pid: 
8795, ti=f629e000 task=f60b9540 task.ti=f629e000)
Aug 13 23:59:00 debian kernel: [435848.981276] Stack:
Aug 13 23:59:00 debian kernel: [435848.981304]  00000000 00000000 
00000000 00000086 8777d000 f69f4000 f66be800 f6802c00
Aug 13 23:59:00 debian kernel: [435848.981359] <0> f28c0d40 b7766000 
c108c611 ffffffff 000000b0 0000000b 00000001 00000000
Aug 13 23:59:00 debian kernel: [435848.981436] <0> 868777d0 a8000000 
00001000 00000000 00000005 00000000 f69f4000 00000000
Aug 13 23:59:00 debian kernel: [435848.981532] Call Trace:
Aug 13 23:59:00 debian kernel: [435848.981572]  [<c108c611>] ? 
__alloc_pages_nodemask+0xf3/0x4d9
Aug 13 23:59:00 debian kernel: [435848.981636]  [<f8a1eb7d>] ? 
__btrfs_free_extent+0xe3/0x743 [btrfs]
Aug 13 23:59:00 debian kernel: [435848.981700]  [<f8a1ed9d>] ? 
__btrfs_free_extent+0x303/0x743 [btrfs]
Aug 13 23:59:00 debian kernel: [435848.981765]  [<f8a1f6a7>] ? 
run_one_delayed_ref+0x4ca/0x4df [btrfs]
Aug 13 23:59:00 debian kernel: [435848.981811]  [<c1001f10>] ? 
__switch_to+0xcf/0x141
Aug 13 23:59:00 debian kernel: [435848.981872]  [<f8a215e9>] ? 
run_clustered_refs+0x1f2/0x22d [btrfs]
Aug 13 23:59:00 debian kernel: [435848.981938]  [<f8a216d9>] ? 
btrfs_run_delayed_refs+0xb5/0x138 [btrfs]
Aug 13 23:59:00 debian kernel: [435848.982007]  [<f8a2a411>] ? 
btrfs_commit_transaction+0x69/0x5a1 [btrfs]
Aug 13 23:59:00 debian kernel: [435848.982077]  [<f8a2a118>] ? 
start_transaction+0x19/0x110 [btrfs]
Aug 13 23:59:00 debian kernel: [435848.983197]  [<c104432e>] ? 
autoremove_wake_function+0x0/0x2d
Aug 13 23:59:00 debian kernel: [435848.983241]  [<c10e4d02>] ? 
sync_quota_sb+0x3a/0xca
Aug 13 23:59:00 debian kernel: [435848.983282]  [<c10ccd78>] ? 
__sync_filesystem+0x3a/0x60
Aug 13 23:59:00 debian kernel: [435848.983325]  [<c10b5513>] ? 
generic_shutdown_super+0x19/0xc6
Aug 13 23:59:00 debian kernel: [435848.983367]  [<c10e3e16>] ? 
vfs_quota_off+0x0/0xd
Aug 13 23:59:00 debian kernel: [435848.983406]  [<c10b55f5>] ? 
kill_anon_super+0x9/0x3b
Aug 13 23:59:00 debian kernel: [435848.983446]  [<c10b5b77>] ? 
deactivate_super+0x4a/0x5f
Aug 13 23:59:00 debian kernel: [435848.983488]  [<c10c5b5b>] ? 
sys_umount+0x2a5/0x2cb
Aug 13 23:59:00 debian kernel: [435848.983528]  [<c10c5b8c>] ? 
sys_oldumount+0xb/0xe
Aug 13 23:59:00 debian kernel: [435848.983567]  [<c10030fb>] ? 
sysenter_do_call+0x12/0x28
Aug 13 23:59:00 debian kernel: [435848.983603] Code: 24 08 ff 74 24 18 
ff 74 24 18 52 50 68 03 d7 a5 f8 e8 36 b9 84 c8 83 c4 30 5b 5e 5f c3 55 
89 d5 57 56 53 89 c3 81 ec 88 00 00 00 <8b> 42 1c ba 03 00 00 00 e8 52 
db 5f c8 8b 50 60 89 54 24 20 ba
Aug 13 23:59:00 debian kernel: [435848.983823] EIP: [<f8a21d84>] 
btrfs_print_leaf+0xe/0x765 [btrfs] SS:ESP 0068:f629fcdc
Aug 13 23:59:00 debian kernel: [435848.983914] CR2: 000000000000001c
Aug 13 23:59:00 debian kernel: [435848.984328] ---[ end trace 
31cd148f196f7434 ]---

-- 
Stefan Harwarth
85051 Ingolstadt

