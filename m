From: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] btrfs: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
Date: Thu, 23 Apr 2009 10:00:55 -0400
Message-ID: <m3vdovo4fc.fsf@pullcord.laptop.org>
References: <20090417083741.GA14933@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090417083741.GA14933@lst.de> (Christoph Hellwig's message of
	"Fri, 17 Apr 2009 10:37:41 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Hi Christoph,

   > Add support for the standard attributes set via chattr and read
   > vis lsattr.  Currently we store the attributes in the flags value
   > in the btrfs inode, but I wonder whether we should split it into
   > two so that we don't have to keep converting between the two
   > formats.

Any thoughts on how best to add support for setting the custom btrfs
flags (nodatasum/nodatacow/nocompress) via an ioctl?  Is it possible
to reuse FS_IOC_SETFLAGS for these too, or do we need a new ioctl?
If we need a new one, any preference between an ioctl per flag vs.
a single ioctl that accepts a new set of flags?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
