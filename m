Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49277 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab3AWIHF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 03:07:05 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 09/10] Btrfs-progs: make get_subvol_name non cmds-send specific
Date: Wed, 23 Jan 2013 16:12:50 +0800
Message-Id: <1358928771-31960-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_subvol_name can be used other than the just with in cmds-send.c
so this patch will make it possible with out changing the original
intentions.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-send.c | 12 ++++++------
 commands.h  |  1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..beebac9 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -331,12 +331,12 @@ out:
 	return ret;
 }
 
-static const char *get_subvol_name(struct btrfs_send *s, const char *full_path)
+char *get_subvol_name(char *mnt, char *full_path)
 {
-	int len = strlen(s->root_path);
+	int len = strlen(mnt);
 	if (!len)
 		return full_path;
-	if (s->root_path[len - 1] != '/')
+	if (mnt[len - 1] != '/')
 		len += 1;
 
 	return full_path + len;
@@ -445,7 +445,7 @@ int cmd_send_start(int argc, char **argv)
 			if (ret < 0)
 				goto out;
 
-			ret = get_root_id(&send, get_subvol_name(&send, subvol),
+			ret = get_root_id(&send, get_subvol_name(send.root_path, subvol),
 					&root_id);
 			if (ret < 0) {
 				fprintf(stderr, "ERROR: could not resolve "
@@ -506,7 +506,7 @@ int cmd_send_start(int argc, char **argv)
 
 	if (snapshot_parent != NULL) {
 		ret = get_root_id(&send,
-				get_subvol_name(&send, snapshot_parent),
+				get_subvol_name(send.root_path, snapshot_parent),
 				&parent_root_id);
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: could not resolve root_id "
@@ -565,7 +565,7 @@ int cmd_send_start(int argc, char **argv)
 			goto out;
 		}
 
-		ret = get_root_id(&send, get_subvol_name(&send, subvol),
+		ret = get_root_id(&send, get_subvol_name(send.root_path, subvol),
 				&root_id);
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: could not resolve root_id "
diff --git a/commands.h b/commands.h
index 9b77f3e..631fb6b 100644
--- a/commands.h
+++ b/commands.h
@@ -106,3 +106,4 @@ int test_issubvolume(char *path);
 
 /* send.c */
 int find_mount_root(const char *path, char **mount_root);
+char *get_subvol_name(char *mnt, char *full_path);
-- 
1.8.1.227.g44fe835

