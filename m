Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36773 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbcADT0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jan 2016 14:26:09 -0500
Received: by mail-ob0-f178.google.com with SMTP id ba1so256148921obb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jan 2016 11:26:09 -0800 (PST)
MIME-Version: 1.0
From: Sylvain Joyeux <sylvain.joyeux@m4x.org>
Date: Mon, 4 Jan 2016 17:25:49 -0200
Message-ID: <CAFENT7K4ir7xNXw=a-=6v=WMyf-3AkGVpgT4ivV=CS54qPp9kg@mail.gmail.com>
Subject: Computer freezes, btrfs check reports bad extent ... type mismatch
 with chunk
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I currently have a btrfs partition that, when mounted, ends up
freezing my system. The only error I get when running btrfs check on
it is a whole lot of "bad extent ... type mismatch with chunk"

I've added the patch https://patchwork.kernel.org/patch/7687611/ on
top of btrfs-progs v4.3.1 (
7c3394ed9ef2063a7256d4bc078a485b6f826bc5), with no change.

dmesg reports first the following message twice

13:29:09 kernel: ------------[ cut here ]------------
13:29:09 kernel: WARNING: CPU: 0 PID: 6 at
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:6226
__btrfs_free_extent+0x83b/0xc40 [btrfs]()
13:29:09 kernel: Modules linked in: binfmt_misc cmac rfcomm bnep
bbswitch(OE) nls_iso8859_1 arc4 intel_rapl iosf_mbi
x86_pkg_temp_thermal intel_powerclamp coretemp dm_multipath
snd_hda_codec_realtek snd_hda_codec_hdmi scsi_dh snd_hda_codec_generic
kvm_intel kvm snd_hda_intel snd_hda_controller crct10dif_pclmul
crc32_pclmul iwlmvm snd_hda_codec snd_hda_core aesni_intel mac80211
aes_x86_64 lrw gf128mul glue_helper ablk_helper uvcvideo cryptd
snd_hwdep videobuf2_vmalloc videobuf2_memops snd_seq_midi snd_pcm
videobuf2_core snd_seq_midi_event v4l2_common videodev snd_rawmidi
serio_raw joydev media iwlwifi snd_seq thinkpad_acpi snd_seq_device
nvram btusb rtsx_pci_ms snd_timer cfg80211 btbcm btintel memstick
lpc_ich bluetooth snd soundcore mei_me mei shpchp ie31200_edac
edac_core mac_hid intel_rst parport_pc
13:29:09 kernel:  ppdev lp parport autofs4 btrfs raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq raid1 raid0 multipath linear hid_generic usbhid hid ses
enclosure uas usb_storage rtsx_pci_sdmmc i915 i2c_algo_bit
drm_kms_helper e1000e psmouse ahci drm ptp rtsx_pci libahci pps_core
wmi video
13:29:09 kernel: CPU: 0 PID: 6 Comm: kworker/u16:0 Tainted: G
 OE   4.1.15-040115-generic #201512150136
13:29:09 kernel: Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS
GLET81WW (2.35 ) 09/10/2015
13:29:09 kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
13:29:09 kernel:  ffffffffc03e1478 ffff88042beaba68 ffffffff817e3f7c
0000000000000007
13:29:09 kernel:  0000000000000000 ffff88042beabaa8 ffffffff81079b8a
000000001c098000
13:29:09 kernel:  0000000c0a108000 ffff88042bfb6000 ffff8803fc0aa1b0
00000000fffffffe
13:29:09 kernel: Call Trace:
13:29:09 kernel:  [<ffffffff817e3f7c>] dump_stack+0x45/0x57
13:29:09 kernel:  [<ffffffff81079b8a>] warn_slowpath_common+0x8a/0xc0
13:29:09 kernel:  [<ffffffff81079c7a>] warn_slowpath_null+0x1a/0x20
13:29:09 kernel:  [<ffffffffc03449ab>] __btrfs_free_extent+0x83b/0xc40 [btrfs]
13:29:09 kernel:  [<ffffffff811e19a7>] ? __slab_free+0xa7/0x2b0
13:29:09 kernel:  [<ffffffffc0349687>]
__btrfs_run_delayed_refs+0x9c7/0x1260 [btrfs]
13:29:09 kernel:  [<ffffffff811e19a7>] ? __slab_free+0xa7/0x2b0
13:29:09 kernel:  [<ffffffffc035e279>] ?
join_transaction.isra.13+0x129/0x420 [btrfs]
13:29:09 kernel:  [<ffffffffc034e303>]
btrfs_run_delayed_refs.part.68+0x73/0x270 [btrfs]
13:29:09 kernel:  [<ffffffffc034e5bc>] delayed_ref_async_start+0x8c/0xb0 [btrfs]
13:29:09 kernel:  [<ffffffffc0390cea>] btrfs_scrubnc_helper+0xca/0x2b0 [btrfs]
13:29:09 kernel:  [<ffffffffc0390efe>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
13:29:09 kernel:  [<ffffffff81093053>] process_one_work+0x163/0x4c0
13:29:09 kernel:  [<ffffffff81093408>] worker_thread+0x58/0x590
13:29:09 kernel:  [<ffffffff810933b0>] ? process_one_work+0x4c0/0x4c0
13:29:09 kernel:  [<ffffffff81099649>] kthread+0xc9/0xe0
13:29:09 kernel:  [<ffffffff81099580>] ? kthread_create_on_node+0x180/0x180
13:29:09 kernel:  [<ffffffff817eb4e2>] ret_from_fork+0x42/0x70
13:29:09 kernel:  [<ffffffff81099580>] ? kthread_create_on_node+0x180/0x180
13:29:09 kernel: ---[ end trace 04d0bdb5f352a0f1 ]---
13:29:09 kernel: BTRFS info (device sda5): leaf 51903889408 total ptrs
223 free space 2845
13:29:09 kernel:         item 0 key (51707002880 169 0) itemoff 16250
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 1 key (51707019264 169 0) itemoff 16217
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 2 key (51707035648 169 0) itemoff 16184
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 3 key (51707052032 169 0) itemoff 16151
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2923 flags 2
13:29:09 kernel:                 tree block backref root 7
13:29:09 kernel:         item 4 key (51707068416 169 0) itemoff 16118
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2923 flags 2
13:29:09 kernel:                 tree block backref root 7
13:29:09 kernel:         item 5 key (51707084800 169 0) itemoff 16076
itemsize 42
13:29:09 kernel:                 extent refs 2 gen 2827 flags 258
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 shared block backref parent 83540770816
13:29:09 kernel:         item 6 key (51707101184 169 0) itemoff 16043
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 7 key (51707117568 169 0) itemoff 16010
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 8 key (51707133952 169 0) itemoff 15968
itemsize 42
13:29:09 kernel:                 extent refs 2 gen 2827 flags 258
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 shared block backref parent 83540770816
13:29:09 kernel:         item 9 key (51707150336 169 0) itemoff 15926
itemsize 42
13:29:09 kernel:                 extent refs 2 gen 2827 flags 258
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 shared block backref parent 83540770816
13:29:09 kernel:         item 10 key (51707166720 169 0) itemoff 15893
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 11 key (51707183104 169 0) itemoff 15860
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 12 key (51707199488 169 0) itemoff 15827
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 13 key (51707215872 169 0) itemoff 15794
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 14 key (51707232256 169 0) itemoff 15761
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51698155520
13:29:09 kernel:         item 15 key (51707248640 169 0) itemoff 15728
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 16 key (51707265024 169 0) itemoff 15695
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 17 key (51707281408 169 0) itemoff 15662
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51819577344
13:29:09 kernel:         item 18 key (51707297792 169 0) itemoff 15629
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51819577344
13:29:09 kernel:         item 19 key (51707314176 169 1) itemoff 15533
itemsize 96
13:29:09 kernel:                 extent refs 8 gen 2963 flags 258
13:29:09 kernel:                 tree block backref root 787
13:29:09 kernel:                 tree block backref root 774
13:29:09 kernel:                 tree block backref root 773
13:29:09 kernel:                 tree block backref root 770
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 766
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:         item 20 key (51707330560 169 0) itemoff 15500
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83375194112
13:29:09 kernel:         item 21 key (51707346944 169 0) itemoff 15467
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 22 key (51707363328 169 0) itemoff 15434
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 23 key (51707379712 169 0) itemoff 15401
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 24 key (51707396096 169 0) itemoff 15368
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 25 key (51707412480 169 0) itemoff 15335
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 26 key (51707428864 169 0) itemoff 15302
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 27 key (51707445248 169 0) itemoff 15269
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 28 key (51707461632 169 0) itemoff 15236
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 29 key (51707478016 169 0) itemoff 15203
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 30 key (51707494400 169 0) itemoff 15170
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 31 key (51707510784 169 0) itemoff 15137
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 32 key (51707527168 169 0) itemoff 15104
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 33 key (51707543552 169 0) itemoff 15071
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 34 key (51707559936 169 0) itemoff 15038
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 35 key (51707576320 169 0) itemoff 15005
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 36 key (51707592704 169 0) itemoff 14972
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83375194112
13:29:09 kernel:         item 37 key (51707609088 169 0) itemoff 14939
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83375194112
13:29:09 kernel:         item 38 key (51707625472 169 0) itemoff 14906
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 39 key (51707641856 169 0) itemoff 14873
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 40 key (51707658240 169 0) itemoff 14840
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51819577344
13:29:09 kernel:         item 41 key (51707674624 169 0) itemoff 14807
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 42 key (51707691008 169 0) itemoff 14774
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 43 key (51707707392 169 0) itemoff 14741
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 44 key (51707723776 169 0) itemoff 14708
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 45 key (51707740160 169 0) itemoff 14675
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 46 key (51707756544 169 0) itemoff 14642
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 47 key (51707772928 169 0) itemoff 14609
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 48 key (51707789312 169 0) itemoff 14576
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 49 key (51707805696 169 0) itemoff 14543
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 50 key (51707822080 169 0) itemoff 14483
itemsize 60
13:29:09 kernel:                 extent refs 4 gen 2433 flags 258
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:                 tree block backref root 761
13:29:09 kernel:         item 51 key (51707838464 169 0) itemoff 14450
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 52 key (51707854848 169 0) itemoff 14417
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 53 key (51707871232 169 0) itemoff 14384
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 54 key (51707887616 169 0) itemoff 14351
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 55 key (51707904000 169 0) itemoff 14318
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 56 key (51707920384 169 0) itemoff 14285
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 57 key (51707936768 169 0) itemoff 14252
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 58 key (51707953152 169 0) itemoff 14219
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83445514240
13:29:09 kernel:         item 59 key (51707969536 169 0) itemoff 14186
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 60 key (51707985920 169 0) itemoff 14153
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83464437760
13:29:09 kernel:         item 61 key (51708002304 169 0) itemoff 14120
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83464437760
13:29:09 kernel:         item 62 key (51708018688 169 0) itemoff 14087
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83464437760
13:29:09 kernel:         item 63 key (51708035072 169 0) itemoff 14054
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 64 key (51708051456 169 0) itemoff 14012
itemsize 42
13:29:09 kernel:                 extent refs 2 gen 2461 flags 258
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 shared block backref parent 83540770816
13:29:09 kernel:         item 65 key (51708067840 169 0) itemoff 13979
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 66 key (51708084224 169 0) itemoff 13946
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 67 key (51708100608 169 0) itemoff 13913
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 68 key (51708116992 169 0) itemoff 13880
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83464437760
13:29:09 kernel:         item 69 key (51708133376 169 0) itemoff 13847
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83464437760
13:29:09 kernel:         item 70 key (51708149760 169 0) itemoff 13814
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 71 key (51708166144 169 0) itemoff 13781
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83464437760
13:29:09 kernel:         item 72 key (51708182528 169 0) itemoff 13748
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 73 key (51708198912 169 0) itemoff 13715
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 74 key (51708215296 169 0) itemoff 13682
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 75 key (51708231680 169 0) itemoff 13649
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83502923776
13:29:09 kernel:         item 76 key (51708248064 169 0) itemoff 13616
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 77 key (51708264448 169 0) itemoff 13583
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 78 key (51708280832 169 0) itemoff 13550
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83566739456
13:29:09 kernel:         item 79 key (51708297216 169 0) itemoff 13517
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 83566739456
13:29:09 kernel:         item 80 key (51708313600 169 0) itemoff 13484
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2923 flags 2
13:29:09 kernel:                 tree block backref root 2
13:29:09 kernel:         item 81 key (51708329984 169 0) itemoff 13451
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 82 key (51708346368 169 0) itemoff 13418
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 83 key (51708362752 169 0) itemoff 13385
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 97898102784
13:29:09 kernel:         item 84 key (51708379136 169 0) itemoff 13325
itemsize 60
13:29:09 kernel:                 extent refs 4 gen 2433 flags 258
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:                 tree block backref root 761
13:29:09 kernel:         item 85 key (51708395520 169 0) itemoff 13292
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 86 key (51708411904 169 0) itemoff 13259
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 87 key (51708428288 169 0) itemoff 13226
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 97898102784
13:29:09 kernel:         item 88 key (51708444672 169 0) itemoff 13193
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 89 key (51708461056 169 1) itemoff 13097
itemsize 96
13:29:09 kernel:                 extent refs 8 gen 2827 flags 258
13:29:09 kernel:                 tree block backref root 787
13:29:09 kernel:                 tree block backref root 774
13:29:09 kernel:                 tree block backref root 773
13:29:09 kernel:                 tree block backref root 770
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 766
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:         item 90 key (51708477440 169 0) itemoff 13064
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 91 key (51708493824 169 0) itemoff 13031
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 92 key (51708510208 169 0) itemoff 12989
itemsize 42
13:29:09 kernel:                 extent refs 2 gen 2461 flags 258
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 shared block backref parent 83540770816
13:29:09 kernel:         item 93 key (51708526592 169 0) itemoff 12956
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 94 key (51708542976 169 0) itemoff 12923
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 95 key (51708559360 169 0) itemoff 12890
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 96 key (51708575744 169 0) itemoff 12857
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 97 key (51708592128 169 0) itemoff 12824
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 98 key (51708608512 169 0) itemoff 12791
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 99 key (51708624896 169 0) itemoff 12758
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 100 key (51708641280 169 0) itemoff
12725 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 101 key (51708657664 169 0) itemoff
12692 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 102 key (51708674048 169 0) itemoff
12659 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 103 key (51708690432 169 0) itemoff
12626 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 2
13:29:09 kernel:                 tree block backref root 7
13:29:09 kernel:         item 104 key (51708706816 169 0) itemoff
12593 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 105 key (51708723200 169 0) itemoff
12560 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 106 key (51708739584 169 0) itemoff
12527 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 107 key (51708755968 169 0) itemoff
12494 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 108 key (51708772352 169 0) itemoff
12461 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 109 key (51708788736 169 0) itemoff
12428 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 110 key (51708805120 169 0) itemoff
12395 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 111 key (51708821504 169 0) itemoff
12362 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 112 key (51708837888 169 0) itemoff
12329 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 113 key (51708854272 169 0) itemoff
12296 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 114 key (51708870656 169 0) itemoff
12263 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 115 key (51708887040 169 0) itemoff
12230 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 116 key (51708903424 169 0) itemoff
12197 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 117 key (51708919808 169 0) itemoff
12164 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 118 key (51708936192 169 0) itemoff
12131 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 119 key (51708952576 169 0) itemoff
12098 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 120 key (51708968960 169 0) itemoff
12065 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 121 key (51708985344 169 0) itemoff
12032 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 122 key (51709001728 169 0) itemoff
11999 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 123 key (51709018112 169 0) itemoff
11966 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 124 key (51709034496 169 0) itemoff
11933 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 125 key (51709050880 169 0) itemoff
11900 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 2
13:29:09 kernel:                 tree block backref root 7
13:29:09 kernel:         item 126 key (51709067264 169 0) itemoff
11867 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 127 key (51709083648 169 0) itemoff
11834 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 128 key (51709100032 169 0) itemoff
11801 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2523 flags 2
13:29:09 kernel:                 tree block backref root 7
13:29:09 kernel:         item 129 key (51709116416 169 0) itemoff
11768 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 130 key (51709132800 169 0) itemoff
11735 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 131 key (51709149184 169 0) itemoff
11702 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 132 key (51709165568 169 0) itemoff
11669 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 133 key (51709181952 169 0) itemoff
11636 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 2
13:29:09 kernel:                 tree block backref root 7
13:29:09 kernel:         item 134 key (51709198336 169 0) itemoff
11603 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 135 key (51709214720 169 0) itemoff
11570 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 136 key (51709231104 169 0) itemoff
11537 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 137 key (51709247488 169 0) itemoff
11504 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 138 key (51709263872 169 0) itemoff
11471 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 139 key (51709280256 169 0) itemoff
11438 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 140 key (51709296640 169 0) itemoff
11405 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 141 key (51709313024 169 0) itemoff
11372 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 142 key (51709329408 169 0) itemoff
11285 itemsize 87
13:29:09 kernel:                 extent refs 7 gen 2154 flags 258
13:29:09 kernel:                 tree block backref root 787
13:29:09 kernel:                 tree block backref root 774
13:29:09 kernel:                 tree block backref root 773
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 766
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:         item 143 key (51709345792 169 0) itemoff
11252 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 144 key (51709362176 169 0) itemoff
11219 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 145 key (51709378560 169 0) itemoff
11186 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 146 key (51709394944 169 0) itemoff
11153 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 147 key (51709411328 169 0) itemoff
11120 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 148 key (51709427712 169 0) itemoff
11087 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 149 key (51709444096 169 0) itemoff
11054 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 150 key (51709460480 169 0) itemoff
11021 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 151 key (51709476864 169 0) itemoff
10988 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 152 key (51709493248 169 0) itemoff
10955 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 153 key (51709509632 169 0) itemoff
10922 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 154 key (51709526016 169 0) itemoff
10889 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 155 key (51709542400 169 0) itemoff
10856 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 156 key (51709558784 169 0) itemoff
10823 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 157 key (51709575168 169 0) itemoff
10790 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51826933760
13:29:09 kernel:         item 158 key (51709591552 169 0) itemoff
10757 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 159 key (51709607936 169 0) itemoff
10724 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51708461056
13:29:09 kernel:         item 160 key (51709624320 169 1) itemoff
10628 itemsize 96
13:29:09 kernel:                 extent refs 8 gen 2827 flags 258
13:29:09 kernel:                 tree block backref root 787
13:29:09 kernel:                 tree block backref root 774
13:29:09 kernel:                 tree block backref root 773
13:29:09 kernel:                 tree block backref root 770
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 766
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:         item 161 key (51709640704 169 0) itemoff
10595 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51709624320
13:29:09 kernel:         item 162 key (51709657088 169 0) itemoff
10562 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51709624320
13:29:09 kernel:         item 163 key (51709673472 169 0) itemoff
10529 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51709624320
13:29:09 kernel:         item 164 key (51709689856 169 0) itemoff
10496 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51826933760
13:29:09 kernel:         item 165 key (51709706240 169 0) itemoff
10463 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51709624320
13:29:09 kernel:         item 166 key (51709722624 169 0) itemoff
10430 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51826933760
13:29:09 kernel:         item 167 key (51709739008 169 0) itemoff
10397 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2827 flags 258
13:29:09 kernel:                 shared block backref parent 51709624320
13:29:09 kernel:         item 168 key (51709755392 169 0) itemoff
10364 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 169 key (51709771776 169 0) itemoff
10331 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 170 key (51709788160 169 0) itemoff
10298 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51826933760
13:29:09 kernel:         item 171 key (51709804544 169 0) itemoff
10265 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 172 key (51709820928 169 0) itemoff
10232 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 173 key (51709837312 169 0) itemoff
10199 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 174 key (51709853696 169 0) itemoff
10166 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 175 key (51709870080 169 0) itemoff
10133 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 176 key (51709886464 169 0) itemoff
10100 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 177 key (51709902848 169 0) itemoff
10067 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 178 key (51709919232 169 0) itemoff
10034 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 179 key (51709935616 169 0) itemoff
10001 itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 180 key (51709952000 169 0) itemoff 9968
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 181 key (51709968384 169 0) itemoff 9935
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 182 key (51709984768 169 0) itemoff 9902
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 183 key (51710001152 169 0) itemoff 9869
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 184 key (51710017536 169 0) itemoff 9836
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 185 key (51710033920 169 0) itemoff 9803
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 186 key (51710050304 169 0) itemoff 9770
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 187 key (51710066688 169 0) itemoff 9737
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 188 key (51710083072 169 0) itemoff 9704
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 189 key (51710099456 169 0) itemoff 9671
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 190 key (51710132224 169 0) itemoff 9638
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2461 flags 258
13:29:09 kernel:                 shared block backref parent 52071596032
13:29:09 kernel:         item 191 key (51710148608 169 0) itemoff 9605
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 192 key (51710181376 169 0) itemoff 9572
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 2
13:29:09 kernel:         item 193 key (51710197760 169 0) itemoff 9539
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 194 key (51710214144 169 0) itemoff 9506
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 3100 flags 2
13:29:09 kernel:                 tree block backref root 786
13:29:09 kernel:         item 195 key (51710230528 169 0) itemoff 9473
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 196 key (51710246912 169 0) itemoff 9413
itemsize 60
13:29:09 kernel:                 extent refs 4 gen 2433 flags 258
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:                 tree block backref root 761
13:29:09 kernel:         item 197 key (51710263296 169 0) itemoff 9380
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 198 key (51710279680 169 0) itemoff 9347
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 199 key (51710296064 169 0) itemoff 9314
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 76 flags 258
13:29:09 kernel:                 shared block backref parent 51967885312
13:29:09 kernel:         item 200 key (51710312448 169 0) itemoff 9254
itemsize 60
13:29:09 kernel:                 extent refs 4 gen 2433 flags 258
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:                 tree block backref root 761
13:29:09 kernel:         item 201 key (51710328832 169 0) itemoff 9194
itemsize 60
13:29:09 kernel:                 extent refs 4 gen 2433 flags 258
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:                 tree block backref root 761
13:29:09 kernel:         item 202 key (51710345216 169 0) itemoff 9134
itemsize 60
13:29:09 kernel:                 extent refs 4 gen 2433 flags 258
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:                 tree block backref root 761
13:29:09 kernel:         item 203 key (51710361600 169 0) itemoff 9101
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 204 key (51710377984 169 0) itemoff 9068
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 205 key (51710394368 169 0) itemoff 9035
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51826933760
13:29:09 kernel:         item 206 key (51710410752 169 0) itemoff 9002
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 2963 flags 258
13:29:09 kernel:                 shared block backref parent 51707314176
13:29:09 kernel:         item 207 key (51710427136 169 0) itemoff 8942
itemsize 60
13:29:09 kernel:                 extent refs 4 gen 2433 flags 258
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:                 tree block backref root 761
13:29:09 kernel:         item 208 key (51710443520 169 0) itemoff 8909
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 209 key (51710459904 169 0) itemoff 8876
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 210 key (51710476288 169 0) itemoff 8843
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 211 key (51710492672 169 0) itemoff 8810
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 212 key (51710509056 169 0) itemoff 8750
itemsize 60
13:29:09 kernel:                 extent refs 4 gen 2433 flags 258
13:29:09 kernel:                 tree block backref root 769
13:29:09 kernel:                 tree block backref root 765
13:29:09 kernel:                 tree block backref root 762
13:29:09 kernel:                 tree block backref root 761
13:29:09 kernel:         item 213 key (51710525440 169 0) itemoff 8717
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 214 key (51710541824 169 0) itemoff 8684
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 215 key (51710558208 169 0) itemoff 8651
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 216 key (51710574592 169 0) itemoff 8618
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 217 key (51710590976 169 0) itemoff 8585
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 218 key (51710607360 169 0) itemoff 8552
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 219 key (51710623744 169 0) itemoff 8519
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 220 key (51710640128 169 0) itemoff 8486
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 221 key (51710656512 169 0) itemoff 8453
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel:         item 222 key (51710672896 169 0) itemoff 8420
itemsize 33
13:29:09 kernel:                 extent refs 1 gen 70 flags 258
13:29:09 kernel:                 shared block backref parent 51824230400
13:29:09 kernel: BTRFS error (device sda5): unable to find ref byte nr
51708461056 parent 0 root 761  owner 1 offset 0
13:29:09 kernel: ------------[ cut here ]------------


and then around 10 000 times the following message in less than 30s
(until I forcefully killed the program responsible)

13:29:09 kernel: WARNING: CPU: 0 PID: 6 at
/home/kernel/COD/linux/fs/btrfs/delayed-ref.c:438
btrfs_select_ref_head+0x11f/0x130 [btrfs]()
13:29:09 kernel: Modules linked in: binfmt_misc cmac rfcomm bnep
bbswitch(OE) nls_iso8859_1 arc4 intel_rapl iosf_mbi
x86_pkg_temp_thermal intel_powerclamp coretemp dm_multipath
snd_hda_codec_realtek snd_hda_codec_hdmi scsi_dh snd_hda_codec_generic
kvm_intel kvm snd_hda_intel snd_hda_controller crct10dif_pclmul
crc32_pclmul iwlmvm snd_hda_codec snd_hda_core aesni_intel mac80211
aes_x86_64 lrw gf128mul glue_helper ablk_helper uvcvideo cryptd
snd_hwdep videobuf2_vmalloc videobuf2_memops snd_seq_midi snd_pcm
videobuf2_core snd_seq_midi_event v4l2_common videodev snd_rawmidi
serio_raw joydev media iwlwifi snd_seq thinkpad_acpi snd_seq_device
nvram btusb rtsx_pci_ms snd_timer cfg80211 btbcm btintel memstick
lpc_ich bluetooth snd soundcore mei_me mei shpchp ie31200_edac
edac_core mac_hid intel_rst parport_pc
13:29:09 kernel:  ppdev lp parport autofs4 btrfs raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq raid1 raid0 multipath linear hid_generic usbhid hid ses
enclosure uas usb_storage rtsx_pci_sdmmc i915 i2c_algo_bit
drm_kms_helper e1000e psmouse ahci drm ptp rtsx_pci libahci pps_core
wmi video
13:29:09 kernel: CPU: 0 PID: 6 Comm: kworker/u16:0 Tainted: G        W
 OE   4.1.15-040115-generic #201512150136
13:29:09 kernel: Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS
GLET81WW (2.35 ) 09/10/2015
13:29:09 kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
13:29:09 kernel:  ffffffffc03e4b48 ffff88042beabb48 ffffffff817e3f7c
0000000000000007
13:29:09 kernel:  0000000000000000 ffff88042beabb88 ffffffff81079b8a
ffff88042beabbc8
13:29:09 kernel:  ffff8800b0ff7aa0 ffff8804262e0168 0000000000000000
ffff8804262e0290
13:29:09 kernel: Call Trace:
13:29:09 kernel:  [<ffffffff817e3f7c>] dump_stack+0x45/0x57
13:29:09 kernel:  [<ffffffff81079b8a>] warn_slowpath_common+0x8a/0xc0
13:29:09 kernel:  [<ffffffff81079c7a>] warn_slowpath_null+0x1a/0x20
13:29:09 kernel:  [<ffffffffc03ad38f>] btrfs_select_ref_head+0x11f/0x130 [btrfs]
13:29:09 kernel:  [<ffffffffc0348ec5>]
__btrfs_run_delayed_refs+0x205/0x1260 [btrfs]
13:29:09 kernel:  [<ffffffffc034e303>]
btrfs_run_delayed_refs.part.68+0x73/0x270 [btrfs]
13:29:09 kernel:  [<ffffffffc034e5bc>] delayed_ref_async_start+0x8c/0xb0 [btrfs]
13:29:09 kernel:  [<ffffffffc0390cea>] btrfs_scrubnc_helper+0xca/0x2b0 [btrfs]
13:29:09 kernel:  [<ffffffffc0390efe>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
13:29:09 kernel:  [<ffffffff81093053>] process_one_work+0x163/0x4c0
13:29:09 kernel:  [<ffffffff81093408>] worker_thread+0x58/0x590
13:29:09 kernel:  [<ffffffff810933b0>] ? process_one_work+0x4c0/0x4c0
13:29:09 kernel:  [<ffffffff81099649>] kthread+0xc9/0xe0
13:29:09 kernel:  [<ffffffff81099580>] ? kthread_create_on_node+0x180/0x180
13:29:09 kernel:  [<ffffffff817eb4e2>] ret_from_fork+0x42/0x70
13:29:09 kernel:  [<ffffffff81099580>] ? kthread_create_on_node+0x180/0x180
13:29:09 kernel: ---[ end trace 04d0bdb5f352a0f5 ]---

Regards,
Sylvain
