Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45920 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751874AbeEGDKn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 23:10:43 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C6CA948AE76D
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 11:10:41 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 00/10] undelete subvolume offline version
Date: Mon, 7 May 2018 11:10:23 +0800
Message-ID: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will add undelete-subvol subcommand for btrfs rescue.

Patchset can be fetched from github:
https://github.com/littleroad/btrfs-progs.git undelete

v2->v3: fixed some issues pointed out by Qu.
v1->v2: add -s option to allow user specify the subvolume which will be
recovered.

The first patch are not modified.
For the rest, please see the changelog in the patches.

Lu Fengqi (10):
  btrfs-progs: copy btrfs_del_orphan_item from kernel
  btrfs-progs: extract btrfs_link_subvol from btrfs_mksubvol
  btrfs-progs: use btrfs_find_free_dir_index to find free inode index
  btrfs-progs: undelete-subvol: introduce is_subvol_intact
  btrfs-progs: undelete-subvol: introduce recover_dead_root
  btrfs-progs: undelete-subvol: introduce link_subvol_to_lostfound
  btrfs-progs: undelete-subvol: introduce btrfs_undelete_subvols
  btrfs-progs: undelete-subvol: add undelete-subvol subcommand
  btrfs-progs: tests: add testcase for undelete-subvol
  btrfs-progs: undelete-subvol: update completion and documentation

 Documentation/btrfs-rescue.asciidoc           |  12 +
 Makefile                                      |   3 +-
 btrfs-completion                              |   2 +-
 cmds-rescue.c                                 |  69 ++++++
 convert/main.c                                |  59 ++++-
 ctree.h                                       |   8 +-
 inode.c                                       | 119 +++++----
 .../031-undelete-subvol/intact_subvolume.img  | Bin 0 -> 4096 bytes
 .../subvolume_in_drop_progress.raw.xz         | Bin 0 -> 23452 bytes
 tests/misc-tests/031-undelete-subvol/test.sh  |  38 +++
 undelete-subvol.c                             | 227 ++++++++++++++++++
 undelete-subvol.h                             |  11 +
 12 files changed, 501 insertions(+), 47 deletions(-)
 create mode 100644 tests/misc-tests/031-undelete-subvol/intact_subvolume.img
 create mode 100644 tests/misc-tests/031-undelete-subvol/subvolume_in_drop_progress.raw.xz
 create mode 100755 tests/misc-tests/031-undelete-subvol/test.sh
 create mode 100644 undelete-subvol.c
 create mode 100644 undelete-subvol.h

-- 
2.17.0



