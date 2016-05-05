Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757718AbcEEQgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 May 2016 12:36:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DE670AC60
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:36:40 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: make find_workspace warn if there are no workspaces
Date: Thu,  5 May 2016 18:36:23 +0200
Message-Id: <ae55b9ec7ac117c05ff866500425fe8b4accfebe.1462460924.git.dsterba@suse.com>
In-Reply-To: <cover.1462460924.git.dsterba@suse.com>
References: <cover.1462460924.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Be verbose if there are no workspaces at all, ie. the module init time
preallocation failed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c70625560265..658c39b70fba 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -834,7 +834,21 @@ static struct list_head *find_workspace(int type)
 		 * workspace preallocated for each type and the compression
 		 * time is bounded so we get to a workspace eventually. This
 		 * makes our caller's life easier.
+		 *
+		 * To prevent silent and low-probability deadlocks (when the
+		 * initial preallocation fails), check if there are any
+		 * workspaces at all.
 		 */
+		if (atomic_read(total_ws) == 0) {
+			static DEFINE_RATELIMIT_STATE(_rs,
+					/* once per minute */ 60 * HZ,
+					/* no burst */ 1);
+
+			if (__ratelimit(&_rs)) {
+				printk(KERN_WARNING
+			    "no compression workspaces, low memory, retrying");
+			}
+		}
 		goto again;
 	}
 	return workspace;
-- 
2.7.1

