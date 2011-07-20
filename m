From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: switch to reader/writer locks for metadata
Date: Tue, 19 Jul 2011 21:13:14 -0400
Message-ID: <1311124334-sup-595@shiny>
References: <1311096777-sup-5422@shiny>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1311096777-sup-5422@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-07-19 13:33:45 -0400:
> Btrfs: switch the btrfs tree locks to reader/writer
> 
> The btrfs metadata btree is the source of significant
> lock contention, especially in the root node.   This
> commit changes our locking to use a reader/writer
> lock.
> 
> The lock is built on top of mutexes, which are much faster
> for dealing with heavy write contention.  We don't try
> very hard to be fair, from a latency point of view
> allowing the readers to come in is very important.
> 
> In read heavy workloads this is dramatically faster.  In write
> heavy workloads we're often faster because of less contention
> on the root node lock.
> 
> We suffer slightly in dbench because we schedule more often
> during write locks.  This still has some adaptive spinning
> in the btrfs code, which I'm trying to get rid of long term.

Hi everyone,

One extra bit is missing from this patch, which is the lockdep
annotations required to keep lockdep happy.  I'll get those out as well,
but if you want to test it, please disable lockdep.

-chris
