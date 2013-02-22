Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47717 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3BVHgA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 02:36:00 -0500
Date: Fri, 22 Feb 2013 15:34:41 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marios Titas <redneb8888@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: make sure NODATACOW also gets NODATASUM set
Message-ID: <20130222073440.GB12835@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1361478855-5059-1-git-send-email-jbacik@fusionio.com>
 <CAAdM647zVT4uJnZ-iHQky_RC7Lq1GdVYYaxLcEc1+TwRcyxVvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAdM647zVT4uJnZ-iHQky_RC7Lq1GdVYYaxLcEc1+TwRcyxVvQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 01:34:26AM -0500, Marios Titas wrote:
> A few weeks ago I reported a similar bug [1]. It has to do with file
> renaming. Do you think that it is related? This patch doesn't seem to
> help.

Yes, they're related, and I sent you a patch in [1] thread, could you check it?

thanks,
liubo

> 
> [1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21640.html
> 
> On Thu, Feb 21, 2013 at 3:34 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > A user reported hitting the BUG_ON() in btrfs_finished_ordered_io() where we had
> > csums on a NOCOW extent.  This can happen if we have NODATACOW set but not
> > NODATASUM set, which can happen in two cases, either we mount with -o nodatacow
> > and then write into preallocated space, or chattr +C a directory and move a file
> > into that directory.  This patch fixes up those two cases and now we should
> > uniformly have NODATACOW and NODATASUM set always.  Thanks,
> >
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/inode.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 40d49da..5d7ceb5 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -5574,7 +5574,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
> >                 if (btrfs_test_opt(root, NODATASUM))
> >                         BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
> >                 if (btrfs_test_opt(root, NODATACOW))
> > -                       BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
> > +                       BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
> > +                               BTRFS_INODE_NODATASUM;
> >         }
> >
> >         insert_inode_hash(inode);
> > @@ -8069,7 +8070,8 @@ static void fixup_inode_flags(struct inode *dir, struct inode *inode)
> >         struct btrfs_inode *b_inode = BTRFS_I(inode);
> >
> >         if (b_dir->flags & BTRFS_INODE_NODATACOW)
> > -               b_inode->flags |= BTRFS_INODE_NODATACOW;
> > +               b_inode->flags |= BTRFS_INODE_NODATACOW |
> > +                       BTRFS_INODE_NODATASUM;
> >         else
> >                 b_inode->flags &= ~BTRFS_INODE_NODATACOW;
> >
> > --
> > 1.7.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
