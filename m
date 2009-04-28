From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 13:23:57 -0400
Message-ID: <1240939437.15136.23.camel@think.oraclecorp.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
	 <1240839448.26451.13.camel@think.oraclecorp.com>
	 <20090428155900.GA1722@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090428155900.GA1722@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-04-28 at 17:59 +0200, Thomas Glanzmann wrote:
> Hello,
> I have a few more questions to this:
> 
>         - Is there a checksum for every block in btrfs?

Yes, but they are only crc32c.

> 
>         - Is it possible to retrieve these checksums from userland?
> 

Not today.  The sage developers sent a patch to make an ioctl for this,
but since it was hard coded to crc32c I haven't taken it yet.

>         - Is it possible to use a blocksize of 4 or 8 kbyte with btrfs?
> 

Yes, btrfs uses extents but for the purposes of dedup, 4k blocksizes are
fine.

> To get a bit more specific: If it is relatively easy to identify and
> deduplicate blocks, and if btrfs supports relatively small block sizes
> like 4 / 8 kbyte, it is the perfect candidate for VMs. To give you some
> data. I took 300 Gbyte (note this is the disk space that is used not the
> provisioned space (the space that isn't currently used by the VM so it's the
> data that are in use) of VMs running different operating systems and used a
> perl script to identify how many data could be deduped give a specific
> blocksize:
> 

Virtual machines are the ideal dedup workload.  But, you do get a big
portion of the dedup benefits by just starting with a common image and
cloning it instead of doing copies of each vm.

-chris


