Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3KNNav (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 08:30:51 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 70158A7A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 14:30:50 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: mkfs: extend -O syntax to disable features
Date: Thu, 14 Nov 2013 14:30:45 +0100
Message-Id: <1384435845-8493-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A way of disabling features that are on by default in case it's not
wanted, eg. due to lack of support in the used kernel.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 mkfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index cd0af9ef8b4f..f825e1b6bc2d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1168,7 +1168,11 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
 	int found = 0;
 
 	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
-		if (!strcmp(mkfs_features[i].name, name)) {
+		if (name[0] == '^' &&
+			!strcmp(mkfs_features[i].name, name + 1)) {
+			*flags &= ~ mkfs_features[i].flag;
+			found = 1;
+		} else if (!strcmp(mkfs_features[i].name, name)) {
 			*flags |= mkfs_features[i].flag;
 			found = 1;
 		}
-- 
1.8.4.2

