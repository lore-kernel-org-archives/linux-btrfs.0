From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Odd block-count behaviour
Date: Thu, 17 Jun 2010 05:16:27 -0400
Message-ID: <20100617091627.GJ27466@think>
References: <20100616124730.GA1727@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100616124730.GA1727@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 16, 2010 at 01:47:30PM +0100, Hugo Mills wrote:
>    Hi,
> 
>    I've just been copying large quantities of data from one btrfs
> volume to another, and while watching the progress of the copy, I've
> noticed something odd.
> 
> $ mv source-dir dest-dir
> $ watch du -ms source-dir dest-dir
> 
>    This gives me a count of the size of the source and target
> directories, every 2 seconds. As expected, the size of the source dir
> stays constant, and the size of the destination directory increases.
> Except when it doesn't.
> 
>    Occasionally, while copying, the size of the dest-dir *drops* by
> several (tens of) megabytes. I'm not too worried about this, as it all
> seems to be copying the data OK, but it just seems a bit odd, and was
> wondering of there was a sane explanation for this behaviour.

If the files are small, they can be packed into the metadata btree.  But
this doesn't happen until the file is actually written.

So we start with a worst case estimate on the number of blocks the file
will consume (4k) and then when it is actually written we update the
metadata to reflect the number of blocks it is actually using (maybe 1
or 2).

You can see this with a test:

mkdir testdir
cd testdir
dd if=/dev/zero of=foo bs=512 count=1
du -k .
sync
du -k .

-chris

