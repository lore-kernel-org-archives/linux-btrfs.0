Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22540 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753614AbeBGJxC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 04:53:02 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 226DF48AE761
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 17:53:00 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: tests common: remove meaningless colon in extract_image()
Date: Wed, 7 Feb 2018 17:57:43 +0800
Message-ID: <20180207095743.28128-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The colon is meaningless so remove it.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 tests/common | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/common b/tests/common
index 8e5d0cde1b7e..7f641a004661 100644
--- a/tests/common
+++ b/tests/common
@@ -331,7 +331,7 @@ extract_image()
 	case "$image" in
 	*.img)
 		rm -f "$image.restored"
-		: ;;
+		;;
 	*.img.xz)
 		xz --decompress --keep "$image" || \
 			_fail "failed to decompress image $image" >&2
-- 
2.16.1



