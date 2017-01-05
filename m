Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:45009 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033254AbdAEI1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 03:27:01 -0500
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v3 0/6] Btrfs: incremental send, fix serval case failure
Date: Thu,  5 Jan 2017 16:24:54 +0800
Message-Id: <1483604700-21017-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Patch for fix btrfs incremental send.
These patches base on v4.8.0-rc8

V3: Improve the change log
V2: Add a new patch "add generation check in existence demtermination for
    the parent directory"

Robbie Ko (6):
  Btrfs: incremental send, fix failure to rename with the name collision
  Btrfs: incremental send, fix invalid path for truncate operations
  Btrfs: incremental send, fix not necessary waiting for rmdir operation
  Btrfs: incremental send, fix invalid path for rmdir operations
  Btrfs: incremental send, fix invalid rename operations
  Btrfs: incremental send, fix invalid utime operations

 fs/btrfs/send.c | 61 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 14 deletions(-)

-- 
1.9.1

