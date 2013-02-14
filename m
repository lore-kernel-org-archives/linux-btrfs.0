Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:57101 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3BNGnI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 01:43:08 -0500
Date: Thu, 14 Feb 2013 07:42:57 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Chris Murphy <lists@colorremedies.com>
cc: linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
In-Reply-To: <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com>
Message-ID: <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 13 Feb 2013, Chris Murphy wrote:
> On Feb 12, 2013, at 11:18 PM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
>> That's not typical for actual media problems, in my experience. :)
>
> Quite typical, because these drives don't support SCTERC which almost 
> certainly means their error timeouts are well above that of the linux 
> SCSI layer which is 30 seconds. Their timeouts are likely around 2 
> minutes. So in fact they never report back a URE because the command 
> timer times out and resets the drive.

That's interesting to read. I haven't ever actually experienced missing a 
bad sector reported by a hard drive, though; and not for a lack of 
experience with bad sectors.

Either way, though, with the assumption that it actually was a cable 
problem rather than bad medium...

> However, in your case, with both the kernel message ICRC ABRT, and the 
> following SMART entry, this is your cable problem.

... I'd still like to solve the problem as it is, so that I know what to 
do the next time I get some device error.

> So the question is whether the cable problem has actually been fixed, 
> and if you're still getting ICRC errors from the kernel.

I'm not getting any block-layer errors from the kernel. The errors I 
posted originally are the only ones I'm getting.

> As this is hdi, I'm wondering how many drives are connected, and if this 
> could be power induced rather than just cable induced.

With the general change, I actually decreased the number of drives in the 
system from 10 to 8, so unless the new drives are incredibly more 
power-hungry than the old ones, that shouldn't be a problem.

> Once that's solved, you should do a scrub, rather than a rebalance.

Oh, will scrubbing actually rebalance the array? I was under the 
impression that it only checked for bad checksums.

I'm still wondering what those errors actually mean, though. I'm still 
getting them occasionally, even when I'm not rebalancing (just not as 
often). I'm also very curious about what it means that it's still 
complaining about sdd rather than sdi.

It's worth noting that I still haven't un- and remounted the filesystem 
since the drive disconnected. I assumed that I shouldn't need to and that 
the multiple-device layer of btrfs should handle the situation correctly. 
Is that assumption correct?

--

Fredrik Tolf
