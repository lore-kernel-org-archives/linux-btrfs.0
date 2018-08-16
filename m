Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:55682 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727317AbeHPTsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 15:48:46 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <dsterba@suse.com>
CC: <jbacik@fb.com>, <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv4 0/3] btrfs: remove unneeded variable and if possbile 
Date: Fri, 17 Aug 2018 00:37:12 +0800
Message-ID: <1534437435-51605-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v3->v4:
 -  btrfs_destroy_delayed_refs return value would be actually needed.
    so just remove the unneeded variable "ret" and modify the subject

v2->v3:
 - repost the patches with detailed commit message.

v1->v2:
 - Fix v1 issue that forget to return after remove the variable "ret".

zhong jiang (3):
  btrfs: remove unneeded variable "ret" in btrfs_destroy_delayed_refs
  btrfs: change btrfs_free_reserved_bytes to be void funtion
  btrfs: change btrfs_pin_log_trans to be void function

 fs/btrfs/disk-io.c     | 5 ++---
 fs/btrfs/extent-tree.c | 6 ++----
 fs/btrfs/tree-log.c    | 5 +----
 fs/btrfs/tree-log.h    | 2 +-
 4 files changed, 6 insertions(+), 12 deletions(-)

-- 
1.7.12.4
