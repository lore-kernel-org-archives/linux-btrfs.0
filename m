Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:36546 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496Ab2HXN6q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 09:58:46 -0400
Received: from venice.bhome (151.24.44.165) by smtp207.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 500F3F97057393F1 for linux-btrfs@vger.kernel.org; Fri, 24 Aug 2012 15:58:45 +0200
Subject: [PATCH v1 3/4] Add a new Kconfig section to enable or disable the
 sysfs.
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Fri, 24 Aug 2012 15:59:29 +0200
Message-ID: <20120824135912.20478.28803.stgit@venice.bhome>
In-Reply-To: <20120824135322.20478.88578.stgit@venice.bhome>
References: <20120824135322.20478.88578.stgit@venice.bhome>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support for sysfs to BTRFS. This patch add the Kconfig part to enable
or disable the exporting of teh BTRFS information via sysfs.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 fs/btrfs/Kconfig |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index d33f01c..187e057 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -50,3 +50,12 @@ config BTRFS_FS_CHECK_INTEGRITY
 	  In most cases, unless you are a btrfs developer who needs
 	  to verify the integrity of (super)-block write requests
 	  during the run of a regression test, say N
+
+config BTRFS_FS_SYSFS
+	bool "Btrfs sysfs support"
+	depends on BTRFS_FS
+	help
+	  This options allow to export some btrfs filesystems/devices
+	  properties via the sysfs interface.
+
+

