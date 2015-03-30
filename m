Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33081 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbbC3JCn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 05:02:43 -0400
Received: by pdnc3 with SMTP id c3so169662367pdn.0
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 02:02:42 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Timo Kokkonen <timo.kokkonen@offcode.fi>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] Btrfs: prevent deletion of mounted subvolumes
Date: Mon, 30 Mar 2015 02:02:17 -0700
Message-Id: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before commit bafc9b754f75 ("vfs: More precise tests in d_invalidate"),
d_invalidate() could return -EBUSY when a dentry for a directory had
more than one reference to it. This is what prevented a mounted
subvolume from being deleted, as struct vfsmount holds a reference to
the subvolume dentry. However, that commit removed that case, and later
commits in that patch series removed the return code from d_invalidate()
completely, so we don't get that check for free anymore. So, reintroduce
it in btrfs_ioctl_snap_destroy().

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=93021
Reported-by: Timo Kokkonen <timo.kokkonen@offcode.fi>
Fixes: bafc9b754f75 ("vfs: More precise tests in d_invalidate")
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
This applies to 4.0-rc6. To be honest, I'm not sure that this is the most
correct fix for this bug, but it's equivalent to the pre-3.18 behavior and it's
the best that I could come up with. Thoughts?

 fs/btrfs/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 74609b9..39b0538 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2384,6 +2384,12 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		goto out_dput;
 	}
 
+	spin_lock(&dentry->d_lock);
+	err = dentry->d_lockref.count > 1 ? -EBUSY : 0;
+	spin_unlock(&dentry->d_lock);
+	if (err)
+		goto out_dput;
+
 	mutex_lock(&inode->i_mutex);
 
 	/*
-- 
2.3.4

