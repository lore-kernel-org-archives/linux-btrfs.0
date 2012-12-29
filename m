Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47350 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2L2PJ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 10:09:27 -0500
Date: Sat, 29 Dec 2012 23:06:33 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, Slava Barinov <rayslava@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: reset path lock state to zero
Message-ID: <20121229150632.GA7874@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1356687199-7198-1-git-send-email-bo.li.liu@oracle.com>
 <CAKcLGm_jZuzHwA=MBxakLPz+hwoDeFd0TXjg_TtbEvWB+jkfwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm_jZuzHwA=MBxakLPz+hwoDeFd0TXjg_TtbEvWB+jkfwA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 28, 2012 at 12:32:25PM -0600, Mitch Harder wrote:
> On Fri, Dec 28, 2012 at 3:33 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > We forgot to reset the path lock state to zero after we unlock the path block,
> > and this can lead to the ASSERT checker in tree unlock API.
> >
> > Reported-by: Slava Barinov <rayslava@gmail.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/extent-tree.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 521e9d4..a71d457 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -6788,11 +6788,13 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
> >                                                        &wc->flags[level]);
> >                         if (ret < 0) {
> >                                 btrfs_tree_unlock_rw(eb, path->locks[level]);
> > +                               path->locks[level] = 0;
> >                                 return ret;
> >                         }
> >                         BUG_ON(wc->refs[level] == 0);
> >                         if (wc->refs[level] == 1) {
> >                                 btrfs_tree_unlock_rw(eb, path->locks[level]);
> > +                               path->locks[level] = 0;
> >                                 return 1;
> >                         }
> >                 }
> > --
> > 1.7.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> This patch seems to clear a lock WARNING I've been seeing recently.
> 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21692
> 
> I'm unable to generate the WARNING after applying this patch.

Good, they are related judging from your stack info :)

thanks,
liubo
> 
> Thanks.
