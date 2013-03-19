Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3CSLvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 07:51:05 -0400
From: David Sterba <dsterba@suse.cz>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: update kconfig title
Date: Tue, 19 Mar 2013 12:50:59 +0100
Message-Id: <1363693859-26936-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The Kconfig title does not make much sense after the cleanup of
CONFIG_EXPERIMENTAL option, align the wording with other filesystems.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Based on current linus/master and should to to 3.9-rc

 fs/btrfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 9a8622a..4f749c7 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -1,5 +1,5 @@
 config BTRFS_FS
-	tristate "Btrfs filesystem Unstable disk format"
+	tristate "Btrfs filesystem support"
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
-- 
1.8.1.4

