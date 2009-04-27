From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 27 Apr 2009 09:37:28 -0400
Message-ID: <1240839448.26451.13.camel@think.oraclecorp.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-04-27 at 05:33 +0200, Thomas Glanzmann wrote:
> Hello,
> I would like to know if it would be possible to implement the following
> feature in btrfs:
> 
> Have an online filesystem check which accounts for possible duplicated
> data blocks (maybe with the help of already implemented checksums: Are
> these checksums for the whole file or block based?) and de duplicate
> these blocks?

There is a btrfs ioctl to clone individual files, and this could be used
to implement an online dedup.  But, since it is happening from userland,
you can't lock out all of the other users of a given file.

So, the dedup application would be responsible for making sure a given
file was not being changed while the dedup scan was running.

-chris


