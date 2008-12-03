From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Partial Allocation
Date: Tue, 02 Dec 2008 20:18:20 -0500
Message-ID: <1228267100.2048.2.camel@think.oraclecorp.com>
References: <1228264376.17414.4.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228264376.17414.4.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-03 at 00:32 +0000, Oliver Mattos wrote:
> Hi,
> 
> I presume that in the design of BTRFS, like most other filesystems, a
> block on the underlying storage is either allocated (ie. to store
> metadata or file data), or deallocated (possibly blank or containing
> garbage left over, but the contents are irrelivant).
> 
> Does BTRFS have any system that could allow adding at a later point in
> time a feature which would allow "weak" allocation of blocks, by which I
> mean the block is allocated (ie. storing useful data), but if another
> file needs to be written which has a higher priority and there are not
> many free blocks left, then the data could be replaced.
> 

It could be done, but I would expect that any userland facility that
wanted this kind of feature would want to maintain its own cache.  Files
that disappear tend to confuse all but a very small set of applications.

For now it doesn't have broad enough applications that I'm willing to
code it up before 1.0.  But if you want to dive in, please feel free.

-chris


