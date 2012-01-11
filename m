From: David Sterba <dave@jikos.cz>
Subject: Warning: bad fsid on block 20971520
Date: Wed, 11 Jan 2012 16:46:21 +0100
Message-ID: <20120111154621.GX7322@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the $subj warning appears sometimes in syslog, in my case when
xfstests/209 runs looped. The minimal reproducer is looped mkfs+mount.

The message comes from disk-io.c btree_readpage_end_io_hook():

581         if (check_tree_block_fsid(root, eb)) {
582                 printk_ratelimited(KERN_INFO "btrfs bad fsid on block %llu\n",
583                                (unsigned long long)eb->start);
584                 ret = -EIO;
585                 goto err;
586         }

relevant syslog messages:

[420367.199710] device fsid dda1a3db-3106-4bb9-8ecf-2e823938d538 devid 1 transid 4 /dev/sda9
[420367.209438] btrfs: force lzo compression
[420367.214695] btrfs: enabling inode map caching
[420367.220404] btrfs: enabling auto defrag
[420367.224193] btrfs: disk space caching is enabled
[420367.323356] btrfs bad fsid on block 20971520
[420367.358349] btrfs bad fsid on block 20971520
[420367.368272] btrfs bad fsid on block 20971520
[420367.376239] btrfs bad fsid on block 20971520
[420367.381836] btrfs bad fsid on block 20971520
[420367.467332] btrfs bad fsid on block 20971520
[420367.473249] btrfs bad fsid on block 20971520
[420367.478649] btrfs: failed to read chunk root on sda9
[420367.487810] btrfs: open_ctree failed

and mount fails.

/proc/partitions:
   8        9   10485760 sda9

10485760*1024 bytes, which is 2621440 4k blocks.

The number 20971520 is not a block number, rather byte offset, so the
message might be confusing first. Real block number is
20971520 / 4096 = 20480

used blocks on a freshly created device:

File size of test-10g is 10737418240 (10485760 blocks, blocksize 1024)
 ext logical physical expected length flags
   0       0 10248192            2048
   1    4096 10252288 10250239     20
   2   20480 10293248 10252307      4
   3   28672 10301440 10293251      4
   4   36864 10260480 10301443     24
   5   65536 10264576 10260503      4
   6 1085440 10276864 10264579     24
   7 10483712   294912 10276887   2048 eof

it's "extent" nr. 2, not a superblock. The block obviously does not
contain the exptected data, though they were submitted and supposed to
be written by the mkfs step. The question is, where the update is lost --
block layer, write caches of the disk.

btrfs-debug-tree says it's:

chunk tree
leaf 20971520 items 6 free space 3283 generation 4 owner 3
fs uuid 024cd2e6-d584-493c-af81-fa3e2f548abb
chunk uuid 3f52ec70-89a9-4cd5-b5f0-177d7ae63de3
        item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 3897 itemsize 98
                dev item devid 1 total_bytes 10737418240 bytes used 2185232384
        item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 3817 itemsize 80
                chunk length 4194304 owner 2 type 2 num_stripes 1
                        stripe 0 devid 1 offset 0
        item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 3737 itemsize 80
                chunk length 8388608 owner 2 type 4 num_stripes 1
                        stripe 0 devid 1 offset 4194304
        item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 3657 itemsize 80
                chunk length 8388608 owner 2 type 1 num_stripes 1
                        stripe 0 devid 1 offset 12582912
        item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 3545 itemsize 112
                chunk length 8388608 owner 2 type 34 num_stripes 2
                        stripe 0 devid 1 offset 20971520
                        stripe 1 devid 1 offset 29360128
        item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 3433 itemsize 112
                chunk length 1073741824 owner 2 type 36 num_stripes 2
                        stripe 0 devid 1 offset 37748736
                        stripe 1 devid 1 offset 1111490560


david
