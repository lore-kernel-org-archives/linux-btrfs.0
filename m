Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47993 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753140AbdJPO4t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:56:49 -0400
Date: Mon, 16 Oct 2017 16:55:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/21] btrfs: breakout empty head cleanup to a helper
Message-ID: <20171016145502.GT3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-11-git-send-email-jbacik@fb.com>
 <4d8e1482-fe3d-cb1a-6ba0-e5ab6b826af5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d8e1482-fe3d-cb1a-6ba0-e5ab6b826af5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 05:07:21PM +0300, Nikolay Borisov wrote:
> 
> 
> On 29.09.2017 22:43, Josef Bacik wrote:
> > Move this code out to a helper function to further simplivy
> > __btrfs_run_delayed_refs.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/extent-tree.c | 80 ++++++++++++++++++++++++++++----------------------
> >  1 file changed, 45 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index f4048b23c7be..bae2eac11db7 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2607,6 +2607,43 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> >  	return ret ? ret : 1;
> >  }
> >  
> > +static int cleanup_ref_head(struct btrfs_trans_handle *trans,
> > +			    struct btrfs_fs_info *fs_info,
> > +			    struct btrfs_delayed_ref_head *head)
> > +{
> > +	struct btrfs_delayed_ref_root *delayed_refs;
> > +	int ret;
> > +
> > +	delayed_refs = &trans->transaction->delayed_refs;
> > +
> > +	ret = cleanup_extent_op(trans, fs_info, head);
> > +	if (ret < 0) {
> > +		unselect_delayed_ref_head(delayed_refs, head);
> > +		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
> > +		return ret;
> > +	} else if (ret) {
> > +		return ret;
> > +	}
> nit: Omit the { } when there is a single statement after a conditional
> clause.

Unless it's a chain of if / if else / ... / else, then all statements
should use { }
