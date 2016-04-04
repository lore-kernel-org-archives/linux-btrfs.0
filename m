Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35995 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbcDDT5w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 15:57:52 -0400
Received: by mail-ig0-f176.google.com with SMTP id f1so87803615igr.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 12:57:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160404213637.58ad33b1@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
	<CAJCQCtTjoQ93wiMRgzHJ+3D_GPwygK1EzGPCFyKdoi1=Mjip_w@mail.gmail.com>
	<20160404213637.58ad33b1@jupiter.sol.kaishome.de>
Date: Mon, 4 Apr 2016 13:57:50 -0600
Message-ID: <CAJCQCtQdGG3o9mu2u=Vjc0rN+0eLWYVXikH5KtfOap2SijjSKA@mail.gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 4, 2016 at 1:36 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

>
>> > I guess the
>> > seed source cannot be mounted or modified...
>>
>> ?
>
> In the following sense: I should disable the automounter and backup job
> for the seed device while I let my data migrate back to main storage in
> the background...

The sprout can be written to just fine by the backup, just understand
that the seed and sprout volume UUID are different. Your automounter
is probably looking for the seed's UUID, and that seed can only be
mounted ro. The sprout UUID however can be mounted rw.

I would probably skip the automounter. Do the seed setup, mount it,
add all devices you're planning to add, then -o remount,rw,compress...
, and then activate the backup. But maybe your backup also is looking
for UUID? If so, that needs to be updated first. Once the balance
-dconvert=raid1 and -mconvert=raid1 is finished, then you can remove
the seed device. And now might be a good time to give the raid1 a new
label, I think it inherits the label of the seed but I'm not certain
of this.


> My intention is to use fully my system while btrfs migrates the data
> from seed to main storage. Then, afterwards I'd like to continue using
> the seed device for backups.
>
> I'd probably do the following:
>
> 1. create btrfs pool, attach seed

I don't understand that step in terms of commands. Sprouts are made
with btrfs dev add, not with mkfs. There is no pool creation. You make
a seed. You mount it. Add devices to it. Then remount it.


> 2. recreate my original subvolume structure by snapshotting the backup
>    scratch area multiple times into each subvolume
> 3. rearrange the files in each subvolume to match their intended use by
>    using rm and mv
> 4. reboot into full system
> 4. remove all left-over snapshots from the seed
> 5. remove (detach) the seed device

You have two 4's.

Anyway the 2nd 4 is not possible. The seed is ro by definition so you
can't remove snapshots from the seed. If you remove them from the
mounted rw sprout volume, they're removed from the sprout, not the
seed. If you want them on the sprout, but not on the seed, you need to
delete snapshots only after the seed is a.) removed from the sprout
and b.) made no longer a seed with btrfstune -S 0 and c.) mounted rw.




-- 
Chris Murphy
