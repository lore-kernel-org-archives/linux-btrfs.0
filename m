Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35883 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933448AbcJSORJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:17:09 -0400
Received: by mail-io0-f174.google.com with SMTP id j37so32781930ioo.3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 07:17:08 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Wed, 19 Oct 2016 14:16:09 +0300
Message-ID: <CAOE4rSymtBm6if2-6auAByo02UWVwv4SnNnFSQLK0H9LxdLmTA@mail.gmail.com>
Subject: WARNING at extent-tree.c:6945 __btrfs_free_extent.isra.33+0x7d6/0xca0
 (Linux 4.8.0)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Basically on multi-disk btrfs partition few sectors on one HDD became
unreadable and when trying to delete one folder on that filesystem I
got this in log

[12210.590339] WARNING: CPU: 4 PID: 3375 at
/mnt/linux/fs/btrfs/extent-tree.c:6945
__btrfs_free_extent.isra.33+0x7d6/0xca0 [btrfs]
[12210.590340] Modules linked in: fuse input_leds led_class
snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device mousedev
joydev hid_generic usbhid hid xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter
xt_tcpudp ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink
ebtable_broute ebtable_nat ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw ip6table_security
ip6table_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_security
iptable_mangle ebtable_filter ebtables bridge ip6table_filter
ip6_tables stp iptable_filter llc it87 hwmon_vid kvm_amd kvm
saa7134_alsa irqbypass snd_hda_codec_realtek snd_hda_codec_generic
crct10dif_pclmul
[12210.590384]  snd_hda_codec_hdmi saa7134 crc32_pclmul tveeprom
rc_core ghash_clmulni_intel snd_hda_intel v4l2_common snd_hda_codec
aesni_intel videobuf2_dma_sg aes_x86_64 snd_hda_core videobuf2_memops
videobuf2_v4l2 lrw videobuf2_core gf128mul snd_hwdep videodev r8169
glue_helper evdev snd_pcm media ablk_helper cryptd mac_hid pcspkr
k10temp fam15h_power mxm_wmi snd_timer mii snd sp5100_tco soundcore
i2c_piix4 acpi_cpufreq tpm_infineon tpm_tis tpm_tis_core shpchp tpm
button wmi nfsd auth_rpcgss oid_registry nfs_acl sch_fq_codel lockd
grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq sd_mod
ata_generic pata_acpi ohci_pci serio_raw atkbd libps2 nvidia_drm(PO)
nvidia_modeset(PO) nvidia(PO) firewire_ohci xhci_pci firewire_core
ohci_hcd
[12210.590435]  ehci_pci xhci_hcd crc_itu_t ehci_hcd drm pata_atiixp
usbcore ahci libahci usb_common i2c_core i8042 serio mvsas libsas
scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel vfat
fat ip_tables x_tables
[12210.590453] CPU: 4 PID: 3375 Comm: kworker/u16:0 Tainted: P
  O    4.8.0-ARCH-dirty #1
[12210.590454] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[12210.590471] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[12210.590474]  0000000000000286 00000000463ac1f2 ffff8805bb097ae0
ffffffff812e9bb0
[12210.590477]  0000000000000000 0000000000000000 ffff8805bb097b20
ffffffff8107bcab
[12210.590481]  00001b219626bc00 0000009626bbf000 00000000fffffffe
ffff88061216ec80
[12210.590484] Call Trace:
[12210.590489]  [<ffffffff812e9bb0>] dump_stack+0x63/0x83
[12210.590492]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[12210.590494]  [<ffffffff8107bddd>] warn_slowpath_null+0x1d/0x20
[12210.590508]  [<ffffffffa109ff86>]
__btrfs_free_extent.isra.33+0x7d6/0xca0 [btrfs]
[12210.590522]  [<ffffffffa10a43b0>]
__btrfs_run_delayed_refs+0x5b0/0x12e0 [btrfs]
[12210.590525]  [<ffffffff811d7570>] ? kmem_cache_free+0x1e0/0x210
[12210.590528]  [<ffffffff810c7546>] ? cpuacct_charge+0x86/0xa0
[12210.590546]  [<ffffffffa10e1a42>] ?
end_bio_extent_readpage+0x222/0x5f0 [btrfs]
[12210.590560]  [<ffffffffa10a81a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[12210.590575]  [<ffffffffa10a8434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[12210.590592]  [<ffffffffa10f3d5d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[12210.590608]  [<ffffffffa10f405e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[12210.590611]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[12210.590614]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[12210.590616]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[12210.590619]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[12210.590621]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[12210.590625]  [<ffffffff815cb1ff>] ret_from_fork+0x1f/0x40
[12210.590628]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[12210.590630] ---[ end trace 293673cf94b7856a ]---
[12210.590633] BTRFS info (device sdo): leaf 33812980416512 total ptrs
213 free space 2101
[12210.590635]     item 0 key (644872798208 168 524288) itemoff 16230
itemsize 53
[12210.590637]         extent refs 1 gen 215 flags 1
[12210.590639]         extent data backref root 261 objectid 783
offset 41418752 count 1
[12210.590641]     item 1 key (644873322496 168 524288) itemoff 16177
itemsize 53
[12210.590642]         extent refs 1 gen 215 flags 1
[12210.590643]         extent data backref root 261 objectid 783
offset 41943040 count 1
[12210.590645]     item 2 key (644873846784 168 524288) itemoff 16124
itemsize 53
[12210.590646]         extent refs 1 gen 215 flags 1
[12210.590647]         extent data backref root 261 objectid 783
offset 42467328 count 1
[12210.590649]     item 3 key (644874371072 168 524288) itemoff 16071
itemsize 53
[12210.590650]         extent refs 1 gen 215 flags 1
[12210.590651]         extent data backref root 261 objectid 783
offset 42991616 count 1
[12210.590653]     item 4 key (644874895360 168 524288) itemoff 16018
itemsize 53
[12210.590654]         extent refs 1 gen 215 flags 1
[12210.590655]         extent data backref root 261 objectid 783
offset 43515904 count 1
[12210.590657]     item 5 key (644875419648 168 524288) itemoff 15965
itemsize 53
[12210.590658]         extent refs 1 gen 215 flags 1
[12210.590659]         extent data backref root 261 objectid 783
offset 44040192 count 1
[12210.590661]     item 6 key (644875943936 168 524288) itemoff 15912
itemsize 53
[12210.590662]         extent refs 1 gen 215 flags 1
[12210.590663]         extent data backref root 261 objectid 783
offset 44564480 count 1
[12210.590665]     item 7 key (644876468224 168 524288) itemoff 15859
itemsize 53
[12210.590666]         extent refs 1 gen 215 flags 1
[12210.590667]         extent data backref root 261 objectid 783
offset 45088768 count 1
[12210.590669]     item 8 key (644876992512 168 524288) itemoff 15806
itemsize 53
[12210.590670]         extent refs 1 gen 215 flags 1
[12210.590671]         extent data backref root 261 objectid 783
offset 45613056 count 1
[12210.590673]     item 9 key (644877516800 168 524288) itemoff 15753
itemsize 53
[12210.590674]         extent refs 1 gen 215 flags 1
[12210.590675]         extent data backref root 261 objectid 783
offset 46137344 count 1
[12210.590677]     item 10 key (644878041088 168 524288) itemoff 15700
itemsize 53
[12210.590678]         extent refs 1 gen 215 flags 1
[12210.590680]         extent data backref root 261 objectid 783
offset 46661632 count 1
[12210.590681]     item 11 key (644878565376 168 524288) itemoff 15647
itemsize 53
[12210.590682]         extent refs 1 gen 215 flags 1
[12210.590684]         extent data backref root 261 objectid 783
offset 47185920 count 1
[12210.590685]     item 12 key (644879089664 168 524288) itemoff 15594
itemsize 53
[12210.590686]         extent refs 1 gen 215 flags 1
[12210.590688]         extent data backref root 261 objectid 783
offset 47710208 count 1
[12210.590689]     item 13 key (644879613952 168 524288) itemoff 15541
itemsize 53
[12210.590690]         extent refs 1 gen 215 flags 1
[12210.590692]         extent data backref root 261 objectid 783
offset 48234496 count 1
[12210.590693]     item 14 key (644880138240 168 524288) itemoff 15488
itemsize 53
[12210.590694]         extent refs 1 gen 215 flags 1
[12210.590696]         extent data backref root 261 objectid 783
offset 48758784 count 1
[12210.590697]     item 15 key (644880662528 168 524288) itemoff 15435
itemsize 53
[12210.590698]         extent refs 1 gen 215 flags 1
[12210.590700]         extent data backref root 261 objectid 783
offset 49283072 count 1
[12210.590701]     item 16 key (644881186816 168 524288) itemoff 15382
itemsize 53
[12210.590702]         extent refs 1 gen 215 flags 1
[12210.590704]         extent data backref root 261 objectid 783
offset 49807360 count 1
[12210.590705]     item 17 key (644881711104 168 524288) itemoff 15329
itemsize 53
[12210.590706]         extent refs 1 gen 215 flags 1
[12210.590708]         extent data backref root 261 objectid 783
offset 50331648 count 1
[12210.590709]     item 18 key (644882235392 168 524288) itemoff 15276
itemsize 53
[12210.590711]         extent refs 1 gen 215 flags 1
[12210.590712]         extent data backref root 261 objectid 783
offset 50855936 count 1
[12210.590713]     item 19 key (644882759680 168 524288) itemoff 15223
itemsize 53
[12210.590715]         extent refs 1 gen 215 flags 1
[12210.590716]         extent data backref root 261 objectid 783
offset 51380224 count 1
[12210.590718]     item 20 key (644883283968 168 524288) itemoff 15170
itemsize 53
[12210.590719]         extent refs 1 gen 215 flags 1
[12210.590720]         extent data backref root 261 objectid 783
offset 51904512 count 1
[12210.590722]     item 21 key (644883808256 168 524288) itemoff 15117
itemsize 53
[12210.590723]         extent refs 1 gen 215 flags 1
[12210.590724]         extent data backref root 261 objectid 783
offset 52428800 count 1
[12210.590726]     item 22 key (644884332544 168 524288) itemoff 15064
itemsize 53
[12210.590727]         extent refs 1 gen 215 flags 1
[12210.590728]         extent data backref root 261 objectid 783
offset 52953088 count 1
[12210.590730]     item 23 key (644884856832 168 524288) itemoff 15011
itemsize 53
[12210.590731]         extent refs 1 gen 215 flags 1
[12210.590732]         extent data backref root 261 objectid 783
offset 53477376 count 1
[12210.590734]     item 24 key (644885381120 168 524288) itemoff 14958
itemsize 53
[12210.590735]         extent refs 1 gen 215 flags 1
[12210.590736]         extent data backref root 261 objectid 783
offset 54001664 count 1
[12210.590738]     item 25 key (644885905408 168 524288) itemoff 14905
itemsize 53
[12210.590739]         extent refs 1 gen 215 flags 1
[12210.590740]         extent data backref root 261 objectid 783
offset 54525952 count 1
[12210.590742]     item 26 key (644886429696 168 524288) itemoff 14852
itemsize 53
[12210.590743]         extent refs 1 gen 215 flags 1
[12210.590744]         extent data backref root 261 objectid 783
offset 55050240 count 1
[12210.590746]     item 27 key (644886953984 168 524288) itemoff 14799
itemsize 53
[12210.590747]         extent refs 1 gen 215 flags 1
[12210.590748]         extent data backref root 261 objectid 783
offset 55574528 count 1
[12210.590750]     item 28 key (644887478272 168 524288) itemoff 14746
itemsize 53
[12210.590751]         extent refs 1 gen 215 flags 1
[12210.590752]         extent data backref root 261 objectid 783
offset 56098816 count 1
[12210.590754]     item 29 key (644888002560 168 524288) itemoff 14693
itemsize 53
[12210.590755]         extent refs 1 gen 215 flags 1
[12210.590756]         extent data backref root 261 objectid 783
offset 56623104 count 1
[12210.590758]     item 30 key (644888526848 168 524288) itemoff 14640
itemsize 53
[12210.590759]         extent refs 1 gen 77869 flags 1
[12210.590761]         extent data backref root 261 objectid 3284
offset 0 count 1
[12210.590762]     item 31 key (644889051136 168 524288) itemoff 14587
itemsize 53
[12210.590763]         extent refs 1 gen 77869 flags 1
[12210.590765]         extent data backref root 261 objectid 3285
offset 0 count 1
[12210.590766]     item 32 key (644889575424 168 655360) itemoff 14550
itemsize 37
[12210.590767]         extent refs 1 gen 77869 flags 1
[12210.590768]         shared data backref parent 33207361650688 count 1
[12210.590770]     item 33 key (644890230784 168 524288) itemoff 14497
itemsize 53
[12210.590771]         extent refs 1 gen 77872 flags 1
[12210.590773]         extent data backref root 261 objectid 3976
offset 1572864 count 1
[12210.590774]     item 34 key (644890755072 168 122880) itemoff 14460
itemsize 37
[12210.590775]         extent refs 1 gen 149517 flags 1
[12210.590776]         shared data backref parent 33205604614144 count 1
[12210.590778]     item 35 key (644890877952 168 106496) itemoff 14423
itemsize 37
[12210.590779]         extent refs 1 gen 149517 flags 1
[12210.590780]         shared data backref parent 33205604614144 count 1
[12210.590782]     item 36 key (644890984448 168 32768) itemoff 14386
itemsize 37
[12210.590783]         extent refs 1 gen 149517 flags 1
[12210.590784]         shared data backref parent 33202788433920 count 1
[12210.590785]     item 37 key (644891017216 168 53248) itemoff 14349
itemsize 37
[12210.590786]         extent refs 1 gen 149515 flags 1
[12210.590787]         shared data backref parent 33195660607488 count 1
[12210.590789]     item 38 key (644891070464 168 24576) itemoff 14312
itemsize 37
[12210.590790]         extent refs 1 gen 149515 flags 1
[12210.590791]         shared data backref parent 33195660607488 count 1
[12210.590793]     item 39 key (644891095040 168 45056) itemoff 14275
itemsize 37
[12210.590794]         extent refs 1 gen 149515 flags 1
[12210.590795]         shared data backref parent 33195660607488 count 1
[12210.590796]     item 40 key (644891140096 168 24576) itemoff 14238
itemsize 37
[12210.590797]         extent refs 1 gen 149515 flags 1
[12210.590799]         shared data backref parent 33195660607488 count 1
[12210.590800]     item 41 key (644891164672 168 69632) itemoff 14201
itemsize 37
[12210.590801]         extent refs 1 gen 149515 flags 1
[12210.590802]         shared data backref parent 33195660607488 count 1
[12210.590804]     item 42 key (644891234304 168 20480) itemoff 14164
itemsize 37
[12210.590805]         extent refs 1 gen 149515 flags 1
[12210.590806]         shared data backref parent 33195660607488 count 1
[12210.590807]     item 43 key (644891254784 168 16384) itemoff 14127
itemsize 37
[12210.590808]         extent refs 1 gen 149515 flags 1
[12210.590810]         shared data backref parent 33195660607488 count 1
[12210.590811]     item 44 key (644891271168 168 4096) itemoff 14090 itemsize 37
[12210.590812]         extent refs 1 gen 149515 flags 1
[12210.590813]         shared data backref parent 33195666014208 count 1
[12210.590815]     item 45 key (644891275264 168 102400) itemoff 14053
itemsize 37
[12210.590816]         extent refs 1 gen 120817 flags 1
[12210.590817]         shared data backref parent 33200591765504 count 1
[12210.590819]     item 46 key (644891377664 168 114688) itemoff 14016
itemsize 37
[12210.590820]         extent refs 1 gen 120817 flags 1
[12210.590821]         shared data backref parent 33200591765504 count 1
[12210.590822]     item 47 key (644891492352 168 36864) itemoff 13979
itemsize 37
[12210.590823]         extent refs 1 gen 146327 flags 1
[12210.590824]         shared data backref parent 33199769829376 count 1
[12210.590826]     item 48 key (644891529216 168 4096) itemoff 13942 itemsize 37
[12210.590827]         extent refs 1 gen 124938 flags 1
[12210.590828]         shared data backref parent 33201927847936 count 1
[12210.590830]     item 49 key (644891533312 168 8192) itemoff 13905 itemsize 37
[12210.590831]         extent refs 1 gen 177562 flags 1
[12210.590832]         shared data backref parent 33202448318464 count 1
[12210.590833]     item 50 key (644891541504 168 86016) itemoff 13868
itemsize 37
[12210.590835]         extent refs 1 gen 150949 flags 1
[12210.590836]         shared data backref parent 33212656697344 count 1
[12210.590837]     item 51 key (644891627520 168 86016) itemoff 13831
itemsize 37
[12210.590838]         extent refs 1 gen 150949 flags 1
[12210.590839]         shared data backref parent 33212656697344 count 1
[12210.590841]     item 52 key (644891713536 168 36864) itemoff 13794
itemsize 37
[12210.590842]         extent refs 1 gen 150949 flags 1
[12210.590843]         shared data backref parent 33212656697344 count 1
[12210.590844]     item 53 key (644891750400 168 28672) itemoff 13757
itemsize 37
[12210.590846]         extent refs 1 gen 150949 flags 1
[12210.590847]         shared data backref parent 33205477900288 count 1
[12210.590848]     item 54 key (644891779072 168 8192) itemoff 13720 itemsize 37
[12210.590849]         extent refs 1 gen 150951 flags 1
[12210.590850]         shared data backref parent 33206214934528 count 1
[12210.590852]     item 55 key (644891787264 168 4096) itemoff 13683 itemsize 37
[12210.590853]         extent refs 1 gen 150951 flags 1
[12210.590854]         shared data backref parent 33206214934528 count 1
[12210.590856]     item 56 key (644891791360 168 8192) itemoff 13630 itemsize 53
[12210.590857]         extent refs 1 gen 318017 flags 1
[12210.590858]         extent data backref root 2043 objectid 3587334
offset 262144 count 1
[12210.590860]     item 57 key (644891799552 168 4096) itemoff 13577 itemsize 53
[12210.590861]         extent refs 1 gen 318374 flags 1
[12210.590862]         extent data backref root 2043 objectid 3599310
offset 0 count 1
[12210.590864]     item 58 key (644891803648 168 524288) itemoff 13524
itemsize 53
[12210.590865]         extent refs 1 gen 149432 flags 1
[12210.590866]         extent data backref root 261 objectid 8872
offset 31457280 count 1
[12210.590868]     item 59 key (644892327936 168 524288) itemoff 13471
itemsize 53
[12210.590869]         extent refs 1 gen 149432 flags 1
[12210.590870]         extent data backref root 261 objectid 8872
offset 31981568 count 1
[12210.590872]     item 60 key (644892852224 168 524288) itemoff 13418
itemsize 53
[12210.590873]         extent refs 1 gen 149432 flags 1
[12210.590874]         extent data backref root 261 objectid 8872
offset 32505856 count 1
[12210.590876]     item 61 key (644893376512 168 524288) itemoff 13365
itemsize 53
[12210.590877]         extent refs 1 gen 149432 flags 1
[12210.590878]         extent data backref root 261 objectid 8872
offset 33030144 count 1
[12210.590880]     item 62 key (644893900800 168 77824) itemoff 13328
itemsize 37
[12210.590881]         extent refs 1 gen 149515 flags 1
[12210.590882]         shared data backref parent 33195660607488 count 1
[12210.590884]     item 63 key (644893978624 168 57344) itemoff 13291
itemsize 37
[12210.590885]         extent refs 1 gen 149515 flags 1
[12210.590886]         shared data backref parent 33195660607488 count 1
[12210.590888]     item 64 key (644894035968 168 57344) itemoff 13254
itemsize 37
[12210.590889]         extent refs 1 gen 149515 flags 1
[12210.590890]         shared data backref parent 33195660607488 count 1
[12210.590891]     item 65 key (644894093312 168 53248) itemoff 13217
itemsize 37
[12210.590892]         extent refs 1 gen 149515 flags 1
[12210.590893]         shared data backref parent 33195660607488 count 1
[12210.590895]     item 66 key (644894146560 168 16384) itemoff 13180
itemsize 37
[12210.590896]         extent refs 1 gen 149515 flags 1
[12210.590897]         shared data backref parent 33195660607488 count 1
[12210.590899]     item 67 key (644894162944 168 86016) itemoff 13143
itemsize 37
[12210.590900]         extent refs 1 gen 150948 flags 1
[12210.590901]         shared data backref parent 33202880495616 count 1
[12210.590902]     item 68 key (644894248960 168 106496) itemoff 13106
itemsize 37
[12210.590903]         extent refs 1 gen 150948 flags 1
[12210.590904]         shared data backref parent 33202880495616 count 1
[12210.590906]     item 69 key (644894355456 168 53248) itemoff 13069
itemsize 37
[12210.590907]         extent refs 1 gen 150948 flags 1
[12210.590908]         shared data backref parent 33207354474496 count 1
[12210.590910]     item 70 key (644894408704 168 16384) itemoff 13032
itemsize 37
[12210.590911]         extent refs 1 gen 150948 flags 1
[12210.590912]         shared data backref parent 33210413891584 count 1
[12210.590913]     item 71 key (644894425088 168 53248) itemoff 12995
itemsize 37
[12210.590914]         extent refs 1 gen 149515 flags 1
[12210.590915]         shared data backref parent 33195666014208 count 1
[12210.590917]     item 72 key (644894478336 168 28672) itemoff 12958
itemsize 37
[12210.590918]         extent refs 1 gen 149515 flags 1
[12210.590919]         shared data backref parent 33195666014208 count 1
[12210.590921]     item 73 key (644894507008 168 53248) itemoff 12921
itemsize 37
[12210.590922]         extent refs 1 gen 149515 flags 1
[12210.590923]         shared data backref parent 33195666014208 count 1
[12210.590924]     item 74 key (644894560256 168 24576) itemoff 12884
itemsize 37
[12210.590925]         extent refs 1 gen 149515 flags 1
[12210.590926]         shared data backref parent 33195666014208 count 1
[12210.590928]     item 75 key (644894584832 168 49152) itemoff 12847
itemsize 37
[12210.590929]         extent refs 1 gen 149515 flags 1
[12210.590930]         shared data backref parent 33195666014208 count 1
[12210.590932]     item 76 key (644894633984 168 20480) itemoff 12810
itemsize 37
[12210.590933]         extent refs 1 gen 149515 flags 1
[12210.590934]         shared data backref parent 33195666014208 count 1
[12210.590935]     item 77 key (644894654464 168 12288) itemoff 12773
itemsize 37
[12210.590936]         extent refs 1 gen 149515 flags 1
[12210.590937]         shared data backref parent 33196891865088 count 1
[12210.590939]     item 78 key (644894666752 168 20480) itemoff 12720
itemsize 53
[12210.590940]         extent refs 1 gen 156901 flags 1
[12210.590941]         extent data backref root 262 objectid 1343827
offset 3014656 count 1
[12210.590943]     item 79 key (644894687232 168 73728) itemoff 12683
itemsize 37
[12210.590944]         extent refs 1 gen 164109 flags 1
[12210.590945]         shared data backref parent 33203275218944 count 1
[12210.590947]     item 80 key (644894760960 168 69632) itemoff 12646
itemsize 37
[12210.590948]         extent refs 1 gen 164109 flags 1
[12210.590949]         shared data backref parent 33203275218944 count 1
[12210.590950]     item 81 key (644894830592 168 73728) itemoff 12609
itemsize 37
[12210.590952]         extent refs 1 gen 164109 flags 1
[12210.590953]         shared data backref parent 33203275218944 count 1
[12210.590954]     item 82 key (644894904320 168 40960) itemoff 12572
itemsize 37
[12210.590955]         extent refs 1 gen 164109 flags 1
[12210.590956]         shared data backref parent 33203275218944 count 1
[12210.590958]     item 83 key (644894945280 168 4096) itemoff 12519 itemsize 53
[12210.590959]         extent refs 1 gen 325722 flags 1
[12210.590960]         extent data backref root 262 objectid 2165941
offset 0 count 1
[12210.590962]     item 84 key (644894949376 168 20480) itemoff 12466
itemsize 53
[12210.590963]         extent refs 1 gen 306115 flags 1
[12210.590964]         extent data backref root 2043 objectid 3265483
offset 0 count 1
[12210.590966]     item 85 key (644894969856 168 20480) itemoff 12413
itemsize 53
[12210.590967]         extent refs 1 gen 156901 flags 1
[12210.590968]         extent data backref root 262 objectid 1343827
offset 5242880 count 1
[12210.590970]     item 86 key (644894990336 168 8192) itemoff 12376 itemsize 37
[12210.590971]         extent refs 1 gen 163977 flags 1
[12210.590972]         shared data backref parent 33208078843904 count 1
[12210.590974]     item 87 key (644894998528 168 4096) itemoff 12323 itemsize 53
[12210.590975]         extent refs 1 gen 325503 flags 1
[12210.590976]         extent data backref root 2043 objectid 3640384
offset 0 count 1
[12210.590978]     item 88 key (644895002624 168 16384) itemoff 12286
itemsize 37
[12210.590979]         extent refs 1 gen 177519 flags 1
[12210.590980]         shared data backref parent 33211444396032 count 1
[12210.590981]     item 89 key (644895019008 168 4096) itemoff 12233 itemsize 53
[12210.590983]         extent refs 1 gen 157657 flags 1
[12210.590984]         extent data backref root 261 objectid 8947
offset 786432 count 1
[12210.590986]     item 90 key (644895023104 168 4096) itemoff 12180 itemsize 53
[12210.590987]         extent refs 1 gen 157657 flags 1
[12210.590988]         extent data backref root 261 objectid 8947
offset 917504 count 1
[12210.590990]     item 91 key (644895027200 168 4096) itemoff 12127 itemsize 53
[12210.590991]         extent refs 1 gen 157657 flags 1
[12210.590992]         extent data backref root 261 objectid 8947
offset 1048576 count 1
[12210.590994]     item 92 key (644895031296 168 20480) itemoff 12090
itemsize 37
[12210.590995]         extent refs 1 gen 177519 flags 1
[12210.590996]         shared data backref parent 33211444396032 count 1
[12210.590998]     item 93 key (644895051776 168 12288) itemoff 12053
itemsize 37
[12210.590999]         extent refs 1 gen 158918 flags 1
[12210.591000]         shared data backref parent 33195740479488 count 1
[12210.591001]     item 94 key (644895064064 168 16384) itemoff 12016
itemsize 37
[12210.591003]         extent refs 1 gen 161013 flags 1
[12210.591004]         shared data backref parent 33205199011840 count 1
[12210.591005]     item 95 key (644895080448 168 49152) itemoff 11979
itemsize 37
[12210.591006]         extent refs 1 gen 157848 flags 1
[12210.591007]         shared data backref parent 33201455628288 count 1
[12210.591009]     item 96 key (644895129600 168 4096) itemoff 11942 itemsize 37
[12210.591010]         extent refs 1 gen 158007 flags 1
[12210.591011]         shared data backref parent 33213106388992 count 1
[12210.591013]     item 97 key (644895133696 168 12288) itemoff 11889
itemsize 53
[12210.591014]         extent refs 1 gen 318024 flags 1
[12210.591015]         extent data backref root 2043 objectid 3587593
offset 2490368 count 1
[12210.591017]     item 98 key (644895145984 168 8192) itemoff 11836 itemsize 53
[12210.591018]         extent refs 1 gen 318018 flags 1
[12210.591019]         extent data backref root 2043 objectid 3587362
offset 786432 count 1
[12210.591021]     item 99 key (644895154176 168 4096) itemoff 11783 itemsize 53
[12210.591022]         extent refs 1 gen 318773 flags 1
[12210.591023]         extent data backref root 2043 objectid 3605775
offset 0 count 1
[12210.591025]     item 100 key (644895158272 168 8192) itemoff 11746
itemsize 37
[12210.591026]         extent refs 1 gen 164108 flags 1
[12210.591027]         shared data backref parent 33213192716288 count 1
[12210.591029]     item 101 key (644895166464 168 12288) itemoff 11709
itemsize 37
[12210.591030]         extent refs 1 gen 161013 flags 1
[12210.591031]         shared data backref parent 33217003601920 count 1
[12210.591032]     item 102 key (644895178752 168 16384) itemoff 11656
itemsize 53
[12210.591034]         extent refs 1 gen 318024 flags 1
[12210.591035]         extent data backref root 2043 objectid 3587556
offset 786432 count 1
[12210.591037]     item 103 key (644895195136 168 4096) itemoff 11603
itemsize 53
[12210.591038]         extent refs 1 gen 318773 flags 1
[12210.591039]         extent data backref root 2043 objectid 3605776
offset 0 count 1
[12210.591041]     item 104 key (644895199232 168 4096) itemoff 11566
itemsize 37
[12210.591042]         extent refs 1 gen 161014 flags 1
[12210.591043]         shared data backref parent 33196744884224 count 1
[12210.591044]     item 105 key (644895203328 168 4096) itemoff 11529
itemsize 37
[12210.591045]         extent refs 1 gen 158007 flags 1
[12210.591046]         shared data backref parent 33213106388992 count 1
[12210.591048]     item 106 key (644895207424 168 4096) itemoff 11492
itemsize 37
[12210.591049]         extent refs 1 gen 158007 flags 1
[12210.591050]         shared data backref parent 33213106388992 count 1
[12210.591052]     item 107 key (644895211520 168 114688) itemoff
11455 itemsize 37
[12210.591053]         extent refs 1 gen 149614 flags 1
[12210.591054]         shared data backref parent 33208149901312 count 1
[12210.591056]     item 108 key (644895326208 168 106496) itemoff
11418 itemsize 37
[12210.591057]         extent refs 1 gen 149614 flags 1
[12210.591058]         shared data backref parent 33208149901312 count 1
[12210.591059]     item 109 key (644895432704 168 114688) itemoff
11381 itemsize 37
[12210.591060]         extent refs 1 gen 149614 flags 1
[12210.591061]         shared data backref parent 33208149901312 count 1
[12210.591063]     item 110 key (644895547392 168 114688) itemoff
11344 itemsize 37
[12210.591064]         extent refs 1 gen 149614 flags 1
[12210.591065]         shared data backref parent 33208149901312 count 1
[12210.591067]     item 111 key (644895662080 168 73728) itemoff 11307
itemsize 37
[12210.591068]         extent refs 1 gen 149615 flags 1
[12210.591069]         shared data backref parent 33202781601792 count 1
[12210.591070]     item 112 key (644895735808 168 73728) itemoff 11270
itemsize 37
[12210.591071]         extent refs 1 gen 149515 flags 1
[12210.591073]         shared data backref parent 33195666014208 count 1
[12210.591074]     item 113 key (644895809536 168 94208) itemoff 11233
itemsize 37
[12210.591075]         extent refs 1 gen 149515 flags 1
[12210.591076]         shared data backref parent 33195666014208 count 1
[12210.591078]     item 114 key (644895903744 168 49152) itemoff 11196
itemsize 37
[12210.591079]         extent refs 1 gen 149515 flags 1
[12210.591080]         shared data backref parent 33195666014208 count 1
[12210.591082]     item 115 key (644895952896 168 20480) itemoff 11159
itemsize 37
[12210.591083]         extent refs 1 gen 149515 flags 1
[12210.591084]         shared data backref parent 33195666014208 count 1
[12210.591085]     item 116 key (644895973376 168 12288) itemoff 11122
itemsize 37
[12210.591086]         extent refs 1 gen 149515 flags 1
[12210.591087]         shared data backref parent 33196922617856 count 1
[12210.591089]     item 117 key (644895985664 168 32768) itemoff 11085
itemsize 37
[12210.591090]         extent refs 1 gen 146328 flags 1
[12210.591091]         shared data backref parent 33194962583552 count 1
[12210.591093]     item 118 key (644896018432 168 4096) itemoff 11048
itemsize 37
[12210.591094]         extent refs 1 gen 124939 flags 1
[12210.591095]         shared data backref parent 33199603023872 count 1
[12210.591096]     item 119 key (644896022528 168 81920) itemoff 11011
itemsize 37
[12210.591097]         extent refs 1 gen 120670 flags 1
[12210.591099]         shared data backref parent 33201905958912 count 1
[12210.591100]     item 120 key (644896104448 168 8192) itemoff 10974
itemsize 37
[12210.591101]         extent refs 1 gen 144006 flags 1
[12210.591102]         shared data backref parent 33199321595904 count 1
[12210.591104]     item 121 key (644896112640 168 94208) itemoff 10937
itemsize 37
[12210.591105]         extent refs 1 gen 120651 flags 1
[12210.591106]         shared data backref parent 33205847834624 count 1
[12210.591107]     item 122 key (644896206848 168 32768) itemoff 10900
itemsize 37
[12210.591109]         extent refs 1 gen 146323 flags 1
[12210.591110]         shared data backref parent 33208303632384 count 1
[12210.591111]     item 123 key (644896239616 168 12288) itemoff 10863
itemsize 37
[12210.591112]         extent refs 1 gen 144001 flags 1
[12210.591113]         shared data backref parent 33200064708608 count 1
[12210.591115]     item 124 key (644896251904 168 4096) itemoff 10810
itemsize 53
[12210.591116]         extent refs 1 gen 306130 flags 1
[12210.591117]         extent data backref root 2043 objectid 3268377
offset 0 count 1
[12210.591119]     item 125 key (644896256000 168 4096) itemoff 10773
itemsize 37
[12210.591120]         extent refs 1 gen 177562 flags 1
[12210.591121]         shared data backref parent 33205374795776 count 1
[12210.591123]     item 126 key (644896260096 168 86016) itemoff 10736
itemsize 37
[12210.591124]         extent refs 1 gen 150959 flags 1
[12210.591125]         shared data backref parent 33208537677824 count 1
[12210.591126]     item 127 key (644896346112 168 122880) itemoff
10699 itemsize 37
[12210.591128]         extent refs 1 gen 150959 flags 1
[12210.591129]         shared data backref parent 33208537677824 count 1
[12210.591130]     item 128 key (644896468992 168 36864) itemoff 10662
itemsize 37
[12210.591131]         extent refs 1 gen 150959 flags 1
[12210.591132]         shared data backref parent 33195330076672 count 1
[12210.591134]     item 129 key (644896505856 168 16384) itemoff 10625
itemsize 37
[12210.591135]         extent refs 1 gen 150960 flags 1
[12210.591136]         shared data backref parent 33196660031488 count 1
[12210.591137]     item 130 key (644896522240 168 90112) itemoff 10588
itemsize 37
[12210.591139]         extent refs 1 gen 150951 flags 1
[12210.591140]         shared data backref parent 33211452473344 count 1
[12210.591141]     item 131 key (644896612352 168 32768) itemoff 10551
itemsize 37
[12210.591142]         extent refs 1 gen 150951 flags 1
[12210.591143]         shared data backref parent 33206214934528 count 1
[12210.591145]     item 132 key (644896645120 168 24576) itemoff 10514
itemsize 37
[12210.591146]         extent refs 1 gen 150951 flags 1
[12210.591147]         shared data backref parent 33206214934528 count 1
[12210.591148]     item 133 key (644896669696 168 20480) itemoff 10477
itemsize 37
[12210.591150]         extent refs 1 gen 150951 flags 1
[12210.591151]         shared data backref parent 33206214934528 count 1
[12210.591152]     item 134 key (644896690176 168 36864) itemoff 10440
itemsize 37
[12210.591153]         extent refs 1 gen 150951 flags 1
[12210.591154]         shared data backref parent 33206214934528 count 1
[12210.591156]     item 135 key (644896727040 168 24576) itemoff 10403
itemsize 37
[12210.591157]         extent refs 1 gen 150951 flags 1
[12210.591158]         shared data backref parent 33206214934528 count 1
[12210.591159]     item 136 key (644896751616 168 24576) itemoff 10366
itemsize 37
[12210.591161]         extent refs 1 gen 150951 flags 1
[12210.591162]         shared data backref parent 33206214934528 count 1
[12210.591163]     item 137 key (644896776192 168 4096) itemoff 10329
itemsize 37
[12210.591164]         extent refs 1 gen 150951 flags 1
[12210.591165]         shared data backref parent 33206214934528 count 1
[12210.591167]     item 138 key (644896780288 168 4096) itemoff 10292
itemsize 37
[12210.591168]         extent refs 1 gen 150974 flags 1
[12210.591169]         shared data backref parent 33202660229120 count 1
[12210.591171]     item 139 key (644896784384 168 65536) itemoff 10255
itemsize 37
[12210.591172]         extent refs 1 gen 149517 flags 1
[12210.591173]         shared data backref parent 33205604614144 count 1
[12210.591174]     item 140 key (644896849920 168 98304) itemoff 10218
itemsize 37
[12210.591175]         extent refs 1 gen 149517 flags 1
[12210.591176]         shared data backref parent 33205604614144 count 1
[12210.591178]     item 141 key (644896948224 168 90112) itemoff 10181
itemsize 37
[12210.591179]         extent refs 1 gen 149517 flags 1
[12210.591180]         shared data backref parent 33205604614144 count 1
[12210.591182]     item 142 key (644897038336 168 8192) itemoff 10144
itemsize 37
[12210.591183]         extent refs 1 gen 149517 flags 1
[12210.591184]         shared data backref parent 33205228044288 count 1
[12210.591185]     item 143 key (644897046528 168 36864) itemoff 10107
itemsize 37
[12210.591187]         extent refs 1 gen 164136 flags 1
[12210.591188]         shared data backref parent 33204544438272 count 1
[12210.591189]     item 144 key (644897083392 168 57344) itemoff 10070
itemsize 37
[12210.591190]         extent refs 1 gen 164136 flags 1
[12210.591191]         shared data backref parent 33204544438272 count 1
[12210.591193]     item 145 key (644897140736 168 53248) itemoff 10033
itemsize 37
[12210.591194]         extent refs 1 gen 164136 flags 1
[12210.591195]         shared data backref parent 33204544438272 count 1
[12210.591196]     item 146 key (644897193984 168 65536) itemoff 9996
itemsize 37
[12210.591198]         extent refs 1 gen 164136 flags 1
[12210.591199]         shared data backref parent 33204544438272 count 1
[12210.591200]     item 147 key (644897259520 168 49152) itemoff 9959
itemsize 37
[12210.591201]         extent refs 1 gen 164136 flags 1
[12210.591202]         shared data backref parent 33204544438272 count 1
[12210.591204]     item 148 key (644897308672 168 110592) itemoff 9922
itemsize 37
[12210.591205]         extent refs 1 gen 149614 flags 1
[12210.591206]         shared data backref parent 33208149901312 count 1
[12210.591208]     item 149 key (644897419264 168 102400) itemoff 9885
itemsize 37
[12210.591209]         extent refs 1 gen 149614 flags 1
[12210.591210]         shared data backref parent 33208149901312 count 1
[12210.591211]     item 150 key (644897521664 168 45056) itemoff 9848
itemsize 37
[12210.591212]         extent refs 1 gen 149616 flags 1
[12210.591213]         shared data backref parent 33209313492992 count 1
[12210.591215]     item 151 key (644897566720 168 114688) itemoff 9811
itemsize 37
[12210.591216]         extent refs 1 gen 149626 flags 1
[12210.591217]         shared data backref parent 33212912517120 count 1
[12210.591219]     item 152 key (644897681408 168 122880) itemoff 9774
itemsize 37
[12210.591220]         extent refs 1 gen 149626 flags 1
[12210.591221]         shared data backref parent 33212912517120 count 1
[12210.591222]     item 153 key (644897804288 168 16384) itemoff 9737
itemsize 37
[12210.591223]         extent refs 1 gen 149626 flags 1
[12210.591224]         shared data backref parent 33212298248192 count 1
[12210.591226]     item 154 key (644897820672 168 12288) itemoff 9700
itemsize 37
[12210.591227]         extent refs 1 gen 149628 flags 1
[12210.591228]         shared data backref parent 33203505070080 count 1
[12210.591230]     item 155 key (644897832960 168 110592) itemoff 9663
itemsize 37
[12210.591231]         extent refs 1 gen 149614 flags 1
[12210.591232]         shared data backref parent 33208149901312 count 1
[12210.591233]     item 156 key (644897943552 168 106496) itemoff 9626
itemsize 37
[12210.591234]         extent refs 1 gen 149614 flags 1
[12210.591235]         shared data backref parent 33208149901312 count 1
[12210.591237]     item 157 key (644898050048 168 32768) itemoff 9589
itemsize 37
[12210.591238]         extent refs 1 gen 149617 flags 1
[12210.591239]         shared data backref parent 33202781601792 count 1
[12210.591241]     item 158 key (644898082816 168 12288) itemoff 9552
itemsize 37
[12210.591242]         extent refs 1 gen 149624 flags 1
[12210.591243]         shared data backref parent 33212743974912 count 1
[12210.591244]     item 159 key (644898095104 168 65536) itemoff 9515
itemsize 37
[12210.591246]         extent refs 1 gen 164136 flags 1
[12210.591247]         shared data backref parent 33204544438272 count 1
[12210.591248]     item 160 key (644898160640 168 65536) itemoff 9478
itemsize 37
[12210.591249]         extent refs 1 gen 164136 flags 1
[12210.591251]         shared data backref parent 33204544438272 count 1
[12210.591252]     item 161 key (644898226176 168 69632) itemoff 9441
itemsize 37
[12210.591253]         extent refs 1 gen 164136 flags 1
[12210.591254]         shared data backref parent 33204544438272 count 1
[12210.591256]     item 162 key (644898295808 168 61440) itemoff 9404
itemsize 37
[12210.591257]         extent refs 1 gen 164136 flags 1
[12210.591258]         shared data backref parent 33204544438272 count 1
[12210.591260]     item 163 key (644898357248 168 94208) itemoff 9367
itemsize 37
[12210.591261]         extent refs 1 gen 149517 flags 1
[12210.591262]         shared data backref parent 33211503411200 count 1
[12210.591263]     item 164 key (644898451456 168 98304) itemoff 9330
itemsize 37
[12210.591264]         extent refs 1 gen 149517 flags 1
[12210.591265]         shared data backref parent 33211503411200 count 1
[12210.591267]     item 165 key (644898549760 168 61440) itemoff 9293
itemsize 37
[12210.591268]         extent refs 1 gen 149517 flags 1
[12210.591269]         shared data backref parent 33211503411200 count 1
[12210.591271]     item 166 key (644898611200 168 8192) itemoff 9256 itemsize 37
[12210.591272]         extent refs 1 gen 149517 flags 1
[12210.591273]         shared data backref parent 33208201789440 count 1
[12210.591274]     item 167 key (644898619392 168 110592) itemoff 9219
itemsize 37
[12210.591275]         extent refs 1 gen 149614 flags 1
[12210.591276]         shared data backref parent 33208149901312 count 1
[12210.591278]     item 168 key (644898729984 168 110592) itemoff 9182
itemsize 37
[12210.591279]         extent refs 1 gen 149614 flags 1
[12210.591280]         shared data backref parent 33208149901312 count 1
[12210.591282]     item 169 key (644898840576 168 110592) itemoff 9145
itemsize 37
[12210.591283]         extent refs 1 gen 149614 flags 1
[12210.591284]         shared data backref parent 33208149901312 count 1
[12210.591285]     item 170 key (644898951168 168 110592) itemoff 9108
itemsize 37
[12210.591286]         extent refs 1 gen 149614 flags 1
[12210.591287]         shared data backref parent 33208149901312 count 1
[12210.591289]     item 171 key (644899061760 168 65536) itemoff 9071
itemsize 37
[12210.591290]         extent refs 1 gen 149615 flags 1
[12210.591291]         shared data backref parent 33202781601792 count 1
[12210.591293]     item 172 key (644899127296 168 81920) itemoff 9034
itemsize 37
[12210.591294]         extent refs 1 gen 149624 flags 1
[12210.591295]         shared data backref parent 33202024169472 count 1
[12210.591296]     item 173 key (644899209216 168 77824) itemoff 8997
itemsize 37
[12210.591297]         extent refs 1 gen 149624 flags 1
[12210.591298]         shared data backref parent 33202024169472 count 1
[12210.591300]     item 174 key (644899287040 168 69632) itemoff 8960
itemsize 37
[12210.591301]         extent refs 1 gen 149624 flags 1
[12210.591302]         shared data backref parent 33202024169472 count 1
[12210.591304]     item 175 key (644899356672 168 45056) itemoff 8923
itemsize 37
[12210.591305]         extent refs 1 gen 149624 flags 1
[12210.591306]         shared data backref parent 33202024169472 count 1
[12210.591307]     item 176 key (644899401728 168 4096) itemoff 8886 itemsize 37
[12210.591309]         extent refs 1 gen 149630 flags 1
[12210.591310]         shared data backref parent 33212298248192 count 1
[12210.591311]     item 177 key (644899405824 168 114688) itemoff 8849
itemsize 37
[12210.591312]         extent refs 1 gen 149614 flags 1
[12210.591313]         shared data backref parent 33208149901312 count 1
[12210.591315]     item 178 key (644899520512 168 110592) itemoff 8812
itemsize 37
[12210.591316]         extent refs 1 gen 149614 flags 1
[12210.591317]         shared data backref parent 33208149901312 count 1
[12210.591319]     item 179 key (644899631104 168 32768) itemoff 8775
itemsize 37
[12210.591320]         extent refs 1 gen 149617 flags 1
[12210.591321]         shared data backref parent 33202199412736 count 1
[12210.591322]     item 180 key (644899663872 168 4096) itemoff 8722 itemsize 53
[12210.591323]         extent refs 1 gen 318773 flags 1
[12210.591325]         extent data backref root 2043 objectid 3605777
offset 0 count 1
[12210.591326]     item 181 key (644899667968 168 45056) itemoff 8685
itemsize 37
[12210.591328]         extent refs 1 gen 154417 flags 1
[12210.591329]         shared data backref parent 33196898254848 count 1
[12210.591330]     item 182 key (644899713024 168 24576) itemoff 8648
itemsize 37
[12210.591331]         extent refs 1 gen 154429 flags 1
[12210.591332]         shared data backref parent 33201605591040 count 1
[12210.591334]     item 183 key (644899737600 168 4096) itemoff 8611 itemsize 37
[12210.591335]         extent refs 1 gen 154430 flags 1
[12210.591336]         shared data backref parent 33215576932352 count 1
[12210.591338]     item 184 key (644899741696 168 8192) itemoff 8574 itemsize 37
[12210.591339]         extent refs 1 gen 161013 flags 1
[12210.591340]         shared data backref parent 33210444234752 count 1
[12210.591341]     item 185 key (644899749888 168 4096) itemoff 8537 itemsize 37
[12210.591342]         extent refs 1 gen 153448 flags 1
[12210.591343]         shared data backref parent 33199426813952 count 1
[12210.591345]     item 186 key (644899753984 168 4096) itemoff 8484 itemsize 53
[12210.591346]         extent refs 1 gen 325503 flags 1
[12210.591347]         extent data backref root 2043 objectid 3640397
offset 0 count 1
[12210.591349]     item 187 key (644899758080 168 8192) itemoff 8447 itemsize 37
[12210.591350]         extent refs 1 gen 153448 flags 1
[12210.591351]         shared data backref parent 33210303414272 count 1
[12210.591353]     item 188 key (644899766272 168 8192) itemoff 8410 itemsize 37
[12210.591354]         extent refs 1 gen 153448 flags 1
[12210.591355]         shared data backref parent 33211417608192 count 1
[12210.591356]     item 189 key (644899774464 168 12288) itemoff 8357
itemsize 53
[12210.591357]         extent refs 1 gen 318756 flags 1
[12210.591359]         extent data backref root 2043 objectid 3605445
offset 1048576 count 1
[12210.591360]     item 190 key (644899786752 168 4096) itemoff 8320 itemsize 37
[12210.591362]         extent refs 1 gen 153448 flags 1
[12210.591363]         shared data backref parent 33199426813952 count 1
[12210.591364]     item 191 key (644899790848 168 28672) itemoff 8267
itemsize 53
[12210.591365]         extent refs 1 gen 152942 flags 1
[12210.591367]         extent data backref root 261 objectid 8922
offset 0 count 1
[12210.591368]     item 192 key (644899819520 168 49152) itemoff 8214
itemsize 53
[12210.591369]         extent refs 1 gen 318017 flags 1
[12210.591371]         extent data backref root 2043 objectid 3587330
offset 131072 count 1
[12210.591372]     item 193 key (644899868672 168 32768) itemoff 8161
itemsize 53
[12210.591373]         extent refs 1 gen 318017 flags 1
[12210.591375]         extent data backref root 2043 objectid 3587330
offset 262144 count 1
[12210.591376]     item 194 key (644899901440 168 28672) itemoff 8108
itemsize 53
[12210.591377]         extent refs 1 gen 318018 flags 1
[12210.591379]         extent data backref root 2043 objectid 3587362
offset 524288 count 1
[12210.591380]     item 195 key (644899930112 168 94208) itemoff 8071
itemsize 37
[12210.591382]         extent refs 1 gen 149618 flags 1
[12210.591383]         shared data backref parent 33202199412736 count 1
[12210.591384]     item 196 key (644900024320 168 102400) itemoff 8034
itemsize 37
[12210.591385]         extent refs 1 gen 149618 flags 1
[12210.591386]         shared data backref parent 33202199412736 count 1
[12210.591388]     item 197 key (644900126720 168 53248) itemoff 7997
itemsize 37
[12210.591389]         extent refs 1 gen 149618 flags 1
[12210.591390]         shared data backref parent 33209313492992 count 1
[12210.591392]     item 198 key (644900179968 168 12288) itemoff 7960
itemsize 37
[12210.591393]         extent refs 1 gen 149628 flags 1
[12210.591394]         shared data backref parent 33203505070080 count 1
[12210.591395]     item 199 key (644900192256 168 77824) itemoff 7923
itemsize 37
[12210.591396]         extent refs 1 gen 150949 flags 1
[12210.591397]         shared data backref parent 33212656697344 count 1
[12210.591399]     item 200 key (644900270080 168 106496) itemoff 7886
itemsize 37
[12210.591400]         extent refs 1 gen 150949 flags 1
[12210.591401]         shared data backref parent 33212656697344 count 1
[12210.591403]     item 201 key (644900376576 168 73728) itemoff 7849
itemsize 37
[12210.591404]         extent refs 1 gen 150949 flags 1
[12210.591405]         shared data backref parent 33212656697344 count 1
[12210.591406]     item 202 key (644900450304 168 4096) itemoff 7812 itemsize 37
[12210.591408]         extent refs 1 gen 150974 flags 1
[12210.591409]         shared data backref parent 33202660229120 count 1
[12210.591410]     item 203 key (644900454400 168 73728) itemoff 7775
itemsize 37
[12210.591411]         extent refs 1 gen 164136 flags 1
[12210.591412]         shared data backref parent 33204544438272 count 1
[12210.591414]     item 204 key (644900528128 168 65536) itemoff 7738
itemsize 37
[12210.591415]         extent refs 1 gen 164136 flags 1
[12210.591416]         shared data backref parent 33204544438272 count 1
[12210.591418]     item 205 key (644900593664 168 65536) itemoff 7701
itemsize 37
[12210.591419]         extent refs 1 gen 164136 flags 1
[12210.591420]         shared data backref parent 33204544438272 count 1
[12210.591421]     item 206 key (644900659200 168 53248) itemoff 7664
itemsize 37
[12210.591422]         extent refs 1 gen 164136 flags 1
[12210.591423]         shared data backref parent 33204544438272 count 1
[12210.591425]     item 207 key (644900712448 168 4096) itemoff 7611 itemsize 53
[12210.591426]         extent refs 1 gen 318773 flags 1
[12210.591427]         extent data backref root 2043 objectid 3605779
offset 0 count 1
[12210.591429]     item 208 key (644900716544 168 110592) itemoff 7574
itemsize 37
[12210.591430]         extent refs 1 gen 149616 flags 1
[12210.591431]         shared data backref parent 33208149901312 count 1
[12210.591433]     item 209 key (644900827136 168 114688) itemoff 7537
itemsize 37
[12210.591434]         extent refs 1 gen 149616 flags 1
[12210.591435]         shared data backref parent 33208149901312 count 1
[12210.591436]     item 210 key (644900941824 168 36864) itemoff 7500
itemsize 37
[12210.591438]         extent refs 1 gen 149618 flags 1
[12210.591439]         shared data backref parent 33202199412736 count 1
[12210.591440]     item 211 key (644900978688 168 94208) itemoff 7463
itemsize 37
[12210.591441]         extent refs 1 gen 149517 flags 1
[12210.591442]         shared data backref parent 33211503411200 count 1
[12210.591444]     item 212 key (644901072896 168 73728) itemoff 7426
itemsize 37
[12210.591445]         extent refs 1 gen 149517 flags 1
[12210.591446]         shared data backref parent 33211503411200 count 1
[12210.591448] BTRFS error (device sdo): unable to find ref byte nr
644894945280 parent 0 root 2043  owner 3640378 offset 0
[12210.591452] ------------[ cut here ]------------
[12210.591466] WARNING: CPU: 4 PID: 3375 at
/mnt/linux/fs/btrfs/extent-tree.c:6951
__btrfs_free_extent.isra.33+0x995/0xca0 [btrfs]
[12210.591467] BTRFS: Transaction aborted (error -2)
[12210.591467] Modules linked in: fuse input_leds led_class
snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device mousedev
joydev hid_generic usbhid hid xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter
xt_tcpudp ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink
ebtable_broute ebtable_nat ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw ip6table_security
ip6table_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_security
iptable_mangle ebtable_filter ebtables bridge ip6table_filter
ip6_tables stp iptable_filter llc it87 hwmon_vid kvm_amd kvm
saa7134_alsa irqbypass snd_hda_codec_realtek snd_hda_codec_generic
crct10dif_pclmul
[12210.591502]  snd_hda_codec_hdmi saa7134 crc32_pclmul tveeprom
rc_core ghash_clmulni_intel snd_hda_intel v4l2_common snd_hda_codec
aesni_intel videobuf2_dma_sg aes_x86_64 snd_hda_core videobuf2_memops
videobuf2_v4l2 lrw videobuf2_core gf128mul snd_hwdep videodev r8169
glue_helper evdev snd_pcm media ablk_helper cryptd mac_hid pcspkr
k10temp fam15h_power mxm_wmi snd_timer mii snd sp5100_tco soundcore
i2c_piix4 acpi_cpufreq tpm_infineon tpm_tis tpm_tis_core shpchp tpm
button wmi nfsd auth_rpcgss oid_registry nfs_acl sch_fq_codel lockd
grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq sd_mod
ata_generic pata_acpi ohci_pci serio_raw atkbd libps2 nvidia_drm(PO)
nvidia_modeset(PO) nvidia(PO) firewire_ohci xhci_pci firewire_core
ohci_hcd
[12210.591543]  ehci_pci xhci_hcd crc_itu_t ehci_hcd drm pata_atiixp
usbcore ahci libahci usb_common i2c_core i8042 serio mvsas libsas
scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel vfat
fat ip_tables x_tables
[12210.591558] CPU: 4 PID: 3375 Comm: kworker/u16:0 Tainted: P
W  O    4.8.0-ARCH-dirty #1
[12210.591559] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[12210.591575] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[12210.591577]  0000000000000286 00000000463ac1f2 ffff8805bb097a88
ffffffff812e9bb0
[12210.591580]  ffff8805bb097ad8 0000000000000000 ffff8805bb097ac8
ffffffff8107bcab
[12210.591584]  00001b2700378c3a 0000009626bbf000 00000000fffffffe
ffff88061216ec80
[12210.591586] Call Trace:
[12210.591589]  [<ffffffff812e9bb0>] dump_stack+0x63/0x83
[12210.591591]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[12210.591594]  [<ffffffff8107bd2f>] warn_slowpath_fmt+0x5f/0x80
[12210.591608]  [<ffffffffa10a0145>]
__btrfs_free_extent.isra.33+0x995/0xca0 [btrfs]
[12210.591622]  [<ffffffffa10a43b0>]
__btrfs_run_delayed_refs+0x5b0/0x12e0 [btrfs]
[12210.591625]  [<ffffffff811d7570>] ? kmem_cache_free+0x1e0/0x210
[12210.591627]  [<ffffffff810c7546>] ? cpuacct_charge+0x86/0xa0
[12210.591645]  [<ffffffffa10e1a42>] ?
end_bio_extent_readpage+0x222/0x5f0 [btrfs]
[12210.591659]  [<ffffffffa10a81a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[12210.591674]  [<ffffffffa10a8434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[12210.591690]  [<ffffffffa10f3d5d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[12210.591707]  [<ffffffffa10f405e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[12210.591710]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[12210.591712]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[12210.591714]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[12210.591717]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[12210.591719]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[12210.591721]  [<ffffffff815cb1ff>] ret_from_fork+0x1f/0x40
[12210.591724]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[12210.591726] ---[ end trace 293673cf94b7856b ]---
[12210.591728] BTRFS: error (device sdo) in __btrfs_free_extent:6951:
errno=-2 No such entry
[12210.591731] BTRFS info (device sdo): forced readonly
[12210.591734] BTRFS: error (device sdo) in
btrfs_run_delayed_refs:2960: errno=-2 No such entry
[12210.927914] pending csums is 5124096




Label: 'Data'  uuid: 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
        Total devices 6 FS bytes used 11.50TiB
        devid    1 size 2.73TiB used 2.68TiB path /dev/sdc
        devid    3 size 1.82TiB used 1.77TiB path /dev/sde
        devid    4 size 1.82TiB used 1.77TiB path /dev/sdg
        devid    5 size 931.51GiB used 882.00GiB path /dev/sdh
        devid    6 size 1.82TiB used 1.77TiB path /dev/sdd
        devid    7 size 2.73TiB used 2.68TiB path /dev/sdo


Overall:
    Device size:                  11.83TiB
    Device allocated:             11.54TiB
    Device unallocated:          296.54GiB
    Device missing:                  0.00B
    Used:                         11.53TiB
    Free (estimated):            302.89GiB      (min: 154.62GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:11.49TiB, Used:11.48TiB
   /dev/sdc        2.68TiB
   /dev/sdd        1.75TiB
   /dev/sde        1.77TiB
   /dev/sdg        1.77TiB
   /dev/sdh      882.00GiB
   /dev/sdo        2.66TiB

Metadata,RAID1: Size:25.00GiB, Used:23.44GiB
   /dev/sdc        1.00GiB
   /dev/sdd       24.00GiB
   /dev/sde        2.00GiB
   /dev/sdo       23.00GiB

System,RAID1: Size:32.00MiB, Used:1.44MiB
   /dev/sdd       32.00MiB
   /dev/sdo       32.00MiB

Unallocated:
   /dev/sdc       49.52GiB
   /dev/sdd       49.99GiB
   /dev/sde       49.02GiB
   /dev/sdg       49.02GiB
   /dev/sdh       49.51GiB
   /dev/sdo       49.49GiB
