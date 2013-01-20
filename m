Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:47737 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3ATVEm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:42 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210441.TZNC21186.eastrmfepo203.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:41 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 11/13] Btrfs-progs: check the relation of two group by real level numbers
Date: Sun, 20 Jan 2013 16:04:16 -0500
Message-Id: <1358715858-4469-12-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Comparing qgroupid is not good way to check the relationship of two groups,
the right way is to compare the real level numbers.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index c4122bf..70019d0 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -50,7 +50,7 @@ static int qgroup_assign(int assign, int argc, char **argv)
 	/*
 	 * FIXME src should accept subvol path
 	 */
-	if (args.src >= args.dst) {
+	if ((args.src >> 48) >= (args.dst >> 48)) {
 		fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
 		return 12;
 	}
-- 
1.8.1

