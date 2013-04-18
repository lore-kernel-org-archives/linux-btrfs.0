Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50775 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab3DRQ3T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 12:29:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1USri1-0002EF-Ve
	for linux-btrfs@vger.kernel.org; Thu, 18 Apr 2013 18:29:17 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 18:29:17 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 18:29:17 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: RAID device nomination (Feature request)
Date: Thu, 18 Apr 2013 17:29:10 +0100
Message-ID: <kkp70i$cq6$1@ger.gmane.org>
References: <kkotdg$o1e$1@ger.gmane.org> <20130418140604.GL7639@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130418140604.GL7639@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/04/13 15:06, Hugo Mills wrote:
> On Thu, Apr 18, 2013 at 02:45:24PM +0100, Martin wrote:
>> Dear Devs,
>> 
>> I have a number of esata disk packs holding 4 physical disks each
>> where I wish to use the disk packs aggregated for 16TB and up to
>> 64TB backups...
>> 
>> Can btrfs...?
>> 
>> 1:
>> 
>> Mirror data such that there is a copy of data on each *disk pack*
>> ?
>> 
>> Note that esata shows just the disks as individual physical
>> disks, 4 per disk pack. Can physical disks be grouped together to
>> force the RAID data to be mirrored across all the nominated
>> groups?
> 
> Interesting you should ask this: I realised quite recently that 
> this could probably be done fairly easily with a modification to
> the chunk allocator.

Hey, that sounds good. And easy? ;-)

Possible?...


>> 2:
>> 
>> Similarly for a mix of different storage technologies such as 
>> manufacturer or type (SSD/HDD), can the disks be grouped to
>> ensure a copy of the data is replicated across all the groups?
>> 
>> For example, I deliberately buy HDDs from different 
>> batches/manufacturers to try to avoid common mode or similarly
>> timed failures. Can btrfs be guided to safely spread the RAID
>> data across the *different* hardware types/batches?
> 
> From the kernel point of view, this is the same question as the 
> previous one.

Indeed so.

The question is how the groups of disks are determined:

Manually by the user for mkfs.btrfs and/or specified when disks are
added/replaced;

Or somehow automatically detected (but with a user override).


Have a "disk group" UUID for a group of disks similar to that done for
md-raid?



>> 3:
>> 
>> Also, for different speeds of disks, can btrfs tune itself to
>> balance the read/writes accordingly?
> 
> Not that I'm aware of.

A 'nice to have' would be some sort of read-access load balancing with
options to balance latency or queue depth... Could btrfs do that
independently (complimentary with) of the block layer schedulers?


>> 4:
>> 
>> Further thought: For SSDs, is the "minimise heads movement"
>> 'staircase' code bypassed so as to speed up allocation for the
>> "don't care" addressing (near zero seek time) of SSDs?
> 
> I think this is more to do with the behaviour of the block layer 
> than the FS. There are alternative elevators that can be used, but
> I don't know how to configure them (or whether they need
> configuring at all).

Regardless of the block level io schedulers, does not btrfs determine
the LBA allocation?...

For example, if for an SSD, the next free space allocation for
whatever is to be newly written could become more like a log based
round-robin allocation across the entire SSD (NILFS-like?) rather than
trying to localise data to minimise the physical head movement as for
a HDD.

Or is there no useful gain with that over simply using the same one
lump of allocator code as for HDDs?


> You have backups, which is good. Keep up with the latest kernels 
> from kernel.org. The odds of you hitting something major are
> small, but non-zero. One thing that's probably fairly likely with
> your setup

Healthy paranoia is good ;-)


[...]
> So with light home use on a largeish array, I've had a number of 
> cockups recently that were recoverable, albeit with some swearing.

Thanks for the notes.


> On the other hand, it's entirely possible that something else will 
> go wrong and things will blow up. My guess is that unless you have
[...]

My worry for moving up to spreading a filesystem across multiple disk
packs is for when the disk pack hardware itself fails taking out all
four disks...

(And there's always the worry of the esata lead getting yanked to take
out all four disks...)


Thanks,
Martin

