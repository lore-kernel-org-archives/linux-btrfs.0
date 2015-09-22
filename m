Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35139 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906AbbIVNGf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:06:35 -0400
Received: by obbzf10 with SMTP id zf10so6507043obb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 06:06:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150922115913.GE5918@carfax.org.uk>
References: <CAFENT7LzCRHX3p-zSrk1ECjo0JQ6=49W=Om9P-2g4x+dpAM2pw@mail.gmail.com>
 <CAFENT7KRPVkkezyddhRXcbNKVftu6VsbrioEY4JTy1FV9jOjXQ@mail.gmail.com>
 <CAFENT7L=hq8uRZ=YU2gRm9S3xfDBLx=BJuFuMuEex_PWDyWLkA@mail.gmail.com> <20150922115913.GE5918@carfax.org.uk>
From: Sylvain Joyeux <sylvain.joyeux@m4x.org>
Date: Tue, 22 Sep 2015 10:06:14 -0300
Message-ID: <CAFENT7K5RjpBhF0hr9HfnZG3xRxPFCT8ErYz=WoBRN5HWOHkvQ@mail.gmail.com>
Subject: Re: BTRFS kernel error on mounted partition. Partition has errors
 detected but not repaired by btrfs-check.
To: Hugo Mills <hugo@carfax.org.uk>, Sylvain Joyeux <sylvain.joyeux@m4x.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Not attached to this email. :) Can you just put the text inline?

Damn. Here they are.

For the record, I felt dumb since the original files (from a week ago)
were using btrfs-progs 3.19 (I thought I was using 4.2). "Luckily" it
happened again today on another drive, so I'm sending this instead. I
can at least say that it is becoming a very recurring problem for me
(3 times in a single week, and on 2 different drives). The drive from
today is a USB drive (WD my passport Ultra, is USB a problem ?) on
which I only transfer snapshots with send/receive. The other drive is
a SATA drive (Seagate) on which I both transfer snapshots and work (I
have VMs on it, marked with NOCOW).

The kernel is an ubuntu-provided vanilla kernel, no Ubuntu patches
applied. I can now say that the symptom appeared while running on this
kernel (which obviously does not mean that it did not happen already
on 4.2 ...)

I'm going to re-run --repair to see if 4.2 would fix those.

uname -a

Linux squidock 4.0.7-040007-generic #201507031036 SMP Fri Jul 3
10:37:58 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

btrfs-check: I removed all the "bad metadata [....] crossing stripe
boundary" - of which there were many.

Checking filesystem on /dev/sdc1
UUID: 14ea871f-1e47-49b3-9f9b-4ded4f510b0b
checking extents
ref mismatch on [315025031168 16384] extent item 0, found 1
Backref 315025031168 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [315025031168 16384]
owner ref check failed [315025031168 16384]
ref mismatch on [315025096704 16384] extent item 0, found 1
Backref 315025096704 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [315025096704 16384]
owner ref check failed [315025096704 16384]
ref mismatch on [334835515392 16384] extent item 0, found 1
Backref 334835515392 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [334835515392 16384]
owner ref check failed [334835515392 16384]
ref mismatch on [334838005760 16384] extent item 0, found 1
Backref 334838005760 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [334838005760 16384]
owner ref check failed [334838005760 16384]
ref mismatch on [334840741888 16384] extent item 0, found 1
Backref 334840741888 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [334840741888 16384]
owner ref check failed [334840741888 16384]
ref mismatch on [334844133376 16384] extent item 0, found 1
Backref 334844133376 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [334844133376 16384]
owner ref check failed [334844133376 16384]
ref mismatch on [334854930432 16384] extent item 13, found 14
Backref 334854930432 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [334854930432 16384]
ref mismatch on [334861041664 16384] extent item 0, found 1
Backref 334861041664 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [334861041664 16384]
owner ref check failed [334861041664 16384]
ref mismatch on [334864269312 16384] extent item 0, found 1
Backref 334864269312 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [334864269312 16384]
owner ref check failed [334864269312 16384]
ref mismatch on [338452496384 16384] extent item 0, found 1
Backref 338452496384 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [338452496384 16384]
owner ref check failed [338452496384 16384]
ref mismatch on [338463244288 16384] extent item 0, found 1
Backref 338463244288 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [338463244288 16384]
owner ref check failed [338463244288 16384]
ref mismatch on [338483609600 16384] extent item 0, found 1
Backref 338483609600 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [338483609600 16384]
owner ref check failed [338483609600 16384]
ref mismatch on [338518589440 16384] extent item 5, found 6
Backref 338518589440 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [338518589440 16384]
ref mismatch on [338518671360 16384] extent item 0, found 1
Backref 338518671360 parent 1406 root 1406 not found in extent tree
backpointer mismatch on [338518671360 16384]
owner ref check failed [338518671360 16384]
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
warning line 3597
checking csums
checking root refs
found 325603717524 bytes used err is 0
total csum bytes: 303756628
total tree bytes: 14641364992
total fs tree bytes: 13830225920
total extent tree bytes: 478543872
btree space waste bytes: 2715556361
file data blocks allocated: 10396334755840
 referenced 1929183850496
btrfs-progs v4.2


dmesg:

[ 2403.689854] ------------[ cut here ]------------
[ 2403.689881] WARNING: CPU: 0 PID: 8190 at
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:5968
__btrfs_free_extent+0xb63/0xbf0 [btrfs]()
[ 2403.689882] Modules linked in: ctr ccm msr binfmt_misc bnep
bbswitch(OE) nls_iso8859_1 ses enclosure arc4 intel_rapl iosf_mbi
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iwlmvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mac80211 aesni_intel
aes_x86_64 lrw gf128mul uvcvideo glue_helper ablk_helper
videobuf2_vmalloc iwlwifi cryptd videobuf2_memops videobuf2_core
v4l2_common videodev serio_raw joydev btusb uas media cfg80211
rtsx_pci_ms bluetooth memstick lpc_ich wmi intel_rst mac_hid
thinkpad_acpi snd_hda_codec_hdmi nvram snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec
snd_hwdep snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq
snd_seq_device snd_timer snd mei_me mei soundcore ie31200_edac
edac_core shpchp parport_pc ppdev
[ 2403.689911]  lp parport autofs4 btrfs xor raid6_pq hid_generic
usbhid hid usb_storage i915 rtsx_pci_sdmmc i2c_algo_bit drm_kms_helper
drm e1000e psmouse ahci ptp libahci rtsx_pci pps_core video
[ 2403.689924] CPU: 0 PID: 8190 Comm: kworker/u16:1 Tainted: G
W  OE   4.0.7-040007-generic #201507031036
[ 2403.689926] Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS
GLET76WW (2.30 ) 01/07/2015
[ 2403.689943] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 2403.689944]  ffffffffc059a5e8 ffff880219da7a88 ffffffff817b5644
0000000000000000
[ 2403.689946]  0000000000000000 ffff880219da7ac8 ffffffff81075e3a
0000000000001000
[ 2403.689948]  ffff880406ba7f30 0000004958f48000 ffff8800a03fa000
0000000000000000
[ 2403.689950] Call Trace:
[ 2403.689958]  [<ffffffff817b5644>] dump_stack+0x45/0x57
[ 2403.689961]  [<ffffffff81075e3a>] warn_slowpath_common+0x8a/0xc0
[ 2403.689963]  [<ffffffff81075f2a>] warn_slowpath_null+0x1a/0x20
[ 2403.689974]  [<ffffffffc04fc193>] __btrfs_free_extent+0xb63/0xbf0 [btrfs]
[ 2403.689988]  [<ffffffffc05616a5>] ? find_ref_head+0x65/0x90 [btrfs]
[ 2403.689998]  [<ffffffffc0501773>]
__btrfs_run_delayed_refs+0x973/0x1200 [btrfs]
[ 2403.690000]  [<ffffffff817b2482>] ? __slab_free+0x104/0x25c
[ 2403.690004]  [<ffffffff811d2c49>] ? kmem_cache_alloc+0x1a9/0x230
[ 2403.690014]  [<ffffffffc05060f3>]
btrfs_run_delayed_refs.part.66+0x73/0x270 [btrfs]
[ 2403.690023]  [<ffffffffc0506398>] delayed_ref_async_start+0x88/0xa0 [btrfs]
[ 2403.690035]  [<ffffffffc0547442>] normal_work_helper+0xc2/0x2b0 [btrfs]
[ 2403.690046]  [<ffffffffc0547862>] btrfs_extent_refs_helper+0x12/0x20 [btrfs]
[ 2403.690049]  [<ffffffff8108f05f>] process_one_work+0x14f/0x420
[ 2403.690051]  [<ffffffff8108f818>] worker_thread+0x118/0x510
[ 2403.690053]  [<ffffffff8108f700>] ? rescuer_thread+0x3d0/0x3d0
[ 2403.690055]  [<ffffffff81094cc9>] kthread+0xc9/0xe0
[ 2403.690058]  [<ffffffff81094c00>] ? kthread_create_on_node+0x180/0x180
[ 2403.690061]  [<ffffffff817bced8>] ret_from_fork+0x58/0x90
[ 2403.690063]  [<ffffffff81094c00>] ? kthread_create_on_node+0x180/0x180
[ 2403.690065] ---[ end trace 3b99dae1af3249b1 ]---
[ 2403.690067] BTRFS info (device sdc1): leaf 283463745536 total ptrs
231 free space 122
[ 2403.690069] item 0 key (315023130624 169 0) itemoff 16205 itemsize 78
[ 2403.690070] extent refs 6 gen 8219 flags 2
[ 2403.690071] tree block backref root 1440
[ 2403.690072] tree block backref root 1439
[ 2403.690073] tree block backref root 1432
[ 2403.690073] tree block backref root 1431
[ 2403.690074] tree block backref root 1428
[ 2403.690075] tree block backref root 1426
[ 2403.690076] item 1 key (315023147008 169 0) itemoff 16127 itemsize 78
[ 2403.690077] extent refs 6 gen 8219 flags 2
[ 2403.690078] tree block backref root 1440
[ 2403.690078] tree block backref root 1439
[ 2403.690079] tree block backref root 1432
[ 2403.690080] tree block backref root 1431
[ 2403.690081] tree block backref root 1428
[ 2403.690081] tree block backref root 1426
[ 2403.690082] item 2 key (315023163392 169 0) itemoff 16049 itemsize 78
[ 2403.690083] extent refs 6 gen 8219 flags 2
[ 2403.690084] tree block backref root 1440
[ 2403.690085] tree block backref root 1439
[ 2403.690086] tree block backref root 1432
[ 2403.690086] tree block backref root 1431
[ 2403.690087] tree block backref root 1428
[ 2403.690088] tree block backref root 1426
[ 2403.690089] item 3 key (315023179776 169 0) itemoff 15971 itemsize 78
[ 2403.690090] extent refs 6 gen 8219 flags 2
[ 2403.690090] tree block backref root 1440
[ 2403.690091] tree block backref root 1439
[ 2403.690092] tree block backref root 1432
[ 2403.690093] tree block backref root 1431
[ 2403.690093] tree block backref root 1428
[ 2403.690094] tree block backref root 1426
[ 2403.690095] item 4 key (315023196160 169 0) itemoff 15893 itemsize 78
[ 2403.690096] extent refs 6 gen 8219 flags 2
[ 2403.690097] tree block backref root 1440
[ 2403.690097] tree block backref root 1439
[ 2403.690098] tree block backref root 1432
[ 2403.690099] tree block backref root 1431
[ 2403.690100] tree block backref root 1428
[ 2403.690100] tree block backref root 1426
[ 2403.690101] item 5 key (315023212544 169 0) itemoff 15860 itemsize 33
[ 2403.690102] extent refs 1 gen 8286 flags 2
[ 2403.690103] tree block backref root 2
[ 2403.690104] item 6 key (315023228928 169 0) itemoff 15827 itemsize 33
[ 2403.690105] extent refs 1 gen 8286 flags 2
[ 2403.690106] tree block backref root 2
[ 2403.690107] item 7 key (315023245312 169 0) itemoff 15794 itemsize 33
[ 2403.690108] extent refs 1 gen 8286 flags 2
[ 2403.690108] tree block backref root 2
[ 2403.690109] item 8 key (315023261696 169 0) itemoff 15716 itemsize 78
[ 2403.690110] extent refs 6 gen 8219 flags 2
[ 2403.690111] tree block backref root 1440
[ 2403.690112] tree block backref root 1439
[ 2403.690112] tree block backref root 1432
[ 2403.690113] tree block backref root 1431
[ 2403.690114] tree block backref root 1428
[ 2403.690115] tree block backref root 1426
[ 2403.690116] item 9 key (315023278080 169 0) itemoff 15638 itemsize 78
[ 2403.690117] extent refs 6 gen 8219 flags 2
[ 2403.690117] tree block backref root 1440
[ 2403.690118] tree block backref root 1439
[ 2403.690119] tree block backref root 1432
[ 2403.690119] tree block backref root 1431
[ 2403.690120] tree block backref root 1428
[ 2403.690121] tree block backref root 1426
[ 2403.690122] item 10 key (315023294464 169 0) itemoff 15560 itemsize 78
[ 2403.690123] extent refs 6 gen 8219 flags 2
[ 2403.690124] tree block backref root 1440
[ 2403.690124] tree block backref root 1439
[ 2403.690125] tree block backref root 1432
[ 2403.690126] tree block backref root 1431
[ 2403.690126] tree block backref root 1428
[ 2403.690127] tree block backref root 1426
[ 2403.690128] item 11 key (315023310848 169 0) itemoff 15482 itemsize 78
[ 2403.690129] extent refs 6 gen 8219 flags 2
[ 2403.690130] tree block backref root 1440
[ 2403.690131] tree block backref root 1439
[ 2403.690131] tree block backref root 1432
[ 2403.690132] tree block backref root 1431
[ 2403.690133] tree block backref root 1428
[ 2403.690133] tree block backref root 1426
[ 2403.690134] item 12 key (315023327232 169 0) itemoff 15404 itemsize 78
[ 2403.690135] extent refs 6 gen 8219 flags 2
[ 2403.690136] tree block backref root 1440
[ 2403.690137] tree block backref root 1439
[ 2403.690138] tree block backref root 1432
[ 2403.690138] tree block backref root 1431
[ 2403.690139] tree block backref root 1428
[ 2403.690140] tree block backref root 1426
[ 2403.690141] item 13 key (315023343616 169 0) itemoff 15326 itemsize 78
[ 2403.690142] extent refs 6 gen 8219 flags 2
[ 2403.690142] tree block backref root 1440
[ 2403.690143] tree block backref root 1439
[ 2403.690144] tree block backref root 1432
[ 2403.690145] tree block backref root 1431
[ 2403.690145] tree block backref root 1428
[ 2403.690146] tree block backref root 1426
[ 2403.690147] item 14 key (315023360000 169 0) itemoff 15248 itemsize 78
[ 2403.690148] extent refs 6 gen 8219 flags 2
[ 2403.690149] tree block backref root 1440
[ 2403.690149] tree block backref root 1439
[ 2403.690150] tree block backref root 1432
[ 2403.690151] tree block backref root 1431
[ 2403.690152] tree block backref root 1428
[ 2403.690152] tree block backref root 1426
[ 2403.690153] item 15 key (315023376384 169 0) itemoff 15170 itemsize 78
[ 2403.690154] extent refs 6 gen 8219 flags 2
[ 2403.690155] tree block backref root 1440
[ 2403.690156] tree block backref root 1439
[ 2403.690156] tree block backref root 1432
[ 2403.690157] tree block backref root 1431
[ 2403.690158] tree block backref root 1428
[ 2403.690159] tree block backref root 1426
[ 2403.690160] item 16 key (315023392768 169 0) itemoff 15092 itemsize 78
[ 2403.690160] extent refs 6 gen 8219 flags 2
[ 2403.690161] tree block backref root 1440
[ 2403.690162] tree block backref root 1439
[ 2403.690163] tree block backref root 1432
[ 2403.690163] tree block backref root 1431
[ 2403.690164] tree block backref root 1428
[ 2403.690165] tree block backref root 1426
[ 2403.690166] item 17 key (315023409152 169 0) itemoff 15059 itemsize 33
[ 2403.690167] extent refs 1 gen 8219 flags 2
[ 2403.690167] tree block backref root 1426
[ 2403.690169] item 18 key (315023425536 169 0) itemoff 15026 itemsize 33
[ 2403.690169] extent refs 1 gen 8286 flags 2
[ 2403.690170] tree block backref root 2
[ 2403.690171] item 19 key (315023441920 169 0) itemoff 14993 itemsize 33
[ 2403.690172] extent refs 1 gen 8286 flags 2
[ 2403.690173] tree block backref root 2
[ 2403.690174] item 20 key (315023458304 169 0) itemoff 14960 itemsize 33
[ 2403.690175] extent refs 1 gen 8286 flags 2
[ 2403.690176] tree block backref root 2
[ 2403.690177] item 21 key (315023474688 169 0) itemoff 14927 itemsize 33
[ 2403.690178] extent refs 1 gen 8286 flags 2
[ 2403.690178] tree block backref root 2
[ 2403.690179] item 22 key (315023491072 169 0) itemoff 14894 itemsize 33
[ 2403.690180] extent refs 1 gen 8286 flags 2
[ 2403.690181] tree block backref root 2
[ 2403.690182] item 23 key (315023507456 169 0) itemoff 14861 itemsize 33
[ 2403.690183] extent refs 1 gen 8286 flags 2
[ 2403.690184] tree block backref root 2
[ 2403.690185] item 24 key (315023556608 169 0) itemoff 14828 itemsize 33
[ 2403.690186] extent refs 1 gen 8219 flags 2
[ 2403.690186] tree block backref root 1426
[ 2403.690187] item 25 key (315023572992 169 0) itemoff 14750 itemsize 78
[ 2403.690188] extent refs 6 gen 8219 flags 2
[ 2403.690189] tree block backref root 1440
[ 2403.690190] tree block backref root 1439
[ 2403.690191] tree block backref root 1432
[ 2403.690191] tree block backref root 1431
[ 2403.690192] tree block backref root 1428
[ 2403.690193] tree block backref root 1426
[ 2403.690194] item 26 key (315023589376 169 0) itemoff 14717 itemsize 33
[ 2403.690195] extent refs 1 gen 8219 flags 2
[ 2403.690195] tree block backref root 1426
[ 2403.690196] item 27 key (315023605760 169 0) itemoff 14675 itemsize 42
[ 2403.690197] extent refs 2 gen 7758 flags 258
[ 2403.690198] tree block backref root 1386
[ 2403.690199] shared block backref parent 315008581632
[ 2403.690200] item 28 key (315023622144 169 0) itemoff 14642 itemsize 33
[ 2403.690201] extent refs 1 gen 7758 flags 258
[ 2403.690202] tree block backref root 1379
[ 2403.690203] item 29 key (315023638528 169 0) itemoff 14609 itemsize 33
[ 2403.690204] extent refs 1 gen 7758 flags 258
[ 2403.690204] tree block backref root 1379
[ 2403.690205] item 30 key (315023654912 169 0) itemoff 14576 itemsize 33
[ 2403.690206] extent refs 1 gen 7758 flags 258
[ 2403.690207] tree block backref root 1379
[ 2403.690208] item 31 key (315023671296 169 0) itemoff 14543 itemsize 33
[ 2403.690209] extent refs 1 gen 7758 flags 258
[ 2403.690210] tree block backref root 1379
[ 2403.690211] item 32 key (315023687680 169 0) itemoff 14510 itemsize 33
[ 2403.690212] extent refs 1 gen 7758 flags 258
[ 2403.690212] tree block backref root 1379
[ 2403.690213] item 33 key (315023704064 169 0) itemoff 14477 itemsize 33
[ 2403.690214] extent refs 1 gen 7758 flags 258
[ 2403.690215] tree block backref root 1379
[ 2403.690216] item 34 key (315023720448 169 0) itemoff 14444 itemsize 33
[ 2403.690217] extent refs 1 gen 7758 flags 258
[ 2403.690218] tree block backref root 1379
[ 2403.690219] item 35 key (315023736832 169 0) itemoff 14411 itemsize 33
[ 2403.690220] extent refs 1 gen 7758 flags 258
[ 2403.690220] tree block backref root 1379
[ 2403.690221] item 36 key (315023753216 169 0) itemoff 14333 itemsize 78
[ 2403.690222] extent refs 6 gen 8219 flags 2
[ 2403.690223] tree block backref root 1440
[ 2403.690224] tree block backref root 1439
[ 2403.690225] tree block backref root 1432
[ 2403.690225] tree block backref root 1431
[ 2403.690226] tree block backref root 1428
[ 2403.690227] tree block backref root 1426
[ 2403.690228] item 37 key (315023769600 169 0) itemoff 14255 itemsize 78
[ 2403.690229] extent refs 6 gen 8219 flags 2
[ 2403.690229] tree block backref root 1440
[ 2403.690230] tree block backref root 1439
[ 2403.690231] tree block backref root 1432
[ 2403.690232] tree block backref root 1431
[ 2403.690232] tree block backref root 1428
[ 2403.690233] tree block backref root 1426
[ 2403.690234] item 38 key (315023785984 169 0) itemoff 14222 itemsize 33
[ 2403.690235] extent refs 1 gen 7758 flags 258
[ 2403.690236] tree block backref root 1379
[ 2403.690237] item 39 key (315023802368 169 0) itemoff 14189 itemsize 33
[ 2403.690238] extent refs 1 gen 7758 flags 258
[ 2403.690238] tree block backref root 1379
[ 2403.690239] item 40 key (315023818752 169 0) itemoff 14111 itemsize 78
[ 2403.690240] extent refs 6 gen 8219 flags 2
[ 2403.690241] tree block backref root 1440
[ 2403.690242] tree block backref root 1439
[ 2403.690243] tree block backref root 1432
[ 2403.690243] tree block backref root 1431
[ 2403.690244] tree block backref root 1428
[ 2403.690245] tree block backref root 1426
[ 2403.690246] item 41 key (315023835136 169 0) itemoff 14078 itemsize 33
[ 2403.690247] extent refs 1 gen 8219 flags 2
[ 2403.690247] tree block backref root 1426
[ 2403.690248] item 42 key (315023851520 169 0) itemoff 14045 itemsize 33
[ 2403.690249] extent refs 1 gen 7758 flags 258
[ 2403.690250] tree block backref root 1379
[ 2403.690251] item 43 key (315023867904 169 0) itemoff 14003 itemsize 42
[ 2403.690252] extent refs 2 gen 7758 flags 258
[ 2403.690253] tree block backref root 1383
[ 2403.690253] tree block backref root 1379
[ 2403.690255] item 44 key (315023884288 169 0) itemoff 13970 itemsize 33
[ 2403.690255] extent refs 1 gen 7758 flags 258
[ 2403.690256] tree block backref root 1379
[ 2403.690257] item 45 key (315023900672 169 0) itemoff 13937 itemsize 33
[ 2403.690258] extent refs 1 gen 7758 flags 258
[ 2403.690259] tree block backref root 1379
[ 2403.690260] item 46 key (315023917056 169 0) itemoff 13895 itemsize 42
[ 2403.690261] extent refs 2 gen 7758 flags 258
[ 2403.690261] tree block backref root 1386
[ 2403.690262] shared block backref parent 315008581632
[ 2403.690263] item 47 key (315023933440 169 0) itemoff 13817 itemsize 78
[ 2403.690264] extent refs 6 gen 8219 flags 2
[ 2403.690265] tree block backref root 1440
[ 2403.690266] tree block backref root 1439
[ 2403.690266] tree block backref root 1432
[ 2403.690267] tree block backref root 1431
[ 2403.690268] tree block backref root 1428
[ 2403.690269] tree block backref root 1426
[ 2403.690270] item 48 key (315023949824 169 0) itemoff 13775 itemsize 42
[ 2403.690271] extent refs 2 gen 7758 flags 258
[ 2403.690271] tree block backref root 1386
[ 2403.690272] shared block backref parent 315008581632
[ 2403.690273] item 49 key (315023966208 169 0) itemoff 13733 itemsize 42
[ 2403.690274] extent refs 2 gen 7758 flags 258
[ 2403.690275] tree block backref root 1386
[ 2403.690275] shared block backref parent 315008581632
[ 2403.690277] item 50 key (315023982592 169 0) itemoff 13700 itemsize 33
[ 2403.690277] extent refs 1 gen 8219 flags 2
[ 2403.690278] tree block backref root 1426
[ 2403.690279] item 51 key (315023998976 169 0) itemoff 13658 itemsize 42
[ 2403.690280] extent refs 2 gen 7758 flags 258
[ 2403.690281] tree block backref root 1386
[ 2403.690282] shared block backref parent 315008581632
[ 2403.690283] item 52 key (315024015360 169 0) itemoff 13616 itemsize 42
[ 2403.690284] extent refs 2 gen 7758 flags 258
[ 2403.690284] tree block backref root 1386
[ 2403.690285] shared block backref parent 315008581632
[ 2403.690286] item 53 key (315024031744 169 0) itemoff 13583 itemsize 33
[ 2403.690287] extent refs 1 gen 8219 flags 2
[ 2403.690288] tree block backref root 1426
[ 2403.690289] item 54 key (315024048128 169 0) itemoff 13541 itemsize 42
[ 2403.690290] extent refs 2 gen 7758 flags 258
[ 2403.690290] tree block backref root 1386
[ 2403.690291] shared block backref parent 315008581632
[ 2403.690292] item 55 key (315024064512 169 0) itemoff 13499 itemsize 42
[ 2403.690293] extent refs 2 gen 7758 flags 258
[ 2403.690294] tree block backref root 1386
[ 2403.690295] shared block backref parent 315008581632
[ 2403.690296] item 56 key (315024080896 169 0) itemoff 13457 itemsize 42
[ 2403.690297] extent refs 2 gen 7758 flags 258
[ 2403.690297] tree block backref root 1386
[ 2403.690298] shared block backref parent 315008581632
[ 2403.690299] item 57 key (315024097280 169 0) itemoff 13415 itemsize 42
[ 2403.690300] extent refs 2 gen 7758 flags 258
[ 2403.690301] tree block backref root 1386
[ 2403.690301] shared block backref parent 315008581632
[ 2403.690303] item 58 key (315024113664 169 0) itemoff 13373 itemsize 42
[ 2403.690303] extent refs 2 gen 7758 flags 258
[ 2403.690304] tree block backref root 1386
[ 2403.690305] shared block backref parent 315008581632
[ 2403.690306] item 59 key (315024130048 169 0) itemoff 13331 itemsize 42
[ 2403.690307] extent refs 2 gen 7758 flags 258
[ 2403.690308] tree block backref root 1386
[ 2403.690308] shared block backref parent 315008581632
[ 2403.690309] item 60 key (315024146432 169 0) itemoff 13289 itemsize 42
[ 2403.690310] extent refs 2 gen 7758 flags 258
[ 2403.690311] tree block backref root 1386
[ 2403.690312] shared block backref parent 315008581632
[ 2403.690313] item 61 key (315024162816 169 0) itemoff 13247 itemsize 42
[ 2403.690314] extent refs 2 gen 7758 flags 258
[ 2403.690314] tree block backref root 1386
[ 2403.690315] shared block backref parent 315008581632
[ 2403.690316] item 62 key (315024179200 169 0) itemoff 13205 itemsize 42
[ 2403.690317] extent refs 2 gen 7758 flags 258
[ 2403.690318] tree block backref root 1386
[ 2403.690319] shared block backref parent 315008581632
[ 2403.690320] item 63 key (315024195584 169 0) itemoff 13163 itemsize 42
[ 2403.690321] extent refs 2 gen 7758 flags 258
[ 2403.690321] tree block backref root 1386
[ 2403.690322] shared block backref parent 315008581632
[ 2403.690323] item 64 key (315024211968 169 0) itemoff 13121 itemsize 42
[ 2403.690324] extent refs 2 gen 7758 flags 258
[ 2403.690325] tree block backref root 1386
[ 2403.690325] shared block backref parent 315008581632
[ 2403.690327] item 65 key (315024228352 169 0) itemoff 13079 itemsize 42
[ 2403.690327] extent refs 2 gen 7758 flags 258
[ 2403.690328] tree block backref root 1386
[ 2403.690329] shared block backref parent 315008581632
[ 2403.690330] item 66 key (315024244736 169 0) itemoff 13037 itemsize 42
[ 2403.690331] extent refs 2 gen 7758 flags 258
[ 2403.690332] tree block backref root 1386
[ 2403.690332] shared block backref parent 315008581632
[ 2403.690333] item 67 key (315024261120 169 0) itemoff 12995 itemsize 42
[ 2403.690334] extent refs 2 gen 7758 flags 258
[ 2403.690335] tree block backref root 1386
[ 2403.690336] shared block backref parent 315008581632
[ 2403.690337] item 68 key (315024277504 169 0) itemoff 12953 itemsize 42
[ 2403.690338] extent refs 2 gen 7758 flags 258
[ 2403.690338] tree block backref root 1386
[ 2403.690339] shared block backref parent 315008581632
[ 2403.690340] item 69 key (315024293888 169 0) itemoff 12911 itemsize 42
[ 2403.690341] extent refs 2 gen 7758 flags 258
[ 2403.690342] tree block backref root 1386
[ 2403.690343] shared block backref parent 315008581632
[ 2403.690344] item 70 key (315024310272 169 0) itemoff 12869 itemsize 42
[ 2403.690345] extent refs 2 gen 7758 flags 258
[ 2403.690345] tree block backref root 1386
[ 2403.690346] shared block backref parent 315008581632
[ 2403.690347] item 71 key (315024326656 169 0) itemoff 12827 itemsize 42
[ 2403.690348] extent refs 2 gen 7758 flags 258
[ 2403.690349] tree block backref root 1386
[ 2403.690350] shared block backref parent 315008581632
[ 2403.690351] item 72 key (315024343040 169 0) itemoff 12785 itemsize 42
[ 2403.690351] extent refs 2 gen 7758 flags 258
[ 2403.690352] tree block backref root 1386
[ 2403.690353] shared block backref parent 315008581632
[ 2403.690354] item 73 key (315024359424 169 0) itemoff 12743 itemsize 42
[ 2403.690355] extent refs 2 gen 7758 flags 258
[ 2403.690356] tree block backref root 1386
[ 2403.690356] shared block backref parent 315008581632
[ 2403.690357] item 74 key (315024375808 169 0) itemoff 12701 itemsize 42
[ 2403.690358] extent refs 2 gen 7758 flags 258
[ 2403.690359] tree block backref root 1386
[ 2403.690360] shared block backref parent 315008581632
[ 2403.690361] item 75 key (315024392192 169 0) itemoff 12659 itemsize 42
[ 2403.690362] extent refs 2 gen 7758 flags 258
[ 2403.690362] tree block backref root 1386
[ 2403.690363] shared block backref parent 315008581632
[ 2403.690364] item 76 key (315024408576 169 0) itemoff 12617 itemsize 42
[ 2403.690365] extent refs 2 gen 7758 flags 258
[ 2403.690366] tree block backref root 1386
[ 2403.690367] shared block backref parent 315008581632
[ 2403.690368] item 77 key (315024424960 169 0) itemoff 12575 itemsize 42
[ 2403.690369] extent refs 2 gen 7758 flags 258
[ 2403.690369] tree block backref root 1386
[ 2403.690370] shared block backref parent 315008581632
[ 2403.690371] item 78 key (315024441344 169 0) itemoff 12533 itemsize 42
[ 2403.690372] extent refs 2 gen 7758 flags 258
[ 2403.690373] tree block backref root 1386
[ 2403.690374] shared block backref parent 315008581632
[ 2403.690375] item 79 key (315024457728 169 0) itemoff 12491 itemsize 42
[ 2403.690375] extent refs 2 gen 7758 flags 258
[ 2403.690376] tree block backref root 1386
[ 2403.690377] shared block backref parent 315008581632
[ 2403.690378] item 80 key (315024474112 169 0) itemoff 12458 itemsize 33
[ 2403.690379] extent refs 1 gen 8219 flags 2
[ 2403.690380] tree block backref root 1426
[ 2403.690381] item 81 key (315024490496 169 0) itemoff 12416 itemsize 42
[ 2403.690382] extent refs 2 gen 7758 flags 258
[ 2403.690382] tree block backref root 1386
[ 2403.690383] shared block backref parent 315008581632
[ 2403.690384] item 82 key (315024506880 169 0) itemoff 12374 itemsize 42
[ 2403.690385] extent refs 2 gen 7758 flags 258
[ 2403.690386] tree block backref root 1386
[ 2403.690386] shared block backref parent 315008581632
[ 2403.690388] item 83 key (315024523264 169 0) itemoff 12332 itemsize 42
[ 2403.690388] extent refs 2 gen 7758 flags 258
[ 2403.690389] tree block backref root 1386
[ 2403.690390] shared block backref parent 315008581632
[ 2403.690391] item 84 key (315024539648 169 0) itemoff 12290 itemsize 42
[ 2403.690392] extent refs 2 gen 7758 flags 258
[ 2403.690393] tree block backref root 1386
[ 2403.690393] shared block backref parent 315008581632
[ 2403.690394] item 85 key (315024556032 169 0) itemoff 12248 itemsize 42
[ 2403.690395] extent refs 2 gen 7758 flags 258
[ 2403.690396] tree block backref root 1386
[ 2403.690397] shared block backref parent 315008581632
[ 2403.690398] item 86 key (315024572416 169 0) itemoff 12215 itemsize 33
[ 2403.690399] extent refs 1 gen 8219 flags 2
[ 2403.690399] tree block backref root 1426
[ 2403.690401] item 87 key (315024588800 169 0) itemoff 12182 itemsize 33
[ 2403.690402] extent refs 1 gen 8219 flags 2
[ 2403.690402] tree block backref root 1426
[ 2403.690403] item 88 key (315024605184 169 0) itemoff 12149 itemsize 33
[ 2403.690404] extent refs 1 gen 8219 flags 2
[ 2403.690405] tree block backref root 1426
[ 2403.690406] item 89 key (315024621568 169 0) itemoff 12107 itemsize 42
[ 2403.690407] extent refs 2 gen 7758 flags 258
[ 2403.690408] tree block backref root 1386
[ 2403.690408] shared block backref parent 315008581632
[ 2403.690409] item 90 key (315024637952 169 0) itemoff 12074 itemsize 33
[ 2403.690410] extent refs 1 gen 8219 flags 2
[ 2403.690411] tree block backref root 1426
[ 2403.690412] item 91 key (315024654336 169 0) itemoff 12041 itemsize 33
[ 2403.690413] extent refs 1 gen 8219 flags 2
[ 2403.690414] tree block backref root 1426
[ 2403.690415] item 92 key (315024670720 169 0) itemoff 12008 itemsize 33
[ 2403.690416] extent refs 1 gen 8219 flags 2
[ 2403.690416] tree block backref root 1426
[ 2403.690417] item 93 key (315024687104 169 0) itemoff 11966 itemsize 42
[ 2403.690418] extent refs 2 gen 7758 flags 258
[ 2403.690419] tree block backref root 1386
[ 2403.690420] shared block backref parent 315008581632
[ 2403.690421] item 94 key (315024703488 169 0) itemoff 11924 itemsize 42
[ 2403.690422] extent refs 2 gen 7758 flags 258
[ 2403.690422] tree block backref root 1386
[ 2403.690423] shared block backref parent 315008581632
[ 2403.690424] item 95 key (315024719872 169 0) itemoff 11891 itemsize 33
[ 2403.690425] extent refs 1 gen 8219 flags 2
[ 2403.690426] tree block backref root 1426
[ 2403.690427] item 96 key (315024736256 169 0) itemoff 11813 itemsize 78
[ 2403.690428] extent refs 6 gen 8219 flags 2
[ 2403.690429] tree block backref root 1440
[ 2403.690429] tree block backref root 1439
[ 2403.690430] tree block backref root 1432
[ 2403.690431] tree block backref root 1431
[ 2403.690431] tree block backref root 1428
[ 2403.690432] tree block backref root 1426
[ 2403.690433] item 97 key (315024752640 169 0) itemoff 11735 itemsize 78
[ 2403.690434] extent refs 6 gen 8219 flags 2
[ 2403.690435] tree block backref root 1440
[ 2403.690436] tree block backref root 1439
[ 2403.690436] tree block backref root 1432
[ 2403.690437] tree block backref root 1431
[ 2403.690438] tree block backref root 1428
[ 2403.690438] tree block backref root 1426
[ 2403.690439] item 98 key (315024769024 169 0) itemoff 11702 itemsize 33
[ 2403.690440] extent refs 1 gen 7672 flags 258
[ 2403.690441] tree block backref root 1334
[ 2403.690442] item 99 key (315024785408 169 0) itemoff 11669 itemsize 33
[ 2403.690443] extent refs 1 gen 7672 flags 258
[ 2403.690444] tree block backref root 1334
[ 2403.690445] item 100 key (315024801792 169 0) itemoff 11636 itemsize 33
[ 2403.690446] extent refs 1 gen 7672 flags 258
[ 2403.690446] tree block backref root 1334
[ 2403.690448] item 101 key (315024818176 169 0) itemoff 11603 itemsize 33
[ 2403.690448] extent refs 1 gen 8286 flags 2
[ 2403.690449] tree block backref root 2
[ 2403.690450] item 102 key (315024834560 169 0) itemoff 11525 itemsize 78
[ 2403.690451] extent refs 6 gen 8219 flags 2
[ 2403.690452] tree block backref root 1440
[ 2403.690453] tree block backref root 1439
[ 2403.690453] tree block backref root 1432
[ 2403.690454] tree block backref root 1431
[ 2403.690455] tree block backref root 1428
[ 2403.690456] tree block backref root 1426
[ 2403.690457] item 103 key (315024850944 169 0) itemoff 11447 itemsize 78
[ 2403.690457] extent refs 6 gen 8219 flags 2
[ 2403.690458] tree block backref root 1440
[ 2403.690459] tree block backref root 1439
[ 2403.690460] tree block backref root 1432
[ 2403.690460] tree block backref root 1431
[ 2403.690461] tree block backref root 1428
[ 2403.690462] tree block backref root 1426
[ 2403.690463] item 104 key (315024867328 169 0) itemoff 11369 itemsize 78
[ 2403.690464] extent refs 6 gen 8219 flags 2
[ 2403.690464] tree block backref root 1440
[ 2403.690465] tree block backref root 1439
[ 2403.690466] tree block backref root 1432
[ 2403.690467] tree block backref root 1431
[ 2403.690467] tree block backref root 1428
[ 2403.690468] tree block backref root 1426
[ 2403.690469] item 105 key (315024883712 169 0) itemoff 11291 itemsize 78
[ 2403.690470] extent refs 6 gen 8219 flags 2
[ 2403.690471] tree block backref root 1440
[ 2403.690471] tree block backref root 1439
[ 2403.690472] tree block backref root 1432
[ 2403.690473] tree block backref root 1431
[ 2403.690474] tree block backref root 1428
[ 2403.690474] tree block backref root 1426
[ 2403.690475] item 106 key (315024900096 169 0) itemoff 11258 itemsize 33
[ 2403.690476] extent refs 1 gen 8286 flags 2
[ 2403.690477] tree block backref root 2
[ 2403.690478] item 107 key (315024916480 169 0) itemoff 11225 itemsize 33
[ 2403.690479] extent refs 1 gen 8286 flags 2
[ 2403.690480] tree block backref root 2
[ 2403.690481] item 108 key (315024932864 169 0) itemoff 11192 itemsize 33
[ 2403.690482] extent refs 1 gen 8286 flags 2
[ 2403.690482] tree block backref root 2
[ 2403.690483] item 109 key (315024949248 169 0) itemoff 11114 itemsize 78
[ 2403.690484] extent refs 6 gen 8219 flags 2
[ 2403.690485] tree block backref root 1440
[ 2403.690486] tree block backref root 1439
[ 2403.690486] tree block backref root 1432
[ 2403.690487] tree block backref root 1431
[ 2403.690488] tree block backref root 1428
[ 2403.690489] tree block backref root 1426
[ 2403.690490] item 110 key (315024965632 169 0) itemoff 11036 itemsize 78
[ 2403.690490] extent refs 6 gen 8219 flags 2
[ 2403.690491] tree block backref root 1440
[ 2403.690492] tree block backref root 1439
[ 2403.690493] tree block backref root 1432
[ 2403.690493] tree block backref root 1431
[ 2403.690494] tree block backref root 1428
[ 2403.690495] tree block backref root 1426
[ 2403.690496] item 111 key (315024982016 169 0) itemoff 10958 itemsize 78
[ 2403.690497] extent refs 6 gen 8219 flags 2
[ 2403.690497] tree block backref root 1440
[ 2403.690498] tree block backref root 1439
[ 2403.690499] tree block backref root 1432
[ 2403.690500] tree block backref root 1431
[ 2403.690500] tree block backref root 1428
[ 2403.690501] tree block backref root 1426
[ 2403.690502] item 112 key (315024998400 169 0) itemoff 10880 itemsize 78
[ 2403.690503] extent refs 6 gen 8219 flags 2
[ 2403.690504] tree block backref root 1440
[ 2403.690504] tree block backref root 1439
[ 2403.690505] tree block backref root 1432
[ 2403.690506] tree block backref root 1431
[ 2403.690507] tree block backref root 1428
[ 2403.690507] tree block backref root 1426
[ 2403.690508] item 113 key (315025014784 169 0) itemoff 10811 itemsize 69
[ 2403.690509] extent refs 5 gen 8012 flags 258
[ 2403.690510] tree block backref root 1433
[ 2403.690511] tree block backref root 1422
[ 2403.690511] tree block backref root 1418
[ 2403.690512] tree block backref root 1414
[ 2403.690513] shared block backref parent 305073094656
[ 2403.690514] item 114 key (315025031168 169 1) itemoff 10769 itemsize 42
[ 2403.690515] extent refs 2 gen 8012 flags 258
[ 2403.690516] tree block backref root 1414
[ 2403.690516] tree block backref root 1410
[ 2403.690517] item 115 key (315025047552 169 0) itemoff 10709 itemsize 60
[ 2403.690518] extent refs 4 gen 8012 flags 258
[ 2403.690519] tree block backref root 1433
[ 2403.690520] tree block backref root 1422
[ 2403.690520] tree block backref root 1418
[ 2403.690521] shared block backref parent 315025031168
[ 2403.690522] item 116 key (315025063936 169 0) itemoff 10649 itemsize 60
[ 2403.690523] extent refs 4 gen 8012 flags 258
[ 2403.690524] tree block backref root 1433
[ 2403.690525] tree block backref root 1422
[ 2403.690525] tree block backref root 1418
[ 2403.690526] shared block backref parent 315025031168
[ 2403.690527] item 117 key (315025080320 169 0) itemoff 10589 itemsize 60
[ 2403.690528] extent refs 4 gen 8012 flags 258
[ 2403.690529] tree block backref root 1433
[ 2403.690529] tree block backref root 1422
[ 2403.690530] tree block backref root 1418
[ 2403.690531] shared block backref parent 315025031168
[ 2403.690532] item 118 key (315025096704 169 1) itemoff 10547 itemsize 42
[ 2403.690533] extent refs 2 gen 8012 flags 258
[ 2403.690534] tree block backref root 1414
[ 2403.690534] tree block backref root 1410
[ 2403.690535] item 119 key (315025113088 169 0) itemoff 10496 itemsize 51
[ 2403.690536] extent refs 3 gen 8012 flags 258
[ 2403.690537] tree block backref root 1418
[ 2403.690538] shared block backref parent 315025096704
[ 2403.690539] shared block backref parent 315012513792
[ 2403.690540] item 120 key (315025129472 169 0) itemoff 10463 itemsize 33
[ 2403.690540] extent refs 1 gen 8012 flags 258
[ 2403.690541] shared block backref parent 315025096704
[ 2403.690542] item 121 key (315025145856 169 0) itemoff 10430 itemsize 33
[ 2403.690543] extent refs 1 gen 8219 flags 2
[ 2403.690544] tree block backref root 1426
[ 2403.690545] item 122 key (315025162240 169 0) itemoff 10352 itemsize 78
[ 2403.690546] extent refs 6 gen 8219 flags 2
[ 2403.690547] tree block backref root 1440
[ 2403.690547] tree block backref root 1439
[ 2403.690548] tree block backref root 1432
[ 2403.690549] tree block backref root 1431
[ 2403.690549] tree block backref root 1428
[ 2403.690550] tree block backref root 1426
[ 2403.690551] item 123 key (315025178624 169 0) itemoff 10274 itemsize 78
[ 2403.690552] extent refs 6 gen 8219 flags 2
[ 2403.690553] tree block backref root 1440
[ 2403.690554] tree block backref root 1439
[ 2403.690554] tree block backref root 1432
[ 2403.690555] tree block backref root 1431
[ 2403.690556] tree block backref root 1428
[ 2403.690556] tree block backref root 1426
[ 2403.690557] item 124 key (315025195008 169 0) itemoff 10232 itemsize 42
[ 2403.690558] extent refs 2 gen 8219 flags 2
[ 2403.690559] tree block backref root 1428
[ 2403.690560] tree block backref root 1426
[ 2403.690561] item 125 key (315025211392 169 0) itemoff 10154 itemsize 78
[ 2403.690562] extent refs 6 gen 8219 flags 2
[ 2403.690562] tree block backref root 1440
[ 2403.690563] tree block backref root 1439
[ 2403.690564] tree block backref root 1432
[ 2403.690565] tree block backref root 1431
[ 2403.690565] tree block backref root 1428
[ 2403.690566] tree block backref root 1426
[ 2403.690567] item 126 key (315025227776 169 0) itemoff 10121 itemsize 33
[ 2403.690568] extent refs 1 gen 8219 flags 2
[ 2403.690569] tree block backref root 1426
[ 2403.690570] item 127 key (315025244160 169 0) itemoff 10088 itemsize 33
[ 2403.690570] extent refs 1 gen 8219 flags 2
[ 2403.690571] tree block backref root 1426
[ 2403.690572] item 128 key (315025260544 169 0) itemoff 10037 itemsize 51
[ 2403.690573] extent refs 3 gen 8012 flags 258
[ 2403.690574] tree block backref root 1422
[ 2403.690575] tree block backref root 1418
[ 2403.690575] tree block backref root 1406
[ 2403.690576] item 129 key (315025276928 169 0) itemoff 10004 itemsize 33
[ 2403.690577] extent refs 1 gen 8286 flags 2
[ 2403.690578] tree block backref root 2
[ 2403.690579] item 130 key (315025293312 169 0) itemoff 9971 itemsize 33
[ 2403.690580] extent refs 1 gen 8286 flags 2
[ 2403.690581] tree block backref root 2
[ 2403.690582] item 131 key (315025309696 169 0) itemoff 9938 itemsize 33
[ 2403.690583] extent refs 1 gen 8286 flags 2
[ 2403.690583] tree block backref root 2
[ 2403.690584] item 132 key (315025326080 169 0) itemoff 9896 itemsize 42
[ 2403.690585] extent refs 2 gen 7758 flags 258
[ 2403.690586] tree block backref root 1386
[ 2403.690587] shared block backref parent 315008581632
[ 2403.690588] item 133 key (315025342464 169 0) itemoff 9854 itemsize 42
[ 2403.690589] extent refs 2 gen 7758 flags 258
[ 2403.690589] tree block backref root 1386
[ 2403.690590] shared block backref parent 315008581632
[ 2403.690591] item 134 key (315025358848 169 0) itemoff 9812 itemsize 42
[ 2403.690592] extent refs 2 gen 7758 flags 258
[ 2403.690593] tree block backref root 1386
[ 2403.690594] shared block backref parent 315008581632
[ 2403.690595] item 135 key (315025375232 169 0) itemoff 9770 itemsize 42
[ 2403.690596] extent refs 2 gen 7758 flags 258
[ 2403.690596] tree block backref root 1386
[ 2403.690597] shared block backref parent 315008581632
[ 2403.690598] item 136 key (315025391616 169 0) itemoff 9728 itemsize 42
[ 2403.690599] extent refs 2 gen 7758 flags 258
[ 2403.690600] tree block backref root 1386
[ 2403.690600] shared block backref parent 315008581632
[ 2403.690601] item 137 key (315025408000 169 0) itemoff 9686 itemsize 42
[ 2403.690602] extent refs 2 gen 7758 flags 258
[ 2403.690603] tree block backref root 1386
[ 2403.690604] shared block backref parent 315008581632
[ 2403.690605] item 138 key (315025424384 169 0) itemoff 9644 itemsize 42
[ 2403.690606] extent refs 2 gen 7758 flags 258
[ 2403.690606] tree block backref root 1386
[ 2403.690607] shared block backref parent 315008581632
[ 2403.690608] item 139 key (315025440768 169 0) itemoff 9602 itemsize 42
[ 2403.690609] extent refs 2 gen 7758 flags 258
[ 2403.690610] tree block backref root 1386
[ 2403.690610] shared block backref parent 315008581632
[ 2403.690612] item 140 key (315025457152 169 0) itemoff 9560 itemsize 42
[ 2403.690612] extent refs 2 gen 7758 flags 258
[ 2403.690613] tree block backref root 1386
[ 2403.690614] shared block backref parent 315008581632
[ 2403.690615] item 141 key (315025473536 169 0) itemoff 9527 itemsize 33
[ 2403.690616] extent refs 1 gen 8286 flags 2
[ 2403.690616] tree block backref root 2
[ 2403.690618] item 142 key (315025489920 169 0) itemoff 9485 itemsize 42
[ 2403.690618] extent refs 2 gen 7758 flags 258
[ 2403.690619] tree block backref root 1386
[ 2403.690620] shared block backref parent 315008581632
[ 2403.690621] item 143 key (315025506304 169 0) itemoff 9443 itemsize 42
[ 2403.690622] extent refs 2 gen 7758 flags 258
[ 2403.690622] tree block backref root 1386
[ 2403.690623] shared block backref parent 315008581632
[ 2403.690624] item 144 key (315025522688 169 0) itemoff 9401 itemsize 42
[ 2403.690625] extent refs 2 gen 7758 flags 258
[ 2403.690626] tree block backref root 1386
[ 2403.690627] shared block backref parent 315008581632
[ 2403.690628] item 145 key (315025539072 169 0) itemoff 9359 itemsize 42
[ 2403.690629] extent refs 2 gen 7758 flags 258
[ 2403.690629] tree block backref root 1386
[ 2403.690630] shared block backref parent 315008581632
[ 2403.690631] item 146 key (315025555456 169 0) itemoff 9317 itemsize 42
[ 2403.690632] extent refs 2 gen 7758 flags 258
[ 2403.690633] tree block backref root 1386
[ 2403.690633] shared block backref parent 315008581632
[ 2403.690643] item 147 key (315025571840 169 0) itemoff 9275 itemsize 42
[ 2403.690644] extent refs 2 gen 7758 flags 258
[ 2403.690645] tree block backref root 1386
[ 2403.690645] shared block backref parent 315008581632
[ 2403.690646] item 148 key (315025588224 169 0) itemoff 9233 itemsize 42
[ 2403.690647] extent refs 2 gen 7758 flags 258
[ 2403.690648] tree block backref root 1386
[ 2403.690649] shared block backref parent 315008581632
[ 2403.690650] item 149 key (315025604608 169 0) itemoff 9191 itemsize 42
[ 2403.690650] extent refs 2 gen 7758 flags 258
[ 2403.690651] tree block backref root 1386
[ 2403.690652] shared block backref parent 315008581632
[ 2403.690653] item 150 key (315025620992 169 0) itemoff 9149 itemsize 42
[ 2403.690654] extent refs 2 gen 7758 flags 258
[ 2403.690654] tree block backref root 1386
[ 2403.690655] shared block backref parent 315008581632
[ 2403.690656] item 151 key (315025637376 169 0) itemoff 9107 itemsize 42
[ 2403.690657] extent refs 2 gen 7758 flags 258
[ 2403.690658] tree block backref root 1386
[ 2403.690658] shared block backref parent 315008581632
[ 2403.690659] item 152 key (315025653760 169 0) itemoff 9074 itemsize 33
[ 2403.690660] extent refs 1 gen 8286 flags 2
[ 2403.690661] tree block backref root 2
[ 2403.690662] item 153 key (315025670144 169 0) itemoff 9041 itemsize 33
[ 2403.690663] extent refs 1 gen 8286 flags 2
[ 2403.690663] tree block backref root 2
[ 2403.690664] item 154 key (315025686528 169 0) itemoff 9008 itemsize 33
[ 2403.690665] extent refs 1 gen 8286 flags 2
[ 2403.690666] tree block backref root 2
[ 2403.690667] item 155 key (315025702912 169 0) itemoff 8975 itemsize 33
[ 2403.690668] extent refs 1 gen 8286 flags 2
[ 2403.690668] tree block backref root 2
[ 2403.690669] item 156 key (315025719296 169 0) itemoff 8942 itemsize 33
[ 2403.690670] extent refs 1 gen 8286 flags 2
[ 2403.690671] tree block backref root 2
[ 2403.690672] item 157 key (315025735680 169 0) itemoff 8909 itemsize 33
[ 2403.690673] extent refs 1 gen 8188 flags 2
[ 2403.690674] tree block backref root 1422
[ 2403.690675] item 158 key (315025752064 169 0) itemoff 8876 itemsize 33
[ 2403.690675] extent refs 1 gen 7672 flags 258
[ 2403.690676] tree block backref root 1334
[ 2403.690677] item 159 key (315025768448 169 0) itemoff 8843 itemsize 33
[ 2403.690678] extent refs 1 gen 8286 flags 2
[ 2403.690679] tree block backref root 2
[ 2403.690680] item 160 key (315025784832 169 0) itemoff 8810 itemsize 33
[ 2403.690681] extent refs 1 gen 7672 flags 258
[ 2403.690681] tree block backref root 1334
[ 2403.690682] item 161 key (315025801216 169 0) itemoff 8777 itemsize 33
[ 2403.690683] extent refs 1 gen 8286 flags 2
[ 2403.690684] tree block backref root 2
[ 2403.690685] item 162 key (315025817600 169 0) itemoff 8744 itemsize 33
[ 2403.690686] extent refs 1 gen 8286 flags 2
[ 2403.690686] tree block backref root 2
[ 2403.690687] item 163 key (315025833984 169 0) itemoff 8711 itemsize 33
[ 2403.690688] extent refs 1 gen 8286 flags 2
[ 2403.690689] tree block backref root 2
[ 2403.690690] item 164 key (315025850368 169 0) itemoff 8678 itemsize 33
[ 2403.690691] extent refs 1 gen 8286 flags 2
[ 2403.690692] tree block backref root 2
[ 2403.690693] item 165 key (315025866752 169 0) itemoff 8645 itemsize 33
[ 2403.690693] extent refs 1 gen 8286 flags 2
[ 2403.690694] tree block backref root 2
[ 2403.690695] item 166 key (315025883136 169 0) itemoff 8567 itemsize 78
[ 2403.690696] extent refs 6 gen 8219 flags 2
[ 2403.690697] tree block backref root 1440
[ 2403.690697] tree block backref root 1439
[ 2403.690698] tree block backref root 1432
[ 2403.690699] tree block backref root 1431
[ 2403.690700] tree block backref root 1428
[ 2403.690700] tree block backref root 1426
[ 2403.690701] item 167 key (315025899520 169 0) itemoff 8489 itemsize 78
[ 2403.690702] extent refs 6 gen 8219 flags 2
[ 2403.690703] tree block backref root 1440
[ 2403.690703] tree block backref root 1439
[ 2403.690704] tree block backref root 1432
[ 2403.690705] tree block backref root 1431
[ 2403.690705] tree block backref root 1428
[ 2403.690706] tree block backref root 1426
[ 2403.690707] item 168 key (315025915904 169 0) itemoff 8447 itemsize 42
[ 2403.690708] extent refs 2 gen 7758 flags 258
[ 2403.690709] tree block backref root 1386
[ 2403.690709] shared block backref parent 315008581632
[ 2403.690710] item 169 key (315025932288 169 0) itemoff 8405 itemsize 42
[ 2403.690711] extent refs 2 gen 7758 flags 258
[ 2403.690712] tree block backref root 1386
[ 2403.690713] shared block backref parent 315008581632
[ 2403.690714] item 170 key (315025948672 169 0) itemoff 8363 itemsize 42
[ 2403.690715] extent refs 2 gen 7758 flags 258
[ 2403.690715] tree block backref root 1386
[ 2403.690716] shared block backref parent 315008581632
[ 2403.690717] item 171 key (315025965056 169 0) itemoff 8321 itemsize 42
[ 2403.690718] extent refs 2 gen 7758 flags 258
[ 2403.690719] tree block backref root 1386
[ 2403.690719] shared block backref parent 315008581632
[ 2403.690720] item 172 key (315025981440 169 0) itemoff 8243 itemsize 78
[ 2403.690721] extent refs 6 gen 8219 flags 2
[ 2403.690722] tree block backref root 1440
[ 2403.690723] tree block backref root 1439
[ 2403.690723] tree block backref root 1432
[ 2403.690724] tree block backref root 1431
[ 2403.690725] tree block backref root 1428
[ 2403.690725] tree block backref root 1426
[ 2403.690726] item 173 key (315025997824 169 0) itemoff 8201 itemsize 42
[ 2403.690727] extent refs 2 gen 7758 flags 258
[ 2403.690728] tree block backref root 1386
[ 2403.690729] shared block backref parent 315008581632
[ 2403.690730] item 174 key (315026014208 169 0) itemoff 8123 itemsize 78
[ 2403.690731] extent refs 6 gen 8219 flags 2
[ 2403.690731] tree block backref root 1440
[ 2403.690732] tree block backref root 1439
[ 2403.690733] tree block backref root 1432
[ 2403.690733] tree block backref root 1431
[ 2403.690734] tree block backref root 1428
[ 2403.690735] tree block backref root 1426
[ 2403.690736] item 175 key (315026030592 169 0) itemoff 8081 itemsize 42
[ 2403.690737] extent refs 2 gen 7758 flags 258
[ 2403.690737] tree block backref root 1386
[ 2403.690738] shared block backref parent 315008581632
[ 2403.690739] item 176 key (315026046976 169 0) itemoff 8039 itemsize 42
[ 2403.690740] extent refs 2 gen 7758 flags 258
[ 2403.690741] tree block backref root 1386
[ 2403.690741] shared block backref parent 315008581632
[ 2403.690742] item 177 key (315026063360 169 0) itemoff 7997 itemsize 42
[ 2403.690743] extent refs 2 gen 7758 flags 258
[ 2403.690744] tree block backref root 1386
[ 2403.690745] shared block backref parent 315008581632
[ 2403.690746] item 178 key (315026079744 169 0) itemoff 7955 itemsize 42
[ 2403.690747] extent refs 2 gen 7758 flags 258
[ 2403.690747] tree block backref root 1386
[ 2403.690748] shared block backref parent 315008581632
[ 2403.690749] item 179 key (315026096128 169 0) itemoff 7877 itemsize 78
[ 2403.690750] extent refs 6 gen 8219 flags 2
[ 2403.690751] tree block backref root 1440
[ 2403.690751] tree block backref root 1439
[ 2403.690752] tree block backref root 1432
[ 2403.690753] tree block backref root 1431
[ 2403.690754] tree block backref root 1428
[ 2403.690754] tree block backref root 1426
[ 2403.690755] item 180 key (315026112512 169 0) itemoff 7799 itemsize 78
[ 2403.690756] extent refs 6 gen 8219 flags 2
[ 2403.690757] tree block backref root 1440
[ 2403.690758] tree block backref root 1439
[ 2403.690758] tree block backref root 1432
[ 2403.690759] tree block backref root 1431
[ 2403.690760] tree block backref root 1428
[ 2403.690760] tree block backref root 1426
[ 2403.690761] item 181 key (315026128896 169 0) itemoff 7766 itemsize 33
[ 2403.690762] extent refs 1 gen 8286 flags 2
[ 2403.690763] tree block backref root 2
[ 2403.690764] item 182 key (315026145280 169 0) itemoff 7688 itemsize 78
[ 2403.690765] extent refs 6 gen 8219 flags 2
[ 2403.690766] tree block backref root 1440
[ 2403.690766] tree block backref root 1439
[ 2403.690767] tree block backref root 1432
[ 2403.690768] tree block backref root 1431
[ 2403.690768] tree block backref root 1428
[ 2403.690769] tree block backref root 1426
[ 2403.690770] item 183 key (315026161664 169 0) itemoff 7655 itemsize 33
[ 2403.690771] extent refs 1 gen 8286 flags 2
[ 2403.690772] tree block backref root 2
[ 2403.690773] item 184 key (315026178048 169 0) itemoff 7613 itemsize 42
[ 2403.690774] extent refs 2 gen 8188 flags 2
[ 2403.690774] tree block backref root 1423
[ 2403.690775] tree block backref root 1422
[ 2403.690776] item 185 key (315026194432 169 0) itemoff 7580 itemsize 33
[ 2403.690777] extent refs 1 gen 8286 flags 2
[ 2403.690778] tree block backref root 2
[ 2403.690779] item 186 key (315026210816 169 0) itemoff 7502 itemsize 78
[ 2403.690779] extent refs 6 gen 8219 flags 2
[ 2403.690780] tree block backref root 1440
[ 2403.690781] tree block backref root 1439
[ 2403.690782] tree block backref root 1432
[ 2403.690782] tree block backref root 1431
[ 2403.690783] tree block backref root 1428
[ 2403.690784] tree block backref root 1426
[ 2403.690785] item 187 key (315026227200 169 0) itemoff 7469 itemsize 33
[ 2403.690785] extent refs 1 gen 8286 flags 2
[ 2403.690786] tree block backref root 2
[ 2403.690787] item 188 key (315026243584 169 0) itemoff 7436 itemsize 33
[ 2403.690788] extent refs 1 gen 8286 flags 2
[ 2403.690789] tree block backref root 2
[ 2403.690790] item 189 key (315026259968 169 0) itemoff 7403 itemsize 33
[ 2403.690791] extent refs 1 gen 8286 flags 2
[ 2403.690791] tree block backref root 2
[ 2403.690792] item 190 key (315026276352 169 0) itemoff 7370 itemsize 33
[ 2403.690793] extent refs 1 gen 8286 flags 2
[ 2403.690794] tree block backref root 2
[ 2403.690795] item 191 key (315026309120 169 0) itemoff 7337 itemsize 33
[ 2403.690796] extent refs 1 gen 8286 flags 2
[ 2403.690797] tree block backref root 2
[ 2403.690798] item 192 key (315026325504 169 0) itemoff 7304 itemsize 33
[ 2403.690798] extent refs 1 gen 8286 flags 2
[ 2403.690799] tree block backref root 2
[ 2403.690800] item 193 key (315026358272 169 0) itemoff 7271 itemsize 33
[ 2403.690801] extent refs 1 gen 8286 flags 2
[ 2403.690802] tree block backref root 2
[ 2403.690803] item 194 key (315026374656 169 0) itemoff 7238 itemsize 33
[ 2403.690804] extent refs 1 gen 8286 flags 2
[ 2403.690804] tree block backref root 2
[ 2403.690805] item 195 key (315026391040 169 0) itemoff 7205 itemsize 33
[ 2403.690806] extent refs 1 gen 8286 flags 2
[ 2403.690807] tree block backref root 2
[ 2403.690808] item 196 key (315026407424 169 0) itemoff 7172 itemsize 33
[ 2403.690809] extent refs 1 gen 8286 flags 2
[ 2403.690810] tree block backref root 2
[ 2403.690811] item 197 key (315026423808 169 0) itemoff 7139 itemsize 33
[ 2403.690812] extent refs 1 gen 8286 flags 2
[ 2403.690812] tree block backref root 2
[ 2403.690813] item 198 key (315026440192 169 0) itemoff 7106 itemsize 33
[ 2403.690814] extent refs 1 gen 8286 flags 2
[ 2403.690815] tree block backref root 2
[ 2403.690816] item 199 key (315026456576 169 0) itemoff 7073 itemsize 33
[ 2403.690817] extent refs 1 gen 8286 flags 2
[ 2403.690817] tree block backref root 2
[ 2403.690818] item 200 key (315026472960 169 0) itemoff 7040 itemsize 33
[ 2403.690819] extent refs 1 gen 8286 flags 2
[ 2403.690820] tree block backref root 2
[ 2403.690821] item 201 key (315026489344 169 0) itemoff 7007 itemsize 33
[ 2403.690822] extent refs 1 gen 8286 flags 2
[ 2403.690823] tree block backref root 2
[ 2403.690824] item 202 key (315026604032 169 0) itemoff 6974 itemsize 33
[ 2403.690824] extent refs 1 gen 7672 flags 258
[ 2403.690825] tree block backref root 1334
[ 2403.690826] item 203 key (315026669568 169 0) itemoff 6941 itemsize 33
[ 2403.690827] extent refs 1 gen 7672 flags 258
[ 2403.690828] tree block backref root 1334
[ 2403.690829] item 204 key (315026685952 169 0) itemoff 6908 itemsize 33
[ 2403.690830] extent refs 1 gen 7672 flags 258
[ 2403.690830] tree block backref root 1334
[ 2403.690832] item 205 key (315026718720 169 0) itemoff 6875 itemsize 33
[ 2403.690832] extent refs 1 gen 7672 flags 258
[ 2403.690833] tree block backref root 1334
[ 2403.690834] item 206 key (315026751488 169 0) itemoff 6842 itemsize 33
[ 2403.690835] extent refs 1 gen 8286 flags 2
[ 2403.690836] tree block backref root 1442
[ 2403.690837] item 207 key (315026800640 169 0) itemoff 6809 itemsize 33
[ 2403.690838] extent refs 1 gen 7672 flags 258
[ 2403.690839] tree block backref root 1334
[ 2403.690840] item 208 key (315026817024 169 0) itemoff 6776 itemsize 33
[ 2403.690841] extent refs 1 gen 7672 flags 258
[ 2403.690842] tree block backref root 1334
[ 2403.690843] item 209 key (315026833408 169 0) itemoff 6743 itemsize 33
[ 2403.690844] extent refs 1 gen 7672 flags 258
[ 2403.690844] tree block backref root 1334
[ 2403.690845] item 210 key (315026849792 169 0) itemoff 6701 itemsize 42
[ 2403.690846] extent refs 2 gen 7758 flags 258
[ 2403.690847] tree block backref root 1386
[ 2403.690848] shared block backref parent 315008581632
[ 2403.690849] item 211 key (315026866176 169 0) itemoff 6668 itemsize 33
[ 2403.690850] extent refs 1 gen 8286 flags 2
[ 2403.690851] tree block backref root 1442
[ 2403.690852] item 212 key (315026882560 169 0) itemoff 6626 itemsize 42
[ 2403.690852] extent refs 2 gen 7758 flags 258
[ 2403.690853] tree block backref root 1386
[ 2403.690854] shared block backref parent 315008581632
[ 2403.690855] item 213 key (315026898944 169 0) itemoff 6593 itemsize 33
[ 2403.690856] extent refs 1 gen 8286 flags 2
[ 2403.690856] tree block backref root 1442
[ 2403.690857] item 214 key (315026915328 169 1) itemoff 6560 itemsize 33
[ 2403.690858] extent refs 1 gen 8286 flags 2
[ 2403.690859] tree block backref root 1442
[ 2403.690860] item 215 key (315026931712 169 0) itemoff 6527 itemsize 33
[ 2403.690861] extent refs 1 gen 8286 flags 2
[ 2403.690862] tree block backref root 1442
[ 2403.690863] item 216 key (315026948096 169 0) itemoff 6485 itemsize 42
[ 2403.690864] extent refs 2 gen 7758 flags 258
[ 2403.690864] tree block backref root 1386
[ 2403.690865] shared block backref parent 315008581632
[ 2403.690866] item 217 key (315026964480 169 0) itemoff 6443 itemsize 42
[ 2403.690867] extent refs 2 gen 7758 flags 258
[ 2403.690868] tree block backref root 1386
[ 2403.690868] shared block backref parent 315008581632
[ 2403.690869] item 218 key (315026980864 169 0) itemoff 6401 itemsize 42
[ 2403.690870] extent refs 2 gen 7758 flags 258
[ 2403.690871] tree block backref root 1386
[ 2403.690872] shared block backref parent 315008581632
[ 2403.690873] item 219 key (315026997248 169 0) itemoff 6359 itemsize 42
[ 2403.690874] extent refs 2 gen 7758 flags 258
[ 2403.690874] tree block backref root 1386
[ 2403.690875] shared block backref parent 315008581632
[ 2403.690876] item 220 key (315027013632 169 0) itemoff 6317 itemsize 42
[ 2403.690877] extent refs 2 gen 7758 flags 258
[ 2403.690878] tree block backref root 1386
[ 2403.690878] shared block backref parent 315008581632
[ 2403.690879] item 221 key (315027030016 169 0) itemoff 6275 itemsize 42
[ 2403.690880] extent refs 2 gen 7758 flags 258
[ 2403.690881] tree block backref root 1386
[ 2403.690882] shared block backref parent 315008581632
[ 2403.690883] item 222 key (315027046400 169 0) itemoff 6233 itemsize 42
[ 2403.690884] extent refs 2 gen 7758 flags 258
[ 2403.690884] tree block backref root 1386
[ 2403.690885] shared block backref parent 315008581632
[ 2403.690886] item 223 key (315027062784 169 0) itemoff 6191 itemsize 42
[ 2403.690887] extent refs 2 gen 7758 flags 258
[ 2403.690888] tree block backref root 1386
[ 2403.690888] shared block backref parent 315008581632
[ 2403.690889] item 224 key (315027079168 169 0) itemoff 6149 itemsize 42
[ 2403.690890] extent refs 2 gen 7758 flags 258
[ 2403.690891] tree block backref root 1386
[ 2403.690892] shared block backref parent 315008581632
[ 2403.690893] item 225 key (315027095552 169 0) itemoff 6107 itemsize 42
[ 2403.690894] extent refs 2 gen 7758 flags 258
[ 2403.690894] tree block backref root 1386
[ 2403.690895] shared block backref parent 315008581632
[ 2403.690896] item 226 key (315027111936 169 0) itemoff 6065 itemsize 42
[ 2403.690897] extent refs 2 gen 7758 flags 258
[ 2403.690898] tree block backref root 1386
[ 2403.690898] shared block backref parent 315008581632
[ 2403.690899] item 227 key (315027128320 169 0) itemoff 6023 itemsize 42
[ 2403.690900] extent refs 2 gen 7758 flags 258
[ 2403.690901] tree block backref root 1386
[ 2403.690902] shared block backref parent 315008581632
[ 2403.690903] item 228 key (315027144704 169 0) itemoff 5981 itemsize 42
[ 2403.690903] extent refs 2 gen 7758 flags 258
[ 2403.690904] tree block backref root 1386
[ 2403.690905] shared block backref parent 315008581632
[ 2403.690906] item 229 key (315027161088 169 0) itemoff 5939 itemsize 42
[ 2403.690907] extent refs 2 gen 7758 flags 258
[ 2403.690907] tree block backref root 1386
[ 2403.690908] shared block backref parent 315008581632
[ 2403.690909] item 230 key (315027177472 169 0) itemoff 5897 itemsize 42
[ 2403.690910] extent refs 2 gen 7758 flags 258
[ 2403.690911] tree block backref root 1386
[ 2403.690912] shared block backref parent 315008581632
[ 2403.690913] BTRFS error (device sdc1): unable to find ref byte nr
315025031168 parent 0 root 1406  owner 1 offset 0
[ 2403.690915] ------------[ cut here ]------------
[ 2403.690922] WARNING: CPU: 0 PID: 8190 at
/home/kernel/COD/linux/fs/btrfs/super.c:260
__btrfs_abort_transaction+0x54/0x130 [btrfs]()
[ 2403.690923] BTRFS: Transaction aborted (error -2)
[ 2403.690924] Modules linked in: ctr ccm msr binfmt_misc bnep
bbswitch(OE) nls_iso8859_1 ses enclosure arc4 intel_rapl iosf_mbi
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iwlmvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mac80211 aesni_intel
aes_x86_64 lrw gf128mul uvcvideo glue_helper ablk_helper
videobuf2_vmalloc iwlwifi cryptd videobuf2_memops videobuf2_core
v4l2_common videodev serio_raw joydev btusb uas media cfg80211
rtsx_pci_ms bluetooth memstick lpc_ich wmi intel_rst mac_hid
thinkpad_acpi snd_hda_codec_hdmi nvram snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec
snd_hwdep snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq
snd_seq_device snd_timer snd mei_me mei soundcore ie31200_edac
edac_core shpchp parport_pc ppdev
[ 2403.690948]  lp parport autofs4 btrfs xor raid6_pq hid_generic
usbhid hid usb_storage i915 rtsx_pci_sdmmc i2c_algo_bit drm_kms_helper
drm e1000e psmouse ahci ptp libahci rtsx_pci pps_core video
[ 2403.690958] CPU: 0 PID: 8190 Comm: kworker/u16:1 Tainted: G
W  OE   4.0.7-040007-generic #201507031036
[ 2403.690959] Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS
GLET76WW (2.30 ) 01/07/2015
[ 2403.690968] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 2403.690969]  ffffffffc0599f60 ffff880219da79f8 ffffffff817b5644
0000000000000000
[ 2403.690971]  ffff880219da7a48 ffff880219da7a38 ffffffff81075e3a
ffff880219da7a58
[ 2403.690973]  ffff88042a2e7d10 ffff8803e9e35800 00000000fffffffe
ffffffffc0596090
[ 2403.690975] Call Trace:
[ 2403.690979]  [<ffffffff817b5644>] dump_stack+0x45/0x57
[ 2403.690981]  [<ffffffff81075e3a>] warn_slowpath_common+0x8a/0xc0
[ 2403.690984]  [<ffffffff81075eb6>] warn_slowpath_fmt+0x46/0x50
[ 2403.690991]  [<ffffffffc04e8cf4>]
__btrfs_abort_transaction+0x54/0x130 [btrfs]
[ 2403.690999]  [<ffffffffc04fc1eb>] __btrfs_free_extent+0xbbb/0xbf0 [btrfs]
[ 2403.691010]  [<ffffffffc05616a5>] ? find_ref_head+0x65/0x90 [btrfs]
[ 2403.691019]  [<ffffffffc0501773>]
__btrfs_run_delayed_refs+0x973/0x1200 [btrfs]
[ 2403.691021]  [<ffffffff817b2482>] ? __slab_free+0x104/0x25c
[ 2403.691025]  [<ffffffff811d2c49>] ? kmem_cache_alloc+0x1a9/0x230
[ 2403.691033]  [<ffffffffc05060f3>]
btrfs_run_delayed_refs.part.66+0x73/0x270 [btrfs]
[ 2403.691041]  [<ffffffffc0506398>] delayed_ref_async_start+0x88/0xa0 [btrfs]
[ 2403.691052]  [<ffffffffc0547442>] normal_work_helper+0xc2/0x2b0 [btrfs]
[ 2403.691061]  [<ffffffffc0547862>] btrfs_extent_refs_helper+0x12/0x20 [btrfs]
[ 2403.691063]  [<ffffffff8108f05f>] process_one_work+0x14f/0x420
[ 2403.691065]  [<ffffffff8108f818>] worker_thread+0x118/0x510
[ 2403.691067]  [<ffffffff8108f700>] ? rescuer_thread+0x3d0/0x3d0
[ 2403.691069]  [<ffffffff81094cc9>] kthread+0xc9/0xe0
[ 2403.691071]  [<ffffffff81094c00>] ? kthread_create_on_node+0x180/0x180
[ 2403.691074]  [<ffffffff817bced8>] ret_from_fork+0x58/0x90
[ 2403.691076]  [<ffffffff81094c00>] ? kthread_create_on_node+0x180/0x180
[ 2403.691077] ---[ end trace 3b99dae1af3249b2 ]---
[ 2403.691079] BTRFS: error (device sdc1) in __btrfs_free_extent:5974:
errno=-2 No such entry
[ 2403.691080] BTRFS info (device sdc1): forced readonly
[ 2403.691082] BTRFS: error (device sdc1) in
btrfs_run_delayed_refs:2790: errno=-2 No such entry
