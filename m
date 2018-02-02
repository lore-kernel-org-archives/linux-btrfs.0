Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:33627 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751827AbeBBI2E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:28:04 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CEE9149F19B7
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:28:00 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 00/10] btrfs-progs: introduce btrfs rescue undelete-subvol subcommand
Date: Fri, 2 Feb 2018 16:27:41 +0800
Message-ID: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This command will undelete all subvolumes those are still intact on the
device, and all the recovered subvolumes will link with the name "sub<id>"
to the lost+found directory.

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

 Documentation/btrfs-rescue.asciidoc                |   6 +
 Makefile                                           |   3 +-
 btrfs-completion                                   |   2 +-
 cmds-rescue.c                                      |  47 ++++
 convert/main.c                                     |  57 +++++
 ctree.h                                            |   8 +-
 inode.c                                            |  99 +++++----
 .../029-undelete-subvol/deleted_subvolume.img      | Bin 0 -> 4096 bytes
 .../029-undelete-subvol/drop_progress.raw.xz       | Bin 0 -> 23452 bytes
 tests/misc-tests/029-undelete-subvol/test.sh       |  34 +++
 undelete-subvol.c                                  | 244 +++++++++++++++++++++
 undelete-subvol.h                                  |  19 ++
 12 files changed, 472 insertions(+), 47 deletions(-)
 create mode 100644 tests/misc-tests/029-undelete-subvol/deleted_subvolume.img
 create mode 100644 tests/misc-tests/029-undelete-subvol/drop_progress.raw.xz
 create mode 100755 tests/misc-tests/029-undelete-subvol/test.sh
 create mode 100644 undelete-subvol.c
 create mode 100644 undelete-subvol.h

-- 
2.16.1



