Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3IPXFt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 19:05:49 -0400
Date: Mon, 16 Sep 2013 16:05:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>, <walken@google.com>, <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-Id: <20130916160547.371b74f91511a42ac263449e@linux-foundation.org>
In-Reply-To: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 30 Aug 2013 10:14:01 -0400 Josef Bacik <jbacik@fusionio.com> wrote:

> Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
> read lock on this rwsem while they scan the extent tree, and if need_resched()
> they will drop the lock and schedule.  The transaction commit needs to take a
> write lock for this rwsem for a very short period to switch out the commit
> roots.  If there are a lot of threads doing this caching operation we can starve
> out the committers which slows everybody out.  To address this we want to add
> this functionality to see if our rwsem has anybody waiting to take a write lock
> so we can drop it and schedule for a bit to allow the commit to continue.
> Thanks,
> 

This sounds rather nasty and hacky.  Rather then working around a
locking shortcoming in a caller it would be better to fix/enhance the
core locking code.  What would such a change need to do?

Presently rwsem waiters are fifo-queued, are they not?  So the commit
thread will eventually get that lock.  Apparently that's not working
adequately for you but I don't fully understand what it is about these
dynamics which is causing observable problems.

> I've cc'ed people who seemed like they may be in charge/familiar with this code,
> hopefully I got the right people.
> 
>  include/linux/rwsem.h |    1 +
>  lib/rwsem.c           |   17 +++++++++++++++++

This will break CONFIG_RWSEM_GENERIC_SPINLOCK=n?

