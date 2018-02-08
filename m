Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12465 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750850AbeBHGfE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 01:35:04 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v5 0/3] Add support for export testsuits
Date: Thu, 8 Feb 2018 14:34:17 +0800
Message-ID: <1518071660-16878-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Achieved:
1. export testsuite by:
 $ make testsuite
files list in testsuites-list will be added into tarball btrfs-progs-tests.tar.gz.

2. after decompress btrfs-progs-tests.tar.gz, run test by:
 $ TEST=`MASK` ./tests/mkfs-tests.sh
and, without MASK also be ok.
replenish:
 $ tar -xzvf ./btrfs-progs-tests.tar.gz
 $ ls
   btrfs-progs
tests directory and other files is in btrfs-progs.

Changelog:
v5->v4: modify patch2.
	make TEST_TOP to represent tests directory.
	and introduce INTERNAL_BIN for internal binaries.
v4->v3: modify patch2.
        1.keep TOP used for binaries, and introduce TEST_TOP for other resources.
v3->v2:
patch1:
        1.change command from `make package` to `make testsuite`
        2.create btrfs-progs-tests.tar.gz in the current directory,
          so remove EXPORT variable.
        3.add a listfile which list files to be added into tarball.
          and, add Documentation into the list. And revert the patch3
          in v2.
        4.add some identification info of tarball
        5.add temporary file testsuites-id to .gitignore

patch3: modify the readme according to the change of patch1.


v2->v1:
big change of realize idea.
from use EXEC parameter given to run the testsuite to export the testsuite files to
a separate tar, run from a script.


Gu Jinxiang (3):
  btrfs-progs: Add make testsuite command for export tests
  btrfs-progs: introduce TEST_TOP and INTERNAL_BIN for tests directory
    and internal binaries
  btrfs-progs: Add readme for export testsuits

 .gitignore                                         |  1 +
 Makefile                                           |  4 +++
 tests/README.md                                    | 13 ++++++++
 tests/cli-tests.sh                                 | 15 ++++++---
 tests/cli-tests/001-btrfs/test.sh                  |  2 +-
 .../cli-tests/002-balance-full-no-filters/test.sh  |  2 +-
 tests/cli-tests/003-fi-resize-args/test.sh         |  2 +-
 .../cli-tests/004-send-parent-multi-subvol/test.sh |  2 +-
 tests/cli-tests/005-qgroup-show/test.sh            |  2 +-
 tests/cli-tests/006-qgroup-show-sync/test.sh       |  2 +-
 tests/cli-tests/007-check-force/test.sh            |  2 +-
 .../008-subvolume-get-set-default/test.sh          |  2 +-
 tests/common                                       | 16 ++++++----
 tests/convert-tests.sh                             | 15 ++++++---
 tests/convert-tests/001-ext2-basic/test.sh         |  4 +--
 tests/convert-tests/002-ext3-basic/test.sh         |  4 +--
 tests/convert-tests/003-ext4-basic/test.sh         |  4 +--
 .../004-ext2-backup-superblock-ranges/test.sh      |  2 +-
 .../convert-tests/005-delete-all-rollback/test.sh  |  4 +--
 tests/convert-tests/006-large-hole-extent/test.sh  |  4 +--
 .../007-unsupported-block-sizes/test.sh            |  4 +--
 tests/convert-tests/008-readonly-image/test.sh     |  4 +--
 tests/convert-tests/009-common-inode-flags/test.sh |  4 +--
 tests/convert-tests/010-reiserfs-basic/test.sh     |  4 +--
 .../011-reiserfs-delete-all-rollback/test.sh       |  4 +--
 .../012-reiserfs-large-hole-extent/test.sh         |  4 +--
 .../013-reiserfs-common-inode-flags/test.sh        |  4 +--
 .../014-reiserfs-tail-handling/test.sh             |  4 +--
 .../015-no-rollback-after-balance/test.sh          |  4 +--
 tests/export-tests.sh                              | 37 ++++++++++++++++++++++
 tests/fsck-tests.sh                                | 17 +++++++---
 tests/fsck-tests/006-bad-root-items/test.sh        |  2 +-
 tests/fsck-tests/012-leaf-corruption/test.sh       |  2 +-
 tests/fsck-tests/013-extent-tree-rebuild/test.sh   |  4 +--
 tests/fsck-tests/018-leaf-crossing-stripes/test.sh |  2 +-
 .../fsck-tests/019-non-skinny-false-alert/test.sh  |  2 +-
 tests/fsck-tests/020-extent-ref-cases/test.sh      |  2 +-
 .../021-partially-dropped-snapshot-case/test.sh    |  2 +-
 tests/fsck-tests/022-qgroup-rescan-halfway/test.sh |  2 +-
 tests/fsck-tests/023-qgroup-stack-overflow/test.sh |  2 +-
 tests/fsck-tests/024-clear-space-cache/test.sh     |  2 +-
 tests/fsck-tests/025-file-extents/test.sh          |  2 +-
 tests/fsck-tests/026-bad-dir-item-name/test.sh     |  2 +-
 tests/fsck-tests/027-tree-reloc-tree/test.sh       |  2 +-
 .../028-unaligned-super-dev-sizes/test.sh          |  2 +-
 tests/fuzz-tests.sh                                | 15 ++++++---
 .../fuzz-tests/001-simple-check-unmounted/test.sh  |  4 +--
 tests/fuzz-tests/002-simple-image/test.sh          |  4 +--
 tests/fuzz-tests/003-multi-check-unmounted/test.sh |  4 +--
 tests/fuzz-tests/004-simple-dump-tree/test.sh      |  4 +--
 tests/fuzz-tests/005-simple-dump-super/test.sh     |  4 +--
 tests/fuzz-tests/006-simple-tree-stats/test.sh     |  4 +--
 tests/fuzz-tests/007-simple-super-recover/test.sh  |  4 +--
 tests/fuzz-tests/008-simple-chunk-recover/test.sh  |  4 +--
 tests/fuzz-tests/009-simple-zero-log/test.sh       |  4 +--
 tests/misc-tests.sh                                | 17 +++++++---
 tests/misc-tests/001-btrfstune-features/test.sh    |  2 +-
 tests/misc-tests/002-uuid-rewrite/test.sh          |  6 ++--
 tests/misc-tests/003-zero-log/test.sh              |  4 +--
 tests/misc-tests/004-shrink-fs/test.sh             |  2 +-
 .../005-convert-progress-thread-crash/test.sh      |  2 +-
 .../misc-tests/006-image-on-missing-device/test.sh |  2 +-
 tests/misc-tests/007-subvolume-sync/test.sh        |  2 +-
 tests/misc-tests/008-leaf-crossing-stripes/test.sh |  2 +-
 .../009-subvolume-sync-must-wait/test.sh           |  2 +-
 .../010-convert-delete-ext2-subvol/test.sh         |  2 +-
 tests/misc-tests/011-delete-missing-device/test.sh |  2 +-
 tests/misc-tests/012-find-root-no-result/test.sh   |  2 +-
 tests/misc-tests/013-subvolume-sync-crash/test.sh  |  2 +-
 tests/misc-tests/014-filesystem-label/test.sh      |  2 +-
 tests/misc-tests/015-dump-super-garbage/test.sh    |  2 +-
 tests/misc-tests/016-send-clone-src/test.sh        |  2 +-
 .../017-recv-stream-malformatted/test.sh           |  2 +-
 tests/misc-tests/018-recv-end-of-stream/test.sh    |  2 +-
 .../019-receive-clones-on-mounted-subvol/test.sh   |  4 +--
 .../020-fix-superblock-corruption/test.sh          |  2 +-
 tests/misc-tests/021-image-multi-devices/test.sh   |  2 +-
 .../022-filesystem-du-on-empty-subvol/test.sh      |  2 +-
 .../023-device-usage-with-missing-device/test.sh   |  2 +-
 .../misc-tests/024-inspect-internal-rootid/test.sh |  2 +-
 tests/misc-tests/025-zstd-compression/test.sh      |  2 +-
 .../026-image-non-printable-chars/test.sh          |  2 +-
 .../027-subvol-list-deleted-toplevel/test.sh       |  2 +-
 tests/mkfs-tests.sh                                | 17 +++++++---
 tests/mkfs-tests/001-basic-profiles/test.sh        |  2 +-
 .../002-no-force-mixed-on-small-volume/test.sh     |  2 +-
 .../003-mixed-with-wrong-nodesize/test.sh          |  2 +-
 tests/mkfs-tests/004-rootdir-keeps-size/test.sh    |  4 +--
 .../005-long-device-name-for-ssd/test.sh           |  2 +-
 tests/mkfs-tests/006-partitioned-loopdev/test.sh   |  2 +-
 .../mkfs-tests/007-mix-nodesize-sectorsize/test.sh |  2 +-
 .../008-sectorsize-nodesize-combination/test.sh    |  2 +-
 .../009-special-files-for-rootdir/test.sh          |  2 +-
 testsuites-list                                    | 22 +++++++++++++
 94 files changed, 264 insertions(+), 147 deletions(-)
 create mode 100755 tests/export-tests.sh
 create mode 100644 testsuites-list

-- 
2.14.3



