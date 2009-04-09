From: Ray Van Dolson <rayvd@bludgeon.org>
Subject: Re: Btrfs TODO
Date: Thu, 9 Apr 2009 09:34:54 -0700
Message-ID: <20090409163454.GA1355@bludgeon.org>
References: <20090409162418.GC20769@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090409162418.GC20769@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2009 at 12:24:18PM -0400, Josef Bacik wrote:
> Hello,
> 
> Trying to put together a list of TODO items for btrfs so we can update the wiki
> page fully.  So far these things are on the list
> 
> * Proper ENOSPC handling 
> * O_DIRECT support (without checksumming) 
> * AIO support 
> * Subvolume quotas and inherited space usage information 
> * Snapshot removal
> * QA Suite for automated regression testing 
> * Reserved space for online fsck and the ability to add storage so that a
> * background extent allocation check can proceed 
> * Additional ioctls to set per-inode attributes (nodatacow, nodatasum, etc)
> 
> So I think all of those are still true.  Things that I know are being worked on
> are
> 
> * async block group cacheing - me
> * locking changes - Chris
> * backref stuff - Yan
> 
> Som other things off the top of my head are
> 
> * a better way to cache block groups in general, for this I was thinking of a
> 	bitmap or something like that per block group of free space
> * space balancing.  this will likely need to wait on proper ENOSPC handling
> * grub support :)
> 
> Thats all that I can think of atm.  Add things to the list if you think of them,
> and hopefully we can update the wiki early next week.  Thanks,

Long-term (post 1.0 release I assume):

* Block based deduplication (not file-based) :-)

Ray
