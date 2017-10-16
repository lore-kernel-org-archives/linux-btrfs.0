Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48469 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753539AbdJPPDt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 11:03:49 -0400
Date: Mon, 16 Oct 2017 17:02:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/21] btrfs: move extent_op cleanup to a helper
Message-ID: <20171016150202.GU3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-10-git-send-email-jbacik@fb.com>
 <762cd1c0-2a51-847d-5dbb-1ba8e7952b70@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <762cd1c0-2a51-847d-5dbb-1ba8e7952b70@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 05:05:19PM +0300, Nikolay Borisov wrote:
> 
> 
> On 29.09.2017 22:43, Josef Bacik wrote:
> > Move the extent_op cleanup for an empty head ref to a helper function to
> > help simplify __btrfs_run_delayed_refs.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/extent-tree.c | 77 ++++++++++++++++++++++++++------------------------
> >  1 file changed, 40 insertions(+), 37 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index f356b4a66186..f4048b23c7be 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2587,6 +2587,26 @@ unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> >  	btrfs_delayed_ref_unlock(head);
> >  }
> >  
> > +static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> > +			     struct btrfs_fs_info *fs_info,
> 
> Do we really need the fs_info as a separate argument, since we can
> obtain it from trans->fs_info, admittedly this would require refactoring
> run_delayed_extent_op as well? Looking at the other patches which
> simplify delayed refs there are numerous function which take both a
> transaction and a fs_info. Is there a case where trans' fs_info is not
> the same as the fs_info based, I'd say no?

I've noticed the trans/fs_info redundancy, but it does not seem
important enough compared to the non-trivial changes the patch does. The
function group (eg. run_delayed_extent_op) uses both trans/fs_info so it
conforms to the current use. I'd suggest to do the argument cleanup
later, once the delayed ref series is merged.

Historically the fs_info pointer was not in transaction, so it had to be
passed separately and many functions do that. There are some exceptions
when transaction could be NULL.

For all internal helpers it would be good to use just trans and reuse
fs_info from there. Functions that represent an API for other code, like
when transaction commit calls to delayed refs, it may look better when
there are both trans and fs_info. This should be decided case by case.
