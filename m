Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.gtisc.gatech.edu ([143.215.130.82]:57343 "EHLO
	mx2.gtisc.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbbCXW0M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 18:26:12 -0400
From: Chengyu Song <csong84@gatech.edu>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, changwoo@gatech.edu, sanidhya@gatech.edu,
        blee@gatech.edu, csong84@gatech.edu
Subject: [PATCH 1/1] btrfs: incorrect handling for fiemap_fill_next_extent return
Date: Tue, 24 Mar 2015 18:12:56 -0400
Message-Id: <1427235176-19381-1-git-send-email-csong84@gatech.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fiemap_fill_next_extent returns 0 on success, -errno on error, 1 if this was
the last extent that will fit in user array. If 1 is returned, the return
value may eventually returned to user space, which should not happen, according
to manpage of ioctl.

Signed-off-by: Chengyu Song <csong84@gatech.edu>
---
 fs/btrfs/extent_io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d688cfe..782f3bc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4514,8 +4514,11 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		}
 		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
 					      em_len, flags);
-		if (ret)
+		if (ret) {
+			if (ret == 1)
+				ret = 0;
 			goto out_free;
+		}
 	}
 out_free:
 	free_extent_map(em);
-- 
2.1.0

