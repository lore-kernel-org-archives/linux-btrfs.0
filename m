Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab3KLQ7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 11:59:24 -0500
Date: Tue, 12 Nov 2013 17:59:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 03/17] btrfs: Add high priority workqueue support for
 btrfs_workqueue_struct
Message-ID: <20131112165923.GE9132@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1383803527-23736-4-git-send-email-quwenruo@cn.fujitsu.com>
 <20131107164134.GJ16662@twin.jikos.cz>
 <527C35EC.8000307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <527C35EC.8000307@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 08, 2013 at 08:53:00AM +0800, Qu Wenruo wrote:
> On Thu, 7 Nov 2013 17:41:34 +0100, David Sterba wrote:
> >On Thu, Nov 07, 2013 at 01:51:53PM +0800, Qu Wenruo wrote:
> >>@@ -753,6 +754,19 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
> >>  		}
> >>  	}
> >>+	if (high_name) {
> >>+		ret->high_wq = alloc_workqueue(high_name,
> >>+					       flags | WQ_HIGHPRI,
> >>+					       max_active);
> >I'd really like to add the btrfs- prefix of the workqueue. Quoting our
> >previous discussion:
> Sorry, I forgot to add the "btrfs-" prefix.
> But on the other hand, I prefer to add the prefix outside the
> alloc_btrfs_workqueue,
> which means change the strings passed to alloc_btrfs_workqueue.
> (Maybe add a small macro?)
> 
> Which way do you prefer?

It's actually quite simple, alloc_workque takes a printk format string,
so:

	alloc_workqueue("%s-%s", flags, max_active, "btrfs", name);

but I consider the following to be harder to get around.

> >>>* the thread names lost the btrfs- prefix, this makes it hard to
> >>>    identify the processes and we want this, either debugging or
> >>>    performance monitoring
> >>Yes, that's right.
> >>But the problem is, even I added "btrfs-" prefix to the wq,
> >>the real work executor is kernel workers without any prefix.
> >>Still hard to debugging due to the workqueue mechanism.
> >AFAICS the string passed down to alloc_workqueue ends up in the process
> >name, this is what I'm expecing and don't understand what do you mean.
> >
> Sorry for the misunderstanding words.
> What I mean is that, since we use the kernel workqueue,
> there will be no kthread named the "btrfs-worker" or something like it.
> (Only when WQ_MEM_RECLAIM is set, the rescuer kthread will have the name,
> See kernel/workqueue.c if(flags & WQ_MEM_RECLAIM) para).

You're right, I was not aware of that, and actually checked the
workqueus that have the MEM_RECLAIM bit set. Most of the btrfs IO
workers will have to have this bit set, there are some of them that do
not need it (scrub or readahead).

> The real executor will be something like kworker/u8:6(Unbound workqueue),
> so even the prefix is added, it's still harder than the original way to
> debug workqueue.

Right, the question is if we really need it that way. We can set the
MEM_RECLAIM bit but it looks like an abuse of the interface.

> What makes it worse is that, to simulate the thresholding and ordering,
> I added serveral helper functions, which even makes kernel tracing not so
> meaningful(all function queued to workqueue will all be normal_helper or
> ordered_helper).

That's a valid concern. Can we extend the tracepoints to keep the
btrfs-worker name?

So, as a first step, we can add MEM_RECLAIM to all threads, this should
do the conversion close to the current state. Next we can start tuning the
workqueue flags. This is an internal change, should be safe to do later.


david
