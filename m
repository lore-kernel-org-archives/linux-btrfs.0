From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 2/4] Btrfs: add config option to enable btrfs integrity check
Date: Wed,  9 Nov 2011 16:17:59 +0100
Message-ID: <3ddcf54087d1d8d146ee7e6f93ba10825dffb9dc.1320850526.git.sbehrens@giantdisaster.de>
References: <cover.1320849129.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1320849129.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Added the BTRFS_FS_CHECK_INTEGRITY option to Kconfig. It depends on
BTRFS_FS.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/Kconfig |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index ecb9fd3..2bb8ba7 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -31,3 +31,36 @@ config BTRFS_FS_POSIX_ACL
 	  Linux website <http://acl.bestbits.at/>.
 
 	  If you don't know what Access Control Lists are, say N
+
+config BTRFS_FS_CHECK_INTEGRITY
+	bool "Btrfs with integrity check tool compiled in (DANGEROUS)"
+	depends on BTRFS_FS
+	help
+	  Adds code that examines all block write requests (including
+	  writes of the super block). The goal is to verify that the
+	  state of the filesystem on disk is always consistent, i.e.,
+	  after a power-loss or kernel panic event the filesystem is
+	  in a consistent state. In order to check this, three rules
+	  are verified:
+	  1. It is not allowed to write a disk block which is
+	     currently referenced by the super block (either directly
+	     or indirectly).
+	  2. When a super block is written, it is verified that all
+	     referenced (directly or indirectly) blocks fulfill the
+	     following requirements:
+	     2a. All referenced blocks have either been present when
+		 the file system was mounted, (i.e., they have been
+		 referenced by the super block) or they have been
+		 written since then and the write completion callback
+		 was called.
+	     2b. All referenced blocks need to have a generation
+		 number which is equal to the parent's number.
+
+	  If the integrity check tool is included and activated in
+	  the mount options, plenty of kernel memory is used, and
+	  plenty of additional CPU cycles are spent. Enabling this
+	  functionality is not intended for normal use.
+
+	  In most cases, unless you are a btrfs developer who needs
+	  to verify the integrity of (super)-block write requests
+	  during the run of a regression test, say N
-- 
1.7.3.4

