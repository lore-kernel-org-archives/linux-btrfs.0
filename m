Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40377 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752565AbdBMOao (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 09:30:44 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 78A13AD45
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 14:30:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/7] btrfs: ulist: make the finalization function public
Date: Mon, 13 Feb 2017 15:30:13 +0100
Message-Id: <0e94449a7f999c37d1a69809d49857f0855bfdec.1486995885.git.dsterba@suse.com>
In-Reply-To: <cover.1486995885.git.dsterba@suse.com>
References: <cover.1486995885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make ulist_fini externally visible so the ulist API is complete.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ulist.c | 2 +-
 fs/btrfs/ulist.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index b1434bb57e36..5deee56434fc 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -58,7 +58,7 @@ void ulist_init(struct ulist *ulist)
  * This is useful in cases where the base 'struct ulist' has been statically
  * allocated.
  */
-static void ulist_fini(struct ulist *ulist)
+void ulist_fini(struct ulist *ulist)
 {
 	struct ulist_node *node;
 	struct ulist_node *next;
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 007b22fff3f9..1a4130443d7e 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -44,6 +44,7 @@ struct ulist {
 };
 
 void ulist_init(struct ulist *ulist);
+void ulist_fini(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
 void ulist_free(struct ulist *ulist);
-- 
2.10.1

