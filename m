Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10655 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754979AbdCUBF4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 21:05:56 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: convert: Add missing return for HOLE mode when checking convert image
Date: Tue, 21 Mar 2017 09:00:55 +0800
Message-ID: <20170321010055.28530-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In check_convert_image(), for normal HOLE case, if the file extents are
smaller than image size, we set ret to -EINVAL and print error message.

But forget to return.

This patch adds the missing return to fix it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/convert/main.c b/convert/main.c
index 96358c62..c56382e9 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1559,6 +1559,7 @@ next:
 			ret = -EINVAL;
 			error("inode %llu has some file extents not checked",
 				ino);
+			return ret;
 		}
 	}
 
-- 
2.12.0



