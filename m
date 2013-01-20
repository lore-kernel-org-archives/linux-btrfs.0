Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:55864 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3ATVEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:39 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210438.XEQF2891.eastrmfepo101.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:38 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Chen Yang <chenyang.fnst@cn.fujitsu.com>, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 04/13] Btrfs-progs: Fix a segmentation fault in btrfstune when <device> is invalid.
Date: Sun, 20 Jan 2013 16:04:09 -0500
Message-Id: <1358715858-4469-5-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Chen Yang <chenyang.fnst@cn.fujitsu.com>

When open_ctree(device, ...) failed, the return value should be checked.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 btrfstune.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 47830c5..07648d5 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -107,6 +107,8 @@ int main(int argc, char *argv[])
 	}
 
 	root = open_ctree(device, 0, 1);
+	if (!root)
+		return 1;
 
 	if (seeding_flag) {
 		ret = update_seeding_flag(root, seeding_value);
-- 
1.8.1

