Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3CTO3u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 10:29:50 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 26639A4FFA
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2013 15:29:49 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: cover more error codes in btrfs_decode_error
Date: Wed, 20 Mar 2013 15:29:47 +0100
Message-Id: <1363789787-9787-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5f21797..808648f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -81,6 +81,12 @@ static const char *btrfs_decode_error(int errno)
 	case -EEXIST:
 		errstr = "Object already exists";
 		break;
+	case -ENOSPC:
+		errstr = "No space left";
+		break;
+	case -ENOENT:
+		errstr = "No such entry";
+		break;
 	}
 
 	return errstr;
-- 
1.7.9

