Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3GIQii (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jul 2013 12:38:38 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D9CA3A51FE
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jul 2013 18:38:36 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Fix getopt on arm/ppc platforms
Date: Tue,  9 Jul 2013 18:38:29 +0200
Message-Id: <1373387909-30885-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(same as commit bb0eabc383e9a3fde7cdb02591ca88243f3e31fb)
There, 'char' is unsigned, so once assigned '-1' from getopt, it gets
the value 255. Then, it compared to '-1' gives false.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-crc.c   | 2 +-
 cmds-device.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-crc.c b/btrfs-crc.c
index e4cda43..1990534 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -34,7 +34,7 @@ void usage(void)
 
 int main(int argc, char **argv)
 {
-	char c;
+	int c;
 	unsigned long checksum = 0;
 	char *str;
 	char *buf;
diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..9e7328b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -294,7 +294,7 @@ static int cmd_dev_stats(int argc, char **argv)
 	int ret;
 	int fdmnt;
 	int i;
-	char c;
+	int c;
 	int err = 0;
 	__u64 flags = 0;
 
-- 
1.8.2

