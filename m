Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4426 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752548AbaGQCqc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 22:46:32 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H2kThq028192
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 10:46:29 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs-progs: remove unnecessary judgment for fd in scrub
Date: Thu, 17 Jul 2014 10:40:37 +0800
Message-ID: <1405564839-28702-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The scrub_read_file function is always on a branch,
which has (fd >= 0), so there is not need to judgment
the pasted in arg.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-scrub.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index f9e2b40..a604b25 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -474,9 +474,6 @@ static struct scrub_file_record **scrub_read_file(int fd, int report_errors)
 	char empty_uuid[BTRFS_FSID_SIZE] = {0};
 	struct scrub_file_record **p = NULL;
 
-	if (fd < 0)
-		return ERR_PTR(-EINVAL);
-
 again:
 	old_avail = avail - i;
 	BUG_ON(old_avail < 0);
-- 
1.8.1.4

