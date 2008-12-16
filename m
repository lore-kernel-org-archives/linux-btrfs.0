From: Thomas Harning <thomas.harning@trustbearer.com>
Subject: kernel BUG: kernel bug caught at 55% mark of portage cache update
Date: Tue, 16 Dec 2008 14:57:55 -0500
Message-ID: <FD060D90-0C58-4222-8A56-CDE0B47AD6DC@trustbearer.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A kernel 'BUG' was caught while I had compression enabled and was  
performing a 'portage' update on my gentoo installation (which had  
btrfs mounted for portage for some basic perf testing).  It has  
finished the rsync and was at the 55% mark of the portage cache  
update... if that helps at all.

Inlined is the kernel bug output... + some extra debug info that had  
been spit out beforehand that i thought might be useful...

didn't appear to be at that 85% freespace mark...

should I attach a btrfs-image dump?

/dev/mapper/vg-btrfsTest
                       1.0G  309M  716M  31% /mnt/btrfsTest


device fsid 6c44efb8af8339de-fdcb30fce5264c82 devid 1 transid 22 /dev/ 
mapper/vg-btrfsTest
space info full 36
we were searching for 4096 bytes, num_bytes 4096, loop 2,  
allowed_alloc 1
allocation failed flags 36, wanted 4096
space_info has 65536 free, is full
block group 29360128 has 53673984 bytes, 50790400 used 2818048 pinned  
0 reserved
0 blocks of free space at or bigger than bytes is
block group 190382080 has 53673984 bytes, 50040832 used 3633152 pinned  
0 reserved
0 blocks of free space at or bigger than bytes is
block group 244056064 has 53673984 bytes, 50913280 used 2760704 pinned  
0 reserved
0 blocks of free space at or bigger than bytes is
block group 297730048 has 53673984 bytes, 50917376 used 2756608 pinned  
0 reserved
0 blocks of free space at or bigger than bytes is
block group 351404032 has 53673984 bytes, 36831232 used 16842752  
pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 405078016 has 53673984 bytes, 19693568 used 33980416  
pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 566099968 has 53673984 bytes, 49348608 used 4325376 pinned  
0 reserved
0 blocks of free space at or bigger than bytes is

------------[ cut here ]------------
kernel BUG at /home/harningt/gitrepo/kernel/btrfs-unstable-standalone/ 
extent-tree.c:3096!
invalid opcode: 0000 [1]
CPU 0
Modules linked in: btrfs crc32c libcrc32c zlib_deflate nvidia(P) fuse  
snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event  
snd_seq snd_seq_device snd_atiixp snd_ac97_codec ac97_bus snd_pcm  
snd_timer snd snd_page_alloc
Pid: 4539, comm: emerge Tainted: P          2.6.27-00080-g13d5f30 #1
RIP: 0010:[<ffffffffa0824718>]  [<ffffffffa0824718>]  
__btrfs_reserve_extent+0x278/0x2b0 [btrfs]
RSP: 0018:ffff880029a25908  EFLAGS: 00010296
RAX: ffff880048118560 RBX: ffff880044468400 RCX: 000000000000ffff
RDX: 00000000ffffff01 RSI: 0000000000000000 RDI: ffff880048118558
RBP: ffff880048118548 R08: 0000000000008b1a R09: 00000000ffffffff
R10: 0000000000000000 R11: 000000000000000a R12: 0000000000001000
R13: ffff880048118558 R14: ffff880048118548 R15: 0000000000001000
FS:  00007f671a6896f0(0000) GS:ffffffff8087fe80(0000) knlGS: 
00000000f7c7d6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001bd1024 CR3: 000000002b39c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process emerge (pid: 4539, threadinfo ffff880029a24000, task  
ffff880049991740)
Stack:  0000000000000000 ffff880029a25a08 0000000000000000  
0000000000000000
  0000000400000024 0000000000000000 0000000000000000 0000000000001000
  ffff880031723800 ffff880029a25a08 0000000000000005 ffff8800437a9070
Call Trace:
  [<ffffffffa082561c>] ? btrfs_alloc_extent+0x4c/0xc0 [btrfs]
  [<ffffffffa08256f4>] ? btrfs_alloc_free_block+0x64/0xa0 [btrfs]
  [<ffffffffa0815be6>] ? __btrfs_cow_block+0x1f6/0x8a0 [btrfs]
  [<ffffffffa08168e4>] ? btrfs_cow_block+0x134/0x210 [btrfs]
  [<ffffffffa081d1c4>] ? btrfs_search_slot+0x1f4/0x910 [btrfs]
  [<ffffffff80261895>] ? __pagevec_lru_add+0x95/0xa0
  [<ffffffffa084e8be>] ? extent_readpages+0x15e/0x180 [btrfs]
  [<ffffffff8025ed46>] ? __alloc_pages_internal+0xb6/0x470
  [<ffffffffa082d182>] ? btrfs_lookup_inode+0x32/0xb0 [btrfs]
  [<ffffffffa0834d2d>] ? btrfs_update_inode+0x3d/0xc0 [btrfs]
  [<ffffffffa0834f93>] ? btrfs_dirty_inode+0x43/0x60 [btrfs]
  [<ffffffff802a0864>] ? __mark_inode_dirty+0x34/0x190
  [<ffffffff8029642e>] ? touch_atime+0xfe/0x170
  [<ffffffff8025be21>] ? generic_file_aio_read+0x581/0x5e0
  [<ffffffff80281dc9>] ? do_sync_read+0xd9/0x120
  [<ffffffff80242360>] ? autoremove_wake_function+0x0/0x30
  [<ffffffff8020fee6>] ? arch_get_unmapped_area_topdown+0x206/0x2b0
  [<ffffffff80281f65>] ? vfs_read+0xc5/0x180
  [<ffffffff80282523>] ? sys_read+0x53/0x90
  [<ffffffff8020b5eb>] ? system_call_fastpath+0x16/0x1b


Code: ff 31 c0 e8 cb bf a0 df 4c 89 e6 48 89 df e8 40 93 03 00 48 8b  
6d 00 48 8b 45 00 4c 39 f5 0f 18 08 75 b3 4c 89 ef e8 a8 0d a2 df <0f>  
0b eb fe be 03 0c 00 00 48 c7 c7 30 00 86 a0 e8 63 af a0 df
RIP  [<ffffffffa0824718>] __btrfs_reserve_extent+0x278/0x2b0 [btrfs]
  RSP <ffff880029a25908>
---[ end trace cdb8403d4defddf6 ]---


-- 
Thomas Harning
TrustBearer Labs
TB OpenID: https://openid.trustbearer.com/harningt

