Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:45531 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3LEQV2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Dec 2013 11:21:28 -0500
Received: by mail-vc0-f176.google.com with SMTP id lf12so13277018vcb.35
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2013 08:21:27 -0800 (PST)
MIME-Version: 1.0
From: Roman Kapusta <roman.kapusta@gmail.com>
Date: Thu, 5 Dec 2013 17:21:05 +0100
Message-ID: <CABVOS0-BHBzRMTLGM5oPWdf8b-3fejUHWqDAeaVdM1_y8d6yWQ@mail.gmail.com>
Subject: parent transid verify failed (was serious problems with softlockups
 on kernel 3.11.9)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After reverting to previous kernel 3.11.8 two of three btrfs
filesystems works without problem, but third is failing with error:

[  181.060135] parent transid verify failed on 529301504 wanted 99194
found 99193
[  181.076391] parent transid verify failed on 529301504 wanted 99194
found 99193
[  181.076548] btrfs: failed to read log tree
[  181.098670] btrfs: open_ctree failed


On Thu, Dec 5, 2013 at 4:49 PM, Roman Kapusta <roman.kapusta@gmail.com> wrote:
> After each reboot everything works until I try to mount btrfs
> filesystem, then computer hangs for long periods of time. Before
> kernel update things were working right. I'm using Fedora 19.
>
> Follows dmesg output from moment when I try to mount btrfs filesystem
> in dmcrypt:
>
> [  158.994656] xor: measuring software checksum speed
> [  159.010128]    prefetch64-sse:  1696.000 MB/sec
> [  159.025123]    generic_sse:  1580.000 MB/sec
> [  159.030515] xor: using function: prefetch64-sse (1696.000 MB/sec)
> [  159.095168] raid6: sse2x1     546 MB/s
> [  159.117182] raid6: sse2x2     742 MB/s
> [  159.139202] raid6: sse2x4    1082 MB/s
> [  159.144460] raid6: using algorithm sse2x4 (1082 MB/s)
> [  159.149735] raid6: using ssse3x2 recovery algorithm
> [  159.289176] bio: create slab <bio-2> at 2
> [  159.294753] Btrfs loaded
> [  159.299174] device label storage devid 1 transid 99192 /dev/dm-12
> [  161.905671] device label storage devid 2 transid 99192 /dev/dm-13
> [  162.042083] device label storage devid 1 transid 99192 /dev/mapper/l1
> [  162.048629] device label storage devid 2 transid 99192 /dev/mapper/l2
> [  162.068288] device label storage devid 1 transid 99192 /dev/mapper/l1
> [  162.077313] btrfs: disk space caching is enabled
> [  172.800422] BTRFS debug (device dm-13): truncated 1 orphans
> [  172.840403] SELinux: initialized (dev dm-13, type btrfs), uses xattr
> [  175.260338] device label db devid 1 transid 486561 /dev/dm-14
> [  175.377316] device label db devid 1 transid 486561 /dev/mapper/ldb
> [  175.383513] btrfs: disk space caching is enabled
> [  175.658698] SELinux: initialized (dev dm-14, type btrfs), uses xattr
> [  203.394535] nf_conntrack: automatic helper assignment is deprecated
> and it will be removed soon. Use the iptables CT target to attach
> helpers instead.
> [  247.687825] [sched_delayed] sched: RT throttling activated
> [  271.884280] BUG: soft lockup - CPU#1 stuck for 23s! [btrfs-cleaner:1745]
> [  271.887119] Modules linked in: btrfs zlib_deflate raid6_pq
> libcrc32c xor dm_crypt nf_conntrack_netbios_ns nf_conntrack_broadcast
> ipt_MASQUERADE ip6t_REJECT xt_conntrack bnep bluetooth ebtable_nat
> ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat
> nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
> ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
> iptable_mangle iptable_security iptable_raw w83627ehf hwmon_vid radeon
> i2c_algo_bit ttm drm_kms_helper drm snd_hda_codec_realtek
> snd_hda_codec_hdmi snd_hda_intel snd_hda_codec kvm_amd kvm r8169
> snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd
> eeepc_wmi asus_wmi sparse_keymap rfkill video microcode serio_raw
> k10temp mii shpchp
> [  271.903174]  soundcore sp5100_tco i2c_piix4 i2c_core wmi
> acpi_cpufreq mperf uinput firewire_ohci firewire_core crc_itu_t
> [  271.906569] CPU: 1 PID: 1745 Comm: btrfs-cleaner Not tainted
> 3.11.9-200.fc19.x86_64 #1
> [  271.909981] Hardware name: System manufacturer System Product
> Name/E35M1-M, BIOS 0401 02/16/2011
> [  271.913401] task: ffff88021c3c07a0 ti: ffff88020d084000 task.ti:
> ffff88020d084000
> [  271.916830] RIP: 0010:[<ffffffff8164e062>]  [<ffffffff8164e062>]
> _raw_spin_lock+0x22/0x30
> [  271.920304] RSP: 0018:ffff88020d085b70  EFLAGS: 00000297
> [  271.923767] RAX: 00000000000000e6 RBX: ffffffff8164c6ca RCX: 0000000000000000
> [  271.927250] RDX: 00000000000000e7 RSI: 0000000000000050 RDI: ffff880212dde0d0
> [  271.930722] RBP: ffff88020d085b70 R08: 000000000001ad80 R09: ffffffffa057ec44
> [  271.934183] R10: 0000011d41c00000 R11: 0000000000000003 R12: ffff880212df1be0
> [  271.937635] R13: ffffffff810962e6 R14: ffff88020d085ae8 R15: ffff880212dde000
> [  271.941074] FS:  00007f8212442840(0000) GS:ffff88023ed00000(0000)
> knlGS:0000000000000000
> [  271.944536] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  271.947983] CR2: 00007f8b2d7444a0 CR3: 0000000211421000 CR4: 00000000000007e0
> [  271.951446] Stack:
> [  271.954866]  ffff88020d085bf0 ffffffffa057ec69 0000000000000005
> 0000000000035d63
> [  271.958365]  00000000eb140000 0000000000000002 ffff880200000000
> ffff8801f65ca440
> [  271.961864]  00000000b4414000 ffff880233266000 0000011d41c00000
> ffff880233266000
> [  271.965343] Call Trace:
> [  271.968805]  [<ffffffffa057ec69>]
> btrfs_add_delayed_data_ref+0x89/0x160 [btrfs]
> [  271.972317]  [<ffffffffa0526c29>] btrfs_free_extent+0x99/0x140 [btrfs]
> [  271.975810]  [<ffffffffa051f253>] __btrfs_mod_ref+0x153/0x280 [btrfs]
> [  271.979304]  [<ffffffffa0526b90>] ? run_clustered_refs+0xdc0/0xdc0 [btrfs]
> [  271.982812]  [<ffffffffa0527b77>] walk_up_proc+0x227/0x410 [btrfs]
> [  271.986328]  [<ffffffffa0527e91>] walk_up_tree+0x131/0x1f0 [btrfs]
> [  271.989826]  [<ffffffffa05296f0>] btrfs_drop_snapshot+0x3d0/0x720 [btrfs]
> [  271.993347]  [<ffffffffa053c393>]
> btrfs_clean_one_deleted_snapshot+0xb3/0x130 [btrfs]
> [  271.996895]  [<ffffffffa0534648>] cleaner_kthread+0x128/0x180 [btrfs]
> [  272.000441]  [<ffffffffa0534520>] ? check_leaf.isra.41+0x310/0x310 [btrfs]
> [  272.003975]  [<ffffffff81088660>] kthread+0xc0/0xd0
> [  272.007487]  [<ffffffff810885a0>] ? insert_kthread_work+0x40/0x40
> [  272.011031]  [<ffffffff816567ac>] ret_from_fork+0x7c/0xb0
> [  272.014556]  [<ffffffff810885a0>] ? insert_kthread_work+0x40/0x40
> [  272.018045] Code: 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48
> 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 0f 66 0f 1f 44
> 00 00 f3 90 <0f> b6 07 38 d0 75 f7 5d c3 0f 1f 44 00 00 66 66 66 66 90
> 55 48
> [  275.872193] BUG: soft lockup - CPU#0 stuck for 22s! [btrfs-transacti:1746]
> [  275.875820] Modules linked in: btrfs zlib_deflate raid6_pq
> libcrc32c xor dm_crypt nf_conntrack_netbios_ns nf_conntrack_broadcast
> ipt_MASQUERADE ip6t_REJECT xt_conntrack bnep bluetooth ebtable_nat
> ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat
> nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
> ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
> iptable_mangle iptable_security iptable_raw w83627ehf hwmon_vid radeon
> i2c_algo_bit ttm drm_kms_helper drm snd_hda_codec_realtek
> snd_hda_codec_hdmi snd_hda_intel snd_hda_codec kvm_amd kvm r8169
> snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd
> eeepc_wmi asus_wmi sparse_keymap rfkill video microcode serio_raw
> k10temp mii shpchp
> [  275.895564]  soundcore sp5100_tco i2c_piix4 i2c_core wmi
> acpi_cpufreq mperf uinput firewire_ohci firewire_core crc_itu_t
> [  275.899763] CPU: 0 PID: 1746 Comm: btrfs-transacti Not tainted
> 3.11.9-200.fc19.x86_64 #1
> [  275.903953] Hardware name: System manufacturer System Product
> Name/E35M1-M, BIOS 0401 02/16/2011
> [  275.908192] task: ffff88021c3c44a0 ti: ffff88020d086000 task.ti:
> ffff88020d086000
> [  275.912451] RIP: 0010:[<ffffffffa057e528>]  [<ffffffffa057e528>]
> btrfs_merge_delayed_refs+0xd8/0x3d0 [btrfs]
> [  275.916824] RSP: 0018:ffff88020d087c38  EFLAGS: 00000212
> [  275.921144] RAX: 0000011c70240000 RBX: 0000000000000000 RCX: 00000000000000b8
> [  275.925518] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801f7ba0cc0
> [  275.929904] RBP: ffff88020d087c80 R08: 0000000000000000 R09: 0000000000000001
> [  275.934317] R10: ffff8801f52bd5a0 R11: 0000000000000003 R12: ffff8801f52bd5a0
> [  275.938753] R13: 0000000000000003 R14: ffffffffa0514c16 R15: ffff88020d087c28
> [  275.943184] FS:  00007fe98ece6700(0000) GS:ffff88023ec00000(0000)
> knlGS:0000000000000000
> [  275.947636] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  275.952105] CR2: 00000000029d2b10 CR3: 0000000211624000 CR4: 00000000000007f0
> [  275.956595] Stack:
> [  275.960981]  ffff8801fd536e58 ffff880212df11e0 ffff8801f2ff8360
> 0000000100000000
> [  275.965381]  ffff8801fd50f220 0000000000000000 0000000000000000
> ffff880212dde000
> [  275.969767]  ffff8801fd536e58 ffff88020d087d78 ffffffffa0525e44
> 0000000000035d63
> [  275.974088] Call Trace:
> [  275.978298]  [<ffffffffa0525e44>] run_clustered_refs+0x74/0xdc0 [btrfs]
> [  275.982479]  [<ffffffffa052af50>] btrfs_run_delayed_refs+0xe0/0x540 [btrfs]
> [  275.986577]  [<ffffffffa053ace0>] btrfs_commit_transaction+0xb0/0x950 [btrfs]
> [  275.990588]  [<ffffffffa053271d>] transaction_kthread+0x18d/0x220 [btrfs]
> [  275.994518]  [<ffffffffa0532590>] ? verify_parent_transid+0x150/0x150 [btrfs]
> [  275.998385]  [<ffffffff81088660>] kthread+0xc0/0xd0
> [  276.002203]  [<ffffffff810885a0>] ? insert_kthread_work+0x40/0x40
> [  276.005999]  [<ffffffff816567ac>] ret_from_fork+0x7c/0xb0
> [  276.009756]  [<ffffffff810885a0>] ? insert_kthread_work+0x40/0x40
> [  276.013493] Code: 44 00 00 4c 89 ff e8 d8 20 d8 e0 49 89 c5 48 8b
> 43 18 49 39 47 18 0f 85 17 01 00 00 4d 85 e4 74 0a 4d 3b 67 28 0f 86
> 08 01 00 00 <31> d2 4c 89 fe 48 89 df e8 db f5 ff ff 85 c0 0f 85 53 01
> 00 00
> [  331.869602] BUG: soft lockup - CPU#0 stuck for 24s! [btrfs-cleaner:1745]
> [  331.881610] BUG: soft lockup - CPU#1 stuck for 23s! [btrfs-transacti:1746]
> [  331.873570] Modules linked in: btrfs zlib_deflate raid6_pq
> libcrc32c xor dm_crypt nf_conntrack_netbios_ns nf_conntrack_broadcast
> ipt_MASQUERADE ip6t_REJECT xt_conntrack bnep bluetooth ebtable_nat
> ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat
> nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
> [  331.881615] Modules linked in:
> [  331.881618]  btrfs
> [  331.881620]  zlib_deflate
> [  331.881623]  raid6_pq
> [  331.881625]  libcrc32c
> [  331.881626]  xor
> [  331.881628]  dm_crypt
> [  331.881630]  nf_conntrack_netbios_ns
> [  331.881632]  nf_conntrack_broadcast
> [  331.881634]  ipt_MASQUERADE
> [  331.881636]  ip6t_REJECT
> [  331.881638]  xt_conntrack
> [  331.881640]  bnep
> [  331.881641]  bluetooth
> [  331.881643]  ebtable_nat
> [  331.881645]  ebtable_broute
> [  331.881647]  bridge
> [  331.881649]  stp
> [  331.881650]  llc
> [  331.881652]  ebtable_filter
> [  331.881654]  ebtables
> [  331.881656]  ip6table_nat
> [  331.881657]  nf_conntrack_ipv6
> [  331.881659]  nf_defrag_ipv6
> [  331.881661]  nf_nat_ipv6
> [  331.881663]  ip6table_mangle
> [  331.881665]  ip6table_security
> [  331.881667]  ip6table_raw
> [  331.881669]  ip6table_filter
> [  331.881671]  ip6_tables
> [  331.881672]  iptable_nat
> [  331.881674]  nf_conntrack_ipv4
> [  331.881676]  nf_defrag_ipv4
> [  331.881678]  nf_nat_ipv4
> [  331.881679]  nf_nat
> [  331.881681]  nf_conntrack
> [  331.881683]  iptable_mangle
> [  331.881685]  iptable_security
> [  331.881687]  iptable_raw
> [  331.881689]  w83627ehf
> [  331.881690]  hwmon_vid
> [  331.881692]  radeon
> [  331.881694]  i2c_algo_bit
> [  331.881696]  ttm
> [  331.881698]  drm_kms_helper
> [  331.881699]  drm
> [  331.881701]  snd_hda_codec_realtek
> [  331.881703]  snd_hda_codec_hdmi
> [  331.881705]  snd_hda_intel
> [  331.881707]  snd_hda_codec
> [  331.881709]  kvm_amd
> [  331.881711]  kvm
> [  331.881712]  r8169
> [  331.881714]  snd_hwdep
> [  331.881716]  snd_seq
> [  331.881718]  snd_seq_device
> [  331.881720]  snd_pcm
> [  331.881722]  snd_page_alloc
> [  331.881724]  snd_timer
> [  331.881725]  snd
> [  331.881727]  eeepc_wmi
> [  331.881729]  asus_wmi
> [  331.881731]  sparse_keymap
> [  331.881732]  rfkill
> [  331.881734]  video
> [  331.881736]  microcode
> [  331.881738]  serio_raw
> [  331.881740]  k10temp
> [  331.881741]  mii
> [  331.881743]  shpchp
> [  331.881745]  soundcore
> [  331.881747]  sp5100_tco
> [  331.881749]  i2c_piix4
> [  331.881751]  i2c_core
> [  331.881752]  wmi
> [  331.881754]  acpi_cpufreq
> [  331.881756]  mperf
> [  331.881758]  uinput
> [  331.881760]  firewire_ohci
> [  331.881761]  firewire_core
> [  331.881763]  crc_itu_t
>
> [  331.881773] CPU: 1 PID: 1746 Comm: btrfs-transacti Not tainted
> 3.11.9-200.fc19.x86_64 #1
> [  331.881777] Hardware name: System manufacturer System Product
> Name/E35M1-M, BIOS 0401 02/16/2011
> [  331.881782] task: ffff88021c3c44a0 ti: ffff88020d086000 task.ti:
> ffff88020d086000
> [  331.881786] RIP: 0010:[<ffffffff8130060c>]
> [  331.881798]  [<ffffffff8130060c>] rb_prev+0x2c/0x50
> [  331.881802] RSP: 0018:ffff88020d087c28  EFLAGS: 00000202
> [  331.881805] RAX: ffff8801f6720cc0 RBX: ffff8801f432f240 RCX: 00000000000000b8
> [  331.881808] RDX: ffff8801f6720cc1 RSI: 0000000000000000 RDI: ffff8801f6722000
> [  331.881811] RBP: ffff88020d087c28 R08: 0000000000000000 R09: 0000000000000000
> [  331.881814] R10: ffff8801f432f240 R11: 0000000000000003 R12: ffffffffa0514c16
> [  331.881817] R13: ffff88020d087c28 R14: ffff8801ecda9140 R15: 0000000000003c6b
> [  331.881822] FS:  00007f520b0ba880(0000) GS:ffff88023ed00000(0000)
> knlGS:0000000000000000
> [  331.881826] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  331.881829] CR2: 00007f520b101dc0 CR3: 00000001f0a5f000 CR4: 00000000000007e0
> [  331.881831] Stack:
> [  331.881834]  ffff88020d087c80
> [  331.881837]  ffffffffa057e508
> [  331.881838]  ffff8801fd5a3440
> [  331.881840]  ffff880212df11e0
>
> [  331.881843]  ffff8801ef3a9960
> [  331.881845]  0000000100000000
> [  331.881846]  ffff8801f669f480
> [  331.881848]  ffff880212dde0d0
>
> [  331.881850]  0000000000000000
> [  331.881852]  ffff880212dde000
> [  331.881854]  ffff8801fd5a3440
> [  331.881855]  ffff88020d087d78
>
> [  331.881858] Call Trace:
>
> [  331.881919]  [<ffffffffa057e508>] btrfs_merge_delayed_refs+0xb8/0x3d0 [btrfs]
>
> [  331.881953]  [<ffffffffa0525e44>] run_clustered_refs+0x74/0xdc0 [btrfs]
>
> [  331.881990]  [<ffffffffa052af50>] btrfs_run_delayed_refs+0xe0/0x540 [btrfs]
>
> [  331.882028]  [<ffffffffa053ace0>] btrfs_commit_transaction+0xb0/0x950 [btrfs]
>
> [  331.882062]  [<ffffffffa053271d>] transaction_kthread+0x18d/0x220 [btrfs]
>
> [  331.882096]  [<ffffffffa0532590>] ? verify_parent_transid+0x150/0x150 [btrfs]
>
> [  331.882105]  [<ffffffff81088660>] kthread+0xc0/0xd0
>
> [  331.882113]  [<ffffffff810885a0>] ? insert_kthread_work+0x40/0x40
>
> [  331.882122]  [<ffffffff816567ac>] ret_from_fork+0x7c/0xb0
>
> [  331.882129]  [<ffffffff810885a0>] ? insert_kthread_work+0x40/0x40
> [  331.882131] Code:
> [  331.882135] 48
> [  331.882136] 8b
> [  331.882138] 17
> [  331.882139] 48
> [  331.882141] 89
> [  331.882142] e5
> [  331.882143] 48
> [  331.882144] 39
> [  331.882146] d7
> [  331.882147] 74
> [  331.882148] 3b
> [  331.882149] 48
> [  331.882151] 8b
> [  331.882152] 47
> [  331.882153] 10
> [  331.882155] 48
> [  331.882156] 85
> [  331.882157] c0
> [  331.882158] 75
> [  331.882160] 0e
> [  331.882161] eb
> [  331.882162] 25
> [  331.882164] 66
> [  331.882165] 0f
> [  331.882166] 1f
> [  331.882167] 84
> [  331.882169] 00
> [  331.882170] 00
> [  331.882171] 00
> [  331.882173] 00
> [  331.882174] 00
> [  331.882175] 48
> [  331.882176] 89
> [  331.882178] d0
> [  331.882179] 48
> [  331.882180] 8b
> [  331.882182] 50
> [  331.882183] 08
> [  331.882184] 48
> [  331.882185] 85
> [  331.882187] d2
> [  331.882188] 75
> [  331.882189] f4
> [  331.882191] <5d>
> [  331.882192] c3
> [  331.882194] 66
> [  331.882195] 90
> [  331.882196] 48
> [  331.882197] 3b
> [  331.882199] 78
> [  331.882200] 10
> [  331.882201] 75
> [  331.882203] f6
> [  331.882204] 48
> [  331.882205] 8b
> [  331.882206] 10
> [  331.882208] 48
> [  331.882209] 89
> [  331.882210] c7
> [  331.882212] 48
> [  331.882213] 89
> [  331.882214] d0
> [  331.882215] 48
> [  331.882217] 83
>
> [  332.048373]  ip6table_security
> [  332.052414]  ip6table_raw ip6table_filter ip6_tables iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
> iptable_mangle iptable_security iptable_raw w83627ehf hwmon_vid radeon
> i2c_algo_bit ttm drm_kms_helper drm snd_hda_codec_realtek
> snd_hda_codec_hdmi snd_hda_intel snd_hda_codec kvm_amd kvm r8169
> snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd
> eeepc_wmi asus_wmi sparse_keymap rfkill video microcode serio_raw
> k10temp mii shpchp soundcore sp5100_tco i2c_piix4 i2c_core wmi
> acpi_cpufreq mperf uinput firewire_ohci firewire_core crc_itu_t
> [  332.070031] CPU: 0 PID: 1745 Comm: btrfs-cleaner Not tainted
> 3.11.9-200.fc19.x86_64 #1
> [  332.074487] Hardware name: System manufacturer System Product
> Name/E35M1-M, BIOS 0401 02/16/2011
> [  332.078969] task: ffff88021c3c07a0 ti: ffff88020d084000 task.ti:
> ffff88020d084000
> [  332.083454] RIP: 0010:[<ffffffff8164e062>]  [<ffffffff8164e062>]
> _raw_spin_lock+0x22/0x30
> [  332.087964] RSP: 0018:ffff88020d085b70  EFLAGS: 00000297
> [  332.092450] RAX: 00000000000000d9 RBX: ffff88020d085b20 RCX: 0000000000000000
> [  332.096957] RDX: 00000000000000da RSI: 0000000000000050 RDI: ffff880212dde0d0
> [  332.101438] RBP: ffff88020d085b70 R08: 000000000001ad80 R09: ffffffffa057ec44
> [  332.105911] R10: 0000011efc83b000 R11: 0000000000000001 R12: ffff8801f6ffa488
> [  332.110380] R13: 00000001802a002a R14: ffff880212dddc80 R15: 0000000000014180
> [  332.114860] FS:  00007fb0850b5700(0000) GS:ffff88023ec00000(0000)
> knlGS:0000000000000000
> [  332.119362] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  332.123856] CR2: 00007f8b332a6000 CR3: 0000000229343000 CR4: 00000000000007f0
> [  332.128373] Stack:
> [  332.132865]  ffff88020d085bf0 ffffffffa057ec69 0000000000000005
> 0000000000035d63
> [  332.137450]  0000000038640000 0000000000000002 ffff880200000000
> ffff880200f4f990
> [  332.142048]  000001028b9b0000 ffff880233266000 0000011efc83b000
> ffff880233266000
> [  332.146578] Call Trace:
> [  332.151027]  [<ffffffffa057ec69>]
> btrfs_add_delayed_data_ref+0x89/0x160 [btrfs]
> [  332.155497]  [<ffffffffa0526c29>] btrfs_free_extent+0x99/0x140 [btrfs]
> [  332.159881]  [<ffffffffa051f253>] __btrfs_mod_ref+0x153/0x280 [btrfs]
> [  332.164179]  [<ffffffffa0526b90>] ? run_clustered_refs+0xdc0/0xdc0 [btrfs]
> [  332.168395]  [<ffffffffa0527b77>] walk_up_proc+0x227/0x410 [btrfs]
> [  332.172522]  [<ffffffffa0527e91>] walk_up_tree+0x131/0x1f0 [btrfs]
> [  332.176542]  [<ffffffffa05296f0>] btrfs_drop_snapshot+0x3d0/0x720 [btrfs]
> [  332.180487]  [<ffffffffa053c393>]
> btrfs_clean_one_deleted_snapshot+0xb3/0x130 [btrfs]
> [  332.184362]  [<ffffffffa0534648>] cleaner_kthread+0x128/0x180 [btrfs]
> [  332.188145]  [<ffffffffa0534520>] ? check_leaf.isra.41+0x310/0x310 [btrfs]
> [  332.191835]  [<ffffffff81088660>] kthread+0xc0/0xd0
> [  332.195454]  [<ffffffff810885a0>] ? insert_kthread_work+0x40/0x40
> [  332.199051]  [<ffffffff816567ac>] ret_from_fork+0x7c/0xb0
> [  332.202602]  [<ffffffff810885a0>] ? insert_kthread_work+0x40/0x40
> [  332.206139] Code: 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48
> 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 0f 66 0f 1f 44
> 00 00 f3 90 <0f> b6 07 38 d0 75 f7 5d c3 0f 1f 44 00 00 66 66 66 66 90
> 55 48
> [  361.466341] systemd-journald[314]: Deleted empty journal
> /var/log/journal/113d85e5e57e472c923bb4a4b903a354/user-1001@0004eccb21f1284e-61c2c25d8a5ce727.journal~
> (140288 bytes).
> [  362.119253] systemd-journald[314]: Deleted empty journal
> /var/log/journal/113d85e5e57e472c923bb4a4b903a354/user-1000@0004eccb293e6390-f35eaf22f8cdf371.journal~
> (140288 bytes).
