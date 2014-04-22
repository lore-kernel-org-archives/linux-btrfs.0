Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbaDVNUD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 09:20:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 492ACAD0E
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 13:20:02 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: read global reserve size from space infos
Date: Tue, 22 Apr 2014 15:20:00 +0200
Message-Id: <1398172800-19548-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernels 3.15 > export the global block reserve as a space info presented
by 'btrfs fi df' but would display 'unknown' instead of some meaningful
string.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Global_rsv or GlobalRsv or Globalrsv or something else?

 cmds-filesystem.c | 2 ++
 ctree.h           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 306f715475ac..5a3bbca91458 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -129,6 +129,8 @@ static char *group_type_str(u64 flag)
 		return "Metadata";
 	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
 		return "Data+Metadata";
+	case BTRFS_SPACE_INFO_GLOBAL_RSV:
+		return "Global_rsv";
 	default:
 		return "unknown";
 	}
diff --git a/ctree.h b/ctree.h
index a4d2cd114614..7e8ced718931 100644
--- a/ctree.h
+++ b/ctree.h
@@ -861,6 +861,8 @@ struct btrfs_csum_item {
 /* used in struct btrfs_balance_args fields */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
+#define BTRFS_SPACE_INFO_GLOBAL_RSV    (1ULL << 49)
+
 #define BTRFS_QGROUP_STATUS_OFF			0
 #define BTRFS_QGROUP_STATUS_ON			1
 #define BTRFS_QGROUP_STATUS_SCANNING		2
-- 
1.9.0

