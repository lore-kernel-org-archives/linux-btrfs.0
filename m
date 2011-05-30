From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 0/9] some fixes for bugs spotted by valgrind
Date: Tue, 31 May 2011 00:18:59 +0300
Message-ID: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello friends!

tmp branch recently got very nice feature: 'mkfs.btrfs -r /some/directory'.

It's very useful, when you need to creare minimal root: sh and fs_mark.

But there is another hidden feature! As '-r' can create whole filesystem
we can effectively valgrind a lot of code paths in btrfs and pick bugs.

This patch series is mostly (with one exception) dumb obvous holes plugs
(sometimes they are backports from kernel).

Patchset based on 'tmp' branch e6bd18d8938986c997c45f0ea95b221d4edec095.

First off the exception:
In order to make --mixed produce proper filesystems with meta+data only
blocks (and not meta+data/data ones, which confused space_cache and led
to an oops for me) I ask to consider for pulling Arne's patch:
> Subject: [PATCH 1/9] btrfs progs: fix extra metadata chunk allocation in --mixed case

The rest of patches should be obvoius. They don't fix all the fair valgrind
compaints, but reduce them severely.


Poking at valgrind warnings I have noticed very worrying problem.
When we (over)write superblock we take 4096 continuous bytes in memory.
In kernel the structures reside in btrfs_fs_info structure, so we compute
CRC for:
    struct btrfs_super_block super_copy;
    struct btrfs_super_block super_for_commit;
and then write it to disk. Nere we have 2 issues:
1. kernel pointers and other random stuff leaks out to kernel.
   It's nondeterministic and leaks out data (not too bad,
   as it should be accessible only for root, but still)
2. more serious: is there guarantee, that noone will kick-in
   between CRC computation and superblock outwrite?

   What if some of mutexes, semaphores or lists will change
   it's internal state? Some async thread will kick it
   an we will end-up writing superblock with invalid CRC!
   This might well be the cause of recend superblock
   corruptions under heavy load + hangup retorted to the list.

Consider the following call chain:
[somewhere in write_dev_supers ...]

                                                                                                                                                bh->b_end_io = btrfs_end_buffer_write_sync;                        crc = ~(u32)0;
                        crc = btrfs_csum_data(NULL, (char *)sb +
                                              BTRFS_CSUM_SIZE, crc,
                                              BTRFS_SUPER_INFO_SIZE -
                                              BTRFS_CSUM_SIZE);
                        btrfs_csum_final(crc, sb->csum);

                        /*
                         * !!!!!!!!!!!!
                         * something kicks-in and changes fs_info lying right after sb
                         * !!!!!!!!!!!!
                         */

                        bh = __getblk(device->bdev, bytenr / 4096,
                                      BTRFS_SUPER_INFO_SIZE);

                        /*
                         * !!!!!!!!!!!!
                         * and we write superblock with incorrect checksum
                         * !!!!!!!!!!!!
                         */
                        memcpy(bh->b_data, sb, BTRFS_SUPER_INFO_SIZE);

                        /* one reference for submit_bh */
                        get_bh(bh);

                        set_buffer_uptodate(bh);
                        lock_buffer(bh);
                        bh->b_end_io = btrfs_end_buffer_write_sync;
