Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab3F0CXn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 22:23:43 -0400
Date: Wed, 26 Jun 2013 19:23:41 -0700
From: Zach Brown <zab@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130627022341.GE10265@lenny.home.zabbo.net>
References: <1372219371-15668-1-git-send-email-bo.li.liu@oracle.com>
 <20130626201829.GA10265@lenny.home.zabbo.net>
 <20130627014001.GB19614@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130627014001.GB19614@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > But in the krealloc() case the rb_erase() will be trying to reference
> > freed memmory because krealloc() frees the old pointer on success.
> 
> Yeah, I realize that you're absolutely right, but my box
> didn't complain about the abused old pointers when we're not in int_nodes
> case, which is weird...

The freed space probably just hasn't been reused yet.  Have you tried
with CONFIG_DEBUG_PAGEALLOC or CONFIG_DEBUG_SLAB?

> > Yeah, it's insane, but no more so than using krealloc() for an array
> > with internal pointers in the first place.
> 
> I doubt if it can work, I'd prefer the re-insert dance.

It should, but it is a disgusting hack.  Not worth it if you can't get
it going.

Re-initializing the nodes instead of removing them after they're moved
should work.

But really, this is all bonkers.  A ulist implementation that doesn't
require this fixup would be better.  Maybe lose the array and have a
simple list_head and slab of allocated structs.  Reliable first,
performant second, presuming there's data to justify it.

- z
