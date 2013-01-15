Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:33467 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab3AOPte (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 10:49:34 -0500
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r0FFnTt5020116
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 16:49:31 +0100
Received: from mail2.itwm.fhg.de ([131.246.191.79]:33177)
	by itwm2.itwm.fhg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(/C=DE/ST=Rheinland-Pfalz/L=Kaiserslautern/O=Fraunhofer ITWM/OU=SLG/CN=mail2.itwm.fhg.de)(verified=1)
	 (Exim 4.74 #1)
	id 1Tv8lV-0007Rf-4F
	for linux-btrfs@vger.kernel.org; Tue, 15 Jan 2013 16:49:29 +0100
Message-ID: <50F57A88.3030503@itwm.fraunhofer.de>
Date: Tue, 15 Jan 2013 16:49:28 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: abort transaction and RO
References: <kd3l1c$bd$1@ger.gmane.org> <50F55B1F.7050608@itwm.fraunhofer.de> <50F55C14.4090605@itwm.fraunhofer.de>
In-Reply-To: <50F55C14.4090605@itwm.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simply mounting and umounting the device will now *always* crash the kernel.
Logs of a 3.8-git debug kernel are below. 
I am not at all familiar with the btrfs code, but can't we simply 
abort the transaction and return -EIO instead of BUG_ON()?
All those BUG_ON()s look scary... Having a failed filesystem is 
already bad, but crashing the entire system is not a good idea,
IMHO.

[  182.265817] Btrfs loaded
[  182.267296] device fsid acb7d446-e3b7-4e1e-9ae3-6bbced79e115 devid 1 transid 154 /dev/vdd
[  182.269821] btrfs: disk space caching is enabled
[  193.530067] btrfs: csum mismatch on free space cache
[  193.530354] btrfs: failed to load free space cache for block group 29360128
[  193.531829] leaf 29368320 total ptrs 49 free space 344
[  193.532142]  item 0 key (0 c0 4194304) itemoff 3971 itemsize 24
[  193.532397]          block group used 0
[  193.532682]  item 1 key (4194304 c0 8388608) itemoff 3947 itemsize 24
[  193.532950]          block group used 0
[  193.533161]  item 2 key (12582912 c0 8388608) itemoff 3923 itemsize 24
[  193.533429]          block group used 7917568
[  193.533653]  item 3 key (12636160 a8 53248) itemoff 3870 itemsize 53
[  193.533914]          extent refs 1 gen 153 flags 1
[  193.534149]          extent data backref root 5 objectid 18446744073709551604 offset 0 count 1
[  193.534554]  item 4 key (12689408 a8 262144) itemoff 3817 itemsize 53
[  193.534818]          extent refs 1 gen 153 flags 1
[  193.535044]          extent data backref root 1 objectid 256 offset 0 count 1
[  193.535322]  item 5 key (13213696 a8 262144) itemoff 3764 itemsize 53
[  193.535608]          extent refs 1 gen 150 flags 1
[  193.535846]          extent data backref root 1 objectid 273 offset 0 count 1
[  193.536166]  item 6 key (13475840 a8 262144) itemoff 3711 itemsize 53
[  193.536435]          extent refs 1 gen 148 flags 1
[  193.536661]          extent data backref root 1 objectid 259 offset 0 count 1
[  193.536926]  item 7 key (13737984 a8 262144) itemoff 3658 itemsize 53
[  193.537193]          extent refs 1 gen 148 flags 1
[  193.537427]          extent data backref root 1 objectid 260 offset 0 count 1
[  193.537698]  item 8 key (14000128 a8 262144) itemoff 3605 itemsize 53
[  193.537976]          extent refs 1 gen 148 flags 1
[  193.538210]          extent data backref root 1 objectid 261 offset 0 count 1
[  193.538479]  item 9 key (14262272 a8 262144) itemoff 3552 itemsize 53
[  193.538742]          extent refs 1 gen 148 flags 1
[  193.538971]          extent data backref root 1 objectid 257 offset 0 count 1
[  193.539238]  item 10 key (14524416 a8 262144) itemoff 3499 itemsize 53
[  193.539506]          extent refs 1 gen 148 flags 1
[  193.539733]          extent data backref root 1 objectid 262 offset 0 count 1
[  193.539996]  item 11 key (14786560 a8 262144) itemoff 3446 itemsize 53
[  193.540298]          extent refs 1 gen 148 flags 1
[  193.540527]          extent data backref root 1 objectid 263 offset 0 count 1
[  193.540795]  item 12 key (15048704 a8 262144) itemoff 3393 itemsize 53
[  193.541063]          extent refs 1 gen 148 flags 1
[  193.541297]          extent data backref root 1 objectid 264 offset 0 count 1
[  193.541564]  item 13 key (15310848 a8 262144) itemoff 3340 itemsize 53
[  193.541830]          extent refs 1 gen 149 flags 1
[  193.542063]          extent data backref root 1 objectid 265 offset 0 count 1
[  193.542330]  item 14 key (15572992 a8 262144) itemoff 3287 itemsize 53
[  193.542595]          extent refs 1 gen 149 flags 1
[  193.542824]          extent data backref root 1 objectid 266 offset 0 count 1
[  193.543085]  item 15 key (15835136 a8 262144) itemoff 3234 itemsize 53
[  193.543352]          extent refs 1 gen 149 flags 1
[  193.543577]          extent data backref root 1 objectid 267 offset 0 count 1
[  193.543844]  item 16 key (16097280 a8 262144) itemoff 3181 itemsize 53
[  193.544132]          extent refs 1 gen 149 flags 1
[  193.544364]          extent data backref root 1 objectid 268 offset 0 count 1
[  193.544628]  item 17 key (16359424 a8 262144) itemoff 3128 itemsize 53
[  193.544894]          extent refs 1 gen 149 flags 1
[  193.545120]          extent data backref root 1 objectid 269 offset 0 count 1
[  193.545387]  item 18 key (16621568 a8 262144) itemoff 3075 itemsize 53
[  193.545654]          extent refs 1 gen 149 flags 1
[  193.545883]          extent data backref root 1 objectid 270 offset 0 count 1
[  193.546152]  item 19 key (16883712 a8 262144) itemoff 3022 itemsize 53
[  193.546418]          extent refs 1 gen 149 flags 1
[  193.546646]          extent data backref root 1 objectid 271 offset 0 count 1
[  193.546903]  item 20 key (17145856 a8 262144) itemoff 2969 itemsize 53
[  193.547184]          extent refs 1 gen 149 flags 1
[  193.547413]          extent data backref root 1 objectid 272 offset 0 count 1
[  193.547703]  item 21 key (17408000 a8 262144) itemoff 2916 itemsize 53
[  193.547967]          extent refs 1 gen 151 flags 1
[  193.548215]          extent data backref root 1 objectid 281 offset 0 count 1
[  193.548481]  item 22 key (17670144 a8 262144) itemoff 2863 itemsize 53
[  193.548749]          extent refs 1 gen 150 flags 1
[  193.548978]          extent data backref root 1 objectid 274 offset 0 count 1
[  193.549246]  item 23 key (17932288 a8 262144) itemoff 2810 itemsize 53
[  193.549515]          extent refs 1 gen 150 flags 1
[  193.549743]          extent data backref root 1 objectid 275 offset 0 count 1
[  193.550014]  item 24 key (18194432 a8 262144) itemoff 2757 itemsize 53
[  193.550277]          extent refs 1 gen 150 flags 1
[  193.550507]          extent data backref root 1 objectid 276 offset 0 count 1
[  193.550773]  item 25 key (18456576 a8 262144) itemoff 2704 itemsize 53
[  193.551043]          extent refs 1 gen 150 flags 1
[  193.551271]          extent data backref root 1 objectid 277 offset 0 count 1
[  193.551536]  item 26 key (18718720 a8 262144) itemoff 2651 itemsize 53
[  193.551803]          extent refs 1 gen 150 flags 1
[  193.552051]          extent data backref root 1 objectid 278 offset 0 count 1
[  193.552323]  item 27 key (18980864 a8 262144) itemoff 2598 itemsize 53
[  193.552589]          extent refs 1 gen 150 flags 1
[  193.552819]          extent data backref root 1 objectid 279 offset 0 count 1
[  193.553086]  item 28 key (19243008 a8 262144) itemoff 2545 itemsize 53
[  193.553349]          extent refs 1 gen 150 flags 1
[  193.553575]          extent data backref root 1 objectid 280 offset 0 count 1
[  193.553842]  item 29 key (19505152 a8 262144) itemoff 2492 itemsize 53
[  193.554115]          extent refs 1 gen 152 flags 1
[  193.554346]          extent data backref root 1 objectid 289 offset 0 count 1
[  193.554611]  item 30 key (19767296 a8 262144) itemoff 2439 itemsize 53
[  193.554876]          extent refs 1 gen 151 flags 1
[  193.555102]          extent data backref root 1 objectid 282 offset 0 count 1
[  193.555371]  item 31 key (20029440 a8 262144) itemoff 2386 itemsize 53
[  193.555638]          extent refs 1 gen 151 flags 1
[  193.555868]          extent data backref root 1 objectid 283 offset 0 count 1
[  193.556155]  item 32 key (20291584 a8 262144) itemoff 2333 itemsize 53
[  193.557227]          extent refs 1 gen 151 flags 1
[  193.557459]          extent data backref root 1 objectid 284 offset 0 count 1
[  193.557733]  item 33 key (20553728 a8 262144) itemoff 2280 itemsize 53
[  193.558325]          extent refs 1 gen 151 flags 1
[  193.558563]          extent data backref root 1 objectid 285 offset 0 count 1
[  193.558831]  item 34 key (20971520 c0 8388608) itemoff 2256 itemsize 24
[  193.559101]          block group used 16384
[  193.559324]  item 35 key (20983808 a8 4096) itemoff 2205 itemsize 51
[  193.559593]          extent refs 1 gen 24 flags 2
[  193.559825]          tree block key (256 e4 34389098496) level 0
[  193.560117]          tree block backref root 3
[  193.560345]  item 36 key (20987904 a8 4096) itemoff 2154 itemsize 51
[  193.560614]          extent refs 1 gen 25 flags 2
[  193.560858]          tree block key (1 d8 1) level 1
[  193.561092]          tree block backref root 3
[  193.561318]  item 37 key (20992000 a8 4096) itemoff 2103 itemsize 51
[  193.561582]          extent refs 1 gen 25 flags 2
[  193.561813]          tree block key (1 d8 1) level 0
[  193.562054]          tree block backref root 3
[  193.562276]  item 38 key (20996096 a8 4096) itemoff 2052 itemsize 51
[  193.562543]          extent refs 1 gen 25 flags 2
[  193.562773]          tree block key (256 e4 75191287808) level 0
[  193.563026]          tree block backref root 3
[  193.563251]  item 39 key (29360128 a8 4096) itemoff 2001 itemsize 51
[  193.563515]          extent refs 1 gen 155 flags 2
[  193.563745]          tree block key (2 84 0) level 1
[  193.563980]          tree block backref root 1
[  193.564232]  item 40 key (29360128 c0 1073741824) itemoff 1977 itemsize 24
[  193.564507]          block group used 1900544
[  193.564731]  item 41 key (29380608 a8 4096) itemoff 1926 itemsize 51
[  193.564996]          extent refs 1 gen 4 flags 2
[  193.565224]          tree block key (256 1 0) level 0
[  193.565461]          tree block backref root 18446744073709551607
[  193.565712]  item 42 key (33206272 a8 4096) itemoff 1875 itemsize 51
[  193.565979]          extent refs 1 gen 154 flags 2
[  193.566211]          tree block key (1137688576 a8 262144) level 0
[  193.566467]          tree block backref root 2
[  193.566693]  item 43 key (33210368 a8 4096) itemoff 1824 itemsize 51
[  193.566956]          extent refs 1 gen 154 flags 2
[  193.567185]          tree block key (26872905728 a8 652713984) level 0
[  193.567442]          tree block backref root 2
[  193.567671]  item 44 key (40587264 a8 4096) itemoff 1773 itemsize 51
[  193.567941]          extent refs 1 gen 154 flags 2
[  193.568193]          tree block key (18446744073709551606 80 12636160) level 0
[  193.568464]          tree block backref root 7
[  193.568687]  item 45 key (58585088 a8 4096) itemoff 1722 itemsize 51
[  193.568955]          extent refs 1 gen 154 flags 2
[  193.569186]          tree block key (0 c0 4194304) level 1
[  193.569428]          tree block backref root 2
[  193.569651]  item 46 key (58589184 a8 4096) itemoff 1671 itemsize 51
[  193.569918]          extent refs 1 gen 154 flags 2
[  193.570151]          tree block key (0 c0 4194304) level 0
[  193.570394]          tree block backref root 2
[  193.570616]  item 47 key (61440000 a8 4096) itemoff 1620 itemsize 51
[  193.570879]          extent refs 1 gen 154 flags 2
[  193.571110]          tree block key (1087504384 a8 4096) level 0
[  193.571363]          tree block backref root 2
[  193.571589]  item 48 key (61444096 a8 4096) itemoff 1569 itemsize 51
[  193.571854]          extent refs 1 gen 154 flags 2
[  193.572107]          tree block key (1088356352 a8 4096) level 0
[  193.572362]          tree block backref root 2
[  193.572589] ------------[ cut here ]------------
[  193.572835] WARNING: at fs/btrfs/extent-tree.c:5175 __btrfs_free_extent+0x716/0x850 [btrfs]()
[  193.573251] Hardware name: Bochs
[  193.573467] Modules linked in: btrfs zlib_deflate libcrc32c nfsv3 nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul tpm_tis tpm tpm_bios vmwgfx snd_pcm snd_timer snd microcode soundcore snd_page_alloc pcspkr psmouse serio_raw evdev parport_pc parport ttm drm i2c_piix4 processor i2c_core thermal_sys button ext4 mbcache jbd2 crc16 sg sr_mod cdrom ata_generic virtio_blk virtio_net ata_piix libata virtio_pci virtio_ring scsi_mod virtio floppy
[  193.578368] Pid: 6211, comm: umount Not tainted 3.8.0-rc3+ #2
[  193.578626] Call Trace:
[  193.578837]  [<ffffffff8105ce4f>] warn_slowpath_common+0x7f/0xc0
[  193.579099]  [<ffffffff8105ceaa>] warn_slowpath_null+0x1a/0x20
[  193.579361]  [<ffffffffa04d0c06>] __btrfs_free_extent+0x716/0x850 [btrfs]
[  193.579640]  [<ffffffffa04d0e72>] ? run_clustered_refs+0x132/0xb20 [btrfs]
[  193.579922]  [<ffffffffa04d1417>] run_clustered_refs+0x6d7/0xb20 [btrfs]
[  193.580225]  [<ffffffffa04d1930>] btrfs_run_delayed_refs+0xd0/0x320 [btrfs]
[  193.580514]  [<ffffffffa04e73c9>] commit_cowonly_roots+0xb9/0x290 [btrfs]
[  193.580796]  [<ffffffffa04e83dd>] btrfs_commit_transaction+0x6ad/0xbf0 [btrfs]
[  193.581202]  [<ffffffffa04e6756>] ? btrfs_record_root_in_trans+0x16/0x90 [btrfs]
[  193.581604]  [<ffffffffa04e8e39>] ? start_transaction+0xa9/0x480 [btrfs]
[  193.581881]  [<ffffffff810884a0>] ? wake_up_bit+0x40/0x40
[  193.582143]  [<ffffffffa04e3d8b>] btrfs_commit_super+0x8b/0x110 [btrfs]
[  193.582419]  [<ffffffffa04e40e8>] close_ctree+0x2d8/0x320 [btrfs]
[  193.582689]  [<ffffffff811c8c34>] ? evict_inodes+0xf4/0x110
[  193.582949]  [<ffffffffa04b9009>] btrfs_put_super+0x19/0x20 [btrfs]
[  193.583220]  [<ffffffff811ae402>] generic_shutdown_super+0x62/0xf0
[  193.583485]  [<ffffffff811ae526>] kill_anon_super+0x16/0x30
[  193.583746]  [<ffffffffa04bcaca>] btrfs_kill_super+0x1a/0x90 [btrfs]
[  193.584034]  [<ffffffff811af9a2>] ? deactivate_super+0x42/0x70
[  193.584293]  [<ffffffff811aea3d>] deactivate_locked_super+0x3d/0x90
[  193.584558]  [<ffffffff811af9aa>] deactivate_super+0x4a/0x70
[  193.584815]  [<ffffffff811cec32>] mntput_no_expire+0xd2/0x130
[  193.585075]  [<ffffffff811cf8ae>] sys_umount+0x7e/0x3d0
[  193.585328]  [<ffffffff8155c529>] system_call_fastpath+0x16/0x1b
[  193.585587] ---[ end trace 01c25d80a115f51e ]---
[  193.585823] btrfs unable to find ref byte nr 61448192 parent 0 root 1  owner 1 offset 0
[  193.586264] ------------[ cut here ]------------
[  193.586505] kernel BUG at fs/btrfs/extent-tree.c:5230!
[  193.586748] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[  193.587150] Modules linked in: btrfs zlib_deflate libcrc32c nfsv3 nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul tpm_tis tpm tpm_bios vmwgfx snd_pcm snd_timer snd microcode soundcore snd_page_alloc pcspkr psmouse serio_raw evdev parport_pc parport ttm drm i2c_piix4 processor i2c_core thermal_sys button ext4 mbcache jbd2 crc16 sg sr_mod cdrom ata_generic virtio_blk virtio_net ata_piix libata virtio_pci virtio_ring scsi_mod virtio floppy
[  193.592200] CPU 1 
[  193.592283] Pid: 6211, comm: umount Tainted: G        W    3.8.0-rc3+ #2 Bochs Bochs
[  193.592843] RIP: 0010:[<ffffffffa04d0cdd>]  [<ffffffffa04d0cdd>] __btrfs_free_extent+0x7ed/0x850 [btrfs]
[  193.593332] RSP: 0018:ffff88010b7619a8  EFLAGS: 00010293
[  193.593580] RAX: 0000000000000fe8 RBX: ffff8801159e6b18 RCX: ffff88010b761958
[  193.593858] RDX: ffff880112eed000 RSI: 0000000000000f83 RDI: ffff88010f487d50
[  193.594143] RBP: ffff88010b761a88 R08: 0000000000000018 R09: ffff88010b761948
[  193.594420] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  193.594699] R13: 00000000fffffffe R14: 0000000003a9a000 R15: ffff88010f487d50
[  193.594984] FS:  00007f31215ec740(0000) GS:ffff88011b000000(0000) knlGS:0000000000000000
[  193.595396] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  193.595651] CR2: 00007f3120c9b772 CR3: 0000000112ef0000 CR4: 00000000000407e0
[  193.595932] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  193.596227] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  193.596510] Process umount (pid: 6211, threadinfo ffff88010b760000, task ffff88010bae4a80)
[  193.596921] Stack:
[  193.597115]  0000000000000000 0000000000000001 0000000000000001 0000000000000000
[  193.597711]  ffff880100000000 ffff88010b989538 ffff88010b989588 ffff880100000018
[  193.598315]  0000000000000000 ffff88010cb7b000 0000000000001000 ffff88010b81f000
[  193.598913] Call Trace:
[  193.599122]  [<ffffffffa04d0e72>] ? run_clustered_refs+0x132/0xb20 [btrfs]
[  193.599405]  [<ffffffffa04d1417>] run_clustered_refs+0x6d7/0xb20 [btrfs]
[  193.599686]  [<ffffffffa04d1930>] btrfs_run_delayed_refs+0xd0/0x320 [btrfs]
[  193.599971]  [<ffffffffa04e73c9>] commit_cowonly_roots+0xb9/0x290 [btrfs]
[  193.600268]  [<ffffffffa04e83dd>] btrfs_commit_transaction+0x6ad/0xbf0 [btrfs]
[  193.600672]  [<ffffffffa04e6756>] ? btrfs_record_root_in_trans+0x16/0x90 [btrfs]
[  193.601079]  [<ffffffffa04e8e39>] ? start_transaction+0xa9/0x480 [btrfs]
[  193.601352]  [<ffffffff810884a0>] ? wake_up_bit+0x40/0x40
[  193.601609]  [<ffffffffa04e3d8b>] btrfs_commit_super+0x8b/0x110 [btrfs]
[  193.601889]  [<ffffffffa04e40e8>] close_ctree+0x2d8/0x320 [btrfs]
[  193.602160]  [<ffffffff811c8c34>] ? evict_inodes+0xf4/0x110
[  193.602422]  [<ffffffffa04b9009>] btrfs_put_super+0x19/0x20 [btrfs]
[  193.602691]  [<ffffffff811ae402>] generic_shutdown_super+0x62/0xf0
[  193.602954]  [<ffffffff811ae526>] kill_anon_super+0x16/0x30
[  193.603211]  [<ffffffffa04bcaca>] btrfs_kill_super+0x1a/0x90 [btrfs]
[  193.603479]  [<ffffffff811af9a2>] ? deactivate_super+0x42/0x70
[  193.603738]  [<ffffffff811aea3d>] deactivate_locked_super+0x3d/0x90
[  193.604023]  [<ffffffff811af9aa>] deactivate_super+0x4a/0x70
[  193.604284]  [<ffffffff811cec32>] mntput_no_expire+0xd2/0x130
[  193.604544]  [<ffffffff811cf8ae>] sys_umount+0x7e/0x3d0
[  193.604792]  [<ffffffff8155c529>] system_call_fastpath+0x16/0x1b
[  193.605048] Code: 30 14 00 00 48 c7 c2 60 63 55 a0 e8 3e 99 fe ff e9 ea f9 ff ff be 70 14 00 00 48 c7 c7 6c 84 55 a0 e8 b8 c1 b8 e0 e9 f3 fb ff ff <0f> 0b eb fe 0f 0b eb fe 89 c6 4c 89 f2 48 c7 c7 40 aa 55 a0 31 
[  193.609070] RIP  [<ffffffffa04d0cdd>] __btrfs_free_extent+0x7ed/0x850 [btrfs]
[  193.609408]  RSP <ffff88010b7619a8>
[  193.609630] ---[ end trace 01c25d80a115f51f ]---
[  193.609869] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[  193.610273] in_atomic(): 1, irqs_disabled(): 0, pid: 6211, name: umount
[  193.610543] INFO: lockdep is turned off.
[  193.610770] Pid: 6211, comm: umount Tainted: G      D W    3.8.0-rc3+ #2
[  193.611039] Call Trace:
[  193.611241]  [<ffffffff810992ec>] __might_sleep+0x18c/0x240
[  193.611499]  [<ffffffff81550836>] down_read+0x26/0xa0
[  193.611746]  [<ffffffff81076124>] exit_signals+0x24/0x140
[  193.611999]  [<ffffffff81063bcc>] do_exit+0xbc/0xb70
[  193.612258]  [<ffffffff81060db8>] ? kmsg_dump+0x1d8/0x2a0
[  193.613281]  [<ffffffff81060c06>] ? kmsg_dump+0x26/0x2a0
[  193.613533]  [<ffffffff8155469c>] oops_end+0xac/0xf0
[  193.613778]  [<ffffffff8101993b>] die+0x5b/0x90
[  193.614019]  [<ffffffff81554023>] do_trap+0xc3/0x170
[  193.614263]  [<ffffffff81017855>] do_invalid_op+0x95/0xb0
[  193.614525]  [<ffffffffa04d0cdd>] ? __btrfs_free_extent+0x7ed/0x850 [btrfs]
[  193.614810]  [<ffffffff812c507d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  193.615080]  [<ffffffff815537a3>] ? restore_args+0x30/0x30
[  193.615330]  [<ffffffff8155d6ee>] invalid_op+0x1e/0x30
[  193.615581]  [<ffffffffa04d0cdd>] ? __btrfs_free_extent+0x7ed/0x850 [btrfs]
[  193.615862]  [<ffffffffa04d088b>] ? __btrfs_free_extent+0x39b/0x850 [btrfs]
[  193.616158]  [<ffffffffa04d0e72>] ? run_clustered_refs+0x132/0xb20 [btrfs]
[  193.616441]  [<ffffffffa04d1417>] run_clustered_refs+0x6d7/0xb20 [btrfs]
[  193.616720]  [<ffffffffa04d1930>] btrfs_run_delayed_refs+0xd0/0x320 [btrfs]
[  193.617005]  [<ffffffffa04e73c9>] commit_cowonly_roots+0xb9/0x290 [btrfs]
[  193.617289]  [<ffffffffa04e83dd>] btrfs_commit_transaction+0x6ad/0xbf0 [btrfs]
[  193.617691]  [<ffffffffa04e6756>] ? btrfs_record_root_in_trans+0x16/0x90 [btrfs]
[  193.618194]  [<ffffffffa04e8e39>] ? start_transaction+0xa9/0x480 [btrfs]
[  193.618469]  [<ffffffff810884a0>] ? wake_up_bit+0x40/0x40
[  193.618723]  [<ffffffffa04e3d8b>] btrfs_commit_super+0x8b/0x110 [btrfs]
[  193.619004]  [<ffffffffa04e40e8>] close_ctree+0x2d8/0x320 [btrfs]
[  193.619271]  [<ffffffff811c8c34>] ? evict_inodes+0xf4/0x110
[  193.619532]  [<ffffffffa04b9009>] btrfs_put_super+0x19/0x20 [btrfs]
[  193.619803]  [<ffffffff811ae402>] generic_shutdown_super+0x62/0xf0
[  193.620087]  [<ffffffff811ae526>] kill_anon_super+0x16/0x30
[  193.620351]  [<ffffffffa04bcaca>] btrfs_kill_super+0x1a/0x90 [btrfs]
[  193.620620]  [<ffffffff811af9a2>] ? deactivate_super+0x42/0x70
[  193.620876]  [<ffffffff811aea3d>] deactivate_locked_super+0x3d/0x90
[  193.621142]  [<ffffffff811af9aa>] deactivate_super+0x4a/0x70
[  193.621400]  [<ffffffff811cec32>] mntput_no_expire+0xd2/0x130
[  193.621660]  [<ffffffff811cf8ae>] sys_umount+0x7e/0x3d0
[  193.621912]  [<ffffffff8155c529>] system_call_fastpath+0x16/0x1b
[  193.622179] note: umount[6211] exited with preempt_count 2

