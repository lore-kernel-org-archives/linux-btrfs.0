Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43469 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751724AbdEPRSk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:18:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D562FAB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:18:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: remove unused member list from btrfs_end_io_wq
Date: Tue, 16 May 2017 19:17:37 +0200
Message-Id: <981cb54dde2cdef8ab649c50ebb5c577d268080c.1494954874.git.dsterba@suse.com>
In-Reply-To: <cover.1494954874.git.dsterba@suse.com>
References: <cover.1494954874.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The end io work queue items have been tracked by the work queues since
"Btrfs: Add async worker threads for pre and post IO checksumming"
(8b7128429235d9bd72cfd5e) (2008).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index db805632b4c0..48b58a1f989e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -89,7 +89,6 @@ struct btrfs_end_io_wq {
 	struct btrfs_fs_info *info;
 	int error;
 	enum btrfs_wq_endio_type metadata;
-	struct list_head list;
 	struct btrfs_work work;
 };
 
-- 
2.12.0

