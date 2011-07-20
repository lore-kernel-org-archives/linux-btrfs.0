From: Arne Jansen <sensille@gmx.net>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Wed, 20 Jul 2011 08:55:16 +0200
Message-ID: <4E267BD4.5030200@gmx.net>
References: <1311096438-sup-1263@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311096438-sup-1263@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On 19.07.2011 19:30, Chris Mason wrote:
> Hi everyone,
> 
> I've pushed out a new integration-test branch, and it includes a new
> reader/writer locking scheme for the btree locks.
> 

I rebased my for-chris branch containing the readahead patches for scrub
to your integration-test branch. It had only trivial conflicts.
Hopefully it can go into 3.1 as well.

-Arne

> We've seen a number of benchmarks dominated by contention on the root
> node lock.  This changes our locks into a simple reader/writer lock.
> They are based on mutexes so that we still take advantage of the mutex
> adaptive spins for write locks (rwsemaphores were much slower).
> 
> I'm also sending the individual commits, please do take a look.
> 
> -chris

