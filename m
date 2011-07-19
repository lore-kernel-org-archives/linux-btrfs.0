From: Chris Mason <chris.mason@oracle.com>
Subject: new metadata reader/writer locks in integration-test
Date: Tue, 19 Jul 2011 13:30:22 -0400
Message-ID: <1311096438-sup-1263@shiny>
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've pushed out a new integration-test branch, and it includes a new
reader/writer locking scheme for the btree locks.

We've seen a number of benchmarks dominated by contention on the root
node lock.  This changes our locks into a simple reader/writer lock.
They are based on mutexes so that we still take advantage of the mutex
adaptive spins for write locks (rwsemaphores were much slower).

I'm also sending the individual commits, please do take a look.

-chris
