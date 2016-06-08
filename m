Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423935AbcFHJhB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jun 2016 05:37:01 -0400
Date: Wed, 8 Jun 2016 11:37:37 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.6-rc1
Message-ID: <20160608093737.GD3905@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the next major version 4.6 is about to be released, ETA tomorrow. The biggest
change is the btrfs-convert rewrite. The delayed release was caused by more
testing as there were some late fixes to the code although the patchset
has been in the development branch for a long time.

Apart from that, usual load of small fixes and improvements.

* convert - major rewrite:
  * fix a long-standing bug that led to mixing data blocks into metadata block
    groups
  * the workaround was to do full balance after conversion, which was
    recommended practice anyway
  * explicitly set the lowest supported version of e2fstools to 1.41
* provide and install udev rules file that addresses problems with device
  mapper devices, renames after removal
* send: new option: quiet
* dev usage: report slack space (device size minus filesystem area on the dev)
* image: support DUP
* build: short options to enable debugging builds
* other:
  * code cleanups
  * build fixes
  * more tests and other enhancements

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Anand Jain (2):
      btrfs-progs: makefile: add clean-all to the usage
      btrfs-progs: clean up commands.h

David Sterba (22):
      btrfs-progs: build: add support for debugging builds
      btrfs-progs: docs: compression is disabled with nodatasum/nodatacow
      btrfs-progs: device usage: report slack space
      btrfs-progs: makefile: add target for testing installation
      btrfs-progs: drop O_CREATE from open_ctree_fs_info
      btrfs-progs: fix type mismatch in backtrace dumping functions
      btrfs-progs: switch to common message helpers in utils.c
      btrfs-progs: tests: convert, run md5sum with sudo helper
      btrfs-progs: tests: run rollback after conversion
      btrfs-progs: tests: convert: dump all superblocks after conversion
      btrfs-progs: tests: document cli-tests in readme
      btrfs-progs: use wider int type in btrfs_min_global_blk_rsv_size
      btrfs-progs: tests: move convert helpers to a separate file
      btrfs-progs: tests: convert: separate ext2 tests
      btrfs-progs: tests: convert: separate ext3 tests
      btrfs-progs: tests: convert: separate ext4 tests
      btrfs-progs: tests: clean up the test driver of convert tests
      btrfs-progs: tests: convert: set common variables
      btrfs-progs: tests: unify test drivers
      btrfs-progs: tests: 004-ext2-backup-superblock-ranges, drop unnecessary root privs
      btrfs-progs: tests: 004-ext2-backup-superblock-ranges, use common helpers for image loop
      Btrfs progs v4.6-rc1

Jeff Mahoney (1):
      btrfs-progs: udev: add rules for dm devices

Lu Fengqi (2):
      btrfs-progs: tests: add 020-extent-ref-cases
      btrfs-progs: make btrfs-image restore to support dup

M G Berberich (1):
      btrfs-progs: send: add quiet option

Merlin Hartley (1):
      btrfs-progs: doc: fix typo in btrfs-subvolume

Nicholas D Steeves (1):
      btrfs-progs: typo review of strings and comments

Qu Wenruo (36):
      btrfs-progs: Enhance tree block check by checking empty leaf or node
      btrfs-progs: Return earlier for previous item
      btrfs-progs: convert-tests: Add test for backup superblock migration
      btrfs-progs: corrupt-block: Add support to corrupt extent for skinny metadata
      btrfs-progs: utils: Introduce new pseudo random API
      btrfs-progs: Use new random number API
      btrfs-progs: convert-tests: Add support for custom test scripts
      btrfs-progs: convert-tests: Add test case for backup superblock migration
      btrfs-progs: convert: add compatibility layer for e2fsprogs < 1.42
      btrfs-progs: convert: Introduce functions to read used space
      btrfs-progs: convert: Introduce new function to remove reserved ranges
      btrfs-progs: convert: Introduce function to calculate the available space
      btrfs-progs: utils: Introduce new function for convert
      btrfs-progs: Introduce function to setup temporary superblock
      btrfs-progs: Introduce function to setup temporary tree root
      btrfs-progs: Introduce function to setup temporary chunk root
      btrfs-progs: Introduce function to initialize device tree
      btrfs-progs: Introduce function to initialize fs tree
      btrfs-progs: Introduce function to initialize csum tree
      btrfs-progs: Introduce function to setup temporary extent tree
      btrfs-progs: Introduce function to create convert data chunks
      btrfs-progs: extent-tree: Introduce function to find the first overlapping extent
      btrfs-progs: extent-tree: Enhance btrfs_record_file_extent
      btrfs-progs: convert: Introduce new function to create converted image
      btrfs-progs: convert: Introduce function to migrate reserved ranges
      btrfs-progs: convert: Enhance record_file_blocks to handle reserved ranges
      btrfs-progs: convert: Introduce init_btrfs_v2 function.
      btrfs-progs: Introduce do_convert_v2 function
      btrfs-progs: Convert: Add support for rollback new convert behavior
      btrfs-progs: convert: Strictly avoid meta or system chunk allocation
      btrfs-progs: Cleanup old btrfs-convert
      btrfs-progs: convert: Add support to rollback new convert image
      btrfs-progs: convert: Fix a bug that makes convert asserts at scan time
      btrfs-progs: convert: Fix bugs in backup superblock migration
      btrfs-progs: convert: Insert needed holes for superblock migration
      btrfs-progs: convert: Fix a bug which fails to insert hole file extent

Satoru Takeuchi (7):
      btrfs-progs: prop: simplify parse_args()
      btrfs-progs: prop: remove conditions which never be satisfied
      btrfs-progs: btrfs-crc: fix build error
      btrfs-progs: btrfs-crc should be ignored by git
      btrfs-progs: btrfs-crc: print usage on receiving invalid arguments
      btrfs-progs: btrfs-crc: improve usage message
      btrfs-progs: btrfs-crc: make argc check more strict

Zhao Lei (3):
      btrfs-progs: autogen: Avoid chdir fail on dirname with blank
      btrfs-progs: autogen: Don't show success message on fail
      btrfs-progs: autogen: Make build success in CentOS 6 and 7
