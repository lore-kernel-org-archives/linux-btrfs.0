Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43223 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3IQGx2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 02:53:28 -0400
Date: Tue, 17 Sep 2013 08:53:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        walken@google.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-ID: <20130917065324.GA20661@gmail.com>
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
 <20130916160547.371b74f91511a42ac263449e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130916160547.371b74f91511a42ac263449e@linux-foundation.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 30 Aug 2013 10:14:01 -0400 Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > Btrfs uses an rwsem to control access to its extent tree.  Threads 
> > will hold a read lock on this rwsem while they scan the extent tree, 
> > and if need_resched() they will drop the lock and schedule.  The 
> > transaction commit needs to take a write lock for this rwsem for a 
> > very short period to switch out the commit roots.  If there are a lot 
> > of threads doing this caching operation we can starve out the 
> > committers which slows everybody out.  To address this we want to add 
> > this functionality to see if our rwsem has anybody waiting to take a 
> > write lock so we can drop it and schedule for a bit to allow the 
> > commit to continue. Thanks,
> 
> This sounds rather nasty and hacky.  Rather then working around a 
> locking shortcoming in a caller it would be better to fix/enhance the 
> core locking code.  What would such a change need to do?
> 
> Presently rwsem waiters are fifo-queued, are they not?  So the commit 
> thread will eventually get that lock.  Apparently that's not working 
> adequately for you but I don't fully understand what it is about these 
> dynamics which is causing observable problems.

It would be nice to see the whole solution, together with the btrfs patch.

The problem I have is that this new primitive is only superficially like 
spin_is_contended(): in the spinlock case dropping the lock will guarantee 
some sort of progress, because another CPU will almost certainly pick up 
the lock if we cpu_relax().

In the rwsem case there's no such guarantee of progress, especially if a 
read-lock is dropped. So I'd like to see how it's implemented in practice.

Thanks,

	Ingo
