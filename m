Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:59164 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932484Ab3CDVkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/14] btrfs-progs: close fd on do_convert error returns
Date: Mon,  4 Mar 2013 16:39:52 -0600
Message-Id: <1362436804-16766-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

stops an fd leak that Coverity found.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 convert.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/convert.c b/convert.c
index 2b3f42f..4a75895 100644
--- a/convert.c
+++ b/convert.c
@@ -2277,7 +2277,8 @@ err:
 
 int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 {
-	int i, fd, ret;
+	int i, ret;
+	int fd = -1;
 	u32 blocksize;
 	u64 blocks[7];
 	u64 total_bytes;
@@ -2407,6 +2408,8 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 	printf("conversion complete.\n");
 	return 0;
 fail:
+	if (fd != -1)
+		close(fd);
 	fprintf(stderr, "conversion aborted.\n");
 	return -1;
 }
-- 
1.7.1

