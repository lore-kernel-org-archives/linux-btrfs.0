Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:42814 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752394AbaCYOrM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 10:47:12 -0400
Date: Tue, 25 Mar 2014 16:47:07 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: scrub: disable thread cancelability during
 mutex locks
Message-ID: <20140325144705.GA7499@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

scrub_progress_cycle thread runs in asynchronous type but locks mutex
while reading shared data. This patch disables cancelability for a
brief time while locks are on so as to make sure they are unlocked
before thread is canceled.

scrub_write_progress gets called from scrub_progress_cycle in
asynchronous thread but cancelability is disabled after mutex is
locked. This patch moves the call to set cancelability type before
mutex lock and makes corresponding changes to labels for error
handling.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-scrub.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index d3bd148..4338a0b 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -773,31 +773,31 @@ static int scrub_write_progress(pthread_mutex_t *m, const char *fsid,
 	int fd = -1;
 	int old;
 
-	ret = pthread_mutex_lock(m);
+	ret = pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &old);
 	if (ret) {
 		err = -ret;
-		goto fail;
+		goto out3;
 	}
 
-	ret = pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &old);
+	ret = pthread_mutex_lock(m);
 	if (ret) {
 		err = -ret;
-		goto out;
+		goto out2;
 	}
 
 	fd = scrub_open_file_w(SCRUB_DATA_FILE, fsid, "tmp");
 	if (fd < 0) {
 		err = fd;
-		goto out;
+		goto out1;
 	}
 	err = scrub_write_file(fd, fsid, data, n);
 	if (err)
-		goto out;
+		goto out1;
 	err = scrub_rename_file(SCRUB_DATA_FILE, fsid, "tmp");
 	if (err)
-		goto out;
+		goto out1;
 
-out:
+out1:
 	if (fd >= 0) {
 		ret = close(fd);
 		if (ret)
@@ -808,11 +808,12 @@ out:
 	if (ret && !err)
 		err = -ret;
 
-fail:
+out2:
 	ret = pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, &old);
 	if (ret && !err)
 		err = -ret;
 
+out3:
 	return err;
 }
 
@@ -944,6 +945,10 @@ static void *scrub_progress_cycle(void *ctx)
 			 * result we got for the current write and go
 			 * on. flag should be set on next cycle, then.
 			 */
+			perr = pthread_setcancelstate(
+					PTHREAD_CANCEL_DISABLE, &old);
+			if (perr)
+				goto out;
 			perr = pthread_mutex_lock(&sp_shared->progress_mutex);
 			if (perr)
 				goto out;
@@ -952,12 +957,20 @@ static void *scrub_progress_cycle(void *ctx)
 						&sp_shared->progress_mutex);
 				if (perr)
 					goto out;
+				perr = pthread_setcancelstate(
+						PTHREAD_CANCEL_ENABLE, &old);
+				if (perr)
+					goto out;
 				memcpy(sp, sp_last, sizeof(*sp));
 				continue;
 			}
 			perr = pthread_mutex_unlock(&sp_shared->progress_mutex);
 			if (perr)
 				goto out;
+			perr = pthread_setcancelstate(
+					PTHREAD_CANCEL_ENABLE, &old);
+			if (perr)
+				goto out;
 			memcpy(sp, sp_shared, sizeof(*sp));
 			memcpy(sp_last, sp_shared, sizeof(*sp));
 		}
-- 
1.8.5.3

