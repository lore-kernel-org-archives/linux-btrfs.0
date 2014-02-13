Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaBMDUP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 22:20:15 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1D3K49d002790
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 11:20:06 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs-progs: remove a dead break before usage()
Date: Thu, 13 Feb 2014 11:16:36 +0800
Message-Id: <1392261398-6197-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The usage() in help.c calls exit(1), so the break behind is nonsense
and should be removed.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-property.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/cmds-property.c b/cmds-property.c
index 3d1f18c..df53f91 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -335,7 +335,6 @@ static void parse_args(int argc, char **argv,
 			break;
 		default:
 			usage(usage_str);
-			break;
 		}
 	}
 
-- 
1.8.1.4

