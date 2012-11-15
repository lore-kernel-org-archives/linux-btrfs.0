Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.clear-code.com ([219.94.234.64]:45975 "EHLO
	mail.clear-code.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992602Ab2KOE6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 23:58:17 -0500
From: Kenji Okimoto <okimoto@clear-code.com>
To: linux-btrfs@vger.kernel.org
Cc: Kenji Okimoto <okimoto@clear-code.com>
Subject: [PATCH 2/3] btrfs-progs: check malloc() result
Date: Thu, 15 Nov 2012 13:47:51 +0900
Message-Id: <1352954872-13770-3-git-send-email-okimoto@clear-code.com>
In-Reply-To: <1352954872-13770-1-git-send-email-okimoto@clear-code.com>
References: <1352954872-13770-1-git-send-email-okimoto@clear-code.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Kenji Okimoto <okimoto@clear-code.com>
---
 disk-io.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 32f45dc..c4d4631 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -458,6 +458,9 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 	u64 blocknr = btrfs_super_log_root(disk_super);
 	struct btrfs_root *log_root = malloc(sizeof(struct btrfs_root));
 
+	if (!log_root)
+		return -ENOMEM;
+
 	if (blocknr == 0) {
 		free(log_root);
 		return 0;
-- 
1.7.10.4

