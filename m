Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62654 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760898AbbBIUDx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:53 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 14/16] Btrfs-progs: make debug-tree spit out full_backref flag
Date: Mon, 9 Feb 2015 15:03:17 -0500
Message-ID: <1423512199-16552-15-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs-debug-tree ignores the FULL_BACKREF flag which makes it hard to
figure out problems related to FULL_BACKREF.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 print-tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index 3a7c13c..931a321 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -312,6 +312,10 @@ static void extent_flags_to_str(u64 flags, char *ret)
 		}
 		strcat(ret, "TREE_BLOCK");
 	}
+	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
+		strcat(ret, "|");
+		strcat(ret, "FULL_BACKREF");
+	}
 }
 
 void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
-- 
1.8.3.1

