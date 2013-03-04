Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab3CDWpi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 17:45:38 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24MjcAv026205
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 17:45:38 -0500
Message-ID: <51352411.7080601@redhat.com>
Date: Mon, 04 Mar 2013 16:45:37 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/14 V2] btrfs-progs: Error handling in scrub_progress_cycle()
 thread
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com> <1362436804-16766-15-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-15-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

consolidate error handling to ensure that peer_fd
is closed on error paths.  Add a couple comments
to the error handling after the thread is complete.

Note that scrub_progress_cycle returns negative
errnos on any error.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: collect positive / pthread errors in perr & flip
on return if needed

diff --git a/cmds-scrub.c b/cmds-scrub.c
index f73b3c6..748a329 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -840,9 +840,11 @@ static void *progress_one_dev(void *ctx)
 	return NULL;
 }
 
+/* nb: returns a negative errno via ERR_PTR */
 static void *scrub_progress_cycle(void *ctx)
 {
 	int ret;
+	int  perr = 0;	/* positive / pthread error returns */
 	int old;
 	int i;
 	char fsid[37];
@@ -867,9 +869,9 @@ static void *scrub_progress_cycle(void *ctx)
 	struct sockaddr_un peer;
 	socklen_t peer_size = sizeof(peer);
 
-	ret = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
-	if (ret)
-		return ERR_PTR(-ret);
+	perr = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
+	if (perr)
+		goto out;
 
 	uuid_unparse(spc->fi->fsid, fsid);
 
@@ -890,8 +892,10 @@ static void *scrub_progress_cycle(void *ctx)
 
 	while (1) {
 		ret = poll(&accept_poll_fd, 1, 5 * 1000);
-		if (ret == -1)
-			return ERR_PTR(-errno);
+		if (ret == -1) {
+			ret = -errno;
+			goto out;
+		}
 		if (ret)
 			peer_fd = accept(spc->prg_fd, (struct sockaddr *)&peer,
 					 &peer_size);
@@ -909,42 +913,46 @@ static void *scrub_progress_cycle(void *ctx)
 			if (!sp->ret)
 				continue;
 			if (sp->ioctl_errno != ENOTCONN &&
-			    sp->ioctl_errno != ENODEV)
-				return ERR_PTR(-sp->ioctl_errno);
+			    sp->ioctl_errno != ENODEV) {
+				ret = -sp->ioctl_errno;
+				goto out;
+			}
 			/*
 			 * scrub finished or device removed, check the
 			 * finished flag. if unset, just use the last
 			 * result we got for the current write and go
 			 * on. flag should be set on next cycle, then.
 			 */
-			ret = pthread_mutex_lock(&sp_shared->progress_mutex);
-			if (ret)
-				return ERR_PTR(-ret);
+			perr = pthread_mutex_lock(&sp_shared->progress_mutex);
+			if (perr)
+				goto out;
 			if (!sp_shared->stats.finished) {
-				ret = pthread_mutex_unlock(
+				perr = pthread_mutex_unlock(
 						&sp_shared->progress_mutex);
-				if (ret)
-					return ERR_PTR(-ret);
+				if (perr)
+					goto out;
 				memcpy(sp, sp_last, sizeof(*sp));
 				continue;
 			}
-			ret = pthread_mutex_unlock(&sp_shared->progress_mutex);
-			if (ret)
-				return ERR_PTR(-ret);
+			perr = pthread_mutex_unlock(&sp_shared->progress_mutex);
+			if (perr)
+				goto out;
 			memcpy(sp, sp_shared, sizeof(*sp));
 			memcpy(sp_last, sp_shared, sizeof(*sp));
 		}
 		if (peer_fd != -1) {
 			write_poll_fd.fd = peer_fd;
 			ret = poll(&write_poll_fd, 1, 0);
-			if (ret == -1)
-				return ERR_PTR(-errno);
+			if (ret == -1) {
+				ret = -errno;
+				goto out;
+			}
 			if (ret) {
 				ret = scrub_write_file(
 					peer_fd, fsid,
 					&spc->progress[this * ndev], ndev);
 				if (ret)
-					return ERR_PTR(ret);
+					goto out;
 			}
 			close(peer_fd);
 			peer_fd = -1;
@@ -954,8 +962,14 @@ static void *scrub_progress_cycle(void *ctx)
 		ret = scrub_write_progress(spc->write_mutex, fsid,
 					   &spc->progress[this * ndev], ndev);
 		if (ret)
-			return ERR_PTR(ret);
+			goto out;
 	}
+out:
+	if (peer_fd != -1)
+		close(peer_fd);
+	if (perr)
+		ret = -perr;
+	return ERR_PTR(ret);
 }
 
 static struct scrub_file_record *last_dev_scrub(
@@ -1373,11 +1387,14 @@ static int scrub_start(int argc, char **argv, int resume)
 	ret = pthread_cancel(t_prog);
 	if (!ret)
 		ret = pthread_join(t_prog, &terr);
+
+	/* check for errors from the handling of the progress thread */
 	if (do_print && ret) {
-		fprintf(stderr, "ERROR: progress thead handling failed: %s\n",
+		fprintf(stderr, "ERROR: progress thread handling failed: %s\n",
 			strerror(ret));
 	}
 
+	/* check for errors returned from the progress thread itself */
 	if (do_print && terr && terr != PTHREAD_CANCELED) {
 		fprintf(stderr, "ERROR: recording progress "
 			"failed: %s\n", strerror(-PTR_ERR(terr)));

