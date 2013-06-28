Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39638 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3F1ERT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 00:17:19 -0400
Date: Fri, 28 Jun 2013 12:17:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130628041659.GA32177@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372386339-32599-1-git-send-email-bo.li.liu@oracle.com>
 <51CD02E7.8070608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51CD02E7.8070608@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 28, 2013 at 11:28:39AM +0800, Wang Shilong wrote:
> Hi Liu,
> 
> > Several users reported this crash of NULL pointer or general protection,
> > the story is that we add a rbtree for speedup ulist iteration, and we
> > use krealloc() to address ulist growth, and krealloc() use memcpy to copy
> > old data to new memory area, so it's OK for an array as it doesn't use
> > pointers while it's not OK for a rbtree as it uses pointers.
> > 
> > So krealloc() will mess up our rbtree and it ends up with crash.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: fix an use-after-free bug and a finger error(Thanks Zach and Josef).
> > 
> >  fs/btrfs/ulist.c |   17 +++++++++++++++++
> >  1 files changed, 17 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> > index 7b417e2..adc9aac 100644
> > --- a/fs/btrfs/ulist.c
> > +++ b/fs/btrfs/ulist.c
> > @@ -205,6 +205,10 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
> >  		u64 new_alloced = ulist->nodes_alloced + 128;
> >  		struct ulist_node *new_nodes;
> >  		void *old = NULL;
> > +		int i;
> > +
> > +		for (i = 0; i < ulist->nnodes; i++)
> > +			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
> >  
> >  		/*
> >  		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
> > @@ -224,6 +228,19 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
> >  
> >  		ulist->nodes = new_nodes;
> >  		ulist->nodes_alloced = new_alloced;
> > +
> > +		/*
> > +		 * krealloc actually uses memcpy, which does not copy rb_node
> > +		 * pointers, so we have to do it ourselves.  Otherwise we may
> > +		 * be bitten by crashes.
> > +		 */
> > +		for (i = 0; i < ulist->nnodes; i++) {
> > +			ret = ulist_rbtree_insert(ulist, &ulist->nodes[i]);
> 
> 
> ulist_rbtree_insert() don't allocate memory. if ret!=0 here means a logic error happens.
> In this case, BUG_ON() should be triggered.

My bad, actually I was meant to 'return ret', and it's not for ENOMEM, but for
EEXIST from rbtree insert, and people don't like BUG_ON().

> 
> > +			if (ret) {
> 
> 
> 
> Another thing is if you want to free ulist memory, you can call ulist_free(). Calling kfree()
> directly here is wrong.
> 
> By the way, i notice in ulist_add_merge() we have a possible memory leak:
> if krealloc() fails, we return -ENOMEM directly, this is wrong. ulist_free(ulist) should be called.
> You can fold this into your this patch.

It wouldn't be.  The ulist is passed from callers, and callers are
responsible to free it, which is actually what they're doing(just
checked), and as we have set 'ulist->nodes = new_nodes', I believe it's
all good with just a 'return ret' here.

Actually I'm reworking ulist with just list operation instead of array,
that way we're straight and simple, and don't need such memory
re-allocation dance.

But for now, we need this workaround to get people happy.

> 
> Otherwise, thanks very much for fixing this issue!
> 
> Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Thanks for the quick response :)

thanks,
liubo
