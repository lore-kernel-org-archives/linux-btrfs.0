Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3GIQj0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jul 2013 12:39:26 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AE5A2A51FE
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jul 2013 18:39:25 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: use reentrant localtime
Date: Tue,  9 Jul 2013 18:39:24 +0200
Message-Id: <1373387964-31043-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

localtime may return NULL (when an error is detected eg. after setting
tzname), followed by a segfault when the values is about to be used.
localtime_r works, does not set tzname and does not return NULL.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-list.c     | 10 ++++++----
 cmds-subvolume.c | 10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index c3d35de..7fcee19 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1344,10 +1344,12 @@ static void print_subvolume_column(struct root_info *subv,
 		printf("%llu", subv->top_id);
 		break;
 	case BTRFS_LIST_OTIME:
-		if (subv->otime)
-			strftime(tstr, 256, "%Y-%m-%d %X",
-				 localtime(&subv->otime));
-		else
+		if (subv->otime) {
+			struct tm tm;
+
+			localtime_r(&subv->otime, &tm);
+			strftime(tstr, 256, "%Y-%m-%d %X", &tm);
+		} else
 			strcpy(tstr, "-");
 		printf("%s", tstr);
 		break;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ccb4762..faf05ca 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -898,10 +898,12 @@ static int cmd_subvol_show(int argc, char **argv)
 		uuid_unparse(get_ri.puuid, uuidparse);
 	printf("\tParent uuid: \t\t%s\n", uuidparse);
 
-	if (get_ri.otime)
-		strftime(tstr, 256, "%Y-%m-%d %X",
-			 localtime(&get_ri.otime));
-	else
+	if (get_ri.otime) {
+		struct tm tm;
+
+		localtime_r(&get_ri.otime, &tm);
+		strftime(tstr, 256, "%Y-%m-%d %X", &tm);
+	} else
 		strcpy(tstr, "-");
 	printf("\tCreation time: \t\t%s\n", tstr);
 
-- 
1.8.2

