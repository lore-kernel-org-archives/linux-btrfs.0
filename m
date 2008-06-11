From: Chris Mason <chris.mason@oracle.com>
Subject: Re: FileSystem level compression support.
Date: Wed, 11 Jun 2008 10:20:34 -0400
Message-ID: <1213194034.10187.224.camel@think.oraclecorp.com>
References: <f058a9c30806110413y39102d33t98cd685f289beb2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30806110413y39102d33t98cd685f289beb2d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-06-11 at 12:13 +0100, Miguel Sousa Filipe wrote:
> Hi there,
> 
> Providing compression and/or encryption at the file system layer has
> proven to be contentious and polemic, at least in the linux kernel
> world.
> 
> However, I would like to probe you guys (specially Chis Mason) about
> your thoughts on the issue.
> I have seen quite a few benchs were compression provides better
> performance, since it reduces the amount of IO.
> It seems to be a cpu/io trade-off. And given that cpu power is more
> easily accessible than fast IO.. it is starting to look a good idea
> that should be more deeply explored.
> 
> Is compression for data on BTRFS a feature that is:
> - completely out of the table - it will not happen at the BTRFS layer
> - considered, but no efforts on developing this feature are planed.
> - considered, and design decisions are contemplating it.. but no code
> yet.. not this soon. (not for 1.0)

Compression is definitely on the table, although it probably won't be in
in until after 1.0 unless someone volunteers.

There are lots of different ways to code compression, and some are much
harder than others.  If you restrict the compression support to only
files small enough to have their data packed into the btree, things get
much much easier.

-chris


