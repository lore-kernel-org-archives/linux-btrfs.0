Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45170 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1758636AbcJRBcF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 21:32:05 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: rgoldwyn@suse.com, rgoldwyn@suse.de
Subject: [PATCH 1/4] btrfs: qgroup: Add comments explaining how btrfs qgroup works
Date: Tue, 18 Oct 2016 09:31:26 +0800
Message-Id: <20161018013129.23331-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
References: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add explain how btrfs qgroup works.

Qgroup is split into 3 main phrases:
1) Reserve
   To ensure qgroup doesn't exceed its limit

2) Trace
   To info qgroup to trace which extent

3) Account
   Calculate qgroup number change for each traced extent.

This should save quite some time for new developers.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 1bc64c8..a72bf21 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -23,6 +23,34 @@
 #include "delayed-ref.h"
 
 /*
+ * Btrfs qgroup overview
+ *
+ * Btrfs qgroup splits into 3 main part:
+ * 1) Reserve
+ *    Reserve metadata/data space for incoming operations
+ *    Affect how qgroup limit works
+ *
+ * 2) Trace
+ *    Tell btrfs qgroup to trace dirty extents.
+ *
+ *    Dirty extents including:
+ *    - Newly allocated extents
+ *    - Extents going to be deleted (in this trans)
+ *    - Extents whose owner is going to be modified
+ *
+ *    This is the main part affects whether qgroup numbers will stay
+ *    consistent.
+ *    Btrfs qgroup can trace clean extents and won't cause any problem,
+ *    but it will consume extra CPU time, it should be avoided if possible.
+ *
+ * 3) Account
+ *    Btrfs qgroup will updates its numbers, based on dirty extents traced
+ *    in previous step.
+ *
+ *    Normally at qgroup rescan and transaction commit time.
+ */
+
+/*
  * Record a dirty extent, and info qgroup to update quota on it
  * TODO: Use kmem cache to alloc it.
  */
-- 
2.10.0



