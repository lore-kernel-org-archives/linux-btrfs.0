Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36061 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752688AbeBEIlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 03:41:20 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CDA80ABD9
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Feb 2018 08:41:19 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 2/4] btrfs: Remove btrfs_file_private::trans
Date: Mon,  5 Feb 2018 10:41:14 +0200
Message-Id: <1517820076-13613-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1517820076-13613-1-git-send-email-nborisov@suse.com>
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
 <1517820076-13613-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that the userspace transaction IOCTL have been removed, this member
is no longer used so just remove it

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V2: 
 * This was 3/4 before, but now move it to 2/4 since it makes more sense
 * Reword the subject to be more concise

 fs/btrfs/ctree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6a4752177ad8..dc679246b8e8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1265,7 +1265,6 @@ struct btrfs_root {
 };
 
 struct btrfs_file_private {
-	struct btrfs_trans_handle *trans;
 	void *filldir_buf;
 };
 
-- 
2.7.4

