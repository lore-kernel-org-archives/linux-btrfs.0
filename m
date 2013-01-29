Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22462 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3A2Gmw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:42:52 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 09/12] Btrfs-progs: make get_subvol_name non cmds-send specific
Date: Tue, 29 Jan 2013 14:48:58 +0800
Message-Id: <1359442141-25498-10-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1359442141-25498-1-git-send-email-anand.jain@oracle.com>

get_subvol_name can be used other than the just with in cmds-send.c
so this patch will make it possible with out changing the original
intentions.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-send.c | 12 ++++++------
 commands.h  |  1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index ac1d3cf..0416b79 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -333,12 +333,12 @@ out:
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
@@ -452,7 +452,7 @@ int cmd_send_start(int argc, char **argv)
 			if (ret < 0)
 				goto out;
 
-			ret = get_root_id(&send, get_subvol_name(&send, subvol),
+			ret = get_root_id(&send, get_subvol_name(send.root_path, subvol),
 					&root_id);
 			if (ret < 0) {
 				fprintf(stderr, "ERROR: could not resolve "
@@ -513,7 +513,7 @@ int cmd_send_start(int argc, char **argv)
 
 	if (snapshot_parent != NULL) {
 		ret = get_root_id(&send,
-				get_subvol_name(&send, snapshot_parent),
+				get_subvol_name(send.root_path, snapshot_parent),
 				&parent_root_id);
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: could not resolve root_id "
@@ -572,7 +572,7 @@ int cmd_send_start(int argc, char **argv)
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

