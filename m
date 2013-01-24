Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22994 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3AXJ6d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 04:58:33 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, brendan@swiftspirit.co.za
Subject: [PATCH] Btrfs-progs: we need to have the string null terminated
Date: Thu, 24 Jan 2013 18:05:14 +0800
Message-Id: <1359021914-6532-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <50FEEB9E.2060305@swiftspirit.co.za>
References: <50FEEB9E.2060305@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bug:
-------------
btrfs subvolume list / -a
ID 258 gen 4226 top level 384 path media/smbshare
::
btrfs subvolume list /home -a
ID 258 gen 4226 top level 5 path <FS_TREE>/__active/media/smbshare4.snap

In the first command's output, this path is printed correctly, however
in the second output it has "4.snap" appended, similar to the names of
the snapshots I made 22 hours ago.
------------

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reported-by: Brendan Hide <brendan@swiftspirit.co.za>
---
 btrfs-list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-list.c b/btrfs-list.c
index e5f0f96..5acba78 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -633,6 +633,7 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 			len = strlen(full_path);
 			tmp = malloc(len + add_len + 2);
 			memcpy(tmp + add_len + 1, full_path, len);
+			tmp[len + add_len + 1] = '\0';
 			tmp[add_len] = '/';
 			memcpy(tmp, p, add_len);
 			free(full_path);
-- 
1.8.1.227.g44fe835

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
