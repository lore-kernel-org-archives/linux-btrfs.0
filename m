Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbcKIRE2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 12:04:28 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA42DAC34
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 17:04:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/12] btrfs: reada, remove pointless BUG_ON in reada_find_extent
Date: Wed,  9 Nov 2016 18:04:25 +0100
Message-Id: <8fb25ce369cf37795481b492215d047d20a0d6ae.1478710770.git.dsterba@suse.com>
In-Reply-To: <cover.1478710770.git.dsterba@suse.com>
References: <cover.1478710770.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The lock is held, we make the same lookup that previously failed with
EEXIST and we don't insert NULL pointers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index fe068b197fc1..95d526af3fba 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -393,7 +393,6 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	ret = radix_tree_insert(&fs_info->reada_tree, index, re);
 	if (ret == -EEXIST) {
 		re_exist = radix_tree_lookup(&fs_info->reada_tree, index);
-		BUG_ON(!re_exist);
 		re_exist->refcnt++;
 		spin_unlock(&fs_info->reada_lock);
 		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
-- 
2.10.1

