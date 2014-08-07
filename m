Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7817 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754623AbaHGCgR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 22:36:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s772aDiS005033
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Aug 2014 10:36:14 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: remove unused parameter in rollback for btrfs-convert
Date: Thu, 7 Aug 2014 10:35:58 +0800
Message-ID: <1407378959-23728-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1407378959-23728-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1407378959-23728-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The @force parameter for function @do_rollback is never checked
or used, remove it.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-convert.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 2ea6a09..21bbc70 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2376,7 +2376,7 @@ fail:
 	return -1;
 }
 
-static int do_rollback(const char *devname, int force)
+static int do_rollback(const char *devname)
 {
 	int fd = -1;
 	int ret;
@@ -2754,7 +2754,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (rollback) {
-		ret = do_rollback(file, 0);
+		ret = do_rollback(file);
 	} else {
 		ret = do_convert(file, datacsum, packing, noxattr);
 	}
-- 
1.8.1.4

