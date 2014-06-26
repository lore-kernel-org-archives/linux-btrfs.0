Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40402 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755828AbaFZC6b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 22:58:31 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5Q2wSnL027090
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 10:58:28 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/6] btrfs-progs: deal with malloc failure in btrfs-image
Date: Thu, 26 Jun 2014 10:53:02 +0800
Message-ID: <1403751186-31559-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Handle the malloc failure for dump_worker in the same way as
the restore worker.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index c90bca8..7131001 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -107,6 +107,8 @@ struct metadump_struct {
 	int done;
 	int data;
 	int sanitize_names;
+
+	int error;
 };
 
 struct name {
@@ -602,6 +604,14 @@ static void *dump_worker(void *data)
 
 			async->bufsize = compressBound(async->size);
 			async->buffer = malloc(async->bufsize);
+			if (!async->buffer) {
+				fprintf(stderr, "Error allocing buffer\n");
+				pthread_mutex_lock(&md->mutex);
+				if (!md->error)
+					md->error = -ENOMEM;
+				pthread_mutex_unlock(&md->mutex);
+				pthread_exit(NULL);
+			}
 
 			ret = compress2(async->buffer,
 					 (unsigned long *)&async->bufsize,
@@ -736,7 +746,7 @@ static int write_buffers(struct metadump_struct *md, u64 *next)
 		goto out;
 
 	/* wait until all buffers are compressed */
-	while (md->num_items > md->num_ready) {
+	while (!err && md->num_items > md->num_ready) {
 		struct timespec ts = {
 			.tv_sec = 0,
 			.tv_nsec = 10000000,
@@ -744,6 +754,13 @@ static int write_buffers(struct metadump_struct *md, u64 *next)
 		pthread_mutex_unlock(&md->mutex);
 		nanosleep(&ts, NULL);
 		pthread_mutex_lock(&md->mutex);
+		err = md->error;
+	}
+
+	if (err) {
+		fprintf(stderr, "One of the threads errored out %s\n",
+				strerror(err));
+		goto out;
 	}
 
 	/* setup and write index block */
-- 
1.8.1.4

