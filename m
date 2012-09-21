Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59935 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2IUAVL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 20:21:11 -0400
Received: by iahk25 with SMTP id k25so2091649iah.19
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 17:21:10 -0700 (PDT)
Message-ID: <505BB2ED.6030906@gmail.com>
Date: Fri, 21 Sep 2012 08:21:01 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: trivial@kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: [RESEND][PATCH] Btrfs: small fix the commment for the action flags
 in delayed-ref.h
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The action field has been merged into struct btrfs_delayed_ref_node,
and no struct btrfs_delayed_ref is available now.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/delayed-ref.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index ab53005..c9d7036 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -18,7 +18,7 @@
 #ifndef __DELAYED_REF__
 #define __DELAYED_REF__
 
-/* these are the possible values of struct btrfs_delayed_ref->action */
+/* these are the possible values of struct btrfs_delayed_ref_node->action */
 #define BTRFS_ADD_DELAYED_REF    1 /* add one backref to the tree */
 #define BTRFS_DROP_DELAYED_REF   2 /* delete one backref from the tree */
 #define BTRFS_ADD_DELAYED_EXTENT 3 /* record a full extent allocation */
-- 
1.7.1
