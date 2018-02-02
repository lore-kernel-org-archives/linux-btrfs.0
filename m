Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56066 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750795AbeBBIeW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:34:22 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <quwenruo.btrfs@gmx.com>
Subject: [RFC PATCH v2 0/4] Add support for export testsuits
Date: Fri, 2 Feb 2018 16:34:01 +0800
Message-ID: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Achieved:
1. export testsuit by:
 $ make EXPORT=/where/you/want/to/generate/tests.tar.gz package
relative path and absolute path both be ok.
Besides tests itself, fssum and btrfs-corrupt-block will also be
included in tests.tar.gz, since misc and fsck tests depend on
btrfs-corrupt-block, and misc tests depend on fssum. 

2. after decompress tests.tar.gz, run test by:
 $ TEST=`MASK` ./mkfs-tests.sh
and, without MASK also be ok.
replenish:
The directory Structure after decompress tests.tar.gz is:
 $ tar -xzvf ./tests.tar.gz
 $ ls
   tests fssum btrfs-corrupt-block

Gu Jinxiang (4):
  btrfs-progs: Add package command for packaging tests
  btrfs-progs: Add EXEC represent path of executable file
  btrfs-progs: Modify rootdir files when use mkfs.btrfs
  btrfs-progs: Add readme for export testsuits

 Makefile                                           |  4 ++
 tests/README.md                                    | 20 ++++++++
 tests/cli-tests.sh                                 |  5 ++
 tests/cli-tests/001-btrfs/test.sh                  | 20 ++++----
 .../cli-tests/002-balance-full-no-filters/test.sh  | 10 ++--
 tests/cli-tests/003-fi-resize-args/test.sh         | 30 +++++------
 .../cli-tests/004-send-parent-multi-subvol/test.sh | 12 ++---
 tests/cli-tests/005-qgroup-show/test.sh            | 14 ++---
 tests/cli-tests/006-qgroup-show-sync/test.sh       | 14 ++---
 tests/cli-tests/007-check-force/test.sh            | 14 ++---
 .../008-subvolume-get-set-default/test.sh          | 20 ++++----
 tests/common                                       | 16 +++---
 tests/common.convert                               |  8 +--
 tests/convert-tests.sh                             |  5 ++
 .../004-ext2-backup-superblock-ranges/test.sh      | 10 ++--
 .../convert-tests/005-delete-all-rollback/test.sh  |  2 +-
 .../007-unsupported-block-sizes/test.sh            |  2 +-
 .../011-reiserfs-delete-all-rollback/test.sh       |  2 +-
 .../015-no-rollback-after-balance/test.sh          |  6 +--
 tests/export-tests.sh                              | 28 ++++++++++
 tests/fsck-tests.sh                                |  5 ++
 tests/fsck-tests/012-leaf-corruption/test.sh       |  2 +-
 tests/fsck-tests/013-extent-tree-rebuild/test.sh   | 12 ++---
 tests/fsck-tests/018-leaf-crossing-stripes/test.sh |  2 +-
 .../fsck-tests/019-non-skinny-false-alert/test.sh  |  2 +-
 tests/fsck-tests/020-extent-ref-cases/test.sh      |  2 +-
 .../021-partially-dropped-snapshot-case/test.sh    |  2 +-
 tests/fsck-tests/022-qgroup-rescan-halfway/test.sh |  2 +-
 tests/fsck-tests/023-qgroup-stack-overflow/test.sh |  2 +-
 tests/fsck-tests/024-clear-space-cache/test.sh     | 10 ++--
 tests/fsck-tests/025-file-extents/test.sh          | 14 ++---
 tests/fsck-tests/026-bad-dir-item-name/test.sh     |  2 +-
 tests/fsck-tests/027-tree-reloc-tree/test.sh       |  2 +-
 .../028-unaligned-super-dev-sizes/test.sh          |  6 +--
 tests/fuzz-tests.sh                                |  5 ++
 .../fuzz-tests/001-simple-check-unmounted/test.sh  |  2 +-
 tests/fuzz-tests/002-simple-image/test.sh          |  2 +-
 tests/fuzz-tests/003-multi-check-unmounted/test.sh | 12 ++---
 tests/fuzz-tests/004-simple-dump-tree/test.sh      |  2 +-
 tests/fuzz-tests/005-simple-dump-super/test.sh     |  4 +-
 tests/fuzz-tests/006-simple-tree-stats/test.sh     |  2 +-
 tests/fuzz-tests/007-simple-super-recover/test.sh  |  2 +-
 tests/fuzz-tests/008-simple-chunk-recover/test.sh  |  2 +-
 tests/fuzz-tests/009-simple-zero-log/test.sh       |  2 +-
 tests/misc-tests.sh                                |  5 ++
 tests/misc-tests/001-btrfstune-features/test.sh    | 10 ++--
 tests/misc-tests/002-uuid-rewrite/test.sh          | 24 ++++-----
 tests/misc-tests/003-zero-log/test.sh              | 18 +++----
 tests/misc-tests/004-shrink-fs/test.sh             | 14 ++---
 .../005-convert-progress-thread-crash/test.sh      |  2 +-
 .../misc-tests/006-image-on-missing-device/test.sh | 10 ++--
 tests/misc-tests/007-subvolume-sync/test.sh        | 18 +++----
 tests/misc-tests/008-leaf-crossing-stripes/test.sh |  4 +-
 .../009-subvolume-sync-must-wait/test.sh           | 22 ++++----
 .../010-convert-delete-ext2-subvol/test.sh         | 10 ++--
 tests/misc-tests/011-delete-missing-device/test.sh | 18 +++----
 tests/misc-tests/012-find-root-no-result/test.sh   |  4 +-
 tests/misc-tests/013-subvolume-sync-crash/test.sh  | 20 ++++----
 tests/misc-tests/014-filesystem-label/test.sh      | 22 ++++----
 tests/misc-tests/015-dump-super-garbage/test.sh    | 18 +++----
 tests/misc-tests/016-send-clone-src/test.sh        | 12 ++---
 .../017-recv-stream-malformatted/test.sh           |  8 +--
 tests/misc-tests/018-recv-end-of-stream/test.sh    | 60 +++++++++++-----------
 .../019-receive-clones-on-mounted-subvol/test.sh   | 38 +++++++-------
 .../020-fix-superblock-corruption/test.sh          |  8 +--
 tests/misc-tests/021-image-multi-devices/test.sh   |  6 +--
 .../022-filesystem-du-on-empty-subvol/test.sh      | 12 ++---
 .../023-device-usage-with-missing-device/test.sh   | 10 ++--
 .../misc-tests/024-inspect-internal-rootid/test.sh | 24 ++++-----
 tests/misc-tests/025-zstd-compression/test.sh      |  6 +--
 .../026-image-non-printable-chars/test.sh          |  8 +--
 .../027-subvol-list-deleted-toplevel/test.sh       |  6 +--
 tests/mkfs-tests.sh                                |  5 ++
 tests/mkfs-tests/001-basic-profiles/test.sh        | 12 ++---
 .../002-no-force-mixed-on-small-volume/test.sh     |  2 +-
 .../003-mixed-with-wrong-nodesize/test.sh          |  2 +-
 tests/mkfs-tests/004-rootdir-keeps-size/test.sh    |  4 +-
 .../005-long-device-name-for-ssd/test.sh           |  4 +-
 tests/mkfs-tests/006-partitioned-loopdev/test.sh   |  4 +-
 .../mkfs-tests/007-mix-nodesize-sectorsize/test.sh |  6 +--
 .../008-sectorsize-nodesize-combination/test.sh    |  4 +-
 .../009-special-files-for-rootdir/test.sh          |  4 +-
 82 files changed, 446 insertions(+), 360 deletions(-)
 create mode 100755 tests/export-tests.sh

-- 
2.14.3



