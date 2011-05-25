From: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference
Date: Wed, 25 May 2011 19:41:14 +0200
Message-ID: <BANLkTik_=otvE_bfyjSQ2NoG6VVh_zgQKg@mail.gmail.com>
References: <BANLkTikKAfPgutxW0Su0v0jZ1LnSA495hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikKAfPgutxW0Su0v0jZ1LnSA495hw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

=46inally I successfully remounted my partition. Here is how I've done
to recover, in case it can help someone else :
 I had to clone btrfs-progs-unstable tree.
Then checkout branch "tmp" (because I use compression, default
btrfs-progs are "too old"
Then I compiled btrfs-zero-log with "make btrfs-zero-log"
And finally ran "./btrfs-zero-log /dev/sda2"

Now I'm copying everything to a new partition, because I don't know if
can safely use the damaged one.

But wouldn't it be possible to avoid the "Null pointer" kernel crash
by checking what we do inside replay_one_buffer, and then
automatically clear log, or provide a "clear_log" mount option?
Any idea about what could have caused my problem?

Thanks.




2011/5/25 matthieu Barth=E9lemy <bonsouere@gmail.com>:
> Hi all,
>
> I have a Btrfs partition that cannot be mounted anymore, it makes
> kernel to crash.
> The partition was created a few months ago, with kernel 2.6.33 (with
> no special options) if I remember well. Since then, with new kernel
> releases, I enabled a few options : first space_cache, then compress,
> and finally with 2.6.38 compress=3Dlzo
> So the filesystem has now space_cache, data compressed with zlib AND =
lzo.
>
> With kernel 2.6.39-rc5 I had, a few weeks ago, a first crash where it
> complained about no free space. Then I rebooted on kernel 2.6.38,
> mounted the filesystem with the clear_cache option, and everything
> went fine, even returning back on kernel 2.6.39-rc5.
>
> But last week, while I was working (nothing special such as intensive
> read or writes), the system crashed because of Btrfs.
> Since then, I cannot mount my FS anymore.
> Here are the dmesg logs I gathered, testing with 2.6.39-rc5, and just
> to see if it made any difference, with the integration-test tree.
>
> Any idea about what happened? How can I help you to diagnose that? An=
y
> chance I could recover my data?
>
> Thanks.
>
> with 2.6.39-rc5 :
> # mount -o clear_cache,compress=3Dlzo /dev/sda2 /mnt/
>
> [ =A0676.767161] Btrfs loaded
> [ =A0676.774399] device fsid f24027efc24d32f7-2191b1da9df7d184 devid =
1
> transid 164511 /dev/sda2
> [ =A0676.775233] btrfs: force clearing of disk cache
> [ =A0676.775255] btrfs: use lzo compression
> [ =A0676.834811] btrfs: disk space caching is enabled
> [ =A0677.601773] BUG: unable to handle kernel NULL pointer dereferenc=
e at =A0 (null)
> [ =A0677.601800] IP: [<c022bbfb>] kmap_atomic_prot+0x1b/0xf0
> [ =A0677.601822] *pde =3D 00000000
> [ =A0677.601834] Oops: 0000 [#1] SMP
> [ =A0677.601846] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/ue=
vent
> [ =A0677.601861] Modules linked in: btrfs zlib_deflate af_packet
> snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bnep edd
> cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
> acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel btusb
> snd_hda_codec bluetooth usb_storage snd_hwdep uas iTCO_wdt
> iTCO_vendor_support snd_pcm rfkill r8187se(C) uvcvideo videodev
> snd_timer media joydev wmi battery ac sg eeprom_93cx6 snd pcspkr
> soundcore r8169 snd_page_alloc ext4 jbd2 crc16 usbhid hid sd_mod
> ata_generic i915 ata_piix drm_kms_helper libata drm uhci_hcd scsi_mod
> ehci_hcd i2c_algo_bit rtc_cmos rtc_core rtc_lib usbcore intel_agp
> button video intel_gtt fan thermal processor thermal_sys hwmon
> [ =A0677.602034]
> [ =A0677.602046] Pid: 2401, comm: mount Tainted: G =A0 =A0 =A0 =A0 C
> 2.6.39-rc5-0.3-default #6 LG Electronics X110-L.A741B/X110
> [ =A0677.602068] EIP: 0060:[<c022bbfb>] EFLAGS: 00210202 CPU: 1
> [ =A0677.602082] EIP is at kmap_atomic_prot+0x1b/0xf0
> [ =A0677.602094] EAX: 00000000 EBX: 000004ca ECX: d9fee000 EDX: 00000=
163
> [ =A0677.602107] ESI: 00000000 EDI: 000004ca EBP: d9fefb88 ESP: d9fef=
b78
> [ =A0677.602121] =A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ =A0677.602134] Process mount (pid: 2401, ti=3Dd9fee000 task=3De61bf=
030
> task.ti=3Dd9fee000)
> [ =A0677.602147] Stack:
> [ =A0677.602156] =A0f64037c0 000004ca 00000000 000004ca d9fefb90 c022=
bcde
> d9fefbbc f853bab8
> [ =A0677.602179] =A000000000 c71c40f0 c68560a8 00000007 b7c09000 0000=
000e
> 00006572 c6850000
> [ =A0677.602202] =A000000f58 d9fefc24 f854b727 00006572 00000000 0000=
0000
> 00000000 00094689
> [ =A0677.602225] Call Trace:
> [ =A0677.602239] =A0[<c022bcde>] __kmap_atomic+0xe/0x10
> [ =A0677.602281] =A0[<f853bab8>] read_extent_buffer+0x88/0x140 [btrfs=
]
> [ =A0677.602322] =A0[<f854b727>] add_inode_ref+0x1e7/0x330 [btrfs]
> [ =A0677.602363] =A0[<f854ccde>] replay_one_buffer+0x21e/0x2e0 [btrfs=
]
> [ =A0677.602404] =A0[<f854a431>] walk_down_log_tree+0x1d1/0x360 [btrf=
s]
> [ =A0677.602445] =A0[<f854a636>] walk_log_tree+0x76/0x1e0 [btrfs]
> [ =A0677.602463] =A0[<c03e7a2a>] ? radix_tree_lookup+0xa/0x10
> [ =A0677.602503] =A0[<f854e8fe>] btrfs_recover_log_trees+0x1de/0x2b0 =
[btrfs]
> [ =A0677.602544] =A0[<f854cac0>] ? replay_one_extent+0x6a0/0x6a0 [btr=
fs]
> [ =A0677.602596] =A0[<f8513a8c>] open_ctree+0x10bc/0x1410 [btrfs]
> [ =A0677.602615] =A0[<c03e9ca9>] ? strlcpy+0x39/0x60
> [ =A0677.602646] =A0[<f84f45e1>] btrfs_mount+0x461/0x590 [btrfs]
> [ =A0677.602664] =A0[<c02e3400>] ? pcpu_alloc+0x310/0x850
> [ =A0677.602681] =A0[<c03098d5>] mount_fs+0x35/0x180
> [ =A0677.602698] =A0[<c031e9d6>] vfs_kern_mount+0x46/0xa0
> [ =A0677.602712] =A0[<c031f7c9>] do_kern_mount+0x39/0xd0
> [ =A0677.602726] =A0[<c0320f34>] do_mount+0x594/0x6c0
> [ =A0677.602741] =A0[<c02d13d6>] ? __get_free_pages+0x26/0x30
> [ =A0677.602755] =A0[<c0320879>] ? copy_mount_options+0x39/0x120
> [ =A0677.602770] =A0[<c0321386>] sys_mount+0x66/0xa0
> [ =A0677.602786] =A0[<c05d021c>] sysenter_do_call+0x12/0x28
> [ =A0677.602798] Code: 8b 15 cc 42 82 c0 55 89 e5 e8 52 f9 ff ff 5d c=
3
> 55 89 e5 83 ec 10 89 e1 81 e1 00 e0 ff ff 89 5d f4 89 75 f8 89 7d fc
> 83 41 14 01 <8b> 08 c1 e9 1e 69 c9 80 03 00 00 8d b1 80 db 78 c0 2b b=
1
> cc de
> [ =A0677.602902] EIP: [<c022bbfb>] kmap_atomic_prot+0x1b/0xf0 SS:ESP =
0068:d9fefb78
> [ =A0677.602920] CR2: 0000000000000000
> [ =A0677.604805] [drm] Changing LVDS panel from (+hsync, +vsync) to
> (-hsync, -vsync)
> [ =A0677.854425] ---[ end trace b216833b014671c4 ]---
> [ =A0677.854452] note: mount[2401] exited with preempt_count 1
> [ =A0677.854731] BUG: scheduling while atomic: mount/2401/0x10000001
> [ =A0677.854753] Modules linked in: btrfs zlib_deflate af_packet
> snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bnep edd
> cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
> acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel btusb
> snd_hda_codec bluetooth usb_storage snd_hwdep uas iTCO_wdt
> iTCO_vendor_support snd_pcm rfkill r8187se(C) uvcvideo videodev
> snd_timer media joydev wmi battery ac sg eeprom_93cx6 snd pcspkr
> soundcore r8169 snd_page_alloc ext4 jbd2 crc16 usbhid hid sd_mod
> ata_generic i915 ata_piix drm_kms_helper libata drm uhci_hcd scsi_mod
> ehci_hcd i2c_algo_bit rtc_cmos rtc_core rtc_lib usbcore intel_agp
> button video intel_gtt fan thermal processor thermal_sys hwmon
> [ =A0677.854935] Pid: 2401, comm: mount Tainted: G =A0 =A0 =A0D =A0C
> 2.6.39-rc5-0.3-default #6
> [ =A0677.854942] Call Trace:
> [ =A0677.854959] =A0[<c023420d>] __schedule_bug+0x5d/0x70
> [ =A0677.854971] =A0[<c05c7984>] schedule+0xa24/0xa30
> [ =A0677.854982] =A0[<c02d4310>] ? release_pages+0x1b0/0x1e0
> [ =A0677.854993] =A0[<c030838f>] ? fput+0x12f/0x1e0
> [ =A0677.855004] =A0[<c02ea9ca>] ? remove_vma+0x3a/0x50
> [ =A0677.855015] =A0[<c023f846>] __cond_resched+0x16/0x30
> [ =A0677.855024] =A0[<c05c7ba3>] _cond_resched+0x23/0x30
> [ =A0677.855034] =A0[<c0248cdc>] put_files_struct+0x6c/0xb0
> [ =A0677.855043] =A0[<c0248dac>] exit_files+0x3c/0x50
> [ =A0677.855051] =A0[<c02491de>] do_exit+0x15e/0x780
> [ =A0677.855060] =A0[<c0247227>] ? kmsg_dump+0x37/0xd0
> [ =A0677.855070] =A0[<c05c6c6d>] ? printk+0x28/0x2b
> [ =A0677.855080] =A0[<c05cad9d>] oops_end+0x8d/0xd0
> [ =A0677.855090] =A0[<c022700e>] no_context+0xbe/0x150
> [ =A0677.855100] =A0[<c0227227>] __bad_area_nosemaphore+0x37/0x170
> [ =A0677.855111] =A0[<c0227372>] bad_area_nosemaphore+0x12/0x20
> [ =A0677.855121] =A0[<c05ccc94>] do_page_fault+0x2c4/0x420
> [ =A0677.855131] =A0[<c02d0dbe>] ? __alloc_pages_nodemask+0xee/0x6e0
> [ =A0677.855142] =A0[<c022bc27>] ? kmap_atomic_prot+0x47/0xf0
> [ =A0677.855152] =A0[<c05cc9d0>] ? spurious_fault+0xd0/0xd0
> [ =A0677.855161] =A0[<c05ca34a>] error_code+0x5a/0x60
> [ =A0677.855171] =A0[<c05cc9d0>] ? spurious_fault+0xd0/0xd0
> [ =A0677.855180] =A0[<c022bbfb>] ? kmap_atomic_prot+0x1b/0xf0
> [ =A0677.855189] =A0[<c022bcde>] __kmap_atomic+0xe/0x10
> [ =A0677.855235] =A0[<f853bab8>] read_extent_buffer+0x88/0x140 [btrfs=
]
> [ =A0677.855273] =A0[<f854b727>] add_inode_ref+0x1e7/0x330 [btrfs]
> [ =A0677.855318] =A0[<f854ccde>] replay_one_buffer+0x21e/0x2e0 [btrfs=
]
> [ =A0677.855358] =A0[<f854a431>] walk_down_log_tree+0x1d1/0x360 [btrf=
s]
> [ =A0677.855399] =A0[<f854a636>] walk_log_tree+0x76/0x1e0 [btrfs]
> [ =A0677.855410] =A0[<c03e7a2a>] ? radix_tree_lookup+0xa/0x10
> [ =A0677.855446] =A0[<f854e8fe>] btrfs_recover_log_trees+0x1de/0x2b0 =
[btrfs]
> [ =A0677.855488] =A0[<f854cac0>] ? replay_one_extent+0x6a0/0x6a0 [btr=
fs]
> [ =A0677.855539] =A0[<f8513a8c>] open_ctree+0x10bc/0x1410 [btrfs]
> [ =A0677.855552] =A0[<c03e9ca9>] ? strlcpy+0x39/0x60
> [ =A0677.855583] =A0[<f84f45e1>] btrfs_mount+0x461/0x590 [btrfs]
> [ =A0677.855594] =A0[<c02e3400>] ? pcpu_alloc+0x310/0x850
> [ =A0677.855604] =A0[<c03098d5>] mount_fs+0x35/0x180
> [ =A0677.855616] =A0[<c031e9d6>] vfs_kern_mount+0x46/0xa0
> [ =A0677.855625] =A0[<c031f7c9>] do_kern_mount+0x39/0xd0
> [ =A0677.855634] =A0[<c0320f34>] do_mount+0x594/0x6c0
> [ =A0677.855643] =A0[<c02d13d6>] ? __get_free_pages+0x26/0x30
> [ =A0677.855652] =A0[<c0320879>] ? copy_mount_options+0x39/0x120
> [ =A0677.855661] =A0[<c0321386>] sys_mount+0x66/0xa0
> [ =A0677.855672] =A0[<c05d021c>] sysenter_do_call+0x12/0x28
>
>
>
>
> with 2.6.39-rc5, without clear_cache option
> =A0# mount -o compress=3Dlzo /dev/sda2 /mnt/
> [ =A0138.393711] Btrfs loaded
> [ =A0138.415758] device fsid f24027efc24d32f7-2191b1da9df7d184 devid =
1
> transid 164511 /dev/sda2
> [ =A0138.416404] btrfs: use lzo compression
> [ =A0138.476160] btrfs: disk space caching is enabled
> [ =A0139.154606] block group 29360128 has an wrong amount of free spa=
ce
> [ =A0139.287457] BUG: unable to handle kernel NULL pointer dereferenc=
e at =A0 (null)
> [ =A0139.287484] IP: [<c022bbfb>] kmap_atomic_prot+0x1b/0xf0
> [ =A0139.287506] *pde =3D 00000000
> [ =A0139.287518] Oops: 0000 [#1] SMP
> [ =A0139.287530] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/ue=
vent
> [ =A0139.287544] Modules linked in: btrfs zlib_deflate af_packet
> snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bnep edd
> cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
> acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm usb_storage uas snd_timer uvcvideo
> videodev iTCO_wdt iTCO_vendor_support snd soundcore snd_page_alloc
> media btusb pcspkr bluetooth r8187se(C) rfkill joydev battery r8169
> eeprom_93cx6 wmi sg ac ext4 jbd2 crc16 usbhid hid sd_mod ata_generic
> i915 drm_kms_helper ata_piix drm uhci_hcd rtc_cmos rtc_core libata
> ehci_hcd i2c_algo_bit rtc_lib usbcore scsi_mod button intel_agp
> intel_gtt video fan thermal processor thermal_sys hwmon
> [ =A0139.287717]
> [ =A0139.287729] Pid: 2193, comm: mount Tainted: G =A0 =A0 =A0 =A0 C
> 2.6.39-rc5-0.3-default #6 LG Electronics X110-L.A741B/X110
> [ =A0139.287751] EIP: 0060:[<c022bbfb>] EFLAGS: 00210202 CPU: 1
> [ =A0139.287764] EIP is at kmap_atomic_prot+0x1b/0xf0
> [ =A0139.287777] EAX: 00000000 EBX: 000004ca ECX: cccc2000 EDX: 00000=
163
> [ =A0139.287790] ESI: 00000000 EDI: 000004ca EBP: cccc3b88 ESP: cccc3=
b78
> [ =A0139.287804] =A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ =A0139.287817] Process mount (pid: 2193, ti=3Dcccc2000 task=3Dccc90=
d30
> task.ti=3Dcccc2000)
> [ =A0139.287830] Stack:
> [ =A0139.287838] =A0f64037c0 000004ca 00000000 000004ca cccc3b90 c022=
bcde
> cccc3bbc f8935ab8
> [ =A0139.287861] =A000000000 d0570180 c92ce0a8 00000007 b7c09000 0000=
000e
> 00006572 c92c8000
> [ =A0139.287884] =A000000f58 cccc3c24 f8945727 00006572 00000000 0000=
0000
> 00000000 00094689
> [ =A0139.287907] Call Trace:
> [ =A0139.287921] =A0[<c022bcde>] __kmap_atomic+0xe/0x10
> [ =A0139.287963] =A0[<f8935ab8>] read_extent_buffer+0x88/0x140 [btrfs=
]
> [ =A0139.288005] =A0[<f8945727>] add_inode_ref+0x1e7/0x330 [btrfs]
> [ =A0139.288056] =A0[<f8946cde>] replay_one_buffer+0x21e/0x2e0 [btrfs=
]
> [ =A0139.288098] =A0[<f8944431>] walk_down_log_tree+0x1d1/0x360 [btrf=
s]
> [ =A0139.288139] =A0[<f8944636>] walk_log_tree+0x76/0x1e0 [btrfs]
> [ =A0139.288157] =A0[<c03e7a2a>] ? radix_tree_lookup+0xa/0x10
> [ =A0139.288197] =A0[<f89488fe>] btrfs_recover_log_trees+0x1de/0x2b0 =
[btrfs]
> [ =A0139.288238] =A0[<f8946ac0>] ? replay_one_extent+0x6a0/0x6a0 [btr=
fs]
> [ =A0139.288290] =A0[<f890da8c>] open_ctree+0x10bc/0x1410 [btrfs]
> [ =A0139.288310] =A0[<c03e9ca9>] ? strlcpy+0x39/0x60
> [ =A0139.288341] =A0[<f88ee5e1>] btrfs_mount+0x461/0x590 [btrfs]
> [ =A0139.288359] =A0[<c02e3400>] ? pcpu_alloc+0x310/0x850
> [ =A0139.288375] =A0[<c03098d5>] mount_fs+0x35/0x180
> [ =A0139.288392] =A0[<c031e9d6>] vfs_kern_mount+0x46/0xa0
> [ =A0139.288407] =A0[<c031f7c9>] do_kern_mount+0x39/0xd0
> [ =A0139.288421] =A0[<c0320f34>] do_mount+0x594/0x6c0
> [ =A0139.288436] =A0[<c02d13d6>] ? __get_free_pages+0x26/0x30
> [ =A0139.288450] =A0[<c0320879>] ? copy_mount_options+0x39/0x120
> [ =A0139.288464] =A0[<c0321386>] sys_mount+0x66/0xa0
> [ =A0139.288481] =A0[<c05d021c>] sysenter_do_call+0x12/0x28
> [ =A0139.288493] Code: 8b 15 cc 42 82 c0 55 89 e5 e8 52 f9 ff ff 5d c=
3
> 55 89 e5 83 ec 10 89 e1 81 e1 00 e0 ff ff 89 5d f4 89 75 f8 89 7d fc
> 83 41 14 01 <8b> 08 c1 e9 1e 69 c9 80 03 00 00 8d b1 80 db 78 c0 2b b=
1
> cc de
> [ =A0139.288595] EIP: [<c022bbfb>] kmap_atomic_prot+0x1b/0xf0 SS:ESP =
0068:cccc3b78
> [ =A0139.288614] CR2: 0000000000000000
> [ =A0139.310232] ---[ end trace 34b5224bc0e9db2d ]---
> [ =A0139.310259] note: mount[2193] exited with preempt_count 1
> [ =A0139.310531] BUG: scheduling while atomic: mount/2193/0x10000001
> [ =A0139.310553] Modules linked in: btrfs zlib_deflate af_packet
> snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bnep edd
> cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
> acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm usb_storage uas snd_timer uvcvideo
> videodev iTCO_wdt iTCO_vendor_support snd soundcore snd_page_alloc
> media btusb pcspkr bluetooth r8187se(C) rfkill joydev battery r8169
> eeprom_93cx6 wmi sg ac ext4 jbd2 crc16 usbhid hid sd_mod ata_generic
> i915 drm_kms_helper ata_piix drm uhci_hcd rtc_cmos rtc_core libata
> ehci_hcd i2c_algo_bit rtc_lib usbcore scsi_mod button intel_agp
> intel_gtt video fan thermal processor thermal_sys hwmon
> [ =A0139.310856] Pid: 2193, comm: mount Tainted: G =A0 =A0 =A0D =A0C
> 2.6.39-rc5-0.3-default #6
> [ =A0139.310881] Call Trace:
> [ =A0139.310911] =A0[<c023420d>] __schedule_bug+0x5d/0x70
> [ =A0139.310940] =A0[<c05c7984>] schedule+0xa24/0xa30
> [ =A0139.310967] =A0[<c02d4310>] ? release_pages+0x1b0/0x1e0
> [ =A0139.310995] =A0[<c030838f>] ? fput+0x12f/0x1e0
> [ =A0139.311022] =A0[<c02ea9ca>] ? remove_vma+0x3a/0x50
> [ =A0139.311048] =A0[<c023f846>] __cond_resched+0x16/0x30
> [ =A0139.311075] =A0[<c05c7ba3>] _cond_resched+0x23/0x30
> [ =A0139.311100] =A0[<c0248cdc>] put_files_struct+0x6c/0xb0
> [ =A0139.311126] =A0[<c0248dac>] exit_files+0x3c/0x50
> [ =A0139.311147] =A0[<c02491de>] do_exit+0x15e/0x780
> [ =A0139.311168] =A0[<c0247227>] ? kmsg_dump+0x37/0xd0
> [ =A0139.311189] =A0[<c05c6c6d>] ? printk+0x28/0x2b
> [ =A0139.311211] =A0[<c05cad9d>] oops_end+0x8d/0xd0
> [ =A0139.311233] =A0[<c022700e>] no_context+0xbe/0x150
> [ =A0139.311255] =A0[<c0227227>] __bad_area_nosemaphore+0x37/0x170
> [ =A0139.311279] =A0[<c0227372>] bad_area_nosemaphore+0x12/0x20
> [ =A0139.311301] =A0[<c05ccc94>] do_page_fault+0x2c4/0x420
> [ =A0139.311323] =A0[<c02d0dbe>] ? __alloc_pages_nodemask+0xee/0x6e0
> [ =A0139.311347] =A0[<c022bc27>] ? kmap_atomic_prot+0x47/0xf0
> [ =A0139.311373] =A0[<c05cc9d0>] ? spurious_fault+0xd0/0xd0
> [ =A0139.311398] =A0[<c05ca34a>] error_code+0x5a/0x60
> [ =A0139.311423] =A0[<c05cc9d0>] ? spurious_fault+0xd0/0xd0
> [ =A0139.311450] =A0[<c022bbfb>] ? kmap_atomic_prot+0x1b/0xf0
> [ =A0139.311476] =A0[<c022bcde>] __kmap_atomic+0xe/0x10
> [ =A0139.311537] =A0[<f8935ab8>] read_extent_buffer+0x88/0x140 [btrfs=
]
> [ =A0139.311598] =A0[<f8945727>] add_inode_ref+0x1e7/0x330 [btrfs]
> [ =A0139.311657] =A0[<f8946cde>] replay_one_buffer+0x21e/0x2e0 [btrfs=
]
> [ =A0139.311710] =A0[<f8944431>] walk_down_log_tree+0x1d1/0x360 [btrf=
s]
> [ =A0139.311761] =A0[<f8944636>] walk_log_tree+0x76/0x1e0 [btrfs]
> [ =A0139.311786] =A0[<c03e7a2a>] ? radix_tree_lookup+0xa/0x10
> [ =A0139.311846] =A0[<f89488fe>] btrfs_recover_log_trees+0x1de/0x2b0 =
[btrfs]
> [ =A0139.311907] =A0[<f8946ac0>] ? replay_one_extent+0x6a0/0x6a0 [btr=
fs]
> [ =A0139.311980] =A0[<f890da8c>] open_ctree+0x10bc/0x1410 [btrfs]
> [ =A0139.312038] =A0[<c03e9ca9>] ? strlcpy+0x39/0x60
> [ =A0139.312087] =A0[<f88ee5e1>] btrfs_mount+0x461/0x590 [btrfs]
> [ =A0139.312115] =A0[<c02e3400>] ? pcpu_alloc+0x310/0x850
> [ =A0139.312142] =A0[<c03098d5>] mount_fs+0x35/0x180
> [ =A0139.312171] =A0[<c031e9d6>] vfs_kern_mount+0x46/0xa0
> [ =A0139.312198] =A0[<c031f7c9>] do_kern_mount+0x39/0xd0
> [ =A0139.312223] =A0[<c0320f34>] do_mount+0x594/0x6c0
> [ =A0139.312249] =A0[<c02d13d6>] ? __get_free_pages+0x26/0x30
> [ =A0139.312275] =A0[<c0320879>] ? copy_mount_options+0x39/0x120
> [ =A0139.312302] =A0[<c0321386>] sys_mount+0x66/0xa0
> [ =A0139.312328] =A0[<c05d021c>] sysenter_do_call+0x12/0x28
>
>
>
> with integration-test tree (2011/05/24)
> # mount -o clear_cache,compress=3Dlzo /dev/sda2 /mnt/
> [ =A0295.895116] Btrfs loaded
> [ =A0295.906626] device fsid f24027efc24d32f7-2191b1da9df7d184 devid =
1
> transid 164511 /dev/sda2
> [ =A0295.907432] btrfs: force clearing of disk cache
> [ =A0295.907455] btrfs: use lzo compression
> [ =A0295.967015] btrfs: disk space caching is enabled
> [ =A0296.767248] BUG: unable to handle kernel NULL pointer dereferenc=
e at =A0 (null)
> [ =A0296.767274] IP: [<c022bcab>] kmap_atomic_prot+0x1b/0xf0
> [ =A0296.767298] *pde =3D 00000000
> [ =A0296.767310] Oops: 0000 [#1] SMP
> [ =A0296.767322] last sysfs file:
> /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:11/PNP0C09:00/PN=
P0C0A:00/power_supply/BAT1/voltage_now
> [ =A0296.767346] Modules linked in: btrfs zlib_deflate fuse af_packet
> snd_pcm_oss snd_mixer_oss snd_seq bnep snd_seq_device edd
> cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
> acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm snd_timer snd uvcvideo r8187se(C)
> btusb videodev soundcore usb_storage iTCO_wdt sg iTCO_vendor_support
> uas eeprom_93cx6 bluetooth r8169 wmi media rfkill snd_page_alloc
> joydev pcspkr battery ac ext4 jbd2 crc16 usbhid hid sd_mod ata_generi=
c
> i915 drm_kms_helper uhci_hcd ata_piix drm ehci_hcd libata scsi_mod
> rtc_cmos intel_agp i2c_algo_bit usbcore intel_gtt rtc_core rtc_lib
> video button fan thermal processor thermal_sys hwmon
> [ =A0296.767523]
> [ =A0296.767534] Pid: 2299, comm: mount Tainted: G =A0 =A0 =A0 =A0 C
> 2.6.39-0.3-default+ #1 LG Electronics X110-L.A741B/X110
> [ =A0296.767556] EIP: 0060:[<c022bcab>] EFLAGS: 00210202 CPU: 1
> [ =A0296.767570] EIP is at kmap_atomic_prot+0x1b/0xf0
> [ =A0296.767582] EAX: 00000000 EBX: 000004ca ECX: d6c4e000 EDX: 00000=
163
> [ =A0296.767595] ESI: 00000000 EDI: 000004ca EBP: d6c4fb78 ESP: d6c4f=
b68
> [ =A0296.767609] =A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ =A0296.767623] Process mount (pid: 2299, ti=3Dd6c4e000 task=3Dd6c4c=
e70
> task.ti=3Dd6c4e000)
> [ =A0296.767636] Stack:
> [ =A0296.767644] =A0f4c037c0 000004ca 00000000 000004ca d6c4fb80 c022=
bd8e
> d6c4fbac f888a278
> [ =A0296.767667] =A000000000 e1ac3888 f400e0a8 00000007 b7c09000 0000=
000e
> 00006572 f4008000
> [ =A0296.767690] =A000000f58 d6c4fc20 f8899e5f 00006572 00000000 0000=
0000
> 00000000 00094689
> [ =A0296.767713] Call Trace:
> [ =A0296.767727] =A0[<c022bd8e>] __kmap_atomic+0xe/0x10
> [ =A0296.767770] =A0[<f888a278>] read_extent_buffer+0x88/0x140 [btrfs=
]
> [ =A0296.767812] =A0[<f8899e5f>] add_inode_ref+0x22f/0x370 [btrfs]
> [ =A0296.767854] =A0[<f889b7fe>] replay_one_buffer+0x21e/0x2e0 [btrfs=
]
> [ =A0296.767897] =A0[<f8898e61>] walk_down_log_tree+0x1d1/0x360 [btrf=
s]
> [ =A0296.767939] =A0[<f8899066>] walk_log_tree+0x76/0x1e0 [btrfs]
> [ =A0296.767957] =A0[<c03e585a>] ? radix_tree_lookup+0xa/0x10
> [ =A0296.767998] =A0[<f889d47c>] btrfs_recover_log_trees+0x1dc/0x2a0 =
[btrfs]
> [ =A0296.768050] =A0[<f889b5e0>] ? replay_one_extent+0x6a0/0x6a0 [btr=
fs]
> [ =A0296.768104] =A0[<f88624c5>] open_ctree+0x11c5/0x1510 [btrfs]
> [ =A0296.768124] =A0[<c03e7ad9>] ? strlcpy+0x39/0x60
> [ =A0296.768155] =A0[<f8842651>] btrfs_mount+0x461/0x590 [btrfs]
> [ =A0296.768174] =A0[<c02e2300>] ? pcpu_alloc+0x2c0/0x850
> [ =A0296.768192] =A0[<c0307f25>] mount_fs+0x35/0x180
> [ =A0296.768208] =A0[<c031cfe6>] vfs_kern_mount+0x46/0xa0
> [ =A0296.768223] =A0[<c031ddd9>] do_kern_mount+0x39/0xd0
> [ =A0296.768237] =A0[<c031f544>] do_mount+0x594/0x6c0
> [ =A0296.768253] =A0[<c02d02a6>] ? __get_free_pages+0x26/0x30
> [ =A0296.768268] =A0[<c031ee89>] ? copy_mount_options+0x39/0x120
> [ =A0296.768282] =A0[<c031f996>] sys_mount+0x66/0xa0
> [ =A0296.768298] =A0[<c05b745c>] sysenter_do_call+0x12/0x28
> [ =A0296.768310] Code: 8b 15 cc f2 7f c0 55 89 e5 e8 52 f9 ff ff 5d c=
3
> 55 89 e5 83 ec 10 89 e1 81 e1 00 e0 ff ff 89 5d f4 89 75 f8 89 7d fc
> 83 41 14 01 <8b> 08 c1 e9 1e 69 c9 80 03 00 00 8d b1 80 a8 76 c0 2b b=
1
> cc ab
> [ =A0296.768413] EIP: [<c022bcab>] kmap_atomic_prot+0x1b/0xf0 SS:ESP =
0068:d6c4fb68
> [ =A0296.768432] CR2: 0000000000000000
> [ =A0296.770367] [drm] Changing LVDS panel from (+hsync, +vsync) to
> (-hsync, -vsync)
> [ =A0296.949992] ---[ end trace 0963ef50bd4dfa03 ]---
> [ =A0296.950017] note: mount[2299] exited with preempt_count 1
> [ =A0296.950322] BUG: scheduling while atomic: mount/2299/0x10000001
> [ =A0296.950345] Modules linked in: btrfs zlib_deflate fuse af_packet
> snd_pcm_oss snd_mixer_oss snd_seq bnep snd_seq_device edd
> cpufreq_conservative microcode cpufreq_userspace cpufreq_powersave
> acpi_cpufreq mperf dm_mod snd_hda_codec_realtek snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm snd_timer snd uvcvideo r8187se(C)
> btusb videodev soundcore usb_storage iTCO_wdt sg iTCO_vendor_support
> uas eeprom_93cx6 bluetooth r8169 wmi media rfkill snd_page_alloc
> joydev pcspkr battery ac ext4 jbd2 crc16 usbhid hid sd_mod ata_generi=
c
> i915 drm_kms_helper uhci_hcd ata_piix drm ehci_hcd libata scsi_mod
> rtc_cmos intel_agp i2c_algo_bit usbcore intel_gtt rtc_core rtc_lib
> video button fan thermal processor thermal_sys hwmon
> [ =A0296.950537] Pid: 2299, comm: mount Tainted: G =A0 =A0 =A0D =A0C
> 2.6.39-0.3-default+ #1
> [ =A0296.950543] Call Trace:
> [ =A0296.950561] =A0[<c023438d>] __schedule_bug+0x5d/0x70
> [ =A0296.950573] =A0[<c05aea3d>] schedule+0x8cd/0xa60
> [ =A0296.950584] =A0[<c02d3280>] ? release_pages+0x1b0/0x1e0
> [ =A0296.950597] =A0[<c03069df>] ? fput+0x12f/0x1e0
> [ =A0296.950608] =A0[<c02e983a>] ? remove_vma+0x3a/0x50
> [ =A0296.950619] =A0[<c023f886>] __cond_resched+0x16/0x30
> [ =A0296.950628] =A0[<c05aede3>] _cond_resched+0x23/0x30
> [ =A0296.950637] =A0[<c0248cdc>] put_files_struct+0x6c/0xb0
> [ =A0296.950646] =A0[<c0248dac>] exit_files+0x3c/0x50
> [ =A0296.950655] =A0[<c02491de>] do_exit+0x15e/0x780
> [ =A0296.950664] =A0[<c0247227>] ? kmsg_dump+0x37/0xd0
> [ =A0296.950673] =A0[<c05ade7d>] ? printk+0x28/0x2b
> [ =A0296.950684] =A0[<c05b1fdd>] oops_end+0x8d/0xd0
> [ =A0296.950694] =A0[<c02270be>] no_context+0xbe/0x150
> [ =A0296.950704] =A0[<c02272d7>] __bad_area_nosemaphore+0x37/0x170
> [ =A0296.950714] =A0[<c0227422>] bad_area_nosemaphore+0x12/0x20
> [ =A0296.950724] =A0[<c05b3ed4>] do_page_fault+0x2c4/0x420
> [ =A0296.950735] =A0[<c02cfc8e>] ? __alloc_pages_nodemask+0xee/0x6e0
> [ =A0296.950746] =A0[<c022bcd7>] ? kmap_atomic_prot+0x47/0xf0
> [ =A0296.950757] =A0[<c05b3c10>] ? spurious_fault+0xd0/0xd0
> [ =A0296.950766] =A0[<c05b158a>] error_code+0x5a/0x60
> [ =A0296.950776] =A0[<c05b3c10>] ? spurious_fault+0xd0/0xd0
> [ =A0296.950785] =A0[<c022bcab>] ? kmap_atomic_prot+0x1b/0xf0
> [ =A0296.950794] =A0[<c022bd8e>] __kmap_atomic+0xe/0x10
> [ =A0296.950841] =A0[<f888a278>] read_extent_buffer+0x88/0x140 [btrfs=
]
> [ =A0296.950886] =A0[<f8899e5f>] add_inode_ref+0x22f/0x370 [btrfs]
> [ =A0296.950927] =A0[<f889b7fe>] replay_one_buffer+0x21e/0x2e0 [btrfs=
]
> [ =A0296.950972] =A0[<f8898e61>] walk_down_log_tree+0x1d1/0x360 [btrf=
s]
> [ =A0296.951012] =A0[<f8899066>] walk_log_tree+0x76/0x1e0 [btrfs]
> [ =A0296.951023] =A0[<c03e585a>] ? radix_tree_lookup+0xa/0x10
> [ =A0296.951064] =A0[<f889d47c>] btrfs_recover_log_trees+0x1dc/0x2a0 =
[btrfs]
> [ =A0296.951104] =A0[<f889b5e0>] ? replay_one_extent+0x6a0/0x6a0 [btr=
fs]
> [ =A0296.951156] =A0[<f88624c5>] open_ctree+0x11c5/0x1510 [btrfs]
> [ =A0296.951168] =A0[<c03e7ad9>] ? strlcpy+0x39/0x60
> [ =A0296.951198] =A0[<f8842651>] btrfs_mount+0x461/0x590 [btrfs]
> [ =A0296.951209] =A0[<c02e2300>] ? pcpu_alloc+0x2c0/0x850
> [ =A0296.951221] =A0[<c0307f25>] mount_fs+0x35/0x180
> [ =A0296.951232] =A0[<c031cfe6>] vfs_kern_mount+0x46/0xa0
> [ =A0296.951242] =A0[<c031ddd9>] do_kern_mount+0x39/0xd0
> [ =A0296.951251] =A0[<c031f544>] do_mount+0x594/0x6c0
> [ =A0296.951261] =A0[<c02d02a6>] ? __get_free_pages+0x26/0x30
> [ =A0296.951270] =A0[<c031ee89>] ? copy_mount_options+0x39/0x120
> [ =A0296.951279] =A0[<c031f996>] sys_mount+0x66/0xa0
> [ =A0296.951289] =A0[<c05b745c>] sysenter_do_call+0x12/0x28
>
>
>
> Thanks!
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
