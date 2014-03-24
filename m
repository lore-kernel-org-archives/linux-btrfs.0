Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:63850 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936AbaCXJEv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 05:04:51 -0400
Date: Mon, 24 Mar 2014 11:04:47 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: remove unsed pthread attribute objects
Message-ID: <20140324090446.GA15679@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Threads always use default attributes in all tools, so pthread
attribute objects and their initializations are of no use. Just pass
NULL as attr attribute to pthread_create for default attributes.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-scrub.c | 13 ++-----------
 cmds-send.c  |  7 +------
 send-test.c  | 11 +----------
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index ca11fb5..d3bd148 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1086,7 +1086,6 @@ static int scrub_start(int argc, char **argv, int resume)
 	};
 	pthread_t *t_devs = NULL;
 	pthread_t t_prog;
-	pthread_attr_t t_attr;
 	struct scrub_file_record **past_scrubs = NULL;
 	struct scrub_file_record *last_scrub = NULL;
 	char *datafile = strdup(SCRUB_DATA_FILE);
@@ -1221,14 +1220,6 @@ static int scrub_start(int argc, char **argv, int resume)
 		goto out;
 	}
 
-	ret = pthread_attr_init(&t_attr);
-	if (ret) {
-		ERR(!do_quiet, "ERROR: pthread_attr_init failed: %s\n",
-		    strerror(ret));
-		err = 1;
-		goto out;
-	}
-
 	for (i = 0; i < fi_args.num_devices; ++i) {
 		devid = di_args[i].devid;
 		ret = pthread_mutex_init(&sp[i].progress_mutex, NULL);
@@ -1376,7 +1367,7 @@ static int scrub_start(int argc, char **argv, int resume)
 		devid = di_args[i].devid;
 		gettimeofday(&tv, NULL);
 		sp[i].stats.t_start = tv.tv_sec;
-		ret = pthread_create(&t_devs[i], &t_attr,
+		ret = pthread_create(&t_devs[i], NULL,
 					scrub_one_dev, &sp[i]);
 		if (ret) {
 			if (do_print)
@@ -1394,7 +1385,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	spc.write_mutex = &spc_write_mutex;
 	spc.shared_progress = sp;
 	spc.fi = &fi_args;
-	ret = pthread_create(&t_prog, &t_attr, scrub_progress_cycle, &spc);
+	ret = pthread_create(&t_prog, NULL, scrub_progress_cycle, &spc);
 	if (ret) {
 		if (do_print)
 			fprintf(stderr, "ERROR: creating progress thread "
diff --git a/cmds-send.c b/cmds-send.c
index dcb6607..1cd457d 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -240,7 +240,6 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 {
 	int ret;
 	pthread_t t_read;
-	pthread_attr_t t_attr;
 	struct btrfs_ioctl_send_args io_send;
 	void *t_err = NULL;
 	int subvol_fd = -1;
@@ -254,8 +253,6 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		goto out;
 	}
 
-	ret = pthread_attr_init(&t_attr);
-
 	ret = pipe(pipefd);
 	if (ret < 0) {
 		ret = -errno;
@@ -268,7 +265,7 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 	send->send_fd = pipefd[0];
 
 	if (!ret)
-		ret = pthread_create(&t_read, &t_attr, dump_thread,
+		ret = pthread_create(&t_read, NULL, dump_thread,
 					send);
 	if (ret) {
 		ret = -ret;
@@ -317,8 +314,6 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		goto out;
 	}
 
-	pthread_attr_destroy(&t_attr);
-
 	ret = 0;
 
 out:
diff --git a/send-test.c b/send-test.c
index 5f7c311..0e804a2 100644
--- a/send-test.c
+++ b/send-test.c
@@ -371,7 +371,6 @@ int main(int argc, char **argv)
 	int ret = 0;
 	int subvol_fd;
 	pthread_t t_read;
-	pthread_attr_t t_attr;
 	void *t_err = NULL;
 	struct recv_args r;
 
@@ -401,13 +400,6 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	ret = pthread_attr_init(&t_attr);
-	if (ret < 0) {
-		fprintf(stderr, "ERROR: pthread init failed. %s\n",
-			strerror(ret));
-		goto out;
-	}
-
 	ret = pipe(pipefd);
 	if (ret < 0) {
 		ret = errno;
@@ -415,7 +407,7 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	ret = pthread_create(&t_read, &t_attr, process_thread, &r);
+	ret = pthread_create(&t_read, NULL, process_thread, &r);
 	if (ret < 0) {
 		ret = errno;
 		fprintf(stderr, "ERROR: pthread create failed. %s\n",
@@ -452,7 +444,6 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	pthread_attr_destroy(&t_attr);
 out:
 	return !!ret;
 }
-- 
1.8.5.3

