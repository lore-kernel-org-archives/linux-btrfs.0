Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54365 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752983AbcL2TFk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 14:05:40 -0500
Received: from dibsi.localnet ([79.238.192.218]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Mb45P-1c7TUB2Xmt-00KirR for
 <linux-btrfs@vger.kernel.org>; Thu, 29 Dec 2016 20:05:36 +0100
From: Jan Koester <jan.koester@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: mounting failed any file on my filesystem
Date: Thu, 29 Dec 2016 20:05:35 +0100
Message-ID: <1707774.BW2KGqTm4d@dibsi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i have problem with filesystem if my system crashed i have made been hard reset 
of the system after my Filesystem was crashed. I have already tried to repair 
without success you can see it on log file. It's seem one corrupted block 
brings complete filesystem to crashing.

Have anybody idea what happened with my filesystem ?

dmesg if open file:
[29450.404327] WARNING: CPU: 5 PID: 16161 at /build/linux-lIgGMF/linux-4.8.11/
fs/btrfs/extent-tree.c:6945 __btrfs_free_extent.isra.71+0x8e2/0xd60 [btrfs]
[29450.404331] Modules linked in: snd_usb_audio snd_usbmidi_lib snd_rawmidi 
snd_seq_device nfnetlink_queue nfnetlink_log nfnetlink cfg80211 bnep 
ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter pci_stub 
vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) bluetooth rfkill 
binfmt_misc ext4 crc16 jbd2 fscrypto ecb mbcache btrfs xor raid6_pq kvm_amd 
kvm amdkfd irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel radeon 
snd_hda_codec_realtek snd_hda_codec_generic sr_mod cdrom pcspkr serio_raw 
snd_hda_codec_hdmi fam15h_power k10temp evdev snd_hda_intel ttm snd_hda_codec 
drm_kms_helper snd_hda_core snd_hwdep snd_pcm drm snd_timer snd soundcore 
i2c_algo_bit sg sp5100_tco nuvoton_cir shpchp rc_core acpi_cpufreq tpm_tis 
tpm_tis_core tpm button cuse fuse parport_pc ppdev lp parport ip_tables
[29450.404512]  x_tables autofs4 xfs libcrc32c crc32c_generic ata_generic 
hid_generic usbhid hid sd_mod uas usb_storage ohci_pci crc32c_intel 
aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd psmouse 
e1000e xhci_pci r8169 xhci_hcd ptp ahci mii pps_core pata_atiixp libahci 
ohci_hcd libata ehci_pci ehci_hcd usbcore scsi_mod i2c_piix4 usb_common fjes
[29450.404543] CPU: 5 PID: 16161 Comm: kworker/u12:3 Tainted: G        W  OE   
4.8.0-2-amd64 #1 Debian 4.8.11-1
[29450.404544] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./
970 Extreme3, BIOS P1.80 07/31/2013
[29450.404579] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[29450.404581]  0000000000000286 000000000bc03c37 ffffffff93d269f5 
0000000000000000
[29450.404586]  0000000000000000 ffffffff93a7c16e 00000000fffffffe 
000000dd8f8a8000
[29450.404590]  0000000000000000 ffff91c65d625000 ffff91c4eac5c000 
ffff91c4e7c09690
[29450.404594] Call Trace:
[29450.404599]  [<ffffffff93d269f5>] ? dump_stack+0x5c/0x77
[29450.404603]  [<ffffffff93a7c16e>] ? __warn+0xbe/0xe0
[29450.404630]  [<ffffffffc0c262a2>] ? __btrfs_free_extent.isra.71+0x8e2/0xd60 
[btrfs]
[29450.404660]  [<ffffffffc0c20801>] ? block_group_cache_tree_search+0x21/0xd0 
[btrfs]
[29450.404690]  [<ffffffffc0c256d3>] ? update_block_group.isra.70+0x133/0x420 
[btrfs]
[29450.404699]  [<ffffffff93b8a9ff>] ? __set_page_dirty_nobuffers+0xef/0x140
[29450.404736]  [<ffffffffc0c95ab9>] ? btrfs_merge_delayed_refs+0x69/0x580 
[btrfs]
[29450.404767]  [<ffffffffc0c2a8ac>] ? __btrfs_run_delayed_refs+0xadc/0x1240 
[btrfs]
[29450.404801]  [<ffffffffc0c2deee>] ? btrfs_run_delayed_refs+0x8e/0x2a0 
[btrfs]
[29450.404834]  [<ffffffffc0c2e189>] ? delayed_ref_async_start+0x89/0xa0 
[btrfs]
[29450.404871]  [<ffffffffc0c788b1>] ? btrfs_scrubparity_helper+0xd1/0x2d0 
[btrfs]
[29450.404879]  [<ffffffff93a94e00>] ? process_one_work+0x160/0x410
[29450.404886]  [<ffffffff93a950fd>] ? worker_thread+0x4d/0x480
[29450.404892]  [<ffffffff93a950b0>] ? process_one_work+0x410/0x410
[29450.404899]  [<ffffffff93a9aecd>] ? kthread+0xcd/0xf0
[29450.404906]  [<ffffffff93fefcaf>] ? ret_from_fork+0x1f/0x40
[29450.404913]  [<ffffffff93a9ae00>] ? kthread_create_on_node+0x190/0x190
[29450.404919] ---[ end trace 9627fcfceb44da0b ]---
[29450.404926] BTRFS info (device sdd): leaf 950359678976 total ptrs 67 free 
space 442
[29450.404934]  item 0 key (503649468416 192 1107296256) itemoff 3971 itemsize 
24
[29450.404940]          block group used 36864
[29450.404947]  item 1 key (503649538048 169 0) itemoff 3938 itemsize 33
[29450.404952]          extent refs 1 gen 861177 flags 2
[29450.404959]          tree block backref root 2
[29450.404965]  item 2 key (503649550336 169 1) itemoff 3905 itemsize 33
[29450.404971]          extent refs 1 gen 861177 flags 2
[29450.404977]          tree block backref root 2
[29450.404984]  item 3 key (503649566720 169 0) itemoff 3872 itemsize 33
[29450.404991]          extent refs 1 gen 861177 flags 2
[29450.404996]          tree block backref root 2
[29450.405001]  item 4 key (503649570816 169 0) itemoff 3839 itemsize 33
[29450.405007]          extent refs 1 gen 861177 flags 2
[29450.405012]          tree block backref root 2
[29450.405019]  item 5 key (503649607680 169 0) itemoff 3806 itemsize 33
[29450.405025]          extent refs 1 gen 861177 flags 2
[29450.405028]          tree block backref root 2
[29450.405030]  item 6 key (503649628160 169 0) itemoff 3773 itemsize 33
[29450.405031]          extent refs 1 gen 861177 flags 2
[29450.405032]          tree block backref root 2
[29450.405034]  item 7 key (503649636352 169 0) itemoff 3740 itemsize 33
[29450.405036]          extent refs 1 gen 861177 flags 2
[29450.405037]          tree block backref root 2
[29450.405039]  item 8 key (503649669120 169 1) itemoff 3707 itemsize 33
[29450.405040]          extent refs 1 gen 861177 flags 2
[29450.405041]          tree block backref root 1
[29450.405043]  item 9 key (503649705984 169 0) itemoff 3674 itemsize 33
[29450.405045]          extent refs 1 gen 861177 flags 2
[29450.405046]          tree block backref root 1
[29450.405048]  item 10 key (950359621632 169 4) itemoff 3641 itemsize 33
[29450.405049]          extent refs 1 gen 861178 flags 2
[29450.405050]          tree block backref root 5
[29450.405053]  item 11 key (950359621632 192 1107296256) itemoff 3617 
itemsize 24
[29450.405054]          block group used 0
[29450.405056]  item 12 key (950359625728 169 3) itemoff 3584 itemsize 33
[29450.405057]          extent refs 1 gen 861178 flags 2
[29450.405058]          tree block backref root 5
[29450.405060]  item 13 key (950359629824 169 2) itemoff 3551 itemsize 33
[29450.405062]          extent refs 1 gen 861178 flags 2
[29450.405063]          tree block backref root 5
[29450.405065]  item 14 key (950359633920 169 1) itemoff 3518 itemsize 33
[29450.405067]          extent refs 1 gen 861178 flags 2
[29450.405067]          tree block backref root 5
[29450.405070]  item 15 key (950359638016 169 0) itemoff 3485 itemsize 33
[29450.405071]          extent refs 1 gen 861178 flags 2
[29450.405072]          tree block backref root 5
[29450.405074]  item 16 key (950359642112 169 1) itemoff 3452 itemsize 33
[29450.405076]          extent refs 1 gen 861178 flags 2
[29450.405077]          tree block backref root 5
[29450.405079]  item 17 key (950359646208 169 0) itemoff 3419 itemsize 33
[29450.405080]          extent refs 1 gen 861178 flags 2
[29450.405081]          tree block backref root 5
[29450.405083]  item 18 key (950359650304 169 3) itemoff 3386 itemsize 33
[29450.405085]          extent refs 1 gen 861178 flags 2
[29450.405086]          tree block backref root 5
[29450.405088]  item 19 key (950359654400 169 2) itemoff 3353 itemsize 33
[29450.405089]          extent refs 1 gen 861178 flags 2
[29450.405090]          tree block backref root 5
[29450.405093]  item 20 key (950359658496 169 1) itemoff 3320 itemsize 33
[29450.405094]          extent refs 1 gen 861178 flags 2
[29450.405095]          tree block backref root 5
[29450.405097]  item 21 key (950359662592 169 0) itemoff 3287 itemsize 33
[29450.405099]          extent refs 1 gen 861178 flags 2
[29450.405100]          tree block backref root 5
[29450.405102]  item 22 key (950359666688 169 1) itemoff 3254 itemsize 33
[29450.405103]          extent refs 1 gen 861178 flags 2
[29450.405104]          tree block backref root 5
[29450.405106]  item 23 key (950359670784 169 1) itemoff 3221 itemsize 33
[29450.405108]          extent refs 1 gen 861178 flags 2
[29450.405109]          tree block backref root 2
[29450.405111]  item 24 key (950359674880 169 0) itemoff 3188 itemsize 33
[29450.405112]          extent refs 1 gen 861178 flags 2
[29450.405113]          tree block backref root 5
[29450.405115]  item 25 key (950359678976 169 0) itemoff 3155 itemsize 33
[29450.405117]          extent refs 1 gen 861178 flags 2
[29450.405118]          tree block backref root 2
[29450.405120]  item 26 key (950359683072 169 1) itemoff 3122 itemsize 33
[29450.405122]          extent refs 1 gen 861178 flags 2
[29450.405123]          tree block backref root 5
[29450.405125]  item 27 key (950359687168 169 0) itemoff 3089 itemsize 33
[29450.405126]          extent refs 1 gen 861178 flags 2
[29450.405127]          tree block backref root 5
[29450.405129]  item 28 key (950359691264 169 1) itemoff 3056 itemsize 33
[29450.405131]          extent refs 1 gen 861178 flags 2
[29450.405132]          tree block backref root 5
[29450.405134]  item 29 key (950359695360 169 0) itemoff 3023 itemsize 33
[29450.405135]          extent refs 1 gen 861178 flags 2
[29450.405136]          tree block backref root 5
[29450.405138]  item 30 key (950359699456 169 2) itemoff 2990 itemsize 33
[29450.405140]          extent refs 1 gen 861178 flags 2
[29450.405141]          tree block backref root 5
[29450.405143]  item 31 key (950359703552 169 1) itemoff 2957 itemsize 33
[29450.405144]          extent refs 1 gen 861178 flags 2
[29450.405145]          tree block backref root 5
[29450.405148]  item 32 key (951466917888 192 1107296256) itemoff 2933 
itemsize 24
[29450.405149]          block group used 0
[29450.405151]  item 33 key (952574214144 192 100663296) itemoff 2909 itemsize 
24
[29450.405152]          block group used 0
[29450.405154]  item 34 key (952674877440 192 3221225472) itemoff 2885 
itemsize 24
[29450.405155]          block group used 0
[29450.405157]  item 35 key (955896102912 192 3221225472) itemoff 2861 
itemsize 24
[29450.405158]          block group used 0
[29450.405160]  item 36 key (959117328384 192 3221225472) itemoff 2837 
itemsize 24
[29450.405161]          block group used 0
[29450.405163]  item 37 key (962338553856 192 3221225472) itemoff 2813 
itemsize 24
[29450.405164]          block group used 0
[29450.405166]  item 38 key (965559779328 192 3221225472) itemoff 2789 
itemsize 24
[29450.405167]          block group used 0
[29450.405169]  item 39 key (968781004800 192 3221225472) itemoff 2765 
itemsize 24
[29450.405171]          block group used 0
[29450.405173]  item 40 key (972002230272 192 3221225472) itemoff 2741 
itemsize 24
[29450.405174]          block group used 0
[29450.405176]  item 41 key (975223455744 192 3221225472) itemoff 2717 
itemsize 24
[29450.405177]          block group used 0
[29450.405179]  item 42 key (978444681216 192 3221225472) itemoff 2693 
itemsize 24
[29450.405180]          block group used 0
[29450.405182]  item 43 key (981665906688 192 3221225472) itemoff 2669 
itemsize 24
[29450.405183]          block group used 0
[29450.405185]  item 44 key (984887132160 192 3221225472) itemoff 2645 
itemsize 24
[29450.405186]          block group used 0
[29450.405188]  item 45 key (988108357632 192 3221225472) itemoff 2621 
itemsize 24
[29450.405189]          block group used 0
[29450.405191]  item 46 key (991329583104 192 3221225472) itemoff 2597 
itemsize 24
[29450.405192]          block group used 0
[29450.405194]  item 47 key (994550808576 192 3221225472) itemoff 2573 
itemsize 24
[29450.405195]          block group used 0
[29450.405197]  item 48 key (997772034048 192 3221225472) itemoff 2549 
itemsize 24
[29450.405198]          block group used 0
[29450.405200]  item 49 key (1000993259520 192 3221225472) itemoff 2525 
itemsize 24
[29450.405201]          block group used 0
[29450.405204]  item 50 key (1004214484992 192 3221225472) itemoff 2501 
itemsize 24
[29450.405205]          block group used 0
[29450.405207]  item 51 key (1007435710464 192 3221225472) itemoff 2477 
itemsize 24
[29450.405208]          block group used 0
[29450.405210]  item 52 key (1010656935936 192 3221225472) itemoff 2453 
itemsize 24
[29450.405211]          block group used 0
[29450.405213]  item 53 key (1013878161408 192 3221225472) itemoff 2429 
itemsize 24
[29450.405214]          block group used 0
[29450.405216]  item 54 key (1017099386880 192 3221225472) itemoff 2405 
itemsize 24
[29450.405217]          block group used 0
[29450.405219]  item 55 key (1020320612352 192 3221225472) itemoff 2381 
itemsize 24
[29450.405220]          block group used 0
[29450.405222]  item 56 key (1023541837824 192 3221225472) itemoff 2357 
itemsize 24
[29450.405223]          block group used 0
[29450.405225]  item 57 key (1026763063296 192 3221225472) itemoff 2333 
itemsize 24
[29450.405228]          block group used 0
[29450.405232]  item 58 key (1029984288768 192 3221225472) itemoff 2309 
itemsize 24
[29450.405237]          block group used 0
[29450.405241]  item 59 key (1033205514240 192 3221225472) itemoff 2285 
itemsize 24
[29450.405244]          block group used 0
[29450.405250]  item 60 key (1036426739712 192 3221225472) itemoff 2261 
itemsize 24
[29450.405255]          block group used 0
[29450.405262]  item 61 key (1039647965184 192 3221225472) itemoff 2237 
itemsize 24
[29450.405266]          block group used 0
[29450.405272]  item 62 key (1042869190656 192 3221225472) itemoff 2213 
itemsize 24
[29450.405279]          block group used 0
[29450.405288]  item 63 key (1046090416128 192 3221225472) itemoff 2189 
itemsize 24
[29450.405293]          block group used 0
[29450.405297]  item 64 key (1049311641600 192 3221225472) itemoff 2165 
itemsize 24
[29450.405304]          block group used 0
[29450.405310]  item 65 key (1052532867072 192 3221225472) itemoff 2141 
itemsize 24
[29450.405317]          block group used 0
[29450.405323]  item 66 key (1055754092544 192 3221225472) itemoff 2117 
itemsize 24
[29450.405329]          block group used 0
[29450.405335] BTRFS error (device sdd): unable to find ref byte nr 
951595991040 parent 0 root 5  owner 1 offset 0
[29450.405350] BTRFS: error (device sdd) in __btrfs_free_extent:6951: errno=-2 
No such entry
[29450.405373] BTRFS: error (device sdd) in btrfs_run_delayed_refs:2960: 
errno=-2 No such entry
[29450.406872] pending csums is 4096


btrfs output:
root@dibsi:/home/jan# btrfs check /dev/disk/by-uuid/
73d4dc77-6ff3-412f-9b0a-0d11458faf32 
Checking filesystem on /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
UUID: 73d4dc77-6ff3-412f-9b0a-0d11458faf32
checking extents
parent transid verify failed on 2280458502144 wanted 861168 found 860380
parent transid verify failed on 2280458502144 wanted 861168 found 860380
checksum verify failed on 2280458502144 found FC3DF84D wanted 2164EB93
checksum verify failed on 2280458502144 found FC3DF84D wanted 2164EB93
bytenr mismatch, want=2280458502144, have=15938383240448
parent transid verify failed on 2280458502144 wanted 861168 found 860380
parent transid verify failed on 2280458502144 wanted 861168 found 860380
checksum verify failed on 2280458502144 found FC3DF84D wanted 2164EB93
checksum verify failed on 2280458502144 found FC3DF84D wanted 2164EB93
bytenr mismatch, want=2280458502144, have=15938383240448
parent transid verify failed on 2280458506240 wanted 861168 found 860380
parent transid verify failed on 2280458506240 wanted 861168 found 860380
checksum verify failed on 2280458506240 found E76FAE4B wanted 968BCF7A
checksum verify failed on 2280458506240 found E76FAE4B wanted 968BCF7A
bytenr mismatch, want=2280458506240, have=15938383228160
parent transid verify failed on 2280458510336 wanted 861168 found 860380
parent transid verify failed on 2280458510336 wanted 861168 found 860380
checksum verify failed on 2280458510336 found ABA824E6 wanted FD072FC5
checksum verify failed on 2280458510336 found ABA824E6 wanted FD072FC5
bytenr mismatch, want=2280458510336, have=15938383199488
parent transid verify failed on 2280458620928 wanted 861168 found 860380
parent transid verify failed on 2280458620928 wanted 861168 found 860380
checksum verify failed on 2280458620928 found 4C43E476 wanted F3660326
checksum verify failed on 2280458620928 found 4C43E476 wanted F3660326
bytenr mismatch, want=2280458620928, have=15938383802368
parent transid verify failed on 2280458625024 wanted 861168 found 860380
parent transid verify failed on 2280458625024 wanted 861168 found 860380
checksum verify failed on 2280458625024 found AD8EE78F wanted 093A4586
checksum verify failed on 2280458625024 found AD8EE78F wanted 093A4586
bytenr mismatch, want=2280458625024, have=15938383831040
parent transid verify failed on 2280458629120 wanted 861168 found 860380
parent transid verify failed on 2280458629120 wanted 861168 found 860380
checksum verify failed on 2280458629120 found 67FC5731 wanted 3F68DF37
checksum verify failed on 2280458629120 found 67FC5731 wanted 3F68DF37
bytenr mismatch, want=2280458629120, have=15938383810560
parent transid verify failed on 2280458633216 wanted 861168 found 860380
parent transid verify failed on 2280458633216 wanted 861168 found 860380
checksum verify failed on 2280458633216 found D3E6B383 wanted 372BEB16
checksum verify failed on 2280458633216 found D3E6B383 wanted 372BEB16
bytenr mismatch, want=2280458633216, have=15938383830272
parent transid verify failed on 2280458637312 wanted 861168 found 860380
parent transid verify failed on 2280458637312 wanted 861168 found 860380
checksum verify failed on 2280458637312 found AD56590B wanted 27275E35
checksum verify failed on 2280458637312 found AD56590B wanted 27275E35
bytenr mismatch, want=2280458637312, have=15938383817984
parent transid verify failed on 2280458645504 wanted 861168 found 860380
parent transid verify failed on 2280458645504 wanted 861168 found 860380
checksum verify failed on 2280458645504 found 609E8D90 wanted 62B88736
checksum verify failed on 2280458645504 found 609E8D90 wanted 62B88736
bytenr mismatch, want=2280458645504, have=15938383793408
parent transid verify failed on 2280465395712 wanted 861168 found 860380
parent transid verify failed on 2280465395712 wanted 861168 found 860380
checksum verify failed on 2280465395712 found 1EE17660 wanted 5A593448
checksum verify failed on 2280465395712 found 1EE17660 wanted 5A593448
bytenr mismatch, want=2280465395712, have=15938501561600
parent transid verify failed on 2280415236096 wanted 861168 found 860380
parent transid verify failed on 2280415236096 wanted 861168 found 860380
checksum verify failed on 2280415236096 found F04B13C4 wanted CD1F2721
checksum verify failed on 2280415236096 found F04B13C4 wanted CD1F2721
bytenr mismatch, want=2280415236096, have=15938149183488
parent transid verify failed on 2280259969024 wanted 861166 found 860373
parent transid verify failed on 2280259969024 wanted 861166 found 860373
checksum verify failed on 2280259969024 found B80076DB wanted 09C8FA6F
checksum verify failed on 2280259969024 found B80076DB wanted 09C8FA6F
bytenr mismatch, want=2280259969024, have=15937221663232
parent transid verify failed on 2280409526272 wanted 861168 found 860376
parent transid verify failed on 2280409526272 wanted 861168 found 860376
checksum verify failed on 2280409526272 found 4357A5F3 wanted 969A158E
checksum verify failed on 2280409526272 found 4357A5F3 wanted 969A158E
bytenr mismatch, want=2280409526272, have=15938088724992
parent transid verify failed on 2280428298240 wanted 861168 found 860376
parent transid verify failed on 2280428298240 wanted 861168 found 860376
checksum verify failed on 2280428298240 found B8F51F6A wanted A2F455BD
checksum verify failed on 2280428298240 found B8F51F6A wanted A2F455BD
bytenr mismatch, want=2280428298240, have=15938466364672
parent transid verify failed on 2280446873600 wanted 861168 found 860380
parent transid verify failed on 2280446873600 wanted 861168 found 860380
checksum verify failed on 2280446873600 found DDD2FE66 wanted F89EED66
checksum verify failed on 2280446873600 found DDD2FE66 wanted F89EED66
bytenr mismatch, want=2280446873600, have=15938382596608
parent transid verify failed on 2280272723968 wanted 861166 found 860370
parent transid verify failed on 2280272723968 wanted 861166 found 860370
checksum verify failed on 2280272723968 found E4F93095 wanted B089A4B7
checksum verify failed on 2280272723968 found E4F93095 wanted B089A4B7
bytenr mismatch, want=2280272723968, have=15937216620288
parent transid verify failed on 2280345731072 wanted 861168 found 860377
parent transid verify failed on 2280345731072 wanted 861168 found 860377
checksum verify failed on 2280345731072 found 316EB1A6 wanted 1249429F
checksum verify failed on 2280345731072 found 316EB1A6 wanted 1249429F
bytenr mismatch, want=2280345731072, have=15937407592192
parent transid verify failed on 2280347447296 wanted 861167 found 860377
parent transid verify failed on 2280347447296 wanted 861167 found 860377
checksum verify failed on 2280347447296 found 6D4A46D8 wanted F2C503E1
checksum verify failed on 2280347447296 found 6D4A46D8 wanted F2C503E1
bytenr mismatch, want=2280347447296, have=15937414706944
parent transid verify failed on 2280388960256 wanted 861168 found 860380
parent transid verify failed on 2280388960256 wanted 861168 found 860380
checksum verify failed on 2280388960256 found 3B3067A0 wanted 46EE075B
checksum verify failed on 2280388960256 found 3B3067A0 wanted 46EE075B
bytenr mismatch, want=2280388960256, have=15938310299648
parent transid verify failed on 2280389693440 wanted 861168 found 860380
parent transid verify failed on 2280389693440 wanted 861168 found 860380
checksum verify failed on 2280389693440 found FABC36B0 wanted E26236B9
checksum verify failed on 2280389693440 found FABC36B0 wanted E26236B9
bytenr mismatch, want=2280389693440, have=15938306026752
parent transid verify failed on 2280157011968 wanted 861165 found 860361
parent transid verify failed on 2280157011968 wanted 861165 found 860361
checksum verify failed on 2280157011968 found 40E10FA2 wanted FF1F5A65
checksum verify failed on 2280157011968 found 40E10FA2 wanted FF1F5A65
bytenr mismatch, want=2280157011968, have=15936811604480
parent transid verify failed on 2280157970432 wanted 861165 found 860361
parent transid verify failed on 2280157970432 wanted 861165 found 860361
checksum verify failed on 2280157970432 found 331A4EF6 wanted 6D271A13
checksum verify failed on 2280157970432 found 331A4EF6 wanted 6D271A13
bytenr mismatch, want=2280157970432, have=15936577447680
parent transid verify failed on 2280427163648 wanted 861168 found 860380
parent transid verify failed on 2280427163648 wanted 861168 found 860380
checksum verify failed on 2280427163648 found 1C8FE3B6 wanted 95818BD4
checksum verify failed on 2280427163648 found 1C8FE3B6 wanted 95818BD4
bytenr mismatch, want=2280427163648, have=15938458906624
parent transid verify failed on 2280445718528 wanted 861168 found 860380
parent transid verify failed on 2280445718528 wanted 861168 found 860380
checksum verify failed on 2280445718528 found 67E355D6 wanted B49E524F
checksum verify failed on 2280445718528 found 67E355D6 wanted B49E524F
bytenr mismatch, want=2280445718528, have=15938385121280
parent transid verify failed on 503649468416 wanted 2486 found 861173
Ignoring transid failure
parent transid verify failed on 503649472512 wanted 2486 found 861177
parent transid verify failed on 503649472512 wanted 2486 found 861177
checksum verify failed on 503649472512 found 094AA6E5 wanted 76FAADD7
checksum verify failed on 503649472512 found 094AA6E5 wanted 76FAADD7
bytenr mismatch, want=503649472512, have=372927852544
parent transid verify failed on 503649476608 wanted 818691 found 861177
parent transid verify failed on 503649476608 wanted 818691 found 861177
checksum verify failed on 503649476608 found 6CF07DA7 wanted 1EC02B4E
checksum verify failed on 503649476608 found 6CF07DA7 wanted 1EC02B4E
bytenr mismatch, want=503649476608, have=372927881216
parent transid verify failed on 503649480704 wanted 2486 found 861177
parent transid verify failed on 503649480704 wanted 2486 found 861177
checksum verify failed on 503649480704 found 74888BDC wanted 5396C8AC
bytenr mismatch, want=503649480704, have=503649415168
parent transid verify failed on 503649484800 wanted 141269 found 861172
parent transid verify failed on 503649484800 wanted 141269 found 861172
checksum verify failed on 503649484800 found 519C3303 wanted 1B4232A5
checksum verify failed on 503649484800 found 519C3303 wanted 1B4232A5
bytenr mismatch, want=503649484800, have=372927880448
parent transid verify failed on 503649488896 wanted 2486 found 861176
parent transid verify failed on 503649488896 wanted 2486 found 861176
checksum verify failed on 503649488896 found 4619DDAF wanted A0B78F95
bytenr mismatch, want=503649488896, have=503649423360
parent transid verify failed on 503649492992 wanted 2486 found 861176
parent transid verify failed on 503649492992 wanted 2486 found 861176
checksum verify failed on 503649492992 found EBC18A42 wanted F05DA8AA
bytenr mismatch, want=503649492992, have=503649427456
parent transid verify failed on 503649497088 wanted 2486 found 861176
parent transid verify failed on 503649497088 wanted 2486 found 861176
checksum verify failed on 503649497088 found B046E5A0 wanted 9867B21F
checksum verify failed on 503649497088 found B046E5A0 wanted 9867B21F
bytenr mismatch, want=503649497088, have=372927843584
parent transid verify failed on 503649501184 wanted 2486 found 861176
parent transid verify failed on 503649501184 wanted 2486 found 861176
checksum verify failed on 503649501184 found 717EBF4C wanted A15FDF58
parent transid verify failed on 503649501184 wanted 2486 found 861176
Ignoring transid failure
leaf parent key incorrect 503649501184
bad block 503649501184
ERROR: errors found in extent allocation tree or chunk allocation
parent transid verify failed on 2280458502144 wanted 861168 found 860380
parent transid verify failed on 2280458502144 wanted 861168 found 860380
checksum verify failed on 2280458502144 found FC3DF84D wanted 2164EB93
checksum verify failed on 2280458502144 found FC3DF84D wanted 2164EB93
bytenr mismatch, want=2280458502144, have=15938383240448
