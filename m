From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ?Understanding metadata efficiency of btrfs
Date: Tue, 6 Mar 2012 21:25:48 +0000 (UTC)
Message-ID: <pan.2012.03.06.21.25.47@cox.net>
References: <F728B049-9007-4FA6-B75B-0249A472E40C@gmail.com>
	<pan.2012.03.06.05.30.23@cox.net> <20120306112957.GJ4481@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 06 Mar 2012 11:29:58 +0000 as excerpted:

> The "in-memory buffer" is simply the standard Linux block layer and FS
> cache: When a piece of metadata is searched for, btrfs walks down the
> relevant tree, loading each tree node (a 4k page) in turn, until it
> finds the metadata. Unless there is a huge amount of memory pressure,
> Linux's block cache will hang on those blocks in RAM.
> 
>    btrfs can then modify those blocks as much as it likes, in RAM, as
> userspace tools request those changes to be made (e.g. writes, deletes,
> etc). By the CoW nature of the FS, modifying a metadata block will also
> require modification of the block above it in the tree, and so on up to
> the top of the tree. If it's all kept in RAM, this is a fast operation,
> since the trees aren't usually very deep(*).
> 
>    At regular intervals (30s), the btrfs code will ensure that it has
> a consistent in-memory set of blocks, and flushes those dirty blocks to
> disk, ensuring that they're moved from the original location. It does so
> by first writing all of the tree data, sending down disk flush commands
> to ensure that the data gets to disk reliably, and then writing out new
> copies of the superblocks so that they point to the new trees.

Thanks for this and the (snipped) rest.  It's nice to know a bit of 
detail at a level below where I was, tho while it makes sense, I suspect 
it may take reading it more than once to sink in. =:^(  But I expect by 
sticking around I'll get that chance. =:^)

Thanks for the truer checksumming picture as well. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

