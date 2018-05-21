Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:55951 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbeEUBHJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 May 2018 21:07:09 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 8EB9CAC00B3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 10:07:02 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id A2EDB6923DB
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 10:07:00 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v7 0/3] btrfs: Add three new unprivileged ioctls to allow normal users to call "sub list/show" etc.
Date: Mon, 21 May 2018 10:09:41 +0900
Message-ID: <cover.1526863497.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:
v6 -> v7
  - Rebase to current misc-next again
  - Fix 1st patch where otime is wrongly set instead of ctime
  - Add reviewed-by/tested-by tag
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


