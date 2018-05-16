Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:61463 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752720AbeEPFrM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 01:47:12 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 3A06EAC020E
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 14:47:04 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 9289D32845B
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 14:47:03 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v5 0/3] btrfs: Add three new unprivileged ioctls to allow normal users to call "sub list/show" etc.
Date: Wed, 16 May 2018 14:49:36 +0900
Message-ID: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[based on current misc-next]

changelog:
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

 fs/btrfs/ioctl.c           | 452 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  84 +++++++++
 2 files changed, 536 insertions(+)

-- 
2.14.3


