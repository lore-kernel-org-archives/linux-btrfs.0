Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:56873 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750737AbaEUB3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 21:29:46 -0400
Message-ID: <57f050e2a37907d810b40c5e115b28ff.squirrel@webmail.wanet.net>
In-Reply-To: <4483661.BdmCOR8JR5@xev>
References: <2308735.51F3c4eZQ7@xev> <lldpvm$s7c$1@ger.gmane.org>
    <537A7BF9.5060508@swiftspirit.co.za> <4483661.BdmCOR8JR5@xev>
Date: Tue, 20 May 2014 07:56:41 -0700
Subject: Re: ditto blocks on ZFS
From: ashford@whisperpc.com
To: linux-btrfs@vger.kernel.org
Cc: ahferroin7@gmail.com, russell@coker.com.au, brendan@swiftspirit.co.za
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I’ve been reading this list for a few years, and giving almost no
feedback, but I feel that this subject demands that I provide some input.

I can think of five possible effects of implementing ditto blocks for the
metadata.  We've only been discussing one (#3 in my list) in this thread. 
While most of these effects are fairly obvious, I have seen no discussion
on them.

In discussing the issues of implementing ditto blocks, I think it would be
good to address all of the potential effects, and determine from that
discussion whether or not the enhancement should be made, and, if so, when
the appropriate development resources should be made available.  As Austin
pointed out, there are some enhancements currently planned which would
make the implementation of ditto blocks simpler.  I believe that defines
the earliest good time for implementation of ditto blocks.

1.  There will be more disk space used by the metadata.  I've been aware
of space allocation issues in BTRFS for more than three years.  If the use
of ditto blocks will make this issue worse, then it's probably not a good
idea to implement it.  The actual increase in metadata space is probably
small in most circumstances.

2.  Use of ditto blocks will increase write bandwidth to the disk.  This
is a direct and unavoidable result of having more copies of the metadata. 
The actual impact of this would depend on the file-system usage pattern,
but would probably be unnoticeable in most circumstances.  Does anyone
have a “worst-case” scenario for testing?

3.  Certain kinds of disk errors would be easier to recover from.  Some
people here claim that those specific errors are rare.  I have no opinion
on how often they happen, but I believe that if the overall disk space
cost is low, it will have a reasonable return.  There would be virtually
no reliability gains on an SSD-based file-system, as the ditto blocks
would be written at the same time, and the SSD would be likely to map the
logical blocks into the same page of flash memory.

4.  If the BIO layer of BTRFS and the device driver are smart enough,
ditto blocks could reduce I/O wait time.  This is a direct result of
having more instances of the data on the disk, so it's likely that there
will be a ditto block closer to where the disk head is currently.  The
actual benefit for disk-based file-systems is likely to be under 1ms per
metadata seek.  It's possible that a short-term backlog on one disk could
cause BTRFS to use a ditto block on another disk, which could deliver
>20ms of performance.  There would be no performance benefit for SSD-based
file-systems.

5.  There will be a (hopefully short) period where the code may be
slightly less stable, due to the modifications being performed at a
low-level within the file-system.  This is likely to happen with any
modification of the file-system code, with more complex modifications
being more likely to introduce instability.  I believe that the overall
complexity of this particular modification is great enough that there may
be some added instability for a bit, but perhaps use of the n-way
replication feature will substantially reduce the complexity.  Hopefully,
the integration testing that’s being performed on the BTRFS code will find
most of the new bugs, and point the core developers in the right direction
to fix them.



I have one final note about RAID levels.  I build and sell file servers as
a side job, having assembled and delivered over 100 file servers storing
several hundreds of TB.  TTBOMK, no system that I’ve built to my own
specifications (not overridden by customer requests) has lost any data
during the first 3 years of operation.  One customer requested a disk
manufacturer change, and has lost data.  A few systems have had data loss
in the 4-year timeframe, due to multiple drive failure, combined with
inadequate disk status monitoring.

My experience is that once your disks are larger than about 500-750GB,
RAID-6 becomes a much better choice, due to the increased chances of
having an uncorrectable read error during a reconstruct.  My opinion is
that anyone storing critical information in RAID-5, or even 2-disk RAID-1,
with disks of this capacity, should either reconsider their storage
topology, or verify that they have a good backup/restore mechanism in
place for that data.

Thank you.

Peter Ashford

