Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755101AbdERDjL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:11 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 06/32] btrfs-progs: Refactor block sizes users in btrfs-map-logical.c
Date: Thu, 18 May 2017 11:38:31 +0800
Message-ID: <20170518033857.15002-7-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-map-logical.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index e856b698..e88357fc 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -82,7 +82,7 @@ again:
 	}
 	logical = key.objectid;
 	if (key.type == BTRFS_METADATA_ITEM_KEY)
-		len = fs_info->tree_root->nodesize;
+		len = fs_info->nodesize;
 	else
 		len = key.offset;
 
@@ -286,7 +286,7 @@ int main(int argc, char **argv)
 	}
 
 	if (bytes == 0)
-		bytes = root->nodesize;
+		bytes = root->fs_info->nodesize;
 	cur_logical = logical;
 	cur_len = bytes;
 
-- 
2.13.0



