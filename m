Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob04.myregisteredsite.com ([209.17.115.42]:47539 "EHLO
	atl4mhob04.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbaANVsF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:48:05 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob04.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0ELm2AX030044
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 16:48:02 -0500
Message-ID: <52D5B091.9090304@chinilu.com>
Date: Tue, 14 Jan 2014 13:48:01 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com> <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com> <52D59E28.7010200@chinilu.com> <B24DFFC0-3B9D-41CA-ADC4-B0C4429C294A@colorremedies.com>
In-Reply-To: <B24DFFC0-3B9D-41CA-ADC4-B0C4429C294A@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/14/2014 01:14 PM, Chris Murphy wrote:
> On Jan 14, 2014, at 1:29 PM, George Mitchell <george@chinilu.com> wrote:
>>> And the key to monitoring hard drive health, in my opinion, is SMART and what we are lacking at this point is a SMART capability to provide visual notifications to the user when any hard drive starts to seriously degrade or suddenly fails.
> Gnome does this:
> https://mail.gnome.org/archives/commits-list/2012-November/msg03124.html
>
> The problem is that something around 40% of failures come with absolutely no advance warning by SMART. So yes it's better than nothing but we're still rather likely to not get sufficient warning.
>
The journal already marks and red types serious problems.  I agree that 
the role of bringing this information to the desktop would be the 
desktop, in my case KDE, which in my case is not providing me with a 
solution to this.  I am glad that at least Gnome has taken care of this, 
thanks probably to Red Hat.
>>   If SMART were capable of launching pop up warnings, btrfs would not have to worry so much about arrays going simplex undetected.
> I don't see a tie in between Btrfs and SMART. Btrfs's behavior in the face of SMART indicating e.g. a high number of reallocated sectors in the past hour, shouldn't change. Only once the drive reports read or write failures would Btrfs need to change its behavior. The SMART warnings preferably should flag the user with some kind of warning.
Well OK, I get that.
>
>>    And it should really be the user's responsibility to be running SMART and providing sufficient number of drives AND sufficient additional free space to accommodate potential drive failure and still retain desired level of redundancy extra drives in their RAID arrays.  That is where I stand on this.
> I'd say the OS should do it. With linux distros, that's the desktop. I don't think users should have to be configuring SMART at all.
>
The problem is that some users might be running systems that, for 
whatever reason, are not compatible with SMART and distros are loath to 
automatically enable functions that might result in DOAs.  I myself have 
had multiple cases of locked up systems before due to SMART issues.  But 
I do think the distros need to make SMART configuration a whole lot 
easier than it currently is.
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

