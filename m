Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbbJVJIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 05:08:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D6D0BAAF4
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 09:08:37 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: add balance filters limits, stripes and usage to supported mask
Date: Thu, 22 Oct 2015 11:07:18 +0200
Message-Id: <1445504838-25196-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enable the extended 'limit' syntax (a range), the new 'stripes' and
extended 'usage' syntax (a range) filters in the filters mask. The patch
comes separate and not within the series that introduced the new filters
because the patch adding the mask was merged in a late rc. The
integration branch was based on an older rc and could not merge the
patch due to the missing changes.

Prerequisities:
* btrfs: check unsupported filters in balance arguments
* btrfs: extend balance filter limit to take minimum and maximum
* btrfs: add balance filter for stripes
* btrfs: extend balance filter usage to take minimum and maximum

Signed-off-by: David Sterba <dsterba@suse.com>
---

 fs/btrfs/volumes.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 90ef3e722b72..6abd2dd346b3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -385,7 +385,10 @@ struct map_lookup {
 	 BTRFS_BALANCE_ARGS_DEVID | 		\
 	 BTRFS_BALANCE_ARGS_DRANGE |		\
 	 BTRFS_BALANCE_ARGS_VRANGE |		\
-	 BTRFS_BALANCE_ARGS_LIMIT)
+	 BTRFS_BALANCE_ARGS_LIMIT |		\
+	 BTRFS_BALANCE_ARGS_LIMIT_RANGE |	\
+	 BTRFS_BALANCE_ARGS_STRIPES_RANGE |	\
+	 BTRFS_BALANCE_ARGS_USAGE_RANGE)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
2.6.2

