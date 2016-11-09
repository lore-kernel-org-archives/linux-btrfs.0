Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754530AbcKIREm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 12:04:42 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E55A6ADB9
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 17:04:40 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/12] btrfs: use specialized page copying helpers in btrfs_clone_extent_buffer
Date: Wed,  9 Nov 2016 18:04:39 +0100
Message-Id: <412f7272c84e3bfd07f05b0cc8e31af68eabbabd.1478710770.git.dsterba@suse.com>
In-Reply-To: <cover.1478710770.git.dsterba@suse.com>
References: <cover.1478710770.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The copy_page is usually optimized and can be faster than memcpy.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 45a986791fe0..0a71a85d103d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4720,9 +4720,9 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 		WARN_ON(PageDirty(p));
 		SetPageUptodate(p);
 		new->pages[i] = p;
+		copy_page(page_address(p), page_address(src->pages[i]));
 	}
 
-	copy_extent_buffer(new, src, 0, 0, src->len);
 	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
 	set_bit(EXTENT_BUFFER_DUMMY, &new->bflags);
 
-- 
2.10.1

