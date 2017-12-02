Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:54117 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751847AbdLBBXZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 20:23:25 -0500
Date: Sat, 2 Dec 2017 02:23:24 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171202012324.GB20205@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 02, 2017 at 08:27:56 +0800, Qu Wenruo wrote:

> I assume there is program eating up the space.
> Not btrfs itself.

Very doubtful. I've encountered ext3 "eating" problem once, that couldn't be
find by lsof on 3.4.75 kernel, but the space was returning after killing
Xorg. The system I'm having problem now is very recent, the space
doesn't return after reboot/emergency and doesn't sum up with files.

>> Now, the weird part for me is exclusive data count:
>> 
>> # btrfs sub sh ./snapshot-171125
>> [...]
>>         Subvolume ID:           388
>> # btrfs fi du -s ./snapshot-171125 
>>      Total   Exclusive  Set shared  Filename
>>   21.50GiB    63.35MiB    20.77GiB  snapshot-171125
> 
> That's the difference between how sub show and quota works.
> 
> For quota, it's per-root owner check.

Just to be clear: I've enabled quota _only_ to see subvolume usage on
spot. And exclusive data - the more detailed approach I've described in
e-mail I've send a minute ago.

> Means even a file extent is shared between different inodes, if all
> inodes are inside the same subvolume, it's counted as exclusive.
> And if any of the file extent belongs to other subvolume, then it's
> counted as shared.

Good to know, but this is almost UID0-only system. There are system
users (vendor provided) and 2 ssh accounts for su, but nobody uses this
machine for daily work. The quota values were the last tool I could find
to debug.

> For fi du, it's per-inode owner check. (The exact behavior is a little
> more complex, I'll skip such corner case to make it a little easier to
> understand).
> 
> That's to say, if one file extent is shared by different inodes, then
> it's counted as shared, no matter if these inodes belong to different or
> the same subvolume.
> 
> That's to say, "fi du" has a looser condition for "shared" calculation,
> and that should explain why you have 20+G shared.

There shouldn't be many multi-inode extents inside single subvolume, as this is mostly fresh
system, with no containers, no deduplication, snapshots are taken from
the same running system before or after some more important change is
done. By 'change' I mean altering text config files mostly (plus
etckeeper's git metadata), so the volume of difference is extremelly
low. Actually most of the difs between subvolumes come from updating
distro packages. There were not much reflink copies made on this
partition, only one kernel source compiled (.ccache files removed
today). So this partition is as clean, as it could be after almost
5 months in use.

Actually I should rephrase the problem:

"snapshot has taken 8 GB of space despite nothing has altered source subvolume"

-- 
Tomasz Pala <gotar@pld-linux.org>
