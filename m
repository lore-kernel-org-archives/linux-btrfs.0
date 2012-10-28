Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:51547 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058Ab2J1TmT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 15:42:19 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: Chris Murphy <chris@colorremedies.com>
In-Reply-To: <20121028190601.GJ2381@yeono.kjorling.se>
Date: Sun, 28 Oct 2012 13:42:17 -0600
Message-Id: <4B78F4E8-C65F-4436-A0BD-147CD776B7A7@colorremedies.com>
References: <50899151.1070503@inwind.it> <201210281133.10571.Martin@lichtvoll.de> <508D0FC5.1020404@inwind.it> <201210281216.43983.Martin@lichtvoll.de> <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com> <20121028190601.GJ2381@yeono.kjorling.se>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 28, 2012, at 1:06 PM, Michael Kjörling <michael@kjorling.se> wrote:
> 
> This makes a valid point. And there's another issue potentially at
> play: file system level compression, _which btrfs already supports_.
> Say you store a highly compressible file (a web server access log,
> perhaps) on a compressed volume that is set up with RAID 1 across a
> set of physical drives. You know the pool size, and you know the data
> allocation ratio. What you _don't_ know and can't predict is the
> _compression_ ratio for any new data, which means that you still can't
> calculate how much more payload data can be added to the file before
> you run out of storage space. You _can_ calculate a worst case
> scenario figure (no compression possible on the new payload data), but
> that's about it.

Btrfs definitely makes absolute prediction of free space remaining difficult. I'm fine with a verbose feature proposing various "free space scenarios" based on compression and redundancy, however I think a summary version can do better. Better being defined as: relatively easy to understand, not a lie, but not the whole truth, and subject to change if you deviate from the ability of the system to estimate.

As the file system is actually used, there is pretty good statistical information, which should get better the more full it gets, how it's being used and therefore how much time to fullness. And I think it's fine for this to vary somewhat based on use. You could have:

Storage remaining
current usage: 3 hours
average usage: 3 weeks

So that's a file system with a lot being written to it currently, way more than average.

Storage remaining
current usage: 35 days
average usage: 40 days

You could even include a switch that allows enterprise to assume regularly added storage. Computing an average data allocation rate allows a prediction for when the file system will be full, assuming that average allocation trend. So an optional switch can include the assumption that storage will be grown at a certain rate: e.g. 3TB per month. Based on both allocation and growth assumptions, storage remaining as time becomes even more useful than a seemingly "raw" percentage that fluctuates. 

I think human's are a lot more forgiving of time estimates being pliable than percentages anyway, although I don't know why.

Anyway, eventually the file system could stop just short of issuing its own purchase orders for the drives it needs to maintain a reasonable current/average usage value.

Ergo, when the file system is young and mostly empty, the estimate may be really off. But once this statistic actually starts becoming important, on the other side of 50%, I think the trend is fairly well established. So it's kindof a no consequence estimate early on.


> _However_, while thinking in terms of storage pool sizes, allocation
> ratios and so forth might work for technically inclined people, I'm
> not so sure it'll work for ordinary users. But then again:

Agreed. I wouldn't expose that to them. At least not in the summary. But underlying, the ratios are in play, and affect the summary information users are given rather than purely raw information, which I think is useless for ordinary users.


> * How many ordinary users are going to use multi-device file systems
>  in the first place?

It's a very interesting question. What's the role of mobile in all of this too, if Gartner is even remotely in the ballpark for latest estimates of (just) Android devices equalling (then surpassing) Windows devices in 2015?

However, sticking to desktop for now, with SSD users can form factor wise much more easily have a raid1 setup; or much more likely, -d single profile to add on more storage, while nothing else file system wise changes. They just have more space. They don't have to move things around, establish a new mount points, etc. Or even screw with LVM. It hardly gets easier than 'device add X Y' done.

> 
> * "btrfs" _is_ the file system administration tool. In a way, it makes
>  sense that the data provided by it will be geared more toward
>  technically minded people.

It is a fair point. But this is not LVM or md raid. It's way easier to understand and manage already, even with some trouble spots. But in the area of storage pool/volume management it's perhaps potentially more complex due to subvolumes and actually usable snapshots.

So, I must refuse part of the premise that sysadmins and storage experts aren't also ordinary people. They can benefit too from useful "at a glance" information that, again, doesn't mislead them.

Chris Murphy

