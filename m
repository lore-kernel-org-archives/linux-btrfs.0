Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:43994 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751844AbeERDAk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 23:00:40 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 0/6] btrfs_search_slot cleanups
Date: Fri, 18 May 2018 11:00:18 +0800
Message-Id: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are a collection of patches I did for btrfs_search_slot().

v2: more explicit commit log for each patch.

Liu Bo (6):
  Btrfs: remove superfluous free_extent_buffer
  Btrfs: use more straightforward extent_buffer_uptodate
  Btrfs: move get root of btrfs_search_slot to a helper
  Btrfs: remove unused check of skip_locking
  Btrfs: grab write lock directly if write_lock_level is the max level
  Btrfs: remove always true check in unlock_up

 fs/btrfs/ctree.c | 121 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 73 insertions(+), 48 deletions(-)

-- 
1.8.3.1

