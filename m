From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 3/4] Btrfs: Makefile changes to optionally include btrfs integrity check
Date: Wed,  9 Nov 2011 16:18:00 +0100
Message-ID: <65ab16ff6c981903749d9445c1b9f3fd118d3fe3.1320850526.git.sbehrens@giantdisaster.de>
References: <cover.1320849129.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1320849129.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

If the btrfs integrity check is enabled, the files required to
implement the checks are included in the build.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index c0ddfd2..bc5b355 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -11,3 +11,4 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   reada.o backref.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
+btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
-- 
1.7.3.4

