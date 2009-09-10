From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Question about back references
Date: Thu, 10 Sep 2009 08:54:44 -0400
Message-ID: <20090910125444.GF5106@think>
References: <4AA2C7E6.40200@eecs.harvard.edu>
 <3d0408630909070241x78f043fdu9bf3f1ddd41a4ddd@mail.gmail.com>
 <4AA6CF37.3090206@eecs.harvard.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yan, Zheng " <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Peter Macko <pmacko@eecs.harvard.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AA6CF37.3090206@eecs.harvard.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 08, 2009 at 05:40:07PM -0400, Peter Macko wrote:
> Thanks! I have a follow up question: Are back references reference
> counted? If so, this should mean that after the file system COWs an
> inode, it must increase the reference counts of its file extent back
> references. Do we know what is the overhead? In the case they are
> not reference counted, how does the system know when to drop the
> reference?

The reference counts live in a tree that is maintained via cow
but not reference counted.

> 
> What are the bookend extents? Is the number of bookend requests in
> the fourth field of a file extent back reference  the number of
> times the extent occurs within the file?

bookends are how we do cow with large extents without needing to read in
the entire large extent.

Picture a large 128MB extent where you want to overwrite 4K in the
middle.  What we do is create two pointers to the original extent, and
then make a new extent for the new 4K mod.  Our pointers end up like
this:

[ old extent part 1 ] [ new 4k extent ] [ old extent part 2 ]

A future mod will be to split and modify the old extent when we know
there aren't any other reference holders on it.  The bookend system
assumes that a given extent is in use by multiple snapshots, where we
aren't allowed to change the actual extent records because it is in use in
other places.

-chris
