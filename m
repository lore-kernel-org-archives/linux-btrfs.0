From: David Sterba <dave@jikos.cz>
Subject: [PATCH] btrfs: fix uninitialized variable warning
Date: Fri, 3 Jun 2011 16:50:14 +0200
Message-ID: <20110603145014.GU12709@twin.jikos.cz>
References: <20110603110011.77121203.sfr@canb.auug.org.au>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
	David Sterba <dave@jikos.cz>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	linux-btrfs@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110603110011.77121203.sfr@canb.auug.org.au>
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

With Linus' tree, today's linux-next build (powercp ppc64_defconfig)
produced this warning:

fs/btrfs/delayed-inode.c: In function 'btrfs_delayed_update_inode':
fs/btrfs/delayed-inode.c:1598:6: warning: 'ret' may be used
uninitialized in this function

Introduced by commit 16cdcec736cd ("btrfs: implement delayed inode items
operation").

This fixes a bug in btrfs_update_inode(): if the returned value from
btrfs_delayed_update_inode is a nonzero garbage, inode stat data are not
updated and several call paths may hit a BUG_ON or fail with strange
code.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

patch pushed to git://repo.or.cz/linux-2.6/btrfs-unstable.git #fixes

 fs/btrfs/delayed-inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 01e2950..8cb012f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1595,7 +1595,7 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, struct inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
-	int ret;
+	int ret = 0;
 
 	delayed_node = btrfs_get_or_create_delayed_node(inode);
 	if (IS_ERR(delayed_node))
-- 
1.7.5.2.353.g5df3e
