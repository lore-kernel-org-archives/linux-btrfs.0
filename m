From: y@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: fix typo 'testeing' -> 'testing'
Date: Tue, 10 May 2011 22:57:29 +0300
Message-ID: <44595.3491529965$1305057334@news.gmane.org>
References: <1305057449-12075-1-git-send-email-y>
Cc: Chris Mason <chris.mason@oracle.com>,
	Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305057449-12075-1-git-send-email-y>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7cd8ab0..72650ce 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1310,7 +1310,7 @@ static int btrfs_set_bit_hook(struct inode *inode,
 
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
-	 * but in this case, we are only testeing for the DELALLOC
+	 * but in this case, we are only testing for the DELALLOC
 	 * bit, which is only set or cleared with irqs on
 	 */
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
@@ -1344,7 +1344,7 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 {
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
-	 * but in this case, we are only testeing for the DELALLOC
+	 * but in this case, we are only testing for the DELALLOC
 	 * bit, which is only set or cleared with irqs on
 	 */
 	if ((state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
-- 
1.7.3.4

