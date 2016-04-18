Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36890 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbcDRC3t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 22:29:49 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, mfasheh@suse.de
Subject: [PATCH 2/3] btrfs-progs: Fix an extent buffer leak in qgroups check
Date: Mon, 18 Apr 2016 10:27:08 +0800
Message-Id: <1460946429-578-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1460946429-578-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1460946429-578-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qgroup verify codes will read fs root to check if the subvolume exists.
But it forgot to free the extent buffer read out, only freeing the
memory.

Fix it by also freeing the extent buffers.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 qgroup-verify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index c4e9201..48e4d22 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -761,7 +761,7 @@ static int load_quota_info(struct btrfs_fs_info *info)
 			tmproot = btrfs_read_fs_root_no_cache(info, &root_key);
 			if (tmproot && !IS_ERR(tmproot)) {
 				count->subvol_exists = 1;
-				free(tmproot);
+				btrfs_free_fs_root(tmproot);
 			}
 		}
 
-- 
2.8.0



