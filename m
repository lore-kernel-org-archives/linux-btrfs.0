Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57018 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967537Ab3DSAbf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 20:31:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1USzEk-0000Vx-6k
	for linux-btrfs@vger.kernel.org; Fri, 19 Apr 2013 02:31:34 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 02:31:34 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 02:31:34 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: RAID device nomination (Feature request)
Date: Fri, 19 Apr 2013 01:31:28 +0100
Message-ID: <kkq38r$nk3$1@ger.gmane.org>
References: <kkotdg$o1e$1@ger.gmane.org> <20130418140604.GL7639@carfax.org.uk> <kkp70i$cq6$1@ger.gmane.org> <20130418194431.GM7639@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130418194431.GM7639@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/04/13 20:44, Hugo Mills wrote:
> On Thu, Apr 18, 2013 at 05:29:10PM +0100, Martin wrote:
>> On 18/04/13 15:06, Hugo Mills wrote:
>>> On Thu, Apr 18, 2013 at 02:45:24PM +0100, Martin wrote:
>>>> Dear Devs,
>>>> 
>>>> I have a number of esata disk packs holding 4 physical disks
>>>> each where I wish to use the disk packs aggregated for 16TB
>>>> and up to 64TB backups...
>>>> 
>>>> Can btrfs...?
>>>> 
>>>> 1:
>>>> 
>>>> Mirror data such that there is a copy of data on each *disk
>>>> pack* ?
>>>> 
>>>> Note that esata shows just the disks as individual physical 
>>>> disks, 4 per disk pack. Can physical disks be grouped
>>>> together to force the RAID data to be mirrored across all the
>>>> nominated groups?
>>> 
>>> Interesting you should ask this: I realised quite recently that
>>>  this could probably be done fairly easily with a modification
>>> to the chunk allocator.
>> 
>> Hey, that sounds good. And easy? ;-)
>> 
>> Possible?...
> 
> We'll see... I'm a bit busy for the next week or so, but I'll see 
> what I can do.

Thanks greatly. That should nicely let me stay with my "plan A" and
just let btrfs conveniently expand over multiple disk packs :-)

(I'm playing 'safe' for the moment while I can by putting in bigger
disks into new packs as needed. I've some packs with smaller disks
that are nearly full that I want to continue to use so I'm agonising
over whether to replace all the disks and rewrite all the data or use
multiple disk packs as one. "Plan A" is good for keeping the existing
disks :-) )


[...]
>> The question is how the groups of disks are determined:
>> 
>> Manually by the user for mkfs.btrfs and/or specified when disks
>> are added/replaced;
>> 
>> Or somehow automatically detected (but with a user override).
>> 
>> 
>> Have a "disk group" UUID for a group of disks similar to that
>> done for md-raid?
> 
> I was planning on simply having userspace assign a (small) integer 
> to each device. Devices with the same integer are in the same
> group, and won't have more than one copy of any given piece of data
> assigned to them. Note that there's already an unused "disk group"
> item which is a 32-bit integer in the device structure, which looks
> like it can be repurposed for this; there's no spare space in the
> device structure, so anything more than that will involve some kind
> of disk format change.

The "repurpose for no format change" sounds very good and 32-bits
should be enough for anyone. (Notwithstanding the inevitable 640k
comments!)

A 32-bit unsigned-int number that the user specifies? Or include a
semi-random automatic numbering to a group of devices listed by the
user?...

Then again, I can't imagine anyone wanting to go beyond 8-bits...
Hence a 16-bit unsigned int is still suitably overkill. That then
offers the other 16-bits for some other repurpose ;-)


For myself, it would be nice to be able to specify a number that is
the same unique number that's stamped on the disk packs so that I can
be sure what has been plugged in! (Assuming there's some option to
list what's been plugged in.)


>>>> 3:
>>>> 
>>>> Also, for different speeds of disks, can btrfs tune itself
>>>> to balance the read/writes accordingly?
>>> 
>>> Not that I'm aware of.
>> 
>> A 'nice to have' would be some sort of read-access load balancing
>> with options to balance latency or queue depth... Could btrfs do
>> that independently (complimentary with) of the block layer
>> schedulers?
> 
> All things are possible... :) Whether it's something that someone 
> will actually do or not, I don't know. There's an argument for
> getting some policy into that allocation decision for other
> purposes (e.g. trying to ensure that if a disk dies from a
> filesystem with "single" allocation, you lose the fewest number of
> files).
> 
> On the other hand, this is probably going to be one of those
> things that could have really nasty performance effects. It's also
> somewhat beyond my knowledge right now, so someone else will have
> to look at it. :)

Sounds ideal for some university research ;-)


[...]
>> For example, if for an SSD, the next free space allocation for 
>> whatever is to be newly written could become more like a log
>> based round-robin allocation across the entire SSD (NILFS-like?)
>> rather than trying to localise data to minimise the physical head
>> movement as for a HDD.
>> 
>> Or is there no useful gain with that over simply using the same
>> one lump of allocator code as for HDDs?
> 
> No idea. It's going to need someone to write the code and
> benchmark the options, I suspect.

A second university project? ;-)


[...]
>> (And there's always the worry of the esata lead getting yanked to
>> take out all four disks...)
> 
> As I said, I've done the latter myself. The array *should* go into

Looks like I'll likely get to find out for myself sometime or other...



Thanks for your help and keep me posted please.

I'll be experimenting with the groupings as soon as they come along.
Also for the dedup work that is being done.

Regards,
Martin






