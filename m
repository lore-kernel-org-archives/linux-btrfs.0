Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37307 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3F0C4K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 22:56:10 -0400
Date: Thu, 27 Jun 2013 10:55:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130627025555.GD19614@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372219371-15668-1-git-send-email-bo.li.liu@oracle.com>
 <20130626201829.GA10265@lenny.home.zabbo.net>
 <20130627014001.GB19614@localhost.localdomain>
 <20130627022341.GE10265@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130627022341.GE10265@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 26, 2013 at 07:23:41PM -0700, Zach Brown wrote:
> > > But in the krealloc() case the rb_erase() will be trying to reference
> > > freed memmory because krealloc() frees the old pointer on success.
> > 
> > Yeah, I realize that you're absolutely right, but my box
> > didn't complain about the abused old pointers when we're not in int_nodes
> > case, which is weird...
> 
> The freed space probably just hasn't been reused yet.  Have you tried
> with CONFIG_DEBUG_PAGEALLOC or CONFIG_DEBUG_SLAB?
> 
> > > Yeah, it's insane, but no more so than using krealloc() for an array
> > > with internal pointers in the first place.
> > 
> > I doubt if it can work, I'd prefer the re-insert dance.
> 
> It should, but it is a disgusting hack.  Not worth it if you can't get
> it going.
> 
> Re-initializing the nodes instead of removing them after they're moved
> should work.
> 
> But really, this is all bonkers.  A ulist implementation that doesn't
> require this fixup would be better.  Maybe lose the array and have a
> simple list_head and slab of allocated structs.  Reliable first,
> performant second, presuming there's data to justify it.

I agree, I'm trying to work it out and will test it with DEBUG_PAGEALLOC ;)

thanks,
liubo
