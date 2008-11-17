From: Josef Bacik <jbacik@redhat.com>
Subject: [DEBUG PATCH] for anybody who gets a panic due to ENOSPC
Date: Mon, 17 Nov 2008 11:01:05 -0500
Message-ID: <20081117160105.GB32763@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

In addition to the patch I sent last week, which should be in the git tree
soonish, please apply this patch and reproduce the problem.  Please note that
you could have very well ran out of space, so if you get the message

space_info has 0 free, is full

then chances are you truly ran out of space.  If it has a value > 0 then thats
probably a problem.  Also please give me the size of the drive you are messing
with and any special mount options you are using, as well as the commands you
are using to reproduce the problem.  Thank you,

Josef

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6eb56a0..93726ae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2981,6 +2989,9 @@ loop_check:
 			*last_ptr = ins->objectid + ins->offset;
 		ret = 0;
 	} else if (!ret) {
+		printk(KERN_ERR "we were searching for %Lu bytes, num_bytes %Lu,"
+		       " loop %d, allowed_alloc %d\n", total_needed, num_bytes,
+		       loop, allowed_chunk_alloc);
 		ret = -ENOSPC;
 	}
 
