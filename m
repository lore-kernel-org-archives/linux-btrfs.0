From: "Yan, Zheng" <ukernel@gmail.com>
Subject: Re: bug when removing device
Date: Thu, 29 Apr 2010 16:58:44 +0800
Message-ID: <p2u3d0408631004290158j40591c7coee8c6fc73c3d06d1@mail.gmail.com>
References: <j2x9bd6b5361004281111u565c16d7x24ea3d4640ca365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: sniper <s3c24xx@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <j2x9bd6b5361004281111u565c16d7x24ea3d4640ca365@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 29, 2010 at 2:11 AM, sniper <s3c24xx@gmail.com> wrote:
> Hi all,
>
> I tried to reproduce the bug reported by Tomas Thiemel
> (http://www.spinics.net/lists/linux-btrfs/msg04818.html) with loop
> device, and caught a bug report.
>
> kernel: v2.6.34-rc5-279-g1600f9d
> btrfs_progs: v0.19-16-g075587c
>
> cd /tmp
> mkdir mnt0
> mkdir mnt1
> dd if=3D/dev/zero of=3D./disk0 bs=3D1M count=3D500
> cp disk0 disk1
> sudo losetup /dev/loop0 ./disk0
> sudo losetup /dev/loop1 ./disk1
> sudo mkfs.btrfs /dev/loop0
> sudo mkfs.btrfs /dev/loop1
> sudo mount -t btrfs /dev/loop0 /tmp/mnt0
> sudo chmod 777 ./mnt0
> cp something to mnt0 to make it about 90% full.
> sync
> sudo btrfs device add /dev/loop1 /tmp/mnt0/
> sudo btrfs device del /dev/loop0 /tmp/mnt0/
>
>
>
> [ =A0 62.633654] Btrfs loaded
> [ =A0 62.683562] device fsid f54c8635a7be86e1-bbbda7c901fc86bc devid =
1
> transid 3244 /dev/sda3
> [ =A0146.235105] device fsid e6427ac6ae899005-2bbefc65da08e8e devid 1
> transid 7 /dev/loop0
> [ =A0283.259210] btrfs: relocating block group 465567744 flags 1
> [ =A0283.546271] btrfs: relocating block group 398458880 flags 1
> [ =A0284.081040] btrfs: found 87 extents
> [ =A0285.807272] btrfs: found 87 extents
> [ =A0286.011543] btrfs: relocating block group 331350016 flags 1
> [ =A0286.609884] btrfs: found 4238 extents
> [ =A0288.990953] btrfs: found 4238 extents
> [ =A0289.283116] btrfs: relocating block group 264241152 flags 1
> [ =A0289.905397] btrfs: found 130 extents
> [ =A0291.474489] btrfs: found 130 extents
> [ =A0291.646969] btrfs: relocating block group 197132288 flags 1
> [ =A0292.121484] btrfs: found 236 extents
> [ =A0293.781097] btrfs: found 236 extents
> [ =A0293.979469] btrfs: relocating block group 130023424 flags 1
> [ =A0294.483698] btrfs: found 208 extents
> [ =A0296.108372] btrfs: found 208 extents
> [ =A0296.328261] btrfs: relocating block group 62914560 flags 1
> [ =A0296.822185] btrfs: found 123 extents
> [ =A0298.424613] btrfs: found 123 extents
> [ =A0298.574020] btrfs: relocating block group 20971520 flags 34
> [ =A0298.659502] btrfs allocation failed flags 34, wanted 4096
> [ =A0298.659509] space_info has 8384512 free, is full
> [ =A0298.659514] space_info total=3D8388608, pinned=3D0, delalloc=3D0=
,
> may_use=3D0, used=3D4096, root=3D0, super=3D0, reserved=3D0
> [ =A0298.659519] block group 20971520 has 8388608 bytes, 4096 used 0
> pinned 0 reserved
> [ =A0298.659524] entry offset 20975616, bytes 8384512, bitmap no
> [ =A0298.659527] block group has cluster?: no
> [ =A0298.659530] 1 blocks of free space at or bigger than bytes is
> [ =A0298.659562] ------------[ cut here ]------------
> [ =A0298.659565] kernel BUG at fs/btrfs/relocation.c:2146!
> [ =A0298.659569] invalid opcode: 0000 [#1] SMP
> [ =A0298.659575] last sysfs file:
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> [ =A0298.659579] Modules linked in: btrfs zlib_deflate crc32c libcrc3=
2c
> binfmt_misc xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle ip_tables
> x_tables pppoe pppox ppdev parport_pc snd_hda_codec_nvhdmi
> snd_hda_codec_realtek snd_hda_intel fbcon tileblit snd_hda_codec font
> snd_hwdep bitblit softcursor snd_pcm_oss arc4 snd_mixer_oss snd_pcm
> joydev snd_seq_dummy snd_seq_oss snd_seq_midi uvcvideo nouveau
> snd_rawmidi ttm drm_kms_helper sdhci_pci videodev video sdhci iwlagn
> psmouse v4l1_compat output snd_seq_midi_event lp led_class iwlcore dr=
m
> intel_agp snd_seq serio_raw agpgart i2c_algo_bit parport snd_timer
> snd_seq_device snd jmb38x_ms memstick soundcore snd_page_alloc
> mac80211 cfg80211 usbhid ohci1394 hid usb_storage tg3 ieee1394
> [ =A0298.659679]
> [ =A0298.659685] Pid: 2179, comm: btrfs Not tainted 2.6.34-rc5-custom=
 #1
> KL1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /IdeaPad =
Y450
> [ =A0298.659691] EIP: 0060:[<f85f3b7e>] EFLAGS: 00010286 CPU: 1
> [ =A0298.659710] EIP is at relocate_tree_blocks+0x52e/0x590 [btrfs]
> [ =A0298.659714] EAX: cd096dc0 EBX: cd1a83c0 ECX: cd096940 EDX: 00000=
000
> [ =A0298.659718] ESI: 00000008 EDI: cd096dc0 EBP: cd333c74 ESP: cd333=
c14
> [ =A0298.659722] =A0DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [ =A0298.659727] Process btrfs (pid: 2179, ti=3Dcd332000 task=3Df6beb=
340
> task.ti=3Dcd332000)
> [ =A0298.659730] Stack:
> [ =A0298.659733] =A0cd096554 f6e0eb60 00000000 cd096540 01400000 0000=
0000
> cd333c74 f6331800
> [ =A0298.659744] <0> cd333ccc ffffffe4 f69bbe40 00000000 ed57d570
> f6e0eb60 cd1a83fc 01000000
> [ =A0298.659756] <0> 00000000 d8000000 00000001 00000000 fffa2000
> 00000002 f6e0eaf0 f69bbe40
> [ =A0298.659768] Call Trace:
> [ =A0298.659788] =A0[<f85f3e0f>] ? relocate_block_group+0x22f/0x430 [=
btrfs]
> [ =A0298.659807] =A0[<f85b23d3>] ? btrfs_clean_old_snapshots+0x63/0xf=
0 [btrfs]
> [ =A0298.659824] =A0[<f85f4187>] ? btrfs_relocate_block_group+0x177/0=
x350 [btrfs]
> [ =A0298.659842] =A0[<f85d920e>] ? btrfs_relocate_chunk+0x6e/0x520 [b=
trfs]
> [ =A0298.659850] =A0[<c0130370>] ? kunmap_atomic+0x60/0x70
> [ =A0298.659869] =A0[<f85cf451>] ? unmap_extent_buffer+0x11/0x20 [btr=
fs]
> [ =A0298.659889] =A0[<f85c5610>] ? btrfs_dev_extent_chunk_offset+0xe0=
/0xf0 [btrfs]
> [ =A0298.659907] =A0[<f85d996e>] ? btrfs_shrink_device+0x2ae/0x3e0 [b=
trfs]
> [ =A0298.659925] =A0[<f85d9c5d>] ? btrfs_rm_device+0x1bd/0x530 [btrfs=
]
> [ =A0298.659933] =A0[<c01cc2fb>] ? filemap_fault+0xbb/0x400
> [ =A0298.659939] =A0[<c02024c3>] ? __mem_cgroup_try_charge+0x53/0x330
> [ =A0298.659956] =A0[<f85e1b9d>] ? btrfs_ioctl+0x79d/0x9c0 [btrfs]
> [ =A0298.659964] =A0[<c01dd0d8>] ? memdup_user+0x38/0x70
> [ =A0298.659980] =A0[<f85e1bbc>] ? btrfs_ioctl+0x7bc/0x9c0 [btrfs]
> [ =A0298.659986] =A0[<c01e28b8>] ? __do_fault+0x3e8/0x560
> [ =A0298.659993] =A0[<c01e47e5>] ? handle_mm_fault+0x145/0xaa0
> [ =A0298.660000] =A0[<c0215532>] ? vfs_ioctl+0x32/0xb0
> [ =A0298.660016] =A0[<f85e1400>] ? btrfs_ioctl+0x0/0x9c0 [btrfs]
> [ =A0298.660022] =A0[<c0215c92>] ? do_vfs_ioctl+0x72/0x5c0
> [ =A0298.660029] =A0[<c05a1abd>] ? do_page_fault+0x1cd/0x440
> [ =A0298.660035] =A0[<c0210e3b>] ? putname+0x2b/0x40
> [ =A0298.660041] =A0[<c0205e9a>] ? do_sys_open+0xfa/0x120
> [ =A0298.660047] =A0[<c0216247>] ? sys_ioctl+0x67/0x80
> [ =A0298.660053] =A0[<c0102fe3>] ? sysenter_do_call+0x12/0x28
> [ =A0298.660057] Code: 85 ff 75 db e9 49 fb ff ff 0f 0b 66 90 eb fc b=
a
> 29 09 00 00 b8 c8 60 5f f8 e8 af 5c b5 c7 0f b6 7e 25 e9 c8 fc ff ff
> 0f 0b eb fe <0f> 0b eb fe 8b 45 d4 e8 d6 1b fa ff c7 45 c4 f4 ff ff f=
f
> e9 02
> [ =A0298.660124] EIP: [<f85f3b7e>] relocate_tree_blocks+0x52e/0x590
> [btrfs] SS:ESP 0068:cd333c14
> [ =A0298.660150] ---[ end trace fb3e62da0e52a0bd ]---
>

I have sent a set of patches that address bugs like this.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
