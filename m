Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:39153 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932798AbaGOTRE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 15:17:04 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] Btrfs: fix sparse warning
Date: Tue, 15 Jul 2014 21:17:17 +0200
Message-Id: <1405451837-8235-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the following sparse warning:
fs/btrfs/send.c:518:51: warning: incorrect type in argument 2 (different address spaces)
fs/btrfs/send.c:518:51:    expected char const [noderef] <asn:1>*<noident>
fs/btrfs/send.c:518:51:    got char *

We can safely use (const char __user *) with set_fs(KERNEL_DS)

__force added to avoid sparse-all warning:
fs/btrfs/send.c:518:40: warning: cast adds address space to expression (<asn:1>)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 fs/btrfs/send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6528aa6..b67e12e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
 	set_fs(KERNEL_DS);
 
 	while (pos < len) {
-		ret = vfs_write(filp, (char *)buf + pos, len - pos, off);
+		ret = vfs_write(filp, (__force const char __user *)buf + pos,
+				len - pos, off);
 		/* TODO handle that correctly */
 		/*if (ret == -ERESTARTSYS) {
 			continue;
-- 
1.8.4.5

