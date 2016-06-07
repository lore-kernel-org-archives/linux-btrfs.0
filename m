Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40755 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbcFGECL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jun 2016 00:02:11 -0400
Message-Id: <1465272129.3661627.630003937.6FC96567@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
Date: Tue, 07 Jun 2016 12:02:09 +0800
In-Reply-To: <CAJCQCtSYfX3M0DVd9WA+yru8Jm=wwfkmYCUUeeswE9DnsMAG1g@mail.gmail.com>
References: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
 <CAJCQCtSYfX3M0DVd9WA+yru8Jm=wwfkmYCUUeeswE9DnsMAG1g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry I unsubscribed from linux-btrfs@vger.kernel.org since the traffic
was a bit too high for me.

On Tue, 7 Jun 2016, at 11:42 AM, Chris Murphy wrote:
> Your command turned this from a 3 drive volume into a 2 drive volume,
> it removed the drive you asked to be removed.

I actually had 2 drives to begin with, but it wouldn't allow me to
delete the drive without adding a new one, so I had 3 drives.

I think I've confused you by my talk of "RAID-1 over 3 drives". I am not
sure why RAIDX terminology is so confusing. All I want is for the data
on one drive to be mirrored across them all. So if I add X drives, I
want to X exact copies. But IIUC this changes the RAID level and
everyone gets confused what I am talking about.


> You're definitely missing something but once you understand how it
> actually works, it'll be interesting if you have suggestions on how
> the existing documentation confused you into making this mistake.


Summary: I issued the remove command when I should have just removed it
physically IIUC.



If I was to do this again, I would unmount the raid1 mount. Take a disk
physically out and then add the new one. So yes, it would be degraded
but then as you mention, the newly drive will sort it out. One would
hope.

Thanks,
