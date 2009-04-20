From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] btrfs: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
Date: Mon, 20 Apr 2009 17:47:25 +0200
Message-ID: <20090420154725.GA14284@lst.de>
References: <20090417083741.GA14933@lst.de> <49E855EB.5010001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49E855EB.5010001@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 17, 2009 at 12:11:55PM +0200, Edward Shishkin wrote:
> Christoph Hellwig wrote:
> >Add support for the standard attributes set via chattr and read vis
> >lsattr.  Currently we store the attributes in the flags value in
> >the btrfs inode, but I wonder whether we should split it into two so
> >that we don't have to keep converting between the two formats.
> >  
> 
> Imho, since inode items are of fixed size, is won't be possible
> to avoid such workarounds like conversion between formats.
> No?

While the inode format is fixed it has 256 spare bits for expansion.
But what I mean with the above is to split the current 64bit flags value
into a a 32 bit internal flags and a 32bit user visible flags value
and store the ioctl flags in the latter.

OTOH every filesystem but extN seem to need some conversion so btrfs
wouldn't be unusual at that.  And the GETFLAGS/SETFLAGS flags value
are pretty ugly anyway as they mix up flags for user visible behaviour
with extN implementation details that shouldn't really need to be
exposed to userspace.

