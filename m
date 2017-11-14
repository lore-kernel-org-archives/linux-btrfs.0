Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752436AbdKNPfb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 10:35:31 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.14-rc1
Date: Tue, 14 Nov 2017 16:33:35 +0100
Message-Id: <20171114153335.5657-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a pre-release has been tagged.

Changes:
  * build: libzstd now required by default
  * check: more lowmem mode repair enhancements
  * subvol set-default: also accept path
  * prop set: compression accepts no/none, same as ""
  * filesystem usage: enable for filesystem on top of a seed device
  * rescue: new command fix-device-size
  * other
    * new tests
    * cleanups and refactoring
    * doc updates

ETA for 4.14 is in +2 days (2017-11-16).

Mailinglist patch backlog has grown again, I'll have to do more minor releases
to get the features and fixes merged. No concrete plans for now, some patchsets
are almost ready so they'll probably go first.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Baruch Siach (1):
      btrfs-progs: convert: add missing types header

Benjamin Peterson (1):
      btrfs-progs: docs: correct grammar

David Sterba (24):
      btrfs-progs: help: print multiple syntax schemas on separate lines
      btrfs-progs: prop: also allow "none" to disable compression
      btrfs-progs: docs: update btrfs-properties
      btrfs-progs: image: move metadump definitions to own header
      btrfs-progs: build: use variables for btrfs-image images
      btrfs-progs: image: start a new header for sanitization functions
      btrfs-progs: image: introduce symbolic names for the sanitization modes
      btrfs-progs: image: pass rb_root to find_collisions
      btrfs-progs: image: drop unused parameter from sanitize_xattr
      btrfs-progs: image: pass sanitize mode and name tree separately to sanitize_inode_ref
      btrfs-progs: image: pass sanitize mode and name tree separately to sanitize_dir_item
      btrfs-progs: image: pass sanitize mode and name tree separately to sanitize_name
      btrfs-progs: image: move sanitization to new file
      btrfs-progs: don't use __u8 for fsid buffers
      btrfs-progs: tests: don't pass size to prepare_test_dev if not necessary
      btrfs-progs: tests: extend fsck/028 to test fix-device-size and mount
      btrfs-progs: docs: update mount options
      btrfs-progs: docs: add impact of atime/noatime
      btrfs-progs: docs: add note about mount option applicability
      btrfs-progs: build: require libzstd support by default
      btrfs-progs: build: mention library dependency for reiserfs
      btrfs-progs: docs: move the rescue fix-device-size command and update
      btrfs-progs: update CHANGES for v4.14
      Btrfs progs v4.14-rc1

Lakshmipathi.G (1):
      btrfs-progs: tests/common: Display warning only after searching for btrfs kernel module

Liu Bo (1):
      btrfs-progs: do not add stale device into fs_devices

Lu Fengqi (7):
      btrfs-progs: qgroup: fix qgroup show sort by multi items
      btrfs-progs: test: Add test image for lowmem mode file extent interrupt
      btrfs-progs: lowmem check: Output more detailed information about file extent interrupt
      btrfs-progs: lowmem check: Fix false alert about referencer count mismatch
      btrfs-progs: test: Add test image for lowmem mode referencer count mismatch false alert
      btrfs-progs: qgroup: cleanup the redundant function add_qgroup
      btrfs-progs: qgroup: split update_qgroup to reduce arguments

Misono, Tomohiro (6):
      btrfs-progs: subvol: change set-default to also accept path
      btrfs-progs: test: add new cli-test for subvol get/set-default
      btrfs-progs: fi: move dev_to_fsid to cmds-fi-usage for later use
      btrfs-progs: fi: enable fi usage for filesystem on top of seed device
      btrfs-progs: device: add description of alias to help message
      btrfs-progs: doc: add description of missing and example, of device remove

Pavel Kretov (1):
      btrfs-progs: defrag: add a brief warning about ref-link breakage

Qu Wenruo (14):
      btrfs-progs: tests: Allow check test to repair in lowmem mode for certain errors
      btrfs-progs: mkfs: avoid BUG_ON for chunk allocation when ENOSPC happens
      btrfs-progs: mkfs: avoid positive return value from cleanup_temp_chunks
      btrfs-progs: mkfs: fix overwritten return value for mkfs
      btrfs-progs: mkfs: error out gracefully for --rootdir
      btrfs-progs: convert: Open the fs readonly for rollback
      btrfs-progs: mkfs: refactor test_minimum_size to use the calculated minimal size
      btrfs-progs: rescue: Fix zero-log mounted branch
      btrfs-progs: Introduce function to fix unaligned device size
      btrfs-progs: Introduce function to fix super block total bytes
      btrfs-progs: rescue: Introduce fix-device-size
      btrfs-progs: check: Also check and repair unaligned/mismatch device and super sizes
      btrfs-progs: tests/fsck: Add test case image for 'rescue fix-dev-size'
      btrfs-progs: print-tree: Print offset as tree objectid for ROOT_ITEM

Satoru Takeuchi (1):
      btrfs-progs: allow "no" to disable compression for convenience

Su Yue (28):
      btrfs-progs: check: enable repair in lowmem mode
      btrfs-progs: check: repair inode nbytes in lowmem mode
      btrfs-progs: check: repair dir inode isize in lowmem mode
      btrfs-progs: check: repair inode orphan item in lowmem mode
      btrfs-progs: check: change find_inode_ref()'s arg
      btrfs-progs: check: modify check_fs_first_inode()
      btrfs-progs: check: change find_dir_index/item
      btrfs-progs: check: introduce print_inode_ref()
      btrfs-progs: check: introduce print_dir_item_err()
      btrfs-progs: check: adjustments for further repair
      btrfs-progs: check: introduce repair_inode_item_missing()
      btrfs-progs: check: introduce repair_fs_first_inode()
      btrfs-progs: check: repair dir_item and inode_ref in lowmem mode
      btrfs-progs: check: count dir inode isize again
      btrfs-progs: check: repair inode nlink in lowmem
      btrfs-progs: check: punch_extent_hole in lowmem
      btrfs-progs: check: special case for last item
      btrfs-progs: check: change the way lowmem mode traverses metadata
      btrfs-progs: check: delete wrong items in lowmem repair
      btrfs-progs: check: introduce repair_chunk_item()
      btrfs-progs: check: introduce repair_tree_block_ref()
      btrfs-progs: check: introduce repair_extent_data_item()
      btrfs-progs: check: repair block group accounting in lowmem mode
      btrfs-progs: check: return value of check_extent_refs
      btrfs-progs: check: call repair_root_items before any repairs
      btrfs-progs: check: error or return value of repair_root_items()
      btrfs-progs: check: check extent_inline_ref in lowmem
      btrfs-progs: fsck-tests: 027/bad_extent_inline_ref_type

