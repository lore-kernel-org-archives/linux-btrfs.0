Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56162 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751048AbeC0HHM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:12 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B74EC4D0EFD4
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:06 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 00/10] undelete subvolume offline version
Date: Tue, 27 Mar 2018 15:06:48 +0800
Message-ID: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will add undelete-subvol subcommand for btrfs rescue. This
enhancement allows undeleting a subvolume on an unmounted filesystem.

Patchset can be fetched from github:
https://github.com/littleroad/btrfs-progs.git undelete

v1->v2: add -s option to allow user specify the subvolume which will be
recovered.

The first six patches are not modified.
7th-8th add the -s option to specify subvol_id instead of recovering all
subvolumes.
9th add shell quoting to test script.
10th just add the -s option documentation.

Lu Fengqi (10):
  btrfs-progs: copy btrfs_del_orphan_item from kernel
  btrfs-progs: extract btrfs_link_subvol from btrfs_mksubvol
  btrfs-progs: use btrfs_find_free_dir_index to find free inode index
  btrfs-progs: undelete-subvol: introduce is_subvol_intact
  btrfs-progs: undelete-subvol: introduce recover_dead_root
  btrfs-progs: undelete-subvol: introduce link_subvol_to_lostfound
  btrfs-progs: undelete-subvol: introduce btrfs_undelete_intact_subvols
  btrfs-progs: undelete-subvol: add undelete-subvol subcommand
  btrfs-progs: tests: add testcase for undelete-subvol
  btrfs-progs: undelete-subvol: update completion and documentation

 Documentation/btrfs-rescue.asciidoc                |  12 +
 Makefile                                           |   3 +-
 btrfs-completion                                   |   2 +-
 cmds-rescue.c                                      |  70 ++++++
 convert/main.c                                     |  57 +++++
 ctree.h                                            |   8 +-
 inode.c                                            |  99 ++++----
 .../030-undelete-subvol/deleted_subvolume.img      | Bin 0 -> 4096 bytes
 .../030-undelete-subvol/drop_progress.raw.xz       | Bin 0 -> 23452 bytes
 tests/misc-tests/030-undelete-subvol/test.sh       |  34 +++
 undelete-subvol.c                                  | 254 +++++++++++++++++++++
 undelete-subvol.h                                  |  19 ++
 12 files changed, 511 insertions(+), 47 deletions(-)
 create mode 100644 tests/misc-tests/030-undelete-subvol/deleted_subvolume.img
 create mode 100644 tests/misc-tests/030-undelete-subvol/drop_progress.raw.xz
 create mode 100755 tests/misc-tests/030-undelete-subvol/test.sh
 create mode 100644 undelete-subvol.c
 create mode 100644 undelete-subvol.h

-- 
2.16.2



