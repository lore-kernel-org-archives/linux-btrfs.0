Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38273 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163044Ab3DFAUa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 20:20:30 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DF8397C0694
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2013 18:20:29 -0600 (MDT)
Date: Fri, 5 Apr 2013 20:20:27 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How are userspace & kernelspace kept in sync?
Message-ID: <20130406002027.GS1876@localhost.localdomain>
References: <515F54D8.4050903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <515F54D8.4050903@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 05, 2013 at 04:48:56PM -0600, Eric Sandeen wrote:
> One thing led to another in poking around the code, and I realized
> that while userspace has lots of code copied from the kernel, it
> was last copied in 2008, in many cases.  ;)
> 
> What's the plan here, how are userspace & kernelspace to be kept
> in sync?
> 
> New features fairly obviously hit both, but what about bugfixes
> that hit one codebase or the other?
> 
> Is it clear (to anyone) which code needs to be synced?
> 
> Should it be done as a wholesale sync-up/rebase from time to
> time, or should commits be merged from one to the other?
>

So having just had to bring back part of the free space cache code I'd say we
just cherry pick stuff since it is a huge pain to just copy it over, especially
when you start talking about the extent buffer stuff.  If maybe we could
seperate out the really kernel specific stuff (like the stuff that does the
reading/writing or interfaces with vfs) and the btrfs specific stuff then maybe
it would be good to keep them in sync.  But honestly I think the core stuff is
pretty solid right now so cherry-picking is probably our better bet.  Thanks,

Josef 
