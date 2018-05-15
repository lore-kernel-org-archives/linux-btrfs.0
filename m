Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33411 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753614AbeEORwW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 13:52:22 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/6] btrfs_search_slot cleanups
Date: Wed, 16 May 2018 01:52:02 +0800
Message-Id: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These're the cleanups I made for btrfs_search_slot() and its callees.

Liu Bo (6):
  Btrfs: remove superfluous free_extent_buffer
  Btrfs: use more straightforward extent_buffer_uptodate
  Btrfs: move get root of btrfs_search_slot to a helper
  Btrfs: remove unused check of skip_locking
  Btrfs: grab write lock directly if write_lock_level is the max level
  Btrfs: remove always true check in unlock_up

 fs/btrfs/ctree.c | 118 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 70 insertions(+), 48 deletions(-)

-- 
1.8.3.1

