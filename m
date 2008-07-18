From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: New data=ordered code pushed out to btrfs-unstable
Date: Fri, 18 Jul 2008 16:09:31 -0400
Message-ID: <4880F87B.7020908@gmail.com>
References: <1216398992.6932.36.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216398992.6932.36.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Hello everyone,
>
> It took me much longer to chase down races in my new data=ordered code,
> but I think I've finally got it, and have pushed it out to the unstable
> trees.
>
> There are no disk format changes included.  I need to make minor mods to
> the resizing and balancing code, but I wanted to get this stuff out the
> door.
>
> In general, I'll call data=ordered any system that prevents seeing stale
> data on the disk after a crash.  This would include null bytes from
> areas not yet written when we crashed and the contents of old blocks the
> filesystem had freed in the past.
>
> The old data=ordered code worked something like this:
>
> file_write: 
> 	* modify pages in page cache
> 	* set delayed allocation bits
> 	* Update in memory and on-disk i_size
>
> writepage:
> 	* collect a large delalloc region
> 	* allocate new extent
> 	* drop existing extents from the metadata
> 	* insert new extent
> 	* start the page io
>
> transaction commit:
> 	* write and wait on any dirty file data to finish
> 	* commit the new btree pointers
>
> The end result was very large latencies during transaction commit
> because it had to wait on all the file data.  A fsync of a single file
> was forced to write out all the dirty metadata and dirty data on the FS.
> This is how ext3 works today, xfs does something smarter.  ext4 is
> moving to something similar to xfs.
>
> With the new code, metadata is not modified in the btree until new
> extents are fully on disk.  It now looks something like this:
>
> file write (start, len):
> 	* wait on pending ordered extents for the start, len range
> 	* modify pages in the page cache
> 	* set delayed allocation bits
> 	* Update in memory only i_size
>
> writepage:
> 	* collect a large delalloc extent
> 	* reserve a extent on disk in the allocation tree
> 	* create an ordered extent record
> 	* start the page io
>
> At IO completion (done in a kthread):
> 	* find the corresponding ordered extent record
> 	* if fully written, remove old extents from the tree,
> 	  add new extents to the tree, update on disk i_size
> 	
> At commit time:
> 	* Just do only metadata IO
>
> The end result of all of this is lower commit latencies and a smoother
> system.
>
> -chris
>   

Just to kick the tires, I tried the same test that I ran last week on 
ext4. Everything was going great, I decided to kill it after 6 million 
files or so and restart.

The unmount has taken a very, very long time - seems like we are 
cleaning up the pending transactions at a very slow rate:

Jul 18 16:06:04 localhost kernel: cleaner awake
Jul 18 16:06:04 localhost kernel: cleaner done
Jul 18 16:06:34 localhost kernel: trans 188 in commit
Jul 18 16:06:35 localhost kernel: trans 188 done in commit
Jul 18 16:06:35 localhost kernel: cleaner awake
Jul 18 16:06:35 localhost kernel: cleaner done
Jul 18 16:07:05 localhost kernel: trans 189 in commit
Jul 18 16:07:06 localhost kernel: trans 189 done in commit
Jul 18 16:07:06 localhost kernel: cleaner awake
Jul 18 16:07:06 localhost kernel: cleaner done
Jul 18 16:07:36 localhost kernel: trans 190 in commit
Jul 18 16:07:37 localhost kernel: trans 190 done in commit
Jul 18 16:07:37 localhost kernel: cleaner awake
Jul 18 16:07:37 localhost kernel: cleaner done
Jul 18 16:08:07 localhost kernel: trans 191 in commit
Jul 18 16:08:09 localhost kernel: trans 191 done in commit
Jul 18 16:08:09 localhost kernel: cleaner awake
Jul 18 16:08:09 localhost kernel: cleaner done
Jul 18 16:08:39 localhost kernel: trans 192 in commit
Jul 18 16:08:39 localhost kernel: trans 192 done in commit
Jul 18 16:08:39 localhost kernel: cleaner awake
Jul 18 16:08:39 localhost kernel: cleaner done

The command I ran was:

fs_mark  -d  /mnt/test  -D  256  -n  100000  -t  4  -s  20480  -F  -S  0 
-l btrfs_new.txt

(No fsyncs involved here)

ric



