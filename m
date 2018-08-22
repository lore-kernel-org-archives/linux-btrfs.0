Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33749 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727687AbeHVXSp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 19:18:45 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] rb_first to rb_first_cached conversion
Date: Thu, 23 Aug 2018 03:51:48 +0800
Message-Id: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several structs in btrfs are using rb_first() in a while loop, it'd be
more efficient to do this with rb_first_cached() which has the O(1)
complexity.

This patch set updates five structs which may have a large rb tree in
practice

Liu Bo (5):
  Btrfs: href_root: use rb_first_cached
  Btrfs: href->ref_tree: use rb_first_cached
  Btrfs: delayed_items: use rb_first_cached
  Btrfs: extent_map: use rb_first_cached
  Btrfs: preftree: use rb_first_cached

 fs/btrfs/backref.c                | 34 +++++++++++++-------------
 fs/btrfs/delayed-inode.c          | 29 +++++++++++++----------
 fs/btrfs/delayed-inode.h          |  4 ++--
 fs/btrfs/delayed-ref.c            | 50 +++++++++++++++++++++++----------------
 fs/btrfs/delayed-ref.h            |  4 ++--
 fs/btrfs/disk-io.c                |  8 +++----
 fs/btrfs/extent-tree.c            | 19 ++++++++-------
 fs/btrfs/extent_map.c             | 27 +++++++++++----------
 fs/btrfs/extent_map.h             |  2 +-
 fs/btrfs/inode.c                  |  4 ++--
 fs/btrfs/tests/extent-map-tests.c |  4 ++--
 fs/btrfs/transaction.c            |  5 ++--
 fs/btrfs/volumes.c                |  5 ++--
 13 files changed, 107 insertions(+), 88 deletions(-)

-- 
1.8.3.1
