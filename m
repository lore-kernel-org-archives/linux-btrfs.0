From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
Date: Thu, 23 Apr 2009 15:56:21 -0400
Message-ID: <1240516581.28015.21.camel@think.oraclecorp.com>
References: <20090417083741.GA14933@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090417083741.GA14933@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-04-17 at 10:37 +0200, Christoph Hellwig wrote:
> Add support for the standard attributes set via chattr and read vis
> lsattr.  Currently we store the attributes in the flags value in
> the btrfs inode, but I wonder whether we should split it into two so
> that we don't have to keep converting between the two formats.
> 
> Remove the btrfs_clear_flag/btrfs_set_flag/btrfs_test_flag macros
> as they were obsfuction the existing code and got in the way of the
> new additions.
> 
> Also add the FS_IOC_GETVERSION ioctl for getting i_generation as it's
> trivial.
> 

Thanks.

> Btw, any idea what the BTRFS_INODE_REDONLY flag is for?  It's a subset
> of the immutable flag, but can't actually be set anywhere from the
> filesystem code.
> 

The ext3 converter sets BTRFS_INODE_READONLY on the ext3 image file.

-chris


