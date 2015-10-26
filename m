Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1221 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753748AbbJZKaF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 06:30:05 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9QATVI6004082
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 18:29:31 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 3/5] btrfs-progs: Add all missing btrfs_close_all_devices to standalone tools
Date: Mon, 26 Oct 2015 18:28:20 +0800
Message-ID: <646e467788083e76422d0faff961b4ae475f69ee.1445855131.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
References: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch add all missing btrfs_close_all_devices() to standalone
tools in btrfs progs, to avoid memory leak.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-calc-size.c    | 1 +
 btrfs-debug-tree.c   | 5 ++++-
 btrfs-find-root.c    | 1 +
 btrfs-map-logical.c  | 1 +
 btrfs-select-super.c | 2 ++
 btrfstune.c          | 1 +
 6 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 7287858..b756693 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -508,5 +508,6 @@ int main(int argc, char **argv)
 out:
 	close_ctree(root);
 	free(roots);
+	btrfs_close_all_devices();
 	return ret;
 }
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 7d8e876..8adc39f 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -28,6 +28,7 @@
 #include "disk-io.h"
 #include "print-tree.h"
 #include "transaction.h"
+#include "volumes.h"
 #include "utils.h"
 
 static int print_usage(int ret)
@@ -428,5 +429,7 @@ no_node:
 	printf("uuid %s\n", uuidbuf);
 	printf("%s\n", PACKAGE_STRING);
 close_root:
-	return close_ctree(root);
+	ret = close_ctree(root);
+	btrfs_close_all_devices();
+	return ret;
 }
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 01b3603..fc3812c 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -216,5 +216,6 @@ int main(int argc, char **argv)
 out:
 	btrfs_find_root_free(&result);
 	close_ctree(root);
+	btrfs_close_all_devices();
 	return ret;
 }
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index d9fa6b2..0161b5c 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -359,5 +359,6 @@ close:
 	close_ctree(root);
 	if (ret < 0)
 		ret = 1;
+	btrfs_close_all_devices();
 	return ret;
 }
diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index b790f3e..bd44978 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -23,6 +23,7 @@
 #include <sys/stat.h>
 #include "kerncompat.h"
 #include "ctree.h"
+#include "volumes.h"
 #include "disk-io.h"
 #include "print-tree.h"
 #include "transaction.h"
@@ -101,5 +102,6 @@ int main(int ac, char **av)
 	 */
 	printf("using SB copy %llu, bytenr %llu\n", (unsigned long long)num,
 	       (unsigned long long)bytenr);
+	btrfs_close_all_devices();
 	return ret;
 }
diff --git a/btrfstune.c b/btrfstune.c
index c248ee6..0907aa9 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -548,6 +548,7 @@ int main(int argc, char *argv[])
 	}
 out:
 	close_ctree(root);
+	btrfs_close_all_devices();
 
 	return ret;
 }
-- 
1.8.5.1

