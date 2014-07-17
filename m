Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4426 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752717AbaGQCqe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 22:46:34 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H2kV4R028199
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 10:46:31 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs-progs: replace a confusing raw number with a macro
Date: Thu, 17 Jul 2014 10:40:38 +0800
Message-ID: <1405564839-28702-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The raw number 36 for the uuid string length is somewhat confusing,
use a macro to define replace it.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-scrub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index a604b25..03eb9ba 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -48,6 +48,8 @@ static const char * const scrub_cmd_group_usage[] = {
 	NULL
 };
 
+#define UUID_LEN_STR 36
+
 #define SCRUB_DATA_FILE "/var/lib/btrfs/scrub.status"
 #define SCRUB_PROGRESS_SOCKET_PATH "/var/lib/btrfs/scrub.progress"
 #define SCRUB_FILE_VERSION_PREFIX "scrub status"
@@ -550,7 +552,7 @@ again:
 				;
 			if (i + j + 1 >= avail)
 				_SCRUB_INVALID;
-			if (j != 36)
+			if (j != UUID_LEN_STR)
 				_SCRUB_INVALID;
 			l[i + j] = '\0';
 			ret = uuid_parse(l + i, p[curr]->fsid);
-- 
1.8.1.4

