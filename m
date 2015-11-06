Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031997AbbKFLLy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Nov 2015 06:11:54 -0500
Date: Fri, 6 Nov 2015 12:10:21 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.3
Message-ID: <20151106111021.GS13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the btrfs-progs 4.3 have been released.

There's a notable change in the behaviour of mkfs on devices smaller than 1
GiB. The forced --mixed mode is no more. The resulting filesytem will have a
split data and metadata groups. This may lead to earlier 'no-space' because the
space is reserved for metadata use.

* mkfs
  * mixed mode is not forced for filesystems smaller than 1GiB
  * mixed mode broken with mismatching sectorsize and nodesize, fixed
  * print version info earlier
  * print devices sorted by id
  * do not truncate target image with --rootsize

* fi usage:
  * don't print global block reserve
  * print device id
  * minor output tuning
  * other cleanups

* calc-size:
  * div-by-zero fix on an empty filesystem
  * fix crash

* bugfixes:
  * more superblock sanity checks
  * consistently round size of all devices down to sectorsize
  * misc leak fixes
  * convert: don't try to rollback with a half-deleted ext2_saved subvolume

* other:
  * check: add progress indicator
  * scrub: enahced error message
  * show-super: read superblock from a given offset
  * add README
  * docs: update manual page for mkfs.btrfs, btrfstune, balance, convert and
    inspect-internal
  * build: optional build with more warnings (W=...)
  * build: better support for static checkers
  * build: html output of documentation
  * pretty-print: last_snapshot for root_item
  * pretty-print: stripe dev uuid
  * error reporting wrappers, introduced and example use
  * refactor open_file_or_dir
  * other docs and help updates

* testing:
  * test for nodes crossing stripes
  * test for broken 'subvolume sync'
  * basic tests for mkfs, raid option combinations
  * basic tests for fuzzed images (check)
  * command intrumentation (eg valgrind)
  * print commands if requested
  * add README for tests


Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git


Shortlog:

Anand Jain (4):
      btrfs-progs: move is_numerical() helper to utils and rename
      btrfs-progs: device add: cleanup argument handling
      btrfs-progs: fix uninitialized copy of btrfs_fs_devices list
      btrfs-progs: fix missing initialization of list head for dev_list

Chandan Rajendra (2):
      Btrfs-progs: Do not force mixed block group creation unless '-M' option is specified
      Btrfs-progs: Prevent creation of filesystem with 'mixed bgs' and having differing sectorsize and nodesize.

David Sterba (46):
      btrfs-progs: misc tests: add 009-subvolume-sync-must-wait
      btrfs-progs: tests: print commands on terminal if requested
      btrfs-progs: build: allow to build with various compiler warnings
      btrfs-progs: a bit of makefile documentation
      btrfs-progs: check: update help text
      btrfs-progs: build: make support for static checkers more generic
      btrfs-progs: docs: add html build target
      btrfs-progs: cleanup and comment parse_range
      btrfs-progs: do not modify the string in parse_range
      btrfs-progs: extend parse_range API to accept a relaxed range
      btrfs-progs: add helpers for parsing 32bit ranges
      btrfs-progs: add helpers to print ranges
      btrfs-progs: tests: add mkfs tests
      btrfs-progs: tests: add 001-basic-profiles mkfs tests
      btrfs-progs: tests: add 002-no-force-mixed-on-small-volume
      btrfs-progs: tests: add 010-convert-delete-ext2-subvol
      btrfs-progs: tests: set default test image size to 2G
      btrfs-progs: tests: do not run sudo helper tests if not necessary
      btrfs-progs: tests: add test driver for fuzzed images
      btrfs-progs: tests: 001-simple-unmounted: iterate over fuzzed images and run check
      btrfs-progs: tests: add support for command instrumentation
      btrfs-progs: tests: do not log output of run_mayfail to terminal
      btrfs-progs: tests: add 003-mixed-with-wrong-nodesize
      btrfs-progs: mkfs: remove stray message about forced mixed-bg
      btrfs-progs: add an initial README
      btrfs-progs: add initial tests/README
      btrfs-progs: image: fix bogus check after cpu on-line detection
      btrfs-progs: mkfs: print version info first
      btrfs-progs: docs: enhance manual page for mkfs
      btrfs-progs: docs: enhance manual page for btrfstune
      btrfs-progs: docs: enhance manual page for balance
      btrfs-progs: docs: enhance the manual page for convert
      btrfs-progs: docs: enhance manual page for inspect-internal
      Btrfs progs v4.3-rc1
      btrfs-progs: fi usage: do not print global block reserve
      btrfs-progs: fi usage: cleanup, print header in one go
      btrfs-progs: fi usage: print path header in the tabular mode
      btrfs-progs: fi usage: properly count real space infos
      btrfs-progs: fi usage: cleanup, replace header constant
      btrfs-progs: fi usage: cleanup, replace space info starting column constant
      btrfs-progs: fi usage: print device id column in the tabular output<F2>
      btrfs-progs: string table: fix whitespace damage
      btrfs-progs: string table: cleanup, rename single letter variables
      btrfs-progs: string table: add specifier for fillup char
      btrfs-progs: fi usage: print header and footer separation line
      btrfs-progs: mkfs: do not truncate the image when --rootdir is set

Eryu Guan (7):
      btrfs-progs: fix leak of "path" in btrfs_find_item() error paths
      btrfs-progs: save and return error number correctly in check_chunks_and_extents
      btrfs-progs: fix memory leak on error path
      btrfs-progs: remove identical branch in record_extent()
      btrfs-progs: fix memory leak in cmd_qgroup_show()
      btrfs-progs: return -ENOMEM properly in btrfs_read_block_groups()
      btrfs-progs: mute coverity warnings about deadcode

Lakshmipathi.G (1):
      btrfs-progs: print root item's last_snapshot value

Liu Bo (1):
      Btrfs-progs: fix btrfs-convert rollback to check ROOT_BACKREF

Qu Wenruo (6):
      btrfs-progs: fsck: Add check for extent and parent chunk type
      btrfs-progs: Read the whole superblock instead of struct btrfs_super_block
      btrfs-progs: add more superblock validation checks
      btrfs-progs: show-super: Add option to print superblock at given bytenr
      btrfs-progs: print-tree: Output stripe dev uuid
      btrfs-progs: Allow btrfs_leaf_free_space to accept NULL root

Silvio Fricke (2):
      btrfs-progs: check: add progress indicator
      btrfs-progs: use calloc instead of malloc+memset

Zhao Lei (32):
      btrfs-progs: tests: Move extract_image out of check_all_images for common use
      btrfs-progs: tests: Introduce fsck-tests/018-leaf-crossing-stripes
      btrfs-progs: tests: Introduce misc-tests/008-leaf-crossing-stripes
      btrfs-progs: tests: Avoid printing useless warning in fsck tests
      btrfs-progs: use switch instead of a series of ifs for output error message
      btrfs-progs: enhance error message with status from kernel and errno
      btrfs-progs: Introduce warning and error for common use
      btrfs-progs: use common warning/error for cmds-scrub.c
      btrfs-progs: subvolume: use btrfs_open_dir for btrfs subvolume command
      btrfs-progs: filesystem: use btrfs_open_dir for btrfs filesystem command
      btrfs-progs: balance: use btrfs_open_dir for btrfs balance command
      btrfs-progs: inspect: Bypass unnecessary clean function in open_error
      btrfs-progs: inspect: set return value of error case
      btrfs-progs: inspect: use btrfs_open_dir for btrfs inspect command
      btrfs-progs: qgroup: use btrfs_open_dir for btrfs qgroup command
      btrfs-progs: quota: use btrfs_open_dir for btrfs quota command
      btrfs-progs: use btrfs_open_dir in open_path_or_dev_mnt
      btrfs-progs: replace: use btrfs_open_dir for btrfs replace command
      btrfs-progs: fragments: use btrfs_open_dir for btrfs-fragments command
      btrfs-progs: btrfs: Add missing btrfs_close_all_devices for btrfs command
      btrfs-progs: Remove all btrfs_close_all_devices in sub-command
      btrfs-progs: Add all missing btrfs_close_all_devices to standalone tools
      btrfs-progs: Add missing close_ctree to btrfs-select-super.c
      btrfs-progs: use system's default path for math.h
      btrfs-progs: fix floating point exception for btrfs-calc-size
      btrfs-progs: Fix negative eb's ref_cnt in btrfs-calc-size
      btrfs-progs: Fix uninitialized key.type for btrfs_find_free_objectid
      btrfs-progs: Avoid use pointer in handle_options
      btrfs-progs: mkfs: output device list in sorted order
      btrfs-progs: mkfs: remove unused code of format uuid string
      btrfs-progs: Rename variables in btrfs_add_to_fsid
      btrfs-progs: mkfs: Round device size down to sectorsize
