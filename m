From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Date: Thu, 23 Sep 2010 15:40:01 -0400
Message-ID: <20100923194001.GG25023@think>
References: <4C9AA546.6050201@cesarb.net>
 <20100923123849.8975fe47.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Jens Axboe <jaxboe@fusionio.com>, linux-btrfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, stable@kernel.org,
	Jens Axboe <axboe@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100923123849.8975fe47.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 23, 2010 at 12:38:49PM -0700, Andrew Morton wrote:
> 
> (Cc stable@kernel.org)
> 
> On Wed, 22 Sep 2010 21:54:30 -0300
> Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> 
> > This started appearing for me on v2.6.36-rc5-49-gc79bd89; it did not 
> > happen on v2.6.36-rc5-33-g1ce1e41, probably because it does not have 
> > commit 692ebd17c2905313fff3c504c249c6a0faad16ec which introduces the 
> > warning.

The problem is that btrfs isn't setting the inode bdi on the directory
inode.  I'm digging now to see if this code is right for
blockdevice/special inodes as well.

-chris
