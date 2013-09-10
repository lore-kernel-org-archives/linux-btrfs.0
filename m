Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3IJEfH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:35:07 -0400
Message-ID: <522EA16D.6080806@suse.com>
Date: Tue, 10 Sep 2013 00:34:53 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <clmason@fusionio.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] ctree: fix broken macros for compat_ro
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The macro for compat_ro had the right name but was modifying compat instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 0b0d701..8ef45f3 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1912,7 +1912,7 @@ BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct
btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_compat_flags, struct btrfs_super_block,
 			 compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
-			 compat_flags, 64);
+			 compat_ro_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
-- 
1.8.1.4


-- 
Jeff Mahoney
SUSE Labs
