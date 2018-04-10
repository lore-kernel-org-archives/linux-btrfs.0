Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45896 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751652AbeDJDe4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 23:34:56 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id A51A94D0EFD1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 11:34:49 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: remove meaningless field write of scrub status file
Date: Tue, 10 Apr 2018 11:31:43 +0800
Message-ID: <1523331103-20857-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since ret must be 0 when goes to scrub status file's write,
so scrub_write_buf(fd, buf, ret) writes nothing.
And when I check the process for read scrub status file,
there is no process for this field.
So, remove it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-scrub.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 8cf1e5df..efd7db94 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -753,7 +753,6 @@ static int scrub_write_file(int fd, const char *fsid,
 		    scrub_write_buf(fd, ":", 1) ||
 		    scrub_writev(fd, buf, sizeof(buf), "%lld",
 					use->scrub_args.devid) ||
-		    scrub_write_buf(fd, buf, ret) ||
 		    _SCRUB_KVWRITE(fd, buf, data_extents_scrubbed, use) ||
 		    _SCRUB_KVWRITE(fd, buf, tree_extents_scrubbed, use) ||
 		    _SCRUB_KVWRITE(fd, buf, data_bytes_scrubbed, use) ||
-- 
2.14.3



