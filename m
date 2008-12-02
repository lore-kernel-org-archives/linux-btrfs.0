From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Weak Allocation
Date: Tue, 2 Dec 2008 08:47:07 +0000
Message-ID: <1228207627.11085.2.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I presume that in the design of BTRFS, like most other filesystems, a
block on the underlying storage is either allocated (ie. to store
metadata or file data), or deallocated (possibly blank or containing
garbage left over, but the contents are irrelivant).

Does BTRFS have any system that could allow adding at a later point in
time a feature which would allow "weak" allocation of blocks, by which I
mean the block is allocated (ie. storing useful data), but if another
file needs to be written which has a higher priority and there are 
no/not many alternate blocks readily available for use then the data
will be replaced.

I could forsee uses for features like that as a cache - for example my
web browsing cache is not vital data, and as such doesn't need to use up
disk space, but it might as well use up any disk space that would
otherwise go unused.  The cache data can always be regenerated, so
loosing the data isn't a problem.

Other uses of the feature could be for persistant network caches (ie. to
store copies of remote files on the network can they can be accessed
faster locally), but again the cache data isn't critical to the
operation of the system, so could be stored in "weakly allocated"
blocks.  Further uses could be caches of compressed files (decompressed
versions of the same files are also saved in other blocks, and depending
on IO and CPU load either the compressed or decompressed version is
used).

>From a user-land perspective, these files could be created with a
special flag which specifies they are only "weakly allocated", which
means any time the file has no open file descriptors it could "vanish"
if the underlying filesystem wants to use the space it occupies for
something else.  A file could have a "priority" value which specifies
how important it is, and therefore how likely it is to be erased if a
new block needs to be allocated.  The block allocator would use this
information, together with the physical layout of the data to decide
where to place new data to avoid fragmentation while retaining possibly
useful data for future use.

Let me know your ideas on this - at the moment it's only an idea, but
I'm interested to know if a) it would be possible to implement it into a
complex filesystem like btrfs, and b) if it would prove useful if
implemented.

Thanks
Oliver.

PS.  I realise this could be implemented with a user space daemon which
polls available disk space and deletes caches when disk space gets low
(as windows does with shadow copies), but that hardly seems ideal, since
it can't intelligently choose which caches to delete to reduce
fragmentation, and large sudden disk allocations will fail.

