Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19352 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab3A0Moy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jan 2013 07:44:54 -0500
Date: Sun, 27 Jan 2013 20:41:55 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com,
        dave@jikos.cz, kitayama@cl.bb4u.ne.jp, miaox@cn.fujitsu.com
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
Message-ID: <20130127124154.GA16722@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
 <CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
 <CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com>
 <20130123075155.GE17162@liubo.jp.oracle.com>
 <CAKcLGm97CSThaz9u0sj8BE=bMGObc6rqCsmzf0AneWfhxfZFDw@mail.gmail.com>
 <20130124005221.GA28406@liubo>
 <CAKcLGm_Casj44A3OL3hpsYAL9szb3-F+8C2fsLow9Trk_y=7dg@mail.gmail.com>
 <20130125154236.GA3997@liubo>
 <CAKcLGm_fyGU3rXKvBfcjQtJDx+1JrbxiDAw1w0EpnPcc2xiHvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm_fyGU3rXKvBfcjQtJDx+1JrbxiDAw1w0EpnPcc2xiHvA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 25, 2013 at 12:16:29PM -0600, Mitch Harder wrote:
[...]
> >>
> >> I've changed up my reproducer to try some things that may hit the
> >> issue quicker and more reliably.
> >>
> >> It gave me a slightly different set of warnings in dmesg, which seem
> >> to suggest issues in the dead_root list.
> >
> > Great!  Many thanks for nail it down, we really shouldn't iput()
> > after btrfs_iget().
> >
> > Could you please try this(remove iput()) and see if it gets us rid of
> > the trouble?
> >
> > thanks,
> > liubo
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 1683f48..c7a0fb7 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -2337,7 +2337,6 @@ out_free_path:
> >  out_unlock:
> >         unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start,
> > lock_end,
> >                              &cached, GFP_NOFS);
> > -       iput(inode);
> >         return ret;
> >  }
> >
> 
> With this patch, the cleaner never runs to delete the old roots.

Hi Mitch,

Many thanks for testing it!

Well, after some debugging, I finally figure out the whys:

(1) btrfs_ioctl_snap_destroy() will free the inode of snapshot and set
root's refs to zero(btrfs_set_root_refs()), if this inode happens to
be the only one in the rbtree of the snapshot's root at this moment,
we add this root to the dead_root list.

(2) Unfortunately, after (1), our snapshot-aware defrag work may read
another inode in this snapshot into memory during 'relink' stage, and
later after we finish relink work and iput() will force us to add the
snapshot's root to the dead_root list again.

So that's why we get double list_add and list_del corruption.

And IMO, it can also take place without snapshot-aware defrag, but it's a
rare case.

So could you please try this? 

thanks,
liubo

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f154946..d4ee66b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -885,7 +885,15 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 int btrfs_add_dead_root(struct btrfs_root *root)
 {
 	spin_lock(&root->fs_info->trans_lock);
+	if (!list_empty(&root->root_list)) {
+		struct btrfs_root *tmp;
+		list_for_each_entry(tmp, &root->fs_info->dead_roots, root_list)
+			if (tmp == root)
+				goto unlock;
+	}
+
 	list_add(&root->root_list, &root->fs_info->dead_roots);
+unlock:
 	spin_unlock(&root->fs_info->trans_lock);
 	return 0;
 }

