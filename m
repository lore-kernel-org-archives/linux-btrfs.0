Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35062 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdFAAdS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 20:33:18 -0400
Received: by mail-oi0-f44.google.com with SMTP id l18so36124987oig.2
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 17:33:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170531125419.GC14523@twin.jikos.cz>
References: <CAMp4zn9Qqx_T03-Vn6zZxo3OkTRfWeHrgOkefmc4JdzzfswAyA@mail.gmail.com>
 <20170531125419.GC14523@twin.jikos.cz>
From: Sargun Dhillon <sargun@sargun.me>
Date: Wed, 31 May 2017 17:32:37 -0700
Message-ID: <CAMp4zn97mUgGAvn-3iEt9rjL-6hACP8Af24VtCvNnxY7KHSVng@mail.gmail.com>
Subject: Re: Debugging Deadlocks?
To: dsterba@suse.cz, Sargun Dhillon <sargun@sargun.me>,
        BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 31, 2017 at 5:54 AM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, May 30, 2017 at 09:12:39AM -0700, Sargun Dhillon wrote:
>> We've been running BtrFS for a couple months now in production on
>> several clusters. We're running on Canonical's 4.8 kernel, and
>> currently, in the process of moving to our own patchset atop vanilla
>> 4.10+. I'm glad to say it's been a fairly good experience for us. Bar
>> some performance issues, it's been largely smooth sailing.
>
> Yay, thanks for the feedback.
>
>> There has been one class of persistent issues that has been plaguing
>> our cluster is deadlocks. We've seen a fair number of issues where
>> there are some number of background threads and user threads are in
>> the process of performing operations where some are waiting to start a
>> transaction, and at least one background thread or user thread is in
>> the process of committing a transaction. Unfortunately, these
>> situations are ending in deadlocks, where no threads are making
>> progress.
>
> In such situations, save stacks of all processes (/proc/PID/stack). I
> don't want to play terminology here, so by a deadlock I could understand
> a system that's making progress so slow that's effectively stuck. This
> could happen if the files are freamgented, so eg. traversing extents
> takes locks and has a lot of work before it unlocks. Add some extent
 > sharing and updating references, this adds some points where the threads
> just wait.
>
> The stacktraces could give an idea of what kind of hang it is.
>
We're saving a dump of the tasks currently running. A recent dump can
be found here: http://cwillu.com:8080/50.19.255.106/1. This is the
only snapshot I have from a node that's not making any progress.

We also see the other case, where tasks are not making progress very
quickly, and it causes the kernel hung task detector to kick in. This
happens pretty often, and it's difficult to catch when it's happening,
but the symptoms can be frustrating, including failed instance
healthchecks, poor performance, and high latency for interactive
services. Some of the traces we've gotten from the stuck task detector
include:
https://gist.github.com/sargun/9643c0c380d27a147ef3486e1d51dbdb
https://gist.github.com/sargun/8858263b8d04c8ab726738022725ec12


>> We've talked about a couple ideas internally, like adding the ability
>> to timeout transactions, abort commits or start_transactions which are
>> taking too long, and adding more debugging to get insights into the
>> state of the filesystem. Unfortunately, since our usage and knowledge
>> of BtrFS is still somewhat nascent, we're unsure of what is the right
>> investment.
>
> There's a kernel-wide hung task detection, but I think a similar
> mechanism around just the transaction commits would be useful, as a
> debugging option.
>
> There are number of ways how a transaction can be blocked though, so
> we'd need to choose the starting point. Extent-related locks, waiting
> for writes, other locks, the intenral transactional logic (and possibly
> more).
>
As a first step, it'd be nice to have the transaction wrapped in a
stack frame. We can then instrument it much more easily with off the
shelf tools like simple BPF-based kprobes / kretprobes, or ftraces,
rather than having to write a custom probe that's familiar with the
innards of the txn datastructure, and does its own accounting to keep
track of what's in flight.

I'll take a cut at something as simple as an in-memory list of
transactions which is periodically scanned for transactions which are
taking too long, and log whether they're stuck starting, commiting, or
in-flight and uncommitted.

>> I'm curious, are other people seeing deadlocks crop up in production
>> often? How are you going about debugging them, and are there any good
>> pieces of advice on avoiding these for production workloads?
>
> I have seen hangs with kernel 4.9 a while back triggered by a
> long-running iozone stress test, but 4.8 was not affected, and 4.10+
> worked fine again. I don't know if/which btrfs patches the 'canonical
> 4.8' kernel has, so this might not be related.
>
> As for deadlocks (double taken lock, lock inversion), I haven't seen
> them for a long time. The testing kernels run with lockdep, so we should
> be able to see them early. You could try to run turn lockdep on if the
> performance penalty is still acceptable for you.  But there are still
> cases that lockdep does not cover IIRC, due to the higher-level
> semantics of the various btrfs trees and locking of extent buffers.
For some of these use-cases, we can pretty easily recreate the pattern
on the machine. For others, it's more complicated to find out which
containers, and datasets were scheduled to be processed on the
machine. We've run some sanity, and stress tests, but we can rarely
get the filesystem to fall over in a predictable way in these tests
compared to some production workloads.
