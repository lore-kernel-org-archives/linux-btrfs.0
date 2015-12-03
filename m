Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbbLCQxq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:53:46 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CAD0FADD6
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:53:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs: use GFP_KERNEL for allocations of workqueues
Date: Thu,  3 Dec 2015 17:51:54 +0100
Message-Id: <61dd5ae65be6dfaeadb0e841ea6639351f0e04ce.1449160585.git.dsterba@suse.com>
In-Reply-To: <cover.1449160585.git.dsterba@suse.com>
References: <cover.1449160585.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't have to use GFP_NOFS to allocate workqueue structures, this is
done from mount context or potentially scrub start context, safe to fail
in both cases.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/async-thread.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 3e36e4adc4a3..88d9af3d4581 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -97,7 +97,7 @@ static struct __btrfs_workqueue *
 __btrfs_alloc_workqueue(const char *name, unsigned int flags, int limit_active,
 			 int thresh)
 {
-	struct __btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_NOFS);
+	struct __btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_KERNEL);
 
 	if (!ret)
 		return NULL;
@@ -148,7 +148,7 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(const char *name,
 					      int limit_active,
 					      int thresh)
 {
-	struct btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_NOFS);
+	struct btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_KERNEL);
 
 	if (!ret)
 		return NULL;
-- 
2.6.2

