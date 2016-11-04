Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:36362 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbcKDIeZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Nov 2016 04:34:25 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 05493AC01B9
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Nov 2016 17:34:18 +0900 (JST)
Message-Id: <201611040833.AA00011@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 04 Nov 2016 17:33:58 +0900
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 3/3] btrfs-progs: send: fix handling of -c option
In-Reply-To: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When two or more -c options are specified, cannot find a suitable
parent. So, output stream is bigger than correct one.

[before]
# btrfs send -f /tmp/data1 -c Snap0 -c ../SnapX Snap[12] ../SnapY
At subvol Snap1
At subvol Snap2
At subvol ../SnapY
# ls -l /tmp/data1
-rw------- 1 root root 3153 Oct 19 10:37 /tmp/data1
#

[after]
# btrfs send -f /tmp/data1 -c Snap0 -c ../SnapX Snap[12] ../SnapY
At subvol Snap1
At subvol Snap2
At subvol ../SnapY
# ls -l /tmp/data1
-rw------- 1 root root 1492 Oct 19 10:39 /tmp/data1
#

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
v2: make helper functions
---
 cmds-send.c | 58 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 2a8a697..f831e99 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -411,6 +411,36 @@ out:
 	return ret;
 }
 
+static int set_root_info(struct btrfs_send *s, char *subvol, u64 *root_id)
+{
+	int ret;
+
+	ret = init_root_path(s, subvol);
+	if (ret < 0)
+		goto out;
+
+	ret = get_root_id(s, subvol_strip_mountpoint(s->root_path, subvol),
+		root_id);
+	if (ret < 0) {
+		error("cannot resolve rootid for %s", subvol);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void free_send_info(struct btrfs_send *s)
+{
+	if (s->mnt_fd >= 0) {
+		close(s->mnt_fd);
+		s->mnt_fd = -1;
+	}
+	free(s->root_path);
+	s->root_path = NULL;
+	subvol_uuid_search_finit(&s->sus);
+}
+
 int cmd_send(int argc, char **argv)
 {
 	char *subvol = NULL;
@@ -460,18 +490,10 @@ int cmd_send(int argc, char **argv)
 				goto out;
 			}
 
-			ret = init_root_path(&send, subvol);
+			ret = set_root_info(&send, subvol, &root_id);
 			if (ret < 0)
 				goto out;
 
-			ret = get_root_id(&send,
-				subvol_strip_mountpoint(send.root_path, subvol),
-				&root_id);
-			if (ret < 0) {
-				error("cannot resolve rootid for %s", subvol);
-				goto out;
-			}
-
 			ret = is_subvol_ro(&send, subvol);
 			if (ret < 0)
 				goto out;
@@ -486,15 +508,9 @@ int cmd_send(int argc, char **argv)
 				error("cannot add clone source: %s", strerror(-ret));
 				goto out;
 			}
-			subvol_uuid_search_finit(&send.sus);
 			free(subvol);
 			subvol = NULL;
-			if (send.mnt_fd >= 0) {
-				close(send.mnt_fd);
-				send.mnt_fd = -1;
-			}
-			free(send.root_path);
-			send.root_path = NULL;
+			free_send_info(&send);
 			full_send = 0;
 			break;
 		case 'f':
@@ -651,6 +667,10 @@ int cmd_send(int argc, char **argv)
 		}
 
 		if (!full_send && root_id) {
+			ret = set_root_info(&send, subvol, &root_id);
+			if (ret < 0)
+				goto out;
+
 			ret = find_good_parent(&send, root_id, &parent_root_id);
 			if (ret < 0) {
 				error("parent determination failed for %lld",
@@ -680,6 +700,7 @@ int cmd_send(int argc, char **argv)
 				error("cannot add clone source: %s", strerror(-ret));
 				goto out;
 			}
+			free_send_info(&send);
 		}
 	}
 
@@ -689,10 +710,7 @@ out:
 	free(subvol);
 	free(snapshot_parent);
 	free(send.clone_sources);
-	if (send.mnt_fd >= 0)
-		close(send.mnt_fd);
-	free(send.root_path);
-	subvol_uuid_search_finit(&send.sus);
+	free_send_info(&send);
 	return !!ret;
 }
 
-- 
2.9.3
