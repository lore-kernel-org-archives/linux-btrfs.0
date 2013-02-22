Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33104 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3BVIlv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 03:41:51 -0500
Date: Fri, 22 Feb 2013 16:40:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marios Titas <redneb8888@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: update inode flags when renaming
Message-ID: <20130222084034.GC12835@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1361520691-22665-1-git-send-email-bo.li.liu@oracle.com>
 <CAAdM645SGn=in2xq-Gv=DBCfpxJvynQEywr5tq7sh=jt-J197A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAdM645SGn=in2xq-Gv=DBCfpxJvynQEywr5tq7sh=jt-J197A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 03:32:50AM -0500, Marios Titas wrote:
> Sorry, but the bug persists even with the above patch.
> 
> touch test
> chattr +C test
> lsattr test
> mv test test2
> lsattr test2
> 
> In the above scenario test2 will not have the C flag.

What do you expect?  IMO it's right that test2 does not have the C flag.

This patch ensure that we get the same result after we remount, no more
the C flag coming back :)

thanks,
liubo

> 
> On Fri, Feb 22, 2013 at 3:11 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > A user reported some weird behaviours,
> > if we move a file with the noCow flag to a directory without the
> > noCow flag, the file is now without the flag, but after remount,
> > we'll find the file's noCow flag comes back.
> >
> > This is because we missed a proper inode update after inheriting
> > parent directory's flags,
> >
> > Reported-by: Marios Titas <redneb8888@gmail.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/inode.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index d9984fa..d2e3352 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -7478,8 +7478,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> >                                         old_dentry->d_inode,
> >                                         old_dentry->d_name.name,
> >                                         old_dentry->d_name.len);
> > -               if (!ret)
> > -                       ret = btrfs_update_inode(trans, root, old_inode);
> >         }
> >         if (ret) {
> >                 btrfs_abort_transaction(trans, root, ret);
> > @@ -7514,6 +7512,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> >         }
> >
> >         fixup_inode_flags(new_dir, old_inode);
> > +       ret = btrfs_update_inode(trans, root, old_inode);
> > +       if (ret) {
> > +               btrfs_abort_transaction(trans, root, ret);
> > +               goto out_fail;
> > +       }
> >
> >         ret = btrfs_add_link(trans, new_dir, old_inode,
> >                              new_dentry->d_name.name,
> > --
> > 1.7.7.6
> >
