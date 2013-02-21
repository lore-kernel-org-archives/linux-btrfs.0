Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:11071 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab3BUPfs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 10:35:48 -0500
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH] Btrfs: fix backref walking race with tree deletions
Date: Thu, 21 Feb 2013 16:35:27 +0100
Message-Id: <1361460927-16355-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com>
References: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a subvolume is removed, we remove the root item from the root tree,
while the tree blocks and backrefs remain for a while. When backref walking
comes across one of those orphan tree blocks, it can find a backref for a
no longer existing root. This is all good, we only must tolerate
__resolve_indirect_ref returning an error and continue with the good refs
found.

Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 04edf69..bd605c8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -352,11 +352,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		err = __resolve_indirect_ref(fs_info, search_commit_root,
 					     time_seq, ref, parents,
 					     extent_item_pos);
-		if (err) {
-			if (ret == 0)
-				ret = err;
+		if (err)
 			continue;
-		}
 
 		/* we put the first parent into the ref at hand */
 		ULIST_ITER_INIT(&uiter);
-- 
1.7.1

