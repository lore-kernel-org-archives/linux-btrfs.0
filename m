Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50799 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2KRCNd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Nov 2012 21:13:33 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so2649497pad.19
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Nov 2012 18:13:32 -0800 (PST)
Message-ID: <50A84440.9030905@gmail.com>
Date: Sun, 18 Nov 2012 10:13:20 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: update options in find-root.c
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove the useless option "-v" and add the option "-o" in
the description of usage.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 find-root.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/find-root.c b/find-root.c
index c0f38b8..2fb40e5 100644
--- a/find-root.c
+++ b/find-root.c
@@ -35,13 +35,12 @@
 #include "utils.h"
 #include "crc32c.h"

-static int verbose = 0;
 static u16 csum_size = 0;
 static u64 search_objectid = BTRFS_ROOT_TREE_OBJECTID;

 static void usage()
 {
-	fprintf(stderr, "Usage: find-roots [-v] <device>\n");
+	fprintf(stderr, "Usage: find-roots [-o search_objectid] <device>\n");
 }

 int csum_block(void *buf, u32 len)
@@ -414,11 +413,8 @@ int main(int argc, char **argv)
 	int opt;
 	int ret;

-	while ((opt = getopt(argc, argv, "vo:")) != -1) {
+	while ((opt = getopt(argc, argv, "o:")) != -1) {
 		switch(opt) {
-			case 'v':
-				verbose++;
-				break;
 			case 'o':
 				errno = 0;
 				search_objectid = (u64)strtoll(optarg, NULL,
-- 
1.7.5.4

