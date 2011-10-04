From: David Sterba <dsterba@suse.cz>
Subject: [PATCH, resend for 3.2] btrfs: add CONFIG_BTRFS_DEBUG option
Date: Wed,  5 Oct 2011 00:58:31 +0200
Message-ID: <1317769111-5365-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index ecb9fd3..5601066 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -31,3 +31,13 @@ config BTRFS_FS_POSIX_ACL
 	  Linux website <http://acl.bestbits.at/>.
 
 	  If you don't know what Access Control Lists are, say N
+
+config BTRFS_DEBUG
+	bool "Btrfs debugging support"
+	depends on BTRFS_FS
+	help
+	  Enable run-time debugging support for the btrfs filesystem. This may
+	  enable additional and expensive checks with negative impact on
+	  performance, or export extra information via sysfs.
+
+	  If unsure, say N.
-- 
1.7.6

