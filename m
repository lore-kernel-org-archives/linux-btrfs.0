From: Chris Mason <chris.mason@oracle.com>
Subject: Re: A couple of questions
Date: Thu, 27 May 2010 12:00:44 -0400
Message-ID: <20100527160044.GD3835@think>
References: <201005271539.55644.paul.millar@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Paul Millar <paul.millar@desy.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005271539.55644.paul.millar@desy.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 27, 2010 at 03:39:54PM +0200, Paul Millar wrote:
> Hi,
> 
> I've been looking at Btrfs and have a couple of naive questions that don't 
> seem to be answered on the wiki or in the articles I've read on the 
> filesystem.
> 
> 
> First: discovering a file's checksum value.
> 
> Here's the scenario: software is writing some data as a fresh file.  This 
> software happens to know (a priori) the checksum of this data; for example, a 
> storage server receives the file's data and checksum independently.
> 
> I've some confidence that, once the data is stored in btrfs, any corruption 
> (from the storage fabric) will be spotted; however, the data may have became 
> corrupt before being stored (e.g., from the network).  To catch this, the 
> checksum of the stored data needs to be calculated and checked.
> 
> One approach is to calculate the checksum (in user-space) after the data is 
> stored.  This adds extra IO- and CPU-load and there's also the possibility of 
> false-negative results due to the filesystem cache (although btrfs may remove 
> this risk).
> 
> Another approach would be to ask btrfs for the checksum.  It seems that it's 
> possible to combine multiple CRC-32C values to figure out the checksum of the 
> combined data [e.g., zlib's crc32_combine() function].  So, obtaining a file's 
> checksum might be a light-weight operation.
> 
> Yet another possibility would be to push the desired checksum value (via 
> fcntl?) and have btrfs compare the desired checksum with the file's actual 
> checksum on close(2), failing that call if the checksums don't match.
> 
> Would any of this be possible (without an awful lot of work)?

I'd suggest that you look at T10 DIF and DIX, which are targeted at
exactly this kind of thing.  We're looking at integrating dif/dix into
btrfs at some point.

> 
> 
> 
> Second: adding support for Adler32?
> 
> Looking at the unstable git repo, it looks like there's currently support for 
> only the CRC-32C checksum algorithm.  Is this correct?  If so, is anyone 
> working on adding support for Adler32?

We haven't looked at adler32.  crc32c was chosen because it is supported
in hardware by recent intel CPUs.

-chris
