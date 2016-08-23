Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59409 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756725AbcHWKnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 064DDAD93
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/13] btrfs-progs: mkfs: switch BUG_ON to error handling in traverse_directory
Date: Tue, 23 Aug 2016 12:25:14 +0200
Message-Id: <1471947917-5324-11-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 mkfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 3f0a3322cc76..c28a8bb7e983 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -910,7 +910,12 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 					      parent_inum, dir_index_cnt,
 					      &cur_inode);
 			if (ret == -EEXIST) {
-				BUG_ON(st.st_nlink <= 1);
+				if (st.st_nlink <= 1) {
+					error(
+			"item %s already exists but has wrong st_nlink %ld <= 1",
+						cur_file->d_name, st.st_nlink);
+					goto fail;
+				}
 				continue;
 			}
 			if (ret) {
-- 
2.7.1

