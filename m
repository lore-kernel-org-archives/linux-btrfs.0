Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:19494 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbeERCws (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 22:52:48 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 802BDAC02E7
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 11:52:44 +0900 (JST)
Received: from G01JPEXCHKW17.g01.fujitsu.local (G01JPEXCHKW17.g01.fujitsu.local [10.0.194.56])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id EA466692440
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 11:52:43 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v6 0/3] btrfs: Add three new unprivileged ioctls to allow normal users to call "sub list/show" etc.
Date: Fri, 18 May 2018 11:54:45 +0900
Message-ID: <cover.1526610386.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:
v5 -> v6
  - Update 1st patch by using btrfs_fs_root_no_name()
  - Return -EUCLEAN when btrfs_next_leaf/next_item() should not fail
  - Add Reviewed-by tag
v4 -> v5
  - Update error handling of 1st/2nd patch. See each log for details
  - Fix misspelling
v3 -> v4
  - call btrfs_next_leaf() after btrfs_search_slot() when the slot
    position exceeds the number of items
  - rebased to current misc-next
v2 -> v3
  - fix kbuild test bot warning
v1 -> v2
  - completely reimplement 1st/2nd ioctl to have user friendly api
  - various cleanup, remove unnecessary goto
===

This adds three new unprivileged ioctls:

1st patch:
  ioctl which returns subvolume information of ROOT_ITEM and ROOT_BACKREF
2nd patch:
  ioctl which returns subvolume information of ROOT_REF (without subvolume name)
3rd patch: 
  user version of ino_lookup ioctl which also performs permission check.

They will be used to implement user version of "subvolume list/show" etc.
in user tools.
See each commit log for more detals.

The implementation of btrfs-progs can be found in the ML titled as follows: 
  [PATCH 0/11] btrfs-progs: Rework of "subvolume list/show" and relax the root privileges of them

Tomohiro Misono (3):
  btrfs: Add unprivileged ioctl which returns subvolume information
  btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
  btrfs: Add unprivileged version of ino_lookup ioctl

 fs/btrfs/ioctl.c           | 431 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  84 +++++++++
 2 files changed, 515 insertions(+)

-- 
2.14.3


