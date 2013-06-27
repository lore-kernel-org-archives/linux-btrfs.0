Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26605 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3F0BvS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 21:51:18 -0400
Date: Thu, 27 Jun 2013 09:51:05 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130627015104.GC19614@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372219371-15668-1-git-send-email-bo.li.liu@oracle.com>
 <20130626201829.GA10265@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130626201829.GA10265@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 26, 2013 at 01:18:29PM -0700, Zach Brown wrote:
> On Wed, Jun 26, 2013 at 12:02:51PM +0800, Liu Bo wrote:
> > Several users reported this crash of NULL pointer or general protection,
> > the story is that we add a rbtree for speedup ulist iteration, and we
> > use krealloc() to address ulist growth, and krealloc() use memcpy to copy
> > old data to new memory area, so it's OK for an array as it doesn't use
> > pointers while it's not OK for a rbtree as it uses pointers.
> >
> > So krealloc() will mess up our rbtree and it ends up with crash.
> 
> It's not just krealloc(), the initial memcpy() out of the int_nodes
> array is also buggy.
> 
> > +		/*
> > +		 * krealloc actually uses memcpy, which does not copy rb_node
> > +		 * pointers, so we have to do it ourselves.  Otherwise we may
> > +		 * be bitten by crashes.
> > +		 */
> > +		for (i = 0; i < ulist->nnodes; i++) {
> > +			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
> > +			ret = ulist_rbtree_insert(ulist, &new_nodes[i]);
> > +			BUG_ON(ret);
> > +		}
> 
> This'll work for the int_nodes case where you still have access to the
> old pointers for rb_erase() to reference.
> 
> But in the krealloc() case the rb_erase() will be trying to reference
> freed memmory because krealloc() frees the old pointer on success.
> 
> And all the tree balancing in the deletion and re-insertion dance is
> totally unneeded.  And another f-ing BUG_ON()!
> 
> Just fixup all the pointers:
> 
> 		ptrdiff_t diff = new_nodes - old;
> 		ulist->root.rb_node += diff;
> 		for (i = 0; i < ulist->nnodes; i++) {
> 			ulist->nodes[i].rb_node.rb_left += diff;
> 			ulist->nodes[i].rb_node.rb_left += diff;
> 		}
> 
> Yeah, it's insane, but no more so than using krealloc() for an array
> with internal pointers in the first place.

Well, it doesn't work,

[ 9062.312202] ulist_add_merge: diff 18446612136922603520
[ 9062.312231] general protection fault: 0000 [#1] SMP 

thanks,
liubo
