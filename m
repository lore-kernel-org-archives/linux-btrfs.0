From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 05/12] btrfs: remove useless mutex lock/unlock sequences
Date: Mon, 25 Apr 2011 08:12:59 -0400
Message-ID: <1303733509-sup-4508@think>
References: <cover.1303398927.git.dsterba@suse.cz> <b5fefb09811c22cd101a44ac753293af942087fc.1303398927.git.dsterba@suse.cz> <4DB513F6.6040503@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: David Sterba <dsterba@suse.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DB513F6.6040503@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tsutomu Itoh's message of 2011-04-25 02:25:58 -0400:
> (2011/04/22 18:41), David Sterba wrote:
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> > ---
> >  fs/btrfs/extent-tree.c |    6 ------
> >  1 files changed, 0 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 31f33ba..c97ceab 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -756,8 +756,6 @@ again:
> >  
> >              btrfs_release_path(root->fs_info->extent_root, path);
> >  
> > -            mutex_lock(&head->mutex);
> > -            mutex_unlock(&head->mutex);
> >              btrfs_put_delayed_ref(&head->node);
> >              goto again;
> 
> This code tests whether the mutex_lock can be acquired, and when the
> mutex_lock can be taken, it try again.
> So I think that it is not a meaningless code.

Correct, this code is waiting for the current lock holder to finish.
It's not exactly pretty but it needs to stay.

-chris
