From: Chris Mason <chris.mason@oracle.com>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Wed, 20 Jul 2011 13:21:47 -0400
Message-ID: <1311182478-sup-9986@shiny>
References: <1311096438-sup-1263@shiny>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1311096438-sup-1263@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-07-19 13:30:22 -0400:
> Hi everyone,
> 
> I've pushed out a new integration-test branch, and it includes a new
> reader/writer locking scheme for the btree locks.
> 
> We've seen a number of benchmarks dominated by contention on the root
> node lock.  This changes our locks into a simple reader/writer lock.
> They are based on mutexes so that we still take advantage of the mutex
> adaptive spins for write locks (rwsemaphores were much slower).
> 
> I'm also sending the individual commits, please do take a look.

Hi everyone,

I just rebased Josef's enospc fixes into integration-test, it should fix
the warnings in extent-tree.c


-chris
