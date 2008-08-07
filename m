From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Btrfs v0.16 released
Date: Thu, 07 Aug 2008 11:08:59 +0200
Message-ID: <1218100139.8625.7.camel@twins>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1217962876.15342.33.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-08-05 at 15:01 -0400, Chris Mason wrote:

> * Fine grained btree locking.  The large fs_mutex is finally gone.
> There is still some work to do on the locking during extent allocation,
> but the code is much more scalable than it was.

Cool - will try to find a cycle to stare at the code ;-)

> * Helper threads for checksumming and other background tasks.  Most CPU
> intensive operations have been pushed off to helper threads to take
> advantage of SMP machines.  Streaming read and write throughput now
> scale to disk speed even with checksumming on.

Can this lead to the same Priority Inversion issues as seen with
kjournald?

