Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32862 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbbDHFeo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 01:34:44 -0400
Received: by paboj16 with SMTP id oj16so103454627pab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 22:34:44 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 3/3] Btrfs: show subvol= and subvolid= in /proc/mounts
Date: Tue,  7 Apr 2015 22:34:02 -0700
Message-Id: <213f0b6a4cffcc82688894b4edbaeb51f8e71137.1428471096.git.osandov@osandov.com>
In-Reply-To: <cover.1428471096.git.osandov@osandov.com>
References: <cover.1428471096.git.osandov@osandov.com>
In-Reply-To: <cover.1428471096.git.osandov@osandov.com>
References: <cover.1428471096.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, userspace has no way to know which subvolume is mounted. But,
now that we're guaranteed to have a meaningful root dentry, we can just
export and use seq_dentry() in btrfs_show_options(). The subvolume ID is
easy to get, so put that in there, too.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 4 ++++
 fs/seq_file.c    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5ab9801..5e14bb6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1193,6 +1193,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",fatal_errors=panic");
 	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
 		seq_printf(seq, ",commit=%d", info->commit_interval);
+	seq_puts(seq, ",subvol=");
+	seq_dentry(seq, dentry, " \t\n\\");
+	seq_printf(seq, ",subvolid=%llu",
+		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	return 0;
 }
 
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 555f821..52b4927 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -538,6 +538,7 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, const char *esc)
 
 	return res;
 }
+EXPORT_SYMBOL(seq_dentry);
 
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
-- 
2.3.5

