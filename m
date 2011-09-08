From: Arne Jansen <sensille@gmx.net>
Subject: Re: Btrfs moved my root tree off the end of the device
Date: Thu, 08 Sep 2011 07:51:23 +0200
Message-ID: <4E6857DB.4020604@gmx.net>
References: <loom.20110908T005218-836@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Justin Gottula <justin@jgottula.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110908T005218-836@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 08.09.2011 01:33, Justin Gottula wrote:
> Hi,
> 
> 
> I recently created a Btrfs volume on top of a software (mdadm) raid5 array
> (since Btrfs currently lacks raid5 support at the FS level). On this 640 GB
> volume, I stored a ~400 GB tar file. After a couple weeks of use, I used 'btrfs
> defragment' on this file in an effort to (a) defrag and (b) compress the file. I
> made sure I was using the latest version of the userspace utilities (Btrfs
> v0.19-35-g1b444cd-dirty) as well as kernel 3.0.

I think Liu Bo posted a fix for this a while ago:

[PATCH] Btrfs: fix a bug of balance on full multi-disk partitions

-Arne

> Now, this may or may not have had something to do with the drives being at 55
> celsius, which I only discovered later, but after I had left this operation to
> work overnight, I came back to some scary messages in the kernel log.
> Immediately after the operation started (as far as I can tell), the following
> messages showed up in the kernel log:
> 
> 
> [17055.793912] btrfs: relocating block group 636489826304 flags 1
> 
> [17112.566998] attempt to access beyond end of device
> [17112.567003] md127p1: rw=145, want=1248172032, limit=1248171999
> [17112.567004] attempt to access beyond end of device
> [17112.567006] md127p1: rw=145, want=1248172280, limit=1248171999
> [17112.567008] attempt to access beyond end of device
> [17112.567009] md127p1: rw=145, want=1248172416, limit=1248171999
> [17112.567011] attempt to access beyond end of device
> [17112.567012] md127p1: rw=145, want=1248172664, limit=1248171999
> [17112.567014] attempt to access beyond end of device
> [17112.567015] md127p1: rw=145, want=1248172912, limit=1248171999
> [17112.567016] attempt to access beyond end of device
> [17112.567018] md127p1: rw=145, want=1248172928, limit=1248171999
> (thousands more of the above in rapid succession)
> 
> 
> and occasionally a few of these:
> 
> 
> [17157.916746] btrfs csum failed ino 258 off 8192 csum 2566472073 private
> 1679206033
> [17157.916758] btrfs csum failed ino 258 off 12288 csum 2566472073 private
> 248979876
> [17157.916771] btrfs csum failed ino 258 off 16384 csum 2566472073 private
> 3790022839
> 
> 
> Then, later, another burst of the same device access warnings followed by this:
> 
> 
> [20063.971837] ------------[ cut here ]------------
> [20063.972050] kernel BUG at fs/btrfs/ctree.c:300!
> [20063.972238] invalid opcode: 0000 [#1] PREEMPT SMP 
> [20063.972666] CPU 0 
> [20063.972669] Modules linked in: ipv6 loop nouveau snd_hda_codec_via ttm
> drm_kms_helper drm r8169 forcedeth i2c_nforce2 mii ppdev i2c_algo_bit mxm_wmi
> parport_pc wmi pcspkr video parport asus_atk0110 snd_hda_intel evdev sg
> edac_core edac_mce_amd snd_hda_codec processor psmouse button snd_hwdep snd_pcm
> snd_timer snd soundcore snd_page_alloc k10temp serio_raw i2c_core usbhid hid
> raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx
> raid0 btrfs zlib_deflate crc32c libcrc32c ext4 mbcache jbd2 crc16 ohci_hcd
> ehci_hcd usbcore md_mod sata_nv sd_mod pata_amd libata scsi_mod
> [20063.974670] 
> [20063.974670] Pid: 7425, comm: btrfs-endio-wri Not tainted 3.0-ARCH #1 System
> manufacturer System Product Name/M4N68T-M-V2
> [20063.974670] RIP: 0010:[<ffffffffa01a1df1>]  [<ffffffffa01a1df1>]
> update_ref_for_cow+0x331/0x340 [btrfs]
> [20063.974670] RSP: 0018:ffff8800236798b0  EFLAGS: 00010282
> [20063.974670] RAX: 00000000fffffffb RBX: ffff88002539f000 RCX: 00000001bc22b580
> [20063.974670] RDX: 00000001bc22b540 RSI: 000060ffc24024f0 RDI: ffffea0000cb7930
> [20063.974670] RBP: ffff880023679900 R08: ffffffffa01a121a R09: 0000000000000000
> [20063.974670] R10: 00000000fffffffb R11: 0000000000000001 R12: ffff880020a72a00
> [20063.974670] R13: ffff880037c7f000 R14: ffff88002c24fc00 R15: ffff88002367997c
> [20063.974670] FS:  00007f6c7ea81740(0000) GS:ffff88003d800000(0000)
> knlGS:0000000000000000
> [20063.974670] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [20063.974670] CR2: 00007fe40de62000 CR3: 0000000025978000 CR4: 00000000000006f0
> [20063.974670] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [20063.974670] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [20063.974670] Process btrfs-endio-wri (pid: 7425, threadinfo ffff880023678000,
> task ffff88003a43f300)
> [20063.974670] Stack:
> [20063.974670]  0000000000001000 ffff880023678000 ffff880023679fd8
> ffff880025cb8010
> [20063.974670]  ffff880023679910 ffff88002539f000 ffff88002c24fc00
> ffff880020a72a00
> [20063.974670]  ffff880037c7f000 ffff880003955900 ffff8800236799b0
> ffffffffa01a2276
> [20063.974670] Call Trace:
> [20063.974670]  [<ffffffffa01a2276>] __btrfs_cow_block+0x476/0x890 [btrfs]
> [20063.974670]  [<ffffffffa01a27a8>] btrfs_cow_block+0x118/0x360 [btrfs]
> [20063.974670]  [<ffffffffa01a7e0e>] btrfs_search_slot+0x1de/0x900 [btrfs]
> [20063.974670]  [<ffffffffa01bac58>] btrfs_lookup_file_extent+0x38/0x40 [btrfs]
> [20063.974670]  [<ffffffffa01d54c4>] btrfs_drop_extents+0x104/0xa10 [btrfs]
> [20063.974670]  [<ffffffffa01cadf3>]
> insert_reserved_file_extent.constprop.47+0x73/0x250 [btrfs]
> [20063.974670]  [<ffffffffa01c6007>] ? start_transaction+0x97/0x2b0 [btrfs]
> [20063.974670]  [<ffffffffa01cbf9a>] btrfs_finish_ordered_io+0x2da/0x320 [btrfs]
> [20063.974670]  [<ffffffffa01cc02d>] btrfs_writepage_end_io_hook+0x4d/0xf0
> [btrfs]
> [20063.974670]  [<ffffffffa01e5c9f>] end_bio_extent_writepage+0x12f/0x170
> [btrfs]
> [20063.974670]  [<ffffffff811894fd>] bio_endio+0x1d/0x40
> [20063.974670]  [<ffffffffa01becf6>] end_workqueue_fn+0x56/0x140 [btrfs]
> [20063.974670]  [<ffffffffa01f2c15>] worker_loop+0x165/0x520 [btrfs]
> [20063.974670]  [<ffffffffa01f2ab0>] ? btrfs_queue_worker+0x2f0/0x2f0 [btrfs]
> [20063.974670]  [<ffffffff8107ee9c>] kthread+0x8c/0xa0
> [20063.974670]  [<ffffffff813f5b64>] kernel_thread_helper+0x4/0x10
> [20063.974670]  [<ffffffff8107ee10>] ? kthread_worker_fn+0x190/0x190
> [20063.974670]  [<ffffffff813f5b60>] ? gs_change+0x13/0x13
> [20063.974670] Code: 48 8b 45 b8 e9 1c fe ff ff f6 45 c9 01 0f 85 1c fe ff ff 0f
> 0b 0f 0b 48 89 45 b8 e8 ba f6 24 e1 48 8b 45 b8 e9 89 fd ff ff 0f 0b <0f> 0b 0f
> 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 
> [20063.974670] RIP  [<ffffffffa01a1df1>] update_ref_for_cow+0x331/0x340 [btrfs]
> [20063.974670]  RSP <ffff8800236798b0>
> [20063.974670] [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encoder
> (output 0)
> [20064.021164] ---[ end trace 5d092910be378bb8 ]---
> [20098.068178] attempt to access beyond end of device
> [20098.068495] md127p1: rw=0, want=1250270168, limit=1248171999
> [20098.069269] attempt to access beyond end of device
> [20098.070180] md127p1: rw=0, want=1250270168, limit=1248171999
> [20098.071105] attempt to access beyond end of device
> [20098.072280] md127p1: rw=0, want=1250532312, limit=1248171999
> [20098.072973] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000030
> [20098.073881] IP: [<ffffffffa01b8027>] btrfs_print_leaf+0x37/0x880 [btrfs]
> [20098.074824] PGD 39989067 PUD 39aed067 PMD 0 
> [20098.075361] Oops: 0000 [#2] PREEMPT SMP 
> [20098.075361] CPU 0 
> [20098.075361] Modules linked in: ipv6 loop nouveau snd_hda_codec_via ttm
> drm_kms_helper drm r8169 forcedeth i2c_nforce2 mii ppdev i2c_algo_bit mxm_wmi
> parport_pc wmi pcspkr video parport asus_atk0110 snd_hda_intel evdev sg
> edac_core edac_mce_amd snd_hda_codec processor psmouse button snd_hwdep snd_pcm
> snd_timer snd soundcore snd_page_alloc k10temp serio_raw i2c_core usbhid hid
> raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx
> raid0 btrfs zlib_deflate crc32c libcrc32c ext4 mbcache jbd2 crc16 ohci_hcd
> ehci_hcd usbcore md_mod sata_nv sd_mod pata_amd libata scsi_mod
> [20098.075361] 
> [20098.075361] Pid: 7416, comm: btrfs-transacti Tainted: G      D     3.0-ARCH
> #1 System manufacturer System Product Name/M4N68T-M-V2
> [20098.075361] RIP: 0010:[<ffffffffa01b8027>]  [<ffffffffa01b8027>]
> btrfs_print_leaf+0x37/0x880 [btrfs]
> [20098.075361] RSP: 0018:ffff880009437af0  EFLAGS: 00010286
> [20098.075361] RAX: 00000000fffffffb RBX: 0000000000000000 RCX: ffff880009437fd8
> [20098.075361] RDX: ffff880009436000 RSI: 0000000000000000 RDI: ffff88002539f800
> [20098.075361] RBP: ffff880009437b80 R08: 0000000000000001 R09: 0000000000000000
> [20098.075361] R10: 00000000fffffffb R11: 0000000000000001 R12: 0000000000000101
> [20098.075361] R13: 00000094db37b000 R14: 00000000fffffffb R15: 0000000000001000
> [20098.075361] FS:  00007fdcd1611700(0000) GS:ffff88003d800000(0000)
> knlGS:0000000000000000
> [20098.075361] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [20098.075361] CR2: 0000000000000030 CR3: 0000000039abd000 CR4: 00000000000006f0
> [20098.075361] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [20098.075361] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [20098.075361] Process btrfs-transacti (pid: 7416, threadinfo ffff880009436000,
> task ffff88003ba2dd70)
> [20098.075361] Stack:
> [20098.075361]  0000000000002000 0000000000001000 ffff880009437c28
> 00000094db37b000
> [20098.075361]  0000000000000000 ffffffff81142ad3 ffff88002539f800
> 0000000000000090
> [20098.075361]  0000000000000090 000080503a22a120 a800000094db37b0
> 0000000000001000
> [20098.075361] Call Trace:
> [20098.075361]  [<ffffffff81142ad3>] ? kmem_cache_alloc+0x133/0x160
> [20098.075361]  [<ffffffffa01b02df>] __btrfs_free_extent+0x61f/0x6d0 [btrfs]
> [20098.075361]  [<ffffffffa01b2b6d>] ? run_clustered_refs+0x11d/0x830 [btrfs]
> [20098.075361]  [<ffffffffa01b2dd9>] run_clustered_refs+0x389/0x830 [btrfs]
> [20098.075361]  [<ffffffff813f0b6e>] ? schedule+0x34e/0x9f0
> [20098.075361]  [<ffffffffa0205400>] ? btrfs_find_ref_cluster+0x20/0x190 [btrfs]
> [20098.075361]  [<ffffffffa01b3348>] btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
> [20098.075361]  [<ffffffff813f27ee>] ? mutex_unlock+0xe/0x10
> [20098.075361]  [<ffffffffa01c5381>] btrfs_commit_transaction+0x81/0x8a0 [btrfs]
> [20098.075361]  [<ffffffff8107f7f0>] ? abort_exclusive_wait+0xb0/0xb0
> [20098.075361]  [<ffffffffa01be3ed>] transaction_kthread+0x26d/0x290 [btrfs]
> [20098.075361]  [<ffffffffa01be180>] ? btrfs_congested_fn+0xd0/0xd0 [btrfs]
> [20098.075361]  [<ffffffff8107ee9c>] kthread+0x8c/0xa0
> [20098.075361]  [<ffffffff813f5b64>] kernel_thread_helper+0x4/0x10
> [20098.075361]  [<ffffffff8107ee10>] ? kthread_worker_fn+0x190/0x190
> [20098.075361]  [<ffffffff813f5b60>] ? gs_change+0x13/0x13
> [20098.075361] Code: 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 66
> 66 66 66 90 65 48 8b 0c 25 48 cd 00 00 48 8d 91 28 e0 ff ff 48 89 f3 
> [20098.075361] RIP  [<ffffffffa01b8027>] btrfs_print_leaf+0x37/0x880 [btrfs]
> [20098.075361]  RSP <ffff880009437af0>
> [20098.075361] CR2: 0000000000000030
> [20098.121409] ---[ end trace 5d092910be378bb9 ]---
> 
> 
> And some time later, this:
> 
> 
> [36853.419291] ------------[ cut here ]------------
> [36853.419852] kernel BUG at fs/btrfs/extent-tree.c:5510!
> [36853.419852] invalid opcode: 0000 [#3] PREEMPT SMP 
> [36853.419852] CPU 0 
> [36853.419852] Modules linked in: ipv6 loop nouveau snd_hda_codec_via ttm
> drm_kms_helper drm r8169 forcedeth i2c_nforce2 mii ppdev i2c_algo_bit mxm_wmi
> parport_pc wmi pcspkr video parport asus_atk0110 snd_hda_intel evdev sg
> edac_core edac_mce_amd snd_hda_codec processor psmouse button snd_hwdep snd_pcm
> snd_timer snd soundcore snd_page_alloc k10temp serio_raw i2c_core usbhid hid
> raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx
> raid0 btrfs zlib_deflate crc32c libcrc32c ext4 mbcache jbd2 crc16 ohci_hcd
> ehci_hcd usbcore md_mod sata_nv sd_mod pata_amd libata scsi_mod
> [36853.419852] 
> [36853.419852] Pid: 7413, comm: btrfs-delayed-m Tainted: G      D     3.0-ARCH
> #1 System manufacturer System Product Name/M4N68T-M-V2
> [36853.419852] RIP: 0010:[<ffffffffa01b3263>]  [<ffffffffa01b3263>]
> run_clustered_refs+0x813/0x830 [btrfs]
> [36853.419852] RSP: 0018:ffff880025c13c10  EFLAGS: 00010282
> [36853.419852] RAX: 00000000fffffffb RBX: ffff880025dfc2a0 RCX: ffff88002a2ceb80
> [36853.419852] RDX: 0000000000000008 RSI: 00000094db37a000 RDI: 0000000000000000
> [36853.419852] RBP: ffff880025c13cf0 R08: 0000000000000001 R09: 0000000000000000
> [36853.419852] R10: ffff88002539f800 R11: ffff880037c7f090 R12: ffff88002869c3c0
> [36853.419852] R13: ffff88001c5b7200 R14: ffff88000a66a1e0 R15: 0000000000000000
> [36853.419852] FS:  00007fd708110700(0000) GS:ffff88003d800000(0000)
> knlGS:0000000000000000
> [36853.419852] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [36853.419852] CR2: 00000000017bd048 CR3: 000000001e1cc000 CR4: 00000000000006f0
> [36853.419852] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [36853.419852] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [36853.419852] Process btrfs-delayed-m (pid: 7413, threadinfo ffff880025c12000,
> task ffff88003a7bebd0)
> [36853.419852] Stack:
> [36853.419852]  ffff880025398800 0000000000000000 ffff880025c13c60
> ffffffffa01a45f1
> [36853.419852]  ffff880025c13c40 000000033a22a5a0 0000000000000000
> 0000000000000002
> [36853.419852]  ffff880026b69d00 ffff880025c13d28 0000000000000000
> ffff880025c13d30
> [36853.419852] Call Trace:
> [36853.419852]  [<ffffffffa01a45f1>] ? bin_search+0x81/0x130 [btrfs]
> [36853.419852]  [<ffffffffa01b3348>] btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
> [36853.419852]  [<ffffffffa01c5c53>] __btrfs_end_transaction+0x83/0x320 [btrfs]
> [36853.419852]  [<ffffffffa01c5f08>] btrfs_end_transaction_dmeta+0x18/0x20
> [btrfs]
> [36853.419852]  [<ffffffffa020f8b8>]
> btrfs_async_run_delayed_node_done+0xd8/0x1a0 [btrfs]
> [36853.419852]  [<ffffffffa01f2c15>] worker_loop+0x165/0x520 [btrfs]
> [36853.419852]  [<ffffffffa01f2ab0>] ? btrfs_queue_worker+0x2f0/0x2f0 [btrfs]
> [36853.419852]  [<ffffffff8107ee9c>] kthread+0x8c/0xa0
> [36853.419852]  [<ffffffff813f5b64>] kernel_thread_helper+0x4/0x10
> [36853.419852]  [<ffffffff8107ee10>] ? kthread_worker_fn+0x190/0x190
> [36853.419852]  [<ffffffff813f5b60>] ? gs_change+0x13/0x13
> [36853.419852] Code: e0 e9 12 f9 ff ff 0f 0b 80 fa b2 0f 84 bc f9 ff ff 0f 0b be
> 95 00 00 00 48 c7 c7 37 a0 21 a0 e8 d4 95 ea e0 e9 04 f9 ff ff 0f 0b <0f> 0b 0f
> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 66 66 66 66 66 2e 
> [36853.419852] RIP  [<ffffffffa01b3263>] run_clustered_refs+0x813/0x830 [btrfs]
> [36853.419852]  RSP <ffff880025c13c10>
> [36853.419852] [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encoder
> (output 0)
> [36853.473157] ---[ end trace 5d092910be378bba ]---
> 
> 
> On the next boot, the volume wouldn't mount:
> 
> 
> [    7.010353] btrfs: use zlib compression
> [    7.040893] attempt to access beyond end of device
> [    7.040896] md126p1: rw=0, want=1250270312, limit=1248171999
> [    7.040902] attempt to access beyond end of device
> [    7.040904] md126p1: rw=0, want=1250270312, limit=1248171999
> [    7.040908] attempt to access beyond end of device
> [    7.040910] md126p1: rw=0, want=1250532456, limit=1248171999
> [    7.040914] btrfs: failed to read tree root on md126p1
> [    7.046842] btrfs: open_ctree failed
> 
> 
> At this point, I took a disk image and dived in, and in doing so discovered that
> somehow, there were CHUNK_ITEMs in the chunk tree that referred to physical
> address ranges that were entirely outside of the device (matching up to the
> ranges showing up in the kernel log over and over). Evidently, the filesystem
> driver thought it should move the root tree onto a chunk that existed at a
> nonexistant offset in the device. I checked the superblocks and verified that
> the total_bytes fields matched up correctly to the actual device size, which
> leaves me wondering how those chunks ever got there.
> 
> I hope this report proves useful for finding the bug responsible for this. If
> complete logs, details about versions used or steps taken, diagnostic output
> from system commands, or particular pieces of the disk image would be helpful
> for debugging this problem, I can provide them.
> 
> 
> Thanks,
> 
> Justin
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

