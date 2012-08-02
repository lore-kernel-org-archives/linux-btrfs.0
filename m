Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62997 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2HBXQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 19:16:31 -0400
Received: by weyx8 with SMTP id x8so47314wey.19
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2012 16:16:29 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH] Btrfs: remove mnt_want_write call in btrfs_mksubvol
Date: Fri,  3 Aug 2012 01:16:20 +0200
Message-Id: <1343949380-15398-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We got a recursive lock in mksubvol because the caller already held
a lock. I think we got into this due to a merge error. Commit a874a63
removed the mnt_want_write call from btrfs_mksubvol and added a
replacement call to mnt_want_write_file in btrfs_ioctl_snap_create_transid.
Commit e7848683 however tried to move all calls to mnt_want_write above
i_mutex. So somewhere while merging this, it got mixed up. The
solution is to remove the mnt_want_write call completely from
mksubvol.

Reported-by: David Sterba <dave@jikos.cz>
Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/ioctl.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 00ddf22..9df50fa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -664,10 +664,6 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	struct dentry *dentry;
 	int error;
 
-	error = mnt_want_write(parent->mnt);
-	if (error)
-		return error;
-
 	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
 
 	dentry = lookup_one_len(name, parent->dentry, namelen);
@@ -703,7 +699,6 @@ out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&dir->i_mutex);
-	mnt_drop_write(parent->mnt);
 	return error;
 }
 
-- 
1.7.10.4

