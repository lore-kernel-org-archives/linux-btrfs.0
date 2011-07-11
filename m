From: Jack Peirce <JPeirce@sourcecode.com>
Subject: Issues after power outage
Date: Mon, 11 Jul 2011 00:31:21 -0400
Message-ID: <F28876BE3E13E3408BD1BA9F5691428A183F86251D@Mail1.sccit.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Had a thunderstorm a week or so ago that ended up taking out one of my machines immediately after a Fedora 14 to 15 upgrade. This particular
machine has two btrfs's on it. An Intel SSD which holds /, and a HD that holds /home and a few other partitions. 

I was having issues mounting the btrfs on both disks at first, but rolling back to a previous snapshot on / resolved that. I don't have a
snapshot to roll back to for /home, but have managed to find a kernel that would mount it (f15 2.6.38.8, which I was then able to recompile
kernel 3.0.0-rc5, which will also mount it) However, it's just a F15 kernel, since I rolled back my / partition to a snapshot from before
the upgrade.

I am still getting random kernel oopses and processes locking up, I would appreciate any help in getting my system to a workable state. I
realize the data may be lost, but my main concern is to get this machine to stop hanging at the moment.

Following is relevant logs:
[  261.952081] btrfs bad tree block start 0 20431736832
[  261.952085] btrfs bad tree block start 0 20431740928
[  261.960156] btrfs bad tree block start 0 20431736832
[  261.960222] btrfs bad tree block start 0 20431736832
[  261.960288] btrfs bad tree block start 0 20431736832
[  261.960383] btrfs bad tree block start 0 20431740928
[  261.960447] btrfs bad tree block start 0 20431740928
[  261.960512] btrfs bad tree block start 0 20431740928
[  262.512050] btrfs bad tree block start 0 20436742144
[  262.517101] btrfs bad tree block start 0 20436742144
[  269.007260] btree_readpage_end_io_hook: 10 callbacks suppressed
[  269.007263] btrfs bad tree block start 0 20439236608                                            
[  269.007332] btrfs bad tree block start 0 20439236608
[  269.007400] btrfs bad tree block start 0 20439236608
[  269.007417] ------------[ cut here ]------------
[  269.007420] kernel BUG at fs/btrfs/extent-tree.c:2222!
[  269.007421] invalid opcode: 0000 [#1] PREEMPT SMP
[  269.007424] CPU 2
[  269.007425] Modules linked in: fuse nvidia(P) ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 ext2 kvm_intel kvm uinput snd_hda_codec_hdmi snd_hda_codec_realtek arc4 rt2800pci rt2800lib crc_ccitt snd_hda_intel microcode rt2x00pci snd_hda_codec rt2x00lib snd_hwdep mac80211 snd_seq serio_raw snd_seq_device snd_pcm cfg80211 snd_timer rfkill snd eeprom_93cx6 e1000e soundcore i2c_i801 i2c_core iTCO_wdt snd_page_alloc wmi iTCO_vendor_support firewire_ohci firewire_core [last unloaded: nvidia]
[  269.007455]
[  269.007457] Pid: 294, comm: btrfs-cleaner Tainted: P3.0.0-rc5-jackson #7                  /DP55WG
[  269.007460] RIP: 0010:[<ffffffff81205cd4>]  [<ffffffff81205cd4>] run_clustered_refs+0x655/0x6a8
[  269.007466] RSP: 0018:ffff88021133bbe0  EFLAGS: 00010282
[  269.007467] RAX: 00000000fffffffb RBX: ffff88015debe480 RCX: 000000000985cd02
[  269.007469] RDX: 000000000985cc02 RSI: 0000000000019710 RDI: ffffea00073cccb8
[  269.007470] RBP: ffff88021133bcd0 R08: 0000000000000000 R09: 0000000000000000
[  269.007472] R10: 0000000000000000 R11: 0000000002ac8b00 R12: 0000000000000000
[  269.007473] R13: ffff880211f95800 R14: ffff88021335e800 R15: 0000000000000000
[  269.007475] FS:  0000000000000000(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
[  269.007477] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[  269.007478] CR2: 00000036c6a17280 CR3: 0000000001a03000 CR4: 00000000000006e0
[  269.007480] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  269.007481] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  269.007483] Process btrfs-cleaner (pid: 294, threadinfo ffff88021133a000, task ffff880210e22e20) 
[  269.007484] Stack:
[  269.007485]  00000000000ee3b4 0000000000000000 0000000000000001 0000000000000000
[  269.007488]  00000005d5536000 ffff8801c00521b0 ffff8801c00521a8 ffff88014b3f7400
[  269.007490]  ffff88021133bd00 0000000000000100 ffff88021335e920 ffff88020c0110d8
[  269.007493] Call Trace:
[  269.007496]  [<ffffffff81206fdd>] ? btrfs_free_tree_block+0x67/0x2a3
[  269.007500]  [<ffffffff81249dd2>] ? btrfs_find_ref_cluster+0xfb/0x13c
[  269.007502]  [<ffffffff81205df8>] btrfs_run_delayed_refs+0xd1/0x198
[  269.007505]  [<ffffffff81213e24>] btrfs_should_end_transaction+0x44/0x73
[  269.007508]  [<ffffffff81208054>] btrfs_drop_snapshot+0x301/0x424
[  269.007510]  [<ffffffff812193b4>] ? btrfs_run_delayed_iputs+0xf6/0x121
[  269.007512]  [<ffffffff812193b4>] ? btrfs_run_delayed_iputs+0xf6/0x121
[  269.007515]  [<ffffffff812152e7>] btrfs_clean_old_snapshots+0x15f/0x180
[  269.007517]  [<ffffffff8120ea55>] cleaner_kthread+0xec/0x173
[  269.007519]  [<ffffffff8120e969>] ? transaction_kthread+0x23c/0x23c
[  269.007522]  [<ffffffff81068a27>] kthread+0x82/0x8a
[  269.007526]  [<ffffffff814f2be4>] kernel_thread_helper+0x4/0x10
[  269.007528]  [<ffffffff810689a5>] ? kthread_worker_fn+0x152/0x152
[  269.007530]  [<ffffffff814f2be0>] ? gs_change+0x13/0x13          
[  269.007531] Code: 89 7c 24 10 48 8b 7b 48 48 89 7c 24 08 48 8b 7b
40 48 89 3c 24 4c 89 f6 48 8b 7d a0 e8 b2 d6 ff ff eb 04 0f 0b 0f 0b
85 c0 74 02 <0f> 0b 48 89 df e8 df a3 ff ff 4c 89 e7 e8 a6 ee f0 ff ff
45 94
[  269.007551] RIP  [<ffffffff81205cd4>] run_clustered_refs+0x655/0x6a8
[  269.007554]  RSP <ffff88021133bbe0>
[  269.007555] ---[ end trace ccd5dc26782dc019 ]---


Thanks,
Jack Peirce
Linux Engineer
Source Code Coporation
