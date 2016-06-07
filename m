Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:38401 "EHLO
	mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbcFGLLC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jun 2016 07:11:02 -0400
Received: by mail-it0-f46.google.com with SMTP id h190so4225214ith.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jun 2016 04:11:01 -0700 (PDT)
Subject: Re: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
To: Kai Hendry <hendry@iki.fi>, Chris Murphy <lists@colorremedies.com>
References: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
 <CAJCQCtSYfX3M0DVd9WA+yru8Jm=wwfkmYCUUeeswE9DnsMAG1g@mail.gmail.com>
 <1465272129.3661627.630003937.6FC96567@webmail.messagingengine.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <abecd302-3ef4-ba0e-eba1-fe27bb68a539@gmail.com>
Date: Tue, 7 Jun 2016 07:10:56 -0400
MIME-Version: 1.0
In-Reply-To: <1465272129.3661627.630003937.6FC96567@webmail.messagingengine.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-07 00:02, Kai Hendry wrote:
> Sorry I unsubscribed from linux-btrfs@vger.kernel.org since the traffic
> was a bit too high for me.
Entirely understandable, although for what it's worth it's nowhere near 
as busy as some other mailing lists (linux-kernel@vger.kernel.org for 
example sees well over a thousand messages a day on average).
>
> On Tue, 7 Jun 2016, at 11:42 AM, Chris Murphy wrote:
>> Your command turned this from a 3 drive volume into a 2 drive volume,
>> it removed the drive you asked to be removed.
>
> I actually had 2 drives to begin with, but it wouldn't allow me to
> delete the drive without adding a new one, so I had 3 drives.
>
> I think I've confused you by my talk of "RAID-1 over 3 drives". I am not
> sure why RAIDX terminology is so confusing. All I want is for the data
> on one drive to be mirrored across them all. So if I add X drives, I
> want to X exact copies. But IIUC this changes the RAID level and
> everyone gets confused what I am talking about.
Actually, because of how raid1 mode in BTRFS works, you just get 2 
copies no matter how many drives you have.  Once you add more than the 
first two drives, it starts to work more like RAID-10, although slightly 
less efficiently than the raid10 profile.  This is why you couldn't pull 
a single drive out of a 3 drive raid1 set and have all the data.
>
>
>> You're definitely missing something but once you understand how it
>> actually works, it'll be interesting if you have suggestions on how
>> the existing documentation confused you into making this mistake.
>
>
> Summary: I issued the remove command when I should have just removed it
> physically IIUC.
Yes.  The device delete command is for shrinking arrays, removing 
failing disks, or for re-purposing individual drives.
>
>
>
> If I was to do this again, I would unmount the raid1 mount. Take a disk
> physically out and then add the new one. So yes, it would be degraded
> but then as you mention, the newly drive will sort it out. One would
> hope.
Yes, although you would then need to be certain to run a balance with 
-dconvert=raid1 -mconvert=raid1 to clean up anything that got allocated 
before the new disk was added.

