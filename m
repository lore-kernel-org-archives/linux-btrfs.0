Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:46600 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894Ab2HWMSt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 08:18:49 -0400
Received: from venice.bhome (151.24.44.165) by smtp209.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 500F3F9E01C18AE2 for linux-btrfs@vger.kernel.org; Thu, 23 Aug 2012 14:12:50 +0200
Subject: [PATCH v0 3/4] Add a new Kconfig section to enable or disable the
 sysfs.
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Thu, 23 Aug 2012 14:13:32 +0200
Message-ID: <20120823121323.12203.5136.stgit@venice.bhome>
In-Reply-To: <20120823120505.12203.11658.stgit@venice.bhome>
References: <20120823120505.12203.11658.stgit@venice.bhome>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support for sysfs to BTRFS. This patch add the Kconfig part to enable
or disable the exporting of teh BTRFS information via sysfs.
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

