Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbcDNG3M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 02:29:12 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 731B9405640D
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 14:26:35 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Restrict e2fsprogs version for new convert
Date: Thu, 14 Apr 2016 14:24:34 +0800
Message-Id: <1460615074-2492-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New btrfs-convert is using a lot of new macro in e2fsprogs 1.42.
Unfortunately the new compatible layer for older e2fsprogs is still
under development.

So restrict e2fsprogs version so far to avoid complier error.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index fc343ea..05fdc32 100644
--- a/configure.ac
+++ b/configure.ac
@@ -105,7 +105,7 @@ AS_IF([test "x$enable_convert" = xyes], [DISABLE_BTRFSCONVERT=0], [DISABLE_BTRFS
 AC_SUBST([DISABLE_BTRFSCONVERT])
 
 if test "x$enable_convert" = xyes; then
-	PKG_CHECK_MODULES(EXT2FS, [ext2fs])
+	PKG_CHECK_MODULES(EXT2FS, [ext2fs >= 1.42])
 	PKG_CHECK_MODULES(COM_ERR, [com_err])
 fi
 
-- 
2.8.0



