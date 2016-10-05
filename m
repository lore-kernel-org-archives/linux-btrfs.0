Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbcJELaE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Oct 2016 07:30:04 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.8
Date: Wed,  5 Oct 2016 13:29:49 +0200
Message-Id: <20161005112949.8086-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.8 have been released. Though it's a major version release, there
are no shiny new features. The theme was error handling improvements and
addressing some fuzzer bugz.

There are several fuzzer bugs open and some tests might report errors with ASAN
or UBSAN enabled. Fixing needs more time, as some bugons happen deep in call
chains. At this moment, bugs triggered by fuzzed images are not considered
release blockers.

Changes:
  * error handling improvements all over the place
  * new fuzzed images, test updates
  * doc fixups
  * minor cleanups and improvements
  * kernel library helpers moved to own directory
  * qgroup: fix regression leading to incorrect status after check,
    introduced in 4.7

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Adam Borowski (1):
      btrfs-progs: docs: document exit codes from scrub

David Sterba (75):
      btrfs-progs: scrub: improved error handling in scrub_read_file
      btrfs-progs: fi usage: improved error handling in load_device_info
      btrfs-progs: dump-tree: improved error handling in print_extents
      btrfs-progs: dump-tree: improved error handling in cmd_inspect_dump_tree
      btrfs-progs: switch BUG_ON to ASSERT in reserve_free_space
      btrfs-progs: more verbose error handling in creation helpers
      btrfs-progs: mkfs: check for sane sectorsize earlier
      btrfs-progs: handle errors from btrfs_alloc_path
      btrfs-progs: receive: improved error handling in process_snapshot
      btrfs-progs: check: improved error handling in calc_extent_flag
      btrfs-progs: switch column values to asserts
      btrfs-progs: chunk-recover: improve error handling in insert_stripe
      btrfs-progs: mkfs: handle block ordering errors in make_btrfs
      btrfs-progs: convert: improve error handling in create_image_file_range
      btrfs-progs: catch invalid flags in open_ctree_fd
      btrfs-progs: remove trivial helpers for filtering functions
      btrfs-progs: qgroup: switch to common message helpers
      btrfs-progs: improved error handling in btrfs_print_tree
      btrfs-progs: inspect: improved error handling
      btrfs-progs: fi du: catch bogus extent lengths
      btrfs-progs: fi du: improved error handling in mark_inode_seen
      btrfs-progs: tree-stats: switch to common message helpers
      btrfs-progs: prop: simplify help printing code
      btrfs-progs: remove redundant check in btrfs_add_to_fsid
      btrfs-progs: improve error handling in btrfs_alloc_data_chunk
      btrfs-progs: dump-super: switch to common message helpers
      btrfs-progs: corrupt-block: improved error handling in corrupt_item_nocow
      btrfs-progs: improve error handling in btrfs_add_to_fsid
      btrfs-progs: use standard allocation functions in non-kenrel code
      btrfs-progs: check: handle errors returned by add_extent_rec_nolookup
      btrfs-progs: check: improve error handling in add_extent_rec_nolookup
      btrfs-progs: convert: improve error handling in do_rollback
      btrfs-progs: image: switch to common message helpers
      btrfs-progs: check: switch some messages to common helpers
      btrfs-progs: corrupt-block: fix assertion condition
      btrfs-progs: improve error handling in clone_inode_rec
      btrfs-progs: cleanup, kill trivial btrfs_set_key_type helper
      btrfs-progs: cleanup, kill trivial btrfs_key_type helper
      btrfs-progs: remove unused variable in add_inode_items
      btrfs-progs: use PATH_MAX in cmd_inspect_logical_resolve
      btrfs-progs: mkfs: remove useless helper
      btrfs-progs: tests: iterate over fuzzed images and test various tools
      btrfs-progs: tests: add script to scan results for some known runtime errors
      btrfs-progs: build: add basic support for subdirectory build
      btrfs-progs: move 3rd party kernel library modules to own directory
      btrfs-progs: restore: update help text
      btrfs-progs: remove stray function declaration
      btrfs-progs: don't write to optarg in btrfs_qgroup_parse_sort_string
      btrfs-progs: constify string arguments where appropriate
      btrfs-progs: image: use common message helpers
      btrfs-progs: btrfstune: use common message helpers
      btrfs-progs: more sanity checks in read_tree_block_fs_info
      btrfs-progs: tests: add fuzzed images with bad blocksize/lengh of eb
      btrfs-progs: check: better error handling in find_parent_roots
      btrfs-progs: tests: add fuzzed image with bad parent refs, qgroup-verify
      btrfs-progs: image: catch zero length extents, avoid endless loop
      btrfs-progs: image: return negativer error from all paths in mdrestore_init
      btrfs-progs: image: drop useless bug_on
      btrfs-progs: print value when assertion fails
      btrfs-progs: chunk-recover: handle duplicate cache entries
      btrfs-progs: don't access freed memory in btrfs_close_devices
      btrfs-progs: tests: split test 004 to separate tests
      btrfs-progs: tests: don't treat segfault as ignorable error
      btrfs-progs: rename __setup_root and change to return void
      btrfs-progs: convert: add new callback to check state
      btrfs-progs: dump-super: print chunks after validation
      btrfs-progs: tests: teach run_mayfail about sigabrt
      btrfs-progs: kerncompat: make WARN_ON more verbose
      btrfs-progs: kerncompat: call abort at the end of assert_trace
      btrfs-progs: build: add alias for check tests
      btrfs-progs: kerncompat: add build-time assertion support
      btrfs-progs: mkfs: fix warning for printf format on 32bit
      btrfs-progs: add build-time checks for size of ioctl structures
      btrfs-progs: update CHANGES for v4.8
      Btrfs progs v4.8

Domagoj Tršan (1):
      btrfs-progs: change btrfs_csum_final result param type to u8

Lakshmipathi.G (1):
      btrfs-progs: convert: check source file system state

Nicholas D Steeves (1):
      btrfs-progs: fix user-facing typos in docs and help strings

Qu Wenruo (4):
      btrfs-progs: Return more meaningful value for btrfs_read_deve_super
      btrfs-progs: super-recover: Reuse btrfs_read_dev_super function
      btrfs-progs: qgroup: Fix regression leads to corrupted qgroup status
      btrfs-progs: Remove unnecessary parameter to clear_extent_uptodate

