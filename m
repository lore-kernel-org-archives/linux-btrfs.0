Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59801 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751100AbdEaMzV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 08:55:21 -0400
Date: Wed, 31 May 2017 14:54:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Subject: Re: Debugging Deadlocks?
Message-ID: <20170531125419.GC14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAMp4zn9Qqx_T03-Vn6zZxo3OkTRfWeHrgOkefmc4JdzzfswAyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMp4zn9Qqx_T03-Vn6zZxo3OkTRfWeHrgOkefmc4JdzzfswAyA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 30, 2017 at 09:12:39AM -0700, Sargun Dhillon wrote:
> We've been running BtrFS for a couple months now in production on
> several clusters. We're running on Canonical's 4.8 kernel, and
> currently, in the process of moving to our own patchset atop vanilla
> 4.10+. I'm glad to say it's been a fairly good experience for us. Bar
> some performance issues, it's been largely smooth sailing.

Yay, thanks for the feedback.

> There has been one class of persistent issues that has been plaguing
> our cluster is deadlocks. We've seen a fair number of issues where
> there are some number of background threads and user threads are in
> the process of performing operations where some are waiting to start a
> transaction, and at least one background thread or user thread is in
> the process of committing a transaction. Unfortunately, these
> situations are ending in deadlocks, where no threads are making
> progress.

In such situations, save stacks of all processes (/proc/PID/stack). I
don't want to play terminology here, so by a deadlock I could understand
a system that's making progress so slow that's effectively stuck. This
could happen if the files are freamgented, so eg. traversing extents
takes locks and has a lot of work before it unlocks. Add some extent
sharing and updating references, this adds some points where the threads
just wait.

The stacktraces could give an idea of what kind of hang it is.

> We've talked about a couple ideas internally, like adding the ability
> to timeout transactions, abort commits or start_transactions which are
> taking too long, and adding more debugging to get insights into the
> state of the filesystem. Unfortunately, since our usage and knowledge
> of BtrFS is still somewhat nascent, we're unsure of what is the right
> investment.

There's a kernel-wide hung task detection, but I think a similar
mechanism around just the transaction commits would be useful, as a
debugging option.

There are number of ways how a transaction can be blocked though, so
we'd need to choose the starting point. Extent-related locks, waiting
for writes, other locks, the intenral transactional logic (and possibly
more).

> I'm curious, are other people seeing deadlocks crop up in production
> often? How are you going about debugging them, and are there any good
> pieces of advice on avoiding these for production workloads?

I have seen hangs with kernel 4.9 a while back triggered by a
long-running iozone stress test, but 4.8 was not affected, and 4.10+
worked fine again. I don't know if/which btrfs patches the 'canonical
4.8' kernel has, so this might not be related.

As for deadlocks (double taken lock, lock inversion), I haven't seen
them for a long time. The testing kernels run with lockdep, so we should
be able to see them early. You could try to run turn lockdep on if the
performance penalty is still acceptable for you.  But there are still
cases that lockdep does not cover IIRC, due to the higher-level
semantics of the various btrfs trees and locking of extent buffers.
