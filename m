Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600AbaLJPGx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 10:06:53 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 52A2DAB09
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 15:06:52 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs-progs: let subvol delete print commit mode inline
Date: Wed, 10 Dec 2014 16:06:51 +0100
Message-Id: <47bbff777e73fb392bf84a2a84a3d4d7e7aa2279.1418223710.git.dsterba@suse.cz>
In-Reply-To: <cover.1418223710.git.dsterba@suse.cz>
References: <cover.1418223710.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are options to specify if the subvolume deletion should wait for
commit after each subvol or at the end. This is reported at the
beginning and considered as a noise. We'd like to report the mode for
each subvolume instead.

http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34617.html

Reported-by: Marc MERLIN <marc@merlins.org
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-subvolume.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 53eec467251d..4e452f4f4eb7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -303,7 +303,9 @@ again:
 		goto out;
 	}
 
-	printf("Delete subvolume '%s/%s'\n", dname, vname);
+	printf("Delete subvolume (%s): '%s/%s'\n",
+		sync_mode == 2 || (sync_mode == 1 && cnt + 1 == argc)
+		? "commit" : "no-commit", dname, vname);
 	strncpy_null(args.name, vname);
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 	e = errno;
-- 
2.1.3

