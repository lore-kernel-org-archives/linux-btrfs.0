Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34921 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbcFOGab (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 02:30:31 -0400
Received: by mail-wm0-f42.google.com with SMTP id v199so148609107wmv.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 23:30:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9QOun4rHcd6om7ZXaiv=ZGMCSufcZTJAFs2Sop=vBhcnxHJQ@mail.gmail.com>
References: <CAK9QOun4rHcd6om7ZXaiv=ZGMCSufcZTJAFs2Sop=vBhcnxHJQ@mail.gmail.com>
From: Paul Verreth <paul@verreth.be>
Date: Wed, 15 Jun 2016 08:29:49 +0200
Message-ID: <CAK9QOu=yjjPtq0DMDF_JG3qsjs4pJjCzHhrRDwx8QPkDT_xxaA@mail.gmail.com>
Subject: Fwd: BTRFS, remarkable problem: filesystem turns to read-only caused
 by firefox download
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all.

When I download a video using  Firefox DownloadHelper addon, the
filesystem suddenly turns read only. Not a coincedence, I tried it
several times, and it happened every time again

Info:
Linux wolfgang 4.2.0-35-generic #40-Ubuntu SMP Tue Mar 15 22:15:45 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.0

firefox --version
Mozilla Firefox 46.0

package: btrfs-tools
State: installed
Automatically installed: no
Version: 4.0-2
Priority: optional
Section: admin
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Architecture: amd64
Uncompressed Size: 3.518 k
Depends: e2fslibs (>= 1.42), libblkid1 (>= 2.17.2), libc6 (>= 2.8), libcomerr2
         (>= 1.01), liblzo2-2, libuuid1 (>= 2.16), zlib1g (>= 1:1.2.0)
Conflicts: btrfs-tools
Description: Checksumming Copy on Write Filesystem utilities

Homepage: http://btrfs.wiki.kernel.org/


extract from dmesg:

[171145.415378] tree block key (18446744073709551611 48 3255000) level 0
[171145.415379] shared block backref parent 203105845248
[171145.415379] item 4 key (75093737472 168 4096) itemoff 3740 itemsize 51
[171145.415380] extent refs 1 gen 1551545 flags 258
[171145.415381] tree block key (3547221 12 3547219) level 0
[171145.415381] shared block backref parent 75092348928
[171145.415382] item 5 key (75093741568 168 4096) itemoff 3689 itemsize 51
[171145.415382] extent refs 1 gen 1452265 flags 258
[171145.415383] tree block key (3280755 12 3280753) level 0
[171145.415383] shared block backref parent 203105845248
[171145.415384] item 6 key (75093745664 168 4096) itemoff 3638 itemsize 51
[171145.415385] extent refs 1 gen 1452265 flags 258
[171145.415385] tree block key (18446744073709551611 48 3255000) level 0
[171145.415386] shared block backref parent 203105845248
[171145.415386] item 7 key (75093749760 168 4096) itemoff 3587 itemsize 51
[171145.415387] extent refs 1 gen 1514341 flags 258
[171145.415387] tree block key (3473870 1 0) level 0
[171145.415388] shared block backref parent 75091329024
[171145.415388] item 8 key (75093753856 168 4096) itemoff 3536 itemsize 51
[171145.415389] extent refs 1 gen 1597177 flags 258
[171145.415390] tree block key (2921841 108 6848512) level 0
[171145.415390] shared block backref parent 75091030016
[171145.415391] item 9 key (75093757952 168 4096) itemoff 3485 itemsize 51
[171145.415391] extent refs 1 gen 1452265 flags 258
[171145.415392] tree block key (18446744073709551611 48 3254998) level 0
[171145.415392] shared block backref parent 203105845248
[171145.415393] item 10 key (75093766144 168 4096) itemoff 3434 itemsize 51
[171145.415394] extent refs 1 gen 1452265 flags 258
[171145.415394] tree block key (3280757 96 12) level 0
[171145.415395] shared block backref parent 203105845248
[171145.415395] item 11 key (75093770240 168 4096) itemoff 3383 itemsize 51
[171145.415396] extent refs 1 gen 1452265 flags 258
[171145.415396] tree block key (18446744073709551611 48 3254998) level 0
[171145.415397] shared block backref parent 203105845248
[171145.415398] item 12 key (75093774336 168 4096) itemoff 3332 itemsize 51
[171145.415398] extent refs 1 gen 1452265 flags 258
[171145.415399] tree block key (3280738 84 4205285998) level 0
[171145.415399] shared block backref parent 203105845248
[171145.415400] item 13 key (75093778432 168 4096) itemoff 3281 itemsize 51
[171145.415400] extent refs 1 gen 1452265 flags 258
[171145.415401] tree block key (18446744073709551611 48 3254998) level 0
[171145.415401] shared block backref parent 203105845248
[171145.415402] item 14 key (75093782528 168 4096) itemoff 3230 itemsize 51
[171145.415403] extent refs 1 gen 1551545 flags 258
[171145.415403] tree block key (3547236 84 3743801254) level 0
[171145.415404] shared block backref parent 75092348928
[171145.415404] item 15 key (75093790720 168 4096) itemoff 3179 itemsize 51
[171145.415405] extent refs 1 gen 305740 flags 258
[171145.415406] tree block key (831798 96 265) level 0
[171145.415406] shared block backref parent 25729994752
[171145.415407] item 16 key (75093794816 168 4096) itemoff 3128 itemsize 51
[171145.415407] extent refs 1 gen 1525268 flags 2
[171145.415408] tree block key (11528453 1 0) level 0
[171145.415408] tree block backref root 281474976710913
[171145.415409] item 17 key (75093798912 168 4096) itemoff 3077 itemsize 51
[171145.415410] extent refs 1 gen 1452265 flags 258
[171145.415410] tree block key (18446744073709551611 48 3254998) level 0
[171145.415411] shared block backref parent 203105845248
[171145.415411] item 18 key (75093803008 168 4096) itemoff 3026 itemsize 51
[171145.415412] extent refs 1 gen 1452265 flags 258
[171145.415413] tree block key (18446744073709551611 48 3255000) level 0
[171145.415413] shared block backref parent 203105845248
[171145.415414] item 19 key (75093807104 168 4096) itemoff 2975 itemsize 51
[171145.415414] extent refs 1 gen 1141992 flags 2
[171145.415415] tree block key (25600704512 168 4096) level 0
[171145.415415] tree block backref root 2
[171145.415416] item 20 key (75093811200 168 4096) itemoff 2924 itemsize 51
[171145.415417] extent refs 1 gen 1452265 flags 258
[171145.415417] tree block key (3280757 96 31) level 0
[171145.415418] shared block backref parent 203105845248
[171145.415418] item 21 key (75093815296 168 4096) itemoff 2873 itemsize 51
[171145.415419] extent refs 1 gen 1452265 flags 258
[171145.415419] tree block key (18446744073709551611 48 3255000) level 0
[171145.415420] shared block backref parent 203105845248
[171145.415421] item 22 key (75093819392 168 4096) itemoff 2822 itemsize 51
[171145.415421] extent refs 1 gen 1452265 flags 258
[171145.415422] tree block key (3280781 12 3280779) level 0
[171145.415422] shared block backref parent 203105845248
[171145.415423] item 23 key (75093823488 168 4096) itemoff 2771 itemsize 51
[171145.415423] extent refs 1 gen 1452265 flags 258
[171145.415424] tree block key (18446744073709551611 48 3254998) level 0
[171145.415424] shared block backref parent 203105845248
[171145.415425] item 24 key (75093827584 168 4096) itemoff 2720 itemsize 51
[171145.415426] extent refs 1 gen 1452265 flags 258
[171145.415426] tree block key (18446744073709551611 48 3255002) level 0
[171145.415427] shared block backref parent 203105845248
[171145.415427] item 25 key (75093831680 168 4096) itemoff 2669 itemsize 51
[171145.415428] extent refs 1 gen 1788602 flags 2
[171145.415428] tree block key (12540900 108 0) level 0
[171145.415429] tree block backref root 257
[171145.415430] item 26 key (75093835776 168 4096) itemoff 2618 itemsize 51
[171145.415430] extent refs 1 gen 1551545 flags 258
[171145.415431] tree block key (3542361 96 2439) level 0
[171145.415431] shared block backref parent 75084333056
[171145.415432] item 27 key (75093839872 168 4096) itemoff 2567 itemsize 51
[171145.415432] extent refs 1 gen 1551545 flags 258
[171145.415433] tree block key (3542362 12 3542361) level 0
[171145.415433] shared block backref parent 75084333056
[171145.415434] item 28 key (75093843968 168 4096) itemoff 2516 itemsize 51
[171145.415435] extent refs 1 gen 1514341 flags 258
[171145.415435] tree block key (3473886 12 3430958) level 0
[171145.415436] shared block backref parent 75091329024
[171145.415436] item 29 key (75093848064 168 4096) itemoff 2465 itemsize 51
[171145.415437] extent refs 1 gen 1514341 flags 258
[171145.415437] tree block key (3430958 84 3499949893) level 0
[171145.415438] shared block backref parent 75073060864
[171145.415439] item 30 key (75093852160 168 4096) itemoff 2414 itemsize 51
[171145.415439] extent refs 1 gen 1525280 flags 2
[171145.415440] tree block key (18446744073709551611 48 11418544) level 0
[171145.415440] tree block backref root 257
[171145.415441] item 31 key (75093864448 168 4096) itemoff 2363 itemsize 51
[171145.415441] extent refs 1 gen 1551545 flags 258
[171145.415442] tree block key (3542361 96 2470) level 0
[171145.415442] shared block backref parent 75084333056
[171145.415443] item 32 key (75093872640 168 4096) itemoff 2312 itemsize 51
[171145.415444] extent refs 1 gen 1551545 flags 258
[171145.415444] tree block key (3547240 84 3670382251) level 0
[171145.415445] shared block backref parent 75092348928
[171145.415445] item 33 key (75093876736 168 4096) itemoff 2261 itemsize 51
[171145.415446] extent refs 1 gen 1514341 flags 258
[171145.415446] tree block key (3473903 1 0) level 0
[171145.415447] shared block backref parent 75091329024
[171145.415447] item 34 key (75093880832 168 4096) itemoff 2210 itemsize 51
[171145.415448] extent refs 1 gen 1551545 flags 258
[171145.415449] tree block key (3542361 96 2533) level 0
[171145.415449] shared block backref parent 75084333056
[171145.415450] item 35 key (75093884928 168 4096) itemoff 2159 itemsize 51
[171145.415450] extent refs 1 gen 1551545 flags 258
[171145.415451] tree block key (3542361 96 849) level 0
[171145.415451] shared block backref parent 75084333056
[171145.415452] item 36 key (75093901312 168 4096) itemoff 2108 itemsize 51
[171145.415452] extent refs 1 gen 1514341 flags 258
[171145.415453] tree block key (3473919 12 3427943) level 0
[171145.415453] shared block backref parent 75091329024
[171145.415454] item 37 key (75093905408 168 4096) itemoff 2057 itemsize 51
[171145.415455] extent refs 1 gen 1551545 flags 258
[171145.415455] tree block key (3542361 96 940) level 0
[171145.415456] shared block backref parent 75084333056
[171145.415456] item 38 key (75093909504 168 4096) itemoff 2006 itemsize 51
[171145.415457] extent refs 1 gen 1551545 flags 258
[171145.415457] tree block key (3542361 96 1030) level 0
[171145.415458] shared block backref parent 75084333056
[171145.415459] item 39 key (75093913600 168 4096) itemoff 1955 itemsize 51
[171145.415459] extent refs 1 gen 1120636 flags 258
[171145.415460] tree block key (2449439 1 0) level 0
[171145.415460] shared block backref parent 75073007616
[171145.415461] item 40 key (75093917696 168 4096) itemoff 1904 itemsize 51
[171145.415461] extent refs 1 gen 1514341 flags 258
[171145.415462] tree block key (3432448 12 3427943) level 0
[171145.415462] shared block backref parent 75063275520
[171145.415463] item 41 key (75093921792 168 4096) itemoff 1853 itemsize 51
[171145.415464] extent refs 1 gen 1551545 flags 258
[171145.415464] tree block key (3542361 96 1128) level 0
[171145.415465] shared block backref parent 75084333056
[171145.415466] BTRFS error (device sda5): unable to find ref byte nr
75093794816 parent 0 root 257  owner 0 offset 0
[171145.415467] ------------[ cut here ]------------
[171145.415473] WARNING: CPU: 3 PID: 15124 at
/build/linux-HVWSXI/linux-4.2.0/fs/btrfs/extent-tree.c:6264
__btrfs_free_extent.isra.69+0x92f/0xd70 [btrfs]()
[171145.415474] BTRFS: Transaction aborted (error -2)
[171145.415475] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4
nfs lockd grace fscache xt_multiport iptable_filter ip_tables x_tables
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic intel_rapl snd_hda_intel x86_pkg_temp_thermal
snd_hda_codec eeepc_wmi intel_powerclamp asus_wmi snd_hda_core
sparse_keymap nls_iso8859_1 snd_hwdep coretemp snd_pcm kvm_intel kvm
snd_seq_midi snd_seq_midi_event crct10dif_pclmul snd_rawmidi
crc32_pclmul aesni_intel aes_x86_64 lrw snd_seq gf128mul glue_helper
ablk_helper cryptd snd_seq_device snd_timer input_leds serio_raw snd
lpc_ich mei_me soundcore mei shpchp 8250_fintek mac_hid tpm_infineon
sunrpc cuse parport_pc ppdev lp parport autofs4 btrfs xor hid_generic
usbhid hid raid6_pq mxm_wmi i915 i2c_algo_bit e1000e drm_kms_helper
ahci drm ptp
[171145.415490]  libahci pps_core wmi video
[171145.415492] CPU: 3 PID: 15124 Comm: kworker/u16:0 Tainted: G
 W       4.2.0-35-generic #40-Ubuntu
[171145.415493] Hardware name: ASUS All Series/Z87-PLUS, BIOS 1707 12/13/2013
[171145.415500] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[171145.415501]  0000000000000286 00000000d2e6987f ffff88010d2fba38
ffffffff817f1d7e
[171145.415502]  ffff88010d2fba90 ffffffffc0360388 ffff88010d2fba78
ffffffff8107cb46
[171145.415504]  ffffffffc035e338 000000117bf06000 00000000fffffffe
0000000000000000
[171145.415505] Call Trace:
[171145.415506]  [<ffffffff817f1d7e>] dump_stack+0x63/0x81
[171145.415508]  [<ffffffff8107cb46>] warn_slowpath_common+0x86/0xc0
[171145.415509]  [<ffffffff8107cbd5>] warn_slowpath_fmt+0x55/0x70
[171145.415516]  [<ffffffffc02c0a5f>]
__btrfs_free_extent.isra.69+0x92f/0xd70 [btrfs]
[171145.415522]  [<ffffffffc02c48e6>]
__btrfs_run_delayed_refs+0xa06/0x1160 [btrfs]
[171145.415524]  [<ffffffff810a6a8d>] ? ttwu_do_wakeup+0x1d/0xf0
[171145.415525]  [<ffffffff811e1737>] ? kmem_cache_alloc+0x197/0x210
[171145.415532]  [<ffffffffc02c7d6e>]
btrfs_run_delayed_refs.part.72+0x6e/0x270 [btrfs]
[171145.415539]  [<ffffffffc02c800e>] delayed_ref_async_start+0x7e/0x90 [btrfs]
[171145.415548]  [<ffffffffc030eafa>]
btrfs_scrubparity_helper+0xca/0x2f0 [btrfs]
[171145.415557]  [<ffffffffc030ed5e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[171145.415559]  [<ffffffff81095bc2>] process_one_work+0x162/0x480
[171145.415561]  [<ffffffff81095f2b>] worker_thread+0x4b/0x4c0
[171145.415562]  [<ffffffff81095ee0>] ? process_one_work+0x480/0x480
[171145.415564]  [<ffffffff8109c2b8>] kthread+0xd8/0xf0
[171145.415565]  [<ffffffff8109c1e0>] ? kthread_create_on_node+0x1f0/0x1f0
[171145.415566]  [<ffffffff817f909f>] ret_from_fork+0x3f/0x70
[171145.415567]  [<ffffffff8109c1e0>] ? kthread_create_on_node+0x1f0/0x1f0
[171145.415568] ---[ end trace 42e5b5054b17a8a2 ]---
[171145.415570] BTRFS: error (device sda5) in
__btrfs_free_extent:6264: errno=-2 No such entry
[171145.415571] BTRFS info (device sda5): forced readonly
[171145.415572] BTRFS: error (device sda5) in
btrfs_run_delayed_refs:2788: errno=-2 No such entry
[171145.417770] pending csums is 1732608
[171162.456572] do_trap: 63 callbacks suppressed
[171162.456575] traps: pool[8600] trap int3 ip:7f309931589b
sp:7f30955f8a00 error:0




dmesg | grep -i btrfs
[    2.232863] Btrfs loaded
[    2.285399] BTRFS: device fsid 23fe3bc6-4ec8-48e9-a833-fc83f657f8dc
devid 2 transid 6954176 /dev/sdb5
[    2.285517] BTRFS: device fsid 23fe3bc6-4ec8-48e9-a833-fc83f657f8dc
devid 1 transid 6954176 /dev/sda5
[    2.296021] BTRFS info (device sda5): disk space caching is enabled
[    2.299181] BTRFS: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[    2.299183] BTRFS: bdev /dev/sdb5 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[    2.374511] BTRFS: detected SSD devices, enabling SSD mode
[    2.820257] BTRFS info (device sda5): enabling auto recovery
[    2.820260] BTRFS info (device sda5): disk space caching is enabled


---

I was able to mount RW again using -o recovery.

Based on these messages, I thought it would be usefull to do btrfs
balance but it gave a segmentation fault after some minutes:

[246678.922508] BTRFS: error (device sdb5) in
__btrfs_free_extent:6549: errno=-2 No such entry
[246678.922509] BTRFS info (device sdb5): forced readonly
[246678.922510] BTRFS: error (device sdb5) in
btrfs_run_delayed_refs:2927: errno=-2 No such entry
[246678.922520] BTRFS error (device sdb5): Error removing orphan
entry, stopping orphan cleanup
[246678.922521] BTRFS error (device sdb5): could not do orphan cleanup -22
[246678.937230] BTRFS error (device sdb5): cleaner transaction attach
returned -30
[246695.833019] BTRFS info (device sdb5): enabling auto recovery
[246695.833028] BTRFS info (device sdb5): disk space caching is enabled
[246695.839775] BTRFS info (device sdb5): bdev /dev/sdb5 errs: wr 0,
rd 0, flush 0, corrupt 1, gen 0
[246695.839786] BTRFS info (device sdb5): bdev /dev/sda5 errs: wr 0,
rd 0, flush 0, corrupt 1, gen 0
[246695.926418] BTRFS: detected SSD devices, enabling SSD mode
[246706.522253] BTRFS warning (device sdb5): block group 52634320896
has wrong amount of free space
[246706.522257] BTRFS warning (device sdb5): failed to load free space
cache for block group 52634320896, rebuilding it now
[246706.585890] BTRFS warning (device sdb5): block group 339323387904
has wrong amount of free space
[246706.585892] BTRFS warning (device sdb5): failed to load free space
cache for block group 339323387904, rebuilding it now

Balance:

btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt
Dumping filters: flags 0x7, state 0x0, force is off
  DATA (flags 0x100): converting, target=16, soft is off
  METADATA (flags 0x100): converting, target=16, soft is off
  SYSTEM (flags 0x100): converting, target=16, soft is off


Segmentation fault

Jun  5 15:03:15 ubuntu kernel: [ 2062.544303] BTRFS info (device
sdb5): relocating block group 383447465984 flags 17
Jun  5 15:03:17 ubuntu kernel: [ 2064.483744] BTRFS info (device
sdb5): found 69 extents
Jun  5 15:03:19 ubuntu kernel: [ 2067.085773] BTRFS info (device
sdb5): found 69 extents
Jun  5 15:03:19 ubuntu kernel: [ 2067.131139] BTRFS info (device
sdb5): relocating block group 382373724160 flags 17
Jun  5 15:03:21 ubuntu kernel: [ 2069.100930] BTRFS info (device
sdb5): found 11 extents
Jun  5 15:03:24 ubuntu kernel: [ 2071.741630] BTRFS info (device
sdb5): found 11 extents
Jun  5 15:03:24 ubuntu kernel: [ 2071.788468] BTRFS info (device
sdb5): relocating block group 382340169728 flags 18
Jun  5 15:03:24 ubuntu kernel: [ 2071.834702] BTRFS info (device
sdb5): found 12 extents
Jun  5 15:03:24 ubuntu kernel: [ 2071.876791] BTRFS info (device
sdb5): relocating block group 297447456768 flags 20
Jun  5 15:03:27 ubuntu kernel: [ 2074.572964] ------------[ cut here
]------------
Jun  5 15:03:27 ubuntu kernel: [ 2074.572981] kernel BUG at
/build/linux-Ay7j_C/linux-4.4.0/fs/btrfs/relocation.c:2683!
Jun  5 15:03:27 ubuntu kernel: [ 2074.572999] invalid opcode: 0000 [#1] SMP
Jun  5 15:03:27 ubuntu kernel: [ 2074.573010] Modules linked in:
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp
snd_hda_codec_realtek snd_hda_codec_hdmi kvm snd_hda_codec_generic
snd_hda_intel irqbypass snd_hda_codec crct10dif_pclmul crc32_pclmul
aesni_intel snd_hda_core snd_hwdep snd_pcm eeepc_wmi aes_x86_64
snd_seq_midi snd_seq_midi_event asus_wmi lrw sparse_keymap snd_rawmidi
gf128mul snd_seq glue_helper snd_seq_device ablk_helper snd_timer
input_leds mei_me snd cryptd serio_raw mei lpc_ich soundcore
8250_fintek mac_hid shpchp tpm_infineon parport_pc ppdev lp parport
autofs4 squashfs overlay nls_utf8 isofs hid_generic usbhid hid uas
usb_storage btrfs xor raid6_pq nls_iso8859_1 dm_mirror dm_region_hash
dm_log mxm_wmi i915 i2c_algo_bit drm_kms_helper syscopyarea e1000e
sysfillrect sysimgblt fb_sys_fops ahci drm ptp libahci pps_core fjes
wmi video
Jun  5 15:03:27 ubuntu kernel: [ 2074.573231] CPU: 1 PID: 6532 Comm:
btrfs Tainted: G        W       4.4.0-21-generic #37-Ubuntu
Jun  5 15:03:27 ubuntu kernel: [ 2074.573250] Hardware name: ASUS All
Series/Z87-PLUS, BIOS 1707 12/13/2013
Jun  5 15:03:27 ubuntu kernel: [ 2074.573266] task: ffff8803fcf5e040
ti: ffff8803d9ac0000 task.ti: ffff8803d9ac0000
Jun  5 15:03:27 ubuntu kernel: [ 2074.573282] RIP:
0010:[<ffffffffc0369e85>]  [<ffffffffc0369e85>]
do_relocation+0x515/0x520 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573321] RSP:
0018:ffff8803d9ac3940  EFLAGS: 00010202
Jun  5 15:03:27 ubuntu kernel: [ 2074.573333] RAX: 0000000000000001
RBX: ffff88016f5d8b80 RCX: 0000000000000000
Jun  5 15:03:27 ubuntu kernel: [ 2074.573348] RDX: 0000000000000000
RSI: 0000000000000000 RDI: 0000000000000000
Jun  5 15:03:27 ubuntu kernel: [ 2074.573364] RBP: ffff8803d9ac39f8
R08: ffff8803d9ac38f4 R09: 0000160000000000
Jun  5 15:03:27 ubuntu kernel: [ 2074.573379] R10: 0000000000000002
R11: 0000000000000045 R12: ffff8803848b2780
Jun  5 15:03:27 ubuntu kernel: [ 2074.573394] R13: ffff88041d188800
R14: ffff880414bbc580 R15: 0000000000000001
Jun  5 15:03:27 ubuntu kernel: [ 2074.573410] FS:
00007fc33a9eb8c0(0000) GS:ffff88042fa40000(0000)
knlGS:0000000000000000
Jun  5 15:03:27 ubuntu kernel: [ 2074.573427] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jun  5 15:03:27 ubuntu kernel: [ 2074.573439] CR2: 00007f8bd8029000
CR3: 00000003cfddd000 CR4: 00000000001406e0
Jun  5 15:03:27 ubuntu kernel: [ 2074.573455] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jun  5 15:03:27 ubuntu kernel: [ 2074.573470] DR3: 0000000000000000
DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun  5 15:03:27 ubuntu kernel: [ 2074.573485] Stack:
Jun  5 15:03:27 ubuntu kernel: [ 2074.573490]  0000000000000000
ffff8803fcc8b920 ffff8803c707cf30 ffff8803848b27c0
Jun  5 15:03:27 ubuntu kernel: [ 2074.573509]  ffff8803fcc8b800
ffff880414bbcaa0 0000000100000000 ffff8800c81db640
Jun  5 15:03:27 ubuntu kernel: [ 2074.573528]  ffff8803d9ac3980
ffff8803d9ac3980 ffff8800c71d3300 ffff880414bbc580
Jun  5 15:03:27 ubuntu kernel: [ 2074.573547] Call Trace:
Jun  5 15:03:27 ubuntu kernel: [ 2074.573561]  [<ffffffffc0306a67>] ?
btrfs_block_rsv_refill+0x37/0xb0 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573585]  [<ffffffffc036c50e>]
relocate_tree_blocks+0x4ee/0x5f0 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573607]  [<ffffffffc0366c1d>] ?
tree_insert+0x4d/0x60 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573627]  [<ffffffffc036a415>] ?
add_tree_block+0x155/0x1e0 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573648]  [<ffffffffc036da7a>]
relocate_block_group+0x41a/0x6c0 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573671]  [<ffffffffc0335860>] ?
btrfs_wait_ordered_roots+0x1d0/0x200 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573693]  [<ffffffffc036ded3>]
btrfs_relocate_block_group+0x1b3/0x290 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573717]  [<ffffffffc0343567>]
btrfs_relocate_chunk.isra.38+0x47/0xd0 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573741]  [<ffffffffc03449c9>]
__btrfs_balance+0x5b9/0xba0 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573762]  [<ffffffffc0345240>]
btrfs_balance+0x290/0x5f0 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573783]  [<ffffffffc0351957>]
btrfs_ioctl_balance+0x377/0x390 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573805]  [<ffffffffc03530d0>]
btrfs_ioctl+0x550/0x28b0 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.573820]  [<ffffffff8120018b>] ?
mem_cgroup_try_charge+0x6b/0x1b0
Jun  5 15:03:27 ubuntu kernel: [ 2074.573836]  [<ffffffff8119dfd7>] ?
lru_cache_add_active_or_unevictable+0x27/0xa0
Jun  5 15:03:27 ubuntu kernel: [ 2074.573853]  [<ffffffff811bf87a>] ?
handle_mm_fault+0xcaa/0x1820
Jun  5 15:03:27 ubuntu kernel: [ 2074.573867]  [<ffffffff812200ff>]
do_vfs_ioctl+0x29f/0x490
Jun  5 15:03:27 ubuntu kernel: [ 2074.573881]  [<ffffffff8106b554>] ?
__do_page_fault+0x1b4/0x400
Jun  5 15:03:27 ubuntu kernel: [ 2074.573894]  [<ffffffff81220369>]
SyS_ioctl+0x79/0x90
Jun  5 15:03:27 ubuntu kernel: [ 2074.573907]  [<ffffffff818244f2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun  5 15:03:27 ubuntu kernel: [ 2074.573921] Code: fd ff ff 0f 0b 0f
b6 43 70 48 8b b5 58 ff ff ff 48 8d 04 c6 48 8b 10 48 89 53 68 48 c7
00 00 00 00 00 0f b6 53 70 e9 db fe ff ff <0f> 0b 0f 0b e8 b2 6e d1 c0
66 90 0f 1f 44 00 00 55 ba b8 05 00
Jun  5 15:03:27 ubuntu kernel: [ 2074.574009] RIP
[<ffffffffc0369e85>] do_relocation+0x515/0x520 [btrfs]
Jun  5 15:03:27 ubuntu kernel: [ 2074.574032]  RSP <ffff8803d9ac3940>
Jun  5 15:03:27 ubuntu kernel: [ 2074.577177] ---[ end trace
e2081181f6c60d52 ]---



>From this moment on, the filesystem is useless. Every reboot (with
live USB) the crashed balance operation restarts, and gives a
segmentation fault after a while. Booting from the disk is not
possible anymore.

What can I do to repair this problem?

Thank you.
Kind regards.



-- 

Paul Verreth

Het verschil tussen theorie en praktijk
is klein in theorie,
maar in praktijk daarentegen ...
