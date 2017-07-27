Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751413AbdG0Pqs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 11:46:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01743ACD7
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 15:46:47 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 0/5 v2] btrfs-progs: convert fixes + reiserfs support
Date: Thu, 27 Jul 2017 11:47:18 -0400
Message-Id: <20170727154723.2208-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Changes since v1:
- reiserfs conversion:
  - use bool instead of int
  - catch 'impossible' condition of multiple discontiguous tails
  - properly handle hole followed by tail
  - add testing for combinations of real blocks, tails, and holes
  - print error indicating filename (and key) that caused a failure
  - constify buffer arg to btrfs_insert_inline_extent
  - add tails=on to reiserfs mount options
  - fixed absence of libreiserfscore to be non-fatal unless specificially
    enabled

- btrfs-progs: convert: use search_cache_extent in migrate_one_reserved_range
  - In testing, we would not be able to roll back to part of the 0-1MB range
    not being migrated.

- btrfs-progs: tests: fix typo in convert-tests/008-readonly-image
  - The test used ext2_save instead of ext2_saved as the filename

---

Jeff Mahoney (5):
  btrfs-progs: convert: properly handle reserved ranges while iterating
    files
  btrfs-progs: convert: add missing newlines for printfs
  btrfs-progs: convert: use search_cache_extent in
    migrate_one_reserved_range
  btrfs-progs: tests: fix typo in convert-tests/008-readonly-image
  btrfs-progs: convert: add support for converting reiserfs

 Makefile                                           |    3 +-
 Makefile.inc.in                                    |    3 +-
 configure.ac                                       |   15 +-
 convert/main.c                                     |   21 +-
 convert/source-fs.c                                |   25 +-
 convert/source-reiserfs.c                          | 1015 ++++++++++++++++++++
 convert/source-reiserfs.h                          |  105 ++
 ctree.h                                            |    2 +-
 file-item.c                                        |    2 +-
 tests/common.convert                               |   14 +-
 tests/convert-tests/008-readonly-image/test.sh     |    4 +-
 tests/convert-tests/010-reiserfs-basic/test.sh     |   16 +
 .../011-reiserfs-delete-all-rollback/test.sh       |   67 ++
 .../012-reiserfs-large-hole-extent/test.sh         |   23 +
 .../013-reiserfs-common-inode-flags/test.sh        |   35 +
 .../convert-tests/014-reiserfs-tail-handling/input |    1 +
 .../014-reiserfs-tail-handling/input2              |    1 +
 .../014-reiserfs-tail-handling/test.sh             |   69 ++
 18 files changed, 1391 insertions(+), 30 deletions(-)
 create mode 100644 convert/source-reiserfs.c
 create mode 100644 convert/source-reiserfs.h
 create mode 100755 tests/convert-tests/010-reiserfs-basic/test.sh
 create mode 100755 tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
 create mode 100755 tests/convert-tests/012-reiserfs-large-hole-extent/test.sh
 create mode 100755 tests/convert-tests/013-reiserfs-common-inode-flags/test.sh
 create mode 100644 tests/convert-tests/014-reiserfs-tail-handling/input
 create mode 100644 tests/convert-tests/014-reiserfs-tail-handling/input2
 create mode 100755 tests/convert-tests/014-reiserfs-tail-handling/test.sh

-- 
2.11.0

