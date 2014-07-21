Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21660 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaGUI7j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 04:59:39 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@gmail.com, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: check if there is required kernel send stream version
Date: Mon, 21 Jul 2014 17:03:01 +0800
Message-Id: <1405933381-21365-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When kernel does not have the send stream version 2 patches,
the btrfs send with --stream-version 2 would fail with out
giving the details what is wrong. This patch will help to
identify correctly that required kernel patches are missing.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-send.c | 13 +++++++++++++
 send.h      |  2 ++
 utils.c     | 17 +++++++++++++++++
 utils.h     |  1 +
 4 files changed, 33 insertions(+)

diff --git a/cmds-send.c b/cmds-send.c
index 9a73b32..0c20a6f 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -435,6 +435,7 @@ int cmd_send(int argc, char **argv)
 	u64 parent_root_id = 0;
 	int full_send = 1;
 	int new_end_cmd_semantic = 0;
+	int k_sstream;
 
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
@@ -544,6 +545,18 @@ int cmd_send(int argc, char **argv)
 				ret = 1;
 				goto out;
 			}
+
+			/* check if btrfs kernel supports send stream ver 2 */
+			if (g_stream_version > BTRFS_SEND_STREAM_VERSION_1) {
+				k_sstream = btrfs_read_sysfs(BTRFS_SEND_STREAM_VER_PATH);
+				if (k_sstream < g_stream_version) {
+					fprintf(stderr,
+					"ERROR: Need btrfs kernel send stream version %d or above, %d\n",
+					BTRFS_SEND_STREAM_VERSION_2, k_sstream);
+					ret = 1;
+					goto out;
+				}
+			}
 			break;
 		case 's':
 			g_total_data_size = 1;
diff --git a/send.h b/send.h
index ea56965..d7a171b 100644
--- a/send.h
+++ b/send.h
@@ -24,6 +24,8 @@ extern "C" {
 #endif
 
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
+#define BTRFS_SEND_STREAM_VER_PATH "/sys/fs/btrfs/send/stream_version"
+
 #define BTRFS_SEND_STREAM_VERSION_1 1
 #define BTRFS_SEND_STREAM_VERSION_2 2
 /* Max supported stream version. */
diff --git a/utils.c b/utils.c
index e144dfd..e3d4fa2 100644
--- a/utils.c
+++ b/utils.c
@@ -2681,3 +2681,20 @@ int fsid_to_mntpt(__u8 *fsid, char *mntpt, int *mnt_cnt)
 
 	return ret;
 }
+
+int btrfs_read_sysfs(char path[PATH_MAX])
+{
+	int fd;
+	char val;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	if (read(fd, &val, sizeof(char)) < sizeof(char)) {
+		close(fd);
+		return -EINVAL;
+	}
+	close(fd);
+	return atoi((const char *)&val);
+}
diff --git a/utils.h b/utils.h
index ddf31cf..0c9b65f 100644
--- a/utils.h
+++ b/utils.h
@@ -153,5 +153,6 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
 	return 2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE +
 		    btrfs_min_global_blk_rsv_size(leafsize));
 }
+int btrfs_read_sysfs(char path[PATH_MAX]);
 
 #endif
-- 
2.0.0.153.g79dcccc

