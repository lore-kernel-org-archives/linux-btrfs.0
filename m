From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH 0/3] apply the Probabilistic Skiplist on btrfs
Date: Fri, 6 Jan 2012 00:51:48 +0100
Message-ID: <20120105235148.GQ7322@twin.jikos.cz>
References: <1325755822-13147-1-git-send-email-liubo2009@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	josef@redhat.com, dave@jikos.cz
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325755822-13147-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I've let it run through xfstests and ended at 091, patches applied
on top of 3.2, mount options
"compress-force=lzo,discard,inode_cache,space_cache,autodefrag"
fresh mkfs with defaults.

[ 1081.623819] btrfs: force lzo compression
[ 1081.629166] btrfs: enabling inode map caching
[ 1081.634853] btrfs: enabling auto defrag
[ 1081.638569] btrfs: disk space caching is enabled
[ 1119.693957] ------------[ cut here ]------------
[ 1119.697876] kernel BUG at fs/btrfs/file.c:530!
[ 1119.697876] invalid opcode: 0000 [#1] SMP
[ 1119.697876] CPU 1
[ 1119.697876] Modules linked in: loop btrfs aoe
[ 1119.697876]
[ 1119.697876] Pid: 25819, comm: fsx Not tainted 3.2.0-default+ #95 Intel Corporation Santa Rosa platform/Matanzas
[ 1119.697876] RIP: 0010:[<ffffffffa0048a18>]  [<ffffffffa0048a18>] btrfs_drop_extent_cache+0x3f8/0x400 [btrfs]
[ 1119.697876] RSP: 0018:ffff88000c47f698  EFLAGS: 00010282
[ 1119.697876] RAX: 00000000ffffffef RBX: ffff88006ff01e48 RCX: 0000000000026fff
[ 1119.697876] RDX: ffff88006ed5d830 RSI: 0000000000022000 RDI: 0000000000000000
[ 1119.697876] RBP: ffff88000c47f738 R08: 0000000000000000 R09: 0000000000022000
[ 1119.697876] R10: fffffffffffffffe R11: 0000000000026fff R12: ffff88001ada9e48
[ 1119.697876] R13: 000000000001f000 R14: 0000000000000000 R15: ffff88000c47f708
[ 1119.697876] FS:  00007f262e570700(0000) GS:ffff88007de00000(0000) knlGS:0000000000000000
[ 1119.697876] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1119.697876] CR2: 00007fc4364fc000 CR3: 0000000079435000 CR4: 00000000000006e0
[ 1119.697876] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1119.697876] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1119.697876] Process fsx (pid: 25819, threadinfo ffff88000c47e000, task ffff880063640700)
[ 1119.697876] Stack:
[ 1119.697876]  ffff880000000000 ffffffff81092040 ffff88000c47f6f0 0100000000000246
[ 1119.697876]  0000000000000001 0000000000000000 0000000000003000 ffff88006e5c44f0
[ 1119.697876]  ffff88006e5c43e0 0000000000000000 0000000000000000 0000000000000000
[ 1119.697876] Call Trace:
[ 1119.697876]  [<ffffffff81092040>] ? trace_hardirqs_on_caller+0x20/0x1d0
[ 1119.697876]  [<ffffffffa003a0b0>] ? csum_exist_in_range+0xa0/0xa0 [btrfs]
[ 1119.697876]  [<ffffffffa003f296>] cow_file_range+0x136/0x3e0 [btrfs]
[ 1119.697876]  [<ffffffff810921fd>] ? trace_hardirqs_on+0xd/0x10
[ 1119.697876]  [<ffffffffa003f8a7>] run_delalloc_nocow+0x367/0x820 [btrfs]
[ 1119.697876]  [<ffffffff81357dae>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1119.697876]  [<ffffffffa00400c9>] run_delalloc_range+0x369/0x370 [btrfs]
[ 1119.697876]  [<ffffffffa00582c0>] __extent_writepage+0x5f0/0x750 [btrfs]
[ 1119.697876]  [<ffffffff81349f4d>] ? radix_tree_gang_lookup_tag_slot+0x8d/0xd0
[ 1119.697876]  [<ffffffff810f30d1>] ? find_get_pages_tag+0x111/0x1b0
[ 1119.697876]  [<ffffffffa0058692>] extent_write_cache_pages.clone.0+0x272/0x3f0 [btrfs]
[ 1119.697876]  [<ffffffff81357dae>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1119.697876]  [<ffffffff81131604>] ? kfree+0xd4/0x180
[ 1119.697876]  [<ffffffff81092040>] ? trace_hardirqs_on_caller+0x20/0x1d0
[ 1119.697876]  [<ffffffffa0058a56>] extent_writepages+0x46/0x60 [btrfs]
[ 1119.697876]  [<ffffffffa003b590>] ? acls_after_inode_item+0xd0/0xd0 [btrfs]
[ 1119.697876]  [<ffffffffa003ad17>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1120.018734]  [<ffffffff810fdcc4>] do_writepages+0x24/0x40
[ 1120.018734]  [<ffffffff810f3cdb>] __filemap_fdatawrite_range+0x5b/0x60
[ 1120.018734]  [<ffffffff810f3d3a>] filemap_write_and_wait_range+0x5a/0x80
[ 1120.018734]  [<ffffffffa004859a>] btrfs_file_aio_write+0x4da/0x560 [btrfs]
[ 1120.018734]  [<ffffffff8113a852>] do_sync_write+0xe2/0x120
[ 1120.018734]  [<ffffffff8187d2ad>] ? __mutex_unlock_slowpath+0xdd/0x180
[ 1120.018734]  [<ffffffff8187d35e>] ? mutex_unlock+0xe/0x10
[ 1120.018734]  [<ffffffffa004703f>] ? btrfs_file_llseek+0x6f/0x390 [btrfs]
[ 1120.018734]  [<ffffffff8113b15e>] vfs_write+0xce/0x190
[ 1120.018734]  [<ffffffff8113b4a4>] sys_write+0x54/0xa0
[ 1120.018734]  [<ffffffff81887a82>] system_call_fastpath+0x16/0x1b
[ 1120.018734] Code: 5e 41 5f c9 c3 0f 0b be bf 01 00 00 48 c7 c7 e6 02 09 a0 48 89 95 68 ff ff ff e8 e4 a2 00 e1 48 8b 95 68 ff ff ff e9 3c fc ff ff <0f> 0b 0f 0b 0f 1f 40 00 55 48 89 e5 41 57 41 56 41 55 41 54 53
[ 1120.018734] RIP  [<ffffffffa0048a18>] btrfs_drop_extent_cache+0x3f8/0x400 [btrfs]
[ 1120.018734]  RSP <ffff88000c47f698>
[ 1120.047841] ---[ end trace ca0f509767e0195d ]---

xfstests/091 output:

091 57s ...     [19:47:50] [19:48:28] [failed, exit status 1] - output mismatch (see 091.out.bad)
--- 091.out     2011-11-01 10:31:12.000000000 +0100
+++ 091.out.bad 2012-01-05 19:48:28.000000000 +0100
@@ -5,3 +5,41 @@
 fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
 fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
 fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
+./091: line 46: 25819 Segmentation fault      $here/ltp/fsx $args $TEST_DIR/junk >> $seq.full 2>&1
+fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+mapped writes DISABLED
+truncating to largest ever: 0x12a00
+truncating to largest ever: 0x75400
+fallocating to largest ever: 0x7a120
+All operations completed A-OK!
+fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+mapped writes DISABLED
+truncating to largest ever: 0x12a00
+truncating to largest ever: 0x75400
+fallocating to largest ever: 0x79cbf
+fallocating to largest ever: 0x7a120
+All operations completed A-OK!
+fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+mapped writes DISABLED
+truncating to largest ever: 0x12a00
+truncating to largest ever: 0x75400
+fallocating to largest ever: 0x7a120
+All operations completed A-OK!
+fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+mapped writes DISABLED
+truncating to largest ever: 0x12a00
+truncating to largest ever: 0x75400
+fallocating to largest ever: 0x79cbf
+fallocating to largest ever: 0x7a120
+All operations completed A-OK!
+fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+mapped writes DISABLED
+truncating to largest ever: 0x12a00
+truncating to largest ever: 0x75400
+fallocating to largest ever: 0x7a120
+All operations completed A-OK!
+fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
+mapped writes DISABLED
+truncating to largest ever: 0x12a00
+truncating to largest ever: 0x75400
+fallocating to largest ever: 0x7a120

Crash site(fs/btrfs/file.c:530):

 518                         if (compressed) {
 519                                 split->block_len = em->block_len;
 520                                 split->block_start = em->block_start;
 521                                 split->orig_start = em->orig_start;
 522                         } else {
 523                                 split->block_len = split->len;
 524                                 split->block_start = em->block_start + diff;
 525                                 split->orig_start = split->start;
 526                         }
 527
 528                         ret = add_extent_mapping(em_tree, split, &to_free[2],
 529                                                  &to_free[3]);
 530                         BUG_ON(ret);
 531                         free_extent_map(split);
 532                         split = NULL;

ret seems to be RAX = 0xEF == -17 == -EEXIST .


david
