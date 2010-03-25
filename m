From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: fix wrong return value
Date: Thu, 25 Mar 2010 20:40:31 +0800
Message-ID: <4BAB59BF.8050703@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

btrfsctl returns 1 if it does something successfully. this patch fixes this
problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfsctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index be6bf25..e2aae17 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -249,8 +249,8 @@ int main(int ac, char **av)
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	if (ret)
-		exit(0);
-	else
 		exit(1);
+
+	return 0;
 }
 
-- 
1.6.5.2


