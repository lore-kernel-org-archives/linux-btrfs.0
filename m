Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39118 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3BVKBd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 05:01:33 -0500
Date: Fri, 22 Feb 2013 18:00:16 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marios Titas <redneb8888@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: update inode flags when renaming
Message-ID: <20130222100015.GD12835@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1361520691-22665-1-git-send-email-bo.li.liu@oracle.com>
 <CAAdM645SGn=in2xq-Gv=DBCfpxJvynQEywr5tq7sh=jt-J197A@mail.gmail.com>
 <20130222084034.GC12835@liubo.cn.oracle.com>
 <CAAdM644hwRoGyrJVcmZgEY6S0EMDX4d-ZAQQ550mVi3SYVsYwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAdM644hwRoGyrJVcmZgEY6S0EMDX4d-ZAQQ550mVi3SYVsYwg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 04:10:37AM -0500, Marios Titas wrote:
> You are right, your patch does improve the situation a bit. But it
> still does not address the main issue. To illustrate that, consider
> the following scenario:

Sorry for so much confusion for users.

Please let me explain the following senario, 

> 
> touch test
> chattr +C test
> head -c 1048576 /dev/zero >> test
> mv test test2
> 
> now test2 lost the C flag because it was renamed. But the data in
> test2 was written before it lost the C flag and so the extents do not
> have checksums!
> Also try to clone it with BTRFS_IOC_CLONE. It fails as if it had the C flag:
> 
> cp --reflink test2 test3

We don't clone a file when the src(test2) file has NODATASUM and the dest(test3)
file does not have NODATASUM, or vice versa.  This ensures our checksum's valid.

Here,
*  test2 does has NODATASUM because test has NODATASUM, while
*  test3 is a new created file, and we're not with '-o nodatasum' or
   '-o nodatacow' mount options or we don't chattr test3,
   so test3 does not have NODATASUM flags set.

So 'cp' ends up 'INVALID'.

> 
> OTOH, if you try to clone over a file with NODATACOW then it works:
> 
> touch test3
> chattr +C test3
> cp --reflink test2 test3

Now test3 is with NODATACOW, so the above 'cp' works.

> 
> so the file is in an incosistent state: it sometimes behaves as if it
> had the NODATACOW flag and sometimes as if it didn't.

The C flag refers to NODATACOW, this NODATACOW is used to tell btrfs
if we write the file's data on COW mode.

So the failure of 'clone' does not equal to the file is NODATACOW.

Feel free to correct me.

thanks,
liubo

> 
> Thanks
> 
> On Fri, Feb 22, 2013 at 3:40 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Fri, Feb 22, 2013 at 03:32:50AM -0500, Marios Titas wrote:
> >> Sorry, but the bug persists even with the above patch.
> >>
> >> touch test
> >> chattr +C test
> >> lsattr test
> >> mv test test2
> >> lsattr test2
> >>
> >> In the above scenario test2 will not have the C flag.
> >
> > What do you expect?  IMO it's right that test2 does not have the C flag.
> >
> > This patch ensure that we get the same result after we remount, no more
> > the C flag coming back :)
> >
> > thanks,
> > liubo
> >
> >>
> >> On Fri, Feb 22, 2013 at 3:11 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >> > A user reported some weird behaviours,
> >> > if we move a file with the noCow flag to a directory without the
> >> > noCow flag, the file is now without the flag, but after remount,
> >> > we'll find the file's noCow flag comes back.
> >> >
> >> > This is because we missed a proper inode update after inheriting
> >> > parent directory's flags,
> >> >
> >> > Reported-by: Marios Titas <redneb8888@gmail.com>
> >> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >> > ---
> >> >  fs/btrfs/inode.c |    7 +++++--
> >> >  1 files changed, 5 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> > index d9984fa..d2e3352 100644
> >> > --- a/fs/btrfs/inode.c
> >> > +++ b/fs/btrfs/inode.c
> >> > @@ -7478,8 +7478,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> >> >                                         old_dentry->d_inode,
> >> >                                         old_dentry->d_name.name,
> >> >                                         old_dentry->d_name.len);
> >> > -               if (!ret)
> >> > -                       ret = btrfs_update_inode(trans, root, old_inode);
> >> >         }
> >> >         if (ret) {
> >> >                 btrfs_abort_transaction(trans, root, ret);
> >> > @@ -7514,6 +7512,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> >> >         }
> >> >
> >> >         fixup_inode_flags(new_dir, old_inode);
> >> > +       ret = btrfs_update_inode(trans, root, old_inode);
> >> > +       if (ret) {
> >> > +               btrfs_abort_transaction(trans, root, ret);
> >> > +               goto out_fail;
> >> > +       }
> >> >
> >> >         ret = btrfs_add_link(trans, new_dir, old_inode,
> >> >                              new_dentry->d_name.name,
> >> > --
> >> > 1.7.7.6
> >> >
