Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:36936 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964934AbcJ1Bl1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 21:41:27 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 0/6] Btrfs: incremental send, fix serval case for inode 256 and generation
Date: Fri, 28 Oct 2016 09:40:44 +0800
Message-Id: <1477618850-12922-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Patch for fix btrfs incremental send.
These patches base on v4.8.0-rc8

v2:
* Improve the change log
* Add a new patch "add generation check in existence demtermination for
  the parent directory"

Robbie Ko (6):
  Btrfs: incremental send, do not skip generation inconsistency check
    for inode 256.
  Btrfs: incremental send, add generation check for the inode waiting
    for rmdir operation.
  Btrfs: incremental send, add generation for waiting_dir_move struct
    and check it in can_rmdir.
  Btrfs: incremental send, skip check overwritten if parents' generation
    are different
  Btrfs: incremental send, add generation check for inode is waiting for
    move.
  Btrfs: incremental send, add generation check in existence
    demtermination for the parent directory

 fs/btrfs/send.c | 61 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 14 deletions(-)

-- 
1.9.1

