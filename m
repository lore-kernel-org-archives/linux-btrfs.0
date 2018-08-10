Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725724AbeHJFBz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 01:01:55 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5BE7BABA2
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 02:34:10 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: qgroup: Don't return 1 if qgroup is marked inconsistent during relationship assignment
Date: Fri, 10 Aug 2018 10:34:06 +0800
Message-Id: <20180810023406.30303-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_IOC_QGROUP_ASSIGN ioctl could return >0 if qgroup is marked
inconsistent after successful relationship assignment/removal.

We leak the return value as the final return value of btrfs command.
But according to the man page, return value other than 0 means failure.

Fix this by resetting the return value to 0 for --no-rescan case.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-qgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index b928edc7c408..7234bdc17bb4 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -123,6 +123,7 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
 				error("quota rescan failed: %m");
 		} else {
 			warning("quotas may be inconsistent, rescan needed");
+			ret = 0;
 		}
 	}
 	close_file_or_dir(fd, dirstream);
-- 
2.18.0
