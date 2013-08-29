Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35659 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3H2UIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 16:08:15 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 55E019A06B0
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 14:08:15 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130829200306.GF10591@localhost.localdomain>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>,
        Lev Vainblat <lev@zadarastorage.com>,
        Shyam Kaushik <shyam@zadarastorage.com>
References: <CAOcd+r0PfcX9Xs9ND8zXui3-YyJh+9THz1qrg7u9DsH1L-uO2g@mail.gmail.com>
 <20130829200306.GF10591@localhost.localdomain>
Message-ID: <20130829200812.30052.29217@localhost.localdomain>
Subject: Re: btrfs:async-thread: atomic_start_pending=1 is set, but it's too late
Date: Thu, 29 Aug 2013 16:08:12 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Josef Bacik (2013-08-29 16:03:06)
> On Mon, Aug 26, 2013 at 05:16:42PM +0300, Alex Lyakas wrote:
> > Greetings all,
> > I see a following issue with spawning new threads for btrfs_workers
> > that have atomic_worker_start set:
> > 
> > # I have BTRFS that has 24Gb of total metadata, out of which extent
> > tree takes 11Gb; space_cache option is not used.
> > # After mouting, cache_block_group() triggers ~250 work items to
> > cache-in the needed block groups.
> > # At this point, fs_info->caching_workers has one thread, which is
> > considered "idle".
> > # Work items start to add to this thread's "pending" list, until this
> > thread becomes considered "busy".
> > # Now workers->atomic_worker_start is set, but
> > check_pending_worker_creates() has not run yet (it is called only from
> > worker_loop), so the same single thread is picked as "fallback".
> > 
> > The problem is that this thread is still running the "caching_thread"
> > function, scanning for EXTENT_ITEMs of the first block-group. This
> > takes 3-4seconds for 1Gb block group.
> > 
> > # Once caching_thread() exits, check_pending_worker_creates() is
> > called, and creates the second thread, but it's too late, because all
> > the 250 work items are already sitting in the first thread's "pending"
> > list. So the  second thread doesn't help at all.
> > 
> > As a result, all block-group caching is performed by the same thread,
> > which, due to one-by-one scanning of EXTENT_ITEMs, takes forever for
> > this BTRFS.
> > 
> > How this can be fixed?
> > - can perhaps check_pending_worker_creates() be called out of
> > worker_loop, e.g., by find_worker()? Instead of just setting
> > workers->atomic_start_pending?
> > - maybe for fs_info->caching_workers we don't have to create new
> > workers asynchronously, so we can pass NULL for async_helper in
> > btrfs_init_workers()? (probably we have to, just checking)
> 
> So I looked at this, and I'm pretty sure we have an async_helper just because of
> copy+paste.  "Hey I want a new async group, let me copy this other one and
> change the name!"  So yes let's just pass NULL here.  In fact the only cases
> that we should be using an async helper is for super critical areas, so I'm
> pretty sure _most_ of the cases that specify an async helper don't need to.
> Chris is this correct, or am I missing something?  Thanks,

No, I think we can just turn off the async start here.

-chris

