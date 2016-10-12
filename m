Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:51736 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753632AbcJLINT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 04:13:19 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 0/5] Btrfs: incremental send, fix serval case for root and gen
Date: Wed, 12 Oct 2016 16:12:45 +0800
Message-Id: <1476259970-1866-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Patch for fix btrfs incremental send. 
These patches base on v4.8.0-rc8

Robbie Ko (5):
  Btrfs: incremental send, fix don't skip root inode in overwrite_ref
  Btrfs: incremental send, add gen for is_waiting_for_rm when some
    corner case
  Btrfs: incremental send, add gen in waiting_dir_move for some corner
    case
  Btrfs: incremental send, add gen check in did_overwrite_ref
  Btrfs: incremental send, add gen check if has waiting_dir_move in the
    will_overwrite_ref

 fs/btrfs/send.c | 50 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 10 deletions(-)

-- 
1.9.1

