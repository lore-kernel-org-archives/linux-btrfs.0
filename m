From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG: kernel bug caught at 55% mark of portage cache
 update
Date: Fri, 19 Dec 2008 11:16:19 -0500
Message-ID: <1229703379.6695.18.camel@think.oraclecorp.com>
References: <FD060D90-0C58-4222-8A56-CDE0B47AD6DC@trustbearer.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Thomas Harning <thomas.harning@trustbearer.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <FD060D90-0C58-4222-8A56-CDE0B47AD6DC@trustbearer.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-16 at 14:57 -0500, Thomas Harning wrote:
> A kernel 'BUG' was caught while I had compression enabled and was  
> performing a 'portage' update on my gentoo installation (which had  
> btrfs mounted for portage for some basic perf testing).  It has  
> finished the rsync and was at the 55% mark of the portage cache  
> update... if that helps at all.
> 
> Inlined is the kernel bug output... + some extra debug info that had  
> been spit out beforehand that i thought might be useful...
> 
> didn't appear to be at that 85% freespace mark...
> 
> should I attach a btrfs-image dump?
> 
> /dev/mapper/vg-btrfsTest
>                        1.0G  309M  716M  31% /mnt/btrfsTest
> 

Looking at the logs, your disk really was full.  Btrfs breaks the disk
up into metadata and data chunks.  The allocator is much more efficient
when the chunks are fairly large (the default is 1GB), and for smaller
devices it tries to make them smaller.

There is some tuning that needs to happen on the smaller devices to
better balance space between data and metadata.  In your case, the
metadata block groups were all full even though the data block groups
still had some empty space.


-chris


