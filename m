Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:37506 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbbJBQuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 12:50:04 -0400
From: axel@tty0.ch
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [PATCH 2/4] btrfs-progs: add "flags" column for subvolume list (shows "readonly" flag with -A)
Date: Fri,  2 Oct 2015 18:41:21 +0200
Message-Id: <1443804083-876-3-git-send-email-axel@tty0.ch>
In-Reply-To: <1443804083-876-1-git-send-email-axel@tty0.ch>
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 btrfs-list.c | 14 ++++++++++++++
 btrfs-list.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/btrfs-list.c b/btrfs-list.c
index 7529e11..ff337f9 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -80,6 +80,11 @@ static struct {
 		.need_print	= 0,
 	},
 	{
+		.name		= "flags",
+		.column_name	= "Flags",
+		.need_print	= 0,
+	},
+	{
 		.name		= "parent_uuid",
 		.column_name	= "Parent UUID",
 		.need_print	= 0,
@@ -1388,6 +1393,15 @@ static void print_subvolume_column(struct root_info *subv,
 			uuid_unparse(subv->ruuid, uuidparse);
 		printf("%s", uuidparse);
 		break;
+	case BTRFS_LIST_FLAGS:
+		if (subv->flags == 0) {
+			printf("-");
+		} else {
+			/* comma-separated list of all available flags */
+			if(subv->flags & BTRFS_ROOT_SUBVOL_RDONLY)
+				printf("readonly");
+		}
+		break;
 	case BTRFS_LIST_PATH:
 		BUG_ON(!subv->full_path);
 		printf("%s", subv->full_path);
diff --git a/btrfs-list.h b/btrfs-list.h
index 13f44c3..397eb3e 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -119,6 +119,7 @@ enum btrfs_list_column_enum {
 	BTRFS_LIST_PARENT,
 	BTRFS_LIST_TOP_LEVEL,
 	BTRFS_LIST_OTIME,
+	BTRFS_LIST_FLAGS,
 	BTRFS_LIST_PUUID,
 	BTRFS_LIST_RUUID,
 	BTRFS_LIST_UUID,
-- 
2.4.9

