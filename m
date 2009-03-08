From: Yien Zheng <esprout@gmail.com>
Subject: Re: Entirely unexpected ENOSPC?
Date: Sun, 8 Mar 2009 01:36:27 -0600
Message-ID: <2c259a8f0903072336g43ed1ee0qf6fbcd2c0ff72850@mail.gmail.com>
References: <2c259a8f0903072332n31d9d20dscad1801b4b468520@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2c259a8f0903072332n31d9d20dscad1801b4b468520@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I just tried umounting the partition and got this:

[ 1395.028651] btrfs searching for 69632 bytes, num_bytes 69632, loop
2, allowed_alloc 1
[ 1395.028661] btrfs allocation failed flags 1, wanted 69632
[ 1395.028667] space_info has 81920 free, is full
[ 1395.028673] space_info total=3D10720313344, pinned=3D2678784,
delalloc=3D0, may_use=3D0, used=3D10717552640
[ 1395.028681] block group 12582912 has 8388608 bytes, 8388608 used 0
pinned 0 reserved
[ 1395.028687] 0 blocks of free space at or bigger than bytes is
[ 1395.028694] block group 1103101952 has 1073741824 bytes, 1072877568
used 864256 pinned 0 reserved
[ 1395.028700] 0 blocks of free space at or bigger than bytes is
[ 1395.028706] block group 2176843776 has 1073741824 bytes, 1073741824
used 0 pinned 0 reserved
[ 1395.028712] 0 blocks of free space at or bigger than bytes is
[ 1395.028718] block group 3250585600 has 1073741824 bytes, 1073709056
used 32768 pinned 0 reserved
[ 1395.028724] 0 blocks of free space at or bigger than bytes is
[ 1395.028730] block group 4324327424 has 1073741824 bytes, 1073741824
used 0 pinned 0 reserved
[ 1395.028736] 0 blocks of free space at or bigger than bytes is
[ 1395.028742] block group 5398069248 has 1073741824 bytes, 1073741824
used 0 pinned 0 reserved
[ 1395.028748] 0 blocks of free space at or bigger than bytes is
[ 1395.028754] block group 6471811072 has 1073741824 bytes, 1073741824
used 0 pinned 0 reserved
[ 1395.028760] 0 blocks of free space at or bigger than bytes is
[ 1395.028767] block group 7545552896 has 1073741824 bytes, 1073618944
used 122880 pinned 0 reserved
[ 1395.028772] 0 blocks of free space at or bigger than bytes is
[ 1395.028779] block group 8619294720 has 1073741824 bytes, 1073639424
used 102400 pinned 0 reserved
[ 1395.028785] 0 blocks of free space at or bigger than bytes is
[ 1395.028791] block group 9693036544 has 1073741824 bytes, 1073549312
used 192512 pinned 0 reserved
[ 1395.028797] 0 blocks of free space at or bigger than bytes is
[ 1395.028804] block group 10766778368 has 1048248320 bytes,
1046802432 used 1363968 pinned 0 reserved
[ 1395.028811] 0 blocks of free space at or bigger than bytes is
[ 1395.028858] ------------[ cut here ]------------
[ 1395.028863] kernel BUG at fs/btrfs/extent-tree.c:3412!
[ 1395.028869] invalid opcode: 0000 [#1] SMP
[ 1395.028876] last sysfs file:
/sys/devices/pci0000:00/0000:00:1e.0/0000:0b:02.0/rf_kill
[ 1395.028882] Modules linked in: arc4 ecb lib80211_crypt_wep
af_packet radeon drm i2c_core sco bridge rfcomm stp bnep l2cap
bluetooth vboxnetflt vboxdrv ppdev acpi_cpufreq cpufreq_ondemand
cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats
freq_table sbs container sbshc pci_slot iptable_filter ip_tables
x_tables loop btrfs zlib_deflate crc32c libcrc32c lp pcmcia joydev
thinkpad_acpi rfkill led_class nvram snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy evdev
snd_seq_oss psmouse snd_seq_midi snd_rawmidi serio_raw
snd_seq_midi_event pcspkr snd_seq snd_timer snd_seq_device
yenta_socket rsrc_nonstatic pcmcia_core ipw2200 libipw lib80211 snd
iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc battery ac video
output parport_pc parport nsc_ircc irda crc_ccitt button shpchp
pci_hotplug intel_agp agpgart ext3 jbd mbcache sd_mod crc_t10dif
usb_storage libusual sg ahci pata_acpi ata_generic ata_piix libata
scsi_mod ehci_hcd uhci_hcd usbcore tg3 libphy thermal processor fan
fuse
[ 1395.029058]
[ 1395.029064] Pid: 4015, comm: btrfs-delalloc- Not tainted
(2.6.29-rc7-custom #2) 2686DHU
[ 1395.029071] EIP: 0060:[<f8055289>] EFLAGS: 00010257 CPU: 0
[ 1395.029108] EIP is at __btrfs_reserve_extent+0x2d9/0x450 [btrfs]
[ 1395.029114] EAX: f6e6535c EBX: f5879300 ECX: ffffffff EDX: 00000001
[ 1395.029120] ESI: 00011000 EDI: 00000000 EBP: f5a9fe8c ESP: f5a9fe04
[ 1395.029126]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1395.029132] Process btrfs-delalloc- (pid: 4015, ti=3Df5a9e000
task=3Df6f7b100 task.ti=3Df5a9e000)
[ 1395.029137] Stack:
[ 1395.029141]  f80960dc 81c00000 00000002 3e7b0000 00000000 3e64f000
00000000 0014d000
[ 1395.029154]  00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000001
[ 1395.029168]  00000000 00000000 00000000 00000000 00000000 00011000
00000000 00000001
[ 1395.029183] Call Trace:
[ 1395.029202]  [<f8055472>] ? btrfs_reserve_extent+0x72/0xb0 [btrfs]
[ 1395.029240]  [<f80659dd>] ? submit_compressed_extents+0x17d/0x4c0 [b=
trfs]
[ 1395.029282]  [<f8065db3>] ? async_cow_submit+0x93/0xa0 [btrfs]
[ 1395.029322]  [<f8087f3c>] ? run_ordered_completions+0x6c/0xc0 [btrfs=
]
[ 1395.029363]  [<f8088110>] ? worker_loop+0x90/0x1e0 [btrfs]
[ 1395.029401]  [<f8088080>] ? worker_loop+0x0/0x1e0 [btrfs]
[ 1395.029436]  [<c0146dcc>] ? kthread+0x3c/0x70
[ 1395.029448]  [<c0146d90>] ? kthread+0x0/0x70
[ 1395.029456]  [<c0103fa7>] ? kernel_thread_helper+0x7/0x10
[ 1395.029465] Code: 53 50 8d 82 74 ff ff ff 89 45 e8 8b 80 8c 00 00
00 0f 18 00 90 83 c3 5039 d3 89 5d ec 0f 85 da 00 00 00 8b 45 f0 e8 f7
5e 0f c8 <0f> 0b eb fe 8d 76 00 8b 4d d8 8b 5d e0 8b 81 2c 01 00 00 8b
50
[ 1395.029543] EIP: [<f8055289>] __btrfs_reserve_extent+0x2d9/0x450
[btrfs] SS:ESP 0068:f5a9fe04
[ 1395.029583] ---[ end trace 652a082f590907db ]---


> Here's my dmesg output:
>
> [ =A0884.445441] no space left, need 8192, 2760704 delalloc bytes,
> 10717552640 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
> bytes_readonly, 0 may use10720313344 total
> [ =A0912.026372] btrfs searching for 524288 bytes, num_bytes 524288,
> loop 2, allowed_alloc 1
> [ =A0912.026389] btrfs searching for 262144 bytes, num_bytes 262144,
> loop 2, allowed_alloc 1
> [ =A0912.026403] btrfs searching for 131072 bytes, num_bytes 131072,
> loop 2, allowed_alloc 1
> [ =A0912.026426] btrfs searching for 458752 bytes, num_bytes 458752,
> loop 2, allowed_alloc 1
> [ =A0912.026439] btrfs searching for 229376 bytes, num_bytes 229376,
> loop 2, allowed_alloc 1
> [...more lines like this]
> [ 1363.318175] no space left, need 8192, 81920 delalloc bytes,
> 10720231424 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
> bytes_readonly, 0 may use10720313344 total
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
