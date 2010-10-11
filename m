From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Horrible btrfs performance on cold cache
Date: Mon, 11 Oct 2010 03:30:25 +0300
Message-ID: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I use btrfs on most of my volumes on my laptop, and I've always felt
booting was very slow, but definitely sure is slow, is starting up
Google Chrome:

encrypted ext4: ~20s
btrfs: ~2:11s

I have tried different things to find out exactly what is the issue,
but haven't quite found it yet.

Here's some stuff I got from latencytop, not sure if would be helpful:

4969.1ms
sys_mmap_pgoff
syscall_call
(chrome)

1139.9ms
sync_page
sync_page_killable
__lock_page_killable
generic_file_aio_read
do_sync_read
vfs_read
sys_read
sysenter_do_call
(chrome)

431.9ms
sync_page
wait_on_page_bit
read_extent_buffer_pages
btree_read_extent_buffer_pages
read_tree_block
read_block_for_search
btrfs_search_slot
lookup_inline_extent_backref
__btrfs_free_extent
run_clustered_refs
btrfs_run_delayed_refs
btrfs_commit_transaction
(btrfs)

Cheers.

-- 
Felipe Contreras
