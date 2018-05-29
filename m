Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:11630 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754609AbeE2HCM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 03:02:12 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0F8ED4B41E6E
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 15:02:05 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/2] UUID tree fs_info cleanup
Date: Tue, 29 May 2018 15:01:52 +0800
Message-ID: <20180529070154.20560-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just remove the redundant fs_info argument from uuid_tree functions
because these functions have already taken transaction which has a
reference to the fs_info.

No functional change.

Lu Fengqi (2):
  btrfs: Remove fs_info argument from btrfs_uuid_tree_add
  btrfs: Remove fs_info argument from btrfs_uuid_tree_rem

 fs/btrfs/ctree.h       |  6 ++----
 fs/btrfs/inode.c       |  5 ++---
 fs/btrfs/ioctl.c       |  9 ++++-----
 fs/btrfs/transaction.c |  7 +++----
 fs/btrfs/uuid-tree.c   | 10 +++++-----
 fs/btrfs/volumes.c     |  5 ++---
 6 files changed, 18 insertions(+), 24 deletions(-)

-- 
2.17.0



