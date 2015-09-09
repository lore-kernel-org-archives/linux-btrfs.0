Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32797 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754618AbbIINeG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 09:34:06 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t89DXmLL017485
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2015 21:33:48 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: don't create no-used threads in btrfs-image
Date: Wed, 9 Sep 2015 21:32:22 +0800
Message-ID: <3e745f7d9a9545e81283d28671c8ac23cdf28685.1441805445.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <1cb14fe54e546b530d0f3991062ff8bca5cc3394.1441805445.git.zhaolei@cn.fujitsu.com>
References: <1cb14fe54e546b530d0f3991062ff8bca5cc3394.1441805445.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of creating image without compess, we don't need to create
many no-used compress threads.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-image.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 7f49cce..c7681f4 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2786,11 +2786,14 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if ((compress_level > 0 || create == 0) &&
-	    num_threads == 0) {
-		num_threads = sysconf(_SC_NPROCESSORS_ONLN);
-		if (num_threads <= 0)
-			num_threads = 1;
+	if (compress_level > 0 || create == 0) {
+		if (num_threads == 0) {
+			num_threads = sysconf(_SC_NPROCESSORS_ONLN);
+			if (num_threads <= 0)
+				num_threads = 1;
+		}
+	} else {
+		num_threads = 0;
 	}
 
 	if (create) {
-- 
1.8.5.1

