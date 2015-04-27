Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34442 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbD0EtN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 00:49:13 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Wolfgang_Mader@brain-frog.de, dsterba@suse.cz
Subject: [PATCH 1/2] Btrfs: log when missing device is created
Date: Mon, 27 Apr 2015 12:46:18 +0800
Message-Id: <1430109979-9397-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430109979-9397-1-git-send-email-anand.jain@oracle.com>
References: <1430109979-9397-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2b5cc9..693745e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6109,6 +6109,8 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 				free_extent_map(em);
 				return -EIO;
 			}
+			btrfs_warn(root->fs_info, "devid %llu uuid %pU is missing",
+						devid, uuid);
 		}
 		map->stripes[i].dev->in_fs_metadata = 1;
 	}
-- 
2.0.0.153.g79dcccc

