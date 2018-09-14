Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728236AbeINTZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 15:25:10 -0400
Date: Fri, 14 Sep 2018 16:10:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: skip setting path to blocking mode if balance is
 not needed
Message-ID: <20180914141027.GF5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-5-git-send-email-bo.liu@linux.alibaba.com>
 <a66438ea-7da5-a207-d368-70f4072c9958@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a66438ea-7da5-a207-d368-70f4072c9958@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 09:51:33AM +0300, Nikolay Borisov wrote:
> 
> 
> On 12.09.2018 01:06, Liu Bo wrote:
> > balance_level() may return early in some cases, but these checks don't
> > have to be done with blocking write lock.
> > 
> > This puts together these checks into a helper and the benefit is to
> > avoid switching spinning locks to blocking locks (in these paticular
> > cases) which slows down btrfs overall.
> 
> Performance patches without numbers are frowned upon. You need to
> substantiate your claims.
> 
> 
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  fs/btrfs/ctree.c | 41 ++++++++++++++++++++++++++++++-----------
> >  1 file changed, 30 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 858085490e23..ba267a069ca1 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -1758,6 +1758,29 @@ static void root_sub_used(struct btrfs_root *root, u32 size)
> >  	return eb;
> >  }
> >  
> > +static bool need_balance_level(struct btrfs_fs_info *fs_info,
> 
> nit: I think should_balance_level seems more readable, but it could be
> just me so won't insist on that.

Quick grep shows that should_ is used more frequently, so I'd go with
that.
