Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:33797 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbcFLPY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 11:24:59 -0400
Received: by mail-vk0-f50.google.com with SMTP id t129so23659376vka.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 08:24:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
 <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net> <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
From: Henk Slager <eye1tm@gmail.com>
Date: Sun, 12 Jun 2016 17:24:57 +0200
Message-ID: <CAPmG0jYrstbaBkL98YrwQk4CXxmBOo4nXd=waAJ9tXGc_WpTag@mail.gmail.com>
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
To: boli <btrfs@bueechi.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 12, 2016 at 12:35 PM, boli <btrfs@bueechi.net> wrote:
>> It has now been doing "btrfs device delete missing /mnt" for about 90 hours.
>>
>> These 90 hours seem like a rather long time, given that a rebalance/convert from 4-disk-raid5 to 4-disk-raid1 took about 20 hours months ago, and a scrub takes about 7 hours (4-disk-raid1).
>>
>> OTOH the filesystem will be rather full with only 3 of 4 disks available, so I do expect it to take somewhat "longer than usual".
>>
>> Would anyone venture a guess as to how long it might take?
>
> It's done now, and took close to 99 hours to rebalance 8.1 TB of data from a 4x6TB raid1 (12 TB capacity) with 1 drive missing onto the remaining 3x6TB raid1 (9 TB capacity).

Indeed, it not clear why it takes 4 days for such an action. You
indicated that you cannot add an online 5th drive, so then you and
intermediate compaction of the fs to less drives is a way to handle
this issue. There are 2 ways however:

1) Keeping the to-be-replaced drive online until a btrfs dev remove of
it from the fs of it is finished and only then replace a 6TB with an
8TB in the drivebay. So in this case, one needs enough free capacity
on the fs (which you had) and full btrfs raid1 redundancy is there all
the time.

2) Take a 6TB out of the drivebay first and then do the btrfs dev
remove, in this case on a really missing disk. This way, the fs is in
degraded mode (or mounted as such) and the action of remove missing is
also a sort of 'reconstruction'. I don't know the details of the code,
but I can imagine that it has performance implications.

> Now I made sure quotas were off, then started a screen to fill the new 8 TB disk with zeros, detached it and and checked iotop to get a rough estimate on how long it will take (I'm aware it will become slower in time).
>
> After that I'll add this 8 TB disk to the btrfs raid1 (for yet another rebalance).
>
> The next 3 disks will be replaced with "btrfs replace", so only one rebalance each is needed.
>
> I assume each "btrfs replace" would do a full rebalance, and thus assign chunks according to the normal strategy of choosing the two drives with the most free space, which in this case would be a chunk to the new drive, and a mirrored chunk to that existing 3 drive with most free space.
>
> What I'm wondering is this:
> If the goal is to replace 4x 6TB drive (raid1) with 4x 8TB drive (still raid1), is there a way to remove one 6 TB drive at a time, recreate its exact contents from the other 3 drives onto a new 8 TB drive, without doing a full rebalance? That is: without writing any substantial amount of data onto the remaining 3 drives.

There isn't such a way. This goal has a violation in itself with
respect to redundancy (btrfs raid1).

> It seems to me that would be a lot more efficient, but it would go against the normal chunk assignment strategy.

man btrfs-replace and option -r I would say. But still, having a 5th
drive online available makes things much easier and faster and solid
and is the way to do a drive replace. You can then do a normal replace
and there is just highspeed data transfer for the old and the new disk
and only for parts/blocks of the disk that contain filedata. So it is
not a sector-by-sector copying also deleted blocks, but from end-user
perspective is an exact copy. There are patches ('hot spare') that
assume it to be this way, but they aren't in the mainline kernel yet.

The btrfs-replace should work ok for btrfs raid1 fs (at least it
worked ok for btrfs raid10 half a year ago I can confirm), if the fs
is mostly idle during the replace (almost no new files added). Still,
you might want to have the replace related fixes added in kernel
4.7-rc2.

Another less likely reason for the performance issue is that the fs is
changed from raid5 and has 4k nodesize. btrfs-show-super can show you
that. It should not be, but my experience for a delete / add sequence
for such a case is that is very slow.
