Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:28465 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2INGCO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 02:02:14 -0400
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, hugo@carfax.org.uk
Subject: [PATCH] Btrfs-progs: make dump_thread and write_buf usable outside cmds-send.c
Date: Fri, 14 Sep 2012 14:04:19 +0800
Message-Id: <1347602661-7576-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <5052C5A0.4090803@oracle.com>
References: <5052C5A0.4090803@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Developing service cmds needs it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-send.c |   15 +++++++++------
 commands.h  |    8 ++++++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 41ea523..9e94410 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -175,7 +175,7 @@ static void add_clone_source(struct btrfs_send *s, u64 root_id)
 	s->clone_sources[s->clone_sources_count++] = root_id;
 }
 
-static int write_buf(int fd, const void *buf, int size)
+int write_buf(int fd, const void *buf, int size)
 {
 	int ret;
 	int pos = 0;
@@ -202,15 +202,15 @@ out:
 	return ret;
 }
 
-static void *dump_thread(void *arg_)
+void *dump_thread(void *arg_)
 {
 	int ret;
-	struct btrfs_send *s = (struct btrfs_send*)arg_;
+	struct btrfs_dump *d = (struct btrfs_dump*)arg_;
 	char buf[4096];
 	int readed;
 
 	while (1) {
-		readed = read(s->send_fd, buf, sizeof(buf));
+		readed = read(d->from_fd, buf, sizeof(buf));
 		if (readed < 0) {
 			ret = -errno;
 			fprintf(stderr, "ERROR: failed to read stream from "
@@ -221,7 +221,7 @@ static void *dump_thread(void *arg_)
 			ret = 0;
 			goto out;
 		}
-		ret = write_buf(s->dump_fd, buf, readed);
+		ret = write_buf(d->to_fd, buf, readed);
 		if (ret < 0)
 			goto out;
 	}
@@ -241,6 +241,7 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 	pthread_attr_t t_attr;
 	struct btrfs_ioctl_send_args io_send;
 	struct subvol_info *si;
+	struct btrfs_dump dump;
 	void *t_err = NULL;
 	int subvol_fd = -1;
 	int pipefd[2];
@@ -273,10 +274,12 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 
 	io_send.send_fd = pipefd[1];
 	send->send_fd = pipefd[0];
+	dump.from_fd = pipefd[0];
+	dump.to_fd = send->dump_fd;
 
 	if (!ret)
 		ret = pthread_create(&t_read, &t_attr, dump_thread,
-					send);
+					&dump);
 	if (ret) {
 		ret = -ret;
 		fprintf(stderr, "ERROR: thread setup failed: %s\n",
diff --git a/commands.h b/commands.h
index bb6d2dd..c65ba20 100644
--- a/commands.h
+++ b/commands.h
@@ -82,6 +82,14 @@ void help_command_group(const struct cmd_group *grp, int argc, char **argv);
 /* common.c */
 int open_file_or_dir(const char *fname);
 
+/* cmds-send.c */
+int write_buf(int fd, const void *buf, int size);
+void * dump_thread(void *arg_);
+struct btrfs_dump {
+        int from_fd;
+        int to_fd;
+};
+
 extern const struct cmd_group subvolume_cmd_group;
 extern const struct cmd_group filesystem_cmd_group;
 extern const struct cmd_group balance_cmd_group;
-- 
1.7.1

