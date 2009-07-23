From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] btrfs-progs: Check /etc/mtab in check_mounted()
Date: Thu, 23 Jul 2009 21:11:08 +0300
Message-ID: <1248372668.7187.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

The setmntent() lookup for '/proc/mounts' returns NULL on Ubuntu so use
'/etc/mtab' instead.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 utils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index 2f4c6e1..af1c6ec 100644
--- a/utils.c
+++ b/utils.c
@@ -600,7 +600,7 @@ int check_mounted(char *file)
 	FILE *f;
 	int ret = 0;
 
-	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
+	if ((f = setmntent ("/etc/mtab", "r")) == NULL)
 		return -errno;
 
 	if (stat(file, &st_buf) < 0) {
-- 
1.5.6.3



