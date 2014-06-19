Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13756 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757163AbaFSBvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:51:21 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1pIaV020929
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:51:19 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs-progs: delete invalid output file when btrfs-image failed
Date: Thu, 19 Jun 2014 09:46:02 +0800
Message-ID: <1403142363-29482-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs-image failed to create an image, the invalid output file
had better be deleted to prevent being used mistakenly in the future.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 549722c..b235b87 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2598,8 +2598,16 @@ int main(int argc, char *argv[])
 out:
 	if (out == stdout)
 		fflush(out);
-	else
+	else {
 		fclose(out);
+		if (ret && create) {
+			ret = unlink(target);
+			if (ret)
+				fprintf(stderr,
+					"unlink output file failed : %s\n",
+					strerror(errno));
+		}
+	}
 
 	return !!ret;
 }
-- 
1.8.1.4

