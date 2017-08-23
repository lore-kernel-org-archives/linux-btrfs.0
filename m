Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34693 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdHWWp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 18:45:58 -0400
Received: by mail-wm0-f66.google.com with SMTP id 69so964097wmh.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 15:45:57 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v6 1/6] Btrfs: heuristic make use compression workspaces
Date: Thu, 24 Aug 2017 01:45:40 +0300
Message-Id: <20170823224545.16375-2-nefelim4ag@gmail.com>
In-Reply-To: <20170823224545.16375-1-nefelim4ag@gmail.com>
References: <20170823224545.16375-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move heuristic to external file
Implement compression workspaces support for
heuristic resources

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index 96ae3e9334bc..d0e9f9112b7e 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -48,14 +48,20 @@ static int heuristic(struct list_head *ws, struct inode *inode,
 {
 	struct page *page;
 	u64 index, index_end;
-	u8 *input_data;

 	index = start >> PAGE_SHIFT;
 	index_end = end >> PAGE_SHIFT;

+	/*
+	 * If end aligned to PAGE_SIZE
+	 * It's useless to check +1 PAGE
+	 */
+	if(end%PAGE_SIZE == 0)
+		index_end--;
+
 	for (; index <= index_end; index++) {
 		page = find_get_page(inode->i_mapping, index);
-		input_data = kmap(page);
+		kmap(page);
 		kunmap(page);
 		put_page(page);
 	}
--
2.14.1
