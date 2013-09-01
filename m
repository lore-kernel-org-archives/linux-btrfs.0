Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:47813 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab3IAIch (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 04:32:37 -0400
Received: by mail-qe0-f52.google.com with SMTP id a11so1720859qen.25
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Sep 2013 01:32:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
Date: Sun, 1 Sep 2013 01:32:36 -0700
Message-ID: <CANN689Gz-g=_0ErGkB1WZhJUxg+op2=DAPr3GMYwiXFeT9NmGw@mail.gmail.com>
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
From: Michel Lespinasse <walken@google.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Fri, Aug 30, 2013 at 7:14 AM, Josef Bacik <jbacik@fusionio.com> wrote:
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
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

FYI, I once tried to introduce something like this before, but my use
case was pretty weak so it was not accepted at the time. I don't think
there were any objections to the API itself though, and I think it's
potentially a good idea if you use case justifies it.

Two comments:

- Note that there are two rwsem implementations - if you are going to
add functionality to rwsem.h you want to add the same functionality in
rwsem-spinlock.h as well.

- I would prefer if you could avoid taking the wait_lock in your
rwsem.h implementation. In your use case (read lock is known to be
held), checking for sem->count < 0 would be sufficient to indicate a
writer is queued (or getting onto the queue). In the general case,
some architectures have the various values set up so that
RWSEM_WAITING_BIAS != RWSEM_ACTIVE_WRITE_BIAS - for these
architectures at least, you can check for waiters by looking if the
lowest bit of RWSEM_WAITING_BIAS is set in sem->count.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
