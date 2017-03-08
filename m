Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56279 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753337AbdCHN3U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 08:29:20 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.10
Date: Wed,  8 Mar 2017 14:28:38 +0100
Message-Id: <20170308132838.14351-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.10 have been released.  There are patches that have
queued so far, plus a few recent additions from the mailingslit.

Changes:
  * send: dump output fixes: missing newlies
  * check: several fixes for the lowmem mode, improved error reporting
  * build
    * removed some library deps for binaries that not use them
    * ctags, cscope
    * split Makefile to the autotool generated part and the rest, not needed
      to autogen.sh after adding a file
  * shared code: sync easy parts with kernel sources
  * other
    * lots of cleanups
    * source file reorganization: convert, mkfs, utils
    * lots of spelling fixes in docs, other updates
    * more tests

Changes since rc1:
  * dropped a preparatory patch to enhance option parsing, fstests need to be
    fixed first so we don't get loads of failures

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Austin S. Hemmelgarn (1):
      btrfs-progs: better document btrfs receive security

Benedikt Morbach (1):
      btrfs-progs: send-dump: add missing newlines

David Sterba (100):
      btrfs-progs: introduce global config
      btrfs-progs: find-root: rename usage helper
      btrfs-progs: move help defines to own header
      btrfs-progs: move help implemetnation to own file
      btrfs-progs: move some common definitions to own header
      btrfs-progs: move mkfs definitions to own header
      btrfs-progs: move convert definitions to own header
      btrfs-progs: mkfs: move common api implementation to own file
      btrfs-progs: convert: move common api implementation to own file
      btrfs-progs: move fs features declarations to own header from utils
      btrfs-progs: move fs features implementation to own file
      btrfs-progs: convert: move definitions for interal conversion API to own file
      btrfs-progs: convert: move ext2 definitions out of main
      btrfs-progs: convert: move ext2 conversion out of main.c
      btrfs-progs: convert: move implementation for interal conversion API to own file
      btrfs-progs: build: list convert build objects in a variable
      btrfs-progs: build: list mkfs.btrfs build objects in a variable
      btrfs-progs: build: split LIBS
      btrfs-progs: build: reorder target dependencies
      btrfs-progs: build: replace target names with automatic variable
      btrfs-progs: build: use target deps on commandline via automatic variable
      btrfs-progs: build: remove directory-specific include paths
      btrfs-progs: mkfs: make list of source fs more visible
      btrfs-progs: convert: use wider types types for inode counts for progress reports
      btrfs-progs: convert: update some forward declarations
      btrfs-progs: build: add rule for ctags
      btrfs-progs: build: split makefile to generated and stable parts
      btrfs-progs: build: add rule for building cscope index
      btrfs-progs: convert: move struct initialization to the init function
      btrfs-progs: convert: use fixed lenght array for source fs name
      btrfs-progs: convert: use on-stack buffer for subvol name dir
      btrfs-progs: convert: remove unused includes
      btrfs-progs: convert: better error handling in ext2_read_used_space
      btrfs-progs: convert: use helper for special inode number check
      btrfs-progs: convert: use bit field for convert flags
      btrfs-progs: build: add stub makefile to convert
      btrfs-progs: build: build library by default
      btrfs-progs: kerncompat: print trace from ASSERT, if enabled
      btrfs-progs: move more mkfs declarations to the common header
      btrfs-progs: move mkfs helper implementation out of utils
      btrfs-progs: convert: rename ext2 function to create a symlink
      btrfs-progs: convert: move internal bg size definition
      btrfs-progs: build: drop deprecated utility from test dependencies
      btrfs-progs: build: use MAKEOPTS where missing
      btrfs-progs: build: remove unused variables from docs makefile
      btrfs-progs: mkfs: clear whole mkfs_cfg at once
      btrfs-progs: mkfs: describe fields of btrfs_mkfs_config
      btrfs-progs: mkfs: make make_cfg::blocks an internal member
      btrfs-progs: mkfs: use const char for label
      btrfs-progs: convert: rename members that clash with other functions
      btrfs-progs: convert: improve assert in make_convert_btrfs
      btrfs-progs: move utils code out of header
      btrfs-progs: move message helpers out of utils
      btrfs-progs: move message helpers implementation out of header
      btrfs-progs: drop unused argument from btrfs_truncate_item
      btrfs-progs: drop unused argument from btrfs_extend_item
      btrfs-progs: drop unused argument from btrfs_del_ptr
      btrfs-progs: move prefixcmp helper to utils
      btrfs-progs: move ulist.[ch] to kernel-shared
      btrfs-progs: shared: copy ulist_del from kernel
      btrfs-progs: shared: remove debug code from ulist
      btrfs-progs: shared: cleanup includes in ulist.c
      btrfs-progs: remove unused helpers from ctree.h
      btrfs-progs: opencode trivial helper btrfs_free_transaction
      btrfs-progs: remove unused parameter from truncate_one_csum
      btrfs-progs: remove unused argument from btrfs_csum_data
      btrfs-progs: remove unused argument from extent_data_ref_count
      btrfs-progs: remove unused argument from setup_inline_extent_backref
      btrfs-progs: remove unused argument from write_and_map_eb
      btrfs-progs: remove unused argument from free_chunk_item
      btrfs-progs: remove unused argument from btrfs_lookup_inode_ref
      btrfs-progs: remove unused function wait_on_tree_block_writeback
      btrfs-progs: remove unused argument from clear_extent_bits
      btrfs-progs: remove unused argument from set_extent_bits
      btrfs-progs: remove unused argument from btrfs_add_system_chunk
      btrfs-progs: remove unused argument from set_extent_dirty
      btrfs-progs: remove unused argument from clear_extent_dirty
      btrfs-progs: check: remove unused argument from process_dir_item
      btrfs-progs: check: remove unused argument from check_child_node
      btrfs-progs: check: remove unused arguments from delete_dir_index
      btrfs-progs: check: remove unused argument from create_inode_item
      btrfs-progs: check: remove unused argument from free_extent_record_cache
      btrfs-progs: check: remove unused argument from fix_key_order
      btrfs-progs: check: remove unused argument from delete_bogus_item
      btrfs-progs: check: remove unused argument from fix_item_offset
      btrfs-progs: check: remove unused argument from calc_extent_flag
      btrfs-progs: remove unused argument from get_raid56_used
      btrfs-progs: remove unused argument from print_device_sizes
      btrfs-progs: remove unused argument from print_device_chunks
      btrfs-progs: check: remove unused argument from process_duplicates
      btrfs-progs: check: remove unused argument from maybe_repair_root_item
      btrfs-progs: mkfs: remove unused argument from make_root_dir
      btrfs-progs: mkfs: remove unused arguments from add_inode_items
      btrfs-progs: image: remove unused argument from copy_log_trees
      btrfs-progs: mkfs: remove unused argument from add_file_items
      btrfs-progs: corrupt-block: remove unused argument from corrupt_extent
      btrfs-progs: tests: fix library-test rules and deps
      btrfs-progs: tests: fix permissions of temporary files in 025-file-extents
      btrfs-progs: tests: use dd in 025-file-extents for creating files
      btrfs-progs: update CHANGES for v4.10

Erik Logtenberg (1):
      btrfs-progs: docs: fix typo in btrfs-scrub manual page

Goldwyn Rodrigues (1):
      btrfs-progs: Remove unused function arg in delete_extent_records

Joey Sabey (2):
      btrfs-progs: docs: fix typo in btrfs-quota
      btrfs-progs: docs: fix typo in btrfs-quota

Jonathan Boulle (1):
      btrfs-progs: docs: fix typo in receive man page

Lu Fengqi (1):
      btrfs-progs: check: Fix lowmem mode override to allow it skip repair work

Matthias Krüger (1):
      btrfs-progs: readme: fix link to issue tracker on github.

Nicholas D Steeves (1):
      btrfs-progs: docs: fix many typos, plus three edits for clarity

Omar Sandoval (1):
      btrfs-progs: report I/O errors when closing the filesystem

Qu Wenruo (12):
      btrfs-progs: Introduce kernel sizes to cleanup large intermediate number
      btrfs-progs: Introduce macro to calculate backup superblock offset
      btrfs-progs: check: lowmem: Fix several bugs related to afterward search
      btrfs-progs: check: Output verbose error when fsck found a bug in any tree
      btrfs-progs: check: lowmem: Fix false alert in checking data extent csums
      btrfs-progs: check: lowmem: Fix extent item size false alert
      btrfs-progs: check: lowmem: Fix false alert on inline compressed extent
      btrfs-progs: check: lowmem: Fix silent error if first inode item missing
      btrfs-progs: tests: Move fsck-tests/015 to fuzz tests
      btrfs-progs: tests: Add test image for lowmem mode block group false alert
      btrfs-progs: tests: Make fsck-test/013 compatible with lowmem mode
      btrfs-progs: tests: Add new test case for file extent false alerts

Su Yue (1):
      btrfs-progs: check: enhance return values of walk_down_tree_v2

