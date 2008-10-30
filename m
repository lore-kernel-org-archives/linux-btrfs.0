From: Paul P Komkoff Jr <i@stingr.net>
Subject: Re: New disk format in -unstable (compression!)
Date: Thu, 30 Oct 2008 16:01:54 +0300
Message-ID: <20081030130154.GL19187@stingr.net>
References: <1225306556.6448.277.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1225306556.6448.277.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Replying to Chris Mason:
> Hello everyone,

Hi.

> I've pushed out the compression code along with a new disk format to the

First!

This is when restoring a tar file with 2.5M small files.

btrfs: use compression
BUG: unable to handle kernel paging request at ffffffff812a0d4d
IP: [<ffffffffa04fed42>] btrfs_submit_compressed_write+0x120/0x262 [btrfs]
PGD 203067 PUD 207063 PMD 21c11f161 PTE 4a0161
Oops: 0003 [1] SMP 
CPU 1 
Modules linked in: btrfs deflate zlib_deflate crc32c libcrc32c fuse ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath raid1 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq ppdev snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore floppy snd_page_alloc pcspkr i2c_i801 radeon drm parport_pc parport i2c_algo_bit iTCO_wdt i3000_edac iTCO_vendor_support edac_core i2c_core shpchp e1000e raid456 async_xor async_memcpy async_tx xor raid10 [last unloaded: microcode]
Pid: 247, comm: pdflush Not tainted 2.6.27.4-61.fc10.x86_64 #1
RIP: 0010:[<ffffffffa04fed42>]  [<ffffffffa04fed42>] btrfs_submit_compressed_write+0x120/0x262 [btrfs]
RSP: 0018:ffff88021cdc17a0  EFLAGS: 00010206
RAX: ffff88018f438638 RBX: ffff88021c498300 RCX: 0000000000001000
RDX: 0000000000000000 RSI: ffff88021c498300 RDI: ffff88021c0a0f30
RBP: ffff88021cdc1800 R08: 0000000000000000 R09: 0000000000000400
R10: ffff88021c498300 R11: 0000080000000001 R12: ffff8801eed37120
R13: ffffffff812a0d35 R14: 0000000041d71000 R15: ffff88018f438528
FS:  0000000000000000(0000) GS:ffff88021fc04980(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffffff812a0d4d CR3: 00000002190ea000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pdflush (pid: 247, threadinfo ffff88021cdc0000, task ffff88021f171740)
Stack:  000000000001c000 0000000041d61000 ffff880218156c00 000000000000c000
 ffff88021ec27000 ffff88018f4383b0 ffff880016089c80 000000000001c000
 0000000000000000 0000000000040000 0000000000040000 0000000000040000
Call Trace:
 [<ffffffffa04e0136>] cow_file_range+0x6e0/0x7c7 [btrfs]
 [<ffffffffa04e0542>] run_delalloc_range+0x325/0x33b [btrfs]
 [<ffffffffa04f1d1d>] ? find_lock_delalloc_range+0xfc/0x151 [btrfs]
 [<ffffffffa04f266b>] __extent_writepage+0x14e/0x648 [btrfs]
 [<ffffffff8116ffc1>] ? __lookup_tag+0xa9/0x110
 [<ffffffff8103baac>] ? try_to_wake_up+0x26f/0x281
 [<ffffffff8109d344>] ? __dec_zone_page_state+0x29/0x2b
 [<ffffffffa04efe73>] extent_write_cache_pages+0x1dd/0x341 [btrfs]
 [<ffffffffa04f251d>] ? __extent_writepage+0x0/0x648 [btrfs]
 [<ffffffffa04f0006>] extent_writepages+0x2f/0x51 [btrfs]
 [<ffffffffa04de375>] ? btrfs_get_extent+0x0/0x733 [btrfs]
 [<ffffffffa04de24e>] btrfs_writepages+0x23/0x25 [btrfs]
 [<ffffffff81097bad>] do_writepages+0x28/0x38
 [<ffffffff810df344>] __writeback_single_inode+0x185/0x2f9
 [<ffffffff81010a07>] ? restore_args+0x0/0x30
 [<ffffffff810df89d>] generic_sync_sb_inodes+0x229/0x309
 [<ffffffff810dfc06>] writeback_inodes+0xa4/0xfd
 [<ffffffff810981ce>] background_writeout+0x92/0xcb
 [<ffffffff81098756>] pdflush+0x171/0x234
 [<ffffffff8109813c>] ? background_writeout+0x0/0xcb
 [<ffffffff810985e5>] ? pdflush+0x0/0x234
 [<ffffffff810985e5>] ? pdflush+0x0/0x234
 [<ffffffff8105684d>] kthread+0x49/0x76
 [<ffffffff810116e9>] child_rip+0xa/0x11
 [<ffffffff81010a07>] ? restore_args+0x0/0x30
 [<ffffffff81056804>] ? kthread+0x0/0x76
 [<ffffffff810116df>] ? child_rip+0x0/0x11


Code: ea 4f a0 f0 41 ff 04 24 48 8b 55 a0 4c 89 75 d0 4c 8b 75 a8 48 89 55 b8 e9 e9 00 00 00 48 8b 45 d0 4c 8b 28 49 8b 87 08 01 00 00 <49> 89 45 18 83 7b 30 00 74 1f 48 8b 55 c8 45 31 c0 31 f6 48 89 
RIP  [<ffffffffa04fed42>] btrfs_submit_compressed_write+0x120/0x262 [btrfs]
 RSP <ffff88021cdc17a0>
CR2: ffffffff812a0d4d
---[ end trace 1844b0f2613c00dd ]---
general protection fault: 0000 [2] SMP 
CPU 1 
Modules linked in: btrfs deflate zlib_deflate crc32c libcrc32c fuse ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath raid1 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq ppdev snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore floppy snd_page_alloc pcspkr i2c_i801 radeon drm parport_pc parport i2c_algo_bit iTCO_wdt i3000_edac iTCO_vendor_support edac_core i2c_core shpchp e1000e raid456 async_xor async_memcpy async_tx xor raid10 [last unloaded: microcode]
Pid: 6319, comm: tar Tainted: G      D   2.6.27.4-61.fc10.x86_64 #1
RIP: 0010:[<ffffffff810bc782>]  [<ffffffff810bc782>] kmem_cache_alloc+0x56/0xc6
RSP: 0018:ffff88021c409688  EFLAGS: 00010082
RAX: 0000000000000000 RBX: c5ffff8801eed37f RCX: 0000000000001000
RDX: ffff8800280531b0 RSI: 0000000000000050 RDI: 0000000000000060
RBP: ffff88021c4096b8 R08: 0000000000000000 R09: 0000000000000400
R10: ffff880192627800 R11: 0000000000010000 R12: 0000000000000296
R13: ffffffff816475f0 R14: ffffffffa04d8552 R15: 0000000000000050
FS:  00007f97c2c99780(0000) GS:ffff88021fc04980(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff812a0d4d CR3: 0000000219121000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process tar (pid: 6319, threadinfo ffff88021c408000, task ffff8801f15dc5c0)
Stack:  0000006042001000 ffff880192627800 ffff88021a832000 0000000000000000
 0000000042002000 ffff880218408178 ffff88021c4096e8 ffffffffa04d8552
 0000000042001000 ffff880192627800 ffff8801eed37120 ffffe2000596e1d8
Call Trace:
 [<ffffffffa04d8552>] btrfs_bio_wq_end_io+0x27/0x6d [btrfs]
 [<ffffffffa04fee41>] btrfs_submit_compressed_write+0x21f/0x262 [btrfs]
 [<ffffffffa04e0136>] cow_file_range+0x6e0/0x7c7 [btrfs]
 [<ffffffffa04e0542>] run_delalloc_range+0x325/0x33b [btrfs]
 [<ffffffffa04f1d1d>] ? find_lock_delalloc_range+0xfc/0x151 [btrfs]
 [<ffffffffa04f266b>] __extent_writepage+0x14e/0x648 [btrfs]
 [<ffffffff8116ffc1>] ? __lookup_tag+0xa9/0x110
 [<ffffffff8109d344>] ? __dec_zone_page_state+0x29/0x2b
 [<ffffffffa04efe73>] extent_write_cache_pages+0x1dd/0x341 [btrfs]
 [<ffffffffa04f251d>] ? __extent_writepage+0x0/0x648 [btrfs]
 [<ffffffffa04f0006>] extent_writepages+0x2f/0x51 [btrfs]
 [<ffffffffa04de375>] ? btrfs_get_extent+0x0/0x733 [btrfs]
 [<ffffffffa04de24e>] btrfs_writepages+0x23/0x25 [btrfs]
 [<ffffffff81097bad>] do_writepages+0x28/0x38
 [<ffffffff810df344>] __writeback_single_inode+0x185/0x2f9
 [<ffffffff8116f6b8>] ? prop_fraction_single+0x3c/0x5e
 [<ffffffff810df89d>] generic_sync_sb_inodes+0x229/0x309
 [<ffffffff810dfc06>] writeback_inodes+0xa4/0xfd
 [<ffffffff810983f5>] balance_dirty_pages_ratelimited_nr+0x15a/0x285
 [<ffffffffa04e4ff5>] btrfs_file_write+0x471/0x64c [btrfs]
 [<ffffffff810c267e>] vfs_write+0xab/0x105
 [<ffffffff810c279c>] sys_write+0x47/0x6f
 [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b


Code: 00 00 00 e8 e1 27 fd ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 f0 10 00 00 8b 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 <48> 8b 04 c3 48 89 02 eb 17 49 89 d0 4c 89 f1 83 ca ff 44 89 fe 
RIP  [<ffffffff810bc782>] kmem_cache_alloc+0x56/0xc6
 RSP <ffff88021c409688>
---[ end trace 1844b0f2613c00dd ]---
general protection fault: 0000 [3] SMP 
CPU 1 
Modules linked in: btrfs deflate zlib_deflate crc32c libcrc32c fuse ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath raid1 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq ppdev snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore floppy snd_page_alloc pcspkr i2c_i801 radeon drm parport_pc parport i2c_algo_bit iTCO_wdt i3000_edac iTCO_vendor_support edac_core i2c_core shpchp e1000e raid456 async_xor async_memcpy async_tx xor raid10 [last unloaded: microcode]
Pid: 6264, comm: btrfs-transacti Tainted: G      D   2.6.27.4-61.fc10.x86_64 #1
RIP: 0010:[<ffffffff810bc782>]  [<ffffffff810bc782>] kmem_cache_alloc+0x56/0xc6
RSP: 0018:ffff8802191a9b80  EFLAGS: 00010082
RAX: 0000000000000000 RBX: c5ffff8801eed37f RCX: ffff88021995c880
RDX: ffff8800280531b0 RSI: 0000000000000050 RDI: 0000000000000060
RBP: ffff8802191a9bb0 R08: 0000000000000000 R09: 0000000000000000
R10: ffff88006c5b8178 R11: ffff8801f92969b0 R12: 0000000000000282
R13: ffffffff816475f0 R14: ffffffffa04d9fe2 R15: 0000000000000050
FS:  0000000000000000(0000) GS:ffff88021fc04980(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f1d11438000 CR3: 000000021c810000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-transacti (pid: 6264, threadinfo ffff8802191a8000, task ffff8802191c5d00)
Stack:  00000060191a9cd0 ffff8802191a9cd0 ffff88021a832000 ffff88006c5b8178
 0000000000000001 ffff88021995c880 ffff8802191a9c40 ffffffffa04d9fe2
 0000000000000000 0000000000000000 0000000000000004 0000000407640520
Call Trace:
 [<ffffffffa04d9fe2>] btrfs_wq_submit_bio+0x4e/0x242 [btrfs]
 [<ffffffffa04dae66>] btree_submit_bio_hook+0x44/0x46 [btrfs]
 [<ffffffffa04dad6c>] ? __btree_submit_bio_hook+0x0/0xb6 [btrfs]
 [<ffffffffa04eebf0>] submit_one_bio+0x61/0x8b [btrfs]
 [<ffffffffa04f2c11>] extent_write_full_page+0xac/0xbc [btrfs]
 [<ffffffffa04dae68>] ? btree_get_extent+0x0/0x1e0 [btrfs]
 [<ffffffffa04d841b>] btree_writepage+0x52/0x57 [btrfs]
 [<ffffffff810977ec>] write_one_page+0x88/0xd7
 [<ffffffffa04dbd09>] btrfs_write_and_wait_marked_extents+0xc2/0x1c7 [btrfs]
 [<ffffffffa04dbe4b>] btrfs_write_and_wait_transaction+0x3d/0x3f [btrfs]
 [<ffffffffa04dcbaa>] btrfs_commit_transaction+0x50a/0x6a0 [btrfs]
 [<ffffffff81056ba1>] ? autoremove_wake_function+0x0/0x38
 [<ffffffffa04d872d>] transaction_kthread+0x195/0x233 [btrfs]
 [<ffffffffa04d8598>] ? transaction_kthread+0x0/0x233 [btrfs]
 [<ffffffff8105684d>] kthread+0x49/0x76
 [<ffffffff810116e9>] child_rip+0xa/0x11
 [<ffffffff81010a07>] ? restore_args+0x0/0x30
 [<ffffffff81056804>] ? kthread+0x0/0x76
 [<ffffffff810116df>] ? child_rip+0x0/0x11


Code: 00 00 00 e8 e1 27 fd ff 65 8b 04 25 24 00 00 00 48 98 49 8b 94 c5 f0 10 00 00 8b 7a 18 89 7d d4 48 8b 1a 48 85 db 74 0c 8b 42 14 <48> 8b 04 c3 48 89 02 eb 17 49 89 d0 4c 89 f1 83 ca ff 44 89 fe 
RIP  [<ffffffff810bc782>] kmem_cache_alloc+0x56/0xc6
 RSP <ffff8802191a9b80>
---[ end trace 1844b0f2613c00dd ]---

-- 
Paul P 'Stingray' Komkoff Jr // http://stingr.net/key <- my pgp key
 This message represents the official view of the voices in my head
