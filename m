From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make set/get functions for the super compat_ro
	flags use compat_ro
Date: Thu, 17 Dec 2009 16:32:27 -0500
Message-ID: <20091217213227.GB4122@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Our set/get functions for compat_ro_flags actually look at compat_flags.  This
will mess any attempt to use compat flags up.  The fix is obvious.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 464f688..917211b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1834,7 +1834,7 @@ BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_compat_flags, struct btrfs_super_block,
 			 compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
-			 compat_flags, 64);
+			 compat_ro_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
-- 
1.5.4.3

