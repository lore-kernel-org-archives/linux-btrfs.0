From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Fri, 15 Aug 2008 16:37:02 -0400
Message-ID: <1218832622.19495.14.camel@think.oraclecorp.com>
References: <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
	 <1218747656.15342.439.camel@think.oraclecorp.com>
	 <20080814234458.GD13048@mit.edu>
	 <1218762627.15342.447.camel@think.oraclecorp.com>
	 <1218804361.15342.470.camel@think.oraclecorp.com>
	 <20080815134545.GM13048@mit.edu>
	 <1218822772.15342.503.camel@think.oraclecorp.com>
	 <20080815195941.GB22395@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080815195941.GB22395@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-08-15 at 15:59 -0400, Theodore Tso wrote:
> On Fri, Aug 15, 2008 at 01:52:52PM -0400, Chris Mason wrote:
> > Have you tried this one:
> > 
> > http://article.gmane.org/gmane.linux.file-systems/25560
> > 
> > This bug should cause fragmentation on small files getting forced out
> > due to memory pressure in ext4.  But, I wasn't able to really
> > demonstrate it with ext4 on my machine.
> 
> I've been able to use compilebench to see the fragmentation problem
> very easily.
> 
> Annesh has been workign on it, and has some fixes that he queued up.
> I'll have to point him at your proposed fix, thanks.  This is what he
> came up with in the common code.  What do you think?
> 

It sounds like ext4 would show the writeback_index bug with
fragmentation on disk and btrfs would show it with seeks during the
benchmark.  I was only watching the throughput numbers and not looking
at filefrag results.

> 						- Ted
> 
> (From Annesh, on the linux-ext4 list.)
> 
> As I explained in my previous patch the problem is due to pdflush
> background_writeout. Now when pdflush does the writeout we may
> have only few pages for the file and we would attempt
> to write them to disk. So my attempt in the last patch was to
> do the below
>

pdflush and delalloc and raid stripe alignment and lots of other things
don't play well together.  In general, I think we need one or more
pdflush threads per mounted FS so that write_cache_pages doesn't have to
bail out every time it hits congestion.

The current write_cache_pages code even misses easy changes to create
bigger bios just because a block device is congested when called by
background_writeout()

But I would hope we can deal with a single threaded small file workload
like compilebench without resorting to big rewrites

> a) When allocation blocks try to be close to the goal block specified
> b) When we call ext4_da_writepages make sure we have minimal nr_to_write
>   that ensures we allocate all dirty buffer_heads in a single go.
>   nr_to_write is set to 1024 in pdflush background_writeout and that
>   would mean we may end up calling some inodes writepages() with really
>   small values even though we have more dirty buffer_heads.
> 
> What it doesn't handle is
> 1) File A have 4 dirty buffer_heads.
> 2) pdflush try to write them. We get 4 contig blocks
> 3) File A now have new 5 dirty_buffer_heads
> 4) File B now have 6 dirty_buffer_heads
> 5) pdflush try to write the 6 dirty buffer_heads of file B and allocate
> them next to earlier file A blocks
> 6) pdflush try to write the 5 dirty buffer_heads of file A and allocate
> them after file B blocks resulting in discontinuity.
> 
> I am right now testing the below patch which make sure new dirty inodes
> are added to the tail of the dirty inode list
> 
> commit 6ad9d25595aea8efa0d45c0a2dd28b4a415e34e6
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Fri Aug 15 23:19:15 2008 +0530
> 
>     move the dirty inodes to the end of the list
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 25adfc3..91f3c54 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -163,7 +163,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  		 */
>  		if (!was_dirty) {
>  			inode->dirtied_when = jiffies;
> -			list_move(&inode->i_list, &sb->s_dirty);
> +			list_move_tail(&inode->i_list, &sb->s_dirty);
>  		}
>  	}
>  out:

Looks like everyone who walks sb->s_io or s_dirty walks it backwards.
This should make the newly dirtied inode the first one to be processed,
which probably isn't what we want.  I could be reading it backwards of
course ;)

-chris


