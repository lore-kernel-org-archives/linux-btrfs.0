Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60896 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3JaFBW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 01:01:22 -0400
Received: by mail-ie0-f176.google.com with SMTP id u16so3922475iet.7
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 22:01:22 -0700 (PDT)
Received: from dshgna ([124.43.179.229])
        by mx.google.com with ESMTPSA id o15sm10259428igx.6.2013.10.30.22.01.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 30 Oct 2013 22:01:21 -0700 (PDT)
Date: Thu, 31 Oct 2013 10:31:13 +0530
From: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: Enclose macros with complex values within
 parenthesis
Message-ID: <aa92a8e38512fe180d28fdc12bd49847d68528e0.1383193392.git.dulshani.gunawardhana89@gmail.com>
References: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enclose macros with complex values within parenthesis in accordance to
checkpatch.pl.

Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
Reviewed-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/extent_map.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 61adc44..93fba71 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -3,10 +3,10 @@
 
 #include <linux/rbtree.h>
 
-#define EXTENT_MAP_LAST_BYTE (u64)-4
-#define EXTENT_MAP_HOLE (u64)-3
-#define EXTENT_MAP_INLINE (u64)-2
-#define EXTENT_MAP_DELALLOC (u64)-1
+#define EXTENT_MAP_LAST_BYTE ((u64)-4)
+#define EXTENT_MAP_HOLE ((u64)-3)
+#define EXTENT_MAP_INLINE ((u64)-2)
+#define EXTENT_MAP_DELALLOC ((u64)-1)
 
 /* bits for the flags field */
 #define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
-- 
1.8.1.2

