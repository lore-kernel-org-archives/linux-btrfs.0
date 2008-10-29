From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compressed Filesystem
Date: Wed, 29 Oct 2008 16:08:42 -0400
Message-ID: <1225310922.6448.300.camel@think.oraclecorp.com>
References: <20081027145401.GB10896@tux64-03>
	 <1225208847.6448.172.camel@think.oraclecorp.com>
	 <20081028163337.GA8488@tux64-02>
	 <1225215517.6448.176.camel@think.oraclecorp.com>
	 <53696.2001:470:e828:1::2:2.1225304096.squirrel@avalon.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: btrfs-devel@arbitraryconstant.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <53696.2001:470:e828:1::2:2.1225304096.squirrel@avalon.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-29 at 12:14 -0600, Anthony Roberts wrote:
> Hi, I have a few questions about this:
> 
> > Compression is optional and off by default (mount -o compress to enable
> > it).  When enabled, every file is compressed.
> 
> Do you know what the CPU load is like with this enabled?

Now that I've finally pushed the code out, you can try it ;)  One part
of the implementation I need to revisit is the place in the code where I
do compression means that most of the time the single threaded pdflush
is the one compressing.

This doesn't spread the load very well across the cpus.  It can be
fixed, but I wanted to get the code out there.

The decompression does spread across cpus, and I've gotten about 800MB/s
doing decompress and checksumming on a zero filled compressed file.  At
the time, the disk was reading 14MB/s.

> 
> Do you know whether data can be compressed at a sufficient rate to still
> saturate the disk on recent-ish AMD/Intel CPUs?

My recentish intel cpu can compress and checksum at about 120MB/s.  
> 
> If no, is the effective pre-compression I/O rate still comparable to the
> disk without compression?
> 

It depends on your disks...

> I'm pretty sure that won't even matter in many cases (eg you're seeking
> too much to care, or you're on a VM with lots of cores but congested
> disks, or you're dealing with media files that it doesn't bother
> compressing, etc), but I'm curious what sort of overhead this adds. :)
> 
> Mostly it seems like a good tradeoff, it trades plentiful cores for scarce
> disk resources.

This varies quite a bit from workload to workload, in some places it'll
make a big difference, but many workloads are seek bound and not
bandwidth bound.

-chris




