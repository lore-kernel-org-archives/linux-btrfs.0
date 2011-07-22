From: Chris Mason <chris.mason@oracle.com>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Fri, 22 Jul 2011 11:49:15 -0400
Message-ID: <20110722154915.GA15194@shiny>
References: <1311096438-sup-1263@shiny>
 <4E2638A6.2070404@jp.fujitsu.com>
 <1311148631-sup-9551@shiny>
 <4E269379.20405@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E269379.20405@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 20, 2011 at 05:36:09PM +0900, Tsutomu Itoh wrote:
> (2011/07/20 16:58), Chris Mason wrote:
> > Excerpts from Tsutomu Itoh's message of 2011-07-19 22:08:38 -0400:
> >> (2011/07/20 2:30), Chris Mason wrote:
> >>> Hi everyone,
> >>>
> >>> I've pushed out a new integration-test branch, and it includes a new
> >>> reader/writer locking scheme for the btree locks.
> >>>
> >>> We've seen a number of benchmarks dominated by contention on the root
> >>> node lock.  This changes our locks into a simple reader/writer lock.
> >>> They are based on mutexes so that we still take advantage of the mutex
> >>> adaptive spins for write locks (rwsemaphores were much slower).
> >>>
> >>> I'm also sending the individual commits, please do take a look.
> >>
> >> I pulled the new integration-test branch, and I got the following
> >> warning messages.
> >>
> >> Jul 20 10:03:30 luna kernel: ------------[ cut here ]------------
> >> Jul 20 10:03:30 luna kernel: WARNING: at fs/btrfs/extent-tree.c:5704 btrfs_alloc_free_block+0x178/0x340 [btrfs]()
> > 
> > Thanks, I think this one is related to Josef's enospc changes, but I'll
> > double check.  
> 
> >What was the test?
> 
> I ran my original test script. 
> This script concurrently executes the making deletion of a lot of files,
> and the making deletion of a big file, etc. 

I'm having a hard time triggering this with Josef's current patch (after
my rebase).

Could you please send along the reproduction script?

-chris

