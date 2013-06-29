Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21098 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3F2KrD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 06:47:03 -0400
Date: Sat, 29 Jun 2013 18:46:50 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130629104649.GA7849@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372394265-1959-1-git-send-email-bo.li.liu@oracle.com>
 <20130628194314.GH10265@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130628194314.GH10265@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 28, 2013 at 12:43:14PM -0700, Zach Brown wrote:
> On Fri, Jun 28, 2013 at 12:37:45PM +0800, Liu Bo wrote:
> > Several users reported this crash of NULL pointer or general protection,
> > the story is that we add a rbtree for speedup ulist iteration, and we
> > use krealloc() to address ulist growth, and krealloc() use memcpy to copy
> > old data to new memory area, so it's OK for an array as it doesn't use
> > pointers while it's not OK for a rbtree as it uses pointers.
> > 
> > So krealloc() will mess up our rbtree and it ends up with crash.
> > 
> > Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Yeah, this should fix the probem.  Thanks for being persistent.
> 
> Reviewed-by: Zach Brown <zab@redhat.com>
> 
> > +		for (i = 0; i < ulist->nnodes; i++)
> > +			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
> 
> (still twitching over here because this is a bunch of work that achieves
> nothing :))

Hmm, I think that this is necessary for the inline array inside ulist,
so I keep it :)

- liubo
