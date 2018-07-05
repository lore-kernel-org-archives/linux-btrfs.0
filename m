Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53550 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753335AbeGEHhl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 03:37:41 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8EB11AD6C
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 07:37:39 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs-progs: check/original: Don't overwrite return value when we failed to repair
Date: Thu,  5 Jul 2018 15:37:31 +0800
Message-Id: <20180705073731.18459-5-wqu@suse.com>
In-Reply-To: <20180705073731.18459-1-wqu@suse.com>
References: <20180705073731.18459-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In check_inode_recs(), for repair mode we always reset @ret to 0.
It makes no sense and later we check@ret to determine if the repair is
successful.

Fix it by removing the offending overwrite.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 2b5abb2d025b..08476968aaba 100644
--- a/check/main.c
+++ b/check/main.c
@@ -2764,7 +2764,6 @@ static int check_inode_recs(struct btrfs_root *root,
 				free_inode_rec(rec);
 				continue;
 			}
-			ret = 0;
 		}
 
 		if (!(repair && ret == 0))
-- 
2.18.0

