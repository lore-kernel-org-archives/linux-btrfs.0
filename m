Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63492 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbbAHPLj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jan 2015 10:11:39 -0500
Received: by mail-pa0-f51.google.com with SMTP id ey11so12260328pad.10
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 07:11:38 -0800 (PST)
Received: from t440p.localnet (203-219-130-111.static.tpgi.com.au. [203.219.130.111])
        by mx.google.com with ESMTPSA id y3sm4713416pbt.44.2015.01.08.07.11.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jan 2015 07:11:37 -0800 (PST)
From: "Reuben D'Netto" <rdnetto@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: 'parent transid verify failed' for 13637 missing transactions, resulting in 'BTRFS: Transaction aborted'
Date: Fri, 09 Jan 2015 02:11:21 +1100
Message-ID: <5167281.Xn5haVTIHm@t440p>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have a btrfs volume in RAID0 across 2 SSDs which has (for no apparent reason) become corrupted. Although I am able to mount the partition, there are several messages displayed in the kernel log when doing so.
I have copied the files off the file system, but would like to know if they can be relied upon or not (and if not, which ones are corrupt). I would also like to know if the file system itself is recoverable, or should be erased entirely and replaced.
I have tried 'btrfs check --repair' and btrfs-zero-log to no avail. The SMART data for both drives suggests there are no issues with the hardware.

Thanks in advance.


Distro: Sabayon amd64
Kernel in use when corruption occurred: 3.17.4
Kernel in use when collecting diagnostic info: 3.16.0-23-generic (Ubuntu livecd)
Btrfs-progs version: 3.18


btrfs fi df: (Used space is incorrect - should be at least 30 GB)
Data, RAID0: total=93.16GiB, used=25.19MiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=8.01GiB, used=73.81MiB
unknown, single: total=16.00MiB, used=16.00KiB


btrfs fi show: (truncated to show relevant filesystem only)
Label: none  uuid: d75ecf88-9b18-4ca6-8fd4-7bda0630de9b
        Total devices 2 FS bytes used 73.81MiB
        devid    1 size 54.62GiB used 54.62GiB path /dev/sda1
        devid    2 size 54.62GiB used 54.62GiB path /dev/sdb1


Kernel log when mounting file system:
[  106.564009] BTRFS info (device sda1): disk space caching is enabled
[  106.577597] BTRFS: detected SSD devices, enabling SSD mode
[  106.578440] BTRFS: checking UUID tree
[  106.581198] parent transid verify failed on 168079851520 wanted 6329580 found 6343217
[  106.581857] parent transid verify failed on 168079851520 wanted 6329580 found 6343217
[  106.581880] BTRFS warning (device sda1): btrfs_uuid_tree_iterate failed -12


When unmounting:
[  113.814408] ------------[ cut here ]------------
[  113.814454] WARNING: CPU: 0 PID: 3872 at /build/buildd/linux-3.16.0/fs/btrfs/extent-tree.c:5956 __btrfs_free_extent+0x675/0xc00 [btrfs]()
[  113.814460] Modules linked in: joydev btrfs dm_crypt xor snd_hda_codec_hdmi raid6_pq dm_multipath scsi_dh kvm_amd kvm snd_seq_midi snd_hda_codec_realtek snd_seq_midi_event snd_hda_codec_generic snd_rawmidi edac_core snd_hda_intel snd_hda_controller k10temp serio_raw edac_mce_amd snd_seq snd_hda_codec bnep snd_hwdep rfcomm snd_seq_device snd_pcm bluetooth snd_timer snd 6lowpan_iphc sp5100_tco soundcore i2c_piix4 shpchp mac_hid parport_pc ppdev lp parport squashfs overlayfs nls_utf8 isofs jfs xfs libcrc32c reiserfs dm_mirror dm_region_hash dm_log hid_generic nouveau mxm_wmi video i2c_algo_bit ttm usbhid drm_kms_helper pata_acpi firewire_ohci tg3 hid firewire_core r8169 drm ahci ptp crc_itu_t mii pata_jmicron libahci pps_core wmi
[  113.814558] CPU: 0 PID: 3872 Comm: umount Tainted: G        W     3.16.0-23-generic #31-Ubuntu
[  113.814564] Hardware name: Gigabyte Technology Co., Ltd. GA-870A-UD3/GA-870A-UD3, BIOS F5 08/01/2011
[  113.814569]  0000000000000009 ffff8800bd5afa28 ffffffff8177fcbc 0000000000000000
[  113.814577]  ffff8800bd5afa60 ffffffff8106fd8d 000000218f175000 ffff8800cb98f000
[  113.814584]  ffff8800a80e9000 00000000fffffffe 0000000000000000 ffff8800bd5afa70
[  113.814591] Call Trace:
[  113.814605]  [<ffffffff8177fcbc>] dump_stack+0x45/0x56
[  113.814615]  [<ffffffff8106fd8d>] warn_slowpath_common+0x7d/0xa0
[  113.814623]  [<ffffffff8106fe6a>] warn_slowpath_null+0x1a/0x20
[  113.814651]  [<ffffffffc0d15345>] __btrfs_free_extent+0x675/0xc00 [btrfs]
[  113.814661]  [<ffffffff811c16a6>] ? __slab_free+0xa6/0x320
[  113.814690]  [<ffffffffc0d1a044>] __btrfs_run_delayed_refs+0x424/0x11e0 [btrfs]
[  113.814721]  [<ffffffffc0d1edf3>] btrfs_run_delayed_refs.part.64+0x73/0x270 [btrfs]
[  113.814750]  [<ffffffffc0d1f51d>] btrfs_write_dirty_block_groups+0x46d/0x710 [btrfs]
[  113.814784]  [<ffffffffc0d2d64d>] commit_cowonly_roots+0x18d/0x240 [btrfs]
[  113.814818]  [<ffffffffc0d301ad>] btrfs_commit_transaction.part.22+0x49d/0x970 [btrfs]
[  113.814852]  [<ffffffffc0d2f27a>] btrfs_commit_transaction+0x3a/0x80 [btrfs]
[  113.814875]  [<ffffffffc0cfe760>] btrfs_sync_fs+0x50/0xc0 [btrfs]
[  113.814884]  [<ffffffff81211a82>] sync_filesystem+0x72/0xb0
[  113.814891]  [<ffffffff811e2d50>] generic_shutdown_super+0x30/0xf0
[  113.814897]  [<ffffffff811e30a2>] kill_anon_super+0x12/0x20
[  113.814920]  [<ffffffffc0d01e86>] btrfs_kill_super+0x16/0x90 [btrfs]
[  113.814926]  [<ffffffff811e3429>] deactivate_locked_super+0x49/0x60
[  113.814932]  [<ffffffff811e3874>] deactivate_super+0x64/0x70
[  113.814940]  [<ffffffff812015ef>] mntput_no_expire+0xdf/0x180
[  113.814947]  [<ffffffff81202bac>] SyS_umount+0x8c/0x100
[  113.814954]  [<ffffffff81787ced>] system_call_fastpath+0x1a/0x1f
[  113.814959] ---[ end trace 328a5b6c02402780 ]---
[  113.814967] BTRFS info (device sda1): leaf 104182874112 total ptrs 209 free space 75
[  113.814973]  item 0 key (140680462336 168 16384) itemoff 16232 itemsize 51
[  113.814978]          extent refs 1 gen 37441104 flags 2
[  113.814983]          tree block key (204243845120 0 0) level 0
[  113.814986]          tree block backref root 354
[  113.814992]  item 1 key (140680478720 168 16384) itemoff 16181 itemsize 51
[  113.814996]          extent refs 1 gen 104182513664 flags 2
[  113.815000]          tree block key (104182513664 0 0) level 24
[  113.815003]          tree block backref root 353
[  113.815008]  item 2 key (140680495104 168 16384) itemoff 16130 itemsize 51
[  113.815011]          extent refs 1 gen 104182513664 flags 2
[  113.815015]          tree block key (104182513664 0 0) level 24
[  113.815018]          tree block backref root 352
[  113.815023]  item 3 key (140680511488 168 16384) itemoff 16079 itemsize 51
[  113.815027]          extent refs 1 gen 104588148736 flags 2
[  113.815030]          tree block key (0 0 0) level 0
[  113.815033]          tree block backref root 351
[  113.815038]  item 4 key (140680708096 168 16384) itemoff 16028 itemsize 51
[  113.815041]          extent refs 1 gen 0 flags 2
[  113.815045]          tree block key (0 0 0) level 0
[  113.815048]          tree block backref root 341
[  113.815052]  item 5 key (140681232384 168 16384) itemoff 15977 itemsize 51
[  113.815056]          extent refs 1 gen 0 flags 2
[  113.815059]          tree block key (0 0 0) level 0
[  113.815062]          tree block backref root 341
[  113.815067]  item 6 key (140681248768 168 16384) itemoff 15926 itemsize 51
[  113.815070]          extent refs 1 gen 96 flags 2
[  113.815074]          tree block key (38067488 0 0) level 0
[  113.815077]          tree block backref root 353
[  113.815081]  item 7 key (140682035200 168 16384) itemoff 15866 itemsize 60
[  113.815085]          extent refs 2 gen 0 flags 2
[  113.815088]          tree block key (576 0 0) level 0
[  113.815091]          tree block backref root 395
[  113.815094]          tree block backref root 357
[  113.815099]  item 8 key (140682297344 168 16384) itemoff 15815 itemsize 51
[  113.815102]          extent refs 1 gen 0 flags 2
[  113.815106]          tree block key (96 0 0) level 0
[  113.815108]          tree block backref root 357
[  113.815113]  item 9 key (140682330112 168 16384) itemoff 15764 itemsize 51
[  113.815117]          extent refs 1 gen 140024299520 flags 2
[  113.815120]          tree block key (0 0 0) level 0
[  113.815123]          tree block backref root 395
[  113.815128]  item 10 key (140682592256 168 16384) itemoff 15713 itemsize 51
[  113.815131]          extent refs 1 gen 0 flags 2
[  113.815135]          tree block key (0 0 0) level 0
[  113.815138]          tree block backref root 357
[  113.815142]  item 11 key (140682805248 168 16384) itemoff 15662 itemsize 51
[  113.815146]          extent refs 1 gen 0 flags 2
[  113.815149]          tree block key (0 0 0) level 0
[  113.815152]          tree block backref root 352
[  113.815157]  item 12 key (140682838016 168 16384) itemoff 15611 itemsize 51
[  113.815160]          extent refs 1 gen 0 flags 2
[  113.815164]          tree block key (0 0 0) level 0
[  113.815166]          tree block backref root 353
[  113.815171]  item 13 key (140683837440 168 16384) itemoff 15560 itemsize 51
[  113.815175]          extent refs 1 gen 40244592 flags 2
[  113.815178]          tree block key (173838434304 0 0) level 0
[  113.815181]          tree block backref root 353
[  113.815186]  item 14 key (140683870208 168 16384) itemoff 15509 itemsize 51
[  113.815190]          extent refs 1 gen 41294640 flags 2
[  113.815193]          tree block key (125891264512 0 0) level 0
[  113.815196]          tree block backref root 352
[  113.815201]  item 15 key (140683886592 168 16384) itemoff 15458 itemsize 51
[  113.815205]          extent refs 1 gen 117027602432 flags 2
[  113.815208]          tree block key (117027602432 0 0) level 27
[  113.815211]          tree block backref root 354
[  113.815216]  item 16 key (140683902976 168 16384) itemoff 15407 itemsize 51
[  113.815219]          extent refs 1 gen 0 flags 2
[  113.815223]          tree block key (192 0 0) level 0
[  113.815226]          tree block backref root 355
[  113.815230]  item 17 key (140683919360 168 16384) itemoff 15356 itemsize 51
[  113.815234]          extent refs 1 gen 0 flags 2
[  113.815237]          tree block key (192 0 0) level 0
[  113.815240]          tree block backref root 356
[  113.815245]  item 18 key (140683935744 168 16384) itemoff 15305 itemsize 51
[  113.815248]          extent refs 1 gen 192 flags 2
[  113.815252]          tree block key (38032352 0 0) level 0
[  113.815255]          tree block backref root 351
[  113.815259]  item 19 key (140683952128 168 16384) itemoff 15254 itemsize 51
[  113.815263]          extent refs 1 gen 104182513664 flags 2
[  113.815267]          tree block key (104182513664 0 0) level 24
[  113.815270]          tree block backref root 395
[  113.815274]  item 20 key (140683968512 168 16384) itemoff 15203 itemsize 51
[  113.815278]          extent refs 1 gen 37271760 flags 2
[  113.815282]          tree block key (104182513664 0 0) level 5
[  113.815285]          tree block backref root 357
[  113.815289]  item 21 key (140684754944 168 16384) itemoff 15152 itemsize 51
[  113.815293]          extent refs 1 gen 37271760 flags 2
[  113.815297]          tree block key (104182513664 0 0) level 20
[  113.815300]          tree block backref root 357
[  113.815304]  item 22 key (140685164544 168 16384) itemoff 15101 itemsize 51
[  113.815308]          extent refs 1 gen 40183632 flags 2
[  113.815312]          tree block key (173859586048 0 0) level 0
[  113.815315]          tree block backref root 352
[  113.815319]  item 23 key (140685869056 168 16384) itemoff 15050 itemsize 51
[  113.815323]          extent refs 1 gen 41299824 flags 2
[  113.815327]          tree block key (116690583552 0 0) level 0
[  113.815330]          tree block backref root 351
[  113.815334]  item 24 key (140686163968 168 16384) itemoff 14999 itemsize 51
[  113.815338]          extent refs 1 gen 104182513664 flags 2
[  113.815342]          tree block key (104182513664 0 0) level 45
[  113.815345]          tree block backref root 395
[  113.815349]  item 25 key (140686475264 168 16384) itemoff 14948 itemsize 51
[  113.815353]          extent refs 1 gen 0 flags 2
[  113.815356]          tree block key (116979908608 0 0) level 0
[  113.815359]          tree block backref root 351
[  113.815364]  item 26 key (140686737408 168 16384) itemoff 14897 itemsize 51
[  113.815367]          extent refs 1 gen 0 flags 2
[  113.815371]          tree block key (140559319040 0 0) level 0
[  113.815374]          tree block backref root 351
[  113.815379]  item 27 key (140687261696 168 16384) itemoff 14846 itemsize 51
[  113.815382]          extent refs 1 gen 0 flags 2
[  113.815386]          tree block key (288 0 0) level 0
[  113.815388]          tree block backref root 341
[  113.815393]  item 28 key (140687605760 168 16384) itemoff 14795 itemsize 51
[  113.815397]          extent refs 1 gen 0 flags 2
[  113.815400]          tree block key (192 0 0) level 0
[  113.815403]          tree block backref root 341
[  113.815407]  item 29 key (140688162816 168 16384) itemoff 14744 itemsize 51
[  113.815411]          extent refs 1 gen 0 flags 2
[  113.815415]          tree block key (96 0 0) level 0
[  113.815417]          tree block backref root 341
[  113.815422]  item 30 key (140688556032 168 16384) itemoff 14693 itemsize 51
[  113.815426]          extent refs 1 gen 0 flags 2
[  113.815429]          tree block key (0 0 0) level 0
[  113.815432]          tree block backref root 353
[  113.815436]  item 31 key (140688588800 168 16384) itemoff 14642 itemsize 51
[  113.815440]          extent refs 1 gen 0 flags 2
[  113.815443]          tree block key (192 0 0) level 0
[  113.815446]          tree block backref root 356
[  113.815451]  item 32 key (140688605184 168 16384) itemoff 14591 itemsize 51
[  113.815454]          extent refs 1 gen 0 flags 2
[  113.815458]          tree block key (192 0 0) level 0
[  113.815461]          tree block backref root 354
[  113.815465]  item 33 key (140688621568 168 16384) itemoff 14540 itemsize 51
[  113.815469]          extent refs 1 gen 480 flags 2
[  113.815472]          tree block key (40040384 0 0) level 0
[  113.815475]          tree block backref root 355
[  113.815480]  item 34 key (140688637952 168 16384) itemoff 14489 itemsize 51
[  113.815484]          extent refs 1 gen 37271760 flags 2
[  113.815487]          tree block key (104182513664 0 0) level 16
[  113.815490]          tree block backref root 352
[  113.815495]  item 35 key (140688654336 168 16384) itemoff 14438 itemsize 51
[  113.815499]          extent refs 1 gen 41311344 flags 2
[  113.815502]          tree block key (126510792704 0 0) level 0
[  113.815505]          tree block backref root 351
[  113.815510]  item 36 key (140688736256 168 16384) itemoff 14387 itemsize 51
[  113.815513]          extent refs 1 gen 0 flags 2
[  113.815517]          tree block key (0 0 0) level 0
[  113.815519]          tree block backref root 352
[  113.815524]  item 37 key (140688801792 168 16384) itemoff 14336 itemsize 51
[  113.815528]          extent refs 1 gen 0 flags 2
[  113.815531]          tree block key (384 0 0) level 0
[  113.815534]          tree block backref root 351
[  113.815538]  item 38 key (140689375232 168 16384) itemoff 14285 itemsize 51
[  113.815542]          extent refs 1 gen 0 flags 2
[  113.815545]          tree block key (96 0 0) level 0
[  113.815548]          tree block backref root 341
[  113.815553]  item 39 key (140689539072 192 2147483648) itemoff 14261 itemsize 24
[  113.815557]          block group used 0
[  113.815562]  item 40 key (142837022720 192 2147483648) itemoff 14237 itemsize 24
[  113.815565]          block group used 0
[  113.815570]  item 41 key (144984506368 192 2147483648) itemoff 14213 itemsize 24
[  113.815573]          block group used 0
[  113.815578]  item 42 key (147131990016 192 2147483648) itemoff 14189 itemsize 24
[  113.815580]          block group used 0
[  113.815585]  item 43 key (149279473664 192 2147483648) itemoff 14165 itemsize 24
[  113.815588]          block group used 0
[  113.815592]  item 44 key (151426957312 192 2147483648) itemoff 14141 itemsize 24
[  113.815595]          block group used 0
[  113.815599]  item 45 key (153574440960 192 2147483648) itemoff 14117 itemsize 24
[  113.815602]          block group used 0
[  113.815607]  item 46 key (155721924608 192 1073741824) itemoff 14093 itemsize 24
[  113.815610]          block group used 21037056
[  113.815615]  item 47 key (155722104832 168 16384) itemoff 14042 itemsize 51
[  113.815618]          extent refs 1 gen 0 flags 2
[  113.815622]          tree block key (140554878976 0 0) level 0
[  113.815625]          tree block backref root 351
[  113.815629]  item 48 key (155722727424 168 16384) itemoff 13991 itemsize 51
[  113.815633]          extent refs 1 gen 40672544 flags 2
[  113.815637]          tree block key (0 0 0) level 0
[  113.815639]          tree block backref root 355
[  113.815644]  item 49 key (155723137024 168 16384) itemoff 13940 itemsize 51
[  113.815648]          extent refs 1 gen 0 flags 2
[  113.815651]          tree block key (193923497984 0 0) level 0
[  113.815654]          tree block backref root 353
[  113.815659]  item 50 key (155723431936 168 16384) itemoff 13889 itemsize 51
[  113.815662]          extent refs 1 gen 39842144 flags 2
[  113.815666]          tree block key (0 0 0) level 0
[  113.815668]          tree block backref root 355
[  113.815673]  item 51 key (155723628544 168 16384) itemoff 13838 itemsize 51
[  113.815677]          extent refs 1 gen 0 flags 2
[  113.815680]          tree block key (1536 0 0) level 0
[  113.815683]          tree block backref root 356
[  113.815687]  item 52 key (155723644928 168 16384) itemoff 13787 itemsize 51
[  113.815691]          extent refs 1 gen 0 flags 2
[  113.815695]          tree block key (39660128 0 0) level 0
[  113.815697]          tree block backref root 355
[  113.815702]  item 53 key (155723710464 168 16384) itemoff 13736 itemsize 51
[  113.815705]          extent refs 1 gen 0 flags 2
[  113.815709]          tree block key (0 0 0) level 0
[  113.815712]          tree block backref root 353
[  113.815716]  item 54 key (155724136448 168 16384) itemoff 13685 itemsize 51
[  113.815720]          extent refs 1 gen 116396572672 flags 2
[  113.815723]          tree block key (0 0 0) level 0
[  113.815726]          tree block backref root 354
[  113.815731]  item 55 key (155724414976 168 16384) itemoff 13634 itemsize 51
[  113.815734]          extent refs 1 gen 0 flags 2
[  113.815738]          tree block key (0 0 0) level 0
[  113.815740]          tree block backref root 354
[  113.815745]  item 56 key (155724562432 168 16384) itemoff 13583 itemsize 51
[  113.815748]          extent refs 1 gen 0 flags 2
[  113.815752]          tree block key (384 0 0) level 0
[  113.815755]          tree block backref root 357
[  113.815759]  item 57 key (155725430784 168 16384) itemoff 13532 itemsize 51
[  113.815763]          extent refs 1 gen 0 flags 2
[  113.815766]          tree block key (168051736576 0 0) level 0
[  113.815769]          tree block backref root 352
[  113.815774]  item 58 key (155725840384 168 16384) itemoff 13481 itemsize 51
[  113.815778]          extent refs 1 gen 30399297484751162 flags 2
[  113.815782]          tree block key (13690942867264115776 0 0) level 0
[  113.815784]          tree block backref root 357
[  113.815789]  item 59 key (155725873152 168 16384) itemoff 13430 itemsize 51
[  113.815793]          extent refs 1 gen 116921565184 flags 2
[  113.815797]          tree block key (116921565184 0 0) level 27
[  113.815799]          tree block backref root 356
[  113.815804]  item 60 key (155725889536 168 16384) itemoff 13379 itemsize 51
[  113.815808]          extent refs 1 gen 125809491968 flags 2
[  113.815811]          tree block key (125809491968 0 0) level 29
[  113.815814]          tree block backref root 355
[  113.815819]  item 61 key (155725905920 168 16384) itemoff 13328 itemsize 51
[  113.815823]          extent refs 1 gen 116119289856 flags 2
[  113.815826]          tree block key (116119289856 0 0) level 27
[  113.815829]          tree block backref root 354
[  113.815834]  item 62 key (155725922304 168 16384) itemoff 13277 itemsize 51
[  113.815837]          extent refs 1 gen 0 flags 2
[  113.815841]          tree block key (104182513664 0 0) level 0
[  113.815844]          tree block backref root 352
[  113.815848]  item 63 key (155725938688 168 16384) itemoff 13226 itemsize 51
[  113.815852]          extent refs 1 gen 96 flags 2
[  113.815855]          tree block key (37659008 0 0) level 0
[  113.815858]          tree block backref root 353
[  113.815863]  item 64 key (155725955072 168 16384) itemoff 13175 itemsize 51
[  113.815867]          extent refs 1 gen 139837390848 flags 2
[  113.815870]          tree block key (139837390848 0 0) level 32
[  113.815873]          tree block backref root 351
[  113.815878]  item 65 key (155726135296 168 16384) itemoff 13124 itemsize 51
[  113.815882]          extent refs 1 gen 40862544 flags 2
[  113.815885]          tree block key (168373239808 0 0) level 0
[  113.815888]          tree block backref root 356
[  113.815893]  item 66 key (155726315520 168 16384) itemoff 13073 itemsize 51
[  113.815896]          extent refs 1 gen 37271760 flags 2
[  113.815900]          tree block key (104182513664 0 0) level 14
[  113.815903]          tree block backref root 357
[  113.815907]  item 67 key (155726364672 168 16384) itemoff 13022 itemsize 51
[  113.815911]          extent refs 1 gen 193391493120 flags 2
[  113.815915]          tree block key (193391493120 0 0) level 45
[  113.815918]          tree block backref root 355
[  113.815922]  item 68 key (155726381056 168 16384) itemoff 12971 itemsize 51
[  113.815926]          extent refs 1 gen 0 flags 2
[  113.815929]          tree block key (192 0 0) level 0
[  113.815932]          tree block backref root 356
[  113.815936]  item 69 key (155726479360 168 16384) itemoff 12920 itemsize 51
[  113.815940]          extent refs 1 gen 0 flags 2
[  113.815943]          tree block key (0 0 0) level 0
[  113.815946]          tree block backref root 352
[  113.815951]  item 70 key (155726495744 168 16384) itemoff 12869 itemsize 51
[  113.815954]          extent refs 1 gen 0 flags 2
[  113.815958]          tree block key (156065644544 0 0) level 0
[  113.815961]          tree block backref root 354
[  113.815965]  item 71 key (155726512128 168 16384) itemoff 12818 itemsize 51
[  113.815969]          extent refs 1 gen 38373168 flags 2
[  113.815973]          tree block key (167751565312 0 0) level 0
[  113.815975]          tree block backref root 353
[  113.815980]  item 72 key (155726528512 168 16384) itemoff 12767 itemsize 51
[  113.815984]          extent refs 1 gen 0 flags 2
[  113.815987]          tree block key (1248 0 0) level 0
[  113.815990]          tree block backref root 351
[  113.815994]  item 73 key (155726725120 168 16384) itemoff 12716 itemsize 51
[  113.815998]          extent refs 1 gen 0 flags 2
[  113.816001]          tree block key (0 0 0) level 0
[  113.816004]          tree block backref root 357
[  113.816009]  item 74 key (155726839808 168 16384) itemoff 12656 itemsize 60
[  113.816012]          extent refs 2 gen 0 flags 2
[  113.816016]          tree block key (1632 0 0) level 0
[  113.816018]          tree block backref root 395
[  113.816021]          tree block backref root 357
[  113.816026]  item 75 key (155727200256 168 16384) itemoff 12605 itemsize 51
[  113.816030]          extent refs 1 gen 652976259072 flags 2
[  113.816033]          tree block key (3255435951664529408 0 0) level 30
[  113.816036]          tree block backref root 356
[  113.816041]  item 76 key (155727380480 168 16384) itemoff 12554 itemsize 51
[  113.816045]          extent refs 1 gen 104182513664 flags 2
[  113.816048]          tree block key (0 0 0) level 0
[  113.816051]          tree block backref root 341
[  113.816056]  item 77 key (155728134144 168 16384) itemoff 12503 itemsize 51
[  113.816059]          extent refs 1 gen 0 flags 2
[  113.816062]          tree block key (960 0 0) level 0
[  113.816065]          tree block backref root 341
[  113.816070]  item 78 key (155729477632 168 16384) itemoff 12452 itemsize 51
[  113.816074]          extent refs 1 gen 43237280 flags 2
[  113.816077]          tree block key (37028592 0 0) level 0
[  113.816080]          tree block backref root 355
[  113.816085]  item 79 key (155729494016 168 16384) itemoff 12365 itemsize 87
[  113.816088]          extent refs 5 gen 0 flags 2
[  113.816092]          tree block key (0 0 0) level 0
[  113.816094]          tree block backref root 411
[  113.816097]          tree block backref root 406
[  113.816100]          tree block backref root 395
[  113.816103]          tree block backref root 357
[  113.816105]          tree block backref root 356
[  113.816110]  item 80 key (155730444288 168 16384) itemoff 12215 itemsize 150
[  113.816114]          extent refs 12 gen 0 flags 2
[  113.816117]          tree block key (0 0 0) level 0
[  113.816120]          tree block backref root 416
[  113.816122]          tree block backref root 411
[  113.816125]          tree block backref root 406
[  113.816128]          tree block backref root 395
[  113.816131]          tree block backref root 357
[  113.816133]          tree block backref root 356
[  113.816136]          tree block backref root 355
[  113.816139]          tree block backref root 354
[  113.816141]          tree block backref root 353
[  113.816144]          tree block backref root 352
[  113.816147]          tree block backref root 351
[  113.816149]          tree block backref root 341
[  113.816154]  item 81 key (155730739200 168 16384) itemoff 12164 itemsize 51
[  113.816158]          extent refs 1 gen 38429040 flags 2
[  113.816162]          tree block key (193956429824 0 0) level 0
[  113.816164]          tree block backref root 357
[  113.816169]  item 82 key (155730837504 168 16384) itemoff 12113 itemsize 51
[  113.816173]          extent refs 1 gen 104182513664 flags 2
[  113.816177]          tree block key (104182513664 0 0) level 45
[  113.816179]          tree block backref root 395
[  113.816184]  item 83 key (155730968576 168 16384) itemoff 12053 itemsize 60
[  113.816188]          extent refs 2 gen 0 flags 2
[  113.816191]          tree block key (0 0 0) level 0
[  113.816194]          tree block backref root 395
[  113.816196]          tree block backref root 357
[  113.816201]  item 84 key (155732017152 168 16384) itemoff 12002 itemsize 51
[  113.816205]          extent refs 1 gen 37271760 flags 2
[  113.816208]          tree block key (104182513664 0 0) level 12
[  113.816211]          tree block backref root 341
[  113.816216]  item 85 key (155732393984 168 16384) itemoff 11951 itemsize 51
[  113.816219]          extent refs 1 gen 0 flags 2
[  113.816223]          tree block key (96 0 0) level 0
[  113.816226]          tree block backref root 356
[  113.816230]  item 86 key (155732787200 168 16384) itemoff 11900 itemsize 51
[  113.816234]          extent refs 1 gen 0 flags 2
[  113.816237]          tree block key (36913184 0 0) level 0
[  113.816240]          tree block backref root 355
[  113.816245]  item 87 key (155732803584 168 16384) itemoff 11849 itemsize 51
[  113.816248]          extent refs 1 gen 104182513664 flags 2
[  113.816252]          tree block key (0 0 0) level 0
[  113.816255]          tree block backref root 354
[  113.816259]  item 88 key (155732869120 168 16384) itemoff 11798 itemsize 51
[  113.816263]          extent refs 1 gen 0 flags 2
[  113.816266]          tree block key (2976 0 0) level 0
[  113.816269]          tree block backref root 357
[  113.816274]  item 89 key (155733721088 168 16384) itemoff 11738 itemsize 60
[  113.816277]          extent refs 2 gen 0 flags 2
[  113.816280]          tree block key (96 0 0) level 0
[  113.816283]          tree block backref root 395
[  113.816286]          tree block backref root 357
[  113.816291]  item 90 key (155733753856 168 16384) itemoff 11687 itemsize 51
[  113.816294]          extent refs 1 gen 194008825856 flags 2
[  113.816298]          tree block key (0 0 0) level 0
[  113.816300]          tree block backref root 354
[  113.816305]  item 91 key (155733786624 168 16384) itemoff 11636 itemsize 51
[  113.816309]          extent refs 1 gen 37528544 flags 2
[  113.816312]          tree block key (37271760 0 0) level 0
[  113.816315]          tree block backref root 355
[  113.816320]  item 92 key (155733884928 168 16384) itemoff 11585 itemsize 51
[  113.816323]          extent refs 1 gen 0 flags 2
[  113.816327]          tree block key (0 0 0) level 0
[  113.816329]          tree block backref root 357
[  113.816334]  item 93 key (155733983232 168 16384) itemoff 11534 itemsize 51
[  113.816338]          extent refs 1 gen 0 flags 2
[  113.816341]          tree block key (96 0 0) level 0
[  113.816344]          tree block backref root 353
[  113.816348]  item 94 key (155734016000 168 16384) itemoff 11483 itemsize 51
[  113.816352]          extent refs 1 gen 0 flags 2
[  113.816355]          tree block key (0 0 0) level 0
[  113.816358]          tree block backref root 352
[  113.816363]  item 95 key (155734081536 168 16384) itemoff 11432 itemsize 51
[  113.816366]          extent refs 1 gen 38565072 flags 2
[  113.816370]          tree block key (126388011008 0 0) level 0
[  113.816373]          tree block backref root 351
[  113.816377]  item 96 key (155734114304 168 16384) itemoff 11381 itemsize 51
[  113.816381]          extent refs 1 gen 0 flags 2
[  113.816384]          tree block key (192 0 0) level 0
[  113.816387]          tree block backref root 354
[  113.816392]  item 97 key (155734130688 168 16384) itemoff 11330 itemsize 51
[  113.816395]          extent refs 1 gen 0 flags 2
[  113.816399]          tree block key (0 0 0) level 0
[  113.816401]          tree block backref root 353
[  113.816406]  item 98 key (155734147072 168 16384) itemoff 11279 itemsize 51
[  113.816410]          extent refs 1 gen 41084784 flags 2
[  113.816413]          tree block key (173521502208 0 0) level 0
[  113.816416]          tree block backref root 352
[  113.816421]  item 99 key (155734163456 168 16384) itemoff 11228 itemsize 51
[  113.816424]          extent refs 1 gen 0 flags 2
[  113.816428]          tree block key (96 0 0) level 0
[  113.816430]          tree block backref root 356
[  113.816435]  item 100 key (155734179840 168 16384) itemoff 11177 itemsize 51
[  113.816439]          extent refs 1 gen 0 flags 2
[  113.816442]          tree block key (42612992 0 0) level 0
[  113.816445]          tree block backref root 355
[  113.816450]  item 101 key (155734376448 168 16384) itemoff 11126 itemsize 51
[  113.816453]          extent refs 1 gen 0 flags 2
[  113.816456]          tree block key (576 0 0) level 0
[  113.816459]          tree block backref root 352
[  113.816464]  item 102 key (155734392832 168 16384) itemoff 11075 itemsize 51
[  113.816467]          extent refs 1 gen 0 flags 2
[  113.816471]          tree block key (38757056 0 0) level 246
[  113.816474]          tree block backref root 351
[  113.816478]  item 103 key (155734425600 168 16384) itemoff 11024 itemsize 51
[  113.816482]          extent refs 1 gen 0 flags 2
[  113.816485]          tree block key (96 0 0) level 0
[  113.816488]          tree block backref root 353
[  113.816493]  item 104 key (155734671360 168 16384) itemoff 10973 itemsize 51
[  113.816496]          extent refs 1 gen 96 flags 2
[  113.816500]          tree block key (37080320 0 0) level 0
[  113.816502]          tree block backref root 395
[  113.816507]  item 105 key (155734704128 168 16384) itemoff 10922 itemsize 51
[  113.816511]          extent refs 1 gen 104182513664 flags 2
[  113.816515]          tree block key (104182513664 0 0) level 24
[  113.816517]          tree block backref root 356
[  113.816522]  item 106 key (155734720512 168 16384) itemoff 10871 itemsize 51
[  113.816525]          extent refs 1 gen 0 flags 2
[  113.816529]          tree block key (0 0 0) level 0
[  113.816532]          tree block backref root 357
[  113.816536]  item 107 key (155734736896 168 16384) itemoff 10820 itemsize 51
[  113.816540]          extent refs 1 gen 0 flags 2
[  113.816543]          tree block key (480 0 0) level 0
[  113.816546]          tree block backref root 352
[  113.816550]  item 108 key (155734753280 168 16384) itemoff 10769 itemsize 51
[  113.816554]          extent refs 1 gen 104346992640 flags 2
[  113.816558]          tree block key (104346992640 0 0) level 24
[  113.816561]          tree block backref root 351
[  113.816565]  item 109 key (155734769664 168 16384) itemoff 10718 itemsize 51
[  113.816569]          extent refs 1 gen 40902848 flags 2
[  113.816573]          tree block key (40903632 0 0) level 0
[  113.816575]          tree block backref root 355
[  113.816580]  item 110 key (155734786048 168 16384) itemoff 10667 itemsize 51
[  113.816584]          extent refs 1 gen 39699216 flags 2
[  113.816587]          tree block key (168272494592 0 0) level 0
[  113.816590]          tree block backref root 353
[  113.816595]  item 111 key (155734802432 168 16384) itemoff 10616 itemsize 51
[  113.816598]          extent refs 1 gen 0 flags 2
[  113.816602]          tree block key (155950088192 0 0) level 0
[  113.816605]          tree block backref root 354
[  113.816609]  item 112 key (155734933504 168 16384) itemoff 10502 itemsize 114
[  113.816613]          extent refs 8 gen 116499546112 flags 2
[  113.816617]          tree block key (116499546112 0 0) level 27
[  113.816620]          tree block backref root 395
[  113.816623]          tree block backref root 357
[  113.816625]          tree block backref root 356
[  113.816628]          tree block backref root 355
[  113.816631]          tree block backref root 354
[  113.816633]          tree block backref root 353
[  113.816636]          tree block backref root 352
[  113.816639]          tree block backref root 351
[  113.816643]  item 113 key (155735097344 168 16384) itemoff 10451 itemsize 51
[  113.816647]          extent refs 1 gen 43833728 flags 2
[  113.816651]          tree block key (42892464 0 0) level 0
[  113.816653]          tree block backref root 351
[  113.816658]  item 114 key (155735130112 168 16384) itemoff 10400 itemsize 51
[  113.816662]          extent refs 1 gen 37271760 flags 2
[  113.816665]          tree block key (104182513664 0 0) level 8
[  113.816668]          tree block backref root 352
[  113.816673]  item 115 key (155735359488 168 16384) itemoff 10340 itemsize 60
[  113.816676]          extent refs 2 gen 0 flags 2
[  113.816680]          tree block key (5184 0 0) level 0
[  113.816683]          tree block backref root 395
[  113.816685]          tree block backref root 357
[  113.816690]  item 116 key (155735539712 168 16384) itemoff 10289 itemsize 51
[  113.816694]          extent refs 1 gen 41310096 flags 2
[  113.816697]          tree block key (125693050880 0 0) level 0
[  113.816700]          tree block backref root 357
[  113.816705]  item 117 key (155735572480 168 16384) itemoff 10238 itemsize 51
[  113.816708]          extent refs 1 gen 168348352512 flags 2
[  113.816712]          tree block key (168348352512 0 0) level 39
[  113.816715]          tree block backref root 355
[  113.816720]  item 118 key (155735621632 168 16384) itemoff 10187 itemsize 51
[  113.816723]          extent refs 1 gen 0 flags 2
[  113.816726]          tree block key (0 0 0) level 0
[  113.816729]          tree block backref root 356
[  113.816734]  item 119 key (155735638016 168 16384) itemoff 10136 itemsize 51
[  113.816737]          extent refs 1 gen 0 flags 2
[  113.816741]          tree block key (288 0 0) level 0
[  113.816743]          tree block backref root 352
[  113.816748]  item 120 key (155735654400 168 16384) itemoff 10085 itemsize 51
[  113.816751]          extent refs 1 gen 0 flags 2
[  113.816755]          tree block key (480 0 0) level 0
[  113.816758]          tree block backref root 351
[  113.816762]  item 121 key (155735703552 168 16384) itemoff 10034 itemsize 51
[  113.816766]          extent refs 1 gen 37271760 flags 2
[  113.816770]          tree block key (104182513664 0 0) level 16
[  113.816772]          tree block backref root 353
[  113.816777]  item 122 key (155735785472 168 16384) itemoff 9983 itemsize 51
[  113.816781]          extent refs 1 gen 0 flags 2
[  113.816784]          tree block key (768 0 0) level 0
[  113.816787]          tree block backref root 353
[  113.816791]  item 123 key (155736440832 168 16384) itemoff 9932 itemsize 51
[  113.816795]          extent refs 1 gen 38671728 flags 2
[  113.816799]          tree block key (139829985280 0 0) level 0
[  113.816801]          tree block backref root 356
[  113.816806]  item 124 key (155736457216 168 16384) itemoff 9881 itemsize 51
[  113.816810]          extent refs 1 gen 0 flags 2
[  113.816813]          tree block key (192 0 0) level 0
[  113.816816]          tree block backref root 353
[  113.816820]  item 125 key (155736473600 168 16384) itemoff 9830 itemsize 51
[  113.816824]          extent refs 1 gen 0 flags 2
[  113.816827]          tree block key (0 0 0) level 0
[  113.816830]          tree block backref root 352
[  113.816835]  item 126 key (155736489984 168 16384) itemoff 9779 itemsize 51
[  113.816838]          extent refs 1 gen 40195904 flags 2
[  113.816842]          tree block key (37271760 0 0) level 0
[  113.816845]          tree block backref root 354
[  113.816849]  item 127 key (155736506368 168 16384) itemoff 9728 itemsize 51
[  113.816853]          extent refs 1 gen 155764146176 flags 2
[  113.816856]          tree block key (0 0 0) level 0
[  113.816859]          tree block backref root 351
[  113.816864]  item 128 key (155736522752 168 16384) itemoff 9677 itemsize 51
[  113.816868]          extent refs 1 gen 173217841152 flags 2
[  113.816871]          tree block key (173217841152 0 0) level 40
[  113.816874]          tree block backref root 355
[  113.816879]  item 129 key (155736621056 168 16384) itemoff 9626 itemsize 51
[  113.816882]          extent refs 1 gen 0 flags 2
[  113.816886]          tree block key (96 0 0) level 0
[  113.816888]          tree block backref root 341
[  113.816893]  item 130 key (155736719360 168 16384) itemoff 9575 itemsize 51
[  113.816897]          extent refs 1 gen 0 flags 2
[  113.816900]          tree block key (192 0 0) level 0
[  113.816903]          tree block backref root 353
[  113.816907]  item 131 key (155736768512 168 16384) itemoff 9524 itemsize 51
[  113.816911]          extent refs 1 gen 0 flags 2
[  113.816914]          tree block key (0 0 0) level 0
[  113.816917]          tree block backref root 353
[  113.816921]  item 132 key (155736834048 168 16384) itemoff 9473 itemsize 51
[  113.816925]          extent refs 1 gen 104182513664 flags 2
[  113.816929]          tree block key (104182513664 0 0) level 45
[  113.816932]          tree block backref root 354
[  113.816936]  item 133 key (155736883200 168 16384) itemoff 9422 itemsize 51
[  113.816940]          extent refs 1 gen 116239597568 flags 2
[  113.816944]          tree block key (116239597568 0 0) level 27
[  113.816947]          tree block backref root 355
[  113.816951]  item 134 key (155736899584 168 16384) itemoff 9371 itemsize 51
[  113.816955]          extent refs 1 gen 192 flags 2
[  113.816958]          tree block key (37139936 0 0) level 0
[  113.816961]          tree block backref root 353
[  113.816966]  item 135 key (155736915968 168 16384) itemoff 9320 itemsize 51
[  113.816969]          extent refs 1 gen 0 flags 2
[  113.816973]          tree block key (0 0 0) level 0
[  113.816975]          tree block backref root 352
[  113.816980]  item 136 key (155736932352 168 16384) itemoff 9269 itemsize 51
[  113.816984]          extent refs 1 gen 168578940928 flags 2
[  113.816987]          tree block key (168578940928 0 0) level 39
[  113.816990]          tree block backref root 351
[  113.816995]  item 137 key (155736948736 168 16384) itemoff 9218 itemsize 51
[  113.816998]          extent refs 1 gen 0 flags 2
[  113.817002]          tree block key (41367392 0 0) level 0
[  113.817005]          tree block backref root 395
[  113.817009]  item 138 key (155736965120 168 16384) itemoff 9167 itemsize 51
[  113.817013]          extent refs 1 gen 125763928064 flags 2
[  113.817017]          tree block key (125763928064 0 0) level 29
[  113.817020]          tree block backref root 356
[  113.817024]  item 139 key (155736981504 168 16384) itemoff 9116 itemsize 51
[  113.817028]          extent refs 1 gen 193923612672 flags 2
[  113.817032]          tree block key (24916941 0 0) level 232
[  113.817034]          tree block backref root 357
[  113.817039]  item 140 key (155737079808 168 16384) itemoff 9065 itemsize 51
[  113.817043]          extent refs 1 gen 0 flags 2
[  113.817046]          tree block key (140425494528 0 0) level 0
[  113.817049]          tree block backref root 357
[  113.817054]  item 141 key (155737145344 168 16384) itemoff 9014 itemsize 51
[  113.817057]          extent refs 1 gen 104182513664 flags 2
[  113.817061]          tree block key (104182513664 0 0) level 39
[  113.817064]          tree block backref root 395
[  113.817069]  item 142 key (155737735168 168 16384) itemoff 8963 itemsize 51
[  113.817072]          extent refs 1 gen 40229792 flags 2
[  113.817076]          tree block key (37271760 0 0) level 0
[  113.817079]          tree block backref root 355
[  113.817083]  item 143 key (155737866240 168 16384) itemoff 8912 itemsize 51
[  113.817087]          extent refs 1 gen 0 flags 2
[  113.817090]          tree block key (5952 0 0) level 0
[  113.817093]          tree block backref root 357
[  113.817098]  item 144 key (155738324992 168 16384) itemoff 8861 itemsize 51
[  113.817101]          extent refs 1 gen 37457040 flags 2
[  113.817105]          tree block key (156699344896 0 0) level 0
[  113.817108]          tree block backref root 357
[  113.817112]  item 145 key (155738750976 168 16384) itemoff 8810 itemsize 51
[  113.817116]          extent refs 1 gen 126704041984 flags 2
[  113.817120]          tree block key (0 0 0) level 0
[  113.817122]          tree block backref root 351
[  113.817127]  item 146 key (155739176960 168 16384) itemoff 8759 itemsize 51
[  113.817131]          extent refs 1 gen 104182513664 flags 2
[  113.817134]          tree block key (104182513664 0 0) level 45
[  113.817137]          tree block backref root 395
[  113.817142]  item 147 key (155740028928 168 16384) itemoff 8681 itemsize 78
[  113.817146]          extent refs 4 gen 96 flags 2
[  113.817149]          tree block key (36604144 0 0) level 0
[  113.817152]          tree block backref root 354
[  113.817155]          tree block backref root 353
[  113.817157]          tree block backref root 352
[  113.817160]          tree block backref root 351
[  113.817165]  item 148 key (155740143616 168 16384) itemoff 8630 itemsize 51
[  113.817168]          extent refs 1 gen 116786954240 flags 2
[  113.817172]          tree block key (0 0 0) level 0
[  113.817175]          tree block backref root 351
[  113.817179]  item 149 key (155742044160 168 16384) itemoff 8579 itemsize 51
[  113.817183]          extent refs 1 gen 0 flags 2
[  113.817186]          tree block key (384 0 0) level 0
[  113.817189]          tree block backref root 354
[  113.817193]  item 150 key (155742208000 168 16384) itemoff 8528 itemsize 51
[  113.817197]          extent refs 1 gen 0 flags 2
[  113.817200]          tree block key (0 0 0) level 0
[  113.817203]          tree block backref root 341
[  113.817208]  item 151 key (155742306304 168 16384) itemoff 8477 itemsize 51
[  113.817211]          extent refs 1 gen 0 flags 2
[  113.817214]          tree block key (0 0 0) level 0
[  113.817217]          tree block backref root 341
[  113.817222]  item 152 key (155743240192 168 16384) itemoff 8426 itemsize 51
[  113.817225]          extent refs 1 gen 0 flags 2
[  113.817229]          tree block key (0 0 0) level 0
[  113.817231]          tree block backref root 341
[  113.817236]  item 153 key (155744698368 168 16384) itemoff 8375 itemsize 51
[  113.817239]          extent refs 1 gen 0 flags 2
[  113.817243]          tree block key (0 0 0) level 0
[  113.817246]          tree block backref root 341
[  113.817250]  item 154 key (155746992128 168 16384) itemoff 8324 itemsize 51
[  113.817254]          extent refs 1 gen 0 flags 2
[  113.817257]          tree block key (96 0 0) level 0
[  113.817260]          tree block backref root 352
[  113.817265]  item 155 key (155747237888 168 16384) itemoff 8183 itemsize 141
[  113.817268]          extent refs 11 gen 0 flags 2
[  113.817272]          tree block key (116749025280 0 0) level 0
[  113.817275]          tree block backref root 416
[  113.817277]          tree block backref root 411
[  113.817280]          tree block backref root 406
[  113.817283]          tree block backref root 395
[  113.817285]          tree block backref root 357
[  113.817288]          tree block backref root 356
[  113.817291]          tree block backref root 355
[  113.817294]          tree block backref root 354
[  113.817296]          tree block backref root 353
[  113.817299]          tree block backref root 352
[  113.817302]          tree block backref root 351
[  113.817306]  item 156 key (155747401728 168 16384) itemoff 8132 itemsize 51
[  113.817310]          extent refs 1 gen 0 flags 2
[  113.817313]          tree block key (0 0 0) level 0
[  113.817316]          tree block backref root 353
[  113.817321]  item 157 key (155747434496 168 16384) itemoff 8081 itemsize 51
[  113.817325]          extent refs 1 gen 104182513664 flags 2
[  113.817328]          tree block key (104182513664 0 0) level 40
[  113.817331]          tree block backref root 355
[  113.817336]  item 158 key (155747450880 168 16384) itemoff 8030 itemsize 51
[  113.817340]          extent refs 1 gen 41900016 flags 2
[  113.817343]          tree block key (139834294272 0 0) level 0
[  113.817346]          tree block backref root 354
[  113.817351]  item 159 key (155748040704 168 16384) itemoff 7979 itemsize 51
[  113.817355]          extent refs 1 gen 168262877184 flags 2
[  113.817359]          tree block key (168262877184 0 0) level 39
[  113.817362]          tree block backref root 351
[  113.817366]  item 160 key (155748139008 168 16384) itemoff 7928 itemsize 51
[  113.817370]          extent refs 1 gen 126648631296 flags 2
[  113.817374]          tree block key (126648631296 0 0) level 29
[  113.817377]          tree block backref root 356
[  113.817381]  item 161 key (155748253696 168 16384) itemoff 7877 itemsize 51
[  113.817385]          extent refs 1 gen 37191792 flags 2
[  113.817389]          tree block key (104897576960 0 0) level 0
[  113.817392]          tree block backref root 352
[  113.817396]  item 162 key (155748368384 168 16384) itemoff 7826 itemsize 51
[  113.817400]          extent refs 1 gen 0 flags 2
[  113.817403]          tree block key (192 0 0) level 0
[  113.817406]          tree block backref root 355
[  113.817411]  item 163 key (155748548608 168 16384) itemoff 7775 itemsize 51
[  113.817414]          extent refs 1 gen 0 flags 2
[  113.817417]          tree block key (96 0 0) level 0
[  113.817420]          tree block backref root 353
[  113.817425]  item 164 key (155748581376 168 16384) itemoff 7724 itemsize 51
[  113.817429]          extent refs 1 gen 156374515712 flags 2
[  113.817432]          tree block key (156374515712 0 0) level 36
[  113.817435]          tree block backref root 354
[  113.817440]  item 165 key (155748597760 168 16384) itemoff 7673 itemsize 51
[  113.817443]          extent refs 1 gen 37722192 flags 2
[  113.817447]          tree block key (194046492672 0 0) level 0
[  113.817450]          tree block backref root 357
[  113.817455]  item 166 key (155749400576 168 16384) itemoff 7622 itemsize 51
[  113.817458]          extent refs 1 gen 39324624 flags 2
[  113.817462]          tree block key (125991862272 0 0) level 0
[  113.817465]          tree block backref root 352
[  113.817469]  item 167 key (155749515264 168 16384) itemoff 7571 itemsize 51
[  113.817473]          extent refs 1 gen 13835058055282163712 flags 2
[  113.817477]          tree block key (14825849973303672868 0 0) level 0
[  113.817480]          tree block backref root 357
[  113.817485]  item 168 key (155749793792 168 16384) itemoff 7520 itemsize 51
[  113.817488]          extent refs 1 gen 116414103552 flags 2
[  113.817492]          tree block key (116414103552 0 0) level 27
[  113.817495]          tree block backref root 356
[  113.817499]  item 169 key (155749908480 168 16384) itemoff 7469 itemsize 51
[  113.817503]          extent refs 1 gen 104182513664 flags 2
[  113.817507]          tree block key (104182513664 0 0) level 45
[  113.817510]          tree block backref root 354
[  113.817514]  item 170 key (155749974016 168 16384) itemoff 7418 itemsize 51
[  113.817518]          extent refs 1 gen 168456077312 flags 2
[  113.817522]          tree block key (168456077312 0 0) level 39
[  113.817525]          tree block backref root 351
[  113.817529]  item 171 key (155750203392 168 16384) itemoff 7367 itemsize 51
[  113.817533]          extent refs 1 gen 140575358976 flags 2
[  113.817537]          tree block key (140575358976 0 0) level 32
[  113.817540]          tree block backref root 355
[  113.817544]  item 172 key (155750219776 168 16384) itemoff 7316 itemsize 51
[  113.817548]          extent refs 1 gen 672 flags 2
[  113.817551]          tree block key (37203008 0 0) level 0
[  113.817554]          tree block backref root 353
[  113.817559]  item 173 key (155750858752 168 16384) itemoff 7265 itemsize 51
[  113.817562]          extent refs 1 gen 0 flags 2
[  113.817566]          tree block key (96 0 0) level 0
[  113.817568]          tree block backref root 341
[  113.817573]  item 174 key (155750957056 168 16384) itemoff 7124 itemsize 141
[  113.817577]          extent refs 11 gen 42171312 flags 2
[  113.817580]          tree block key (155981643776 0 0) level 0
[  113.817583]          tree block backref root 416
[  113.817586]          tree block backref root 411
[  113.817589]          tree block backref root 406
[  113.817591]          tree block backref root 395
[  113.817594]          tree block backref root 357
[  113.817597]          tree block backref root 356
[  113.817600]          tree block backref root 355
[  113.817602]          tree block backref root 354
[  113.817605]          tree block backref root 353
[  113.817608]          tree block backref root 352
[  113.817611]          tree block backref root 351
[  113.817615]  item 175 key (155756232704 168 16384) itemoff 7073 itemsize 51
[  113.817619]          extent refs 1 gen 37271760 flags 2
[  113.817623]          tree block key (104182513664 0 0) level 0
[  113.817625]          tree block backref root 351
[  113.817630]  item 176 key (155757625344 168 16384) itemoff 7022 itemsize 51
[  113.817634]          extent refs 1 gen 0 flags 2
[  113.817637]          tree block key (96 0 0) level 0
[  113.817640]          tree block backref root 351
[  113.817644]  item 177 key (155764015104 168 16384) itemoff 6971 itemsize 51
[  113.817648]          extent refs 1 gen 0 flags 2
[  113.817651]          tree block key (39063968 0 0) level 0
[  113.817654]          tree block backref root 357
[  113.817659]  item 178 key (155764080640 168 16384) itemoff 6920 itemsize 51
[  113.817663]          extent refs 1 gen 104182513664 flags 2
[  113.817666]          tree block key (104182513664 0 0) level 40
[  113.817669]          tree block backref root 356
[  113.817674]  item 179 key (155764621312 168 16384) itemoff 6869 itemsize 51
[  113.817677]          extent refs 1 gen 0 flags 2
[  113.817681]          tree block key (0 0 0) level 0
[  113.817683]          tree block backref root 341
[  113.817688]  item 180 key (155765227520 168 16384) itemoff 6818 itemsize 51
[  113.817692]          extent refs 1 gen 0 flags 2
[  113.817695]          tree block key (0 0 0) level 0
[  113.817698]          tree block backref root 341
[  113.817702]  item 181 key (155766718464 168 16384) itemoff 6767 itemsize 51
[  113.817706]          extent refs 1 gen 0 flags 2
[  113.817709]          tree block key (104299577344 0 0) level 0
[  113.817712]          tree block backref root 351
[  113.817717]  item 182 key (155769421824 168 16384) itemoff 6716 itemsize 51
[  113.817720]          extent refs 1 gen 0 flags 2
[  113.817724]          tree block key (1056 0 0) level 0
[  113.817727]          tree block backref root 341
[  113.817731]  item 183 key (155770044416 168 16384) itemoff 6665 itemsize 51
[  113.817735]          extent refs 1 gen 0 flags 2
[  113.817738]          tree block key (96 0 0) level 0
[  113.817741]          tree block backref root 341
[  113.817746]  item 184 key (155772043264 168 16384) itemoff 6605 itemsize 60
[  113.817749]          extent refs 2 gen 104182513664 flags 2
[  113.817753]          tree block key (104182513664 0 0) level 45
[  113.817756]          tree block backref root 352
[  113.817759]          tree block backref root 351
[  113.817763]  item 185 key (155772076032 168 16384) itemoff 6482 itemsize 123
[  113.817767]          extent refs 9 gen 0 flags 2
[  113.817771]          tree block key (105210118144 0 0) level 0
[  113.817773]          tree block backref root 416
[  113.817776]          tree block backref root 411
[  113.817779]          tree block backref root 406
[  113.817782]          tree block backref root 395
[  113.817784]          tree block backref root 357
[  113.817787]          tree block backref root 356
[  113.817790]          tree block backref root 355
[  113.817792]          tree block backref root 354
[  113.817795]          tree block backref root 353
[  113.817800]  item 186 key (155773845504 168 16384) itemoff 6431 itemsize 51
[  113.817803]          extent refs 1 gen 0 flags 2
[  113.817807]          tree block key (96 0 0) level 0
[  113.817809]          tree block backref root 341
[  113.817814]  item 187 key (155776712704 168 16384) itemoff 6380 itemsize 51
[  113.817818]          extent refs 1 gen 38545680 flags 2
[  113.817821]          tree block key (173443760128 0 0) level 0
[  113.817824]          tree block backref root 357
[  113.817829]  item 188 key (155776745472 168 16384) itemoff 6329 itemsize 51
[  113.817832]          extent refs 1 gen 96 flags 2
[  113.817836]          tree block key (38419040 0 0) level 0
[  113.817839]          tree block backref root 395
[  113.817844]  item 189 key (155776761856 168 16384) itemoff 6278 itemsize 51
[  113.817847]          extent refs 1 gen 0 flags 2
[  113.817850]          tree block key (0 0 0) level 0
[  113.817853]          tree block backref root 356
[  113.817858]  item 190 key (155776794624 168 16384) itemoff 6227 itemsize 51
[  113.817862]          extent refs 1 gen 104182513664 flags 2
[  113.817865]          tree block key (104182513664 0 0) level 45
[  113.817868]          tree block backref root 355
[  113.817873]  item 191 key (155776827392 168 16384) itemoff 6176 itemsize 51
[  113.817877]          extent refs 1 gen 36577952 flags 2
[  113.817880]          tree block key (116514570240 0 0) level 0
[  113.817883]          tree block backref root 354
[  113.817888]  item 192 key (155776843776 168 16384) itemoff 6125 itemsize 51
[  113.817891]          extent refs 1 gen 0 flags 2
[  113.817894]          tree block key (0 0 0) level 0
[  113.817897]          tree block backref root 351
[  113.817902]  item 193 key (155776860160 168 16384) itemoff 6074 itemsize 51
[  113.817905]          extent refs 1 gen 0 flags 2
[  113.817909]          tree block key (0 0 0) level 0
[  113.817912]          tree block backref root 352
[  113.817916]  item 194 key (155776876544 168 16384) itemoff 6023 itemsize 51
[  113.817920]          extent refs 1 gen 37271760 flags 2
[  113.817924]          tree block key (104182513664 0 0) level 20
[  113.817926]          tree block backref root 353
[  113.817931]  item 195 key (155777056768 168 16384) itemoff 5972 itemsize 51
[  113.817934]          extent refs 1 gen 0 flags 2
[  113.817938]          tree block key (0 0 0) level 0
[  113.817941]          tree block backref root 341
[  113.817945]  item 196 key (155777679360 168 16384) itemoff 5921 itemsize 51
[  113.817949]          extent refs 1 gen 288 flags 2
[  113.817952]          tree block key (41072384 0 0) level 0
[  113.817955]          tree block backref root 341
[  113.817960]  item 197 key (155780235264 168 16384) itemoff 5870 itemsize 51
[  113.817963]          extent refs 1 gen 0 flags 2
[  113.817967]          tree block key (0 0 0) level 0
[  113.817969]          tree block backref root 357
[  113.817974]  item 198 key (155782873088 168 16384) itemoff 5819 itemsize 51
[  113.817977]          extent refs 1 gen 0 flags 2
[  113.817981]          tree block key (0 0 0) level 0
[  113.817984]          tree block backref root 353
[  113.817988]  item 199 key (155783217152 168 16384) itemoff 5768 itemsize 51
[  113.817992]          extent refs 1 gen 37271760 flags 2
[  113.817996]          tree block key (104182513664 0 0) level 20
[  113.817998]          tree block backref root 357
[  113.818003]  item 200 key (155783610368 168 16384) itemoff 5717 itemsize 51
[  113.818007]          extent refs 1 gen 126289870848 flags 2
[  113.818010]          tree block key (126289870848 0 0) level 29
[  113.818013]          tree block backref root 395
[  113.818018]  item 201 key (155783954432 168 16384) itemoff 5657 itemsize 60
[  113.818021]          extent refs 2 gen 0 flags 2
[  113.818025]          tree block key (192 0 0) level 0
[  113.818028]          tree block backref root 395
[  113.818030]          tree block backref root 357
[  113.818035]  item 202 key (155783987200 168 16384) itemoff 5606 itemsize 51
[  113.818039]          extent refs 1 gen 104182513664 flags 2
[  113.818042]          tree block key (0 0 0) level 0
[  113.818045]          tree block backref root 351
[  113.818050]  item 203 key (155784347648 168 16384) itemoff 5555 itemsize 51
[  113.818053]          extent refs 1 gen 0 flags 2
[  113.818057]          tree block key (2496 0 0) level 0
[  113.818059]          tree block backref root 357
[  113.818064]  item 204 key (155785641984 168 16384) itemoff 5504 itemsize 51
[  113.818067]          extent refs 1 gen 0 flags 2
[  113.818071]          tree block key (42967616 0 0) level 246
[  113.818074]          tree block backref root 341
[  113.818078]  item 205 key (155786657792 168 16384) itemoff 5453 itemsize 51
[  113.818082]          extent refs 1 gen 0 flags 2
[  113.818085]          tree block key (480 0 0) level 0
[  113.818088]          tree block backref root 341
[  113.818093]  item 206 key (155786674176 168 16384) itemoff 5402 itemsize 51
[  113.818096]          extent refs 1 gen 0 flags 2
[  113.818100]          tree block key (3264 0 0) level 0
[  113.818103]          tree block backref root 353
[  113.818107]  item 207 key (155786887168 168 16384) itemoff 5351 itemsize 51
[  113.818111]          extent refs 1 gen 0 flags 2
[  113.818114]          tree block key (0 0 0) level 0
[  113.818117]          tree block backref root 341
[  113.818121]  item 208 key (155788001280 168 16384) itemoff 5300 itemsize 51
[  113.818125]          extent refs 1 gen 0 flags 2
[  113.818129]          tree block key (39245696 0 0) level 0
[  113.818131]          tree block backref root 341
[  113.818137] BTRFS error (device sda1): unable to find ref byte nr 144134590464 parent 0 root 1  owner 367 offset 0
[  113.818142] ------------[ cut here ]------------
[  113.818167] WARNING: CPU: 0 PID: 3872 at /build/buildd/linux-3.16.0/fs/btrfs/super.c:259 __btrfs_abort_transaction+0x50/0x110 [btrfs]()
[  113.818171] BTRFS: Transaction aborted (error -2)
[  113.818174] Modules linked in: joydev btrfs dm_crypt xor snd_hda_codec_hdmi raid6_pq dm_multipath scsi_dh kvm_amd kvm snd_seq_midi snd_hda_codec_realtek snd_seq_midi_event snd_hda_codec_generic snd_rawmidi edac_core snd_hda_intel snd_hda_controller k10temp serio_raw edac_mce_amd snd_seq snd_hda_codec bnep snd_hwdep rfcomm snd_seq_device snd_pcm bluetooth snd_timer snd 6lowpan_iphc sp5100_tco soundcore i2c_piix4 shpchp mac_hid parport_pc ppdev lp parport squashfs overlayfs nls_utf8 isofs jfs xfs libcrc32c reiserfs dm_mirror dm_region_hash dm_log hid_generic nouveau mxm_wmi video i2c_algo_bit ttm usbhid drm_kms_helper pata_acpi firewire_ohci tg3 hid firewire_core r8169 drm ahci ptp crc_itu_t mii pata_jmicron libahci pps_core wmi
[  113.818610] CPU: 0 PID: 3872 Comm: umount Tainted: G        W     3.16.0-23-generic #31-Ubuntu
[  113.818611] Hardware name: Gigabyte Technology Co., Ltd. GA-870A-UD3/GA-870A-UD3, BIOS F5 08/01/2011
[  113.818613]  0000000000000009
[  113.818614]  ffff8800bd5af9a0
[  113.818631]  ffffffff8177fcbc ffff8800bd5af9e8
[  113.818635]  ffff8800bd5af9d8 ffffffff8106fd8d 00000000fffffffe ffff8800ad334000
[  113.818663]  ffff8802199a0000
[  113.818664]  ffffffffc0da9320
[  113.818665]  000000000000174a
[  113.818666]  ffff8800bd5afa38

[  113.818668] Call Trace:
[  113.818679]  [<ffffffff8177fcbc>] dump_stack+0x45/0x56
[  113.818689]  [<ffffffff8106fd8d>] warn_slowpath_common+0x7d/0xa0
[  113.818696]  [<ffffffff8106fdfc>] warn_slowpath_fmt+0x4c/0x50
[  113.818722]  [<ffffffffc0d023c0>] __btrfs_abort_transaction+0x50/0x110 [btrfs]
[  113.818751]  [<ffffffffc0d1539b>] __btrfs_free_extent+0x6cb/0xc00 [btrfs]
[  113.818763]  [<ffffffff811c16a6>] ? __slab_free+0xa6/0x320
[  113.818791]  [<ffffffffc0d1a044>] __btrfs_run_delayed_refs+0x424/0x11e0 [btrfs]
[  113.818834]  [<ffffffffc0d1edf3>] btrfs_run_delayed_refs.part.64+0x73/0x270 [btrfs]
[  113.818865]  [<ffffffffc0d1f51d>] btrfs_write_dirty_block_groups+0x46d/0x710 [btrfs]
[  113.818899]  [<ffffffffc0d2d64d>] commit_cowonly_roots+0x18d/0x240 [btrfs]
[  113.818945]  [<ffffffffc0d301ad>] btrfs_commit_transaction.part.22+0x49d/0x970 [btrfs]
[  113.818979]  [<ffffffffc0d2f27a>] btrfs_commit_transaction+0x3a/0x80 [btrfs]
[  113.819004]  [<ffffffffc0cfe760>] btrfs_sync_fs+0x50/0xc0 [btrfs]
[  113.819037]  [<ffffffff81211a82>] sync_filesystem+0x72/0xb0
[  113.819049]  [<ffffffff811e2d50>] generic_shutdown_super+0x30/0xf0
[  113.819063]  [<ffffffff811e30a2>] kill_anon_super+0x12/0x20
[  113.819116]  [<ffffffffc0d01e86>] btrfs_kill_super+0x16/0x90 [btrfs]
[  113.819146]  [<ffffffff811e3429>] deactivate_locked_super+0x49/0x60
[  113.819174]  [<ffffffff811e3874>] deactivate_super+0x64/0x70
[  113.819204]  [<ffffffff812015ef>] mntput_no_expire+0xdf/0x180
[  113.819233]  [<ffffffff81202bac>] SyS_umount+0x8c/0x100
[  113.819264]  [<ffffffff81787ced>] system_call_fastpath+0x1a/0x1f
[  113.819281] ---[ end trace 328a5b6c02402781 ]---
[  113.819286] BTRFS: error (device sda1) in __btrfs_free_extent:5962: errno=-2 No such entry
[  113.819290] BTRFS info (device sda1): forced readonly
[  113.819297] BTRFS: error (device sda1) in btrfs_run_delayed_refs:2806: errno=-2 No such entry
[  113.842430] BTRFS warning (device sda1): Skipping commit of aborted transaction.
[  113.842433] BTRFS: error (device sda1) in cleanup_transaction:1571: errno=-2 No such entry
                                                                                          

