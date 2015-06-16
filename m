Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:44159 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbbFPNlo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 09:41:44 -0400
Received: from smtp23.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp23.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id EFF22280971
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 09:36:21 -0400 (EDT)
Received: from smtp23.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp23.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id BF04928081D
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 09:36:21 -0400 (EDT)
Received: by smtp23.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id 4CF46280961
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 09:34:37 -0400 (EDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: RAID10 Balancing Request for Comments and Advices
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <20150616122545.GI9850@carfax.org.uk>
Date: Tue, 16 Jun 2015 09:34:29 -0400
Message-Id: <61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com>
References: <1434456557.89597618@apps.rackspace.com> <20150616122545.GI9850@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> On Jun 16, 2015, at 8:25 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> On Tue, Jun 16, 2015 at 08:09:17AM -0400, Vincent Olivier wrote:
>> 
>> "btrfs filesystem df” gives :
>> 
>> 
>> Data, RAID10: total=7.08TiB, used=7.02TiB
>> Data, single: total=8.00MiB, used=0.00B
>> System, RAID10: total=7.88MiB, used=656.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, RAID10: total=9.19GiB, used=7.56GiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
>> My first question is this : is it normal to have “single” blocks ?
>> Why not only RAID10? I don’t remember the exact mkfs options I used
>> but I certainly didn’t ask for “single” so this is unexpected.
> 
>  Yes. It's an artefact of the way that mkfs works. If you run a
> balance on those chunks, they'll go away. (btrfs balance start
> -dusage=0 -musage=0 /mountpoint)



Thanks! I did and it did go away, except for the "GlobalReserve, single: total=512.00MiB, used=0.00B”. But I suppose this is a permanent fixture, right?



> 
>> My second question is : what is the best device add / balance sequence to use if I want to add 2 more disks to this RAID10 volume? Also is a balance necessary at all since I’m adding a pair?
> 
>  Add both devices first, then balance.
> 
>  For a RAID-1 filesystem, adding two devices wouldn't need a balance
> to get full usage out of the new devices. However, you've got RAID-10,
> so the most you'd be able to get on the FS without a balance is four
> times the remaining space on one of the existing disks.
> 
>  The chunk allocator for RAID-10 will allocate as many chunks as it
> can in an even number across all the devices, omitting the device with
> the smallest free space if there's an odd number of devices. It must
> have space on at least four devices, so adding two devices means that
> it'll have to have free space on at least two of the existing ones
> (and will try to use all of them).
> 
>  So yes, unless you're adding four devices, a rebalance is required
> here.


It is perfectly clear and logical that 1+0 works on four devices at a time.


>> My third question is: given that this file system is an offline
>> backup for another RAID0 volume with SMB sharing, what is the best
>> maintenance schedule as long as it is offline? For now, I only have
>> a weekly cron scrub now, but I think that the priority is to have it
>> balanced after a send-receive or rsync to optimize storage space
>> availability (over performance). Is there a “light” balancing method
>> recommended in this case?
> 
>  You don't need to balance after send/receive or rsync. If you find
> that you have lots of data space allocated but not used (the first
> line in btrfs fi df, above), *and* metadata close to usage (within,
> say, 700 MiB), *and* no unallocated space (btrfs fi show), then it's
> worth running a filtered balance with -dlimit=3 or some similar small
> value to free up some space that the metadata can expand into. Other
> than that, it's pretty much entirely pointless.


Ok thanks. Is there a btrfs-utils way of automating the "if less than 1Gb free do balance -dlimit=3” ?


>  For maintenance, I would suggest running a scrub regularly, to
> check for various forms of bitrot. Typical frequencies for a scrub
> are once a week or once a month -- opinions vary (as do runtimes).


Yes. I cronned it weekly for now. Takes about 5 hours. Is it automatically corrected on RAID10 since a copy of it exist within the filesystem ? What happens for RAID0 ?

Thanks!

V