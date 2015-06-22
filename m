Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:6582 "EHLO mail.synology.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbbFVJI4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 05:08:56 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 0/7] Btrfs incremental send fix serval case for rename and rm directory
Date: Mon, 22 Jun 2015 17:08:41 +0800
Message-Id: <1434964128-31757-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch for fix btrfs send receive. These patches base on v4.1
plus following patches.
[PATCH] Btrfs: incremental send, don't delay directory renames unnecessarily
[PATCH] Btrfs: incremental send, check if orphanized dir inode needs delayed rename

Thanks.

Robbie Ko (7):
  Revert "Btrfs: incremental send, remove dead code"
  Btrfs: incremental send, avoid circular waiting and descendant
    overwrite ancestor need to update path
  Btrfs: incremental send, avoid ancestor rename to descendant
  Btrfs: incremental send, fix orphan_dir_info leak
  Btrfs: incremental send, fix rmdir but dir have a unprocess item
  Btrfs: incremental send, don't send utimes for non-existing directory
  Btrfs: incremental send, avoid the overhead of allocating an
    orphan_dir_info object unnecessarily

 fs/btrfs/send.c | 167 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 153 insertions(+), 14 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
