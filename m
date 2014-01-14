Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34002 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751485AbaANVOI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:14:08 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:55098 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W3BJE-000II6-CJ
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 14:14:04 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52D59E28.7010200@chinilu.com>
Date: Tue, 14 Jan 2014 14:14:01 -0700
Message-Id: <B24DFFC0-3B9D-41CA-ADC4-B0C4429C294A@colorremedies.com>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com> <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com> <52D59E28.7010200@chinilu.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 14, 2014, at 1:29 PM, George Mitchell <george@chinilu.com> wrote:
>> 
> Chris,  Please don't misunderstand me.  I am not advocating that btrfs or any other filesystem should be dealing with bad blocks.  I believe very strongly that if the drive firmware can't deal with that transparently the drive is, indeed, toast, and should be tossed.

OK.


> And the key to monitoring hard drive health, in my opinion, is SMART and what we are lacking at this point is a SMART capability to provide visual notifications to the user when any hard drive starts to seriously degrade or suddenly fails.

Gnome does this:
https://mail.gnome.org/archives/commits-list/2012-November/msg03124.html

The problem is that something around 40% of failures come with absolutely no advance warning by SMART. So yes it's better than nothing but we're still rather likely to not get sufficient warning.


>  If SMART were capable of launching pop up warnings, btrfs would not have to worry so much about arrays going simplex undetected.

I don't see a tie in between Btrfs and SMART. Btrfs's behavior in the face of SMART indicating e.g. a high number of reallocated sectors in the past hour, shouldn't change. Only once the drive reports read or write failures would Btrfs need to change its behavior. The SMART warnings preferably should flag the user with some kind of warning.

>   And it should really be the user's responsibility to be running SMART and providing sufficient number of drives AND sufficient additional free space to accommodate potential drive failure and still retain desired level of redundancy extra drives in their RAID arrays.  That is where I stand on this.

I'd say the OS should do it. With linux distros, that's the desktop. I don't think users should have to be configuring SMART at all.


Chris Murphy

