Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:54968 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3ASSGc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 13:06:32 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130119180631.YWCZ21186.eastrmfepo203.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 19 Jan 2013 13:06:31 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 2/6] Fedora 18 - build-fixes.patch
Date: Sat, 19 Jan 2013 13:06:17 -0500
Message-Id: <1358618781-26629-3-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-1-git-send-email-gene@czarc.net>
References: <1358618781-26629-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 btrfsck.c | 2 ++
 mkfs.c    | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index a851008..6274ff7 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -22,7 +22,9 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sys/types.h>
 #include <sys/stat.h>
+#include <unistd.h>
 #include <getopt.h>
 #include "kerncompat.h"
 #include "ctree.h"
diff --git a/mkfs.c b/mkfs.c
index fbf8319..d123d5f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1206,7 +1206,7 @@ int main(int ac, char **av)
 	u64 alloc_start = 0;
 	u64 metadata_profile = 0;
 	u64 data_profile = 0;
-	u32 leafsize = getpagesize();
+	u32 leafsize = sysconf(_SC_PAGESIZE);
 	u32 sectorsize = 4096;
 	u32 nodesize = leafsize;
 	u32 stripesize = 4096;
@@ -1282,7 +1282,7 @@ int main(int ac, char **av)
 				print_usage();
 		}
 	}
-	sectorsize = max(sectorsize, (u32)getpagesize());
+	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
 	if (check_leaf_or_node_size(leafsize, sectorsize))
 		exit(1);
 	if (check_leaf_or_node_size(nodesize, sectorsize))
-- 
1.8.1

