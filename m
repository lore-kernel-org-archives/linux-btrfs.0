Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbbFQLse (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 07:48:34 -0400
Date: Wed, 17 Jun 2015 13:48:32 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.1-rc1
Message-ID: <20150617114832.GT6761@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

unusual load of changes. Among the small UI enhancements, the mkfs output
rework is worth mentioning separately. It's based on Goffredo's patches
but I've tweaked the output:

Current:
https://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/commit/?id=60447579c41a10069b67d502b317bf57519acdd3

Original proposal:
https://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/commit/?id=3afd86683b7324c9fec94ca2c35b64ac72ab523f

The ETA for 4.1 release is next week, please give it a test and report
bugs.


* bugfixes
  - fsck.btrfs: no bash-isms
  - bugzilla 97171: invalid memory access (with tests)
  - receive:
    - cloning works with --chroot
    - capabilities not lost
  - mkfs: do not try to register bare file images
  - option --help accepted by the standalone utilities

* enhancements
  - corrupt block: ability to remove csums
  - mkfs:
    - warn if metadata redundancy is lower than for data
    - options to make the output quiet (only errors)
    - mixed case names of raid profiles accepted
    - rework the output:
      - more compact, 'key: value' format
  - subvol:
    - show:
      - print received uuid
      - update the output
    - sync:
      - grab all deleted ids and print them as they're removed,
	previous implementation only checked if there are any
	to be deleted - change in command semantics
  - scrub: print timestamps in days HMS format
  - receive:
    - can specify mount point, do not rely on /proc
    - can work inside subvolumes
  - send:
    - new option to send stream without data (NO_FILE_DATA)
  - convert:
    - specify incompat features on the new fs
  - qgroup:
    - show: distinguish no limits and 0 limit value
    - limit: ability to clear the limit
  - help for 'btrfs' is shorter, 1st level command overview
  - debug tree: print key names according to their C name

* new
  - rescure zero-log
  - btrfsune:
    - rewrite uuid on a filesystem image
    - new option to turn on NO_HOLES incompat feature

* deprecated
  - standalone btrfs-zero-log

* other
  - testing framework updates
    - uuid rewrite test
    - btrfstune feature setting test
    - zero-log tests
    - more testing image formats
  - manual page updates
  - ioctl.h synced with current kernel uapi version
  - convert: preparatory works for more filesystems (reiserfs pending)
  - use static buffers for path handling where possible
  - add new helpers for send uilts that check memory allocations,
    switch all users, deprecate old helpers
  - Makefile: fix build dependency generation

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Anand Jain (2):
      btrfs-progs: add info about list-all to the help
      btrfs-progs: use function is_block_device() instead

Dimitri John Ledkov (1):
      btrfs-progs: fsck.btrfs: Fix bashism and bad getopts processing

Dongsheng Yang (4):
      btrfs-progs: qgroup: show 'none' when we did not limit it on this qgroup
      btrfs-progs: qgroup: allow user to clear some limitation on qgroup.
      btrfs-progs: qgroup limit: error out if input value is negative
      btrfs-progs: qgroup limit: add a check for invalid input of 'T/G/M/K'

Emil Karlson (1):
      btrfs-progs: use openat for process_clone in receive

Goffredo Baroncelli (4):
      btrfs-progs: add strdup in btrfs_add_to_fsid() to track the device path
      btrfs-progs: return the fsid from make_btrfs()
      btrfs-progs: mkfs: track sizes of created block groups
      btrfs-progs: mkfs: print the summary

Jeff Mahoney (8):
      btrfs-progs: convert: clean up blk_iterate_data handling wrt record_file_blocks
      btrfs-progs: convert: remove unused fs argument from block_iterate_proc
      btrfs-progs: convert: remove unused inode_key in copy_single_inode
      btrfs-progs: convert: rename ext2_root to image_root
      btrfs-progs: compat: define DIV_ROUND_UP if not already defined
      btrfs-progs: convert: fix typo in btrfs_insert_dir_item call
      btrfs-progs: convert: factor out adding dirent into convert_insert_dirent
      btrfs-progs: convert: factor out block iteration callback

Josef Bacik (3):
      Btrfs-progs: corrupt-block: add the ability to remove csums
      btrfs-progs: specify mountpoint for recieve
      btrfs-progs: make receive work inside of subvolumes

Qu Wenruo (6):
      btrfs-progs: Enhance read_tree_block to avoid memory corruption
      btrfs-progs: btrfstune: rework change_uuid
      btrfs-progs: btrfstune: add ability to restore unfinished fsid change
      btrfs-progs: btrfstune: add '-U' and '-u' option to change fsid
      btrfs-progs: Documentation: uuid change
      btrfs-progs: btrfstune: fix a bug which makes unfinished fsid change unrecoverable

Sam Tygier (1):
      btrfs-progs: mkfs: check metadata redundancy

David Sterba (73):
      btrfs-progs: tests: log the test name in results file
      btrfs-progs: tests: support more formats of test images
      btrfs-progs: tests: use readlink -f to resolve path
      btrfs-progs: tests: sort image files
      btrfs-progs: test: 015-check-bad-memory-access
      btrfs-progs: tests: add script to clean intermediate images
      btrfs-progs: receive: restore capabilities after chown
      btrfs-progs: tests: add driver script for misc tests
      btrfs-progs: tests: common: add helper run_check_stdout
      btrfs-progs: tests: add misc test for fs features
      btrfs-progs: update .gitignore
      btrfs-progs: subvol show: print received uuid
      btrfs-progs: subvol show: tweak output
      btrfs-progs: btrfstune: rework option handling
      btrfs-progs: btrfstune: add option to enable NO_HOLES
      btrfs-progs: doc: update btrfstune manpage
      btrfs-progs: tests: add misc tests for uuid rewrite
      btrfs-progs: btrfstune: make uuid rewrite progress more verbose
      btrfs-progs: ioctl.h: reorder to match kernel uapi header
      btrfs-progs: ioctl.h: copy commented version of scrub_progress structure
      btrfs-progs: ioctl.h: copy commented version of balance structures
      btrfs-progs: ioctl.h: add EXTENT_SAME ioctl and structures
      btrfs-progs: ioctl.h: add send flag mask
      btrfs-progs: ioctl.h: update type annotations
      btrfs-progs: ioctl.h: update btrfs_ioctl_fs_info_args
      btrfs-progs: ioctl.h: add btrfs_ioctl_feature_flags struct
      btrfs-progs: doc: update btrfs-rescue page and drop btrfs-zero-log
      btrfs-progs: scrub: more friendly duration format in status
      btrfs-progs: add function to stringify filesystem features
      btrfs-progs: convert: allow to set filesystem features
      btrfs-progs: tests: update convert tests to set fs features
      btrfs-progs: cleanup and deprecate btrfs-zero-log
      btrfs-progs: tests: add test for zero-log
      btrfs-progs: mkfs: add option to make it quiet
      btrfs-progs: mkfs: accept mixed case for profile names
      btrfs-progs: mkfs: move info message out of btrfs_add_to_fsid
      btrfs-progs: mkfs: do not try to register non-block-devices
      btrfs-progs: mkfs, move uuid to the end of device summary
      btrfs-progs: mkfs, drop UUID from device summary
      btrfs-progs: mkfs: drop mixed from summary
      btrfs-progs: mkfs: make the summary more compact
      btrfs-progs: remove stray deprecation notice
      btrfs-progs: fix argv0_buf handling
      btrfs-progs: add command group info strings
      btrfs-progs: print compact help for btrfs
      btrfs-progs: receive: fix minor resource leak
      btrfs-progs: cleanup after errors in open_file_or_dir3
      btrfs-progs: subvol: let sync check only current deletions
      btrfs-progs: add helper to wait for subvolume cleaning
      btrfs-progs: add missing includes to header files
      btrfs-progs: accept --help as option in the standalone utilities
      btrfs-progs: print error within test_dev_for_mkfs
      btrfs-progs: print error within test_num_disk_vs_raid
      btrfs-progs: use less memory for pretty_size_mode buffers
      btrfs-progs: receive: implement the update_extent callback
      btrfs-progs: send: add option to for the no-data mode
      btrfs-progs: use PATH_MAX instead of BTRFS_PATH_NAME_MAX
      btrfs-progs: properly set up ioctl arguments
      btrfs-progs: receive: use static buffer for cur_subvol
      btrfs-progs: add helper for copying paths
      btrfs-progs: receive: use static buffer for mount point option argument
      btrfs-progs: receive: use static buffer for source file
      btrfs-progs: send: use static buffer for output file name
      btrfs-progs: and new path_cat helpers to send utils
      btrfs-progs: send utils: switch callbacks to new helpers
      btrfs-progs: unify naming of key types in print-tree
      btrfs-progs: receive: use static buffer for root_subvol_path
      btrfs-progs: receive: use static buffer for write_path
      btrfs-progs: send utils: switch callbacks to patch_cat3_out
      btrfs-progs: receive: use static buffer for cur_subvol path
      btrfs-progs: send utils: deprecate path_cat and path_cat3
      btrfs-progs: Makefile: fix typo, dependencies for cmds-* files
      Btrfs progs v4.1-rc1
