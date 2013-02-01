Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29914 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3BAH6k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 02:58:40 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 13/13] Btrfs-progs: add subvol flags to print
Date: Fri,  1 Feb 2013 15:56:32 +0800
Message-Id: <1359705392-7485-14-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the flags row which as of now will show if the
subvol/snapshot is readonly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 5e51a26..c14e878 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -860,6 +860,11 @@ static int cmd_subvol_show(int argc, char **argv)
 	printf("\tParent: \t\t%llu\n", get_ri.ref_tree);
 	printf("\tTop Level: \t\t%llu\n", get_ri.top_id);
 
+	if (get_ri.flags & BTRFS_ROOT_SUBVOL_RDONLY)
+		printf("\tFlags: \t\t\treadonly\n");
+	else
+		printf("\tFlags: \t\t\t-\n");
+
 	/* print the snapshots of the given subvol if any*/
 	printf("\tSnapshot(s):\n");
 	filter_set = btrfs_list_alloc_filter_set();
-- 
1.8.1.227.g44fe835

