Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7345 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751147AbaFXDWF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 23:22:05 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v3 3/4] btrfs-progs: delete invalid output file when btrfs-image failed
Date: Tue, 24 Jun 2014 11:16:45 +0800
Message-ID: <1403579805-7832-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <20140623141557.GG1553@twin.jikos.cz>
References: <20140623141557.GG1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs-image failed to create an image, the invalid output file
had better be deleted to prevent being used mistakenly in the future.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
        v1->v2: use a new local variable to avoid return value overwritten
	v2->v3: fix patch format problem: tailing whitespace
---
 btrfs-image.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 9e5b8b3..1a3e6ca 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2608,8 +2608,18 @@ int main(int argc, char *argv[])
 out:
 	if (out == stdout)
 		fflush(out);
-	else
+	else {
 		fclose(out);
+		if (ret && create) {
+			int unlink_ret;
+
+			unlink_ret = unlink(target);
+			if (unlink_ret)
+				fprintf(stderr,
+					"unlink output file failed : %s\n",
+					strerror(errno));
+		}
+	}
 
 	return !!ret;
 }
-- 
1.8.1.4

