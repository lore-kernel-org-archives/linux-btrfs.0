Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbbDTF21 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 01:28:27 -0400
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Date: Mon, 20 Apr 2015 15:27:52 +1000
Subject: [PATCH 1/3] cachefiles: perform test on s_blocksize when opening
 cache file.
Cc: linux-cachefs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <20150420052752.26554.53475.stgit@notabene.brown>
In-Reply-To: <20150420052558.26554.97143.stgit@notabene.brown>
References: <20150420052558.26554.97143.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cachefiles requires that s_blocksize in the cache is not greater than
PAGE_SIZE, and performs the check every time a block is accessed.

Move the test to the place where the file is "opened", where other
file-validity tests are performed.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/cachefiles/namei.c |    2 ++
 fs/cachefiles/rdwr.c  |    6 ------
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 1e51714eb33e..5404afcdee98 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -649,6 +649,8 @@ lookup_again:
 			aops = object->dentry->d_inode->i_mapping->a_ops;
 			if (!aops->bmap)
 				goto check_error;
+			if (object->dentry->d_sb->s_blocksize > PAGE_SIZE)
+				goto check_error;
 
 			object->backer = object->dentry;
 		} else {
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index c6cd8d7a4eef..9bd44ff48cc0 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -414,9 +414,6 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 	ASSERT(inode->i_mapping->a_ops->readpages);
 
 	/* calculate the shift required to use bmap */
-	if (inode->i_sb->s_blocksize > PAGE_SIZE)
-		goto enobufs;
-
 	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
 
 	op->op.flags &= FSCACHE_OP_KEEP_FLAGS;
@@ -711,9 +708,6 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 	ASSERT(inode->i_mapping->a_ops->readpages);
 
 	/* calculate the shift required to use bmap */
-	if (inode->i_sb->s_blocksize > PAGE_SIZE)
-		goto all_enobufs;
-
 	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
 
 	pagevec_init(&pagevec, 0);


