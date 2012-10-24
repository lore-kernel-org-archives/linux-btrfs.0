Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62448 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2JXV0i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 17:26:38 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so646738pad.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 14:26:38 -0700 (PDT)
From: raghu.prabhu13@gmail.com
To: kosaki.motohiro@gmail.com, fengguang.wu@intel.com, zheng.z.yan@intel.com
Cc: linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: [PATCH v2] Change the check for PageReadahead into an else-if
Date: Thu, 25 Oct 2012 02:56:04 +0530
Message-Id: <05ff4f71283e84be8ab1b312864168d89535239f.1351113536.git.rprabhu@wnohang.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

>From 51daa88ebd8e0d437289f589af29d4b39379ea76, page_sync_readahead coalesces
async readahead into its readahead window, so another checking for that again is
not required.

Version 2: Fixed the incorrect indentation.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/btrfs/relocation.c | 4 +---
 mm/filemap.c          | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 776f0aa..8cfa1ab 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2996,9 +2996,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				ret = -ENOMEM;
 				goto out;
 			}
-		}
-
-		if (PageReadahead(page)) {
+		} else if (PageReadahead(page)) {
 			page_cache_async_readahead(inode->i_mapping,
 						   ra, NULL, page, index,
 						   last_index + 1 - index);
diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..aa440f16 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1113,8 +1113,7 @@ find_page:
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
 				goto no_cached_page;
-		}
-		if (PageReadahead(page)) {
+		} else if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping,
 					ra, filp, page,
 					index, last_index - index);
--
1.8.0

