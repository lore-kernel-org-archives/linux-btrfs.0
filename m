Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:43272 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754341AbeEHKLv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 06:11:51 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 0/2] btrfs :incremental send, improve rmdir performance
Date: Tue,  8 May 2018 18:11:36 +0800
Message-Id: <1525774298-6919-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

The following patch is to improve the btrfs send, the speed of large
directory deletion.

1. Optimization, avoid unnecessary allocations.

2. Increase the speed of can_rmdir.

Robbie Ko (2):
  btrfs: incremental send, optimization add orphan_dir_info
  btrfs: incremental send, improve rmdir performance for large directory

 fs/btrfs/send.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

-- 
1.9.1

