Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725745AbeIYGLP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 02:11:15 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 121E7AD1A
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 00:06:31 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: Use NAME_MAX to replace intermediate number of BTRFS_NAME_LEN
Date: Tue, 25 Sep 2018 08:06:25 +0800
Message-Id: <20180925000626.15474-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we're following the name size limit of linux, just use NAME_MAX.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 53af9f5253f4..5ab6d1f6e055 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -65,7 +65,7 @@ struct btrfs_ordered_sum;
  * we can actually store much bigger names, but lets not confuse the rest
  * of linux
  */
-#define BTRFS_NAME_LEN 255
+#define BTRFS_NAME_LEN NAME_MAX
 
 /*
  * Theoretical limit is larger, but we keep this down to a sane
-- 
2.19.0
