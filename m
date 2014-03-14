Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:64356 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755659AbaCNXtt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 19:49:49 -0400
Date: Sat, 15 Mar 2014 01:49:45 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: scrub: don't call unlock if pthread_mutex_lock
 fails
Message-ID: <20140314234943.GA28451@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If pthread_mutex_lock fails (rare but fix it anyway), don't call
pthread_mutex_unlock on mutex.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 128537b..ca11fb5 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -776,7 +776,7 @@ static int scrub_write_progress(pthread_mutex_t *m, const char *fsid,
 	ret = pthread_mutex_lock(m);
 	if (ret) {
 		err = -ret;
-		goto out;
+		goto fail;
 	}
 
 	ret = pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &old);
@@ -808,6 +808,7 @@ out:
 	if (ret && !err)
 		err = -ret;
 
+fail:
 	ret = pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, &old);
 	if (ret && !err)
 		err = -ret;
-- 
1.8.5.3

