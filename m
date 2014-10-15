Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24703 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaJOIkV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 04:40:21 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 1/1] btrfs-progs: open RW to register device using btrfs-control
Date: Wed, 15 Oct 2014 08:46:54 +0800
Message-Id: <1413334014-25616-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are passing device path to be registered with in kernel,
so we need to open with RW

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index dd4ee52..78cb93f 100644
--- a/utils.c
+++ b/utils.c
@@ -1243,7 +1243,7 @@ void btrfs_register_one_device(char *fname)
 	int ret;
 	int e;
 
-	fd = open("/dev/btrfs-control", O_RDONLY);
+	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		fprintf(stderr, "failed to open /dev/btrfs-control "
 			"skipping device registration: %s\n",
-- 
2.0.0.153.g79dcccc

