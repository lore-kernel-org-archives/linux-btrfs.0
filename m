Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab3H0TRw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 15:17:52 -0400
Message-ID: <521CFB59.8000903@suse.com>
Date: Tue, 27 Aug 2013 15:17:45 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
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
@@ -1912,7 +1912,7 @@ BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct btrfs_super_block,
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
