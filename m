Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751628AbdG1NtJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 09:49:09 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.12
Date: Fri, 28 Jul 2017 15:47:47 +0200
Message-Id: <20170728134747.7535-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.12 have been released. Although it's major number update,
there are no major updates, besides the usual bugfixes and enhancements.

Per user request, the tarball now contains the generated manual pages, as the
build dependencies for documentation are not lightweight. If you configure with
--disable-documentation, the generated *.gz are not touched and need to be
manually copied to the destination path ($prefix/share/man/man[58]).

Changes:
  * subvol show: new options --rootid, --uuid to show subvol by the given spec
  * convert: progress report fixes, found by tsan
  * image: progress report fixes, found by tsan
  * fix infinite looping in find-root, or when looking for free extents
  * other:
    * code refactoring
    * docs updates
    * build: ThreadSanitizer support
    * tests: stricter checks for mounted filesystem

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Adam Buchbinder (7):
      btrfs-progs: convert: Fix data race when reporting progress
      btrfs-progs: image: Fix data races when reporting progress
      btrfs-progs: image: fix typos in messages
      btrfs-progs: tests: Fix missing internal deps in check and misc tests
      btrfs-progs: Tighten integer types in print-tree
      btrfs-progs: build: Enable ThreadSanitizer, using D=tsan
      btrfs-progs: tests: Use '-t btrfs' mount option in tests

Anand Jain (2):
      btrfs-progs: subvol show: fix the path use full_path as provided by the root info
      btrfs-progs: subvol show: add support to search subvolume by rootid or uuid

David Sterba (8):
      btrfs-progs: docs: document conventions
      btrfs-progs: docs: move deprecated mount option to own section
      btrfs-progs: docs: enhance documentation of 'btrfs device ready'
      btrfs-progs: docs: adjust wording for subvol delete
      btrfs-progs: tests: enhance API to request type of the converted filesystem
      btrfs-progs: tests: use separate helper for mounting convert filesystems
      btrfs-progs: docs: update wording for compression mount options
      btrfs-progs: update CHANGES for v4.12

Justin Maggard (1):
      btrfs-progs: Fix an infinite loop in btrfs_next_bg

Liu Bo (1):
      Btrfs-progs: fix infinite loop in find_free_extent

Philipp Hahn (1):
      btrfs-progs: Fix slot >= nritems

Qu Wenruo (61):
      btrfs-progs: Cleanup open-coded btrfs_chunk_item_size
      btrfs-progs: Remove deprecated leafsize usage
      btrfs-progs: Introduce sectorsize nodesize and stripesize members for btrfs_fs_info
      btrfs-progs: Refactor block sizes users in disk-io.c
      btrfs-progs: Refactor block sizes users in btrfs-corrupt-block.c
      btrfs-progs: Refactor block sizes users in ctree.c and ctree.h
      btrfs-progs: Refactor block sizes users in btrfs-map-logical.c
      btrfs-progs: Refactor block sizes users in chunk-recover.c
      btrfs-progs: Refactor block sizes users in backref.c
      btrfs-progs: Refactor block sizes users in cmds-restore.c
      btrfs-progs: Refactor nodesize user in extent_io.c
      btrfs-progs: Refactor nodesize users in image/main.c
      btrfs-progs: Refactor block sizes users in cmds-check.c
      btrfs-progs: Refactor nodesize user in btrfstune.c
      btrfs-progs: Refactor nodesize users in utils.c
      btrfs-progs: Refactor block sizes users in extent-tree.c
      btrfs-progs: Refactor nodesize user in print-tree.c
      btrfs-progs: Refactor nodesize users in qgroup-verify.c
      btrfs-progs: Refactor nodesize users in cmds-inspect-tree-stats.c
      btrfs-progs: Refactor sectorsize users in mkfs/main.c
      btrfs-progs: Refactor sectorsizes users in file-item.c
      btrfs-progs: Refactor sectorsize users in free-space-cache.c
      btrfs-progs: Refactor sectorsize users in file.c
      btrfs-progs: Refactor sectorsize users in volumes.c
      btrfs-progs: Refactor sectorsize users in free-space-tree.c
      btrfs-progs: Refactor sectorsize in convert/source-fs.c
      btrfs-progs: Refactor sectorsize users in convert/main.c
      btrfs-progs: Refactor sectorsize users in convert/source-ext2.c
      btrfs-progs: Refactor sectorsize users in cmds-inspect-dump-tree.c
      btrfs-progs: Remove block size members in btrfs_root
      btrfs-progs: Refactor btrfs_root paramters in btrfs-corrupt-block.c
      btrfs-progs: Refactor read_tree_block to get rid of btrfs_root
      btrfs-progs: Refactor read_node_slot function to get rid of btrfs_root parameter
      btrfs-progs: raid56: Introduce raid56 header for later recovery usage
      btrfs-progs: raid56: Introduce tables for RAID6 recovery
      btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
      btrfs-progs: raid56: Allow raid6 to recover data and P
      btrfs-progs: Introduce wrapper to recover raid56 data
      btrfs-progs: Enhance chunk item validation check
      btrfs-progs: check: Reuse btrfs_check_chunk_valid in lowmem mode
      btrfs-progs: Introduce function to get correct stripe length
      btrfs-progs: lowmem check: Fix false alert on missing chunk or dev extent
      btrfs-progs: Refactor btrfs_map_block and its variants to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_num_copies to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_next_bg and its callers to use btrfs_fs_info
      btrfs-progs: Refactor csum_tree_block to use btrfs_fs_info
      btrfs-progs: Refactor write_and_map_eb to use btrfs_fs_info
      btrfs-progs: Refactor write_tree_block to use btrfs_fs_info
      btrfs-progs: btrfstune: Refactor change_devices_uuid to use btrfs_fs_info
      btrfs-progs: Refactor read_extent_data to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_find_tree_block to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_readahead_tree_block to use btrfs_fs_info
      btrfs-progs: Refactor write_all_supers and its callers to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_check_chunk_valid to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_find_device to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_read_sys_array/chunk_tree to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_add_system_chunk to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_chunk_readonly to use btrfs_fs_info
      btrfs-progs: Refactor btrfs_add_device() to use btrfs_fs_info
      btrfs-progs: Remove btrfs_read_super_device as there is no implementation
      btrfs-progs: Refactor chunk creation functions to use btrfs_fs_info
