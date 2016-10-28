Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55085 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757449AbcJ1MLF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 08:11:05 -0400
Received: from dibsi.localnet ([79.238.221.28]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0Lz3nU-1cvPeK3BK4-0148Hi for
 <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 14:10:56 +0200
From: Jan Koester <jan.koester@gmx.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: mount error raid6
Date: Fri, 28 Oct 2016 14:10:55 +0200
Message-ID: <2336134.a2Eh0WVdK9@dibsi>
In-Reply-To: <1651074.QXhxzsRz7W@dibsi>
References: <1651074.QXhxzsRz7W@dibsi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sonntag, 25. September 2016 11:25:40 CEST you wrote:
> Hi,
> 
> i got some errors in dmesg if i want to mount my Filesystem,
> 
> uname -a:
> Linux dibsi 4.8.0-040800rc7-generic #201609182130 SMP Mon Sep 19 01:32:13
> UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> 
> dmesg:
> [   71.599464] BTRFS warning (device sde): 'recovery' is deprecated, use
> 'usebackuproot' instead
> [   71.599469] BTRFS info (device sde): trying to use backup root at mount
> time
> [   71.599477] BTRFS info (device sde): disabling disk space caching
> [   71.599487] BTRFS info (device sde): has skinny extents
> [   71.654586] BTRFS error (device sde): parent transid verify failed on
> 2280458645504 wanted 861168 found 860380
> [   71.703142] BTRFS info (device sde): bdev /dev/sda errs: wr 111, rd
> 124642, flush 0, corrupt 0, gen 0
> [   71.752921] BTRFS error (device sde): parent transid verify failed on
> 2280389693440 wanted 861168 found 860380
> [   71.772571] BTRFS error (device sde): parent transid verify failed on
> 2280389709824 wanted 861168 found 860380
> [   71.785304] BTRFS info (device sde): checking UUID tree
> [   71.853116] BTRFS error (device sde): parent transid verify failed on
> 2280458502144 wanted 861168 found 860380
> [   71.868238] BTRFS error (device sde): parent transid verify failed on
> 2280458506240 wanted 861168 found 860380
> [   71.868488] BTRFS error (device sde): parent transid verify failed on
> 2280458510336 wanted 861168 found 860380
> [   71.868977] BTRFS error (device sde): parent transid verify failed on
> 2280458620928 wanted 861168 found 860380
> [   71.869262] BTRFS error (device sde): parent transid verify failed on
> 2280458625024 wanted 861168 found 860380
> [   71.881341] BTRFS error (device sde): parent transid verify failed on
> 2280458629120 wanted 861168 found 860380
> [   71.926156] BTRFS error (device sde): parent transid verify failed on
> 2280458633216 wanted 861168 found 860380
> [  101.960210] ------------[ cut here ]------------
> [  101.960277] WARNING: CPU: 0 PID: 2850 at /home/kernel/COD/linux/fs/btrfs/
> extent-tree.c:6948 __btrfs_free_extent.isra.71+0x85a/0xd40 [btrfs] [ 
> 101.960293] Modules linked in: binfmt_misc crc32c_generic btrfs xor
> raid6_pq kvm_amd kvm irqbypass snd_hda_codec_hdmi serio_raw snd_hda_intel
> snd_hda_codec k10temp snd_usb_audio snd_hda_core joydev snd_usbmidi_lib
> snd_seq_midi snd_seq_midi_event snd_hwdep snd_ctxfi snd_rawmidi snd_pcm
> snd_seq snd_seq_device i2c_piix4 snd_timer snd tpm_infineon sg soundcore
> evdev shpchp acpi_cpufreq tpm_tis tpm_tis_core tpm parport_pc ppdev sunrpc
> lp parport autofs4 ext4 crc16 jbd2 fscrypto mbcache sd_mod hid_generic
> usbhid hid ohci_pci amdkfd radeon i2c_algo_bit ttm ahci drm_kms_helper
> ohci_hcd xhci_pci libahci syscopyarea ehci_pci xhci_hcd sysfillrect libata
> ehci_hcd sysimgblt fb_sys_fops e1000e usbcore drm scsi_mod r8169 ptp mii
> pps_core usb_common wmi fjes button
> [  101.960395] CPU: 0 PID: 2850 Comm: btrfs-transacti Not tainted
> 4.8.0-040800rc7-generic #201609182130
> [  101.960397] Hardware name: Gigabyte Technology Co., Ltd. GA-970A-D3/
> GA-970A-D3, BIOS F12 09/03/2013
> [  101.960402]  0000000000200286 00000000198bae94 ffffffff9b53fba4
> 0000000000000000
> [  101.960409]  0000000000000000 ffffffff9b27f6ae 000000df39b62000
> ffff883781532d90
> [  101.960415]  00000000fffffffe ffff88376bfd2140 ffff8837c393a000
> 0000000000000000
> [  101.960421] Call Trace:
> [  101.960431]  [<ffffffff9b53fba4>] ? dump_stack+0x5c/0x78
> [  101.960438]  [<ffffffff9b27f6ae>] ? __warn+0xbe/0xe0
> [  101.960484]  [<ffffffffc0df467a>] ?
> __btrfs_free_extent.isra.71+0x85a/0xd40 [btrfs]
> [  101.960527]  [<ffffffffc0deea00>] ? btrfs_previous_extent_item+0xe0/0x100
> [btrfs]
> [  101.960570]  [<ffffffffc0df3af3>] ?
> update_block_group.isra.70+0x133/0x460 [btrfs]
> [  101.960577]  [<ffffffff9b39745c>] ? __set_page_dirty_nobuffers+0xec/0x140
> [  101.960621]  [<ffffffffc0df89b3>] ?
> __btrfs_run_delayed_refs+0x4f3/0x13d0 [btrfs]
> [  101.960668]  [<ffffffffc0dfc86a>] ? btrfs_run_delayed_refs+0x9a/0x2b0
> [btrfs]
> [  101.960673]  [<ffffffff9b237035>] ? sched_clock+0x5/0x10
> [  101.960723]  [<ffffffffc0e13430>] ? btrfs_commit_transaction+0x50/0xa60
> [btrfs]
> [  101.960771]  [<ffffffffc0e13ecf>] ? start_transaction+0x8f/0x4c0 [btrfs]
> [  101.960819]  [<ffffffffc0e0e279>] ? transaction_kthread+0x1e9/0x200
> [btrfs] [  101.960866]  [<ffffffffc0e0e090>] ?
> btrfs_cleanup_transaction+0x5c0/0x5c0 [btrfs]
> [  101.960872]  [<ffffffff9b29efcd>] ? kthread+0xcd/0xf0
> [  101.960877]  [<ffffffff9b22c751>] ? __switch_to+0x2c1/0x7a0
> [  101.960884]  [<ffffffff9b81d55f>] ? ret_from_fork+0x1f/0x40
> [  101.960890]  [<ffffffff9b29ef00>] ? kthread_create_on_node+0x1a0/0x1a0
> [  101.960893] ---[ end trace 413d8788543e689c ]---
> [  101.960900] BTRFS info (device sde): leaf 950359654400 total ptrs 56 free
> space 945
> [  101.960904]  item 0 key (503649468416 168 4096) itemoff 3944 itemsize 51
> [  101.960908]          extent refs 1 gen 861173 flags 2
> [  101.960911]          tree block key (0 0 0) level 0
> [  101.960912]          tree block backref root 7
> [  101.960916]  item 1 key (503649468416 192 1107296256) itemoff 3920
> itemsize 24
> [  101.960918]          block group used 45056
> [  101.960921]  item 2 key (503649484800 168 4096) itemoff 3869 itemsize 51
> [  101.960923]          extent refs 1 gen 861172 flags 2
> [  101.960925]          tree block key (0 0 0) level 0
> [  101.960927]          tree block backref root 7
> [  101.960930]  item 3 key (503649488896 169 1) itemoff 3836 itemsize 33
> [  101.960932]          extent refs 1 gen 861176 flags 2
> [  101.960933]          tree block backref root 1
> [  101.960936]  item 4 key (503649492992 169 1) itemoff 3803 itemsize 33
> [  101.960938]          extent refs 1 gen 861176 flags 2
> [  101.960940]          tree block backref root 2
> [  101.960943]  item 5 key (503649497088 169 0) itemoff 3770 itemsize 33
> [  101.960945]          extent refs 1 gen 861176 flags 2
> [  101.960946]          tree block backref root 2
> [  101.960949]  item 6 key (503649501184 169 0) itemoff 3737 itemsize 33
> [  101.960951]          extent refs 1 gen 861176 flags 2
> [  101.960952]          tree block backref root 1
> [  101.960955]  item 7 key (503649570816 168 4096) itemoff 3686 itemsize 51
> [  101.960958]          extent refs 1 gen 861170 flags 2
> [  101.960960]          tree block key (1065417768960 192 3221225472) level
> 0 [  101.960961]          tree block backref root 2
> [  101.960964]  item 8 key (503649607680 168 4096) itemoff 3635 itemsize 51
> [  101.960966]          extent refs 1 gen 861170 flags 2
> [  101.960969]          tree block key (1316673355776 192 3221225472) level
> 0 [  101.960970]          tree block backref root 2
> [  101.960973]  item 9 key (503649628160 168 4096) itemoff 3584 itemsize 51
> [  101.960975]          extent refs 1 gen 861170 flags 2
> [  101.960977]          tree block key (1446629670912 192 3221225472) level
> 0 [  101.960979]          tree block backref root 2
> [  101.960982]  item 10 key (503649636352 168 4096) itemoff 3533 itemsize 51
> [  101.960984]          extent refs 1 gen 861170 flags 2
> [  101.960986]          tree block key (1707548934144 192 3221225472) level
> 0 [  101.960988]          tree block backref root 2
> [  101.960991]  item 11 key (503649669120 168 4096) itemoff 3482 itemsize 51
> [  101.960993]          extent refs 1 gen 861170 flags 2
> [  101.960995]          tree block key (1966354268160 192 3221225472) level
> 0 [  101.960996]          tree block backref root 2
> [  101.960999]  item 12 key (950359621632 169 4) itemoff 3449 itemsize 33
> [  101.961001]          extent refs 1 gen 861177 flags 2
> [  101.961002]          tree block backref root 5
> [  101.961005]  item 13 key (950359621632 192 1107296256) itemoff 3425
> itemsize 24
> [  101.961007]          block group used 0
> [  101.961010]  item 14 key (950359625728 169 3) itemoff 3392 itemsize 33
> [  101.961012]          extent refs 1 gen 861177 flags 2
> [  101.961013]          tree block backref root 5
> [  101.961016]  item 15 key (950359629824 169 2) itemoff 3359 itemsize 33
> [  101.961018]          extent refs 1 gen 861177 flags 2
> [  101.961019]          tree block backref root 5
> [  101.961022]  item 16 key (950359633920 169 1) itemoff 3326 itemsize 33
> [  101.961024]          extent refs 1 gen 861177 flags 2
> [  101.961025]          tree block backref root 5
> [  101.961028]  item 17 key (950359638016 169 0) itemoff 3293 itemsize 33
> [  101.961030]          extent refs 1 gen 861177 flags 2
> [  101.961032]          tree block backref root 5
> [  101.961035]  item 18 key (950359642112 169 1) itemoff 3260 itemsize 33
> [  101.961036]          extent refs 1 gen 861177 flags 2
> [  101.961038]          tree block backref root 5
> [  101.961041]  item 19 key (950359646208 169 0) itemoff 3227 itemsize 33
> [  101.961043]          extent refs 1 gen 861177 flags 2
> [  101.961044]          tree block backref root 5
> [  101.961047]  item 20 key (950359650304 169 1) itemoff 3194 itemsize 33
> [  101.961049]          extent refs 1 gen 861177 flags 2
> [  101.961050]          tree block backref root 2
> [  101.961053]  item 21 key (950359654400 169 0) itemoff 3161 itemsize 33
> [  101.961055]          extent refs 1 gen 861177 flags 2
> [  101.961056]          tree block backref root 2
> [  101.961059]  item 22 key (951466917888 192 1107296256) itemoff 3137
> itemsize 24
> [  101.961061]          block group used 0
> [  101.961064]  item 23 key (952574214144 192 100663296) itemoff 3113
> itemsize 24
> [  101.961065]          block group used 0
> [  101.961068]  item 24 key (952674877440 192 3221225472) itemoff 3089
> itemsize 24
> [  101.961069]          block group used 0
> [  101.961072]  item 25 key (955896102912 192 3221225472) itemoff 3065
> itemsize 24
> [  101.961073]          block group used 0
> [  101.961076]  item 26 key (959117328384 192 3221225472) itemoff 3041
> itemsize 24
> [  101.961078]          block group used 0
> [  101.961081]  item 27 key (962338553856 192 3221225472) itemoff 3017
> itemsize 24
> [  101.961082]          block group used 0
> [  101.961085]  item 28 key (965559779328 192 3221225472) itemoff 2993
> itemsize 24
> [  101.961086]          block group used 0
> [  101.961089]  item 29 key (968781004800 192 3221225472) itemoff 2969
> itemsize 24
> [  101.961090]          block group used 0
> [  101.961093]  item 30 key (972002230272 192 3221225472) itemoff 2945
> itemsize 24
> [  101.961095]          block group used 0
> [  101.961098]  item 31 key (975223455744 192 3221225472) itemoff 2921
> itemsize 24
> [  101.961099]          block group used 0
> [  101.961102]  item 32 key (978444681216 192 3221225472) itemoff 2897
> itemsize 24
> [  101.961103]          block group used 0
> [  101.961106]  item 33 key (981665906688 192 3221225472) itemoff 2873
> itemsize 24
> [  101.961107]          block group used 0
> [  101.961110]  item 34 key (984887132160 192 3221225472) itemoff 2849
> itemsize 24
> [  101.961112]          block group used 0
> [  101.961114]  item 35 key (988108357632 192 3221225472) itemoff 2825
> itemsize 24
> [  101.961116]          block group used 0
> [  101.961119]  item 36 key (991329583104 192 3221225472) itemoff 2801
> itemsize 24
> [  101.961120]          block group used 0
> [  101.961123]  item 37 key (994550808576 192 3221225472) itemoff 2777
> itemsize 24
> [  101.961124]          block group used 0
> [  101.961127]  item 38 key (997772034048 192 3221225472) itemoff 2753
> itemsize 24
> [  101.961128]          block group used 0
> [  101.961131]  item 39 key (1000993259520 192 3221225472) itemoff 2729
> itemsize 24
> [  101.961133]          block group used 0
> [  101.961136]  item 40 key (1004214484992 192 3221225472) itemoff 2705
> itemsize 24
> [  101.961137]          block group used 0
> [  101.961140]  item 41 key (1007435710464 192 3221225472) itemoff 2681
> itemsize 24
> [  101.961141]          block group used 0
> [  101.961144]  item 42 key (1010656935936 192 3221225472) itemoff 2657
> itemsize 24
> [  101.961146]          block group used 0
> [  101.961149]  item 43 key (1013878161408 192 3221225472) itemoff 2633
> itemsize 24
> [  101.961150]          block group used 0
> [  101.961153]  item 44 key (1017099386880 192 3221225472) itemoff 2609
> itemsize 24
> [  101.961154]          block group used 0
> [  101.961157]  item 45 key (1020320612352 192 3221225472) itemoff 2585
> itemsize 24
> [  101.961158]          block group used 0
> [  101.961161]  item 46 key (1023541837824 192 3221225472) itemoff 2561
> itemsize 24
> [  101.961163]          block group used 0
> [  101.961166]  item 47 key (1026763063296 192 3221225472) itemoff 2537
> itemsize 24
> [  101.961167]          block group used 0
> [  101.961170]  item 48 key (1029984288768 192 3221225472) itemoff 2513
> itemsize 24
> [  101.961171]          block group used 0
> [  101.961174]  item 49 key (1033205514240 192 3221225472) itemoff 2489
> itemsize 24
> [  101.961175]          block group used 0
> [  101.961178]  item 50 key (1036426739712 192 3221225472) itemoff 2465
> itemsize 24
> [  101.961179]          block group used 0
> [  101.961182]  item 51 key (1039647965184 192 3221225472) itemoff 2441
> itemsize 24
> [  101.961184]          block group used 0
> [  101.961187]  item 52 key (1042869190656 192 3221225472) itemoff 2417
> itemsize 24
> [  101.961188]          block group used 0
> [  101.961191]  item 53 key (1046090416128 192 3221225472) itemoff 2393
> itemsize 24
> [  101.961192]          block group used 0
> [  101.961195]  item 54 key (1049311641600 192 3221225472) itemoff 2369
> itemsize 24
> [  101.961196]          block group used 0
> [  101.961199]  item 55 key (1052532867072 192 3221225472) itemoff 2345
> itemsize 24
> [  101.961201]          block group used 0
> [  101.961205] BTRFS error (device sde): unable to find ref byte nr
> 958745944064 parent 0 root 5  owner 18689154 offset 0
> [  101.961213] ------------[ cut here ]------------
> [  101.961258] WARNING: CPU: 0 PID: 2850 at /home/kernel/COD/linux/fs/btrfs/
> extent-tree.c:6954 __btrfs_free_extent.isra.71+0xa33/0xd40 [btrfs] [ 
> 101.961260] BTRFS: Transaction aborted (error -2)
> [  101.961261] Modules linked in: binfmt_misc crc32c_generic btrfs xor
> raid6_pq kvm_amd kvm irqbypass snd_hda_codec_hdmi serio_raw snd_hda_intel
> snd_hda_codec k10temp snd_usb_audio snd_hda_core joydev snd_usbmidi_lib
> snd_seq_midi snd_seq_midi_event snd_hwdep snd_ctxfi snd_rawmidi snd_pcm
> snd_seq snd_seq_device i2c_piix4 snd_timer snd tpm_infineon sg soundcore
> evdev shpchp acpi_cpufreq tpm_tis tpm_tis_core tpm parport_pc ppdev sunrpc
> lp parport autofs4 ext4 crc16 jbd2 fscrypto mbcache sd_mod hid_generic
> usbhid hid ohci_pci amdkfd radeon i2c_algo_bit ttm ahci drm_kms_helper
> ohci_hcd xhci_pci libahci syscopyarea ehci_pci xhci_hcd sysfillrect libata
> ehci_hcd sysimgblt fb_sys_fops e1000e usbcore drm scsi_mod r8169 ptp mii
> pps_core usb_common wmi fjes button
> [  101.961340] CPU: 0 PID: 2850 Comm: btrfs-transacti Tainted: G        W
> 4.8.0-040800rc7-generic #201609182130
> [  101.961342] Hardware name: Gigabyte Technology Co., Ltd. GA-970A-D3/
> GA-970A-D3, BIOS F12 09/03/2013
> [  101.961344]  0000000000200286 00000000198bae94 ffffffff9b53fba4
> ffff88377d0ebb78
> [  101.961351]  0000000000000000 ffffffff9b27f6ae 000000df39b62000
> ffff88377d0ebbd0
> [  101.961357]  00000000fffffffe ffff88376bfd2140 ffff8837c393a000
> 0000000000000000
> [  101.961363] Call Trace:
> [  101.961369]  [<ffffffff9b53fba4>] ? dump_stack+0x5c/0x78
> [  101.961374]  [<ffffffff9b27f6ae>] ? __warn+0xbe/0xe0
> [  101.961380]  [<ffffffff9b27f72f>] ? warn_slowpath_fmt+0x5f/0x80
> [  101.961424]  [<ffffffffc0df4853>] ?
> __btrfs_free_extent.isra.71+0xa33/0xd40 [btrfs]
> [  101.961467]  [<ffffffffc0deea00>] ? btrfs_previous_extent_item+0xe0/0x100
> [btrfs]
> [  101.961509]  [<ffffffffc0df3af3>] ?
> update_block_group.isra.70+0x133/0x460 [btrfs]
> [  101.961515]  [<ffffffff9b39745c>] ? __set_page_dirty_nobuffers+0xec/0x140
> [  101.961559]  [<ffffffffc0df89b3>] ?
> __btrfs_run_delayed_refs+0x4f3/0x13d0 [btrfs]
> [  101.961605]  [<ffffffffc0dfc86a>] ? btrfs_run_delayed_refs+0x9a/0x2b0
> [btrfs]
> [  101.961610]  [<ffffffff9b237035>] ? sched_clock+0x5/0x10
> [  101.961658]  [<ffffffffc0e13430>] ? btrfs_commit_transaction+0x50/0xa60
> [btrfs]
> [  101.961706]  [<ffffffffc0e13ecf>] ? start_transaction+0x8f/0x4c0 [btrfs]
> [  101.961753]  [<ffffffffc0e0e279>] ? transaction_kthread+0x1e9/0x200
> [btrfs] [  101.961801]  [<ffffffffc0e0e090>] ?
> btrfs_cleanup_transaction+0x5c0/0x5c0 [btrfs]
> [  101.961805]  [<ffffffff9b29efcd>] ? kthread+0xcd/0xf0
> [  101.961810]  [<ffffffff9b22c751>] ? __switch_to+0x2c1/0x7a0
> [  101.961816]  [<ffffffff9b81d55f>] ? ret_from_fork+0x1f/0x40
> [  101.961821]  [<ffffffff9b29ef00>] ? kthread_create_on_node+0x1a0/0x1a0
> [  101.961824] ---[ end trace 413d8788543e689d ]---
> [  101.961829] BTRFS: error (device sde) in __btrfs_free_extent:6954:
> errno=-2 No such entry
> [  101.961834] BTRFS info (device sde): forced readonly
> [  101.961839] BTRFS: error (device sde) in btrfs_run_delayed_refs:2960:
> errno=-2 No such entry
> [  101.961892] pending csums is 4096
> [  105.983553] verify_parent_transid: 2 callbacks suppressed
> [  105.983562] BTRFS error (device sde): parent transid verify failed on
> 2280450908160 wanted 861168 found 860380
> [  106.636854] BTRFS error (device sde): parent transid verify failed on
> 2280409526272 wanted 861168 found 860376
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

also buffer oferflow in chunk-recover:

btrfs rescue chunk-recover /dev/disk/by-uuid/
73d4dc77-6ff3-412f-9b0a-0d11458faf32
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[New Thread 0x7ffff6f6e700 (LWP 2940)]
[New Thread 0x7ffff676d700 (LWP 2941)]
[New Thread 0x7ffff5f6c700 (LWP 2942)]
[New Thread 0x7ffff576b700 (LWP 2943)]
[New Thread 0x7ffff4f6a700 (LWP 2944)]
Scanning: 938721280 in dev0, 842907648 in dev1, 639483904 in dev2, 961396736 
in dev3, 855490560 in dev4                
Thread 5 "btrfs" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff576b700 (LWP 2943)]
btrfs_new_chunk_record (leaf=leaf@entry=0x7fffe00008c0, 
key=key@entry=0x7ffff576ac90, slot=slot@entry=11)
    at cmds-check.c:5153
5153                    rec->stripes[i].devid =
(gdb) bt
#0  btrfs_new_chunk_record (leaf=leaf@entry=0x7fffe00008c0, 
key=key@entry=0x7ffff576ac90, slot=slot@entry=11)
    at cmds-check.c:5153
#1  0x00000000004364b5 in process_chunk_item (slot=11, key=0x7ffff576ac90, 
leaf=0x7fffe00008c0, 
    chunk_cache=0x7fffffffe3a0) at chunk-recover.c:288
#2  extract_metadata_record (rc=rc@entry=0x7fffffffe370, 
leaf=leaf@entry=0x7fffe00008c0) at chunk-recover.c:722
#3  0x0000000000436b09 in scan_one_device (dev_scan_struct=0x6ad530) at chunk-
recover.c:807
#4  0x00007ffff733f6fa in start_thread (arg=0x7ffff576b700) at 
pthread_create.c:333
#5  0x00007ffff7075b5d in clone () at ../sysdeps/unix/sysv/linux/x86_64/
clone.S:109


