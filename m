Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5640 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933114AbcBYTnE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 14:43:04 -0500
Date: Thu, 25 Feb 2016 14:42:51 -0500
From: Chris Mason <clm@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: Can you help explain these OOM crashes?
Message-ID: <20160225194251.kidqfejwlsai6h5v@floor.thefacebook.com>
References: <20160225192029.GF2290@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160225192029.GF2290@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2016 at 11:20:29AM -0800, Marc MERLIN wrote:
> Which kind of RAM am I missing? :)
> 
> Thanks,
> Marc
> 
> [46320.200703] btrfs: page allocation failure: order:1, mode:0x2204020
> [46320.221174] CPU: 7 PID: 12576 Comm: btrfs Not tainted 4.4.2-amd64-i915-volpreempt-20160213bc1 #3
> [46320.249161] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> [46320.277878]  0000000000000000 ffff8801cdb636f0 ffffffff8134ae0a 0000000000000000
> [46320.301563]  ffff8801cdb63788 ffffffff81124ab6 0000000000000086 0000000000000086
> [46320.325248]  ffff88021f5f5e00 fffffffffffffffe ffff8801cdb63750 ffffffff8108c770
> [46320.348911] Call Trace:
> [46320.357508]  [<ffffffff8134ae0a>] dump_stack+0x44/0x55
> [46320.374222]  [<ffffffff81124ab6>] warn_alloc_failed+0x114/0x12c
> [46320.393259]  [<ffffffff8108c770>] ? __wake_up+0x44/0x4b
> [46320.410229]  [<ffffffff811274b8>] __alloc_pages_nodemask+0x7cb/0x84c
> [46320.430671]  [<ffffffff8116584c>] kmem_getpages+0x5c/0x137
> [46320.448328]  [<ffffffff81165a30>] fallback_alloc+0x109/0x1b1
> [46320.466472]  [<ffffffff81165bfb>] ____cache_alloc_node+0x123/0x130
> [46320.486219]  [<ffffffff811667f6>] kmem_cache_alloc+0xa4/0x14f
> [46320.504600]  [<ffffffff8134b941>] ida_pre_get+0x32/0xb6
> [46320.521395]  [<ffffffff8117f94f>] get_anon_bdev+0x1f/0xc8

Al, any ideas why get_anon_bdev is doing an atomic allocation here?

	if (ida_pre_get(&unnamed_dev_ida, GFP_ATOMIC) == 0)

[ rest of the oom below for reference ]

-chris

> [46320.538780]  [<ffffffff81257de1>] btrfs_init_fs_root+0x104/0x14e
> [46320.557889]  [<ffffffff81258f03>] btrfs_get_fs_root+0xb7/0x1bf
> [46320.576480]  [<ffffffff8125cc47>] create_pending_snapshot+0x65e/0xb09
> [46320.596850]  [<ffffffff8125d164>] create_pending_snapshots+0x72/0x8e
> [46320.616946]  [<ffffffff8125d164>] ? create_pending_snapshots+0x72/0x8e
> [46320.637533]  [<ffffffff8125e010>] btrfs_commit_transaction+0x3a5/0x921
> [46320.658117]  [<ffffffff81288dfb>] btrfs_mksubvol+0x2f4/0x408
> [46320.676044]  [<ffffffff8108cc0e>] ? wake_up_atomic_t+0x2c/0x2c
> [46320.694626]  [<ffffffff81289057>] btrfs_ioctl_snap_create_transid+0x148/0x17a
> [46320.716984]  [<ffffffff812891b7>] btrfs_ioctl_snap_create_v2+0xc7/0x110
> [46320.737714]  [<ffffffff8128b1b9>] btrfs_ioctl+0x545/0x2630
> [46320.755071]  [<ffffffff8116faac>] ? mem_cgroup_charge_statistics.isra.23+0x33/0x69
> [46320.778689]  [<ffffffff8112c465>] ? __lru_cache_add+0x23/0x44
> [46320.796851]  [<ffffffff8112c732>] ? lru_cache_add_active_or_unevictable+0x2d/0x6b
> [46320.820156]  [<ffffffff81142d9c>] ? set_pte_at+0x9/0xd
> [46320.836407]  [<ffffffff81146975>] ? handle_mm_fault+0x4f0/0xf06
> [46320.854969]  [<ffffffff8114bae7>] ? do_mmap+0x2de/0x327
> [46320.871422]  [<ffffffff8118c4fd>] do_vfs_ioctl+0x3a1/0x414
> [46320.888953]  [<ffffffff810dad64>] ? __audit_syscall_entry+0xc0/0xe4
> [46320.908531]  [<ffffffff81003490>] ? do_audit_syscall_entry+0x60/0x62
> [46320.928487]  [<ffffffff8118c5c7>] SyS_ioctl+0x57/0x79
> [46320.944553]  [<ffffffff816e1876>] entry_SYSCALL_64_fastpath+0x16/0x75
> [46320.964603] Mem-Info:
> [46320.972173] active_anon:40431 inactive_anon:129104 isolated_anon:0
> [46320.972173]  active_file:414564 inactive_file:956231 isolated_file:0
> [46320.972173]  unevictable:1220 dirty:227385 writeback:4016 unstable:0
> [46320.972173]  slab_reclaimable:46015 slab_unreclaimable:67059
> [46320.972173]  mapped:11769 shmem:2295 pagetables:2380 bounce:0
> [46320.972173]  free:13404 free_pcp:1790 free_cma:0
> [46321.081552] Node 0 DMA free:15888kB min:20kB low:24kB high:28kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:4kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
> [46321.209469] lowmem_reserve[]: 0 3201 7672 7672
> [46321.223638] Node 0 DMA32 free:27816kB min:4640kB low:5800kB high:6960kB active_anon:72844kB inactive_anon:205672kB active_file:725732kB inactive_file:1484744kB unevictable:1524kB isolated(anon):0kB isolated(file):0kB present:3362068kB managed:3283032kB mlocked:1524kB dirty:206660kB writeback:189832kB mapped:18112kB shmem:3456kB slab_reclaimable:75980kB slab_unreclaimable:103932kB kernel_stack:4800kB pagetables:3932kB unstable:0kB bounce:0kB free_pcp:2160kB local_pcp:380kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [46321.370242] lowmem_reserve[]: 0 0 4471 4471
> [46321.383748] Node 0 Normal free:14396kB min:6480kB low:8100kB high:9720kB active_anon:88268kB inactive_anon:310756kB active_file:1001176kB inactive_file:1915152kB unevictable:3356kB isolated(anon):0kB isolated(file):0kB present:4708352kB managed:4578512kB mlocked:120259087644kB dirty:274088kB writeback:255988kB mapped:28380kB shmem:5736kB slab_reclaimable:108288kB slab_unreclaimable:163908kB kernel_stack:7312kB pagetables:5540kB unstable:0kB bounce:0kB free_pcp:2468kB local_pcp:688kB free_cma:2628kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [46321.534455] lowmem_reserve[]: 0 0 0 0
> [46321.546480] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15888kB
> [46321.588226] Node 0 DMA32: 6462*4kB (UME) 1397*8kB (UM) 9*16kB (U) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 37168kB
> [46321.628535] Node 0 Normal: 4296*4kB (UMEC) 880*8kB (UMEC) 130*16kB (UMC) 9*32kB (C) 1*64kB (C) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 26656kB
> [46321.672956] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
> [46321.699161] 1267593 total pagecache pages
> [46321.712115] 933 pages in swap cache
> [46321.723501] Swap cache stats: add 10732, delete 9799, find 13919/14910
> [46321.743996] Free swap  = 15587628kB
> [46321.755413] Total swap = 15616764kB
> [46321.766815] 2021599 pages RAM
> [46321.776641] 0 pages HighMem/MovableOnly
> [46321.789072] 52240 pages reserved
> [46321.799666] 4096 pages cma reserved
> [46321.811045] 0 pages hwpoisoned
> 
> [46321.836560] WARNING: CPU: 7 PID: 12576 at fs/btrfs/transaction.c:1481 create_pending_snapshot+0x6b2/0xb09()
> [46321.867370] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs cpuid udp_diag tcp_diag inet_diag veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype tun bridge stp llc autofs4 softdog binfmt_misc ftdi_sio nfsd nfs_acl auth_rpcgss nfs fscache lockd grace sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter bcache lm85 hwmon_vid pl2303 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 ip_tables nf_conntrack_ftp ipt_MASQUERADE x_tables nf_nat_masquerade_ipv4 nf_nat nf_conntrack sg st snd_pcm_oss snd_mixer_oss snd_opl3_synth snd_seq_midi_emul snd_hda_codec_realtek snd_hda_codec_generic snd_cmipci gameport kvm_intel snd_opl3_lib snd_mpu401_uart snd_hda_intel kvm snd_seq_midi snd_seq_midi_event irqbypass snd_hda_codec snd_seq rc_ati_x10 snd_hda_core eeepc_wmi snd_rawmidi asus_wmi snd_hwdep ati_remote asix snd_pcm sparse_keymap tpm_tis parport_pc tpm_infineon snd_seq_device snd_timer coretemp xhci_pci rfkill input_leds battery libphy 8250_fintek tpm usbnet rc_core intel_rapl pcspkr iosf_mbi lpc_ich processor wmi parport i2c_i801 evdev snd xhci_hcd intel_powerclamp x86_pkg_temp_thermal soundcore usbserial e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts ansi_cprng drbg aesni_intel ablk_helper lrw gf128mul glue_helper aes_x86_64 crc32_pclmul ehci_pci crct10dif_pclmul ehci_hcd fjes thermal usbcore cryptd usb_common sata_mv crc32c_intel fan r8169 mii sata_sil24 [last unloaded: ftdi_sio]
> [46322.339534] CPU: 7 PID: 12576 Comm: btrfs Not tainted 4.4.2-amd64-i915-volpreempt-20160213bc1 #3
> [46322.366986] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> [46322.395437]  0000000000000000 ffff8801cdb639f0 ffffffff8134ae0a ffff8801cdb63a38
> [46322.418872]  ffff8801cdb63a28 ffffffff8105d940 ffffffff8125cc9b 00000000fffffff4
> [46322.442300]  ffff8800c5859000 ffff88001e1738e0 ffff8801c5e7dc00 ffff8801cdb63a90
> [46322.465725] Call Trace:
> [46322.474136]  [<ffffffff8134ae0a>] dump_stack+0x44/0x55
> [46322.490632]  [<ffffffff8105d940>] warn_slowpath_common+0x99/0xb2
> [46322.509671]  [<ffffffff8125cc9b>] ? create_pending_snapshot+0x6b2/0xb09
> [46322.530474]  [<ffffffff8105d9a1>] warn_slowpath_fmt+0x48/0x50
> [46322.549300]  [<ffffffff8125cc9b>] create_pending_snapshot+0x6b2/0xb09
> [46322.569614]  [<ffffffff8125d164>] create_pending_snapshots+0x72/0x8e
> [46322.589648]  [<ffffffff8125d164>] ? create_pending_snapshots+0x72/0x8e
> [46322.610158]  [<ffffffff8125e010>] btrfs_commit_transaction+0x3a5/0x921
> [46322.630673]  [<ffffffff81288dfb>] btrfs_mksubvol+0x2f4/0x408
> [46322.648577]  [<ffffffff8108cc0e>] ? wake_up_atomic_t+0x2c/0x2c
> [46322.666976]  [<ffffffff81289057>] btrfs_ioctl_snap_create_transid+0x148/0x17a
> [46322.689251]  [<ffffffff812891b7>] btrfs_ioctl_snap_create_v2+0xc7/0x110
> [46322.709976]  [<ffffffff8128b1b9>] btrfs_ioctl+0x545/0x2630
> [46322.727302]  [<ffffffff8116faac>] ? mem_cgroup_charge_statistics.isra.23+0x33/0x69
> [46322.750875]  [<ffffffff8112c465>] ? __lru_cache_add+0x23/0x44
> [46322.768952]  [<ffffffff8112c732>] ? lru_cache_add_active_or_unevictable+0x2d/0x6b
> [46322.792243]  [<ffffffff81142d9c>] ? set_pte_at+0x9/0xd
> [46322.808505]  [<ffffffff81146975>] ? handle_mm_fault+0x4f0/0xf06
> [46322.827059]  [<ffffffff8114bae7>] ? do_mmap+0x2de/0x327
> [46322.843529]  [<ffffffff8118c4fd>] do_vfs_ioctl+0x3a1/0x414
> [46322.860914]  [<ffffffff810dad64>] ? __audit_syscall_entry+0xc0/0xe4
> [46322.880558]  [<ffffffff81003490>] ? do_audit_syscall_entry+0x60/0x62
> [46322.900498]  [<ffffffff8118c5c7>] SyS_ioctl+0x57/0x79
> [46322.916526]  [<ffffffff816e1876>] entry_SYSCALL_64_fastpath+0x16/0x75
> [46322.937086] ---[ end trace 121bf2eae0452f60 ]---
> [46322.951800] BTRFS: error (device dm-0) in create_pending_snapshot:1481: errno=-12 Out of memory
> [46322.978718] BTRFS info (device dm-0): forced readonly
> [46322.994710] BTRFS warning (device dm-0): Skipping commit of aborted transaction.
> [46323.017758] BTRFS: error (device dm-0) in cleanup_transaction:1746: errno=-12 Out of memory
> [46327.385584] BUG: unable to handle kernel paging request at 00000000ffffffef
> [46327.407388] IP: [<ffffffff81073782>] find_pid_ns+0x4a/0x7a
> [46327.424733] PGD 16742f067 PUD 201b42067 PMD 0
> [46327.439021] Oops: 0000 [#1] SMP
> [46327.449592] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs cpuid udp_diag tcp_diag inet_diag veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype tun bridge stp llc autofs4 softdog binfmt_misc ftdi_sio nfsd nfs_acl auth_rpcgss nfs fscache lockd grace sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter bcache lm85 hwmon_vid pl2303 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 ip_tables nf_conntrack_ftp ipt_MASQUERADE x_tables nf_nat_masquerade_ipv4 nf_nat nf_conntrack sg st snd_pcm_oss snd_mixer_oss snd_opl3_synth snd_seq_midi_emul snd_hda_codec_realtek snd_hda_codec_generic snd_cmipci gameport kvm_intel snd_opl3_lib snd_mpu401_uart snd_hda_intel kvm snd_seq_midi snd_seq_midi_event irqbypass snd_hda_codec snd_seq rc_ati_x10 snd_hda_core eeepc_wmi snd_rawmidi asus_wmi snd_hwdep ati_remote asix snd_pcm sparse_keymap tpm_tis parport_pc tpm_infineon snd_seq_device snd_timer coretemp xhci_pci rfkill input_leds battery libphy 8250_fintek tpm usbnet rc_core intel_rapl pcspkr iosf_mbi lpc_ich processor wmi parport i2c_i801 evdev snd xhci_hcd intel_powerclamp x86_pkg_temp_thermal soundcore usbserial e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts ansi_cprng drbg aesni_intel ablk_helper lrw gf128mul glue_helper aes_x86_64 crc32_pclmul ehci_pci crct10dif_pclmul ehci_hcd fjes thermal usbcore cryptd usb_common sata_mv crc32c_intel fan r8169 mii sata_sil24 [last unloaded: ftdi_sio]
> [46327.915608] CPU: 4 PID: 12653 Comm: pgrep Tainted: G        W       4.4.2-amd64-i915-volpreempt-20160213bc1 #3
> [46327.946456] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> [46327.974820] task: ffff8800ab49c180 ti: ffff880105b48000 task.ti: ffff880105b48000
> [46327.998159] RIP: 0010:[<ffffffff81073782>]  [<ffffffff81073782>] find_pid_ns+0x4a/0x7a
> [46328.023164] RSP: 0018:ffff880105b4bd90  EFLAGS: 00010202
> [46328.040017] RAX: 00000000ffffffef RBX: 000000000000314f RCX: 0000000000000034
> [46328.062337] RDX: ffff88003dd31700 RSI: ffffffff81e47be0 RDI: 000000000000314f
> [46328.085123] RBP: ffff880105b4bd90 R08: 000000000080db2c R09: 0000000000000004
> [46328.107438] R10: ffff880105b4bf38 R11: ffff880105b4be10 R12: 000000000000314f
> [46328.129735] R13: ffffffff81e47be0 R14: ffffffff81e47be0 R15: ffff8800140e6200
> [46328.152063] FS:  0000000000000000(0000) GS:ffff88021e300000(0063) knlGS:00000000f759b700
> [46328.177244] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [46328.195407] CR2: 00000000ffffffef CR3: 00000001b7235000 CR4: 00000000001406e0
> [46328.217742] Stack:
> [46328.224730]  ffff880105b4bdb8 ffffffff81074166 000000000000314f 000000000000314f
> [46328.248046]  ffff880105b4bec0 ffff880105b4bdf0 ffffffff811d269d ffff8801ab3bc300
> [46328.271337]  ffff880105b4bf38 000000000000314e ffff880105b4bec0 ffffffff81e47be0
> [46328.294683] Call Trace:
> [46328.302969]  [<ffffffff81074166>] find_ge_pid+0x1d/0x3f
> [46328.320091]  [<ffffffff811d269d>] next_tgid+0x31/0x98
> [46328.336232]  [<ffffffff811d4b25>] proc_pid_readdir+0x18b/0x1c9
> [46328.354667]  [<ffffffff811d0f03>] proc_root_readdir+0x38/0x3d
> [46328.372844]  [<ffffffff8118c92f>] iterate_dir+0x8b/0x10f
> [46328.389722]  [<ffffffff811beff1>] compat_SyS_getdents+0x95/0xe9
> [46328.408480]  [<ffffffff811bd8be>] ? zero_fd_set+0x1d/0x1d
> [46328.425607]  [<ffffffff810039c3>] do_fast_syscall_32+0xb3/0xf3
> [46328.444122]  [<ffffffff810039c3>] ? do_fast_syscall_32+0xb3/0xf3
> [46328.463046]  [<ffffffff816e3e32>] sysenter_flags_fixed+0x8/0x12
> [46328.481708] Code: 37 9e 55 48 0f af c2 48 8b 15 e3 11 0a 01 48 89 e5 48 d3 e8 48 8d 04 c2 48 8b 10 31 c0 48 85 d2 74 37 48 8d 42 f0 48 85 c0 74 2e <3b> 38 75 19 48 3b 70 08 75 13 8b 96 30 08 00 00 48 c1 e2 05 48
> [46328.543420] RIP  [<ffffffff81073782>] find_pid_ns+0x4a/0x7a
> [46328.561112]  RSP <ffff880105b4bd90>
> [46328.572535] CR2: 00000000ffffffef
> [46328.583473] ---[ end trace 121bf2eae0452f61 ]---
> [46328.598310] Kernel panic - not syncing: Fatal exception
> [46329.652710] Shutting down cpus with NMI
> [46329.665091] Kernel Offset: disabled
> [46329.676398] Rebooting in 20 seconds..
> [46349.624353] ACPI MEMORY or I/O RESET_REG.
> 
> 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=CwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=xMva0DX-dD-yKhksE5wf7DpRo79VIsXN6ivK_OYTq4c&s=i_8jTPjXYEFrBQZFc5T4hz6hbAD37lacftY-ZbukIBQ&e=                          | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
