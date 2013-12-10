Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26437 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3LJIvw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 03:51:52 -0500
Date: Tue, 10 Dec 2013 16:51:41 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: avoid building inode cache repeatly
Message-ID: <20131210084733.GA8913@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1386581671-4639-1-git-send-email-bo.li.liu@oracle.com>
 <20131209142005.20371.31891@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131209142005.20371.31891@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 09, 2013 at 09:20:05AM -0500, Chris Mason wrote:
> Quoting Liu Bo (2013-12-09 04:34:31)
> > Inode cache is similar to free space cache and in fact shares the same
> > code, however, we don't load inode cache unless we're about to allocate
> > inode id, then there is a case where we only commit the transaction during
> > other operations, such as snapshot creation, we now update fs roots' generation
> > to the new transaction id, after that when we want to load the inode cache,
> > we'll find that it's not valid thanks to the mismatch of generation, and we
> > have to push btrfs-ino-cache thread to build inode cache from disk, and
> > this operation is sometimes time-costing.
> > 
> > So to fix the above, we load inode cache into memory during reading fs root.
> 
> Thanks Liu.  Have you tested this with orphan replay?  I'd like to make
> sure the new ordering of starting caching isn't causing problems with
> finding and processing the orphan items.

I hacked the code with the following change in order to test orphan
replay with inode cache enabled, it's ok on my side on mounting and
using, I'll make some tests to make sure xfstests is ok, too.

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 431ba6f..ba5abd7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3515,7 +3515,7 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 
 	if (delete_item) {
 		atomic_dec(&root->orphan_inodes);
-		if (trans)
+		if (0 && trans)
 			ret = btrfs_del_orphan_item(trans, root,
 						    btrfs_ino(inode));
 	}



I'll be glad if anyone tells me he/she has a better way to test it :)

-liubo
