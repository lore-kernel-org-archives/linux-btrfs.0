Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36140 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbcFGOvS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jun 2016 10:51:18 -0400
Received: by mail-oi0-f47.google.com with SMTP id p204so84762605oih.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jun 2016 07:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465272129.3661627.630003937.6FC96567@webmail.messagingengine.com>
References: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
	<CAJCQCtSYfX3M0DVd9WA+yru8Jm=wwfkmYCUUeeswE9DnsMAG1g@mail.gmail.com>
	<1465272129.3661627.630003937.6FC96567@webmail.messagingengine.com>
Date: Tue, 7 Jun 2016 08:51:17 -0600
Message-ID: <CAJCQCtTBCPDNOpZjPmyLu1Z1aBuK-Eii2k7=K1RgwWwMHu1e8w@mail.gmail.com>
Subject: Re: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
From: Chris Murphy <lists@colorremedies.com>
To: Kai Hendry <hendry@iki.fi>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 6, 2016 at 10:02 PM, Kai Hendry <hendry@iki.fi> wrote:
> Sorry I unsubscribed from linux-btrfs@vger.kernel.org since the traffic
> was a bit too high for me.
>
> On Tue, 7 Jun 2016, at 11:42 AM, Chris Murphy wrote:
>> Your command turned this from a 3 drive volume into a 2 drive volume,
>> it removed the drive you asked to be removed.
>
> I actually had 2 drives to begin with, but it wouldn't allow me to
> delete the drive without adding a new one, so I had 3 drives.

Two drive raid1 is the minimum number of drives, that's why it won't
allow you to delete one.


>
> I think I've confused you by my talk of "RAID-1 over 3 drives". I am not
> sure why RAIDX terminology is so confusing. All I want is for the data
> on one drive to be mirrored across them all. So if I add X drives, I
> want to X exact copies. But IIUC this changes the RAID level and
> everyone gets confused what I am talking about.

Yeah you're confused about both RAID in general and how Btrfs raid
works. There is no guarantee of X drives meaning X copies with any
RAID-1. The mkfs.btrfs man page makes it very clear that there are
only ever two copies of data with Btrfs raid1 no matter how many
drives you include.


>
>
>> You're definitely missing something but once you understand how it
>> actually works, it'll be interesting if you have suggestions on how
>> the existing documentation confused you into making this mistake.
>
>
> Summary: I issued the remove command when I should have just removed it
> physically IIUC.

Yes, but that only works with a two drive Btrfs raid1. The minimum
number of drives for successful degraded mount is n-1 drives. You can
only lose 1 drive with Btrfs raid1 volumes, you must have all of the
other drives for it to be mountable degraded.



> If I was to do this again, I would unmount the raid1 mount. Take a disk
> physically out and then add the new one. So yes, it would be degraded
> but then as you mention, the newly drive will sort it out. One would
> hope.

Btrfs isn't mature enough to hope for the best. You definitely need to
understand it. There's a lot less you need to understand than mdadm or
LVM plus other file system stuff, but there's still minimum knowledge
required and also there are gotchas that aren't always obvious.

-- 
Chris Murphy
