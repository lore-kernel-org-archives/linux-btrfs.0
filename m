From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] btrfs: Show discard option in /proc/mounts
Date: Mon, 14 Dec 2009 15:01:12 -0700
Message-ID: <20091214220112.GJ7812@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Christoph's patch e244a0aeb6a599c19a7c802cda6e2d67c847b154 doesn't display
the discard option in /proc/mounts, leading to some confusion for me.
Here's the missing bit.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 752a546..5e5bd29 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -450,6 +450,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",notreelog");
 	if (btrfs_test_opt(root, FLUSHONCOMMIT))
 		seq_puts(seq, ",flushoncommit");
+	if (btrfs_test_opt(root, DISCARD))
+		seq_puts(seq, ",discard");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
 	return 0;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
