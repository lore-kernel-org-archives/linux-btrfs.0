Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:32934 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755991AbdGKS5M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 14:57:12 -0400
Received: by mail-pg0-f43.google.com with SMTP id k14so544425pgr.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Jul 2017 11:57:11 -0700 (PDT)
MIME-Version: 1.0
From: Clemens Eisserer <linuxhippy@gmail.com>
Date: Tue, 11 Jul 2017 20:57:09 +0200
Message-ID: <CAFvQSYTj1V5ACny++vHiQR=xcTa9H9F28YRJ1YFbZE1Ls8FSTg@mail.gmail.com>
Subject: "Unable to find ref byte nr ...." (4.11 somehow fishy?)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

My external drive (single metadata, inline) caused an Ooops recently
and went read-only.
I wonder, has this something to do with the btrfs issues some have with 4.11?

Best regards, Clemens

[  619.850316] perf: interrupt took too long (3958 > 3941), lowering
kernel.perf_event_max_sample_rate to 50000
[  625.656835] ------------[ cut here ]------------
[  625.656880] WARNING: CPU: 0 PID: 2919 at
fs/btrfs/extent-tree.c:6936 __btrfs_free_extent.isra.61+0x7bf/0xe40
[btrfs]
[  625.656883] Modules linked in: uas usb_storage rfcomm ccm bnep
sunrpc uvcvideo videobuf2_vmalloc videobuf2_memops btusb btrtl
videobuf2_v4l2 btbcm btintel videobuf2_core bluetooth videodev media
mei_wdt iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp hp_wmi
kvm_intel sparse_keymap ppdev snd_hda_codec_hdmi kvm arc4
snd_hda_codec_idt snd_hda_codec_generic iwldvm snd_hda_intel mac80211
snd_hda_codec irqbypass intel_cstate snd_hda_core intel_uncore iwlwifi
snd_hwdep snd_seq snd_seq_device joydev intel_ips snd_pcm cfg80211
acpi_cpufreq tpm_infineon snd_timer snd rfkill lpc_ich soundcore
shpchp mei_me mei wmi parport_pc parport hp_accel lis3lv02d
input_polldev tpm_tis tpm_tis_core tpm binfmt_misc vboxpci(OE)
vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) btrfs xor raid6_pq dm_crypt
i915 mmc_block bcache
[  625.656931]  crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel i2c_algo_bit drm_kms_helper serio_raw sdhci_pci
drm e1000e sdhci mmc_core ptp pps_core video
[  625.656943] CPU: 0 PID: 2919 Comm: btrfs-cleaner Tainted: G
  OE   4.11.8-200.fc25.x86_64 #1
[  625.656944] Hardware name: Hewlett-Packard HP EliteBook 2540p/7008,
BIOS 68CSU Ver. F.60 11/11/2015
[  625.656945] Call Trace:
[  625.656952]  dump_stack+0x63/0x86
[  625.656955]  __warn+0xcb/0xf0
[  625.656956]  warn_slowpath_null+0x1d/0x20
[  625.656968]  __btrfs_free_extent.isra.61+0x7bf/0xe40 [btrfs]
[  625.656977]  ? btrfs_search_slot+0x429/0x9d0 [btrfs]
[  625.656992]  ? btrfs_merge_delayed_refs+0x61/0x6c0 [btrfs]
[  625.657002]  __btrfs_run_delayed_refs+0x501/0x12b0 [btrfs]
[  625.657017]  ? btrfs_get_token_64+0x105/0x120 [btrfs]
[  625.657028]  btrfs_run_delayed_refs+0x8f/0x2a0 [btrfs]
[  625.657042]  ? free_extent_buffer+0x4b/0xa0 [btrfs]
[  625.657055]  btrfs_should_end_transaction+0x48/0x60 [btrfs]
[  625.657066]  btrfs_drop_snapshot+0x3e0/0x920 [btrfs]
[  625.657079]  btrfs_clean_one_deleted_snapshot+0xbc/0x100 [btrfs]
[  625.657091]  cleaner_kthread+0x133/0x180 [btrfs]
[  625.657093]  kthread+0x109/0x140
[  625.657105]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  625.657106]  ? kthread_park+0x90/0x90
[  625.657110]  ret_from_fork+0x2c/0x40
[  625.657164] ---[ end trace 1c4d5dd9396052ae ]---
[  625.657168] BTRFS info (device dm-1): leaf 183797051392 total ptrs
64 free space 186
[  625.657172] item 0 key (178663501824 169 0) itemoff 3926 itemsize 69
[  625.657173] extent refs 5 gen 1026 flags 258
[  625.657174] shared block backref parent 245739773952
[  625.657174] shared block backref parent 245673074688
[  625.657174] shared block backref parent 181409894400
[  625.657175] shared block backref parent 181343162368
[  625.657175] shared block backref parent 180773711872
[  625.657176] item 1 key (178663505920 168 4096) itemoff 3889 itemsize 37
[  625.657177] extent refs 1 gen 1045 flags 1
[  625.657177] shared data backref parent 179187650560 count 1
[  625.657178] item 2 key (178663510016 168 4096) itemoff 3852 itemsize 37
[  625.657179] extent refs 1 gen 1180 flags 1
[  625.657180] shared data backref parent 245746434048 count 1
[  625.657180] item 3 key (178663514112 169 0) itemoff 3819 itemsize 33
[  625.657181] extent refs 1 gen 1098 flags 2
[  625.657182] tree block backref root 2
[  625.657183] item 4 key (178663518208 168 4096) itemoff 3769 itemsize 50
[  625.657183] extent refs 2 gen 1030 flags 1
[  625.657184] shared data backref parent 178675068928 count 1
[  625.657184] shared data backref parent 178137387008 count 1
[  625.657185] item 5 key (178663522304 168 4096) itemoff 3732 itemsize 37
[  625.657186] extent refs 1 gen 1053 flags 1
[  625.657186] shared data backref parent 180441329664 count 1
[  625.657187] item 6 key (178663526400 169 0) itemoff 3555 itemsize 177
[  625.657188] extent refs 17 gen 1196 flags 258
[  625.657188] shared block backref parent 415361105920
[  625.657189] shared block backref parent 415227764736
[  625.657189] shared block backref parent 415125512192
[  625.657190] shared block backref parent 414450216960
[  625.657190] shared block backref parent 414116110336
[  625.657190] shared block backref parent 414103474176
[  625.657191] shared block backref parent 412705067008
[  625.657191] shared block backref parent 412643041280
[  625.657192] shared block backref parent 390315855872
[  625.657192] shared block backref parent 287440842752
[  625.657192] shared block backref parent 287294996480
[  625.657193] shared block backref parent 266445434880
[  625.657193] shared block backref parent 256855588864
[  625.657194] shared block backref parent 256145903616
[  625.657194] shared block backref parent 253848592384
[  625.657194] shared block backref parent 248051871744
[  625.657195] shared block backref parent 245527207936
[  625.657196] item 7 key (178663530496 169 2) itemoff 3351 itemsize 204
[  625.657196] extent refs 35 gen 1026 flags 258
[  625.657197] tree block backref root 736
[  625.657197] tree block backref root 730
[  625.657198] tree block backref root 726
[  625.657198] tree block backref root 721
[  625.657198] tree block backref root 717
[  625.657199] tree block backref root 603
[  625.657199] tree block backref root 599
[  625.657200] tree block backref root 591
[  625.657200] tree block backref root 585
[  625.657201] tree block backref root 579
[  625.657201] tree block backref root 570
[  625.657201] tree block backref root 556
[  625.657202] tree block backref root 543
[  625.657202] tree block backref root 539
[  625.657203] tree block backref root 532
[  625.657203] tree block backref root 523
[  625.657203] tree block backref root 517
[  625.657204] tree block backref root 513
[  625.657204] tree block backref root 453
[  625.657205] tree block backref root 444
[  625.657206] item 8 key (178663530496 176 740) itemoff 3351 itemsize 0
[  625.657206] tree block backref
[  625.657207] item 9 key (178663530496 176 745) itemoff 3351 itemsize 0
[  625.657207] tree block backref
[  625.657208] item 10 key (178663530496 176 750) itemoff 3351 itemsize 0
[  625.657209] tree block backref
[  625.657209] item 11 key (178663530496 176 754) itemoff 3351 itemsize 0
[  625.657210] tree block backref
[  625.657211] item 12 key (178663530496 176 758) itemoff 3351 itemsize 0
[  625.657211] tree block backref
[  625.657212] item 13 key (178663530496 176 762) itemoff 3351 itemsize 0
[  625.657212] tree block backref
[  625.657213] item 14 key (178663530496 176 766) itemoff 3351 itemsize 0
[  625.657213] tree block backref
[  625.657214] item 15 key (178663530496 176 770) itemoff 3351 itemsize 0
[  625.657214] tree block backref
[  625.657215] item 16 key (178663530496 176 774) itemoff 3351 itemsize 0
[  625.657215] tree block backref
[  625.657216] item 17 key (178663530496 176 778) itemoff 3351 itemsize 0
[  625.657217] tree block backref
[  625.657217] item 18 key (178663530496 176 782) itemoff 3351 itemsize 0
[  625.657218] tree block backref
[  625.657219] item 19 key (178663530496 176 786) itemoff 3351 itemsize 0
[  625.657219] tree block backref
[  625.657220] item 20 key (178663530496 176 790) itemoff 3351 itemsize 0
[  625.657220] tree block backref
[  625.657221] item 21 key (178663530496 176 794) itemoff 3351 itemsize 0
[  625.657221] tree block backref
[  625.657222] item 22 key (178663530496 176 799) itemoff 3351 itemsize 0
[  625.657222] tree block backref
[  625.657223] item 23 key (178663534592 168 4096) itemoff 3314 itemsize 37
[  625.657224] extent refs 1 gen 1200 flags 1
[  625.657224] shared data backref parent 245976125440 count 1
[  625.657225] item 24 key (178663538688 168 4096) itemoff 3264 itemsize 50
[  625.657226] extent refs 2 gen 1030 flags 1
[  625.657227] shared data backref parent 178675068928 count 1
[  625.657227] shared data backref parent 178137387008 count 1
[  625.657228] item 25 key (178663542784 168 4096) itemoff 3227 itemsize 37
[  625.657229] extent refs 1 gen 1082 flags 1
[  625.657229] shared data backref parent 180794540032 count 1
[  625.657230] item 26 key (178663546880 168 4096) itemoff 3190 itemsize 37
[  625.657231] extent refs 1 gen 1026 flags 1
[  625.657231] shared data backref parent 178663501824 count 1
[  625.657232] item 27 key (178663550976 168 4096) itemoff 3140 itemsize 50
[  625.657233] extent refs 2 gen 1030 flags 1
[  625.657233] shared data backref parent 178675068928 count 1
[  625.657234] shared data backref parent 178137387008 count 1
[  625.657235] item 28 key (178663555072 168 4096) itemoff 3103 itemsize 37
[  625.657236] extent refs 1 gen 1045 flags 1
[  625.657236] shared data backref parent 179187650560 count 1
[  625.657237] item 29 key (178663559168 168 4096) itemoff 3014 itemsize 89
[  625.657238] extent refs 5 gen 1026 flags 1
[  625.657238] shared data backref parent 286873866240 count 1
[  625.657239] shared data backref parent 286709125120 count 1
[  625.657239] shared data backref parent 277393047552 count 1
[  625.657240] shared data backref parent 252206927872 count 1
[  625.657240] shared data backref parent 178663501824 count 1
[  625.657241] item 30 key (178663563264 168 12288) itemoff 2977 itemsize 37
[  625.657242] extent refs 1 gen 1045 flags 1
[  625.657243] shared data backref parent 178586718208 count 1
[  625.657243] item 31 key (178663575552 168 4096) itemoff 2940 itemsize 37
[  625.657244] extent refs 1 gen 1051 flags 1
[  625.657245] shared data backref parent 179476021248 count 1
[  625.657246] item 32 key (178663579648 168 4096) itemoff 2903 itemsize 37
[  625.657246] extent refs 1 gen 1051 flags 1
[  625.657247] shared data backref parent 179476004864 count 1
[  625.657248] item 33 key (178663583744 168 4096) itemoff 2762 itemsize 141
[  625.657248] extent refs 9 gen 1026 flags 1
[  625.657249] shared data backref parent 257500905472 count 1
[  625.657249] shared data backref parent 252206936064 count 1
[  625.657250] shared data backref parent 252042674176 count 1
[  625.657251] shared data backref parent 251875823616 count 1
[  625.657251] shared data backref parent 245744291840 count 1
[  625.657252] shared data backref parent 245673230336 count 1
[  625.657252] shared data backref parent 181503750144 count 1
[  625.657253] shared data backref parent 181342941184 count 1
[  625.657253] shared data backref parent 178663804928 count 1
[  625.657254] item 34 key (178663587840 168 4096) itemoff 2712 itemsize 50
[  625.657255] extent refs 2 gen 1030 flags 1
[  625.657255] shared data backref parent 178675068928 count 1
[  625.657256] shared data backref parent 178137387008 count 1
[  625.657257] item 35 key (178663591936 168 4096) itemoff 2675 itemsize 37
[  625.657257] extent refs 1 gen 1045 flags 1
[  625.657258] shared data backref parent 179187650560 count 1
[  625.657259] item 36 key (178663596032 168 4096) itemoff 2638 itemsize 37
[  625.657259] extent refs 1 gen 1080 flags 1
[  625.657260] shared data backref parent 180566806528 count 1
[  625.657261] item 37 key (178663600128 168 4096) itemoff 2588 itemsize 50
[  625.657262] extent refs 2 gen 1030 flags 1
[  625.657262] shared data backref parent 178675068928 count 1
[  625.657263] shared data backref parent 178137387008 count 1
[  625.657264] item 38 key (178663604224 168 4096) itemoff 2538 itemsize 50
[  625.657264] extent refs 2 gen 1030 flags 1
[  625.657265] shared data backref parent 178675068928 count 1
[  625.657265] shared data backref parent 178137387008 count 1
[  625.657266] item 39 key (178663608320 168 4096) itemoff 2501 itemsize 37
[  625.657267] extent refs 1 gen 1045 flags 1
[  625.657267] shared data backref parent 179187650560 count 1
[  625.657268] item 40 key (178663612416 168 4096) itemoff 2464 itemsize 37
[  625.657269] extent refs 1 gen 1040 flags 1
[  625.657270] shared data backref parent 179144916992 count 1
[  625.657270] item 41 key (178663616512 168 4096) itemoff 2427 itemsize 37
[  625.657271] extent refs 1 gen 1044 flags 1
[  625.657272] shared data backref parent 178580058112 count 1
[  625.657273] item 42 key (178663620608 168 4096) itemoff 2234 itemsize 193
[  625.657273] extent refs 27 gen 1090 flags 1
[  625.657274] shared data backref parent 286832046080 count 1
[  625.657274] shared data backref parent 286715400192 count 1
[  625.657275] shared data backref parent 286690906112 count 1
[  625.657275] shared data backref parent 286672891904 count 1
[  625.657276] shared data backref parent 257517543424 count 1
[  625.657276] shared data backref parent 253976293376 count 1
[  625.657277] shared data backref parent 252231581696 count 1
[  625.657277] shared data backref parent 252047101952 count 1
[  625.657278] shared data backref parent 248005345280 count 1
[  625.657278] shared data backref parent 246456664064 count 1
[  625.657279] shared data backref parent 184333676544 count 1
[  625.657280] shared data backref parent 184229064704 count 1
[  625.657280] shared data backref parent 181164576768 count 1
[  625.657281] item 43 key (178663620608 178 3665759692300308034)
itemoff 2206 itemsize 28
[  625.657283] extent data backref root 797 objectid 564789 offset 53248 count 1
[  625.657284] item 44 key (178663620608 184 291363012608) itemoff
2202 itemsize 4
[  625.657284] shared data backref count 1
[  625.657285] item 45 key (178663620608 184 410261458944) itemoff
2198 itemsize 4
[  625.657286] shared data backref count 1
[  625.657286] item 46 key (178663620608 184 410405048320) itemoff
2194 itemsize 4
[  625.657287] shared data backref count 1
[  625.657288] item 47 key (178663620608 184 414798696448) itemoff
2190 itemsize 4
[  625.657288] shared data backref count 1
[  625.657289] item 48 key (178663620608 184 414805569536) itemoff
2186 itemsize 4
[  625.657289] shared data backref count 1
[  625.657290] item 49 key (178663620608 184 414906974208) itemoff
2182 itemsize 4
[  625.657291] shared data backref count 1
[  625.657292] item 50 key (178663620608 184 415082700800) itemoff
2178 itemsize 4
[  625.657292] shared data backref count 1
[  625.657293] item 51 key (178663620608 184 415170252800) itemoff
2174 itemsize 4
[  625.657293] shared data backref count 1
[  625.657294] item 52 key (178663620608 184 415185018880) itemoff
2170 itemsize 4
[  625.657295] shared data backref count 1
[  625.657295] item 53 key (178663620608 184 415186878464) itemoff
2166 itemsize 4
[  625.657296] shared data backref count 1
[  625.657297] item 54 key (178663620608 184 415188045824) itemoff
2162 itemsize 4
[  625.657297] shared data backref count 1
[  625.657298] item 55 key (178663620608 184 415272210432) itemoff
2158 itemsize 4
[  625.657298] shared data backref count 1
[  625.657299] item 56 key (178663620608 184 415298473984) itemoff
2154 itemsize 4
[  625.657300] shared data backref count 1
[  625.657301] item 57 key (178663624704 169 0) itemoff 2121 itemsize 33
[  625.657301] extent refs 1 gen 1048 flags 258
[  625.657302] shared block backref parent 180902735872
[  625.657303] item 58 key (178663628800 168 4096) itemoff 2045 itemsize 76
[  625.657303] extent refs 4 gen 1026 flags 1
[  625.657304] shared data backref parent 252206940160 count 1
[  625.657304] shared data backref parent 252042711040 count 1
[  625.657305] shared data backref parent 184797204480 count 1
[  625.657305] shared data backref parent 180623306752 count 1
[  625.657306] item 59 key (178663632896 168 4096) itemoff 2008 itemsize 37
[  625.657307] extent refs 1 gen 1045 flags 1
[  625.657308] shared data backref parent 179187650560 count 1
[  625.657308] item 60 key (178663636992 168 4096) itemoff 1932 itemsize 76
[  625.657309] extent refs 4 gen 1026 flags 1
[  625.657310] shared data backref parent 252206940160 count 1
[  625.657310] shared data backref parent 252042711040 count 1
[  625.657311] shared data backref parent 184797204480 count 1
[  625.657311] shared data backref parent 180623306752 count 1
[  625.657312] item 61 key (178663641088 169 0) itemoff 1899 itemsize 33
[  625.657313] extent refs 1 gen 1078 flags 2
[  625.657313] tree block backref root 7
[  625.657314] item 62 key (178663645184 168 4096) itemoff 1862 itemsize 37
[  625.657315] extent refs 1 gen 1045 flags 1
[  625.657315] shared data backref parent 179187650560 count 1
[  625.657316] item 63 key (178663649280 168 4096) itemoff 1786 itemsize 76
[  625.657317] extent refs 4 gen 1026 flags 1
[  625.657317] shared data backref parent 252206940160 count 1
[  625.657318] shared data backref parent 252042711040 count 1
[  625.657318] shared data backref parent 184797204480 count 1
[  625.657319] shared data backref parent 180623306752 count 1
[  625.657321] BTRFS error (device dm-1): unable to find ref byte nr
178663530496 parent 0 root 797  owner 2 offset 0
[  625.657325] ------------[ cut here ]------------
[  625.657338] WARNING: CPU: 0 PID: 2919 at
fs/btrfs/extent-tree.c:6942 __btrfs_free_extent.isra.61+0x821/0xe40
[btrfs]
[  625.657340] BTRFS: Transaction aborted (error -2)
[  625.657340] Modules linked in: uas usb_storage rfcomm ccm bnep
sunrpc uvcvideo videobuf2_vmalloc videobuf2_memops btusb btrtl
videobuf2_v4l2 btbcm btintel videobuf2_core bluetooth videodev media
mei_wdt iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp hp_wmi
kvm_intel sparse_keymap ppdev snd_hda_codec_hdmi kvm arc4
snd_hda_codec_idt snd_hda_codec_generic iwldvm snd_hda_intel mac80211
snd_hda_codec irqbypass intel_cstate snd_hda_core intel_uncore iwlwifi
snd_hwdep snd_seq snd_seq_device joydev intel_ips snd_pcm cfg80211
acpi_cpufreq tpm_infineon snd_timer snd rfkill lpc_ich soundcore
shpchp mei_me mei wmi parport_pc parport hp_accel lis3lv02d
input_polldev tpm_tis tpm_tis_core tpm binfmt_misc vboxpci(OE)
vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) btrfs xor raid6_pq dm_crypt
i915 mmc_block bcache
[  625.657365]  crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel i2c_algo_bit drm_kms_helper serio_raw sdhci_pci
drm e1000e sdhci mmc_core ptp pps_core video
[  625.657371] CPU: 0 PID: 2919 Comm: btrfs-cleaner Tainted: G
W  OE   4.11.8-200.fc25.x86_64 #1
[  625.657372] Hardware name: Hewlett-Packard HP EliteBook 2540p/7008,
BIOS 68CSU Ver. F.60 11/11/2015
[  625.657372] Call Trace:
[  625.657374]  dump_stack+0x63/0x86
[  625.657376]  __warn+0xcb/0xf0
[  625.657377]  warn_slowpath_fmt+0x5a/0x80
[  625.657390]  __btrfs_free_extent.isra.61+0x821/0xe40 [btrfs]
[  625.657401]  ? btrfs_search_slot+0x429/0x9d0 [btrfs]
[  625.657416]  ? btrfs_merge_delayed_refs+0x61/0x6c0 [btrfs]
[  625.657428]  __btrfs_run_delayed_refs+0x501/0x12b0 [btrfs]
[  625.657443]  ? btrfs_get_token_64+0x105/0x120 [btrfs]
[  625.657456]  btrfs_run_delayed_refs+0x8f/0x2a0 [btrfs]
[  625.657473]  ? free_extent_buffer+0x4b/0xa0 [btrfs]
[  625.657486]  btrfs_should_end_transaction+0x48/0x60 [btrfs]
[  625.657498]  btrfs_drop_snapshot+0x3e0/0x920 [btrfs]
[  625.657512]  btrfs_clean_one_deleted_snapshot+0xbc/0x100 [btrfs]
[  625.657527]  cleaner_kthread+0x133/0x180 [btrfs]
[  625.657529]  kthread+0x109/0x140
[  625.657542]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  625.657543]  ? kthread_park+0x90/0x90
[  625.657545]  ret_from_fork+0x2c/0x40
[  625.657546] ---[ end trace 1c4d5dd9396052af ]---
[  625.657548] BTRFS: error (device dm-1) in __btrfs_free_extent:6942:
errno=-2 No such entry
[  625.657550] BTRFS info (device dm-1): forced readonly
[  625.657553] BTRFS: error (device dm-1) in
btrfs_run_delayed_refs:2961: errno=-2 No such entry
