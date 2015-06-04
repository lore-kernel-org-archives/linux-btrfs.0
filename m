Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:60450 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbbFDL14 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 07:27:56 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 0/5] Btrfs incremental send fix serval case for rename and rm directory
Date: Thu,  4 Jun 2015 19:18:05 +0800
Message-Id: <1433416690-19177-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch for fix btrfs send receive. These patches base on v4.1-rc6-49-g8a7deb3
plus following patches.
[PATCH] Btrfs: incremental send, don't delay directory renames unnecessarily
[PATCH] Btrfs: incremental send, check if orphanized dir inode needs delayed rename

Thanks.

Robbie Ko (5):
  Btrfs: incremental send, avoid circular waiting and descendant
    overwrite ancestor need to update path
  Btrfs: incremental send, avoid ancestor rename to descendant
  Btrfs: incremental send, fix orphan_dir_info not completely cleared
  Btrfs: incremental send, fix rmdir but dir have a unprocess item
  Btrfs: incremental send, fix rmdir not send utimes

 fs/btrfs/send.c | 163 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 149 insertions(+), 14 deletions(-)

-- 
1.9.1

