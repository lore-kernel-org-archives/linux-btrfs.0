Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33081 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753443AbdFLPaq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 11:30:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9FD8CAD06
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jun 2017 15:30:40 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs: document mandatory order of bio in btrfs_io_bio
Date: Mon, 12 Jun 2017 17:29:36 +0200
Message-Id: <e9e6988cba06239527f8a4a33c62e7a21b0f9762.1497281195.git.dsterba@suse.com>
In-Reply-To: <cover.1497281195.git.dsterba@suse.com>
References: <cover.1497281195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 58b97b6f5f02..35327efecdbb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -281,6 +281,10 @@ struct btrfs_io_bio {
 	u8 *csum_allocated;
 	btrfs_io_bio_end_io_t *end_io;
 	struct bvec_iter iter;
+	/*
+	 * This member must come last, bio_alloc_bioset will allocate enough
+	 * bytes for entire btrfs_io_bio but relies on bio being last.
+	 */
 	struct bio bio;
 };
 
-- 
2.13.0

