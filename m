Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51629 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3F0BEN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 21:04:13 -0400
Date: Thu, 27 Jun 2013 09:03:58 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130627010356.GA19614@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372219371-15668-1-git-send-email-bo.li.liu@oracle.com>
 <20130626123821.GM4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130626123821.GM4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 26, 2013 at 08:38:21AM -0400, Josef Bacik wrote:
> On Wed, Jun 26, 2013 at 12:02:51PM +0800, Liu Bo wrote:
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
> >  fs/btrfs/ulist.c |   13 ++++++++++++-
> >  1 files changed, 12 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> > index 7b417e2..69a9c32 100644
> > --- a/fs/btrfs/ulist.c
> > +++ b/fs/btrfs/ulist.c
> > @@ -73,7 +73,6 @@ void ulist_fini(struct ulist *ulist)
> >  	if (ulist->nodes_alloced > ULIST_SIZE)
> >  		kfree(ulist->nodes);
> >  	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
> > -	ulist->root = RB_ROOT;
> 
> Why this change ^^?

Ahh, another finger error...actually I was thinking that this
ulist_fini() will be followed by ulist_init() in ulist_reinit() or just
be freed in ulist_free().

thanks,
liubo
