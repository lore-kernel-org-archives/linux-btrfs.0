From: Christoph Hellwig <hch@infradead.org>
Subject: rw_semaphore performance, was: new metadata reader/writer locks in
 integration-test
Date: Fri, 22 Jul 2011 11:01:51 -0400
Message-ID: <20110722150151.GA23686@infradead.org>
References: <1311096438-sup-1263@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel@vger.kernel.org, david@fromorbit.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311096438-sup-1263@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 19, 2011 at 01:30:22PM -0400, Chris Mason wrote:
> We've seen a number of benchmarks dominated by contention on the root
> node lock.  This changes our locks into a simple reader/writer lock.
> They are based on mutexes so that we still take advantage of the mutex
> adaptive spins for write locks (rwsemaphores were much slower).

Interesting.  Do you have set up some artifical benchmarks for this?

I wonder if the lack of adaptive spinning has something to do with the
slightly slower XFS performance on Joern's flash testing, given that
we extensively use the rw_semaphore as the primary I/O mutex, while
all others rely on plain mutexes as the primary synchronization
primitive.
