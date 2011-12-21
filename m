From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 2/4] Btrfs: add config option to enable btrfs integrity check
Date: Wed, 21 Dec 2011 19:17:35 +0100
Message-ID: <c975dd469d748ce619c510050d4fb407c2398591.1324491283.git.sbehrens@giantdisaster.de>
References: <cover.1324489705.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1324489705.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1324491283.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Added the BTRFS_FS_CHECK_INTEGRITY option to Kconfig. It depends on
BTRFS_FS.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/Kconfig |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index ecb9fd3..d33f01c 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -31,3 +31,22 @@ config BTRFS_FS_POSIX_ACL
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
+	  in a consistent state.
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

