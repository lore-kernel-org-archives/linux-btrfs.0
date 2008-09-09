From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: Warning and oops running bonnie
Date: Tue, 09 Sep 2008 08:18:35 +0100
Message-ID: <ga580b$nhd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo!

I was running bonnie to compare btrfs to alternatives, see where it is 
in terms of relative performance. It looks good (but has very high CPU 
usage, is that expected?), but then I get a warning and later an oops.

This is using two >9GB partitions, and bonnie running with 3GB and later 
9GB.

kernel: Btrfs v0.16+417d87e57364 loaded

Here begins the first run, mkfs -d raid0

kernel: device label test devid 1 transid 7 /dev/sda2
kernel: device label test devid 2 transid 7 /dev/sdb2
kernel: device label test devid 1 transid 12 /dev/sda2
kernel: space info full 9

but it completes bonnie.

Here begins the second run, mkfs -d raid1

kernel: device label test devid 1 transid 7 /dev/sda2
kernel: device label test devid 2 transid 7 /dev/sdb2
kernel: device label test devid 1 transid 12 /dev/sda2
kernel: space info full 17
kernel: Unable to find block group for 9183821824
kernel: ------------[ cut here ]------------
kernel: WARNING: at /usr/local/src/btrfs/extent-tree.c:300 
find_search_start+0x2a9/0x2f0 [btrfs]()
kernel: Modules linked in: btrfs crc32c libcrc32c snd_hda_intel piix 
snd_pcm snd_timer ide_core snd_page_alloc snd_hwdep snd soundcore
kernel: Pid: 2246, comm: bonnie Not tainted 2.6.26.3 #9
kernel:
kernel: Call Trace:
kernel: [<ffffffff8022e414>] warn_on_slowpath+0x64/0xc0
kernel: [<ffffffff804dc725>] printk+0x4e/0x59
kernel: [<ffffffffa00f708d>] :btrfs:__etree_search+0x8d/0x110
kernel: [<ffffffffa00f7a98>] :btrfs:find_first_extent_bit+0x58/0xe0
kernel: [<ffffffffa00d4618>] :btrfs:btrfs_lookup_block_group+0x38/0x80
kernel: [<ffffffffa00d4cd6>] :btrfs:btrfs_lookup_first_block_group+0x36/0x70
kernel: [<ffffffffa00d5369>] :btrfs:find_search_start+0x2a9/0x2f0
kernel: [<ffffffffa00d6693>] :btrfs:find_free_extent+0x333/0x7a0
kernel: [<ffffffffa00d6c6b>] :btrfs:__btrfs_reserve_extent+0x16b/0x290
kernel: [<ffffffffa00d6e00>] :btrfs:btrfs_reserve_extent+0x70/0xa0
kernel: [<ffffffffa00e3b70>] :btrfs:cow_file_range+0x130/0x270
kernel: [<ffffffffa00e3e0a>] :btrfs:run_delalloc_range+0x15a/0x2d0
kernel: [<ffffffffa00fb1e0>] :btrfs:__extent_writepage+0x140/0x740
kernel: [<ffffffff802644a9>] write_cache_pages+0x229/0x3c0
kernel: [<ffffffffa00fb0a0>] :btrfs:__extent_writepage+0x0/0x740
kernel: [<ffffffffa00f830f>] :btrfs:extent_writepages+0x2f/0x50
kernel: [<ffffffffa00e4de0>] :btrfs:btrfs_get_extent+0x0/0x780
kernel: [<ffffffff80244288>] wake_up_bit+0x18/0x40
kernel: [<ffffffff80264690>] do_writepages+0x20/0x40
kernel: [<ffffffff802acca0>] __writeback_single_inode+0xa0/0x470
kernel: [<ffffffffa00f7b8c>] :btrfs:merge_state+0x6c/0x100
kernel: [<ffffffff802ad5a0>] sync_sb_inodes+0x2f0/0x470
kernel: [<ffffffff802ad982>] writeback_inodes+0x52/0xf0
kernel: [<ffffffff8026501e>] balance_dirty_pages_ratelimited_nr+0x24e/0x350
kernel: [<ffffffffa00eb048>] :btrfs:btrfs_file_write+0x6f8/0x9e0
kernel: [<ffffffffa00ea950>] :btrfs:btrfs_file_write+0x0/0x9e0
kernel: [<ffffffff8028aa0b>] vfs_write+0xcb/0x170
kernel: [<ffffffff8028b270>] fget_light+0x30/0xb0
kernel: [<ffffffff8028abb3>] sys_write+0x53/0xa0
kernel: [<ffffffff8020b66b>] system_call_after_swapgs+0x7b/0x80
kernel:
kernel: ---[ end trace ebf771890be803e6 ]---
kernel: Unable to find block group for 9183821824
kernel: ------------[ cut here ]------------
kernel: WARNING: at /usr/local/src/btrfs/extent-tree.c:300 
find_search_start+0x2a9/0x2f0 [btrfs]()
kernel: Modules linked in: btrfs crc32c libcrc32c snd_hda_intel piix 
snd_pcm snd_timer ide_core snd_page_alloc snd_hwdep snd soundcore
kernel: Pid: 2246, comm: bonnie Tainted: G        W 2.6.26.3 #9
kernel:
kernel: Call Trace:
kernel: [<ffffffff8022e414>] warn_on_slowpath+0x64/0xc0

At this point df says there is 6GB of ~18.5 GB in use.

Frank

