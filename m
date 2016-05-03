Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30228 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbcECXah (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 19:30:37 -0400
Date: Tue, 3 May 2016 16:30:54 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org, master.b.at.raven@chefmail.de
Subject: Re: [PATCH] Btrfs: fix unexpected balance crash due to BUG_ON
Message-ID: <20160503233054.GD21008@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1462230062-8053-1-git-send-email-bo.li.liu@oracle.com>
 <CAHji150s7Ha05biMeNyMSuBRh7eMxj5SR7ezck2D2-PfJTL=WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAHji150s7Ha05biMeNyMSuBRh7eMxj5SR7ezck2D2-PfJTL=WQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 04, 2016 at 01:14:27AM +0200, Holger Hoffstätte wrote:
> On Tue, May 3, 2016 at 1:01 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > Mounting a btrfs can resume previous balance operations asynchronously.
> > An user got a crash when one drive has some corrupt sectors.
> >
> > Since balance can cancel itself in case of any error, we can gracefully
> > return errors to upper layers and let balance do the cancel job.
> >
> > Reported-by: sash <master.b.at.raven@chefmail.de>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/volumes.c | 18 +++++++++++++++---
> >  1 file changed, 15 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index bd0f45f..5aed2e2 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -3418,13 +3418,25 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
> >                 ret = btrfs_shrink_device(device, old_size - size_to_free);
> >                 if (ret == -ENOSPC)
> >                         break;
> > -               BUG_ON(ret);
> > +               if (ret) {
> > +                       /* btrfs_shrink_device never returns ret > 0 */
> > +                       WARN_ON_ONCE(ret > 0);
> > +                       goto error;
> > +               }
> >
> >                 trans = btrfs_start_transaction(dev_root, 0);
> > -               BUG_ON(IS_ERR(trans));
> > +               if (IS_ERR(trans)) {
> > +                       ret = PTR_ERR(trans);
> > +                       goto error;
> > +               }
> >
> >                 ret = btrfs_grow_device(trans, device, old_size);
> > -               BUG_ON(ret);
> > +               if (ret) {
> > +                       btrfs_end_transaction(trans, dev_root);
> > +                       /* btrfs_grow_device never returns ret > 0 */
> > +                       WARN_ON_ONCE(ret > 0);
> > +                       goto error;
> > +               }
> >
> >                 btrfs_end_transaction(trans, dev_root);
> >         }
> 
> Just a heads up that this seems to introduce a valid warning, since it now
> can goto error before the first initializing use of path:
> 
> fs/btrfs/volumes.c: In function 'btrfs_balance':
> fs/btrfs/volumes.c:3601:2: warning: 'path' may be used uninitialized
> in this function [-Wmaybe-uninitialized]
>   btrfs_free_path(path);
>   ^
> fs/btrfs/volumes.c:3385:21: note: 'path' was declared here
>   struct btrfs_path *path;
>                      ^
> (it's really in __btrfs_balance which got inlined, so gcc thinks it's
> at the call site).
> 
> Simply setting path = NULL at the beginning of __btrfs_balance fixes it, since
> btrfs_free_path allows NULL values.

That's right, it's weird that I didn't get this warning while testing it.

Thanks for catching it, Holger.

Thanks,

-liubo
