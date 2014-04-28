Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35500 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753944AbaD1Igb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 04:36:31 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3S8aSlY001439
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 16:36:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Replace the overkill assert with normal error message.
Date: Mon, 28 Apr 2014 16:37:30 +0800
Message-ID: <1398674250-9656-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1398674250-9656-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1398674250-9656-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When 'btrfs replace status' encounters an unknown dev replace status, it
will cause an assert, which is somewhat overkilled and can be replaced
with a normal error message.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-replace.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 645dc98..9eb981b 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -449,7 +449,10 @@ static int print_replace_status(int fd, const char *path, int once)
 			break;
 		default:
 			prevent_loop = 1;
-			assert(0);
+			fprintf(stderr,
+				"Unknown btrfs dev replace status:%llu",
+				status->replace_state);
+			ret = -EINVAL;
 			break;
 		}
 
@@ -459,9 +462,9 @@ static int print_replace_status(int fd, const char *path, int once)
 				(unsigned long long)status->num_write_errors,
 				(unsigned long long)
 				 status->num_uncorrectable_read_errors);
-		if (once || prevent_loop) {
+		if (once || prevent_loop || ret) {
 			printf("\n");
-			return 0;
+			return ret;
 		}
 
 		fflush(stdout);
-- 
1.9.2

