Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:30522 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab3DJRK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 13:10:56 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp4) (RZmta 31.26 OK)
	with ESMTP id 6028d5p3AEEcMo for <linux-btrfs@vger.kernel.org>;
	Wed, 10 Apr 2013 19:10:52 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: allow omitting stream header and end-cmd for btrfs send
Date: Wed, 10 Apr 2013 19:10:52 +0200
Message-Id: <1365613852-12389-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two new flags are added to allow omitting the stream header and the
end command for btrfs send streams. This is used in cases where you
send multiple snapshots back-to-back in one stream.

This used to be encoded like this (with 2 snapshots in this example):
<stream header> + <sequence of commands> + <end cmd> +
<stream header> + <sequence of commands> + <end cmd> + EOF

The new format (if the two new flags are used) is this one:
<stream header> + <sequence of commands> +
                  <sequence of commands> + <end cmd>

Note that the currently existing receivers treat <end cmd> only as
an indication that a new <stream header> is following. This means,
you can just skip the sequence <end cmd> <stream header> without
loosing compatibility. As long as an EOF is following, the currently
existing receivers handle the new format (if the two new flags are
used) exactly as the old one.

So what is the benefit of this change? The goal is to be able to use
a single stream (one TCP connection) to multiplex a request/response
handshake plus Btrfs send streams, all in the same stream. In this
case you cannot evaluate an EOF condition as an end of the Btrfs send
stream. You need something else, and the <end cmd> is just perfect
for this purpose.

The summary is:
The format change is driven by the need to send several Btrfs send
streams over a single TCP connections, with the ability for a repeated
request/response handshake in the middle. And this format change does
not break any existing tool, it is completely compatible.

You could compare the old behaviour of the Btrfs send stream to the
one of ftp where you need a seperate request/response channel and
newly opened data transfer channels for each file, while the new
behaviour is more like http using a single stream for everything.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/send.c            | 24 ++++++++++++++----------
 include/uapi/linux/btrfs.h | 20 +++++++++++++++++++-
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ed897dc..3b5fa17 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4529,9 +4529,11 @@ static int send_subvol(struct send_ctx *sctx)
 {
 	int ret;
 
-	ret = send_header(sctx);
-	if (ret < 0)
-		goto out;
+	if (!(sctx->flags & BTRFS_SEND_FLAG_OMIT_STREAM_HEADER)) {
+		ret = send_header(sctx);
+		if (ret < 0)
+			goto out;
+	}
 
 	ret = send_subvol_begin(sctx);
 	if (ret < 0)
@@ -4593,7 +4595,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		goto out;
 	}
 
-	if (arg->flags & ~BTRFS_SEND_FLAG_NO_FILE_DATA) {
+	if (arg->flags & ~BTRFS_SEND_FLAG_MASK) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4704,12 +4706,14 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	if (ret < 0)
 		goto out;
 
-	ret = begin_cmd(sctx, BTRFS_SEND_C_END);
-	if (ret < 0)
-		goto out;
-	ret = send_cmd(sctx);
-	if (ret < 0)
-		goto out;
+	if (!(sctx->flags & BTRFS_SEND_FLAG_OMIT_END_CMD)) {
+		ret = begin_cmd(sctx, BTRFS_SEND_C_END);
+		if (ret < 0)
+			goto out;
+		ret = send_cmd(sctx);
+		if (ret < 0)
+			goto out;
+	}
 
 out:
 	kfree(arg);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index fa3a5f9..5e39e85 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -412,7 +412,25 @@ struct btrfs_ioctl_received_subvol_args {
  * search of clone sources doesn't find an extent. UPDATE_EXTENT
  * commands will be sent instead of WRITE commands.
  */
-#define BTRFS_SEND_FLAG_NO_FILE_DATA     0x1
+#define BTRFS_SEND_FLAG_NO_FILE_DATA		0x1
+
+/*
+ * Do not add the leading stream header. Used when multiple snapshots
+ * are sent back to back.
+ */
+#define BTRFS_SEND_FLAG_OMIT_STREAM_HEADER	0x2
+
+/*
+ * Omit the command at the end of the stream that indicated the end
+ * of the stream. This option is used when multiple snapshots are
+ * sent back to back.
+ */
+#define BTRFS_SEND_FLAG_OMIT_END_CMD		0x4
+
+#define BTRFS_SEND_FLAG_MASK \
+	(BTRFS_SEND_FLAG_NO_FILE_DATA | \
+	 BTRFS_SEND_FLAG_OMIT_STREAM_HEADER | \
+	 BTRFS_SEND_FLAG_OMIT_END_CMD)
 
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
-- 
1.8.2.1

