Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbdIRHVs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:21:48 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 00/14] Mkfs: Rework --rootdir to a more generic behavior
Date: Mon, 18 Sep 2017 16:21:25 +0900
Message-Id: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/mkfs_rootdir_rework

mkfs.btrfs --rootdir provides user a method to generate btrfs with
pre-written content while without the need of root privilege to mount
the fs.

However the code is quite old and doesn't get much review or test.
This makes some strange behavior, from customized chunk allocation
(which uses the reserved 0~1M device space) to variant BUG_ON caused by
ENOSPC or EPERM.

The reworked --rootdir will be based on traditional mkfs, everything is
processed after traditional mkfs, so nothing is customized.

The result will be an equivalent of mkfs, mount, cp, umount.
(If btrfs-progs chunk/extent allocator acts as the same as kernel)

Also, documentation and test cases (especially test cases) are also
enhanced.
Documentation has extra explanation for the behavior change, and test
cases are following convert tests, testing all possible feature and
nodesize combinations.

Patch 1~6 change the rootdir behavior.
Patch 7 enhances the documentation.
Patch 8~14 enhances the mkfs test cases, with one bug fix exposed by new
test cases.

Changelog:
  v2:
    Follows the "mkfs.ext4 -d" behavior, which will not create the file
    for non-existent destination, nor shrink the fs.
    Add extra explanation for the behavior change.

  v3:
    Make convert tests facility more flex to handle the test pattern of
    "--rootdir".
    Introduce new mkfs test cases to both check file content and error
    handlers.
    Slightly enhance the documentation explanation of --rootdir.
    Since the main change is test case, patch 1~5 are not modified.

Qu Wenruo (14):
  btrfs-progs: Refactor find_next_chunk() to get rid of parameter root
    and objectid
  btrfs-progs: Fix one-byte overlap bug in free_block_group_cache
  btrfs-progs: mkfs: Rework rootdir option to avoid custom chunk layout
  btrfs-progs: mkfs: Update allocation info before verbose output
  btrfs-progs: Avoid BUG_ON for chunk allocation when ENOSPC happens
  btrfs-progs: mkfs: Workaround BUG_ON caused by rootdir option
  btrfs-progs: Doc/mkfs: Add extra condition for rootdir option
  btrfs-progs: tests/common: Split user xattr into its own branch for
    generate_dataset
  btrfs-progs: tests/common: Introduce optional parameter to specify
    destination directory for generate_dataset
  btrfs-progs: tests/common: Make checksum, permission and acl check
    path independent
  btrfs-progs: tests/mkfs: Add basic test case for rootdir parameter
  btrfs-progs: tests/common: Detect ungraceful failure case
  btrfs-progs: mkfs: Fix overwritten return value for mkfs
  btrfs-progs: tests/mkfs: Check error handler for rootdir parameter

 Documentation/mkfs.btrfs.asciidoc                  |  13 +
 extent-tree.c                                      |   5 +-
 mkfs/main.c                                        | 286 ++++++---------------
 tests/common                                       |  17 +-
 tests/common.convert                               |  93 ++++++-
 tests/mkfs-tests/010-basic-rootdir/test.sh         |  78 ++++++
 .../mkfs-tests/011-rootdir-fail-condition/test.sh  |  82 ++++++
 volumes.c                                          |  32 ++-
 8 files changed, 377 insertions(+), 229 deletions(-)
 create mode 100755 tests/mkfs-tests/010-basic-rootdir/test.sh
 create mode 100755 tests/mkfs-tests/011-rootdir-fail-condition/test.sh

-- 
2.14.1

