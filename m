Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54891 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbaCLOVi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 10:21:38 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 12 Mar 2014 19:51:35 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id EAA8F1258044
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:53:48 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s2CELbgU524688
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:51:37 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s2CELXak010667
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:51:33 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [PATCH 5/6] Btrfs: subpagesize-blocksize: Hardcode MAX_EXTENT_BUFFERS_PER_PAGE to 2.
Date: Wed, 12 Mar 2014 19:50:32 +0530
Message-Id: <1394634033-2528-6-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With 2k blocksize the maximum number extent buffers per page will be 2. We
should be computing this value at runtime. For now, Let's work with the
hardcoded value.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 71100ad..6cc5ed2 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -123,7 +123,12 @@ struct extent_state {
 
 #define INLINE_EXTENT_BUFFER_PAGES 16
 #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_CACHE_SIZE)
-#define MAX_EXTENT_BUFFERS_PER_PAGE 16
+
+#if 0
+#define MAX_EXTENT_BUFFERS_PER_PAGE 1
+#else
+#define MAX_EXTENT_BUFFERS_PER_PAGE 2
+#endif
 
 struct extent_buffer {
 	u64 start;
-- 
1.8.3.1

