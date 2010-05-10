From: Josef Bacik <josef@redhat.com>
Subject: Re: Disk space accounting and subvolume delete
Date: Mon, 10 May 2010 14:50:31 -0400
Message-ID: <20100510185031.GA2453@localhost.localdomain>
References: <20100510182352.GA21154@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100510182352.GA21154@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 10, 2010 at 12:23:52PM -0600, Bruce Guenter wrote:
> Hi.
> 
> When deleting a snapshot, I have observed that the disk space used by
> that snapshot is not immediately released (according to statvfs or df).
> Neither "sync" nor "btrfs filesystem sync" releases the disk space
> neither.  The only way I have found to actually fully release the disk
> space is to issue the sync and then sleep until the statvfs free numbers
> stop changing.
> 
> This is a rather problematic approach to managing disk space.  Is there
> any way to either force a wait until the disk space has been released?
> 
> My application is automatically managing disk space in the presence of
> snapshots.  I allow the disk (a backup) to fill up with snapshots until
> it is nearly full, and then to delete snapshots until I have a threshold
> free.  However, without the disk space being released promptly and no
> way to wait until it is released, the loop can't tell how many snapshots
> to delete.
> 

The way BTRFS's COW works is that we can't free up space until after a
transaction has committed.  After the transaction commits (after a sync) we walk
the list of pinned extents and free them asynchronously.  We could probably make
btrfs filesystem sync wait for that part to finish tho.  It shouldn't be too
hard to do, feel free to take a crack at it.  Thanks,

Josef
