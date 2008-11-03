From: Chris Mason <chris.mason@oracle.com>
Subject: Re: File System Performance results
Date: Mon, 03 Nov 2008 14:34:08 -0500
Message-ID: <1225740848.18271.1.camel@think.oraclecorp.com>
References: <48FF87CE.2090502@austin.ibm.com>
	 <1225308408.6448.287.camel@think.oraclecorp.com>
	 <490F4D98.2050608@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <490F4D98.2050608@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-11-03 at 13:14 -0600, Steven Pratt wrote:
> Chris Mason wrote:
> > On Wed, 2008-10-22 at 15:06 -0500, Steven Pratt wrote:
> >   
> >> We have set up a new page which is intended mainly for tracking the 
> >> performance of BTRFS, but in doing so we are testing other filesystems 
> >> as well (ext3, ext4, xfs and jfs).  Thought some people here might find 
> >> the results useful.
> >>     
> >
> > I think I understand the bad read performance in btrfs.  I was forcing a
> > tiny max readahead size.
> >
> > The current git tree has fixes for it, along with a ton of new code.
> >   
> Results for the the new (Git pull on 10/29) on the raid system are 
> complete.  Sequential read with a small number of threads has increased 
> dramatically, however on large number of threads (128) we see a large 
> dropoff in performance from before, as well as a huge spike in CPU 
> utilization. A quick look at the oprofile reveals some new functions at 
> the top which seem really out of place on a read only workload.
> 

Thanks, we've got a ton of new code in there, and I'm working through
some performance testing as well.

> samples  %        image name               app name                 symbol name
> 13752215 23.8658  btrfs.ko                 btrfs                    alloc_extent_state
> 12840571 22.2837  btrfs.ko                 btrfs                    free_extent_state
> 9658945  16.7623  vmlinux-2.6.27           vmlinux-2.6.27           crc32c_le
> 
> Both of the extent_state function have overtaken the crc function at the 
> top of the profile.  Why would we be messing with extent states on read 
> only workload?

It depends ;)  We'll have to get a call graph of who is calling that.

-chris


