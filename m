From: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference
Date: Wed, 25 May 2011 13:46:21 +0200
Message-ID: <BANLkTikKAfPgutxW0Su0v0jZ1LnSA495hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have a Btrfs partition that cannot be mounted anymore, it makes
kernel to crash.
The partition was created a few months ago, with kernel 2.6.33 (with
no special options) if I remember well. Since then, with new kernel
releases, I enabled a few options : first space_cache, then compress,
and finally with 2.6.38 compress=lzo
So the filesystem has now space_cache, data compressed with zlib AND lzo.

With kernel 2.6.39-rc5 I had, a few weeks ago, a first crash where it
complained about no free space. Then I rebooted on kernel 2.6.38,
mounted the filesystem with the clear_cache option, and everything
went fine, even returning back on kernel 2.6.39-rc5.

But last week, while I was working (nothing special such as intensive
read or writes), the system crashed because of Btrfs.
Since then, I cannot mount my FS anymore.
Here are the dmesg logs I gathered, testing with 2.6.39-rc5, and just
to see if it made any difference, with the integration-test tree.

Any idea about what happened? How can I help you to diagnose that? Any
chance I could recover my data?

Thanks.

with 2.6.39-rc5 :
# mount -o clear_cache,compress=lzo /dev/sda2 /mnt/

[  676.767161] Btrfs loaded
[  676.774399] device fsid f24027efc24d32f7-2191b1da9df7d184 devid 1
transid 164511 /dev/sda2
[  676.775233] btrfs: force clearing of disk cache
[  676.775255] btrfs: use lzo compression
[  676.834811] btrfs: disk space caching is enabled
[  677.601773] BUG: unable to handle kernel NULL pointer dereference at   (null)
[  677.601800] IP: [<c022bbfb>] kmap_atomic_prot+0x1b/0xf0
[  677.601822] *pde = 00000000
[  677.601834] Oops: 0000 [#1] SMP
[  677.601846] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
[  677.601861] Modules linked in: btrfs zlib_deflate af_packet
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bnep edd
cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel btusb
snd_hda_codec bluetooth usb_storage snd_hwdep uas iTCO_wdt
iTCO_vendor_support snd_pcm rfkill r8187se(C) uvcvideo videodev
snd_timer media joydev wmi battery ac sg eeprom_93cx6 snd pcspkr
soundcore r8169 snd_page_alloc ext4 jbd2 crc16 usbhid hid sd_mod
ata_generic i915 ata_piix drm_kms_helper libata drm uhci_hcd scsi_mod
ehci_hcd i2c_algo_bit rtc_cmos rtc_core rtc_lib usbcore intel_agp
button video intel_gtt fan thermal processor thermal_sys hwmon
[  677.602034]
[  677.602046] Pid: 2401, comm: mount Tainted: G         C
2.6.39-rc5-0.3-default #6 LG Electronics X110-L.A741B/X110
[  677.602068] EIP: 0060:[<c022bbfb>] EFLAGS: 00210202 CPU: 1
[  677.602082] EIP is at kmap_atomic_prot+0x1b/0xf0
[  677.602094] EAX: 00000000 EBX: 000004ca ECX: d9fee000 EDX: 00000163
[  677.602107] ESI: 00000000 EDI: 000004ca EBP: d9fefb88 ESP: d9fefb78
[  677.602121]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  677.602134] Process mount (pid: 2401, ti=d9fee000 task=e61bf030
task.ti=d9fee000)
[  677.602147] Stack:
[  677.602156]  f64037c0 000004ca 00000000 000004ca d9fefb90 c022bcde
d9fefbbc f853bab8
[  677.602179]  00000000 c71c40f0 c68560a8 00000007 b7c09000 0000000e
00006572 c6850000
[  677.602202]  00000f58 d9fefc24 f854b727 00006572 00000000 00000000
00000000 00094689
[  677.602225] Call Trace:
[  677.602239]  [<c022bcde>] __kmap_atomic+0xe/0x10
[  677.602281]  [<f853bab8>] read_extent_buffer+0x88/0x140 [btrfs]
[  677.602322]  [<f854b727>] add_inode_ref+0x1e7/0x330 [btrfs]
[  677.602363]  [<f854ccde>] replay_one_buffer+0x21e/0x2e0 [btrfs]
[  677.602404]  [<f854a431>] walk_down_log_tree+0x1d1/0x360 [btrfs]
[  677.602445]  [<f854a636>] walk_log_tree+0x76/0x1e0 [btrfs]
[  677.602463]  [<c03e7a2a>] ? radix_tree_lookup+0xa/0x10
[  677.602503]  [<f854e8fe>] btrfs_recover_log_trees+0x1de/0x2b0 [btrfs]
[  677.602544]  [<f854cac0>] ? replay_one_extent+0x6a0/0x6a0 [btrfs]
[  677.602596]  [<f8513a8c>] open_ctree+0x10bc/0x1410 [btrfs]
[  677.602615]  [<c03e9ca9>] ? strlcpy+0x39/0x60
[  677.602646]  [<f84f45e1>] btrfs_mount+0x461/0x590 [btrfs]
[  677.602664]  [<c02e3400>] ? pcpu_alloc+0x310/0x850
[  677.602681]  [<c03098d5>] mount_fs+0x35/0x180
[  677.602698]  [<c031e9d6>] vfs_kern_mount+0x46/0xa0
[  677.602712]  [<c031f7c9>] do_kern_mount+0x39/0xd0
[  677.602726]  [<c0320f34>] do_mount+0x594/0x6c0
[  677.602741]  [<c02d13d6>] ? __get_free_pages+0x26/0x30
[  677.602755]  [<c0320879>] ? copy_mount_options+0x39/0x120
[  677.602770]  [<c0321386>] sys_mount+0x66/0xa0
[  677.602786]  [<c05d021c>] sysenter_do_call+0x12/0x28
[  677.602798] Code: 8b 15 cc 42 82 c0 55 89 e5 e8 52 f9 ff ff 5d c3
55 89 e5 83 ec 10 89 e1 81 e1 00 e0 ff ff 89 5d f4 89 75 f8 89 7d fc
83 41 14 01 <8b> 08 c1 e9 1e 69 c9 80 03 00 00 8d b1 80 db 78 c0 2b b1
cc de
[  677.602902] EIP: [<c022bbfb>] kmap_atomic_prot+0x1b/0xf0 SS:ESP 0068:d9fefb78
[  677.602920] CR2: 0000000000000000
[  677.604805] [drm] Changing LVDS panel from (+hsync, +vsync) to
(-hsync, -vsync)
[  677.854425] ---[ end trace b216833b014671c4 ]---
[  677.854452] note: mount[2401] exited with preempt_count 1
[  677.854731] BUG: scheduling while atomic: mount/2401/0x10000001
[  677.854753] Modules linked in: btrfs zlib_deflate af_packet
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bnep edd
cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel btusb
snd_hda_codec bluetooth usb_storage snd_hwdep uas iTCO_wdt
iTCO_vendor_support snd_pcm rfkill r8187se(C) uvcvideo videodev
snd_timer media joydev wmi battery ac sg eeprom_93cx6 snd pcspkr
soundcore r8169 snd_page_alloc ext4 jbd2 crc16 usbhid hid sd_mod
ata_generic i915 ata_piix drm_kms_helper libata drm uhci_hcd scsi_mod
ehci_hcd i2c_algo_bit rtc_cmos rtc_core rtc_lib usbcore intel_agp
button video intel_gtt fan thermal processor thermal_sys hwmon
[  677.854935] Pid: 2401, comm: mount Tainted: G      D  C
2.6.39-rc5-0.3-default #6
[  677.854942] Call Trace:
[  677.854959]  [<c023420d>] __schedule_bug+0x5d/0x70
[  677.854971]  [<c05c7984>] schedule+0xa24/0xa30
[  677.854982]  [<c02d4310>] ? release_pages+0x1b0/0x1e0
[  677.854993]  [<c030838f>] ? fput+0x12f/0x1e0
[  677.855004]  [<c02ea9ca>] ? remove_vma+0x3a/0x50
[  677.855015]  [<c023f846>] __cond_resched+0x16/0x30
[  677.855024]  [<c05c7ba3>] _cond_resched+0x23/0x30
[  677.855034]  [<c0248cdc>] put_files_struct+0x6c/0xb0
[  677.855043]  [<c0248dac>] exit_files+0x3c/0x50
[  677.855051]  [<c02491de>] do_exit+0x15e/0x780
[  677.855060]  [<c0247227>] ? kmsg_dump+0x37/0xd0
[  677.855070]  [<c05c6c6d>] ? printk+0x28/0x2b
[  677.855080]  [<c05cad9d>] oops_end+0x8d/0xd0
[  677.855090]  [<c022700e>] no_context+0xbe/0x150
[  677.855100]  [<c0227227>] __bad_area_nosemaphore+0x37/0x170
[  677.855111]  [<c0227372>] bad_area_nosemaphore+0x12/0x20
[  677.855121]  [<c05ccc94>] do_page_fault+0x2c4/0x420
[  677.855131]  [<c02d0dbe>] ? __alloc_pages_nodemask+0xee/0x6e0
[  677.855142]  [<c022bc27>] ? kmap_atomic_prot+0x47/0xf0
[  677.855152]  [<c05cc9d0>] ? spurious_fault+0xd0/0xd0
[  677.855161]  [<c05ca34a>] error_code+0x5a/0x60
[  677.855171]  [<c05cc9d0>] ? spurious_fault+0xd0/0xd0
[  677.855180]  [<c022bbfb>] ? kmap_atomic_prot+0x1b/0xf0
[  677.855189]  [<c022bcde>] __kmap_atomic+0xe/0x10
[  677.855235]  [<f853bab8>] read_extent_buffer+0x88/0x140 [btrfs]
[  677.855273]  [<f854b727>] add_inode_ref+0x1e7/0x330 [btrfs]
[  677.855318]  [<f854ccde>] replay_one_buffer+0x21e/0x2e0 [btrfs]
[  677.855358]  [<f854a431>] walk_down_log_tree+0x1d1/0x360 [btrfs]
[  677.855399]  [<f854a636>] walk_log_tree+0x76/0x1e0 [btrfs]
[  677.855410]  [<c03e7a2a>] ? radix_tree_lookup+0xa/0x10
[  677.855446]  [<f854e8fe>] btrfs_recover_log_trees+0x1de/0x2b0 [btrfs]
[  677.855488]  [<f854cac0>] ? replay_one_extent+0x6a0/0x6a0 [btrfs]
[  677.855539]  [<f8513a8c>] open_ctree+0x10bc/0x1410 [btrfs]
[  677.855552]  [<c03e9ca9>] ? strlcpy+0x39/0x60
[  677.855583]  [<f84f45e1>] btrfs_mount+0x461/0x590 [btrfs]
[  677.855594]  [<c02e3400>] ? pcpu_alloc+0x310/0x850
[  677.855604]  [<c03098d5>] mount_fs+0x35/0x180
[  677.855616]  [<c031e9d6>] vfs_kern_mount+0x46/0xa0
[  677.855625]  [<c031f7c9>] do_kern_mount+0x39/0xd0
[  677.855634]  [<c0320f34>] do_mount+0x594/0x6c0
[  677.855643]  [<c02d13d6>] ? __get_free_pages+0x26/0x30
[  677.855652]  [<c0320879>] ? copy_mount_options+0x39/0x120
[  677.855661]  [<c0321386>] sys_mount+0x66/0xa0
[  677.855672]  [<c05d021c>] sysenter_do_call+0x12/0x28




with 2.6.39-rc5, without clear_cache option
 # mount -o compress=lzo /dev/sda2 /mnt/
[  138.393711] Btrfs loaded
[  138.415758] device fsid f24027efc24d32f7-2191b1da9df7d184 devid 1
transid 164511 /dev/sda2
[  138.416404] btrfs: use lzo compression
[  138.476160] btrfs: disk space caching is enabled
[  139.154606] block group 29360128 has an wrong amount of free space
[  139.287457] BUG: unable to handle kernel NULL pointer dereference at   (null)
[  139.287484] IP: [<c022bbfb>] kmap_atomic_prot+0x1b/0xf0
[  139.287506] *pde = 00000000
[  139.287518] Oops: 0000 [#1] SMP
[  139.287530] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
[  139.287544] Modules linked in: btrfs zlib_deflate af_packet
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bnep edd
cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm usb_storage uas snd_timer uvcvideo
videodev iTCO_wdt iTCO_vendor_support snd soundcore snd_page_alloc
media btusb pcspkr bluetooth r8187se(C) rfkill joydev battery r8169
eeprom_93cx6 wmi sg ac ext4 jbd2 crc16 usbhid hid sd_mod ata_generic
i915 drm_kms_helper ata_piix drm uhci_hcd rtc_cmos rtc_core libata
ehci_hcd i2c_algo_bit rtc_lib usbcore scsi_mod button intel_agp
intel_gtt video fan thermal processor thermal_sys hwmon
[  139.287717]
[  139.287729] Pid: 2193, comm: mount Tainted: G         C
2.6.39-rc5-0.3-default #6 LG Electronics X110-L.A741B/X110
[  139.287751] EIP: 0060:[<c022bbfb>] EFLAGS: 00210202 CPU: 1
[  139.287764] EIP is at kmap_atomic_prot+0x1b/0xf0
[  139.287777] EAX: 00000000 EBX: 000004ca ECX: cccc2000 EDX: 00000163
[  139.287790] ESI: 00000000 EDI: 000004ca EBP: cccc3b88 ESP: cccc3b78
[  139.287804]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  139.287817] Process mount (pid: 2193, ti=cccc2000 task=ccc90d30
task.ti=cccc2000)
[  139.287830] Stack:
[  139.287838]  f64037c0 000004ca 00000000 000004ca cccc3b90 c022bcde
cccc3bbc f8935ab8
[  139.287861]  00000000 d0570180 c92ce0a8 00000007 b7c09000 0000000e
00006572 c92c8000
[  139.287884]  00000f58 cccc3c24 f8945727 00006572 00000000 00000000
00000000 00094689
[  139.287907] Call Trace:
[  139.287921]  [<c022bcde>] __kmap_atomic+0xe/0x10
[  139.287963]  [<f8935ab8>] read_extent_buffer+0x88/0x140 [btrfs]
[  139.288005]  [<f8945727>] add_inode_ref+0x1e7/0x330 [btrfs]
[  139.288056]  [<f8946cde>] replay_one_buffer+0x21e/0x2e0 [btrfs]
[  139.288098]  [<f8944431>] walk_down_log_tree+0x1d1/0x360 [btrfs]
[  139.288139]  [<f8944636>] walk_log_tree+0x76/0x1e0 [btrfs]
[  139.288157]  [<c03e7a2a>] ? radix_tree_lookup+0xa/0x10
[  139.288197]  [<f89488fe>] btrfs_recover_log_trees+0x1de/0x2b0 [btrfs]
[  139.288238]  [<f8946ac0>] ? replay_one_extent+0x6a0/0x6a0 [btrfs]
[  139.288290]  [<f890da8c>] open_ctree+0x10bc/0x1410 [btrfs]
[  139.288310]  [<c03e9ca9>] ? strlcpy+0x39/0x60
[  139.288341]  [<f88ee5e1>] btrfs_mount+0x461/0x590 [btrfs]
[  139.288359]  [<c02e3400>] ? pcpu_alloc+0x310/0x850
[  139.288375]  [<c03098d5>] mount_fs+0x35/0x180
[  139.288392]  [<c031e9d6>] vfs_kern_mount+0x46/0xa0
[  139.288407]  [<c031f7c9>] do_kern_mount+0x39/0xd0
[  139.288421]  [<c0320f34>] do_mount+0x594/0x6c0
[  139.288436]  [<c02d13d6>] ? __get_free_pages+0x26/0x30
[  139.288450]  [<c0320879>] ? copy_mount_options+0x39/0x120
[  139.288464]  [<c0321386>] sys_mount+0x66/0xa0
[  139.288481]  [<c05d021c>] sysenter_do_call+0x12/0x28
[  139.288493] Code: 8b 15 cc 42 82 c0 55 89 e5 e8 52 f9 ff ff 5d c3
55 89 e5 83 ec 10 89 e1 81 e1 00 e0 ff ff 89 5d f4 89 75 f8 89 7d fc
83 41 14 01 <8b> 08 c1 e9 1e 69 c9 80 03 00 00 8d b1 80 db 78 c0 2b b1
cc de
[  139.288595] EIP: [<c022bbfb>] kmap_atomic_prot+0x1b/0xf0 SS:ESP 0068:cccc3b78
[  139.288614] CR2: 0000000000000000
[  139.310232] ---[ end trace 34b5224bc0e9db2d ]---
[  139.310259] note: mount[2193] exited with preempt_count 1
[  139.310531] BUG: scheduling while atomic: mount/2193/0x10000001
[  139.310553] Modules linked in: btrfs zlib_deflate af_packet
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bnep edd
cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm usb_storage uas snd_timer uvcvideo
videodev iTCO_wdt iTCO_vendor_support snd soundcore snd_page_alloc
media btusb pcspkr bluetooth r8187se(C) rfkill joydev battery r8169
eeprom_93cx6 wmi sg ac ext4 jbd2 crc16 usbhid hid sd_mod ata_generic
i915 drm_kms_helper ata_piix drm uhci_hcd rtc_cmos rtc_core libata
ehci_hcd i2c_algo_bit rtc_lib usbcore scsi_mod button intel_agp
intel_gtt video fan thermal processor thermal_sys hwmon
[  139.310856] Pid: 2193, comm: mount Tainted: G      D  C
2.6.39-rc5-0.3-default #6
[  139.310881] Call Trace:
[  139.310911]  [<c023420d>] __schedule_bug+0x5d/0x70
[  139.310940]  [<c05c7984>] schedule+0xa24/0xa30
[  139.310967]  [<c02d4310>] ? release_pages+0x1b0/0x1e0
[  139.310995]  [<c030838f>] ? fput+0x12f/0x1e0
[  139.311022]  [<c02ea9ca>] ? remove_vma+0x3a/0x50
[  139.311048]  [<c023f846>] __cond_resched+0x16/0x30
[  139.311075]  [<c05c7ba3>] _cond_resched+0x23/0x30
[  139.311100]  [<c0248cdc>] put_files_struct+0x6c/0xb0
[  139.311126]  [<c0248dac>] exit_files+0x3c/0x50
[  139.311147]  [<c02491de>] do_exit+0x15e/0x780
[  139.311168]  [<c0247227>] ? kmsg_dump+0x37/0xd0
[  139.311189]  [<c05c6c6d>] ? printk+0x28/0x2b
[  139.311211]  [<c05cad9d>] oops_end+0x8d/0xd0
[  139.311233]  [<c022700e>] no_context+0xbe/0x150
[  139.311255]  [<c0227227>] __bad_area_nosemaphore+0x37/0x170
[  139.311279]  [<c0227372>] bad_area_nosemaphore+0x12/0x20
[  139.311301]  [<c05ccc94>] do_page_fault+0x2c4/0x420
[  139.311323]  [<c02d0dbe>] ? __alloc_pages_nodemask+0xee/0x6e0
[  139.311347]  [<c022bc27>] ? kmap_atomic_prot+0x47/0xf0
[  139.311373]  [<c05cc9d0>] ? spurious_fault+0xd0/0xd0
[  139.311398]  [<c05ca34a>] error_code+0x5a/0x60
[  139.311423]  [<c05cc9d0>] ? spurious_fault+0xd0/0xd0
[  139.311450]  [<c022bbfb>] ? kmap_atomic_prot+0x1b/0xf0
[  139.311476]  [<c022bcde>] __kmap_atomic+0xe/0x10
[  139.311537]  [<f8935ab8>] read_extent_buffer+0x88/0x140 [btrfs]
[  139.311598]  [<f8945727>] add_inode_ref+0x1e7/0x330 [btrfs]
[  139.311657]  [<f8946cde>] replay_one_buffer+0x21e/0x2e0 [btrfs]
[  139.311710]  [<f8944431>] walk_down_log_tree+0x1d1/0x360 [btrfs]
[  139.311761]  [<f8944636>] walk_log_tree+0x76/0x1e0 [btrfs]
[  139.311786]  [<c03e7a2a>] ? radix_tree_lookup+0xa/0x10
[  139.311846]  [<f89488fe>] btrfs_recover_log_trees+0x1de/0x2b0 [btrfs]
[  139.311907]  [<f8946ac0>] ? replay_one_extent+0x6a0/0x6a0 [btrfs]
[  139.311980]  [<f890da8c>] open_ctree+0x10bc/0x1410 [btrfs]
[  139.312038]  [<c03e9ca9>] ? strlcpy+0x39/0x60
[  139.312087]  [<f88ee5e1>] btrfs_mount+0x461/0x590 [btrfs]
[  139.312115]  [<c02e3400>] ? pcpu_alloc+0x310/0x850
[  139.312142]  [<c03098d5>] mount_fs+0x35/0x180
[  139.312171]  [<c031e9d6>] vfs_kern_mount+0x46/0xa0
[  139.312198]  [<c031f7c9>] do_kern_mount+0x39/0xd0
[  139.312223]  [<c0320f34>] do_mount+0x594/0x6c0
[  139.312249]  [<c02d13d6>] ? __get_free_pages+0x26/0x30
[  139.312275]  [<c0320879>] ? copy_mount_options+0x39/0x120
[  139.312302]  [<c0321386>] sys_mount+0x66/0xa0
[  139.312328]  [<c05d021c>] sysenter_do_call+0x12/0x28



with integration-test tree (2011/05/24)
# mount -o clear_cache,compress=lzo /dev/sda2 /mnt/
[  295.895116] Btrfs loaded
[  295.906626] device fsid f24027efc24d32f7-2191b1da9df7d184 devid 1
transid 164511 /dev/sda2
[  295.907432] btrfs: force clearing of disk cache
[  295.907455] btrfs: use lzo compression
[  295.967015] btrfs: disk space caching is enabled
[  296.767248] BUG: unable to handle kernel NULL pointer dereference at   (null)
[  296.767274] IP: [<c022bcab>] kmap_atomic_prot+0x1b/0xf0
[  296.767298] *pde = 00000000
[  296.767310] Oops: 0000 [#1] SMP
[  296.767322] last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:11/PNP0C09:00/PNP0C0A:00/power_supply/BAT1/voltage_now
[  296.767346] Modules linked in: btrfs zlib_deflate fuse af_packet
snd_pcm_oss snd_mixer_oss snd_seq bnep snd_seq_device edd
cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_timer snd uvcvideo r8187se(C)
btusb videodev soundcore usb_storage iTCO_wdt sg iTCO_vendor_support
uas eeprom_93cx6 bluetooth r8169 wmi media rfkill snd_page_alloc
joydev pcspkr battery ac ext4 jbd2 crc16 usbhid hid sd_mod ata_generic
i915 drm_kms_helper uhci_hcd ata_piix drm ehci_hcd libata scsi_mod
rtc_cmos intel_agp i2c_algo_bit usbcore intel_gtt rtc_core rtc_lib
video button fan thermal processor thermal_sys hwmon
[  296.767523]
[  296.767534] Pid: 2299, comm: mount Tainted: G         C
2.6.39-0.3-default+ #1 LG Electronics X110-L.A741B/X110
[  296.767556] EIP: 0060:[<c022bcab>] EFLAGS: 00210202 CPU: 1
[  296.767570] EIP is at kmap_atomic_prot+0x1b/0xf0
[  296.767582] EAX: 00000000 EBX: 000004ca ECX: d6c4e000 EDX: 00000163
[  296.767595] ESI: 00000000 EDI: 000004ca EBP: d6c4fb78 ESP: d6c4fb68
[  296.767609]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  296.767623] Process mount (pid: 2299, ti=d6c4e000 task=d6c4ce70
task.ti=d6c4e000)
[  296.767636] Stack:
[  296.767644]  f4c037c0 000004ca 00000000 000004ca d6c4fb80 c022bd8e
d6c4fbac f888a278
[  296.767667]  00000000 e1ac3888 f400e0a8 00000007 b7c09000 0000000e
00006572 f4008000
[  296.767690]  00000f58 d6c4fc20 f8899e5f 00006572 00000000 00000000
00000000 00094689
[  296.767713] Call Trace:
[  296.767727]  [<c022bd8e>] __kmap_atomic+0xe/0x10
[  296.767770]  [<f888a278>] read_extent_buffer+0x88/0x140 [btrfs]
[  296.767812]  [<f8899e5f>] add_inode_ref+0x22f/0x370 [btrfs]
[  296.767854]  [<f889b7fe>] replay_one_buffer+0x21e/0x2e0 [btrfs]
[  296.767897]  [<f8898e61>] walk_down_log_tree+0x1d1/0x360 [btrfs]
[  296.767939]  [<f8899066>] walk_log_tree+0x76/0x1e0 [btrfs]
[  296.767957]  [<c03e585a>] ? radix_tree_lookup+0xa/0x10
[  296.767998]  [<f889d47c>] btrfs_recover_log_trees+0x1dc/0x2a0 [btrfs]
[  296.768050]  [<f889b5e0>] ? replay_one_extent+0x6a0/0x6a0 [btrfs]
[  296.768104]  [<f88624c5>] open_ctree+0x11c5/0x1510 [btrfs]
[  296.768124]  [<c03e7ad9>] ? strlcpy+0x39/0x60
[  296.768155]  [<f8842651>] btrfs_mount+0x461/0x590 [btrfs]
[  296.768174]  [<c02e2300>] ? pcpu_alloc+0x2c0/0x850
[  296.768192]  [<c0307f25>] mount_fs+0x35/0x180
[  296.768208]  [<c031cfe6>] vfs_kern_mount+0x46/0xa0
[  296.768223]  [<c031ddd9>] do_kern_mount+0x39/0xd0
[  296.768237]  [<c031f544>] do_mount+0x594/0x6c0
[  296.768253]  [<c02d02a6>] ? __get_free_pages+0x26/0x30
[  296.768268]  [<c031ee89>] ? copy_mount_options+0x39/0x120
[  296.768282]  [<c031f996>] sys_mount+0x66/0xa0
[  296.768298]  [<c05b745c>] sysenter_do_call+0x12/0x28
[  296.768310] Code: 8b 15 cc f2 7f c0 55 89 e5 e8 52 f9 ff ff 5d c3
55 89 e5 83 ec 10 89 e1 81 e1 00 e0 ff ff 89 5d f4 89 75 f8 89 7d fc
83 41 14 01 <8b> 08 c1 e9 1e 69 c9 80 03 00 00 8d b1 80 a8 76 c0 2b b1
cc ab
[  296.768413] EIP: [<c022bcab>] kmap_atomic_prot+0x1b/0xf0 SS:ESP 0068:d6c4fb68
[  296.768432] CR2: 0000000000000000
[  296.770367] [drm] Changing LVDS panel from (+hsync, +vsync) to
(-hsync, -vsync)
[  296.949992] ---[ end trace 0963ef50bd4dfa03 ]---
[  296.950017] note: mount[2299] exited with preempt_count 1
[  296.950322] BUG: scheduling while atomic: mount/2299/0x10000001
[  296.950345] Modules linked in: btrfs zlib_deflate fuse af_packet
snd_pcm_oss snd_mixer_oss snd_seq bnep snd_seq_device edd
cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_timer snd uvcvideo r8187se(C)
btusb videodev soundcore usb_storage iTCO_wdt sg iTCO_vendor_support
uas eeprom_93cx6 bluetooth r8169 wmi media rfkill snd_page_alloc
joydev pcspkr battery ac ext4 jbd2 crc16 usbhid hid sd_mod ata_generic
i915 drm_kms_helper uhci_hcd ata_piix drm ehci_hcd libata scsi_mod
rtc_cmos intel_agp i2c_algo_bit usbcore intel_gtt rtc_core rtc_lib
video button fan thermal processor thermal_sys hwmon
[  296.950537] Pid: 2299, comm: mount Tainted: G      D  C
2.6.39-0.3-default+ #1
[  296.950543] Call Trace:
[  296.950561]  [<c023438d>] __schedule_bug+0x5d/0x70
[  296.950573]  [<c05aea3d>] schedule+0x8cd/0xa60
[  296.950584]  [<c02d3280>] ? release_pages+0x1b0/0x1e0
[  296.950597]  [<c03069df>] ? fput+0x12f/0x1e0
[  296.950608]  [<c02e983a>] ? remove_vma+0x3a/0x50
[  296.950619]  [<c023f886>] __cond_resched+0x16/0x30
[  296.950628]  [<c05aede3>] _cond_resched+0x23/0x30
[  296.950637]  [<c0248cdc>] put_files_struct+0x6c/0xb0
[  296.950646]  [<c0248dac>] exit_files+0x3c/0x50
[  296.950655]  [<c02491de>] do_exit+0x15e/0x780
[  296.950664]  [<c0247227>] ? kmsg_dump+0x37/0xd0
[  296.950673]  [<c05ade7d>] ? printk+0x28/0x2b
[  296.950684]  [<c05b1fdd>] oops_end+0x8d/0xd0
[  296.950694]  [<c02270be>] no_context+0xbe/0x150
[  296.950704]  [<c02272d7>] __bad_area_nosemaphore+0x37/0x170
[  296.950714]  [<c0227422>] bad_area_nosemaphore+0x12/0x20
[  296.950724]  [<c05b3ed4>] do_page_fault+0x2c4/0x420
[  296.950735]  [<c02cfc8e>] ? __alloc_pages_nodemask+0xee/0x6e0
[  296.950746]  [<c022bcd7>] ? kmap_atomic_prot+0x47/0xf0
[  296.950757]  [<c05b3c10>] ? spurious_fault+0xd0/0xd0
[  296.950766]  [<c05b158a>] error_code+0x5a/0x60
[  296.950776]  [<c05b3c10>] ? spurious_fault+0xd0/0xd0
[  296.950785]  [<c022bcab>] ? kmap_atomic_prot+0x1b/0xf0
[  296.950794]  [<c022bd8e>] __kmap_atomic+0xe/0x10
[  296.950841]  [<f888a278>] read_extent_buffer+0x88/0x140 [btrfs]
[  296.950886]  [<f8899e5f>] add_inode_ref+0x22f/0x370 [btrfs]
[  296.950927]  [<f889b7fe>] replay_one_buffer+0x21e/0x2e0 [btrfs]
[  296.950972]  [<f8898e61>] walk_down_log_tree+0x1d1/0x360 [btrfs]
[  296.951012]  [<f8899066>] walk_log_tree+0x76/0x1e0 [btrfs]
[  296.951023]  [<c03e585a>] ? radix_tree_lookup+0xa/0x10
[  296.951064]  [<f889d47c>] btrfs_recover_log_trees+0x1dc/0x2a0 [btrfs]
[  296.951104]  [<f889b5e0>] ? replay_one_extent+0x6a0/0x6a0 [btrfs]
[  296.951156]  [<f88624c5>] open_ctree+0x11c5/0x1510 [btrfs]
[  296.951168]  [<c03e7ad9>] ? strlcpy+0x39/0x60
[  296.951198]  [<f8842651>] btrfs_mount+0x461/0x590 [btrfs]
[  296.951209]  [<c02e2300>] ? pcpu_alloc+0x2c0/0x850
[  296.951221]  [<c0307f25>] mount_fs+0x35/0x180
[  296.951232]  [<c031cfe6>] vfs_kern_mount+0x46/0xa0
[  296.951242]  [<c031ddd9>] do_kern_mount+0x39/0xd0
[  296.951251]  [<c031f544>] do_mount+0x594/0x6c0
[  296.951261]  [<c02d02a6>] ? __get_free_pages+0x26/0x30
[  296.951270]  [<c031ee89>] ? copy_mount_options+0x39/0x120
[  296.951279]  [<c031f996>] sys_mount+0x66/0xa0
[  296.951289]  [<c05b745c>] sysenter_do_call+0x12/0x28



Thanks!
