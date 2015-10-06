Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbbJFJjr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Oct 2015 05:39:47 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: subvol sync: fix reversed condition
Date: Tue,  6 Oct 2015 11:38:40 +0200
Message-Id: <1444124320-6132-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my local change to 07cc891d1d9819d5cf0628af555e7727d289cf7b
("btrfs-progs: Simplify all-subvolumn-clean condition for
wait_for_subvolume_cleaning") that reversed the meaning of the variable
dirty -> clean, I made a mistake and broke 'subvol sync' that will not
wait as expected and ends prematurely. Zhao Lei's original patch worked.

CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-subvolume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 82173c0489a9..6f8675657417 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -89,7 +89,7 @@ static int wait_for_subvolume_cleaning(int fd, int count, u64 *ids,
 				clean = 0;
 			}
 		}
-		if (clean == 0)
+		if (clean == 1)
 			break;
 		sleep(sleep_interval);
 	}
-- 
2.1.3

