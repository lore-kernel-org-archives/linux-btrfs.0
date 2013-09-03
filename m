Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38437 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3ICPt3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2013 11:49:29 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 9115C9A0689
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Sep 2013 09:49:29 -0600 (MDT)
Date: Tue, 3 Sep 2013 11:49:27 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <walken@google.com>, <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-ID: <20130903154927.GC15634@localhost.localdomain>
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
 <20130831145136.GX31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130831145136.GX31370@twins.programming.kicks-ass.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 31, 2013 at 04:51:36PM +0200, Peter Zijlstra wrote:
> On Fri, Aug 30, 2013 at 10:14:01AM -0400, Josef Bacik wrote:
> > Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
> > read lock on this rwsem while they scan the extent tree, and if need_resched()
> > they will drop the lock and schedule.  The transaction commit needs to take a
> > write lock for this rwsem for a very short period to switch out the commit
> > roots.  If there are a lot of threads doing this caching operation we can starve
> > out the committers which slows everybody out.  To address this we want to add
> > this functionality to see if our rwsem has anybody waiting to take a write lock
> > so we can drop it and schedule for a bit to allow the commit to continue.
> 
> 
> > +/*
> > + * check to see if the rwsem we're holding has anybody waiting to acquire it.
> > + */
> > +int rwsem_is_contended(struct rw_semaphore *sem)
> > +{
> > +	int ret = 0;
> > +	unsigned long flags;
> > +
> > +	if (!raw_spin_trylock_irqsave(&sem->wait_lock, flags))
> > +		return 1;
> > +	if (!list_empty(&sem->wait_list))
> > +		ret = 1;
> > +	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
> > +	return ret;
> > +}
> > +
> > +EXPORT_SYMBOL(rwsem_is_contended);
> 
> Modeled after spin_is_contended(), so no problem with that. One thing I
> was wondering about is if it wants to be called
> rwsem_is_write_contended() or similar, since it explicitly only tests
> for pending writers.
> 

Well it checks all pending waiters, the waiters list isn't split between
readers waiters and write waiters, so people holding the write lock could call
this to see if readers are waiting on the lock.  Thanks,

Josef
