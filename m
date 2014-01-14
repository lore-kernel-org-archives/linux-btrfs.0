Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob14.myregisteredsite.com ([209.17.115.52]:50375 "EHLO
	atl4mhob14.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbaANU3G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 15:29:06 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob14.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0EKT3m4018693
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 15:29:03 -0500
Message-ID: <52D59E28.7010200@chinilu.com>
Date: Tue, 14 Jan 2014 12:29:28 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com> <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com>
In-Reply-To: <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/14/2014 11:13 AM, Chris Murphy wrote:
> On Jan 9, 2014, at 6:31 PM, George Mitchell <george@chinilu.com> wrote:
>> Jim, my point was that IF the drive does not successfully resolve the bad block issue and btrfs takes a write failure every time it attempts to overwrite the bad data, it is not going to remap that data, but rather it is going to fail the drive.
> If the drive doesn't resolve a bad block on write, then the drive is toast. That's how md handles it. That's even how manufacturers handle it. The point at which write failures occur mean there are no reserve sectors left, or the head itself is having problems writing data to even good sectors. Either way, the drive isn't reliable for rw purposes and coming up with a bunch of code to fix bad drives isn't worth development time in my opinion. Such a drive is vaguely interesting for test purposes however, because even though the drive is toast, we'd like the system to remain stable with it connected first and foremost. And maybe we'd want it as a source during rebuild/replacement.
>
>>   In other words, if the drive has a bad sector which it has not done anything about at the drive level, btrfs will not remap the sector.  It will, rather, fail the drive. Is that not correct?
> I've skimmed for this in the code, but haven't found it, so I'm not sure what the handling is. It's probably easier to take a drive I don't care about, and use hdparm to cause a sector to be flagged as bad, and see how Btrfs handles it. (The hdparm command should be clearable, but I'd rather not screw up a drive I like.)
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
Chris,  Please don't misunderstand me.  I am not advocating that btrfs 
or any other filesystem should be dealing with bad blocks.  I believe 
very strongly that if the drive firmware can't deal with that 
transparently the drive is, indeed, toast, and should be tossed.  And 
the key to monitoring hard drive health, in my opinion, is SMART and 
what we are lacking at this point is a SMART capability to provide 
visual notifications to the user when any hard drive starts to seriously 
degrade or suddenly fails.  This would ideally be mediated by journal 
daemon which desperately needs to be enhanced to provide visual and 
ideally audible pop up warnings to the user in such cases.  It would be 
nice to have those notifications from btrfs as well, also mediated by 
journal daemon, but this is really a SMART specialty and SMART should be 
our first line defense.  Where we need btrfs to move is toward automated 
resiliency, automatically dropping the bad drive(s) and automatically 
following up with a rebalance and return to sanity.  If SMART were 
capable of launching pop up warnings, btrfs would not have to worry so 
much about arrays going simplex undetected.   And it should really be 
the user's responsibility to be running SMART and providing sufficient 
number of drives AND sufficient additional free space to accommodate 
potential drive failure and still retain desired level of redundancy 
extra drives in their RAID arrays.  That is where I stand on this.
