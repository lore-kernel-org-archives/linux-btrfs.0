Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:33309 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727081AbeHHQTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 12:19:34 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 0/3] change some function to be void function
Date: Wed, 8 Aug 2018 21:47:52 +0800
Message-ID: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v3->v2:
 - Repost the patches with detailed changelog.
v1->v2:
 - Fix v1 issue that forget to return after remove the variable "ret".

zhong jiang (3):
  fs/btrfs/disk-io: change btrfs_destroy_delayed_refs to be void
    function
  fs/btrfs/extent-tree: change btrfs_free_reserved_bytes to be void
    funtion
  fs/btrfs/tree-log: change btrfs_pin_log_trans to be void function

 fs/btrfs/disk-io.c     | 13 +++++--------
 fs/btrfs/extent-tree.c |  6 ++----
 fs/btrfs/tree-log.c    |  5 +----
 fs/btrfs/tree-log.h    |  2 +-
 4 files changed, 9 insertions(+), 17 deletions(-)

-- 
1.7.12.4

