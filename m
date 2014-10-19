Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27963 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaJSMoM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 08:44:12 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] fstests: fix memory corruption in aio-last-ref-held-by-io
Date: Sun, 19 Oct 2014 20:43:54 +0800
Message-Id: <1413722634-25514-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liub.liubo@gmail.com>

This's been detected by testing generic/323 on btrfs, it keeps producing chaos
of checksum errors.

It is because aio-last-ref-held-by-io uses a static buffer that is been used
repeatedly for every io_submit() call, but we'll issue NUM_IOS(=16) io_sumbit()
in a 'for' loop at a time, and when those data read by aio has not finish its
endio(), its memory is likely to be used in the next io_submit, which ends up
data corruption and numerous checksum errors.

This allocates memory for each io_submit() and generic/323 runs fine after this.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 src/aio-dio-regress/aio-last-ref-held-by-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/aio-dio-regress/aio-last-ref-held-by-io.c b/src/aio-dio-regress/aio-last-ref-held-by-io.c
index a73dc3b..7633831 100644
--- a/src/aio-dio-regress/aio-last-ref-held-by-io.c
+++ b/src/aio-dio-regress/aio-last-ref-held-by-io.c
@@ -109,7 +109,7 @@ aio_test_thread(void *data)
 	ioctx_initted = 0;
 	ios_submitted = 0;
 
-	ret = posix_memalign((void **)&buffer, getpagesize(), IOSIZE);
+	ret = posix_memalign((void **)&buffer, getpagesize(), IOSIZE * NUM_IOS);
 	if (ret != 0) {
 		printf("%lu: Failed to allocate buffer for IO: %d\n",
 		       pthread_self(), ret);
@@ -137,7 +137,7 @@ aio_test_thread(void *data)
 				struct iocb *iocb = &iocbs[i];
 
 				memset(iocb, 0, sizeof(*iocb));
-				io_prep_pread(iocb, fd, buffer,
+				io_prep_pread(iocb, fd, (buffer + i * IOSIZE),
 					      IOSIZE, i * IOSIZE);
 				if (io_submit(ioctx, 1, &iocb) != 1) {
 					printf("%lu: failed to submit io #%d\n",
-- 
1.8.1.4

