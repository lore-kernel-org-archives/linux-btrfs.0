From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 3/4] Btrfs: Makefile changes to optionally include btrfs integrity check
Date: Wed, 21 Dec 2011 19:17:36 +0100
Message-ID: <f11e4d7f533249ddfa110116200c5c3a509f9218.1324491283.git.sbehrens@giantdisaster.de>
References: <cover.1324489705.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1324489705.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1324491283.git.sbehrens@giantdisaster.de>
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

