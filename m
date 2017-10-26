Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:43550 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdJZH2z (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 26 Oct 2017 03:28:55 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: convert: Open the fs readonly for rollback
Date: Thu, 26 Oct 2017 15:28:37 +0800
Message-Id: <20171026072837.27460-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For rollback, we only needs to open the fs to check if it meets the
condition to rollback.
And this RW read makes us failed to rollback btrfs with v2 space cache.

In fact, we don't even start a transaction during rollback.

So open the fs RO for rollback, to avoid v2 space cache problem.

Reported-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/convert/main.c b/convert/main.c
index 882daf7ced53..3ec10f233915 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1529,7 +1529,13 @@ static int do_rollback(const char *devname)
 		goto free_mem;
 	}
 	fsize = lseek(fd, 0, SEEK_END);
-	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
+
+	/*
+	 * For rollback, we don't really need write anything into btrfs,
+	 * so open it RO.
+	 * The write part will happen after we close the btrfs.
+	 */
+	root = open_ctree_fd(fd, devname, 0, 0);
 	if (!root) {
 		error("unable to open ctree");
 		ret = -EIO;
-- 
2.14.3

