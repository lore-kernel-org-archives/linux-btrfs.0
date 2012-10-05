Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:46258 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab2JEUtZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 16:49:25 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id k2SE9x84IHbukuWH (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Oct 2012 14:49:24 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix page leakage
Date: Fri, 5 Oct 2012 16:55:00 -0400
Message-ID: <1349470500-7328-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alloc_dummy_extent_buffer will not free the first page in the eb array if we
fail to allocate a page, fix this.  Thanks,

Reported-by: David Sterba <dave@jikos.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7dc69b3..64dc93f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4104,7 +4104,7 @@ struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len)
 
 	return eb;
 err:
-	for (i--; i > 0; i--)
+	for (i--; i >= 0; i--)
 		__free_page(eb->pages[i]);
 	__free_extent_buffer(eb);
 	return NULL;
-- 
1.7.7.6

