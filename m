Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2FMHj5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 03:39:57 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] E2fsprogs: add missing usage for No_COW
Date: Wed, 13 Jun 2012 15:47:13 +0800
Message-Id: <1339573633-31023-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the missing usage for No_COW since we've supported No_COW flag.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 misc/chattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/chattr.c b/misc/chattr.c
index 141ea6e..24254cc 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -83,7 +83,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AacDdeijsSu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=AacDdeijsSuC] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
-- 
1.6.5.2

