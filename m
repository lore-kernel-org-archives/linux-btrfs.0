Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727112AbeHFQZl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 12:25:41 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.17.1
Date: Mon,  6 Aug 2018 16:16:14 +0200
Message-Id: <20180806141614.933-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.17.1 have been released. This is a bugfix release,
consisting of most of current devel branch. The kernel release of 4.18 is going
to be delayed one more week so this would delay the fixes too.  The plan for
4.18 still is to merge the ioctl support for subvolume listing.

Changes:
  * check:
    * add ability to fix wrong ram_bytes for compressed inline files
    * beautify progress output
  * btrfstune: allow to continue uuid change after unclean interruption
  * several fuzz fixes:
    * detect overalpping chunks
    * chunk loading error handling
    * don't crash with unexpected root refs to extents
  * relax option parsing again to allow mixing options and non-options
    arguments
  * fix qgroup rescan status reporting
  * build:
    * drop obsolete dir-test
    * new configure option to disable building of tools
    * add compatibility options --disable-static and --disable-shared
  * other:
    * cleanups and preparatory work
    * new test images

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Disseldorp (1):
      btrfs-progs: check: add experimental flag for lowmem mode

David Sterba (7):
      btrfs-progs: pass superblock flags to mount check helpers
      btrfs-progs: add new flag to read superblock with mismatched fsids
      btrfs-progs: btrfstune: prepare for enhanced mount check
      btrfs-progs: tests: add fuzzed image that triggers crash in reloc setup on mount
      btrfs-progs: fix build of quick-test
      btrfs-progs: check: reorder options to sections
      btrfs-progs: update CHANGES for v4.17.1

Jeff Mahoney (3):
      btrfs-progs: qgroups: fix misleading index check
      btrfs-progs: constify pathnames passed as arguments
      btrfs-progs: btrfs-list: add rb_entry helpers for root_info

Misono Tomohiro (2):
      btrfs-progs: doc: Update man 5 btrfs for 4.18
      btrfs-progs: inspect logical-resolve: Set correct error value

Nikolay Borisov (13):
      btrfs-progs: check: Fix wrong root parameter of btrfs_next_leaf call
      btrfs-progs: check: factor out root parsing from check_chunks_and_extents
      btrfs-progs: check: Fix wrong error message in case of corrupted extent
      btrfs-progs: Remove root argument from pin_down_bytes
      btrfs-progs: Remove root argument from btrfs_del_csums
      btrfs-progs: Add functions to modify the used space by a root
      btrfs-progs: Refactor the root used bytes are updated
      btrfs-progs: Make update_block_group take fs_info instead of root
      btrfs-progs: check: Drop trans/root arguments from free_extent_hook
      btrfs-progs: Remove root argument from __free_extent
      btrfs-progs: Remove root argument from alloc_reserved_tree_block
      btrfs-progs: Always pass 0 for offset when calling btrfs_free_extent for btree blocks.
      btrfs-progs: Add boolean to signal whether we are re-initing extent tree

Omar Sandoval (3):
      btrfs-progs: remove stale dir-test
      btrfs-progs: build: add --disable-programs
      btrfs-progs: build: add --disable-shared and --disable-static

Qu Wenruo (20):
      btrfs-progs: Fix wrong optind re-initialization to allow mixed option and non-option
      btrfs-progs: misc-tests: Fix 029 test cases for sudo test environment
      btrfs-progs: free-space-cache: Don't panic when free space cache is corrupted
      btrfs-progs: restore: Fix wrong compressed item size for decompress()
      btrfs-progs: Get rid of the confusing btrfs_file_extent_inline_len()
      btrfs-progs: check/original: Detect and repair wrong inline ram_bytes
      btrfs-progs: check/lowmem: Prepare check_file_extent() to handle repair
      btrfs-progs: check/lowmem: Repair wrong inline ram_bytes for uncompressed extent
      btrfs-progs: fsck-tests: Add test case for corrupted inline ram_bytes
      btrfs-progs: Don't BUG_ON() if we failed to load one device or one chunk
      btrfs-progs: Exit gracefully when overlapping chunks are detected
      btrfs-progs: tests/fuzz: Add image for bko-200409
      btrfs-progs: check: orig: Don't panic when unexpected root item is referring to one extent
      btrfs-progs: tests/fuzz: Add fuzzed test image for btrfs check BUG_ON
      btrfs-progs: test/fuzz: Add image for BUG_ON() when opening the fs by btrfs check
      btrfs-progs: check: Remove the ability to rebuild root overwriting existing tree blocks
      btrfs-progs: check/original: Avoid infinite loop when failed to repair inode
      btrfs-progs: check/original: Don't overwrite return value when we failed to repair
      btrfs-progs: qgroup-verify: Don't treat qgroup difference as error if the fs hasn't initialized a rescan
      btrfs-progs: fsck-tests: Add test image to check if btrfs check reports uninitialized rescan as error

Stéphane Lesimple (2):
      btrfs-progs: fix nanosecs in task_period_start
      btrfs-progs: check: enhanced progress indicator

Su Yue (3):
      btrfs-progs: print bytenr of tree block in print_tree_block_error
      btrfs-progs: lowmem: fix false alerts of referencer count mismatch for blocks relocated
      btrfs-progs: fsck-tests: add test case with keyed data backref with reloc tree blocks

james harvey (2):
      btrfs-progs: map-logical: Use btrfs_next_extent_item
      btrfs-progs: btrfs_close_devices: only fsync if device->writeable is set

