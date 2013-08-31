Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3HaOvv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 10:51:51 -0400
Date: Sat, 31 Aug 2013 16:51:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, walken@google.com, mingo@elte.hu,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-ID: <20130831145136.GX31370@twins.programming.kicks-ass.net>
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 10:14:01AM -0400, Josef Bacik wrote:
> Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
> read lock on this rwsem while they scan the extent tree, and if need_resched()
> they will drop the lock and schedule.  The transaction commit needs to take a
> write lock for this rwsem for a very short period to switch out the commit
> roots.  If there are a lot of threads doing this caching operation we can starve
> out the committers which slows everybody out.  To address this we want to add
> this functionality to see if our rwsem has anybody waiting to take a write lock
> so we can drop it and schedule for a bit to allow the commit to continue.


> +/*
> + * check to see if the rwsem we're holding has anybody waiting to acquire it.
> + */
> +int rwsem_is_contended(struct rw_semaphore *sem)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	if (!raw_spin_trylock_irqsave(&sem->wait_lock, flags))
> +		return 1;
> +	if (!list_empty(&sem->wait_list))
> +		ret = 1;
> +	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
> +	return ret;
> +}
> +
> +EXPORT_SYMBOL(rwsem_is_contended);

Modeled after spin_is_contended(), so no problem with that. One thing I
was wondering about is if it wants to be called
rwsem_is_write_contended() or similar, since it explicitly only tests
for pending writers.

