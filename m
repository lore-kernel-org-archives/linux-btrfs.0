Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbeINMi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 08:38:29 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E5D79AE1D
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 07:25:18 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: convert: Make read_disk_extent() return more meaningful -EIO other -1
Date: Fri, 14 Sep 2018 15:25:04 +0800
Message-Id: <20180914072505.15916-2-wqu@suse.com>
In-Reply-To: <20180914072505.15916-1-wqu@suse.com>
References: <20180914072505.15916-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When pread64() returns value smaller than expected, it normally means
EIO, so just return -EIO to replace the intermediate number.
So when IO fails, we should be able to get more meaningful error number
of than EPERM.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/source-fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/convert/source-fs.c b/convert/source-fs.c
index b6d08370428a..5660a22cc652 100644
--- a/convert/source-fs.c
+++ b/convert/source-fs.c
@@ -201,7 +201,7 @@ int read_disk_extent(struct btrfs_root *root, u64 bytenr,
 	ret = 0;
 fail:
 	if (ret > 0)
-		ret = -1;
+		ret = -EIO;
 	return ret;
 }
 
-- 
2.19.0
