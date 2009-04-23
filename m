From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] btrfs: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
Date: Thu, 23 Apr 2009 20:01:31 +0200
Message-ID: <20090423180131.GA17835@lst.de>
References: <20090417083741.GA14933@lst.de> <m3vdovo4fc.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3vdovo4fc.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2009 at 10:00:55AM -0400, Chris Ball wrote:
> Hi Christoph,
> 
>    > Add support for the standard attributes set via chattr and read
>    > vis lsattr.  Currently we store the attributes in the flags value
>    > in the btrfs inode, but I wonder whether we should split it into
>    > two so that we don't have to keep converting between the two
>    > formats.
> 
> Any thoughts on how best to add support for setting the custom btrfs
> flags (nodatasum/nodatacow/nocompress) via an ioctl?  Is it possible
> to reuse FS_IOC_SETFLAGS for these too, or do we need a new ioctl?
> If we need a new one, any preference between an ioctl per flag vs.
> a single ioctl that accepts a new set of flags?

I think adding them here is a good idea.  In fact nocompress already
has a flag assigned, I just didn't want to put it in without broader
consultation first as it's not used yet in any mainline code.

