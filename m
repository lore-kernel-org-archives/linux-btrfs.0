Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36370 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3IQAFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 20:05:19 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 669607C06A1
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 18:05:19 -0600 (MDT)
Date: Mon, 16 Sep 2013 20:05:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <walken@google.com>, <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-ID: <20130917000516.GJ2446@localhost.localdomain>
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
 <20130916160547.371b74f91511a42ac263449e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130916160547.371b74f91511a42ac263449e@linux-foundation.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 04:05:47PM -0700, Andrew Morton wrote:
> On Fri, 30 Aug 2013 10:14:01 -0400 Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
> > read lock on this rwsem while they scan the extent tree, and if need_resched()
> > they will drop the lock and schedule.  The transaction commit needs to take a
> > write lock for this rwsem for a very short period to switch out the commit
> > roots.  If there are a lot of threads doing this caching operation we can starve
> > out the committers which slows everybody out.  To address this we want to add
> > this functionality to see if our rwsem has anybody waiting to take a write lock
> > so we can drop it and schedule for a bit to allow the commit to continue.
> > Thanks,
> > 
> 
> This sounds rather nasty and hacky.  Rather then working around a
> locking shortcoming in a caller it would be better to fix/enhance the
> core locking code.  What would such a change need to do?
> 
> Presently rwsem waiters are fifo-queued, are they not?  So the commit
> thread will eventually get that lock.  Apparently that's not working
> adequately for you but I don't fully understand what it is about these
> dynamics which is causing observable problems.
> 

So the problem is not that its normal lock starvation, it's more our particular
use case that is causing the starvation.  We can have lots of people holding
readers and simply never give them up for long periods of time, which is why we
need this is_contended helper so we know to drop things and let the committer
through.  Thanks,

Josef
