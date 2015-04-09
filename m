Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33453 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbbDIVfb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 17:35:31 -0400
Received: by paboj16 with SMTP id oj16so406258pab.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 14:35:30 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 6/6] Btrfs: show subvol= and subvolid= in /proc/mounts
Date: Thu,  9 Apr 2015 14:34:56 -0700
Message-Id: <229b56bc5f19138a74e92869c22934224575216f.1428614837.git.osandov@osandov.com>
In-Reply-To: <cover.1428614837.git.osandov@osandov.com>
References: <cover.1428614837.git.osandov@osandov.com>
In-Reply-To: <cover.1428614837.git.osandov@osandov.com>
References: <cover.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we're guaranteed to have a meaningful root dentry, we can just
export seq_dentry() and use it in btrfs_show_options(). The subvolume ID
is easy to get and can also be useful, so put that in there, too.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 4 ++++
 fs/seq_file.c    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 80a8047..f334cc4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1193,6 +1193,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",fatal_errors=panic");
 	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
 		seq_printf(seq, ",commit=%d", info->commit_interval);
+	seq_printf(seq, ",subvolid=%llu",
+		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
+	seq_puts(seq, ",subvol=");
+	seq_dentry(seq, dentry, " \t\n\\");
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

