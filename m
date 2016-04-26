Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbcDZKoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 06:44:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8ECD1ABF6
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 10:44:08 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: __btrfs_buffered_write: PAGE_CACHE_ removal related fixups
Date: Tue, 26 Apr 2016 12:44:00 +0200
Message-Id: <b70f5aeab8239af9d932066276f9adbdad7af8b6.1461666893.git.dsterba@suse.com>
In-Reply-To: <cover.1461666892.git.dsterba@suse.com>
References: <cover.1461666892.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The PAGE_CACHE_* macros and page_cache_* helpers are gone in the next
merging target (4.7), so we have to fix that before the "enospc rework"
branch gets merged. Fixed only instances introduced by this patchset.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7c802082a76b..2ef3b94a1a44 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1549,7 +1549,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				 * write_bytes, so scale down.
 				 */
 				num_pages = DIV_ROUND_UP(write_bytes + offset,
-							 PAGE_CACHE_SIZE);
+							 PAGE_SIZE);
 				reserve_bytes = round_up(write_bytes +
 							 sector_offset,
 							 root->sectorsize);
-- 
2.7.1

