Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:33948 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751441AbdDCUVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 16:21:19 -0400
From: Christian Brauner <christian.brauner@ubuntu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 1/2 v2] btrfs-progs: fix btrfs send & receive with -e flag
Date: Mon,  3 Apr 2017 22:21:07 +0200
Message-Id: <20170403202108.14859-2-christian.brauner@ubuntu.com>
In-Reply-To: <20170403202108.14859-1-christian.brauner@ubuntu.com>
References: <20170403202108.14859-1-christian.brauner@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The old check here tried to ensure that empty streams are not considered valid.
The old check however, will always fail when only one run through the while(1)
loop is needed and honor_end_cmd is set. So this:

btrfs send /some/subvol | btrfs receive -e /some/

will consistently fail because -e causes honor_cmd_to be set and
btrfs_read_and_process_send_stream() to correctly return 1. So the command will
be successful but btrfs receive will error out because the send - receive
concluded in one run through the while(1) loop.

If we want to exclude empty streams we need a way to tell the difference between
btrfs_read_and_process_send_stream() returning 1 because read_buf() did not
detect any data and read_and_process_cmd() returning 1 because honor_end_cmd was
set. Without introducing too many changes the best way to me seems to have
btrfs_read_and_process_send_stream() return -ENODATA in the first case. The rest
stays the same. We can then check for -ENODATA in do_receive() and report a
proper error in this case. This should also be backwards compatible to previous
versions of btrfs receive. They will fail on empty streams because a negative
value is returned. The only thing that they will lack is a nice error message.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
Changelog: 2017-04-03
	- no changes
---
 cmds-receive.c | 13 +++++--------
 send-stream.c  |  2 +-
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 6cf22637..b59f00e4 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1091,7 +1091,6 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
 	char *dest_dir_full_path;
 	char root_subvol_path[PATH_MAX];
 	int end = 0;
-	int count;
 
 	dest_dir_full_path = realpath(tomnt, NULL);
 	if (!dest_dir_full_path) {
@@ -1186,7 +1185,6 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
 	if (ret < 0)
 		goto out;
 
-	count = 0;
 	while (!end) {
 		if (rctx->cached_capabilities_len) {
 			if (g_verbose >= 3)
@@ -1200,16 +1198,15 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
 							 rctx,
 							 rctx->honor_end_cmd,
 							 max_errors);
-		if (ret < 0)
-			goto out;
-		/* Empty stream is invalid */
-		if (ret && count == 0) {
+		if (ret < 0 && ret == -ENODATA) {
+			/* Empty stream is invalid */
 			error("empty stream is not considered valid");
 			ret = -EINVAL;
 			goto out;
+		} else if (ret < 0) {
+			goto out;
 		}
-		count++;
-		if (ret)
+		if (ret > 0)
 			end = 1;
 
 		close_inode_for_write(rctx);
diff --git a/send-stream.c b/send-stream.c
index 5a028cd9..78f2571a 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -492,7 +492,7 @@ int btrfs_read_and_process_send_stream(int fd,
 	if (ret < 0)
 		goto out;
 	if (ret) {
-		ret = 1;
+		ret = -ENODATA;
 		goto out;
 	}
 
-- 
2.11.0

