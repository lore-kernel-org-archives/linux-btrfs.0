Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35887 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753647AbcK1C36 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Nov 2016 21:29:58 -0500
Received: by mail-io0-f176.google.com with SMTP id m5so69692895ioe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Nov 2016 18:29:57 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Mon, 28 Nov 2016 04:29:55 +0200
Message-ID: <CAOE4rSyn8dZVmFFOtFfnb09QjDT5goJnUvgW7tmM9_aaVvgsgA@mail.gmail.com>
Subject: Re: WARNING at extent-tree.c:6945 __btrfs_free_extent.isra.33+0x7d6/0xca0
 (Linux 4.8.0)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-10-19 14:16 GMT+03:00 Dāvis Mosāns <davispuh@gmail.com>:
>
> Basically on multi-disk btrfs partition few sectors on one HDD became
> unreadable and when trying to delete one folder on that filesystem I
> got this in log
>
[...]

dmesg now on 4.8.11

[ 3825.603883] WARNING: CPU: 5 PID: 15736 at
/mnt/linux/fs/btrfs/extent-tree.c:6945
__btrfs_free_extent.isra.33+0x7d6/0xca0 [btrfs]
[ 3825.603885] Modules linked in: arc4 md4 hmac nls_utf8 cifs
dns_resolver fscache nls_iso8859_4 nls_cp775 xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun cfg80211 rfkill
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_tcpudp xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ip_set nfnetlink ebtable_broute ebtable_nat
ip6table_security ip6table_raw ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle iptable_security
iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle bridge ebtable_filter ebtables stp
llc ip6table_filter ip6_tables iptable_filter it87 hwmon_vid
saa7134_alsa kvm_amd kvm saa7134 snd_hda_codec_hdmi irqbypass
snd_hda_codec_realtek tveeprom snd_hda_codec_generic crct10dif_pclmul
[ 3825.603935]  crc32_pclmul rc_core ghash_clmulni_intel snd_hda_intel
aesni_intel snd_hda_codec v4l2_common videobuf2_dma_sg aes_x86_64 lrw
gf128mul evdev snd_hda_core videobuf2_memops glue_helper
videobuf2_v4l2 mac_hid videobuf2_core mxm_wmi videodev r8169
ablk_helper snd_hwdep snd_pcm cryptd pcspkr media fam15h_power mii
k10temp snd_timer sp5100_tco snd tpm_infineon acpi_cpufreq button
tpm_tis tpm_tis_core wmi i2c_piix4 tpm i2c_core shpchp soundcore nfsd
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc sch_fq_codel btrfs
xor zlib_deflate raid6_pq sd_mod ata_generic pata_acpi ohci_pci
serio_raw atkbd libps2 firewire_ohci firewire_core crc_itu_t xhci_pci
xhci_hcd pata_atiixp ohci_hcd ehci_pci ehci_hcd usbcore ahci libahci
usb_common i8042 serio mvsas libsas scsi_transport_sas libata scsi_mod
crc32c_generic
[ 3825.603990]  crc32c_intel vfat fat ip_tables x_tables
[ 3825.603996] CPU: 5 PID: 15736 Comm: kworker/u16:0 Not tainted
4.8.11-ARCH-dirty #1
[ 3825.603997] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 3825.604016] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 3825.604018]  0000000000000286 00000000e1e4b79b ffff8804dc05fae0
ffffffff812e9a00
[ 3825.604021]  0000000000000000 0000000000000000 ffff8804dc05fb20
ffffffff8107bcab
[ 3825.604025]  00001b219626bc00 0000009626bbf000 00000000fffffffe
ffff88060af40140
[ 3825.604028] Call Trace:
[ 3825.604033]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[ 3825.604036]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[ 3825.604039]  [<ffffffff8107bddd>] warn_slowpath_null+0x1d/0x20
[ 3825.604053]  [<ffffffffa02e9f86>]
__btrfs_free_extent.isra.33+0x7d6/0xca0 [btrfs]
[ 3825.604072]  [<ffffffffa035adef>] ? find_ref_head+0x6f/0x80 [btrfs]
[ 3825.604090]  [<ffffffffa02ee3b0>]
__btrfs_run_delayed_refs+0x5b0/0x12e0 [btrfs]
[ 3825.604109]  [<ffffffffa02f21a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[ 3825.604127]  [<ffffffffa02f2434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[ 3825.604148]  [<ffffffffa033de9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 3825.604169]  [<ffffffffa033e19e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[ 3825.604172]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 3825.604176]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 3825.604179]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3825.604181]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3825.604185]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 3825.604188]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 3825.604192]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 3825.604195]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 3825.604197] ---[ end trace b9ac501b3586974e ]---
[ 3825.604201] BTRFS info (device sdd): leaf 33197477511168 total ptrs
213 free space 2101
[ 3825.604204]     item 0 key (644872798208 168 524288) itemoff 16230
itemsize 53
[ 3825.604206]         extent refs 1 gen 215 flags 1
[ 3825.604208]         extent data backref root 261 objectid 783
offset 41418752 count 1
[ 3825.604210]     item 1 key (644873322496 168 524288) itemoff 16177
itemsize 53
[ 3825.604212]         extent refs 1 gen 215 flags 1
[ 3825.604213]         extent data backref root 261 objectid 783
offset 41943040 count 1
[ 3825.604216]     item 2 key (644873846784 168 524288) itemoff 16124
itemsize 53
[ 3825.604217]         extent refs 1 gen 215 flags 1
[ 3825.604219]         extent data backref root 261 objectid 783
offset 42467328 count 1
[ 3825.604221]     item 3 key (644874371072 168 524288) itemoff 16071
itemsize 53
[ 3825.604222]         extent refs 1 gen 215 flags 1
[ 3825.604223]         extent data backref root 261 objectid 783
offset 42991616 count 1
[ 3825.604225]     item 4 key (644874895360 168 524288) itemoff 16018
itemsize 53
[ 3825.604227]         extent refs 1 gen 215 flags 1
[ 3825.604229]         extent data backref root 261 objectid 783
offset 43515904 count 1
[ 3825.604230]     item 5 key (644875419648 168 524288) itemoff 15965
itemsize 53
[ 3825.604232]         extent refs 1 gen 215 flags 1
[ 3825.604233]         extent data backref root 261 objectid 783
offset 44040192 count 1
[ 3825.604235]     item 6 key (644875943936 168 524288) itemoff 15912
itemsize 53
[ 3825.604237]         extent refs 1 gen 215 flags 1
[ 3825.604238]         extent data backref root 261 objectid 783
offset 44564480 count 1
[ 3825.604241]     item 7 key (644876468224 168 524288) itemoff 15859
itemsize 53
[ 3825.604242]         extent refs 1 gen 215 flags 1
[ 3825.604244]         extent data backref root 261 objectid 783
offset 45088768 count 1
[ 3825.604246]     item 8 key (644876992512 168 524288) itemoff 15806
itemsize 53
[ 3825.604247]         extent refs 1 gen 215 flags 1
[ 3825.604248]         extent data backref root 261 objectid 783
offset 45613056 count 1
[ 3825.604250]     item 9 key (644877516800 168 524288) itemoff 15753
itemsize 53
[ 3825.604252]         extent refs 1 gen 215 flags 1
[ 3825.604253]         extent data backref root 261 objectid 783
offset 46137344 count 1
[ 3825.604255]     item 10 key (644878041088 168 524288) itemoff 15700
itemsize 53
[ 3825.604257]         extent refs 1 gen 215 flags 1
[ 3825.604258]         extent data backref root 261 objectid 783
offset 46661632 count 1
[ 3825.604260]     item 11 key (644878565376 168 524288) itemoff 15647
itemsize 53
[ 3825.604262]         extent refs 1 gen 215 flags 1
[ 3825.604263]         extent data backref root 261 objectid 783
offset 47185920 count 1
[ 3825.604265]     item 12 key (644879089664 168 524288) itemoff 15594
itemsize 53
[ 3825.604266]         extent refs 1 gen 215 flags 1
[ 3825.604268]         extent data backref root 261 objectid 783
offset 47710208 count 1
[ 3825.604270]     item 13 key (644879613952 168 524288) itemoff 15541
itemsize 53
[ 3825.604271]         extent refs 1 gen 215 flags 1
[ 3825.604273]         extent data backref root 261 objectid 783
offset 48234496 count 1
[ 3825.604275]     item 14 key (644880138240 168 524288) itemoff 15488
itemsize 53
[ 3825.604276]         extent refs 1 gen 215 flags 1
[ 3825.604278]         extent data backref root 261 objectid 783
offset 48758784 count 1
[ 3825.604280]     item 15 key (644880662528 168 524288) itemoff 15435
itemsize 53
[ 3825.604281]         extent refs 1 gen 215 flags 1
[ 3825.604283]         extent data backref root 261 objectid 783
offset 49283072 count 1
[ 3825.604285]     item 16 key (644881186816 168 524288) itemoff 15382
itemsize 53
[ 3825.604286]         extent refs 1 gen 215 flags 1
[ 3825.604288]         extent data backref root 261 objectid 783
offset 49807360 count 1
[ 3825.604290]     item 17 key (644881711104 168 524288) itemoff 15329
itemsize 53
[ 3825.604291]         extent refs 1 gen 215 flags 1
[ 3825.604293]         extent data backref root 261 objectid 783
offset 50331648 count 1
[ 3825.604295]     item 18 key (644882235392 168 524288) itemoff 15276
itemsize 53
[ 3825.604296]         extent refs 1 gen 215 flags 1
[ 3825.604298]         extent data backref root 261 objectid 783
offset 50855936 count 1
[ 3825.604300]     item 19 key (644882759680 168 524288) itemoff 15223
itemsize 53
[ 3825.604301]         extent refs 1 gen 215 flags 1
[ 3825.604303]         extent data backref root 261 objectid 783
offset 51380224 count 1
[ 3825.604305]     item 20 key (644883283968 168 524288) itemoff 15170
itemsize 53
[ 3825.604307]         extent refs 1 gen 215 flags 1
[ 3825.604308]         extent data backref root 261 objectid 783
offset 51904512 count 1
[ 3825.604310]     item 21 key (644883808256 168 524288) itemoff 15117
itemsize 53
[ 3825.604312]         extent refs 1 gen 215 flags 1
[ 3825.604313]         extent data backref root 261 objectid 783
offset 52428800 count 1
[ 3825.604315]     item 22 key (644884332544 168 524288) itemoff 15064
itemsize 53
[ 3825.604317]         extent refs 1 gen 215 flags 1
[ 3825.604318]         extent data backref root 261 objectid 783
offset 52953088 count 1
[ 3825.604320]     item 23 key (644884856832 168 524288) itemoff 15011
itemsize 53
[ 3825.604321]         extent refs 1 gen 215 flags 1
[ 3825.604323]         extent data backref root 261 objectid 783
offset 53477376 count 1
[ 3825.604325]     item 24 key (644885381120 168 524288) itemoff 14958
itemsize 53
[ 3825.604327]         extent refs 1 gen 215 flags 1
[ 3825.604328]         extent data backref root 261 objectid 783
offset 54001664 count 1
[ 3825.604330]     item 25 key (644885905408 168 524288) itemoff 14905
itemsize 53
[ 3825.604331]         extent refs 1 gen 215 flags 1
[ 3825.604333]         extent data backref root 261 objectid 783
offset 54525952 count 1
[ 3825.604335]     item 26 key (644886429696 168 524288) itemoff 14852
itemsize 53
[ 3825.604336]         extent refs 1 gen 215 flags 1
[ 3825.604338]         extent data backref root 261 objectid 783
offset 55050240 count 1
[ 3825.604340]     item 27 key (644886953984 168 524288) itemoff 14799
itemsize 53
[ 3825.604341]         extent refs 1 gen 215 flags 1
[ 3825.604343]         extent data backref root 261 objectid 783
offset 55574528 count 1
[ 3825.604344]     item 28 key (644887478272 168 524288) itemoff 14746
itemsize 53
[ 3825.604346]         extent refs 1 gen 215 flags 1
[ 3825.604348]         extent data backref root 261 objectid 783
offset 56098816 count 1
[ 3825.604350]     item 29 key (644888002560 168 524288) itemoff 14693
itemsize 53
[ 3825.604351]         extent refs 1 gen 215 flags 1
[ 3825.604353]         extent data backref root 261 objectid 783
offset 56623104 count 1
[ 3825.604355]     item 30 key (644888526848 168 524288) itemoff 14640
itemsize 53
[ 3825.604356]         extent refs 1 gen 77869 flags 1
[ 3825.604358]         extent data backref root 261 objectid 3284
offset 0 count 1
[ 3825.604360]     item 31 key (644889051136 168 524288) itemoff 14587
itemsize 53
[ 3825.604361]         extent refs 1 gen 77869 flags 1
[ 3825.604363]         extent data backref root 261 objectid 3285
offset 0 count 1
[ 3825.604364]     item 32 key (644889575424 168 655360) itemoff 14550
itemsize 37
[ 3825.604366]         extent refs 1 gen 77869 flags 1
[ 3825.604367]         shared data backref parent 33207361650688 count 1
[ 3825.604369]     item 33 key (644890230784 168 524288) itemoff 14497
itemsize 53
[ 3825.604371]         extent refs 1 gen 77872 flags 1
[ 3825.604372]         extent data backref root 261 objectid 3976
offset 1572864 count 1
[ 3825.604374]     item 34 key (644890755072 168 122880) itemoff 14460
itemsize 37
[ 3825.604376]         extent refs 1 gen 149517 flags 1
[ 3825.604377]         shared data backref parent 33205604614144 count 1
[ 3825.604379]     item 35 key (644890877952 168 106496) itemoff 14423
itemsize 37
[ 3825.604380]         extent refs 1 gen 149517 flags 1
[ 3825.604382]         shared data backref parent 33205604614144 count 1
[ 3825.604384]     item 36 key (644890984448 168 32768) itemoff 14386
itemsize 37
[ 3825.604385]         extent refs 1 gen 149517 flags 1
[ 3825.604386]         shared data backref parent 33202788433920 count 1
[ 3825.604388]     item 37 key (644891017216 168 53248) itemoff 14349
itemsize 37
[ 3825.604389]         extent refs 1 gen 149515 flags 1
[ 3825.604391]         shared data backref parent 33195660607488 count 1
[ 3825.604393]     item 38 key (644891070464 168 24576) itemoff 14312
itemsize 37
[ 3825.604394]         extent refs 1 gen 149515 flags 1
[ 3825.604396]         shared data backref parent 33195660607488 count 1
[ 3825.604398]     item 39 key (644891095040 168 45056) itemoff 14275
itemsize 37
[ 3825.604399]         extent refs 1 gen 149515 flags 1
[ 3825.604400]         shared data backref parent 33195660607488 count 1
[ 3825.604402]     item 40 key (644891140096 168 24576) itemoff 14238
itemsize 37
[ 3825.604403]         extent refs 1 gen 149515 flags 1
[ 3825.604405]         shared data backref parent 33195660607488 count 1
[ 3825.604406]     item 41 key (644891164672 168 69632) itemoff 14201
itemsize 37
[ 3825.604408]         extent refs 1 gen 149515 flags 1
[ 3825.604409]         shared data backref parent 33195660607488 count 1
[ 3825.604411]     item 42 key (644891234304 168 20480) itemoff 14164
itemsize 37
[ 3825.604412]         extent refs 1 gen 149515 flags 1
[ 3825.604413]         shared data backref parent 33195660607488 count 1
[ 3825.604416]     item 43 key (644891254784 168 16384) itemoff 14127
itemsize 37
[ 3825.604417]         extent refs 1 gen 149515 flags 1
[ 3825.604418]         shared data backref parent 33195660607488 count 1
[ 3825.604420]     item 44 key (644891271168 168 4096) itemoff 14090 itemsize 37
[ 3825.604421]         extent refs 1 gen 149515 flags 1
[ 3825.604423]         shared data backref parent 33195666014208 count 1
[ 3825.604424]     item 45 key (644891275264 168 102400) itemoff 14053
itemsize 37
[ 3825.604426]         extent refs 1 gen 120817 flags 1
[ 3825.604427]         shared data backref parent 33200591765504 count 1
[ 3825.604429]     item 46 key (644891377664 168 114688) itemoff 14016
itemsize 37
[ 3825.604430]         extent refs 1 gen 120817 flags 1
[ 3825.604431]         shared data backref parent 33200591765504 count 1
[ 3825.604433]     item 47 key (644891492352 168 36864) itemoff 13979
itemsize 37
[ 3825.604435]         extent refs 1 gen 146327 flags 1
[ 3825.604436]         shared data backref parent 33199769829376 count 1
[ 3825.604438]     item 48 key (644891529216 168 4096) itemoff 13942 itemsize 37
[ 3825.604439]         extent refs 1 gen 124938 flags 1
[ 3825.604440]         shared data backref parent 33201927847936 count 1
[ 3825.604442]     item 49 key (644891533312 168 8192) itemoff 13905 itemsize 37
[ 3825.604444]         extent refs 1 gen 177562 flags 1
[ 3825.604445]         shared data backref parent 33202448318464 count 1
[ 3825.604447]     item 50 key (644891541504 168 86016) itemoff 13868
itemsize 37
[ 3825.604448]         extent refs 1 gen 150949 flags 1
[ 3825.604449]         shared data backref parent 33212656697344 count 1
[ 3825.604452]     item 51 key (644891627520 168 86016) itemoff 13831
itemsize 37
[ 3825.604453]         extent refs 1 gen 150949 flags 1
[ 3825.604454]         shared data backref parent 33212656697344 count 1
[ 3825.604456]     item 52 key (644891713536 168 36864) itemoff 13794
itemsize 37
[ 3825.604457]         extent refs 1 gen 150949 flags 1
[ 3825.604459]         shared data backref parent 33212656697344 count 1
[ 3825.604460]     item 53 key (644891750400 168 28672) itemoff 13757
itemsize 37
[ 3825.604462]         extent refs 1 gen 150949 flags 1
[ 3825.604463]         shared data backref parent 33205477900288 count 1
[ 3825.604465]     item 54 key (644891779072 168 8192) itemoff 13720 itemsize 37
[ 3825.604466]         extent refs 1 gen 150951 flags 1
[ 3825.604468]         shared data backref parent 33206214934528 count 1
[ 3825.604470]     item 55 key (644891787264 168 4096) itemoff 13683 itemsize 37
[ 3825.604471]         extent refs 1 gen 150951 flags 1
[ 3825.604472]         shared data backref parent 33206214934528 count 1
[ 3825.604474]     item 56 key (644891791360 168 8192) itemoff 13630 itemsize 53
[ 3825.604476]         extent refs 1 gen 318017 flags 1
[ 3825.604477]         extent data backref root 2043 objectid 3587334
offset 262144 count 1
[ 3825.604479]     item 57 key (644891799552 168 4096) itemoff 13577 itemsize 53
[ 3825.604480]         extent refs 1 gen 330051 flags 1
[ 3825.604482]         extent data backref root 2043 objectid 4036120
offset 0 count 1
[ 3825.604484]     item 58 key (644891803648 168 524288) itemoff 13524
itemsize 53
[ 3825.604485]         extent refs 1 gen 149432 flags 1
[ 3825.604487]         extent data backref root 261 objectid 8872
offset 31457280 count 1
[ 3825.604489]     item 59 key (644892327936 168 524288) itemoff 13471
itemsize 53
[ 3825.604490]         extent refs 1 gen 149432 flags 1
[ 3825.604492]         extent data backref root 261 objectid 8872
offset 31981568 count 1
[ 3825.604494]     item 60 key (644892852224 168 524288) itemoff 13418
itemsize 53
[ 3825.604495]         extent refs 1 gen 149432 flags 1
[ 3825.604497]         extent data backref root 261 objectid 8872
offset 32505856 count 1
[ 3825.604499]     item 61 key (644893376512 168 524288) itemoff 13365
itemsize 53
[ 3825.604500]         extent refs 1 gen 149432 flags 1
[ 3825.604502]         extent data backref root 261 objectid 8872
offset 33030144 count 1
[ 3825.604504]     item 62 key (644893900800 168 77824) itemoff 13328
itemsize 37
[ 3825.604506]         extent refs 1 gen 149515 flags 1
[ 3825.604507]         shared data backref parent 33195660607488 count 1
[ 3825.604509]     item 63 key (644893978624 168 57344) itemoff 13291
itemsize 37
[ 3825.604510]         extent refs 1 gen 149515 flags 1
[ 3825.604511]         shared data backref parent 33195660607488 count 1
[ 3825.604513]     item 64 key (644894035968 168 57344) itemoff 13254
itemsize 37
[ 3825.604515]         extent refs 1 gen 149515 flags 1
[ 3825.604516]         shared data backref parent 33195660607488 count 1
[ 3825.604518]     item 65 key (644894093312 168 53248) itemoff 13217
itemsize 37
[ 3825.604519]         extent refs 1 gen 149515 flags 1
[ 3825.604520]         shared data backref parent 33195660607488 count 1
[ 3825.604522]     item 66 key (644894146560 168 16384) itemoff 13180
itemsize 37
[ 3825.604524]         extent refs 1 gen 149515 flags 1
[ 3825.604525]         shared data backref parent 33195660607488 count 1
[ 3825.604527]     item 67 key (644894162944 168 86016) itemoff 13143
itemsize 37
[ 3825.604528]         extent refs 1 gen 150948 flags 1
[ 3825.604529]         shared data backref parent 33202880495616 count 1
[ 3825.604531]     item 68 key (644894248960 168 106496) itemoff 13106
itemsize 37
[ 3825.604533]         extent refs 1 gen 150948 flags 1
[ 3825.604534]         shared data backref parent 33202880495616 count 1
[ 3825.604536]     item 69 key (644894355456 168 53248) itemoff 13069
itemsize 37
[ 3825.604537]         extent refs 1 gen 150948 flags 1
[ 3825.604538]         shared data backref parent 33207354474496 count 1
[ 3825.604540]     item 70 key (644894408704 168 16384) itemoff 13032
itemsize 37
[ 3825.604541]         extent refs 1 gen 150948 flags 1
[ 3825.604543]         shared data backref parent 33210413891584 count 1
[ 3825.604545]     item 71 key (644894425088 168 53248) itemoff 12995
itemsize 37
[ 3825.604546]         extent refs 1 gen 149515 flags 1
[ 3825.604547]         shared data backref parent 33195666014208 count 1
[ 3825.604549]     item 72 key (644894478336 168 28672) itemoff 12958
itemsize 37
[ 3825.604551]         extent refs 1 gen 149515 flags 1
[ 3825.604552]         shared data backref parent 33195666014208 count 1
[ 3825.604554]     item 73 key (644894507008 168 53248) itemoff 12921
itemsize 37
[ 3825.604555]         extent refs 1 gen 149515 flags 1
[ 3825.604556]         shared data backref parent 33195666014208 count 1
[ 3825.604558]     item 74 key (644894560256 168 24576) itemoff 12884
itemsize 37
[ 3825.604560]         extent refs 1 gen 149515 flags 1
[ 3825.604561]         shared data backref parent 33195666014208 count 1
[ 3825.604563]     item 75 key (644894584832 168 49152) itemoff 12847
itemsize 37
[ 3825.604564]         extent refs 1 gen 149515 flags 1
[ 3825.604565]         shared data backref parent 33195666014208 count 1
[ 3825.604567]     item 76 key (644894633984 168 20480) itemoff 12810
itemsize 37
[ 3825.604569]         extent refs 1 gen 149515 flags 1
[ 3825.604570]         shared data backref parent 33195666014208 count 1
[ 3825.604572]     item 77 key (644894654464 168 12288) itemoff 12773
itemsize 37
[ 3825.604573]         extent refs 1 gen 149515 flags 1
[ 3825.604574]         shared data backref parent 33196891865088 count 1
[ 3825.604576]     item 78 key (644894666752 168 20480) itemoff 12720
itemsize 53
[ 3825.604578]         extent refs 1 gen 156901 flags 1
[ 3825.604580]         extent data backref root 262 objectid 1343827
offset 3014656 count 1
[ 3825.604582]     item 79 key (644894687232 168 73728) itemoff 12683
itemsize 37
[ 3825.604584]         extent refs 1 gen 164109 flags 1
[ 3825.604585]         shared data backref parent 33203275218944 count 1
[ 3825.604587]     item 80 key (644894760960 168 69632) itemoff 12646
itemsize 37
[ 3825.604588]         extent refs 1 gen 164109 flags 1
[ 3825.604590]         shared data backref parent 33203275218944 count 1
[ 3825.604592]     item 81 key (644894830592 168 73728) itemoff 12609
itemsize 37
[ 3825.604593]         extent refs 1 gen 164109 flags 1
[ 3825.604594]         shared data backref parent 33203275218944 count 1
[ 3825.604596]     item 82 key (644894904320 168 40960) itemoff 12572
itemsize 37
[ 3825.604597]         extent refs 1 gen 164109 flags 1
[ 3825.604599]         shared data backref parent 33203275218944 count 1
[ 3825.604601]     item 83 key (644894945280 168 4096) itemoff 12519 itemsize 53
[ 3825.604602]         extent refs 1 gen 325722 flags 1
[ 3825.604604]         extent data backref root 262 objectid 2165941
offset 0 count 1
[ 3825.604606]     item 84 key (644894949376 168 20480) itemoff 12466
itemsize 53
[ 3825.604607]         extent refs 1 gen 306115 flags 1
[ 3825.604609]         extent data backref root 2043 objectid 3265483
offset 0 count 1
[ 3825.604611]     item 85 key (644894969856 168 20480) itemoff 12413
itemsize 53
[ 3825.604612]         extent refs 1 gen 156901 flags 1
[ 3825.604614]         extent data backref root 262 objectid 1343827
offset 5242880 count 1
[ 3825.604616]     item 86 key (644894990336 168 8192) itemoff 12376 itemsize 37
[ 3825.604617]         extent refs 1 gen 163977 flags 1
[ 3825.604618]         shared data backref parent 33208078843904 count 1
[ 3825.604620]     item 87 key (644894998528 168 4096) itemoff 12323 itemsize 53
[ 3825.604622]         extent refs 1 gen 325503 flags 1
[ 3825.604623]         extent data backref root 2043 objectid 3640384
offset 0 count 1
[ 3825.604625]     item 88 key (644895002624 168 16384) itemoff 12286
itemsize 37
[ 3825.604627]         extent refs 1 gen 177519 flags 1
[ 3825.604628]         shared data backref parent 33211444396032 count 1
[ 3825.604630]     item 89 key (644895019008 168 4096) itemoff 12233 itemsize 53
[ 3825.604631]         extent refs 1 gen 157657 flags 1
[ 3825.604633]         extent data backref root 261 objectid 8947
offset 786432 count 1
[ 3825.604635]     item 90 key (644895023104 168 4096) itemoff 12180 itemsize 53
[ 3825.604637]         extent refs 1 gen 157657 flags 1
[ 3825.604638]         extent data backref root 261 objectid 8947
offset 917504 count 1
[ 3825.604640]     item 91 key (644895027200 168 4096) itemoff 12127 itemsize 53
[ 3825.604641]         extent refs 1 gen 157657 flags 1
[ 3825.604643]         extent data backref root 261 objectid 8947
offset 1048576 count 1
[ 3825.604645]     item 92 key (644895031296 168 20480) itemoff 12090
itemsize 37
[ 3825.604647]         extent refs 1 gen 177519 flags 1
[ 3825.604648]         shared data backref parent 33211444396032 count 1
[ 3825.604650]     item 93 key (644895051776 168 12288) itemoff 12053
itemsize 37
[ 3825.604651]         extent refs 1 gen 158918 flags 1
[ 3825.604652]         shared data backref parent 33195740479488 count 1
[ 3825.604654]     item 94 key (644895064064 168 16384) itemoff 12016
itemsize 37
[ 3825.604656]         extent refs 1 gen 161013 flags 1
[ 3825.604657]         shared data backref parent 33205199011840 count 1
[ 3825.604659]     item 95 key (644895080448 168 49152) itemoff 11979
itemsize 37
[ 3825.604660]         extent refs 1 gen 157848 flags 1
[ 3825.604661]         shared data backref parent 33201455628288 count 1
[ 3825.604663]     item 96 key (644895129600 168 4096) itemoff 11942 itemsize 37
[ 3825.604665]         extent refs 1 gen 158007 flags 1
[ 3825.604666]         shared data backref parent 33213106388992 count 1
[ 3825.604668]     item 97 key (644895133696 168 12288) itemoff 11889
itemsize 53
[ 3825.604669]         extent refs 1 gen 318024 flags 1
[ 3825.604671]         extent data backref root 2043 objectid 3587593
offset 2490368 count 1
[ 3825.604673]     item 98 key (644895145984 168 8192) itemoff 11836 itemsize 53
[ 3825.604674]         extent refs 1 gen 318018 flags 1
[ 3825.604676]         extent data backref root 2043 objectid 3587362
offset 786432 count 1
[ 3825.604678]     item 99 key (644895154176 168 4096) itemoff 11783 itemsize 53
[ 3825.604679]         extent refs 1 gen 318773 flags 1
[ 3825.604681]         extent data backref root 2043 objectid 3605775
offset 0 count 1
[ 3825.604683]     item 100 key (644895158272 168 8192) itemoff 11746
itemsize 37
[ 3825.604684]         extent refs 1 gen 164108 flags 1
[ 3825.604685]         shared data backref parent 33213192716288 count 1
[ 3825.604687]     item 101 key (644895166464 168 12288) itemoff 11709
itemsize 37
[ 3825.604688]         extent refs 1 gen 161013 flags 1
[ 3825.604690]         shared data backref parent 33217003601920 count 1
[ 3825.604691]     item 102 key (644895178752 168 16384) itemoff 11656
itemsize 53
[ 3825.604693]         extent refs 1 gen 318024 flags 1
[ 3825.604694]         extent data backref root 2043 objectid 3587556
offset 786432 count 1
[ 3825.604696]     item 103 key (644895195136 168 4096) itemoff 11603
itemsize 53
[ 3825.604698]         extent refs 1 gen 318773 flags 1
[ 3825.604699]         extent data backref root 2043 objectid 3605776
offset 0 count 1
[ 3825.604701]     item 104 key (644895199232 168 4096) itemoff 11566
itemsize 37
[ 3825.604703]         extent refs 1 gen 161014 flags 1
[ 3825.604704]         shared data backref parent 33196744884224 count 1
[ 3825.604706]     item 105 key (644895203328 168 4096) itemoff 11529
itemsize 37
[ 3825.604707]         extent refs 1 gen 158007 flags 1
[ 3825.604708]         shared data backref parent 33213106388992 count 1
[ 3825.604710]     item 106 key (644895207424 168 4096) itemoff 11492
itemsize 37
[ 3825.604711]         extent refs 1 gen 158007 flags 1
[ 3825.604713]         shared data backref parent 33213106388992 count 1
[ 3825.604714]     item 107 key (644895211520 168 114688) itemoff
11455 itemsize 37
[ 3825.604716]         extent refs 1 gen 149614 flags 1
[ 3825.604717]         shared data backref parent 33208149901312 count 1
[ 3825.604719]     item 108 key (644895326208 168 106496) itemoff
11418 itemsize 37
[ 3825.604720]         extent refs 1 gen 149614 flags 1
[ 3825.604722]         shared data backref parent 33208149901312 count 1
[ 3825.604724]     item 109 key (644895432704 168 114688) itemoff
11381 itemsize 37
[ 3825.604725]         extent refs 1 gen 149614 flags 1
[ 3825.604726]         shared data backref parent 33208149901312 count 1
[ 3825.604728]     item 110 key (644895547392 168 114688) itemoff
11344 itemsize 37
[ 3825.604729]         extent refs 1 gen 149614 flags 1
[ 3825.604731]         shared data backref parent 33208149901312 count 1
[ 3825.604733]     item 111 key (644895662080 168 73728) itemoff 11307
itemsize 37
[ 3825.604734]         extent refs 1 gen 149615 flags 1
[ 3825.604735]         shared data backref parent 33202781601792 count 1
[ 3825.604737]     item 112 key (644895735808 168 73728) itemoff 11270
itemsize 37
[ 3825.604738]         extent refs 1 gen 149515 flags 1
[ 3825.604740]         shared data backref parent 33195666014208 count 1
[ 3825.604741]     item 113 key (644895809536 168 94208) itemoff 11233
itemsize 37
[ 3825.604743]         extent refs 1 gen 149515 flags 1
[ 3825.604744]         shared data backref parent 33195666014208 count 1
[ 3825.604746]     item 114 key (644895903744 168 49152) itemoff 11196
itemsize 37
[ 3825.604747]         extent refs 1 gen 149515 flags 1
[ 3825.604748]         shared data backref parent 33195666014208 count 1
[ 3825.604750]     item 115 key (644895952896 168 20480) itemoff 11159
itemsize 37
[ 3825.604752]         extent refs 1 gen 149515 flags 1
[ 3825.604753]         shared data backref parent 33195666014208 count 1
[ 3825.604755]     item 116 key (644895973376 168 12288) itemoff 11122
itemsize 37
[ 3825.604756]         extent refs 1 gen 149515 flags 1
[ 3825.604757]         shared data backref parent 33196922617856 count 1
[ 3825.604759]     item 117 key (644895985664 168 32768) itemoff 11085
itemsize 37
[ 3825.604761]         extent refs 1 gen 146328 flags 1
[ 3825.604762]         shared data backref parent 33194962583552 count 1
[ 3825.604764]     item 118 key (644896018432 168 4096) itemoff 11048
itemsize 37
[ 3825.604765]         extent refs 1 gen 124939 flags 1
[ 3825.604766]         shared data backref parent 33199603023872 count 1
[ 3825.604768]     item 119 key (644896022528 168 81920) itemoff 11011
itemsize 37
[ 3825.604770]         extent refs 1 gen 120670 flags 1
[ 3825.604771]         shared data backref parent 33201905958912 count 1
[ 3825.604773]     item 120 key (644896104448 168 8192) itemoff 10974
itemsize 37
[ 3825.604774]         extent refs 1 gen 144006 flags 1
[ 3825.604775]         shared data backref parent 33199321595904 count 1
[ 3825.604777]     item 121 key (644896112640 168 94208) itemoff 10937
itemsize 37
[ 3825.604779]         extent refs 1 gen 120651 flags 1
[ 3825.604780]         shared data backref parent 33205847834624 count 1
[ 3825.604782]     item 122 key (644896206848 168 32768) itemoff 10900
itemsize 37
[ 3825.604783]         extent refs 1 gen 146323 flags 1
[ 3825.604784]         shared data backref parent 33208303632384 count 1
[ 3825.604786]     item 123 key (644896239616 168 12288) itemoff 10863
itemsize 37
[ 3825.604787]         extent refs 1 gen 144001 flags 1
[ 3825.604788]         shared data backref parent 33200064708608 count 1
[ 3825.604790]     item 124 key (644896251904 168 4096) itemoff 10810
itemsize 53
[ 3825.604792]         extent refs 1 gen 306130 flags 1
[ 3825.604793]         extent data backref root 2043 objectid 3268377
offset 0 count 1
[ 3825.604795]     item 125 key (644896256000 168 4096) itemoff 10773
itemsize 37
[ 3825.604797]         extent refs 1 gen 177562 flags 1
[ 3825.604798]         shared data backref parent 33205374795776 count 1
[ 3825.604800]     item 126 key (644896260096 168 86016) itemoff 10736
itemsize 37
[ 3825.604801]         extent refs 1 gen 150959 flags 1
[ 3825.604802]         shared data backref parent 33208537677824 count 1
[ 3825.604804]     item 127 key (644896346112 168 122880) itemoff
10699 itemsize 37
[ 3825.604806]         extent refs 1 gen 150959 flags 1
[ 3825.604807]         shared data backref parent 33208537677824 count 1
[ 3825.604809]     item 128 key (644896468992 168 36864) itemoff 10662
itemsize 37
[ 3825.604810]         extent refs 1 gen 150959 flags 1
[ 3825.604811]         shared data backref parent 33195330076672 count 1
[ 3825.604813]     item 129 key (644896505856 168 16384) itemoff 10625
itemsize 37
[ 3825.604815]         extent refs 1 gen 150960 flags 1
[ 3825.604816]         shared data backref parent 33196660031488 count 1
[ 3825.604817]     item 130 key (644896522240 168 90112) itemoff 10588
itemsize 37
[ 3825.604818]         extent refs 1 gen 150951 flags 1
[ 3825.604819]         shared data backref parent 33211452473344 count 1
[ 3825.604821]     item 131 key (644896612352 168 32768) itemoff 10551
itemsize 37
[ 3825.604822]         extent refs 1 gen 150951 flags 1
[ 3825.604823]         shared data backref parent 33206214934528 count 1
[ 3825.604824]     item 132 key (644896645120 168 24576) itemoff 10514
itemsize 37
[ 3825.604825]         extent refs 1 gen 150951 flags 1
[ 3825.604826]         shared data backref parent 33206214934528 count 1
[ 3825.604828]     item 133 key (644896669696 168 20480) itemoff 10477
itemsize 37
[ 3825.604829]         extent refs 1 gen 150951 flags 1
[ 3825.604830]         shared data backref parent 33206214934528 count 1
[ 3825.604832]     item 134 key (644896690176 168 36864) itemoff 10440
itemsize 37
[ 3825.604833]         extent refs 1 gen 150951 flags 1
[ 3825.604834]         shared data backref parent 33206214934528 count 1
[ 3825.604835]     item 135 key (644896727040 168 24576) itemoff 10403
itemsize 37
[ 3825.604836]         extent refs 1 gen 150951 flags 1
[ 3825.604837]         shared data backref parent 33206214934528 count 1
[ 3825.604839]     item 136 key (644896751616 168 24576) itemoff 10366
itemsize 37
[ 3825.604840]         extent refs 1 gen 150951 flags 1
[ 3825.604841]         shared data backref parent 33206214934528 count 1
[ 3825.604842]     item 137 key (644896776192 168 4096) itemoff 10329
itemsize 37
[ 3825.604844]         extent refs 1 gen 150951 flags 1
[ 3825.604845]         shared data backref parent 33206214934528 count 1
[ 3825.604846]     item 138 key (644896780288 168 4096) itemoff 10292
itemsize 37
[ 3825.604847]         extent refs 1 gen 150974 flags 1
[ 3825.604848]         shared data backref parent 33202660229120 count 1
[ 3825.604850]     item 139 key (644896784384 168 65536) itemoff 10255
itemsize 37
[ 3825.604851]         extent refs 1 gen 149517 flags 1
[ 3825.604852]         shared data backref parent 33205604614144 count 1
[ 3825.604853]     item 140 key (644896849920 168 98304) itemoff 10218
itemsize 37
[ 3825.604855]         extent refs 1 gen 149517 flags 1
[ 3825.604856]         shared data backref parent 33205604614144 count 1
[ 3825.604857]     item 141 key (644896948224 168 90112) itemoff 10181
itemsize 37
[ 3825.604858]         extent refs 1 gen 149517 flags 1
[ 3825.604859]         shared data backref parent 33205604614144 count 1
[ 3825.604861]     item 142 key (644897038336 168 8192) itemoff 10144
itemsize 37
[ 3825.604862]         extent refs 1 gen 149517 flags 1
[ 3825.604863]         shared data backref parent 33205228044288 count 1
[ 3825.604864]     item 143 key (644897046528 168 36864) itemoff 10107
itemsize 37
[ 3825.604865]         extent refs 1 gen 164136 flags 1
[ 3825.604866]         shared data backref parent 33204544438272 count 1
[ 3825.604868]     item 144 key (644897083392 168 57344) itemoff 10070
itemsize 37
[ 3825.604869]         extent refs 1 gen 164136 flags 1
[ 3825.604870]         shared data backref parent 33204544438272 count 1
[ 3825.604872]     item 145 key (644897140736 168 53248) itemoff 10033
itemsize 37
[ 3825.604873]         extent refs 1 gen 164136 flags 1
[ 3825.604874]         shared data backref parent 33204544438272 count 1
[ 3825.604875]     item 146 key (644897193984 168 65536) itemoff 9996
itemsize 37
[ 3825.604876]         extent refs 1 gen 164136 flags 1
[ 3825.604877]         shared data backref parent 33204544438272 count 1
[ 3825.604879]     item 147 key (644897259520 168 49152) itemoff 9959
itemsize 37
[ 3825.604880]         extent refs 1 gen 164136 flags 1
[ 3825.604881]         shared data backref parent 33204544438272 count 1
[ 3825.604882]     item 148 key (644897308672 168 110592) itemoff 9922
itemsize 37
[ 3825.604884]         extent refs 1 gen 149614 flags 1
[ 3825.604885]         shared data backref parent 33208149901312 count 1
[ 3825.604886]     item 149 key (644897419264 168 102400) itemoff 9885
itemsize 37
[ 3825.604887]         extent refs 1 gen 149614 flags 1
[ 3825.604888]         shared data backref parent 33208149901312 count 1
[ 3825.604890]     item 150 key (644897521664 168 45056) itemoff 9848
itemsize 37
[ 3825.604891]         extent refs 1 gen 149616 flags 1
[ 3825.604892]         shared data backref parent 33209313492992 count 1
[ 3825.604893]     item 151 key (644897566720 168 114688) itemoff 9811
itemsize 37
[ 3825.604894]         extent refs 1 gen 149626 flags 1
[ 3825.604895]         shared data backref parent 33212912517120 count 1
[ 3825.604897]     item 152 key (644897681408 168 122880) itemoff 9774
itemsize 37
[ 3825.604898]         extent refs 1 gen 149626 flags 1
[ 3825.604899]         shared data backref parent 33212912517120 count 1
[ 3825.604900]     item 153 key (644897804288 168 16384) itemoff 9737
itemsize 37
[ 3825.604902]         extent refs 1 gen 149626 flags 1
[ 3825.604903]         shared data backref parent 33212298248192 count 1
[ 3825.604904]     item 154 key (644897820672 168 12288) itemoff 9700
itemsize 37
[ 3825.604905]         extent refs 1 gen 149628 flags 1
[ 3825.604906]         shared data backref parent 33203505070080 count 1
[ 3825.604908]     item 155 key (644897832960 168 110592) itemoff 9663
itemsize 37
[ 3825.604909]         extent refs 1 gen 149614 flags 1
[ 3825.604910]         shared data backref parent 33208149901312 count 1
[ 3825.604911]     item 156 key (644897943552 168 106496) itemoff 9626
itemsize 37
[ 3825.604912]         extent refs 1 gen 149614 flags 1
[ 3825.604913]         shared data backref parent 33208149901312 count 1
[ 3825.604915]     item 157 key (644898050048 168 32768) itemoff 9589
itemsize 37
[ 3825.604916]         extent refs 1 gen 149617 flags 1
[ 3825.604917]         shared data backref parent 33202781601792 count 1
[ 3825.604918]     item 158 key (644898082816 168 12288) itemoff 9552
itemsize 37
[ 3825.604919]         extent refs 1 gen 149624 flags 1
[ 3825.604921]         shared data backref parent 33212743974912 count 1
[ 3825.604922]     item 159 key (644898095104 168 65536) itemoff 9515
itemsize 37
[ 3825.604923]         extent refs 1 gen 164136 flags 1
[ 3825.604924]         shared data backref parent 33204544438272 count 1
[ 3825.604926]     item 160 key (644898160640 168 65536) itemoff 9478
itemsize 37
[ 3825.604927]         extent refs 1 gen 164136 flags 1
[ 3825.604928]         shared data backref parent 33204544438272 count 1
[ 3825.604930]     item 161 key (644898226176 168 69632) itemoff 9441
itemsize 37
[ 3825.604931]         extent refs 1 gen 164136 flags 1
[ 3825.604932]         shared data backref parent 33204544438272 count 1
[ 3825.604933]     item 162 key (644898295808 168 61440) itemoff 9404
itemsize 37
[ 3825.604934]         extent refs 1 gen 164136 flags 1
[ 3825.604935]         shared data backref parent 33204544438272 count 1
[ 3825.604937]     item 163 key (644898357248 168 94208) itemoff 9367
itemsize 37
[ 3825.604938]         extent refs 1 gen 149517 flags 1
[ 3825.604939]         shared data backref parent 33211503411200 count 1
[ 3825.604940]     item 164 key (644898451456 168 98304) itemoff 9330
itemsize 37
[ 3825.604941]         extent refs 1 gen 149517 flags 1
[ 3825.604942]         shared data backref parent 33211503411200 count 1
[ 3825.604944]     item 165 key (644898549760 168 61440) itemoff 9293
itemsize 37
[ 3825.604945]         extent refs 1 gen 149517 flags 1
[ 3825.604946]         shared data backref parent 33211503411200 count 1
[ 3825.604948]     item 166 key (644898611200 168 8192) itemoff 9256 itemsize 37
[ 3825.604949]         extent refs 1 gen 149517 flags 1
[ 3825.604950]         shared data backref parent 33208201789440 count 1
[ 3825.604951]     item 167 key (644898619392 168 110592) itemoff 9219
itemsize 37
[ 3825.604952]         extent refs 1 gen 149614 flags 1
[ 3825.604953]         shared data backref parent 33208149901312 count 1
[ 3825.604955]     item 168 key (644898729984 168 110592) itemoff 9182
itemsize 37
[ 3825.604956]         extent refs 1 gen 149614 flags 1
[ 3825.604957]         shared data backref parent 33208149901312 count 1
[ 3825.604958]     item 169 key (644898840576 168 110592) itemoff 9145
itemsize 37
[ 3825.604959]         extent refs 1 gen 149614 flags 1
[ 3825.604960]         shared data backref parent 33208149901312 count 1
[ 3825.604962]     item 170 key (644898951168 168 110592) itemoff 9108
itemsize 37
[ 3825.604963]         extent refs 1 gen 149614 flags 1
[ 3825.604964]         shared data backref parent 33208149901312 count 1
[ 3825.604966]     item 171 key (644899061760 168 65536) itemoff 9071
itemsize 37
[ 3825.604967]         extent refs 1 gen 149615 flags 1
[ 3825.604968]         shared data backref parent 33202781601792 count 1
[ 3825.604969]     item 172 key (644899127296 168 81920) itemoff 9034
itemsize 37
[ 3825.604970]         extent refs 1 gen 149624 flags 1
[ 3825.604971]         shared data backref parent 33202024169472 count 1
[ 3825.604973]     item 173 key (644899209216 168 77824) itemoff 8997
itemsize 37
[ 3825.604974]         extent refs 1 gen 149624 flags 1
[ 3825.604975]         shared data backref parent 33202024169472 count 1
[ 3825.604976]     item 174 key (644899287040 168 69632) itemoff 8960
itemsize 37
[ 3825.604977]         extent refs 1 gen 149624 flags 1
[ 3825.604978]         shared data backref parent 33202024169472 count 1
[ 3825.604980]     item 175 key (644899356672 168 45056) itemoff 8923
itemsize 37
[ 3825.604981]         extent refs 1 gen 149624 flags 1
[ 3825.604982]         shared data backref parent 33202024169472 count 1
[ 3825.604984]     item 176 key (644899401728 168 4096) itemoff 8886 itemsize 37
[ 3825.604985]         extent refs 1 gen 149630 flags 1
[ 3825.604986]         shared data backref parent 33212298248192 count 1
[ 3825.604987]     item 177 key (644899405824 168 114688) itemoff 8849
itemsize 37
[ 3825.604988]         extent refs 1 gen 149614 flags 1
[ 3825.604989]         shared data backref parent 33208149901312 count 1
[ 3825.604991]     item 178 key (644899520512 168 110592) itemoff 8812
itemsize 37
[ 3825.604992]         extent refs 1 gen 149614 flags 1
[ 3825.604993]         shared data backref parent 33208149901312 count 1
[ 3825.604994]     item 179 key (644899631104 168 32768) itemoff 8775
itemsize 37
[ 3825.604996]         extent refs 1 gen 149617 flags 1
[ 3825.604997]         shared data backref parent 33202199412736 count 1
[ 3825.604998]     item 180 key (644899663872 168 4096) itemoff 8722 itemsize 53
[ 3825.604999]         extent refs 1 gen 318773 flags 1
[ 3825.605001]         extent data backref root 2043 objectid 3605777
offset 0 count 1
[ 3825.605002]     item 181 key (644899667968 168 45056) itemoff 8685
itemsize 37
[ 3825.605003]         extent refs 1 gen 154417 flags 1
[ 3825.605004]         shared data backref parent 33196898254848 count 1
[ 3825.605006]     item 182 key (644899713024 168 24576) itemoff 8648
itemsize 37
[ 3825.605007]         extent refs 1 gen 154429 flags 1
[ 3825.605008]         shared data backref parent 33201605591040 count 1
[ 3825.605009]     item 183 key (644899737600 168 4096) itemoff 8611 itemsize 37
[ 3825.605011]         extent refs 1 gen 154430 flags 1
[ 3825.605012]         shared data backref parent 33215576932352 count 1
[ 3825.605013]     item 184 key (644899741696 168 8192) itemoff 8574 itemsize 37
[ 3825.605014]         extent refs 1 gen 161013 flags 1
[ 3825.605015]         shared data backref parent 33210444234752 count 1
[ 3825.605017]     item 185 key (644899749888 168 4096) itemoff 8537 itemsize 37
[ 3825.605018]         extent refs 1 gen 153448 flags 1
[ 3825.605019]         shared data backref parent 33199426813952 count 1
[ 3825.605020]     item 186 key (644899753984 168 4096) itemoff 8484 itemsize 53
[ 3825.605022]         extent refs 1 gen 325503 flags 1
[ 3825.605023]         extent data backref root 2043 objectid 3640397
offset 0 count 1
[ 3825.605024]     item 187 key (644899758080 168 8192) itemoff 8447 itemsize 37
[ 3825.605026]         extent refs 1 gen 153448 flags 1
[ 3825.605027]         shared data backref parent 33210303414272 count 1
[ 3825.605028]     item 188 key (644899766272 168 8192) itemoff 8410 itemsize 37
[ 3825.605029]         extent refs 1 gen 153448 flags 1
[ 3825.605030]         shared data backref parent 33211417608192 count 1
[ 3825.605032]     item 189 key (644899774464 168 12288) itemoff 8357
itemsize 53
[ 3825.605033]         extent refs 1 gen 318756 flags 1
[ 3825.605034]         extent data backref root 2043 objectid 3605445
offset 1048576 count 1
[ 3825.605036]     item 190 key (644899786752 168 4096) itemoff 8320 itemsize 37
[ 3825.605037]         extent refs 1 gen 153448 flags 1
[ 3825.605038]         shared data backref parent 33199426813952 count 1
[ 3825.605039]     item 191 key (644899790848 168 28672) itemoff 8267
itemsize 53
[ 3825.605040]         extent refs 1 gen 152942 flags 1
[ 3825.605042]         extent data backref root 261 objectid 8922
offset 0 count 1
[ 3825.605043]     item 192 key (644899819520 168 49152) itemoff 8214
itemsize 53
[ 3825.605045]         extent refs 1 gen 318017 flags 1
[ 3825.605046]         extent data backref root 2043 objectid 3587330
offset 131072 count 1
[ 3825.605047]     item 193 key (644899868672 168 32768) itemoff 8161
itemsize 53
[ 3825.605048]         extent refs 1 gen 318017 flags 1
[ 3825.605050]         extent data backref root 2043 objectid 3587330
offset 262144 count 1
[ 3825.605051]     item 194 key (644899901440 168 28672) itemoff 8108
itemsize 53
[ 3825.605052]         extent refs 1 gen 318018 flags 1
[ 3825.605054]         extent data backref root 2043 objectid 3587362
offset 524288 count 1
[ 3825.605055]     item 195 key (644899930112 168 94208) itemoff 8071
itemsize 37
[ 3825.605056]         extent refs 1 gen 149618 flags 1
[ 3825.605057]         shared data backref parent 33202199412736 count 1
[ 3825.605059]     item 196 key (644900024320 168 102400) itemoff 8034
itemsize 37
[ 3825.605060]         extent refs 1 gen 149618 flags 1
[ 3825.605061]         shared data backref parent 33202199412736 count 1
[ 3825.605063]     item 197 key (644900126720 168 53248) itemoff 7997
itemsize 37
[ 3825.605064]         extent refs 1 gen 149618 flags 1
[ 3825.605065]         shared data backref parent 33209313492992 count 1
[ 3825.605066]     item 198 key (644900179968 168 12288) itemoff 7960
itemsize 37
[ 3825.605067]         extent refs 1 gen 149628 flags 1
[ 3825.605068]         shared data backref parent 33203505070080 count 1
[ 3825.605070]     item 199 key (644900192256 168 77824) itemoff 7923
itemsize 37
[ 3825.605071]         extent refs 1 gen 150949 flags 1
[ 3825.605072]         shared data backref parent 33212656697344 count 1
[ 3825.605073]     item 200 key (644900270080 168 106496) itemoff 7886
itemsize 37
[ 3825.605075]         extent refs 1 gen 150949 flags 1
[ 3825.605076]         shared data backref parent 33212656697344 count 1
[ 3825.605077]     item 201 key (644900376576 168 73728) itemoff 7849
itemsize 37
[ 3825.605078]         extent refs 1 gen 150949 flags 1
[ 3825.605079]         shared data backref parent 33212656697344 count 1
[ 3825.605081]     item 202 key (644900450304 168 4096) itemoff 7812 itemsize 37
[ 3825.605082]         extent refs 1 gen 150974 flags 1
[ 3825.605083]         shared data backref parent 33202660229120 count 1
[ 3825.605084]     item 203 key (644900454400 168 73728) itemoff 7775
itemsize 37
[ 3825.605085]         extent refs 1 gen 164136 flags 1
[ 3825.605086]         shared data backref parent 33204544438272 count 1
[ 3825.605088]     item 204 key (644900528128 168 65536) itemoff 7738
itemsize 37
[ 3825.605089]         extent refs 1 gen 164136 flags 1
[ 3825.605090]         shared data backref parent 33204544438272 count 1
[ 3825.605092]     item 205 key (644900593664 168 65536) itemoff 7701
itemsize 37
[ 3825.605093]         extent refs 1 gen 164136 flags 1
[ 3825.605094]         shared data backref parent 33204544438272 count 1
[ 3825.605095]     item 206 key (644900659200 168 53248) itemoff 7664
itemsize 37
[ 3825.605096]         extent refs 1 gen 164136 flags 1
[ 3825.605097]         shared data backref parent 33204544438272 count 1
[ 3825.605099]     item 207 key (644900712448 168 4096) itemoff 7611 itemsize 53
[ 3825.605100]         extent refs 1 gen 318773 flags 1
[ 3825.605101]         extent data backref root 2043 objectid 3605779
offset 0 count 1
[ 3825.605103]     item 208 key (644900716544 168 110592) itemoff 7574
itemsize 37
[ 3825.605104]         extent refs 1 gen 149616 flags 1
[ 3825.605105]         shared data backref parent 33208149901312 count 1
[ 3825.605106]     item 209 key (644900827136 168 114688) itemoff 7537
itemsize 37
[ 3825.605107]         extent refs 1 gen 149616 flags 1
[ 3825.605108]         shared data backref parent 33208149901312 count 1
[ 3825.605110]     item 210 key (644900941824 168 36864) itemoff 7500
itemsize 37
[ 3825.605111]         extent refs 1 gen 149618 flags 1
[ 3825.605112]         shared data backref parent 33202199412736 count 1
[ 3825.605114]     item 211 key (644900978688 168 94208) itemoff 7463
itemsize 37
[ 3825.605115]         extent refs 1 gen 149517 flags 1
[ 3825.605116]         shared data backref parent 33211503411200 count 1
[ 3825.605117]     item 212 key (644901072896 168 73728) itemoff 7426
itemsize 37
[ 3825.605118]         extent refs 1 gen 149517 flags 1
[ 3825.605119]         shared data backref parent 33211503411200 count 1
[ 3825.605122] BTRFS error (device sdd): unable to find ref byte nr
644894945280 parent 0 root 2043  owner 3640378 offset 0
[ 3825.605212] ------------[ cut here ]------------
[ 3825.605227] WARNING: CPU: 5 PID: 15736 at
/mnt/linux/fs/btrfs/extent-tree.c:6951
__btrfs_free_extent.isra.33+0x995/0xca0 [btrfs]
[ 3825.605229] BTRFS: Transaction aborted (error -2)
[ 3825.605230] Modules linked in: arc4 md4 hmac nls_utf8 cifs
dns_resolver fscache nls_iso8859_4 nls_cp775 xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun cfg80211 rfkill
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_tcpudp xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ip_set nfnetlink ebtable_broute ebtable_nat
ip6table_security ip6table_raw ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle iptable_security
iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle bridge ebtable_filter ebtables stp
llc ip6table_filter ip6_tables iptable_filter it87 hwmon_vid
saa7134_alsa kvm_amd kvm saa7134 snd_hda_codec_hdmi irqbypass
snd_hda_codec_realtek tveeprom snd_hda_codec_generic crct10dif_pclmul
[ 3825.605270]  crc32_pclmul rc_core ghash_clmulni_intel snd_hda_intel
aesni_intel snd_hda_codec v4l2_common videobuf2_dma_sg aes_x86_64 lrw
gf128mul evdev snd_hda_core videobuf2_memops glue_helper
videobuf2_v4l2 mac_hid videobuf2_core mxm_wmi videodev r8169
ablk_helper snd_hwdep snd_pcm cryptd pcspkr media fam15h_power mii
k10temp snd_timer sp5100_tco snd tpm_infineon acpi_cpufreq button
tpm_tis tpm_tis_core wmi i2c_piix4 tpm i2c_core shpchp soundcore nfsd
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc sch_fq_codel btrfs
xor zlib_deflate raid6_pq sd_mod ata_generic pata_acpi ohci_pci
serio_raw atkbd libps2 firewire_ohci firewire_core crc_itu_t xhci_pci
xhci_hcd pata_atiixp ohci_hcd ehci_pci ehci_hcd usbcore ahci libahci
usb_common i8042 serio mvsas libsas scsi_transport_sas libata scsi_mod
crc32c_generic
[ 3825.605313]  crc32c_intel vfat fat ip_tables x_tables
[ 3825.605318] CPU: 5 PID: 15736 Comm: kworker/u16:0 Tainted: G
W       4.8.11-ARCH-dirty #1
[ 3825.605319] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 3825.605337] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 3825.605339]  0000000000000286 00000000e1e4b79b ffff8804dc05fa88
ffffffff812e9a00
[ 3825.605342]  ffff8804dc05fad8 0000000000000000 ffff8804dc05fac8
ffffffff8107bcab
[ 3825.605345]  00001b2700378c3a 0000009626bbf000 00000000fffffffe
ffff88060af40140
[ 3825.605348] Call Trace:
[ 3825.605351]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[ 3825.605354]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[ 3825.605356]  [<ffffffff8107bd2f>] warn_slowpath_fmt+0x5f/0x80
[ 3825.605371]  [<ffffffffa02ea145>]
__btrfs_free_extent.isra.33+0x995/0xca0 [btrfs]
[ 3825.605388]  [<ffffffffa035adef>] ? find_ref_head+0x6f/0x80 [btrfs]
[ 3825.605402]  [<ffffffffa02ee3b0>]
__btrfs_run_delayed_refs+0x5b0/0x12e0 [btrfs]
[ 3825.605418]  [<ffffffffa02f21a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[ 3825.605433]  [<ffffffffa02f2434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[ 3825.605451]  [<ffffffffa033de9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 3825.605471]  [<ffffffffa033e19e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[ 3825.605474]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 3825.605477]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 3825.605479]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3825.605481]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3825.605484]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 3825.605486]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 3825.605489]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 3825.605492]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 3825.605494] ---[ end trace b9ac501b3586974f ]---
[ 3825.605497] BTRFS: error (device sdd) in __btrfs_free_extent:6951:
errno=-2 No such entry
[ 3825.605551] BTRFS info (device sdd): forced readonly
[ 3825.605554] BTRFS: error (device sdd) in
btrfs_run_delayed_refs:2960: errno=-2 No such entry
[ 3825.625986] ------------[ cut here ]------------
[ 3825.626012] WARNING: CPU: 4 PID: 15835 at
/mnt/linux/fs/btrfs/delayed-ref.c:378
btrfs_select_ref_head+0x116/0x130 [btrfs]
[ 3825.626013] Modules linked in: arc4 md4 hmac nls_utf8 cifs
dns_resolver fscache nls_iso8859_4 nls_cp775 xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun cfg80211 rfkill
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_tcpudp xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ip_set nfnetlink ebtable_broute ebtable_nat
ip6table_security ip6table_raw ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle iptable_security
iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle bridge ebtable_filter ebtables stp
llc ip6table_filter ip6_tables iptable_filter it87 hwmon_vid
saa7134_alsa kvm_amd kvm saa7134 snd_hda_codec_hdmi irqbypass
snd_hda_codec_realtek tveeprom snd_hda_codec_generic crct10dif_pclmul
[ 3825.626052]  crc32_pclmul rc_core ghash_clmulni_intel snd_hda_intel
aesni_intel snd_hda_codec v4l2_common videobuf2_dma_sg aes_x86_64 lrw
gf128mul evdev snd_hda_core videobuf2_memops glue_helper
videobuf2_v4l2 mac_hid videobuf2_core mxm_wmi videodev r8169
ablk_helper snd_hwdep snd_pcm cryptd pcspkr media fam15h_power mii
k10temp snd_timer sp5100_tco snd tpm_infineon acpi_cpufreq button
tpm_tis tpm_tis_core wmi i2c_piix4 tpm i2c_core shpchp soundcore nfsd
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc sch_fq_codel btrfs
xor zlib_deflate raid6_pq sd_mod ata_generic pata_acpi ohci_pci
serio_raw atkbd libps2 firewire_ohci firewire_core crc_itu_t xhci_pci
xhci_hcd pata_atiixp ohci_hcd ehci_pci ehci_hcd usbcore ahci libahci
usb_common i8042 serio mvsas libsas scsi_transport_sas libata scsi_mod
crc32c_generic
[ 3825.626100]  crc32c_intel vfat fat ip_tables x_tables
[ 3825.626106] CPU: 4 PID: 15835 Comm: kworker/u16:3 Tainted: G
W       4.8.11-ARCH-dirty #1
[ 3825.626107] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 3825.626124] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 3825.626127]  0000000000000286 00000000b1b1b86a ffff8804dc183ba0
ffffffff812e9a00
[ 3825.626130]  0000000000000000 0000000000000000 ffff8804dc183be0
ffffffff8107bcab
[ 3825.626133]  0000017a11b750a0 ffff880470587ba0 ffff880526f815f0
0000000000000000
[ 3825.626136] Call Trace:
[ 3825.626140]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[ 3825.626143]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[ 3825.626146]  [<ffffffff8107bddd>] warn_slowpath_null+0x1d/0x20
[ 3825.626162]  [<ffffffffa035c376>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[ 3825.626177]  [<ffffffffa02ee09f>]
__btrfs_run_delayed_refs+0x29f/0x12e0 [btrfs]
[ 3825.626193]  [<ffffffffa02f21a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[ 3825.626208]  [<ffffffffa02f2434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[ 3825.626226]  [<ffffffffa033de9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 3825.626243]  [<ffffffffa033e19e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[ 3825.626246]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 3825.626249]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 3825.626251]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3825.626254]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 3825.626257]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 3825.626260]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 3825.626263]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 3825.626264] ---[ end trace b9ac501b35869750 ]---
[ 3825.640888] ------------[ cut here ]------------
[ 3825.640915] WARNING: CPU: 0 PID: 15836 at
/mnt/linux/fs/btrfs/delayed-ref.c:378
btrfs_select_ref_head+0x116/0x130 [btrfs]
[ 3825.640916] Modules linked in: arc4 md4 hmac nls_utf8 cifs
dns_resolver fscache nls_iso8859_4 nls_cp775 xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun cfg80211 rfkill
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_tcpudp xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ip_set nfnetlink ebtable_broute ebtable_nat
ip6table_security ip6table_raw ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle iptable_security
iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle bridge ebtable_filter ebtables stp
llc ip6table_filter ip6_tables iptable_filter it87 hwmon_vid
saa7134_alsa kvm_amd kvm saa7134 snd_hda_codec_hdmi irqbypass
snd_hda_codec_realtek tveeprom snd_hda_codec_generic crct10dif_pclmul
[ 3825.640956]  crc32_pclmul rc_core ghash_clmulni_intel snd_hda_intel
aesni_intel snd_hda_codec v4l2_common videobuf2_dma_sg aes_x86_64 lrw
gf128mul evdev snd_hda_core videobuf2_memops glue_helper
videobuf2_v4l2 mac_hid videobuf2_core mxm_wmi videodev r8169
ablk_helper snd_hwdep snd_pcm cryptd pcspkr media fam15h_power mii
k10temp snd_timer sp5100_tco snd tpm_infineon acpi_cpufreq button
tpm_tis tpm_tis_core wmi i2c_piix4 tpm i2c_core shpchp soundcore nfsd
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc sch_fq_codel btrfs
xor zlib_deflate raid6_pq sd_mod ata_generic pata_acpi ohci_pci
serio_raw atkbd libps2 firewire_ohci firewire_core crc_itu_t xhci_pci
xhci_hcd pata_atiixp ohci_hcd ehci_pci ehci_hcd usbcore ahci libahci
usb_common i8042 serio mvsas libsas scsi_transport_sas libata scsi_mod
crc32c_generic
[ 3825.641005]  crc32c_intel vfat fat ip_tables x_tables
[ 3825.641011] CPU: 0 PID: 15836 Comm: kworker/u16:4 Tainted: G
W       4.8.11-ARCH-dirty #1
[ 3825.641012] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 3825.641030] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 3825.641032]  0000000000000286 00000000c5f919fa ffff8804dc09bba0
ffffffff812e9a00
[ 3825.641035]  0000000000000000 0000000000000000 ffff8804dc09bbe0
ffffffff8107bcab
[ 3825.641039]  0000017a11b750a0 ffff880470588c30 ffff880526f815f0
0000000000000000
[ 3825.641042] Call Trace:
[ 3825.641046]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[ 3825.641049]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[ 3825.641051]  [<ffffffff8107bddd>] warn_slowpath_null+0x1d/0x20
[ 3825.641068]  [<ffffffffa035c376>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[ 3825.641083]  [<ffffffffa02ee09f>]
__btrfs_run_delayed_refs+0x29f/0x12e0 [btrfs]
[ 3825.641099]  [<ffffffffa02f21a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[ 3825.641114]  [<ffffffffa02f2434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[ 3825.641132]  [<ffffffffa033de9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 3825.641150]  [<ffffffffa033e19e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[ 3825.641153]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 3825.641156]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 3825.641158]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3825.641162]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 3825.641164]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 3825.641167]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 3825.641170]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 3825.641172] ---[ end trace b9ac501b35869751 ]---
[ 3825.652047] ------------[ cut here ]------------
[ 3825.652072] WARNING: CPU: 4 PID: 15973 at
/mnt/linux/fs/btrfs/delayed-ref.c:378
btrfs_select_ref_head+0x116/0x130 [btrfs]
[ 3825.652073] Modules linked in: arc4 md4 hmac nls_utf8 cifs
dns_resolver fscache nls_iso8859_4 nls_cp775 xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun cfg80211 rfkill
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_tcpudp xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ip_set nfnetlink ebtable_broute ebtable_nat
ip6table_security ip6table_raw ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle iptable_security
iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle bridge ebtable_filter ebtables stp
llc ip6table_filter ip6_tables iptable_filter it87 hwmon_vid
saa7134_alsa kvm_amd kvm saa7134 snd_hda_codec_hdmi irqbypass
snd_hda_codec_realtek tveeprom snd_hda_codec_generic crct10dif_pclmul
[ 3825.652113]  crc32_pclmul rc_core ghash_clmulni_intel snd_hda_intel
aesni_intel snd_hda_codec v4l2_common videobuf2_dma_sg aes_x86_64 lrw
gf128mul evdev snd_hda_core videobuf2_memops glue_helper
videobuf2_v4l2 mac_hid videobuf2_core mxm_wmi videodev r8169
ablk_helper snd_hwdep snd_pcm cryptd pcspkr media fam15h_power mii
k10temp snd_timer sp5100_tco snd tpm_infineon acpi_cpufreq button
tpm_tis tpm_tis_core wmi i2c_piix4 tpm i2c_core shpchp soundcore nfsd
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc sch_fq_codel btrfs
xor zlib_deflate raid6_pq sd_mod ata_generic pata_acpi ohci_pci
serio_raw atkbd libps2 firewire_ohci firewire_core crc_itu_t xhci_pci
xhci_hcd pata_atiixp ohci_hcd ehci_pci ehci_hcd usbcore ahci libahci
usb_common i8042 serio mvsas libsas scsi_transport_sas libata scsi_mod
crc32c_generic
[ 3825.652160]  crc32c_intel vfat fat ip_tables x_tables
[ 3825.652166] CPU: 4 PID: 15973 Comm: kworker/u16:8 Tainted: G
W       4.8.11-ARCH-dirty #1
[ 3825.652167] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 3825.652185] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 3825.652187]  0000000000000286 00000000b02278ba ffff8804c8057ba0
ffffffff812e9a00
[ 3825.652191]  0000000000000000 0000000000000000 ffff8804c8057be0
ffffffff8107bcab
[ 3825.652194]  0000017a11b750a0 ffff880470587ee0 ffff880526f815f0
0000000000000000
[ 3825.652197] Call Trace:
[ 3825.652201]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[ 3825.652204]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[ 3825.652206]  [<ffffffff8107bddd>] warn_slowpath_null+0x1d/0x20
[ 3825.652223]  [<ffffffffa035c376>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[ 3825.652238]  [<ffffffffa02ee09f>]
__btrfs_run_delayed_refs+0x29f/0x12e0 [btrfs]
[ 3825.652253]  [<ffffffffa02f21a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[ 3825.652269]  [<ffffffffa02f2434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[ 3825.652286]  [<ffffffffa033de9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 3825.652303]  [<ffffffffa033e19e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[ 3825.652307]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 3825.652309]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 3825.652311]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3825.652314]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 3825.652317]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 3825.652320]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 3825.652323]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 3825.652325] ---[ end trace b9ac501b35869752 ]---
[ 3838.353580] BTRFS warning (device sdd): Skipping commit of aborted
transaction.
[ 3838.353584] BTRFS: error (device sdd) in cleanup_transaction:1854:
errno=-2 No such entry
