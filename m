Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55299 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761723Ab3IECkk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Sep 2013 22:40:40 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r852eZQw014031
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Sep 2013 10:40:35 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/5] btrfs-progs:free local variable buf upon unsuccessful returns
Date: Thu, 5 Sep 2013 10:38:54 +0800
Message-Id: <1378348738-14451-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variable "buf" passed into find_collision() as parameter "name" should be freed on unsuccessful returns.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index 3ea3730..1a52aa6 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -284,6 +284,7 @@ static char *find_collision(struct metadump_struct *md, char *name,
 	val = malloc(sizeof(struct name));
 	if (!val) {
 		fprintf(stderr, "Couldn't sanitize name, enomem\n");
+		free(name);
 		return NULL;
 	}
 
@@ -295,6 +296,7 @@ static char *find_collision(struct metadump_struct *md, char *name,
 	if (!val->sub) {
 		fprintf(stderr, "Couldn't sanitize name, enomem\n");
 		free(val);
+		free(name);
 		return NULL;
 	}
 
-- 
1.8.0.1

