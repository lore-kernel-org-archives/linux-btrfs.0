Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35028 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdIKT7J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 15:59:09 -0400
Received: by mail-pf0-f175.google.com with SMTP id q76so1874498pfq.2
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 12:59:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccx0zn055v-UK0DUGPO1-xMSNwNfUrMMzeb4vPHn6OLfyQ@mail.gmail.com>
References: <CAFvQSYTj1V5ACny++vHiQR=xcTa9H9F28YRJ1YFbZE1Ls8FSTg@mail.gmail.com>
 <CAMG9ccx0zn055v-UK0DUGPO1-xMSNwNfUrMMzeb4vPHn6OLfyQ@mail.gmail.com>
From: Clemens Eisserer <linuxhippy@gmail.com>
Date: Mon, 11 Sep 2017 21:59:06 +0200
Message-ID: <CAFvQSYTMCGu9X0MspSGa=ebn9zQMYyhtH2+COdVr81mz2sFv0A@mail.gmail.com>
Subject: Re: "Unable to find ref byte nr ...." (4.11 somehow fishy?)
To: Ivan Sizov <sivan606@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,

> I have exactly the same errors, also on 4.11 kernel, but RAID-1 with 4 disks.

After re-formating my backup-disk back in July, I today got exactly
the same error running 4.12.9 (stack trace at the end of the mail)
using the following mount options:
"ro,nosuid,nodev,relatime,compress-force=lzo,space_cache,subvolid=5,subvol=/,user"

All I did was basically using the external disk as a receive target
for btrfs send/receive backups and it was always cleanly unmounted.

As the issues don't seem to generate much interest, I wonder ...
should I stop using btrfs send/receive for my backups?
After all, it in case it works, it works like magic ;)

Best regards, Clemens


[11938.378457] BTRFS: device fsid 51cd0fd0-c96f-43e7-8b72-67ece426840a
devid 1 transid 2840 /dev/dm-1
[11939.426768] BTRFS info (device dm-1): force lzo compression
[11939.426770] BTRFS info (device dm-1): disk space caching is enabled
[11939.426771] BTRFS info (device dm-1): has skinny extents
[11972.529804] ------------[ cut here ]------------
[11972.529865] WARNING: CPU: 1 PID: 10985 at
fs/btrfs/extent-tree.c:6942 __btrfs_free_extent.isra.62+0x1fc/0xdc0
[btrfs]
[11972.529866] Modules linked in: vfat fat uas usb_storage rfcomm ccm
bnep sunrpc btusb btrtl btbcm uvcvideo btintel bluetooth
videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core
videodev ecdh_generic media intel_powerclamp coretemp iTCO_wdt
iTCO_vendor_support arc4 kvm_intel hp_wmi iwldvm sparse_keymap ppdev
mac80211 kvm mei_wdt irqbypass intel_cstate intel_uncore iwlwifi
joydev cfg80211 intel_ips snd_hda_codec_hdmi acpi_cpufreq
snd_hda_codec_idt tpm_infineon snd_hda_codec_generic lpc_ich rfkill
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq wmi
snd_seq_device snd_pcm snd_timer parport_pc parport snd soundcore
hp_accel tpm_tis tpm_tis_core lis3lv02d tpm input_polldev mei_me mei
shpchp binfmt_misc vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE)
vboxdrv(OE) btrfs xor raid6_pq dm_crypt
[11972.529908]  i915 mmc_block bcache crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel i2c_algo_bit serio_raw drm_kms_helper
sdhci_pci sdhci e1000e drm mmc_core ptp pps_core video
[11972.529923] CPU: 1 PID: 10985 Comm: btrfs-cleaner Tainted: G
   OE   4.12.9-300.fc26.x86_64 #1
[11972.529924] Hardware name: Hewlett-Packard HP EliteBook 2540p/7008,
BIOS 68CSU Ver. F.60 11/11/2015
[11972.529925] task: ffff8c7951c2a480 task.stack: ffffb13cc41f0000
[11972.529941] RIP: 0010:__btrfs_free_extent.isra.62+0x1fc/0xdc0 [btrfs]
[11972.529942] RSP: 0018:ffffb13cc41f3bb8 EFLAGS: 00010246
[11972.529944] RAX: 00000000fffffffe RBX: 0000000000000000 RCX: 0000000000000000
[11972.529944] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8c79529f1810
[11972.529945] RBP: ffffb13cc41f3c70 R08: ffff8c79a8984620 R09: 0000000000000061
[11972.529946] R10: 0000000000000000 R11: ffffb13cc41f3b24 R12: 00000011c524c000
[11972.529947] R13: ffff8c7804110000 R14: 00000000fffffffe R15: ffff8c79a8984620
[11972.529949] FS:  0000000000000000(0000) GS:ffff8c79bbc40000(0000)
knlGS:0000000000000000
[11972.529950] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11972.529951] CR2: 00007f908c811020 CR3: 000000008fe09000 CR4: 00000000000006a0
[11972.529952] Call Trace:
[11972.529977]  ? btrfs_merge_delayed_refs+0x63/0x540 [btrfs]
[11972.529996]  ? add_delayed_ref_head.isra.9+0x1d7/0x310 [btrfs]
[11972.530012]  __btrfs_run_delayed_refs+0x791/0x12b0 [btrfs]
[11972.530029]  btrfs_run_delayed_refs+0x6b/0x270 [btrfs]
[11972.530045]  ? walk_up_tree+0xed/0x210 [btrfs]
[11972.530061]  btrfs_should_end_transaction+0x55/0x60 [btrfs]
[11972.530076]  btrfs_drop_snapshot+0x3db/0x8c0 [btrfs]
[11972.530093]  btrfs_clean_one_deleted_snapshot+0xc1/0x110 [btrfs]
[11972.530111]  cleaner_kthread+0x14a/0x180 [btrfs]
[11972.530117]  kthread+0x125/0x140
[11972.530132]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[11972.530134]  ? kthread_park+0x60/0x60
[11972.530140]  ret_from_fork+0x25/0x30
[11972.530141] Code: ff 75 10 4c 89 e1 48 c7 45 a0 00 00 00 00 e8 cc
d4 ff ff 41 89 c6 58 5a 45 85 f6 0f 84 84 00 00 00 41 83 fe fe 0f 85
06 ff ff ff <0f> ff 49 8b 37 4c 89 ef e8 a7 ec 00 00 4c 8b 4d 10 4c 8b
85 78
[11972.530166] ---[ end trace ed0da2429768f973 ]---
[11972.530172] BTRFS info (device dm-1): leaf 60489728 total ptrs 119
free space 8598
[11972.530174]     item 0 key (76321669120 169 0) itemoff 16250 itemsize 33
[11972.530175]         extent refs 1 gen 1541 flags 258
[11972.530176]         shared block backref parent 76328681472
[11972.530177]     item 1 key (76321685504 169 0) itemoff 16217 itemsize 33
[11972.530178]         extent refs 1 gen 1541 flags 258
[11972.530179]         shared block backref parent 76328681472
[11972.530179]     item 2 key (76321701888 169 0) itemoff 16184 itemsize 33
[11972.530180]         extent refs 1 gen 1541 flags 258
[11972.530181]         shared block backref parent 76328681472
[11972.530181]     item 3 key (76321718272 169 0) itemoff 16151 itemsize 33
[11972.530182]         extent refs 1 gen 1541 flags 258
[11972.530182]         shared block backref parent 76328681472
[11972.530183]     item 4 key (76321734656 169 0) itemoff 16118 itemsize 33
[11972.530184]         extent refs 1 gen 1541 flags 258
[11972.530184]         shared block backref parent 76328681472
[11972.530185]     item 5 key (76321751040 169 0) itemoff 16085 itemsize 33
[11972.530186]         extent refs 1 gen 1541 flags 258
[11972.530186]         shared block backref parent 76328681472
[11972.530187]     item 6 key (76321767424 169 0) itemoff 16052 itemsize 33
[11972.530188]         extent refs 1 gen 1541 flags 258
[11972.530188]         shared block backref parent 76328681472
[11972.530189]     item 7 key (76321783808 169 0) itemoff 16019 itemsize 33
[11972.530190]         extent refs 1 gen 1541 flags 258
[11972.530190]         shared block backref parent 76328681472
[11972.530191]     item 8 key (76321800192 169 0) itemoff 15986 itemsize 33
[11972.530192]         extent refs 1 gen 1541 flags 258
[11972.530193]         shared block backref parent 76328681472
[11972.530194]     item 9 key (76321816576 169 0) itemoff 15953 itemsize 33
[11972.530195]         extent refs 1 gen 1541 flags 258
[11972.530195]         shared block backref parent 76328681472
[11972.530197]     item 10 key (76321832960 169 0) itemoff 15920 itemsize 33
[11972.530198]         extent refs 1 gen 1541 flags 258
[11972.530198]         shared block backref parent 76328681472
[11972.530200]     item 11 key (76321849344 169 0) itemoff 15887 itemsize 33
[11972.530200]         extent refs 1 gen 1541 flags 258
[11972.530201]         shared block backref parent 76328681472
[11972.530202]     item 12 key (76321865728 169 0) itemoff 15854 itemsize 33
[11972.530203]         extent refs 1 gen 1541 flags 258
[11972.530203]         shared block backref parent 76328681472
[11972.530204]     item 13 key (76321882112 169 0) itemoff 15749 itemsize 105
[11972.530205]         extent refs 9 gen 1687 flags 258
[11972.530206]         tree block backref root 622
[11972.530206]         shared block backref parent 215764484096
[11972.530207]         shared block backref parent 215534108672
[11972.530207]         shared block backref parent 156403171328
[11972.530208]         shared block backref parent 143508340736
[11972.530208]         shared block backref parent 108430950400
[11972.530209]         shared block backref parent 108166725632
[11972.530209]         shared block backref parent 76354371584
[11972.530210]         shared block backref parent 555204608
[11972.530211]     item 14 key (76321898496 169 0) itemoff 15644 itemsize 105
[11972.530212]         extent refs 9 gen 1687 flags 258
[11972.530212]         tree block backref root 622
[11972.530213]         shared block backref parent 215764484096
[11972.530213]         shared block backref parent 215534108672
[11972.530214]         shared block backref parent 156403171328
[11972.530214]         shared block backref parent 143508340736
[11972.530215]         shared block backref parent 108430950400
[11972.530215]         shared block backref parent 108166725632
[11972.530215]         shared block backref parent 76354371584
[11972.530216]         shared block backref parent 555204608
[11972.530217]     item 15 key (76321914880 169 0) itemoff 15539 itemsize 105
[11972.530218]         extent refs 9 gen 1687 flags 258
[11972.530218]         tree block backref root 622
[11972.530219]         shared block backref parent 215764484096
[11972.530219]         shared block backref parent 215534108672
[11972.530220]         shared block backref parent 156403171328
[11972.530220]         shared block backref parent 143508340736
[11972.530220]         shared block backref parent 108430950400
[11972.530221]         shared block backref parent 108166725632
[11972.530221]         shared block backref parent 76354371584
[11972.530222]         shared block backref parent 555204608
[11972.530223]     item 16 key (76321931264 169 0) itemoff 15434 itemsize 105
[11972.530224]         extent refs 9 gen 1687 flags 258
[11972.530224]         tree block backref root 622
[11972.530225]         shared block backref parent 215764484096
[11972.530225]         shared block backref parent 215534108672
[11972.530225]         shared block backref parent 156403171328
[11972.530226]         shared block backref parent 143508340736
[11972.530226]         shared block backref parent 108430950400
[11972.530227]         shared block backref parent 108166725632
[11972.530227]         shared block backref parent 76354371584
[11972.530228]         shared block backref parent 555204608
[11972.530229]     item 17 key (76321947648 169 0) itemoff 15329 itemsize 105
[11972.530229]         extent refs 9 gen 1687 flags 258
[11972.530230]         tree block backref root 622
[11972.530230]         shared block backref parent 215764484096
[11972.530231]         shared block backref parent 215534108672
[11972.530231]         shared block backref parent 156403171328
[11972.530232]         shared block backref parent 143508340736
[11972.530232]         shared block backref parent 108430950400
[11972.530233]         shared block backref parent 108166725632
[11972.530233]         shared block backref parent 76354371584
[11972.530234]         shared block backref parent 555204608
[11972.530235]     item 18 key (76321964032 169 1) itemoff 15089 itemsize 240
[11972.530236]         extent refs 24 gen 1541 flags 258
[11972.530236]         tree block backref root 616
[11972.530237]         tree block backref root 598
[11972.530237]         tree block backref root 593
[11972.530238]         tree block backref root 587
[11972.530238]         tree block backref root 574
[11972.530239]         tree block backref root 556
[11972.530240]         tree block backref root 549
[11972.530240]         tree block backref root 540
[11972.530241]         tree block backref root 536
[11972.530241]         tree block backref root 527
[11972.530241]         tree block backref root 506
[11972.530242]         tree block backref root 479
[11972.530242]         tree block backref root 473
[11972.530243]         tree block backref root 450
[11972.530243]         tree block backref root 440
[11972.530244]         tree block backref root 435
[11972.530244]         tree block backref root 427
[11972.530245]         tree block backref root 422
[11972.530245]         tree block backref root 417
[11972.530246]         tree block backref root 411
[11972.530246]         tree block backref root 404
[11972.530247]         tree block backref root 397
[11972.530247]         tree block backref root 393
[11972.530248]         tree block backref root 370
[11972.530249]     item 19 key (76321980416 169 0) itemoff 14984 itemsize 105
[11972.530250]         extent refs 9 gen 1689 flags 258
[11972.530250]         tree block backref root 622
[11972.530251]         shared block backref parent 215765073920
[11972.530251]         shared block backref parent 215534190592
[11972.530252]         shared block backref parent 156404858880
[11972.530253]         shared block backref parent 143509585920
[11972.530254]         shared block backref parent 108433981440
[11972.530254]         shared block backref parent 108168609792
[11972.530255]         shared block backref parent 76376768512
[11972.530255]         shared block backref parent 557236224
[11972.530256]     item 20 key (76321996800 169 0) itemoff 14951 itemsize 33
[11972.530257]         extent refs 1 gen 1541 flags 258
[11972.530258]         shared block backref parent 76328681472
[11972.530259]     item 21 key (76322013184 169 0) itemoff 14918 itemsize 33
[11972.530260]         extent refs 1 gen 1541 flags 258
[11972.530260]         shared block backref parent 76328681472
[11972.530261]     item 22 key (76322029568 169 0) itemoff 14885 itemsize 33
[11972.530262]         extent refs 1 gen 1541 flags 258
[11972.530263]         shared block backref parent 76328681472
[11972.530264]     item 23 key (76322045952 169 0) itemoff 14780 itemsize 105
[11972.530264]         extent refs 9 gen 1689 flags 258
[11972.530265]         tree block backref root 622
[11972.530266]         shared block backref parent 215765073920
[11972.530266]         shared block backref parent 215534190592
[11972.530267]         shared block backref parent 156404858880
[11972.530267]         shared block backref parent 143509585920
[11972.530267]         shared block backref parent 108433981440
[11972.530268]         shared block backref parent 108168609792
[11972.530268]         shared block backref parent 76376768512
[11972.530269]         shared block backref parent 557236224
[11972.530270]     item 24 key (76322062336 169 0) itemoff 14747 itemsize 33
[11972.530271]         extent refs 1 gen 1541 flags 258
[11972.530271]         shared block backref parent 76328681472
[11972.530273]     item 25 key (76322078720 169 0) itemoff 14714 itemsize 33
[11972.530273]         extent refs 1 gen 1541 flags 258
[11972.530274]         shared block backref parent 76328681472
[11972.530275]     item 26 key (76322095104 169 0) itemoff 14681 itemsize 33
[11972.530276]         extent refs 1 gen 1541 flags 258
[11972.530276]         shared block backref parent 76328681472
[11972.530277]     item 27 key (76322111488 169 0) itemoff 14648 itemsize 33
[11972.530278]         extent refs 1 gen 1541 flags 258
[11972.530279]         shared block backref parent 76328681472
[11972.530280]     item 28 key (76322127872 169 0) itemoff 14615 itemsize 33
[11972.530280]         extent refs 1 gen 1541 flags 258
[11972.530281]         shared block backref parent 76328681472
[11972.530282]     item 29 key (76322144256 169 0) itemoff 14582 itemsize 33
[11972.530283]         extent refs 1 gen 1541 flags 258
[11972.530283]         shared block backref parent 76328681472
[11972.530284]     item 30 key (76322160640 169 0) itemoff 14549 itemsize 33
[11972.530285]         extent refs 1 gen 1541 flags 258
[11972.530286]         shared block backref parent 76328681472
[11972.530287]     item 31 key (76322177024 169 0) itemoff 14516 itemsize 33
[11972.530288]         extent refs 1 gen 1541 flags 258
[11972.530289]         shared block backref parent 76328681472
[11972.530290]     item 32 key (76322193408 169 0) itemoff 14483 itemsize 33
[11972.530291]         extent refs 1 gen 1541 flags 258
[11972.530291]         shared block backref parent 76328681472
[11972.530293]     item 33 key (76322209792 169 0) itemoff 14450 itemsize 33
[11972.530294]         extent refs 1 gen 1541 flags 258
[11972.530294]         shared block backref parent 76328681472
[11972.530295]     item 34 key (76322226176 169 0) itemoff 14417 itemsize 33
[11972.530296]         extent refs 1 gen 1541 flags 258
[11972.530297]         shared block backref parent 76328681472
[11972.530298]     item 35 key (76322242560 169 0) itemoff 14384 itemsize 33
[11972.530299]         extent refs 1 gen 1541 flags 258
[11972.530299]         shared block backref parent 76328681472
[11972.530301]     item 36 key (76322258944 169 0) itemoff 14351 itemsize 33
[11972.530302]         extent refs 1 gen 1541 flags 258
[11972.530302]         shared block backref parent 76328681472
[11972.530303]     item 37 key (76322275328 169 0) itemoff 14318 itemsize 33
[11972.530304]         extent refs 1 gen 1541 flags 258
[11972.530305]         shared block backref parent 76328681472
[11972.530306]     item 38 key (76322291712 169 0) itemoff 14285 itemsize 33
[11972.530307]         extent refs 1 gen 1541 flags 258
[11972.530308]         shared block backref parent 76328681472
[11972.530309]     item 39 key (76322308096 169 0) itemoff 14252 itemsize 33
[11972.530310]         extent refs 1 gen 1541 flags 258
[11972.530311]         shared block backref parent 76328681472
[11972.530312]     item 40 key (76322324480 169 0) itemoff 14219 itemsize 33
[11972.530313]         extent refs 1 gen 1541 flags 258
[11972.530314]         shared block backref parent 76328681472
[11972.530315]     item 41 key (76322340864 169 0) itemoff 14186 itemsize 33
[11972.530316]         extent refs 1 gen 1541 flags 258
[11972.530317]         shared block backref parent 76328681472
[11972.530318]     item 42 key (76322357248 169 0) itemoff 14153 itemsize 33
[11972.530319]         extent refs 1 gen 1541 flags 258
[11972.530320]         shared block backref parent 76328681472
[11972.530321]     item 43 key (76322373632 169 0) itemoff 14120 itemsize 33
[11972.530322]         extent refs 1 gen 1541 flags 258
[11972.530322]         shared block backref parent 76328681472
[11972.530324]     item 44 key (76322390016 169 0) itemoff 14087 itemsize 33
[11972.530325]         extent refs 1 gen 1541 flags 258
[11972.530325]         shared block backref parent 76328681472
[11972.530326]     item 45 key (76322406400 169 0) itemoff 14054 itemsize 33
[11972.530327]         extent refs 1 gen 1541 flags 258
[11972.530328]         shared block backref parent 76328681472
[11972.530329]     item 46 key (76322422784 169 0) itemoff 14021 itemsize 33
[11972.530330]         extent refs 1 gen 1541 flags 258
[11972.530331]         shared block backref parent 76328681472
[11972.530332]     item 47 key (76322439168 169 0) itemoff 13988 itemsize 33
[11972.530333]         extent refs 1 gen 1541 flags 258
[11972.530334]         shared block backref parent 76328681472
[11972.530335]     item 48 key (76322455552 169 0) itemoff 13955 itemsize 33
[11972.530336]         extent refs 1 gen 1541 flags 258
[11972.530337]         shared block backref parent 76328681472
[11972.530338]     item 49 key (76322471936 169 0) itemoff 13922 itemsize 33
[11972.530339]         extent refs 1 gen 1541 flags 258
[11972.530339]         shared block backref parent 76328681472
[11972.530340]     item 50 key (76322488320 169 0) itemoff 13889 itemsize 33
[11972.530341]         extent refs 1 gen 1541 flags 258
[11972.530342]         shared block backref parent 76328681472
[11972.530343]     item 51 key (76322504704 169 0) itemoff 13856 itemsize 33
[11972.530343]         extent refs 1 gen 1541 flags 258
[11972.530344]         shared block backref parent 76328681472
[11972.530345]     item 52 key (76322521088 169 0) itemoff 13823 itemsize 33
[11972.530346]         extent refs 1 gen 1541 flags 258
[11972.530346]         shared block backref parent 76328681472
[11972.530348]     item 53 key (76322537472 169 0) itemoff 13790 itemsize 33
[11972.530348]         extent refs 1 gen 1541 flags 258
[11972.530349]         shared block backref parent 76328681472
[11972.530350]     item 54 key (76322553856 169 0) itemoff 13757 itemsize 33
[11972.530351]         extent refs 1 gen 1541 flags 258
[11972.530352]         shared block backref parent 76328681472
[11972.530353]     item 55 key (76322570240 169 0) itemoff 13724 itemsize 33
[11972.530354]         extent refs 1 gen 1541 flags 258
[11972.530354]         shared block backref parent 76328681472
[11972.530356]     item 56 key (76322586624 169 0) itemoff 13691 itemsize 33
[11972.530357]         extent refs 1 gen 1541 flags 258
[11972.530357]         shared block backref parent 76328681472
[11972.530358]     item 57 key (76322603008 169 0) itemoff 13658 itemsize 33
[11972.530359]         extent refs 1 gen 1541 flags 258
[11972.530360]         shared block backref parent 76328681472
[11972.530361]     item 58 key (76322619392 169 0) itemoff 13625 itemsize 33
[11972.530362]         extent refs 1 gen 1541 flags 258
[11972.530362]         shared block backref parent 76328681472
[11972.530363]     item 59 key (76322635776 169 0) itemoff 13592 itemsize 33
[11972.530364]         extent refs 1 gen 1541 flags 258
[11972.530364]         shared block backref parent 76328681472
[11972.530365]     item 60 key (76322652160 169 0) itemoff 13559 itemsize 33
[11972.530366]         extent refs 1 gen 1541 flags 258
[11972.530366]         shared block backref parent 76328681472
[11972.530367]     item 61 key (76322668544 169 0) itemoff 13526 itemsize 33
[11972.530368]         extent refs 1 gen 1541 flags 258
[11972.530368]         shared block backref parent 76328681472
[11972.530369]     item 62 key (76322684928 169 0) itemoff 13493 itemsize 33
[11972.530370]         extent refs 1 gen 1541 flags 258
[11972.530370]         shared block backref parent 76328681472
[11972.530371]     item 63 key (76322701312 169 0) itemoff 13460 itemsize 33
[11972.530371]         extent refs 1 gen 1541 flags 258
[11972.530372]         shared block backref parent 76328681472
[11972.530373]     item 64 key (76322717696 169 0) itemoff 13427 itemsize 33
[11972.530373]         extent refs 1 gen 1541 flags 258
[11972.530374]         shared block backref parent 76328681472
[11972.530375]     item 65 key (76322734080 169 0) itemoff 13394 itemsize 33
[11972.530375]         extent refs 1 gen 1541 flags 258
[11972.530376]         shared block backref parent 76328681472
[11972.530377]     item 66 key (76322750464 169 0) itemoff 13361 itemsize 33
[11972.530378]         extent refs 1 gen 1541 flags 258
[11972.530378]         shared block backref parent 76328681472
[11972.530380]     item 67 key (76322766848 169 0) itemoff 13328 itemsize 33
[11972.530381]         extent refs 1 gen 1541 flags 258
[11972.530381]         shared block backref parent 76328681472
[11972.530382]     item 68 key (76322783232 169 0) itemoff 13295 itemsize 33
[11972.530383]         extent refs 1 gen 1541 flags 258
[11972.530384]         shared block backref parent 76328681472
[11972.530385]     item 69 key (76322799616 169 0) itemoff 13262 itemsize 33
[11972.530386]         extent refs 1 gen 1541 flags 258
[11972.530387]         shared block backref parent 76328681472
[11972.530388]     item 70 key (76322816000 169 0) itemoff 13229 itemsize 33
[11972.530389]         extent refs 1 gen 1541 flags 258
[11972.530389]         shared block backref parent 76328681472
[11972.530390]     item 71 key (76322832384 169 0) itemoff 13196 itemsize 33
[11972.530391]         extent refs 1 gen 1541 flags 258
[11972.530392]         shared block backref parent 76328681472
[11972.530393]     item 72 key (76322848768 169 0) itemoff 13163 itemsize 33
[11972.530394]         extent refs 1 gen 1541 flags 258
[11972.530395]         shared block backref parent 76328681472
[11972.530396]     item 73 key (76322865152 169 0) itemoff 13130 itemsize 33
[11972.530396]         extent refs 1 gen 1541 flags 258
[11972.530397]         shared block backref parent 76328681472
[11972.530398]     item 74 key (76322881536 169 0) itemoff 13097 itemsize 33
[11972.530399]         extent refs 1 gen 1541 flags 258
[11972.530400]         shared block backref parent 76328681472
[11972.530402]     item 75 key (76322897920 169 0) itemoff 13064 itemsize 33
[11972.530402]         extent refs 1 gen 1541 flags 258
[11972.530403]         shared block backref parent 76328681472
[11972.530404]     item 76 key (76322914304 169 0) itemoff 13031 itemsize 33
[11972.530405]         extent refs 1 gen 1541 flags 258
[11972.530405]         shared block backref parent 76328681472
[11972.530406]     item 77 key (76322930688 169 0) itemoff 12998 itemsize 33
[11972.530407]         extent refs 1 gen 1541 flags 258
[11972.530408]         shared block backref parent 76328681472
[11972.530409]     item 78 key (76322947072 169 0) itemoff 12965 itemsize 33
[11972.530409]         extent refs 1 gen 1541 flags 258
[11972.530410]         shared block backref parent 76328681472
[11972.530411]     item 79 key (76322963456 169 0) itemoff 12932 itemsize 33
[11972.530412]         extent refs 1 gen 1541 flags 258
[11972.530412]         shared block backref parent 76328681472
[11972.530413]     item 80 key (76322979840 169 0) itemoff 12899 itemsize 33
[11972.530414]         extent refs 1 gen 1541 flags 258
[11972.530414]         shared block backref parent 76328681472
[11972.530415]     item 81 key (76322996224 169 0) itemoff 12866 itemsize 33
[11972.530416]         extent refs 1 gen 1541 flags 258
[11972.530416]         shared block backref parent 76328681472
[11972.530417]     item 82 key (76323012608 169 0) itemoff 12833 itemsize 33
[11972.530418]         extent refs 1 gen 1541 flags 258
[11972.530419]         shared block backref parent 76328681472
[11972.530420]     item 83 key (76323028992 169 0) itemoff 12800 itemsize 33
[11972.530420]         extent refs 1 gen 1541 flags 258
[11972.530421]         shared block backref parent 76328681472
[11972.530422]     item 84 key (76323045376 169 0) itemoff 12767 itemsize 33
[11972.530423]         extent refs 1 gen 1541 flags 258
[11972.530423]         shared block backref parent 76328681472
[11972.530424]     item 85 key (76323061760 169 0) itemoff 12734 itemsize 33
[11972.530425]         extent refs 1 gen 1541 flags 258
[11972.530425]         shared block backref parent 76328681472
[11972.530426]     item 86 key (76323078144 169 0) itemoff 12701 itemsize 33
[11972.530427]         extent refs 1 gen 1541 flags 258
[11972.530427]         shared block backref parent 76328681472
[11972.530428]     item 87 key (76323094528 169 0) itemoff 12668 itemsize 33
[11972.530429]         extent refs 1 gen 1541 flags 258
[11972.530430]         shared block backref parent 76328681472
[11972.530431]     item 88 key (76323110912 169 0) itemoff 12635 itemsize 33
[11972.530431]         extent refs 1 gen 1541 flags 258
[11972.530432]         shared block backref parent 76328681472
[11972.530433]     item 89 key (76323127296 169 0) itemoff 12602 itemsize 33
[11972.530433]         extent refs 1 gen 1541 flags 258
[11972.530434]         shared block backref parent 76328681472
[11972.530435]     item 90 key (76323143680 169 0) itemoff 12569 itemsize 33
[11972.530436]         extent refs 1 gen 1541 flags 258
[11972.530436]         shared block backref parent 76328681472
[11972.530437]     item 91 key (76323160064 169 0) itemoff 12536 itemsize 33
[11972.530438]         extent refs 1 gen 1541 flags 258
[11972.530438]         shared block backref parent 76328681472
[11972.530439]     item 92 key (76323176448 169 0) itemoff 12503 itemsize 33
[11972.530440]         extent refs 1 gen 1541 flags 258
[11972.530440]         shared block backref parent 76328681472
[11972.530441]     item 93 key (76323192832 169 0) itemoff 12470 itemsize 33
[11972.530442]         extent refs 1 gen 1541 flags 258
[11972.530443]         shared block backref parent 76328681472
[11972.530444]     item 94 key (76323209216 169 0) itemoff 12437 itemsize 33
[11972.530444]         extent refs 1 gen 1541 flags 258
[11972.530445]         shared block backref parent 76328681472
[11972.530446]     item 95 key (76323225600 169 0) itemoff 12404 itemsize 33
[11972.530447]         extent refs 1 gen 1541 flags 258
[11972.530447]         shared block backref parent 76328681472
[11972.530448]     item 96 key (76323241984 169 0) itemoff 12371 itemsize 33
[11972.530449]         extent refs 1 gen 1541 flags 258
[11972.530449]         shared block backref parent 76328681472
[11972.530450]     item 97 key (76323258368 169 0) itemoff 12338 itemsize 33
[11972.530451]         extent refs 1 gen 1541 flags 258
[11972.530452]         shared block backref parent 76328681472
[11972.530452]     item 98 key (76323274752 169 0) itemoff 12305 itemsize 33
[11972.530453]         extent refs 1 gen 1541 flags 258
[11972.530454]         shared block backref parent 76328681472
[11972.530455]     item 99 key (76323291136 169 0) itemoff 12272 itemsize 33
[11972.530455]         extent refs 1 gen 1541 flags 258
[11972.530456]         shared block backref parent 76328681472
[11972.530457]     item 100 key (76323307520 169 0) itemoff 12239 itemsize 33
[11972.530457]         extent refs 1 gen 1541 flags 258
[11972.530458]         shared block backref parent 76328681472
[11972.530459]     item 101 key (76323323904 169 0) itemoff 12206 itemsize 33
[11972.530460]         extent refs 1 gen 1541 flags 258
[11972.530460]         shared block backref parent 76328681472
[11972.530461]     item 102 key (76323340288 169 0) itemoff 12137 itemsize 69
[11972.530462]         extent refs 5 gen 1877 flags 258
[11972.530462]         shared block backref parent 76271157248
[11972.530463]         shared block backref parent 511655936
[11972.530463]         shared block backref parent 391610368
[11972.530464]         shared block backref parent 386957312
[11972.530464]         shared block backref parent 105381888
[11972.530465]     item 103 key (76323356672 169 0) itemoff 12104 itemsize 33
[11972.530466]         extent refs 1 gen 1541 flags 258
[11972.530466]         shared block backref parent 76328681472
[11972.530467]     item 104 key (76323373056 169 0) itemoff 12035 itemsize 69
[11972.530468]         extent refs 5 gen 1877 flags 258
[11972.530468]         shared block backref parent 76271157248
[11972.530469]         shared block backref parent 511655936
[11972.530469]         shared block backref parent 391610368
[11972.530470]         shared block backref parent 386957312
[11972.530470]         shared block backref parent 105381888
[11972.530471]     item 105 key (76323389440 169 0) itemoff 12002 itemsize 33
[11972.530472]         extent refs 1 gen 1541 flags 258
[11972.530473]         shared block backref parent 76328681472
[11972.530474]     item 106 key (76323405824 169 0) itemoff 11969 itemsize 33
[11972.530474]         extent refs 1 gen 1541 flags 258
[11972.530475]         shared block backref parent 76328681472
[11972.530476]     item 107 key (76323422208 169 0) itemoff 11936 itemsize 33
[11972.530476]         extent refs 1 gen 1541 flags 258
[11972.530477]         shared block backref parent 76328681472
[11972.530478]     item 108 key (76323438592 169 0) itemoff 11903 itemsize 33
[11972.530479]         extent refs 1 gen 1541 flags 258
[11972.530479]         shared block backref parent 76328681472
[11972.530480]     item 109 key (76323454976 169 0) itemoff 11870 itemsize 33
[11972.530481]         extent refs 1 gen 1541 flags 258
[11972.530482]         shared block backref parent 76328681472
[11972.530483]     item 110 key (76323471360 169 0) itemoff 11837 itemsize 33
[11972.530484]         extent refs 1 gen 1541 flags 258
[11972.530485]         shared block backref parent 76328681472
[11972.530486]     item 111 key (76323487744 169 0) itemoff 11804 itemsize 33
[11972.530487]         extent refs 1 gen 1541 flags 258
[11972.530488]         shared block backref parent 76328681472
[11972.530489]     item 112 key (76323504128 169 0) itemoff 11771 itemsize 33
[11972.530490]         extent refs 1 gen 1541 flags 258
[11972.530490]         shared block backref parent 76328681472
[11972.530491]     item 113 key (76323520512 169 0) itemoff 11738 itemsize 33
[11972.530492]         extent refs 1 gen 1541 flags 258
[11972.530493]         shared block backref parent 76328681472
[11972.530494]     item 114 key (76323536896 169 0) itemoff 11705 itemsize 33
[11972.530495]         extent refs 1 gen 1541 flags 258
[11972.530496]         shared block backref parent 76328681472
[11972.530497]     item 115 key (76323553280 169 0) itemoff 11672 itemsize 33
[11972.530497]         extent refs 1 gen 1541 flags 258
[11972.530498]         shared block backref parent 76328681472
[11972.530499]     item 116 key (76323569664 169 0) itemoff 11639 itemsize 33
[11972.530499]         extent refs 1 gen 1541 flags 258
[11972.530500]         shared block backref parent 76328681472
[11972.530501]     item 117 key (76323586048 169 0) itemoff 11606 itemsize 33
[11972.530501]         extent refs 1 gen 1541 flags 258
[11972.530502]         shared block backref parent 76328681472
[11972.530503]     item 118 key (76323602432 169 0) itemoff 11573 itemsize 33
[11972.530503]         extent refs 1 gen 1541 flags 258
[11972.530504]         shared block backref parent 76328681472
[11972.530506] BTRFS error (device dm-1): unable to find ref byte nr
76321964032 parent 0 root 613  owner 1 offset 0
[11972.530510] BTRFS: Transaction aborted (error -2)
[11972.530535] ------------[ cut here ]------------
[11972.530553] WARNING: CPU: 1 PID: 10985 at
fs/btrfs/extent-tree.c:6948 __btrfs_free_extent.isra.62+0x255/0xdc0
[btrfs]
[11972.530554] Modules linked in: vfat fat uas usb_storage rfcomm ccm
bnep sunrpc btusb btrtl btbcm uvcvideo btintel bluetooth
videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core
videodev ecdh_generic media intel_powerclamp coretemp iTCO_wdt
iTCO_vendor_support arc4 kvm_intel hp_wmi iwldvm sparse_keymap ppdev
mac80211 kvm mei_wdt irqbypass intel_cstate intel_uncore iwlwifi
joydev cfg80211 intel_ips snd_hda_codec_hdmi acpi_cpufreq
snd_hda_codec_idt tpm_infineon snd_hda_codec_generic lpc_ich rfkill
snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq wmi
snd_seq_device snd_pcm snd_timer parport_pc parport snd soundcore
hp_accel tpm_tis tpm_tis_core lis3lv02d tpm input_polldev mei_me mei
shpchp binfmt_misc vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE)
vboxdrv(OE) btrfs xor raid6_pq dm_crypt
[11972.530586]  i915 mmc_block bcache crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel i2c_algo_bit serio_raw drm_kms_helper
sdhci_pci sdhci e1000e drm mmc_core ptp pps_core video
[11972.530596] CPU: 1 PID: 10985 Comm: btrfs-cleaner Tainted: G
W  OE   4.12.9-300.fc26.x86_64 #1
[11972.530596] Hardware name: Hewlett-Packard HP EliteBook 2540p/7008,
BIOS 68CSU Ver. F.60 11/11/2015
[11972.530598] task: ffff8c7951c2a480 task.stack: ffffb13cc41f0000
[11972.530615] RIP: 0010:__btrfs_free_extent.isra.62+0x255/0xdc0 [btrfs]
[11972.530616] RSP: 0018:ffffb13cc41f3bb8 EFLAGS: 00010286
[11972.530617] RAX: 0000000000000025 RBX: 0000000000000000 RCX: 0000000000000006
[11972.530617] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff8c79bbc4e120
[11972.530618] RBP: ffffb13cc41f3c70 R08: 0000000000000587 R09: 0000000000000004
[11972.530619] R10: 0000000000000000 R11: 0000000000000001 R12: 00000011c524c000
[11972.530619] R13: ffff8c7804110000 R14: 00000000fffffffe R15: ffff8c79a8984620
[11972.530620] FS:  0000000000000000(0000) GS:ffff8c79bbc40000(0000)
knlGS:0000000000000000
[11972.530621] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11972.530622] CR2: 00007f908c811020 CR3: 000000008fe09000 CR4: 00000000000006a0
[11972.530622] Call Trace:
[11972.530643]  ? btrfs_merge_delayed_refs+0x63/0x540 [btrfs]
[11972.530662]  ? add_delayed_ref_head.isra.9+0x1d7/0x310 [btrfs]
[11972.530677]  __btrfs_run_delayed_refs+0x791/0x12b0 [btrfs]
[11972.530694]  btrfs_run_delayed_refs+0x6b/0x270 [btrfs]
[11972.530708]  ? walk_up_tree+0xed/0x210 [btrfs]
[11972.530728]  btrfs_should_end_transaction+0x55/0x60 [btrfs]
[11972.530760]  btrfs_drop_snapshot+0x3db/0x8c0 [btrfs]
[11972.530781]  btrfs_clean_one_deleted_snapshot+0xc1/0x110 [btrfs]
[11972.530799]  cleaner_kthread+0x14a/0x180 [btrfs]
[11972.530803]  kthread+0x125/0x140
[11972.530822]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[11972.530823]  ? kthread_park+0x60/0x60
[11972.530825]  ret_from_fork+0x25/0x30
[11972.530826] Code: fe ff 48 8b 45 90 48 8b 40 60 f0 0f ba a8 18 ce
00 00 02 0f 92 c0 84 c0 41 59 75 11 44 89 f6 48 c7 c7 60 08 61 c0 e8
fc 02 c6 fb <0f> ff 48 8b 7d 90 b9 fe ff ff ff ba 24 1b 00 00 48 c7 c6
e0 a7
[11972.530854] ---[ end trace ed0da2429768f974 ]---
[11972.530858] BTRFS: error (device dm-1) in __btrfs_free_extent:6948:
errno=-2 No such entry
[11972.530860] BTRFS info (device dm-1): forced readonly
[11972.530866] BTRFS: error (device dm-1) in
btrfs_run_delayed_refs:2971: errno=-2 No such entry


2017-07-31 21:13 GMT+02:00 Ivan Sizov <sivan606@gmail.com>:
> 2017-07-11 21:57 GMT+03:00 Clemens Eisserer <linuxhippy@gmail.com>:
>> Hi,
>>
>> My external drive (single metadata, inline) caused an Ooops recently
>> and went read-only.
>> I wonder, has this something to do with the btrfs issues some have with 4.11?
>>
>> Best regards, Clemens
>>
>> [  619.850316] perf: interrupt took too long (3958 > 3941), lowering
>> kernel.perf_event_max_sample_rate to 50000
>> [  625.656835] ------------[ cut here ]------------
>> [  625.656880] WARNING: CPU: 0 PID: 2919 at
>> fs/btrfs/extent-tree.c:6936 __btrfs_free_extent.isra.61+0x7bf/0xe40
>> [btrfs]
>> [  625.656883] Modules linked in: uas usb_storage rfcomm ccm bnep
>> sunrpc uvcvideo videobuf2_vmalloc videobuf2_memops btusb btrtl
>> videobuf2_v4l2 btbcm btintel videobuf2_core bluetooth videodev media
>> mei_wdt iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp hp_wmi
>> kvm_intel sparse_keymap ppdev snd_hda_codec_hdmi kvm arc4
>> snd_hda_codec_idt snd_hda_codec_generic iwldvm snd_hda_intel mac80211
>> snd_hda_codec irqbypass intel_cstate snd_hda_core intel_uncore iwlwifi
>> snd_hwdep snd_seq snd_seq_device joydev intel_ips snd_pcm cfg80211
>> acpi_cpufreq tpm_infineon snd_timer snd rfkill lpc_ich soundcore
>> shpchp mei_me mei wmi parport_pc parport hp_accel lis3lv02d
>> input_polldev tpm_tis tpm_tis_core tpm binfmt_misc vboxpci(OE)
>> vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) btrfs xor raid6_pq dm_crypt
>> i915 mmc_block bcache
>> [  625.656931]  crct10dif_pclmul crc32_pclmul crc32c_intel
>> ghash_clmulni_intel i2c_algo_bit drm_kms_helper serio_raw sdhci_pci
>> drm e1000e sdhci mmc_core ptp pps_core video
>> [  625.656943] CPU: 0 PID: 2919 Comm: btrfs-cleaner Tainted: G
>>   OE   4.11.8-200.fc25.x86_64 #1
>> [  625.656944] Hardware name: Hewlett-Packard HP EliteBook 2540p/7008,
>> BIOS 68CSU Ver. F.60 11/11/2015
>> [  625.656945] Call Trace:
>> [  625.656952]  dump_stack+0x63/0x86
>> [  625.656955]  __warn+0xcb/0xf0
>> [  625.656956]  warn_slowpath_null+0x1d/0x20
>> [  625.656968]  __btrfs_free_extent.isra.61+0x7bf/0xe40 [btrfs]
>> [  625.656977]  ? btrfs_search_slot+0x429/0x9d0 [btrfs]
>> [  625.656992]  ? btrfs_merge_delayed_refs+0x61/0x6c0 [btrfs]
>> [  625.657002]  __btrfs_run_delayed_refs+0x501/0x12b0 [btrfs]
>> [  625.657017]  ? btrfs_get_token_64+0x105/0x120 [btrfs]
>> [  625.657028]  btrfs_run_delayed_refs+0x8f/0x2a0 [btrfs]
>> [  625.657042]  ? free_extent_buffer+0x4b/0xa0 [btrfs]
>> [  625.657055]  btrfs_should_end_transaction+0x48/0x60 [btrfs]
>> [  625.657066]  btrfs_drop_snapshot+0x3e0/0x920 [btrfs]
>> [  625.657079]  btrfs_clean_one_deleted_snapshot+0xbc/0x100 [btrfs]
>> [  625.657091]  cleaner_kthread+0x133/0x180 [btrfs]
>> [  625.657093]  kthread+0x109/0x140
>> [  625.657105]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
>> [  625.657106]  ? kthread_park+0x90/0x90
>> [  625.657110]  ret_from_fork+0x2c/0x40
>> [  625.657164] ---[ end trace 1c4d5dd9396052ae ]---
>> [  625.657168] BTRFS info (device dm-1): leaf 183797051392 total ptrs
>> 64 free space 186
>> [  625.657172] item 0 key (178663501824 169 0) itemoff 3926 itemsize 69
>> [  625.657173] extent refs 5 gen 1026 flags 258
>> [  625.657174] shared block backref parent 245739773952
>> [  625.657174] shared block backref parent 245673074688
>> [  625.657174] shared block backref parent 181409894400
>> [  625.657175] shared block backref parent 181343162368
>> [  625.657175] shared block backref parent 180773711872
>> [  625.657176] item 1 key (178663505920 168 4096) itemoff 3889 itemsize 37
>> [  625.657177] extent refs 1 gen 1045 flags 1
>> [  625.657177] shared data backref parent 179187650560 count 1
>> [  625.657178] item 2 key (178663510016 168 4096) itemoff 3852 itemsize 37
>> [  625.657179] extent refs 1 gen 1180 flags 1
>> [  625.657180] shared data backref parent 245746434048 count 1
>> [  625.657180] item 3 key (178663514112 169 0) itemoff 3819 itemsize 33
>> [  625.657181] extent refs 1 gen 1098 flags 2
>> [  625.657182] tree block backref root 2
>> [  625.657183] item 4 key (178663518208 168 4096) itemoff 3769 itemsize 50
>> [  625.657183] extent refs 2 gen 1030 flags 1
>> [  625.657184] shared data backref parent 178675068928 count 1
>> [  625.657184] shared data backref parent 178137387008 count 1
>> [  625.657185] item 5 key (178663522304 168 4096) itemoff 3732 itemsize 37
>> [  625.657186] extent refs 1 gen 1053 flags 1
>> [  625.657186] shared data backref parent 180441329664 count 1
>> [  625.657187] item 6 key (178663526400 169 0) itemoff 3555 itemsize 177
>> [  625.657188] extent refs 17 gen 1196 flags 258
>> [  625.657188] shared block backref parent 415361105920
>> [  625.657189] shared block backref parent 415227764736
>> [  625.657189] shared block backref parent 415125512192
>> [  625.657190] shared block backref parent 414450216960
>> [  625.657190] shared block backref parent 414116110336
>> [  625.657190] shared block backref parent 414103474176
>> [  625.657191] shared block backref parent 412705067008
>> [  625.657191] shared block backref parent 412643041280
>> [  625.657192] shared block backref parent 390315855872
>> [  625.657192] shared block backref parent 287440842752
>> [  625.657192] shared block backref parent 287294996480
>> [  625.657193] shared block backref parent 266445434880
>> [  625.657193] shared block backref parent 256855588864
>> [  625.657194] shared block backref parent 256145903616
>> [  625.657194] shared block backref parent 253848592384
>> [  625.657194] shared block backref parent 248051871744
>> [  625.657195] shared block backref parent 245527207936
>> [  625.657196] item 7 key (178663530496 169 2) itemoff 3351 itemsize 204
>> [  625.657196] extent refs 35 gen 1026 flags 258
>> [  625.657197] tree block backref root 736
>> [  625.657197] tree block backref root 730
>> [  625.657198] tree block backref root 726
>> [  625.657198] tree block backref root 721
>> [  625.657198] tree block backref root 717
>> [  625.657199] tree block backref root 603
>> [  625.657199] tree block backref root 599
>> [  625.657200] tree block backref root 591
>> [  625.657200] tree block backref root 585
>> [  625.657201] tree block backref root 579
>> [  625.657201] tree block backref root 570
>> [  625.657201] tree block backref root 556
>> [  625.657202] tree block backref root 543
>> [  625.657202] tree block backref root 539
>> [  625.657203] tree block backref root 532
>> [  625.657203] tree block backref root 523
>> [  625.657203] tree block backref root 517
>> [  625.657204] tree block backref root 513
>> [  625.657204] tree block backref root 453
>> [  625.657205] tree block backref root 444
>> [  625.657206] item 8 key (178663530496 176 740) itemoff 3351 itemsize 0
>> [  625.657206] tree block backref
>> [  625.657207] item 9 key (178663530496 176 745) itemoff 3351 itemsize 0
>> [  625.657207] tree block backref
>> [  625.657208] item 10 key (178663530496 176 750) itemoff 3351 itemsize 0
>> [  625.657209] tree block backref
>> [  625.657209] item 11 key (178663530496 176 754) itemoff 3351 itemsize 0
>> [  625.657210] tree block backref
>> [  625.657211] item 12 key (178663530496 176 758) itemoff 3351 itemsize 0
>> [  625.657211] tree block backref
>> [  625.657212] item 13 key (178663530496 176 762) itemoff 3351 itemsize 0
>> [  625.657212] tree block backref
>> [  625.657213] item 14 key (178663530496 176 766) itemoff 3351 itemsize 0
>> [  625.657213] tree block backref
>> [  625.657214] item 15 key (178663530496 176 770) itemoff 3351 itemsize 0
>> [  625.657214] tree block backref
>> [  625.657215] item 16 key (178663530496 176 774) itemoff 3351 itemsize 0
>> [  625.657215] tree block backref
>> [  625.657216] item 17 key (178663530496 176 778) itemoff 3351 itemsize 0
>> [  625.657217] tree block backref
>> [  625.657217] item 18 key (178663530496 176 782) itemoff 3351 itemsize 0
>> [  625.657218] tree block backref
>> [  625.657219] item 19 key (178663530496 176 786) itemoff 3351 itemsize 0
>> [  625.657219] tree block backref
>> [  625.657220] item 20 key (178663530496 176 790) itemoff 3351 itemsize 0
>> [  625.657220] tree block backref
>> [  625.657221] item 21 key (178663530496 176 794) itemoff 3351 itemsize 0
>> [  625.657221] tree block backref
>> [  625.657222] item 22 key (178663530496 176 799) itemoff 3351 itemsize 0
>> [  625.657222] tree block backref
>> [  625.657223] item 23 key (178663534592 168 4096) itemoff 3314 itemsize 37
>> [  625.657224] extent refs 1 gen 1200 flags 1
>> [  625.657224] shared data backref parent 245976125440 count 1
>> [  625.657225] item 24 key (178663538688 168 4096) itemoff 3264 itemsize 50
>> [  625.657226] extent refs 2 gen 1030 flags 1
>> [  625.657227] shared data backref parent 178675068928 count 1
>> [  625.657227] shared data backref parent 178137387008 count 1
>> [  625.657228] item 25 key (178663542784 168 4096) itemoff 3227 itemsize 37
>> [  625.657229] extent refs 1 gen 1082 flags 1
>> [  625.657229] shared data backref parent 180794540032 count 1
>> [  625.657230] item 26 key (178663546880 168 4096) itemoff 3190 itemsize 37
>> [  625.657231] extent refs 1 gen 1026 flags 1
>> [  625.657231] shared data backref parent 178663501824 count 1
>> [  625.657232] item 27 key (178663550976 168 4096) itemoff 3140 itemsize 50
>> [  625.657233] extent refs 2 gen 1030 flags 1
>> [  625.657233] shared data backref parent 178675068928 count 1
>> [  625.657234] shared data backref parent 178137387008 count 1
>> [  625.657235] item 28 key (178663555072 168 4096) itemoff 3103 itemsize 37
>> [  625.657236] extent refs 1 gen 1045 flags 1
>> [  625.657236] shared data backref parent 179187650560 count 1
>> [  625.657237] item 29 key (178663559168 168 4096) itemoff 3014 itemsize 89
>> [  625.657238] extent refs 5 gen 1026 flags 1
>> [  625.657238] shared data backref parent 286873866240 count 1
>> [  625.657239] shared data backref parent 286709125120 count 1
>> [  625.657239] shared data backref parent 277393047552 count 1
>> [  625.657240] shared data backref parent 252206927872 count 1
>> [  625.657240] shared data backref parent 178663501824 count 1
>> [  625.657241] item 30 key (178663563264 168 12288) itemoff 2977 itemsize 37
>> [  625.657242] extent refs 1 gen 1045 flags 1
>> [  625.657243] shared data backref parent 178586718208 count 1
>> [  625.657243] item 31 key (178663575552 168 4096) itemoff 2940 itemsize 37
>> [  625.657244] extent refs 1 gen 1051 flags 1
>> [  625.657245] shared data backref parent 179476021248 count 1
>> [  625.657246] item 32 key (178663579648 168 4096) itemoff 2903 itemsize 37
>> [  625.657246] extent refs 1 gen 1051 flags 1
>> [  625.657247] shared data backref parent 179476004864 count 1
>> [  625.657248] item 33 key (178663583744 168 4096) itemoff 2762 itemsize 141
>> [  625.657248] extent refs 9 gen 1026 flags 1
>> [  625.657249] shared data backref parent 257500905472 count 1
>> [  625.657249] shared data backref parent 252206936064 count 1
>> [  625.657250] shared data backref parent 252042674176 count 1
>> [  625.657251] shared data backref parent 251875823616 count 1
>> [  625.657251] shared data backref parent 245744291840 count 1
>> [  625.657252] shared data backref parent 245673230336 count 1
>> [  625.657252] shared data backref parent 181503750144 count 1
>> [  625.657253] shared data backref parent 181342941184 count 1
>> [  625.657253] shared data backref parent 178663804928 count 1
>> [  625.657254] item 34 key (178663587840 168 4096) itemoff 2712 itemsize 50
>> [  625.657255] extent refs 2 gen 1030 flags 1
>> [  625.657255] shared data backref parent 178675068928 count 1
>> [  625.657256] shared data backref parent 178137387008 count 1
>> [  625.657257] item 35 key (178663591936 168 4096) itemoff 2675 itemsize 37
>> [  625.657257] extent refs 1 gen 1045 flags 1
>> [  625.657258] shared data backref parent 179187650560 count 1
>> [  625.657259] item 36 key (178663596032 168 4096) itemoff 2638 itemsize 37
>> [  625.657259] extent refs 1 gen 1080 flags 1
>> [  625.657260] shared data backref parent 180566806528 count 1
>> [  625.657261] item 37 key (178663600128 168 4096) itemoff 2588 itemsize 50
>> [  625.657262] extent refs 2 gen 1030 flags 1
>> [  625.657262] shared data backref parent 178675068928 count 1
>> [  625.657263] shared data backref parent 178137387008 count 1
>> [  625.657264] item 38 key (178663604224 168 4096) itemoff 2538 itemsize 50
>> [  625.657264] extent refs 2 gen 1030 flags 1
>> [  625.657265] shared data backref parent 178675068928 count 1
>> [  625.657265] shared data backref parent 178137387008 count 1
>> [  625.657266] item 39 key (178663608320 168 4096) itemoff 2501 itemsize 37
>> [  625.657267] extent refs 1 gen 1045 flags 1
>> [  625.657267] shared data backref parent 179187650560 count 1
>> [  625.657268] item 40 key (178663612416 168 4096) itemoff 2464 itemsize 37
>> [  625.657269] extent refs 1 gen 1040 flags 1
>> [  625.657270] shared data backref parent 179144916992 count 1
>> [  625.657270] item 41 key (178663616512 168 4096) itemoff 2427 itemsize 37
>> [  625.657271] extent refs 1 gen 1044 flags 1
>> [  625.657272] shared data backref parent 178580058112 count 1
>> [  625.657273] item 42 key (178663620608 168 4096) itemoff 2234 itemsize 193
>> [  625.657273] extent refs 27 gen 1090 flags 1
>> [  625.657274] shared data backref parent 286832046080 count 1
>> [  625.657274] shared data backref parent 286715400192 count 1
>> [  625.657275] shared data backref parent 286690906112 count 1
>> [  625.657275] shared data backref parent 286672891904 count 1
>> [  625.657276] shared data backref parent 257517543424 count 1
>> [  625.657276] shared data backref parent 253976293376 count 1
>> [  625.657277] shared data backref parent 252231581696 count 1
>> [  625.657277] shared data backref parent 252047101952 count 1
>> [  625.657278] shared data backref parent 248005345280 count 1
>> [  625.657278] shared data backref parent 246456664064 count 1
>> [  625.657279] shared data backref parent 184333676544 count 1
>> [  625.657280] shared data backref parent 184229064704 count 1
>> [  625.657280] shared data backref parent 181164576768 count 1
>> [  625.657281] item 43 key (178663620608 178 3665759692300308034)
>> itemoff 2206 itemsize 28
>> [  625.657283] extent data backref root 797 objectid 564789 offset 53248 count 1
>> [  625.657284] item 44 key (178663620608 184 291363012608) itemoff
>> 2202 itemsize 4
>> [  625.657284] shared data backref count 1
>> [  625.657285] item 45 key (178663620608 184 410261458944) itemoff
>> 2198 itemsize 4
>> [  625.657286] shared data backref count 1
>> [  625.657286] item 46 key (178663620608 184 410405048320) itemoff
>> 2194 itemsize 4
>> [  625.657287] shared data backref count 1
>> [  625.657288] item 47 key (178663620608 184 414798696448) itemoff
>> 2190 itemsize 4
>> [  625.657288] shared data backref count 1
>> [  625.657289] item 48 key (178663620608 184 414805569536) itemoff
>> 2186 itemsize 4
>> [  625.657289] shared data backref count 1
>> [  625.657290] item 49 key (178663620608 184 414906974208) itemoff
>> 2182 itemsize 4
>> [  625.657291] shared data backref count 1
>> [  625.657292] item 50 key (178663620608 184 415082700800) itemoff
>> 2178 itemsize 4
>> [  625.657292] shared data backref count 1
>> [  625.657293] item 51 key (178663620608 184 415170252800) itemoff
>> 2174 itemsize 4
>> [  625.657293] shared data backref count 1
>> [  625.657294] item 52 key (178663620608 184 415185018880) itemoff
>> 2170 itemsize 4
>> [  625.657295] shared data backref count 1
>> [  625.657295] item 53 key (178663620608 184 415186878464) itemoff
>> 2166 itemsize 4
>> [  625.657296] shared data backref count 1
>> [  625.657297] item 54 key (178663620608 184 415188045824) itemoff
>> 2162 itemsize 4
>> [  625.657297] shared data backref count 1
>> [  625.657298] item 55 key (178663620608 184 415272210432) itemoff
>> 2158 itemsize 4
>> [  625.657298] shared data backref count 1
>> [  625.657299] item 56 key (178663620608 184 415298473984) itemoff
>> 2154 itemsize 4
>> [  625.657300] shared data backref count 1
>> [  625.657301] item 57 key (178663624704 169 0) itemoff 2121 itemsize 33
>> [  625.657301] extent refs 1 gen 1048 flags 258
>> [  625.657302] shared block backref parent 180902735872
>> [  625.657303] item 58 key (178663628800 168 4096) itemoff 2045 itemsize 76
>> [  625.657303] extent refs 4 gen 1026 flags 1
>> [  625.657304] shared data backref parent 252206940160 count 1
>> [  625.657304] shared data backref parent 252042711040 count 1
>> [  625.657305] shared data backref parent 184797204480 count 1
>> [  625.657305] shared data backref parent 180623306752 count 1
>> [  625.657306] item 59 key (178663632896 168 4096) itemoff 2008 itemsize 37
>> [  625.657307] extent refs 1 gen 1045 flags 1
>> [  625.657308] shared data backref parent 179187650560 count 1
>> [  625.657308] item 60 key (178663636992 168 4096) itemoff 1932 itemsize 76
>> [  625.657309] extent refs 4 gen 1026 flags 1
>> [  625.657310] shared data backref parent 252206940160 count 1
>> [  625.657310] shared data backref parent 252042711040 count 1
>> [  625.657311] shared data backref parent 184797204480 count 1
>> [  625.657311] shared data backref parent 180623306752 count 1
>> [  625.657312] item 61 key (178663641088 169 0) itemoff 1899 itemsize 33
>> [  625.657313] extent refs 1 gen 1078 flags 2
>> [  625.657313] tree block backref root 7
>> [  625.657314] item 62 key (178663645184 168 4096) itemoff 1862 itemsize 37
>> [  625.657315] extent refs 1 gen 1045 flags 1
>> [  625.657315] shared data backref parent 179187650560 count 1
>> [  625.657316] item 63 key (178663649280 168 4096) itemoff 1786 itemsize 76
>> [  625.657317] extent refs 4 gen 1026 flags 1
>> [  625.657317] shared data backref parent 252206940160 count 1
>> [  625.657318] shared data backref parent 252042711040 count 1
>> [  625.657318] shared data backref parent 184797204480 count 1
>> [  625.657319] shared data backref parent 180623306752 count 1
>> [  625.657321] BTRFS error (device dm-1): unable to find ref byte nr
>> 178663530496 parent 0 root 797  owner 2 offset 0
>> [  625.657325] ------------[ cut here ]------------
>> [  625.657338] WARNING: CPU: 0 PID: 2919 at
>> fs/btrfs/extent-tree.c:6942 __btrfs_free_extent.isra.61+0x821/0xe40
>> [btrfs]
>> [  625.657340] BTRFS: Transaction aborted (error -2)
>> [  625.657340] Modules linked in: uas usb_storage rfcomm ccm bnep
>> sunrpc uvcvideo videobuf2_vmalloc videobuf2_memops btusb btrtl
>> videobuf2_v4l2 btbcm btintel videobuf2_core bluetooth videodev media
>> mei_wdt iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp hp_wmi
>> kvm_intel sparse_keymap ppdev snd_hda_codec_hdmi kvm arc4
>> snd_hda_codec_idt snd_hda_codec_generic iwldvm snd_hda_intel mac80211
>> snd_hda_codec irqbypass intel_cstate snd_hda_core intel_uncore iwlwifi
>> snd_hwdep snd_seq snd_seq_device joydev intel_ips snd_pcm cfg80211
>> acpi_cpufreq tpm_infineon snd_timer snd rfkill lpc_ich soundcore
>> shpchp mei_me mei wmi parport_pc parport hp_accel lis3lv02d
>> input_polldev tpm_tis tpm_tis_core tpm binfmt_misc vboxpci(OE)
>> vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) btrfs xor raid6_pq dm_crypt
>> i915 mmc_block bcache
>> [  625.657365]  crct10dif_pclmul crc32_pclmul crc32c_intel
>> ghash_clmulni_intel i2c_algo_bit drm_kms_helper serio_raw sdhci_pci
>> drm e1000e sdhci mmc_core ptp pps_core video
>> [  625.657371] CPU: 0 PID: 2919 Comm: btrfs-cleaner Tainted: G
>> W  OE   4.11.8-200.fc25.x86_64 #1
>> [  625.657372] Hardware name: Hewlett-Packard HP EliteBook 2540p/7008,
>> BIOS 68CSU Ver. F.60 11/11/2015
>> [  625.657372] Call Trace:
>> [  625.657374]  dump_stack+0x63/0x86
>> [  625.657376]  __warn+0xcb/0xf0
>> [  625.657377]  warn_slowpath_fmt+0x5a/0x80
>> [  625.657390]  __btrfs_free_extent.isra.61+0x821/0xe40 [btrfs]
>> [  625.657401]  ? btrfs_search_slot+0x429/0x9d0 [btrfs]
>> [  625.657416]  ? btrfs_merge_delayed_refs+0x61/0x6c0 [btrfs]
>> [  625.657428]  __btrfs_run_delayed_refs+0x501/0x12b0 [btrfs]
>> [  625.657443]  ? btrfs_get_token_64+0x105/0x120 [btrfs]
>> [  625.657456]  btrfs_run_delayed_refs+0x8f/0x2a0 [btrfs]
>> [  625.657473]  ? free_extent_buffer+0x4b/0xa0 [btrfs]
>> [  625.657486]  btrfs_should_end_transaction+0x48/0x60 [btrfs]
>> [  625.657498]  btrfs_drop_snapshot+0x3e0/0x920 [btrfs]
>> [  625.657512]  btrfs_clean_one_deleted_snapshot+0xbc/0x100 [btrfs]
>> [  625.657527]  cleaner_kthread+0x133/0x180 [btrfs]
>> [  625.657529]  kthread+0x109/0x140
>> [  625.657542]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
>> [  625.657543]  ? kthread_park+0x90/0x90
>> [  625.657545]  ret_from_fork+0x2c/0x40
>> [  625.657546] ---[ end trace 1c4d5dd9396052af ]---
>> [  625.657548] BTRFS: error (device dm-1) in __btrfs_free_extent:6942:
>> errno=-2 No such entry
>> [  625.657550] BTRFS info (device dm-1): forced readonly
>> [  625.657553] BTRFS: error (device dm-1) in
>> btrfs_run_delayed_refs:2961: errno=-2 No such entry
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> I have exactly the same errors, also on 4.11 kernel, but RAID-1 with 4 disks.
> And I can't fix it till two months. Yes, I'm quite a bit lazy and
> didn't have much spare time))
>
> Unfortunately, my last post in mailing list left unanswered:
> https://www.spinics.net/lists/linux-btrfs/msg67681.html
>
> Seems like it's a common problem.
> This answer on StackOverflow contains an output (in "btrfs check")
> which is identical to one in my system:
> https://unix.stackexchange.com/questions/369133/dealing-with-btrfs-ref-backpointer-mismatches-backref-missing/369275
>
> Tomorrow I'll try to run "btrfs check" with 4.12 kernel and progs.
> Maybe someone have a "success story"?
>
>
> --
> Ivan Sizov
