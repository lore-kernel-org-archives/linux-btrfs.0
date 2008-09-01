From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Transparent compression for Btrfs
Date: Mon, 01 Sep 2008 09:52:52 -0400
Message-ID: <1220277172.6898.18.camel@think.oraclecorp.com>
References: <200809010739.29862.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200809010739.29862.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-09-01 at 07:39 +0530, Balaji Rao wrote:
> Hi,
> 
> For a medium term project, I'm thinking of working on transparent compression 
> for Btrfs. Please give any hints and comments on how we would want to go 
> about this, the features we would like to have and some common pitfalls to 
> avoid.
> 
> Is looking at how it's done in Reiser4, a good idea ? Can we allow the 
> compression algorithm be configurable on a per file basis, may be using an 
> xattr ? This, for example, would allow us to make a compromise between speed 
> and compression ratio.
> 
> Any other ideas welcome.
> 

Actually coding up the compression is fairly simple, the hard part is
making it work in with the rest of the writeback code.  The good news is
the data=ordered mode from v0.16 should make this easier.  There are a
few rules for how writeback works in general:

1) COW rules mean that we only write a block once.  This helps quite a
lot with compression.

2) Delayed allocation and data=ordered pair up, and once a given extent
is recorded in the data=ordered tree, those pages in the file will not
be modified again until the ordered IO is complete.

So, the very natural place to do compression is while
inode.c:cow_file_range is doing btrfs_add_ordered_extent.  You'll
actually want to compress it just before btrfs_reserve_extent is called
so that you know how much space should be reserved on disk.

The basic formula would be:

* allocate pages to hold the compressed result
* compress the data and copy it into those pages
* allocate extents to hold the compressed copy on disk
* checksum the compressed copy
* write the compress copy to disk.

I would suggest that you put the compressed data into an address space
dedicated just to compressed data blocks.  This gives you something to
allocate pages against, but more importantly it gives you a place to
cache the compressed blocks.

In terms of customizing things, I would like the compression algorithm
to be selectable and stored in a field in the inode.  We can make
interfaces for changing the field later.

-chris


