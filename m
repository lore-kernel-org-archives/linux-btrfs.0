Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751585AbeDFPSn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 11:18:43 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.16
Date: Fri,  6 Apr 2018 17:16:13 +0200
Message-Id: <20180406151613.31018-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.16 have been released.

This version brings the new library that should help applications to use the
btrfs functionality in a more convenient way than plain ioctls. And has python
bindings. The rest are bugfixes and small enhancements.

The library is hosted in the progs git because of the close dependency and
maintained primarily by Omar Sandoval.

Changes:

  * libbtrfsutil - new LGPL library to wrap userspace functionality
    * several 'btrfs' commands converted to use it:
      * properties
      * filesystem sync
      * subvolume set-default/get-default/delete/show/sync
    * python bindings, tests
  * build
    * use configured pkg-config path
    * CI: add python, musl/clang, built dependencies caching
    * convert: build fix for e2fsprogs 1.44+
    * don't install library links with wrong permissions
  * fixes
    * prevent incorrect use of subvol_strip_mountpoint
    * dump-super: don't verify csum for unknown type
    * convert: fix inline extent creation condition
  * check:
    * lowmem: fix false alert for 'data extent backref lost for snapshot'
    * lowmem: fix false alert for orphan inode
    * lowmem: fix false alert for shared prealloc extents
  * mkfs:
    * add UUID and otime to root of FS_TREE - with the uuid, snapshots will
      be now linked to the toplevel subvol by the parent UUID
    * don't follow symlinks when calculating size
    * pre-create the UUID tree
    * fix --rootdir with selinux enabled
  * dump-tree: add option to print only children nodes of a given block
  * image: handle missing device for RAID1
  * other
    * new tests
    * test script cleanups (quoting, helpers)
    * tool to edit superblocks
    * updated docs

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Axel Burri (1):
      btrfs-progs: prevent incorrect use of subvol_strip_mountpoint

David Sterba (24):
      btrfs-progs: build: configure.ac hard-codes the pkg-config command
      btrfs-progs: tests: add test for send -p on 2 mont points
      btrfs-progs: tests: add helper to log pipe stdout
      btrfs-progs: ci: add python dependencies for libbtrfsutil
      libbtrfsutil: add stub for reallocarray
      btrfs-progs: ci: cache built dependencies
      libbtrfsutils: add python-devel detection
      btrfs-progs: ci: update test image packages - add clang and python
      btrfs-progs: ci: enable clang and python for musl build test
      btrfs-progs: docs: add section about filesystem limits to btrfs(5)
      btrfs-progs: tests: fix source path for testsuite
      btrfs-progs: tests: don't use fallocate in mkfs/014-rootdir-inline-extent
      btrfs-progs: tests: mkfs fills uuid and otime for FS_TREE
      btrfs-progs: tests: update README, images, coding style
      btrfs-progs: tests: convert/014 use shell builtin for generating content
      btrfs-progs: tests: add shell quoting to fuzz test scripts
      btrfs-progs: tests: remove trivial use of local variables
      btrfs-progs: tests: add shell quotes to mkfs test scripts
      btrfs-progs: tests: add shell quotes to misc test scripts
      btrfs-progs: add tool to edit super blocks
      btrfs-progs: mkfs: precreate the uuid tree
      btrfs-progs: docs: fix typos
      btrfs-progs: update CHANGES for v4.16
      Btrfs progs v4.16

Filipe Manana (2):
      Btrfs-progs: check, fix false error reports for shared prealloc extents
      Btrfs-progs: add fsck test for filesystem with shared prealloc extents

Gu Jinxiang (1):
      btrfs-progs: Remove unused parameter

Lu Fengqi (4):
      btrfs-progs: check/lowmem: Fix the incorrect error message of check_extent_data_item
      btrfs-progs: check/lowmem: Fix false alert of data extent backref lost for snapshot
      btrfs-progs: fsck-tests: Introduce test case with keyed data backref with the extent offset
      btrfs-progs: build: modify cscope/ctags rules to include directories such as check

Misono Tomohiro (2):
      btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of, FS_TREE
      btrfs-progs: mkfs rootdir: use lgetxattr() not to follow a symbolic link

Misono, Tomohiro (1):
      btrfs-progs: remove BTRFS_CRC32_SIZE definition

Nicholas D Steeves (1):
      btrfs-progs: Fix typos in docs and user-facing strings

Nikolay Borisov (1):
      btrfs-progs: Beautify owner when printing leaf/nodes

Omar Sandoval (30):
      Add libbtrfsutil
      libbtrfsutil: add Python bindings
      libbtrfsutil: add qgroup inheritance helpers
      libbtrfsutil: add filesystem sync helpers
      libbtrfsutil: fix Python tests
      libbtrfsutil: copy in Btrfs UAPI headers
      libbtrfsutil: add btrfs_util_is_subvolume() and btrfs_util_subvolume_id()
      libbtrfsutil: add btrfs_util_create_subvolume()
      libbtrfsutil: add btrfs_util_subvolume_path()
      libbtrfsutil: add btrfs_util_subvolume_info()
      libbtrfsutil: add btrfs_util_[gs]et_read_only()
      libbtrfsutil: add btrfs_util_[gs]et_default_subvolume()
      libbtrfsutil: add subvolume iterator helpers
      libbtrfsutil: add btrfs_util_create_snapshot()
      libbtrfsutil: add btrfs_util_delete_subvolume()
      libbtrfsutil: add btrfs_util_deleted_subvolumes()
      btrfs-progs: use libbtrfsutil for read-only property
      btrfs-progs: use libbtrfsutil for sync ioctls
      btrfs-progs: use libbtrfsutil for set-default
      btrfs-progs: use libbtrfsutil for get-default
      btrfs-progs: use libbtrfsutil for subvol delete
      btrfs-progs: use libbtrfsutil for subvol show
      btrfs-progs: use libbtrfsutil for subvol sync
      btrfs-progs: replace test_issubvolume() with btrfs_util_is_subvolume()
      libbtrfsutil: use pkg-config detection for the right Python version
      libbtrfsutil: don't return free space cache inodes from deleted_subvolumes()
      libbtrfsutil: fix memory leak in deleted_subvolumes()
      libbtrfsutil: use local mkfs.btrfs for tests if it exists
      libbtrfsutil: always build libbtrfsutil.so.$MAJOR
      libbtrfsutil: fix test assumptions about top-level subvolume

Peter Kjellerstedt (1):
      btrfs-progs: build: Do not use cp -a to install library links

Qu Wenruo (28):
      btrfs-progs: Refactor parameter of BTRFS_MAX_DEVS() from root to fs_info
      btrfs-progs: Introduce btrfs_raid_array and related infrastructures
      btrfs-progs: volumes: Allow find_free_dev_extent() to return maximum hole size
      btrfs-progs: Move chunk stripe size calculation function to volumes.h
      btrfs-progs: free-space-cache: Use DIV_ROUND_UP() to replace open code
      btrfs-progs: free-space-cache: Enhance free space cache free space check
      btrfs-progs: dump-super: Don't verify csum if csum type or size is unknown
      btrfs-progs: gitignore: Ignore *.restored test image
      btrfs-progs: gitignore: Ignore patches
      btrfs-progs: check: lowmem: Fix false alert about orphan inode
      btrfs-progs: tests: Add test case with valid orphan inode
      btrfs-progs: ctree: Add extra level check for read_node_slot()
      btrfs-progs: convert/ext2: Remove check for ext2_ext_attr_entry->e_value_block
      btrfs-progs: print-tree: Do correct offset output for ROOT_ITEM
      btrfs-progs: print-tree: Enhance warning on tree block level mismatch and error handling
      btrfs-progs: dump-tree: add option to print children nodes of a given block
      btrfs-progs: convert: Fix inline file extent creation condition
      btrfs-progs: mkfs/rootdir: Fix inline extent creation check
      btrfs-progs: check: original mode: Check inline extent size
      btrfs-progs: check/lowmem mode: Check inline extent size
      btrfs-progs: test/convert: Add test case for invalid large inline data extent
      btrfs-progs: tests: Add testcase for rootdir inline extent size
      btrfs-progs: check/original: Remove unused variable first_key
      btrfs-progs: mkfs/rootdir: Don't follow symbolic link when calcuating size
      btrfs-progs: tests: Test if mkfs.btrfs --rootdir can handle ng symlink
      btrfs-progs: disk-io: Fix read_extent_data() error handler for missing device
      btrfs-progs: convert: Fix offset-by-one error in read_data_extent()
      btrfs-progs: tests: Test if btrfs-image can handle RAID1 missing device

