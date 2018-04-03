Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60415 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbeDCSQB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:16:01 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] btrfs: add SPDX header to Kconfig
Date: Tue,  3 Apr 2018 20:13:32 +0200
Message-Id: <02c93560f5566c0c923630ee1f390ff5e2cade9d.1522778802.git.dsterba@suse.com>
In-Reply-To: <cover.1522778802.git.dsterba@suse.com>
References: <cover.1522778802.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 167e5dc7eadd..23537bc8c827 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 config BTRFS_FS
 	tristate "Btrfs filesystem support"
 	select LIBCRC32C
-- 
2.16.2

