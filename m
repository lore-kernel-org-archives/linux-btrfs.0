From: Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: Re: Btrfs TODO
Date: Fri, 10 Apr 2009 12:12:41 +0530
Message-ID: <1239345763.5029.18.camel@subratamodak.linux.ibm.com>
References: <20090409162418.GC20769@unused.rdu.redhat.com>
Reply-To: subrata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, ltp-list <ltp-list@lists.sf.net>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090409162418.GC20769@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Thu, 2009-04-09 at 12:24 -0400, Josef Bacik wrote:
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

We at LTP would be interested in the above. Please let us know your
plans in doing Btrfs testing in any ways you do.

Regards--
Subrata

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
> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

