From: Josef Bacik <josef@redhat.com>
Subject: Re: Updating RAID[56] support
Date: Fri, 30 Apr 2010 14:39:05 -0400
Message-ID: <20100430183904.GC2223@localhost.localdomain>
References: <1272564366.3367.4143.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1272564366.3367.4143.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 29, 2010 at 07:06:06PM +0100, David Woodhouse wrote:
> I've been looking again at the RAID5/RAID6 support, and updated the tree
> at git://git.infradead.org/users/dwmw2/btrfs-raid56.git#merged
> 
> At the moment, we limit writes to a single disk's worth at a time, which
> means we _always_ do the read-calculateparity-write cycle and suffer the
> traditional RAID 'write hole' problem.
> 
> We need to fix the upper layers so that it'll _always_ write a full
> stripe, which Chris has promised to do. When that's done, we can rip out
> the whole raid56_parity_write_partial() and raid_read_end_io() and
> raid_hack_mutex crap.
> 
> But first I needed to actually make the RAID code _cope_ with a full
> stripe at a time, which for some reason I hadn't already done. That's
> what this patch attempts to do.
> 
> (It also sets the stripe size to 4KiB/disk so that we can use it on a
> 4-disk RAID6 and be sure we'll only ever be asked to write either
> precisely one disk's worth as before, or the whole stripe -- I've not
> attempted to make it cope with anything in-between. That's a simple hack
> for short-term testing purposes, which needs to be done in mkfs.btrfs
> too.)
> 
> It seems to work, and recovery is successful when I mount the file
> system with -oro,degraded. But in read-write mode it'll oops (even
> without the below patch) because it's trying to _write_ to the degraded
> RAID6. Last time I was testing this, it wouldn't continue to write to
> that block group; it would allocate a new one which didn't include the
> missing disk. What changed?
> 

Maybe that block group isn't getting marked read only?  I'd need to see the oops
to know what was going on.  Thanks,

Josef
