From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: move extra checks under debug option in btrfs_search_slot
Date: Fri,  3 Jun 2011 14:09:51 +0200
Message-ID: <1307102991-18308-1-git-send-email-dsterba@suse.cz>
References: <1307101404-15199-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>,
	Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307101404-15199-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

CC: Josef Bacik <josef@redhat.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

this patch is in conflict with josef's patch

http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-work.git;a=commit;h=98cdd9ffc5da7aa4c516347f7fc8f65cb08df6ae

 fs/btrfs/ctree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b0e18d9..4fe7634 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1648,9 +1648,11 @@ again:
 		}
 cow_done:
 		BUG_ON(!cow && ins_len);
+#ifdef CONFIG_BTRFS_DEBUG
 		if (level != btrfs_header_level(b))
 			WARN_ON(1);
 		level = btrfs_header_level(b);
+#endif
 
 		p->nodes[level] = b;
 		if (!p->skip_locking)
-- 
1.7.5.2.353.g5df3e

