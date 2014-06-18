Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:43397 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbaFRQvw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 12:51:52 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Subject: [PATCH] btrfs-progs: restore: check lzo compress length
Date: Wed, 18 Jun 2014 18:51:19 +0200
Message-Id: <1403110279-28688-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When things go wrong for lzo-compressed btrfs, feeding lzo1x_decompress_safe()
with corrupt data during restore can lead to crashes. Reduce the risk by adding
a check on the input length.

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
---

Hi,

This patch actually allowed me to finish a btrfs restore of a damaged
filesystem, which was repeateadly crashing otherwise. This was with v3.12, but
I think it still makes sense.

Best regards,

V.

 cmds-restore.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index 96b97e1..4338493 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -115,6 +115,12 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 
 	while (tot_in < tot_len) {
 		in_len = read_compress_length(inbuf);
+
+		if ((tot_in + LZO_LEN + in_len) > tot_len) {
+			fprintf(stderr, "bad compress length %lu\n", in_len);
+			return -1;
+		}
+
 		inbuf += LZO_LEN;
 		tot_in += LZO_LEN;
 
-- 
2.0.0

