Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55708 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726755AbeIJWYA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:24:00 -0400
Date: Mon, 10 Sep 2018 19:28:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH linux-next] btrfs: btrfs_run_delayed_refs_for_head()
 can be static
Message-ID: <20180910172833.GT24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201809102215.95hxOLVe%fengguang.wu@intel.com>
 <20180910150029.GA11874@lkp-wsm-ep1.lkp.intel.com>
 <20180910164843.GS24025@twin.jikos.cz>
 <7438b39c-dabf-568b-efdb-afef9cd513fd@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7438b39c-dabf-568b-efdb-afef9cd513fd@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2018 at 08:15:18PM +0300, Nikolay Borisov wrote:
> 
> 
> On 10.09.2018 19:48, David Sterba wrote:
> > On Mon, Sep 10, 2018 at 11:00:29PM +0800, kbuild test robot wrote:
> >>
> >> Fixes: ac75a14eb672 ("btrfs: Factor out loop processing all refs of a head")
> >> Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
> >> ---
> >>  extent-tree.c |    6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >> index b0882b6..719f1bb 100644
> >> --- a/fs/btrfs/extent-tree.c
> >> +++ b/fs/btrfs/extent-tree.c
> >> @@ -2537,9 +2537,9 @@ struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
> >>  }
> >>  
> >>  STATIC
> >> -int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
> >> -				    struct btrfs_delayed_ref_head *locked_ref,
> >> -				    unsigned long *run_refs)
> >> +static int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
> >> +					   struct btrfs_delayed_ref_head *locked_ref,
> >> +					   unsigned long *run_refs)
> > 
> > I have a cleanup series to get rid of the STATIC macro, will result in
> > normal 'static' of the function. The patch will need to be updated, you
> > can ignore the warning for now.
> 
> So one added benefit of the STATIC macro (at least in XFS and hence I
> used it here) is that STATIC functions are noinline_for_stack pretty
> much which is why I wanted to use it here. I guess for btrfs we ought to
> use a bare noinline_for_static

Feel free to use noinline_for_static if you see a reason for it. Some
functions are better not inlined so in case the error happen there we
can tell immediatelly from the stack trace. As inlining is a compiler
optimization, I'd rather not force turning it off with some
convenient-looking macro like STATIC.
