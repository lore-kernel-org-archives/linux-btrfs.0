Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:41463 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3ATVEn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:43 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210442.OLRR7113.eastrmfepo102.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:42 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 12/13] Btrfs-progs: disable qgroupid 0 for quota_tree
Date: Sun, 20 Jan 2013 16:04:17 -0500
Message-Id: <1358715858-4469-13-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

In kernel, qgroupid 0 is a special number when we run the quota group limit command.

So, we should not be able to create a quota group whose id is 0, otherwise the kernel
can't deal with it. Fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-qgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 70019d0..dfff1b9 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -86,6 +86,10 @@ static int qgroup_create(int create, int argc, char **argv)
 	args.create = create;
 	args.qgroupid = parse_qgroupid(argv[1]);
 
+	if (!args.qgroupid) {
+		fprintf(stderr, "ERROR: qgroup 0 is not supported\n");
+		return 30;
+	}
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-- 
1.8.1

