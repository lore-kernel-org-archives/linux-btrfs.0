Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbcEBNMx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 09:12:53 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 795D5ABF6
	for <linux-btrfs@vger.kernel.org>; Mon,  2 May 2016 13:12:51 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: handle memory allocation error in cmd_device_stats
Date: Mon,  2 May 2016 15:12:35 +0200
Message-Id: <1462194755-19618-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-coverity-id: 1359012
Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index 5c0040c4f2ab..1c886ad58939 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -450,6 +450,10 @@ static int cmd_device_stats(int argc, char **argv)
 			/* No path when device is missing. */
 			if (!canonical_path) {
 				canonical_path = malloc(32);
+				if (!canonical_path) {
+					error("not enough memory for path buffer");
+					goto out;
+				}
 				snprintf(canonical_path, 32,
 					 "devid:%llu", args.devid);
 			}
-- 
2.7.1

