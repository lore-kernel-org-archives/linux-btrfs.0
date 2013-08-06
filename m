Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab3HFMZh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 08:25:37 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 08B33A51B7
	for <linux-btrfs@vger.kernel.org>; Tue,  6 Aug 2013 14:25:37 +0200 (CEST)
Date: Tue, 6 Aug 2013 14:25:36 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: move chunk-recover command to devel
 namespace
Message-ID: <22cc667a2f998c4a04851fbe00bff4d57b688cd1.1375791411.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1375791411.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs.c b/btrfs.c
index dff0d70..4bbce48 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -252,6 +252,7 @@ const struct cmd_group devel_features_cmd_group = {
 	"NOTE: you have to call the commands as eg.\n"
 	"\tbtrfs _ newcommand --args\n",
 	{
+		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},
 		{ 0, 0, 0, 0, 0 }
 	}
 };
@@ -269,7 +270,6 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "check", cmd_check, cmd_check_usage, NULL, 0 },
-		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},
 		{ "restore", cmd_restore, cmd_restore_usage, NULL, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
 		{ "send", cmd_send, cmd_send_usage, NULL, 0 },
-- 
1.8.3.1

