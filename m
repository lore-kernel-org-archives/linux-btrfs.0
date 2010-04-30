From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Updating RAID[56] support
Date: Fri, 30 Apr 2010 21:00:13 +0100
Message-ID: <1272657613.31892.119.camel@macbook.infradead.org>
References: <1272564366.3367.4143.camel@macbook.infradead.org>
	 <20100430183904.GC2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100430183904.GC2223@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2010-04-30 at 14:39 -0400, Josef Bacik wrote:
> > It seems to work, and recovery is successful when I mount the file
> > system with -oro,degraded. But in read-write mode it'll oops (even
> > without the below patch) because it's trying to _write_ to the degraded
> > RAID6. Last time I was testing this, it wouldn't continue to write to
> > that block group; it would allocate a new one which didn't include the
> > missing disk. What changed?
> > 
> 
> Maybe that block group isn't getting marked read only?  I'd need to see the oops
> to know what was going on.  Thanks,

Yes, it's not getting marked read-only. 

All the asynchronicity means that there isn't a clear backtrace. I put
extra checks in different places a few times, and the closest I got was 

WARNING: at fs/btrfs/volumes.c:3913 btrfs_map_bio+0x482/0x6c2 [btrfs]()         
 [<ffffffffa019bbf6>] btrfs_map_bio+0x482/0x6c2 [btrfs]                         
 [<ffffffffa01777c1>] __btree_submit_bio_done+0x16/0x18 [btrfs]                 
 [<ffffffffa0178d2f>] run_one_async_done+0x8d/0x92 [btrfs]                      
 [<ffffffffa019f0c7>] run_ordered_completions+0x73/0xbe [btrfs]    

>From a check for !device->bdev in raid56_parity_write().

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

