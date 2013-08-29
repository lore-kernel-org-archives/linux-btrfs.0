Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59778 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3H2Oid (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 10:38:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3976A9A06A4
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 08:38:33 -0600 (MDT)
Date: Thu, 29 Aug 2013 10:38:31 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Notify caching_thread()s to give up on extent_commit_sem
 when needed.
Message-ID: <20130829143831.GB10591@localhost.localdomain>
References: <CAOcd+r3zDtf3uNs5YOk=9LhGannN2WK-CpF0PQMdrnu58phBiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r3zDtf3uNs5YOk=9LhGannN2WK-CpF0PQMdrnu58phBiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 01:31:05PM +0300, Alex Lyakas wrote:
> caching_thread()s do all their work under read access to extent_commit_sem.
> They give up on this read access only when need_resched() tells them, or
> when they exit. As a result, somebody that wants a WRITE access to this sem,
> might wait for a long time. Especially this is problematic in
> cache_block_group(),
> which can be called on critical paths like find_free_extent() and in commit
> path via commit_cowonly_roots().
> 
> This patch is an RFC, that attempts to fix this problem, by notifying the
> caching threads to give up on extent_commit_sem.
> 
> On a system with a lot of metadata (~20Gb total metadata, ~10Gb extent tree),
> with increased number of caching_threads, commits were very slow,
> stuck in commit_cowonly_roots, due to this issue.
> With this patch, commits no longer get stuck in commit_cowonly_roots.
> 

But what kind of effect do you see on overall performance/runtime?  Honestly I'd
expect we'd spend more of our time waiting for the caching kthread to fill in
free space so we can make allocations than waiting on this lock contention.  I'd
like to see real numbers here to see what kind of effect this patch has on your
workload.  (I don't doubt it makes a difference, I'm just curious to see how big
of a difference it makes.)

> This patch is not indented to be applied, just a request to comment on whether
> you agree this problem happens, and whether the fix goes in the right direction.
> 

So I think we should do 2 things here

1) Make a spin_lock for the caching ctl list.  This is independant of the
purpose of the extent_commit_sem, so we should lock it independantly.

2) Your idea for triggering the caching kthreads to stop what they are doing is
good, but it seems like a waste of effort when we could easily check the
semaphore to see if anybody is waiting on this lock.  So I'm going to rig up a
function in the rwsem library to do this for us, and that way we can do
something like

if (need_resched() || rwsem_is_contended(extent_commit_sem)) {
	drop and resched();
}

and that way we only have to add yet another spin lock to the fs_info for the
caching ctl list and we can avoid this issue.  How does that sound to you?
Thanks,

Josef
