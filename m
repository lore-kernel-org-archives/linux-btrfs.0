Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:47130 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbeHERTa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Aug 2018 13:19:30 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Remove uneeded variable "err"
Date: Sun, 5 Aug 2018 23:02:48 +0800
Message-ID: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


zhong jiang (3):
  fs/btrfs/disk-io: Remove unneeded variable "err"
  fs/btrfs/extent-tree: remove redudant variable "err"
  fs/btrfs/tree-log: remove the unneeded variable "err"

 fs/btrfs/disk-io.c     | 12 ++++--------
 fs/btrfs/extent-tree.c |  6 ++----
 fs/btrfs/tree-log.c    |  5 +----
 fs/btrfs/tree-log.h    |  2 +-
 4 files changed, 8 insertions(+), 17 deletions(-)

-- 
1.7.12.4

