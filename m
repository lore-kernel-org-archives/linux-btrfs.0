From: Shane Shrybman <shrybman@teksavvy.com>
Subject: Oops while rebalancing, now unmountable.
Date: Mon, 08 Nov 2010 12:10:57 -0500
Message-ID: <1289236257.3611.3.camel@mars>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Got an oops last week while rebalancing that seems to have left me with
a corrupted btrfs. Kernel was ~2.6.36 + Transparent hugetlb patchset +
small misc. patchs.

=EF=BB=BFI tried my last reliable 2.6.35 based kernel without the trans=
parent
hugetlb patchset and the btrfs was not mountable there either.
=EF=BB=BF
There has been a few unclean shutdowns lately due to power issues. But
things seemed fine after several days of use.

Label: none  uuid: b8a1b5a4-dce4-405f-89f4-903c13e92174
        Total devices 1 FS bytes used 1.25TB
        devid    1 size 1.36TB used 1.30TB path /dev/sdc1

Btrfs v0.19

Here's the oops I dug out of the log.

btrfs: found 97 extents
btrfs: sdc1 checksum verify failed on 624993189888 wanted 57EC7EA0 foun=
d 872AA969 level 0
message repeated 2 times
BUG: unable to handle kernel NULL pointer dereference at 0000001c
IP: [<791338e4>] btrfs_print_leaf+0x14/0xb00
*pde =3D 00000000=20
Oops: 0000 [#1] SMP=20
last sysfs file: /sys/block/sdd/removable
Modules linked in: loop nvidia(P) agpgart acpi_cpufreq mperf nfsd expor=
tfs nfs lockd fscache auth_rpcgss sunrpc coretemp netconsole usbhid tda=
7432 tuner tea5767 tda8290 tda18271 tuner_xc2028 xc5000 snd_cmipci game=
port snd_opl3_lib snd_hwdep snd_mpu401_uart tda9887 tuner_simple tuner_=
types mt20xx tea5761 msp3400 snd_hda_codec_realtek snd_hda_intel snd_hd=
a_codec snd_pcm_oss snd_mixer_oss snd_pcm saa7115 snd_seq_dummy snd_seq=
_oss snd_seq_midi snd_seq_midi_event snd_seq r8169 bttv uhci_hcd ivtv v=
ideobuf_dma_sg videobuf_core btcx_risc snd_rawmidi cx2341x i2c_algo_bit=
 snd_timer tveeprom mii rtc_cmos rtc_core rtc_lib snd_seq_device ehci_h=
cd snd usbcore soundcore snd_page_alloc [last unloaded: tvaudio]

Pid: 26877, comm: btrfs Tainted: P            2.6.36-aa1 #5 P35-S3G/P35=
-S3G
EIP: 0060:[<791338e4>] EFLAGS: 00010296 CPU: 1
EIP is at btrfs_print_leaf+0x14/0xb00
EAX: f2374000 EBX: 00000000 ECX: 091847f5 EDX: 00000000
ESI: f2374000 EDI: 00000065 EBP: 82d73abc ESP: 82d73988
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process btrfs (pid: 26877, ti=3D82d72000 task=3D79527120 task.ti=3D82d7=
2000)
Stack:
 f2374000 847f4000 00000091 00001000 000001af 00000000 00000021 0000100=
0
<0> 0000002b 00000000 00000000 847f4000 00000091 8ac1a000 00000091 0000=
0037
<0> e329489c 82d739ec 7912145f 00000002 00000001 e329489c 82d73a9f 82d7=
3a9f
Call Trace:
 [<7912145f>] ? unlock_up+0xcf/0xe0
 [<79126767>] ? btrfs_search_slot+0x537/0x630
 [<791316f0>] ? lookup_inline_extent_backref+0xd0/0x4f0
 [<79129fc8>] ? update_block_group+0xe8/0x2c0
 [<7913263c>] ? __btrfs_free_extent+0x60c/0x7d0
 [<791a8e18>] ? rb_erase+0x208/0x280
 [<79132d74>] ? run_clustered_refs+0x224/0x9d0
 [<79159ba9>] ? map_extent_buffer+0xb9/0xc0
 [<791335bd>] ? btrfs_run_delayed_refs+0x9d/0x170
 [<7913d590>] ? btrfs_commit_transaction+0x80/0x640
 [<791756bd>] ? tree_insert+0x6d/0x80
 [<79176f28>] ? btrfs_update_reloc_root+0x108/0x180
 [<79045840>] ? autoremove_wake_function+0x0/0x50
 [<79178315>] ? prepare_to_merge+0x215/0x230
 [<7917bfdb>] ? relocate_block_group+0x4db/0x5a0
 [<7917c181>] ? btrfs_relocate_block_group+0xe1/0x270
 [<791649c6>] ? btrfs_relocate_chunk+0x56/0x520
 [<791597cc>] ? unmap_extent_buffer+0xc/0x10
 [<7914f96d>] ? btrfs_item_offset+0xbd/0xc0
 [<791665ce>] ? btrfs_balance+0x21e/0x2b0
 [<7916aa32>] ? btrfs_ioctl+0x3f2/0x8f0
 [<79076d26>] ? lru_cache_add_lru+0x26/0x40
 [<7908232f>] ? handle_pte_fault+0x39f/0x600
 [<79083438>] ? __pte_alloc+0x78/0xd0
 [<7916a640>] ? btrfs_ioctl+0x0/0x8f0
 [<790aa833>] ? vfs_ioctl+0x33/0x50
 [<790aa9c5>] ? do_vfs_ioctl+0x85/0x530
 [<7901efec>] ? do_page_fault+0x14c/0x3e0
 [<790945fd>] ? follow_hugetlb_page+0x8d/0x260
 [<790aaed0>] ? sys_ioctl+0x60/0x70
 [<79002b50>] ? sysenter_do_call+0x12/0x26
Code: 75 f8 8b 7d fc 89 ec 5d c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00=
 00 55 89 e5 57 56 89 c6 53 81 ec 28 01 00 00 89 95 f0 fe ff ff <8b> 42=
 1c ba 03 00 00 00 e8 3f 03 ef ff 8b 50 60 89 95 3c ff ff=20
EIP: [<791338e4>] btrfs_print_leaf+0x14/0xb00 SS:ESP 0068:82d73988
CR2: 000000000000001c
---[ end trace 11a6d62f12dc6118 ]---


# btrfsck  /dev/sdc1
checksum verify failed on 625055924224 wanted C3DFFE41 found 9F99998
checksum verify failed on 625055924224 wanted C3DFFE41 found 9F99998
checksum verify failed on 625055924224 wanted C3DFFE41 found 9F99998
Segmentation fault

Is it a total write off or can a repair be made? I don't care about the
data,  as long as I can mount it and delete the corrupted files.

Regards,

Shane


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
