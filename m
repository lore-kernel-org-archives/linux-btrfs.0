Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19752 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752243AbbJLNYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:52 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOJt4026200
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:19 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 05/11] btrfs-progs: inspect: set return value of error case
Date: Mon, 12 Oct 2015 21:22:58 +0800
Message-ID: <089dd78bdaf8e25721ba718248a66b00e1b68284.1444655800.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
References: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of open_file_or_dir() failed, ret is not set to right value,
and the function will return unwanted value(ret of sprintf).

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-inspect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 879fd43..a13a170 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -243,6 +243,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 				if (path_fd < 0) {
 					fprintf(stderr, "ERROR: can't access "
 						"'%s'\n", full_path);
+					ret = -ENOENT;
 					goto out;
 				}
 			}
-- 
1.8.5.1

