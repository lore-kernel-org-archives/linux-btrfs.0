Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20089 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbBRDHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 22:07:51 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] Btrfs-progs: fix compile failure
Date: Wed, 18 Feb 2015 12:10:43 +0800
Message-Id: <1424232643-15133-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

make
::
    [CC]     btrfs-search-metadata.o
btrfs-search-metadata.c: In function ‘print_usage’:
btrfs-search-metadata.c:40: error: ‘BTRFS_BUILD_VERSION’ undeclared (first use in this function)
btrfs-search-metadata.c:40: error: (Each undeclared identifier is reported only once
btrfs-search-metadata.c:40: error: for each function it appears in.)
make: *** [btrfs-search-metadata.o] Error 1

btrfs-search-metadata.c:	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-search-metadata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/btrfs-search-metadata.c b/btrfs-search-metadata.c
index 80dc326..34c6f39 100644
--- a/btrfs-search-metadata.c
+++ b/btrfs-search-metadata.c
@@ -37,7 +37,6 @@ static int print_usage(void)
 	fprintf(stderr, "\t-t <tree-id>: search for given tree\n");
 	fprintf(stderr, "\t-l <level>: search for node level (0=leaf)\n");
 	fprintf(stderr, "\t-L: print full listing of matching leaf/node contents\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
 
-- 
2.0.0.153.g79dcccc

