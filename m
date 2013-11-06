Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56121 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/16] btrfs-progs: don't leak fd in test_dev_for_mkfs() error paths
Date: Wed,  6 Nov 2013 17:15:44 -0600
Message-Id: <1383779755-18228-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Close fd before we return on error paths.

Resolves-Coverity-CID: 1125939
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/utils.c b/utils.c
index c11a7c2..c784345 100644
--- a/utils.c
+++ b/utils.c
@@ -1905,10 +1905,12 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	if (fstat(fd, &st)) {
 		snprintf(estr, sz, "unable to stat %s: %s\n", file,
 			strerror(errno));
+		close(fd);
 		return 1;
 	}
 	if (!S_ISBLK(st.st_mode)) {
 		fprintf(stderr, "'%s' is not a block device\n", file);
+		close(fd);
 		return 1;
 	}
 	close(fd);
-- 
1.7.1

