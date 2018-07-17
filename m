Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727481AbeGQGqd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 02:46:33 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B9A7AD61
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2018 06:15:36 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: completion: Use _filedir() to replace _btrfs_devs()
Date: Tue, 17 Jul 2018 14:15:31 +0800
Message-Id: <20180717061532.11857-2-wqu@suse.com>
In-Reply-To: <20180717061532.11857-1-wqu@suse.com>
References: <20180717061532.11857-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For developers it's pretty common to call "btrfs check" on a raw image
dump other than real block device.

So current _btrfs_devs() is really making things worse. Use _filedir()
to replace _btrfs_devs() so it can complete any filenames, no matter if
it's just a file or a real block device.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-completion | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/btrfs-completion b/btrfs-completion
index ae683f4ecf61..33830e827977 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -6,9 +6,7 @@
 
 _btrfs_devs()
 {
-	local DEVS
-	DEVS=''; while read dev; do DEVS+="$dev "; done < <(lsblk -pnro name)
-	COMPREPLY+=( $( compgen -W "$DEVS" -- "$cur" ) )
+	_filedir
 }
 
 _btrfs_mnts()
-- 
2.18.0

