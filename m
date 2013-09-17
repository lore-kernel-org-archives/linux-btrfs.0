Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46427 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3IQBLw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 21:11:52 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A50C69A0697
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 19:11:51 -0600 (MDT)
Date: Mon, 16 Sep 2013 21:11:50 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: David Daney <ddaney.cavm@gmail.com>
CC: Peter Hurley <peter@hurleysoftware.com>, Josef Bacik <jbacik@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <walken@google.com>, <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-ID: <20130917011150.GK2446@localhost.localdomain>
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
 <20130916160547.371b74f91511a42ac263449e@linux-foundation.org>
 <20130917000516.GJ2446@localhost.localdomain>
 <5237A257.1070303@gmail.com>
 <5237A461.3010802@hurleysoftware.com>
 <5237AB9A.1030604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5237AB9A.1030604@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 06:08:42PM -0700, David Daney wrote:
> On 09/16/2013 05:37 PM, Peter Hurley wrote:
> >On 09/16/2013 08:29 PM, David Daney wrote:
> >>On 09/16/2013 05:05 PM, Josef Bacik wrote:
> >>>On Mon, Sep 16, 2013 at 04:05:47PM -0700, Andrew Morton wrote:
> >>>>On Fri, 30 Aug 2013 10:14:01 -0400 Josef Bacik <jbacik@fusionio.com>
> >>>>wrote:
> >>>>
> >>>>>Btrfs uses an rwsem to control access to its extent tree.  Threads
> >>>>>will hold a
> >>>>>read lock on this rwsem while they scan the extent tree, and if
> >>>>>need_resched()
> >>>>>they will drop the lock and schedule.  The transaction commit needs
> >>>>>to take a
> >>>>>write lock for this rwsem for a very short period to switch out the
> >>>>>commit
> >>>>>roots.  If there are a lot of threads doing this caching operation
> >>>>>we can starve
> >>>>>out the committers which slows everybody out.  To address this we
> >>>>>want to add
> >>>>>this functionality to see if our rwsem has anybody waiting to take
> >>>>>a write lock
> >>>>>so we can drop it and schedule for a bit to allow the commit to
> >>>>>continue.
> >>>>>Thanks,
> >>>>>
> >>>>
> >>>>This sounds rather nasty and hacky.  Rather then working around a
> >>>>locking shortcoming in a caller it would be better to fix/enhance the
> >>>>core locking code.  What would such a change need to do?
> >>>>
> >>>>Presently rwsem waiters are fifo-queued, are they not?  So the commit
> >>>>thread will eventually get that lock.  Apparently that's not working
> >>>>adequately for you but I don't fully understand what it is about these
> >>>>dynamics which is causing observable problems.
> >>>>
> >>>
> >>>So the problem is not that its normal lock starvation, it's more our
> >>>particular
> >>>use case that is causing the starvation.  We can have lots of people
> >>>holding
> >>>readers and simply never give them up for long periods of time, which
> >>>is why we
> >>>need this is_contended helper so we know to drop things and let the
> >>>committer
> >>>through.  Thanks,
> >>
> >>You could easily achieve the same thing by putting an "is_contending"
> >>flag in parallel with the rwsem and testing that:
> >
> >Which adds a bunch more bus-locked operations to contended over
> 
> Would that be a problem in this particular case?  Has it been measured?
> 
> >, when
> >a unlocked if (list_empty()) is sufficient.
> 
> I don't object to adding rwsem_is_contended() *if* it is required.  I was
> just pointing out that there may be other options.
> 
> The patch adds a bunch of new semantics to rwsem.  There is a trade off
> between increased complexity of core code, and generalizing subsystem
> specific optimizations that may not be globally useful.
> 
> Is it worth it in this case?  I do not know.
> 

So what you suggested is actually what we did in order to prove that this was
what the problem was.  I'm ok with continuing to do that, I just figured adding
something like rwsem_is_contended() would be nice in case anybody else runs into
the issue in the future, plus it would save me an atomic_t in an already large
structure.  Thanks,

Josef
