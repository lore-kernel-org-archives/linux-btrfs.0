Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:42883 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2GBNet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 09:34:49 -0400
Date: Mon, 2 Jul 2012 09:34:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Daniel J Blueman <daniel@quora.org>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Please hammer my for-linus branch
Message-ID: <20120702133446.GD6185@localhost.localdomain>
References: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 01, 2012 at 09:35:01PM -0600, Daniel J Blueman wrote:
> > Hi everyone,
> >
> > I've got a nice set of fixes from Josef, Jan, Ilya and others in my
> > for-linus branch:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> >
> > Some of the changes are fixes for the tree logging code, so I ran some
> > extra crash runs against them Friday night.
> >
> > I ended up with a new crash in the tree log directory deletion replay
> > code, so I didn't send out the pull request to Linus.
> >
> > It isn't clear yet if the new crash is because I was testing differently
> > or if it is a regression.  I'm nailing it down this weekend, but please
> > give my for-linus a shot.
> 
> With this branch (3.4.0), my test has consistently been hitting the
> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID) in
> insert_inline_extent_backref [1]. This is followed by a string of
> other issues [2] and a hard lockup, so I used netconsole to collect
> this.
> 
> I'm preparing my btrfs test for xfstests integration, but can slip you
> it if interested. It hits this case in ~30s.
> 

Can you apply this and capture the output, I have a feeling I know what this is.
Thanks,

Josef

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5775dc4..917ea70 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1766,7 +1766,13 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 					   bytenr, num_bytes, parent,
 					   root_objectid, owner, offset, 1);
 	if (ret == 0) {
-		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
+		if (owner < BTRFS_FIRST_FREE_OBJECTID) {
+			printk(KERN_ERR "bad inline extent, bytenr=%Lu, "
+			       "num_bytes=%Lu, parent=%Lu, root=%Lu, owner=%Lu"
+			       ", offset=%Lu\n", bytenr, num_bytes, parent,
+			       root_objectid, owner, offset);
+			BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
+		}
 		update_inline_extent_backref(trans, root, path, iref,
 					     refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {
