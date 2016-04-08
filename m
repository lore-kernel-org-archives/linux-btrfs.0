Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35020 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758705AbcDHQR1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 12:17:27 -0400
Received: by mail-io0-f182.google.com with SMTP id g185so137549923ioa.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 09:17:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5707961D.6000803@gmail.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
	<CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
	<57064231.2070201@gmail.com>
	<CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
	<5707961D.6000803@gmail.com>
Date: Fri, 8 Apr 2016 10:17:26 -0600
Message-ID: <CAJCQCtT1Pt__k+aYqSjNPLmcgpH7F4N+ueJ3b+z+aVTYTYtGEg@mail.gmail.com>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Ank Ular <ankular.anime@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 8, 2016 at 5:29 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>> I can see this being happening automatically with up to 2 device
>> failures, so that all subsequent writes are fully intact stripe
>> writes. But the instant there's a 3rd device failure, there's a rather
>> large hole in the file system that can't be reconstructed. It's an
>> invalid file system. I'm not sure what can be gained by allowing
>> writes to continue, other than tying off loose ends (so to speak) with
>> full stripe metadata writes for the purpose of making recovery
>> possible and easier, but after that metadata is written - poof, go
>> read only.
>
> I don't mean writing partial stripes, I mean writing full stripes with a
> reduced width (so in an 8 device filesystem, if 3 devices fail, we can still
> technically write a complete stripe across 5 devices, but it will result in
> less total space we can use).

I understand what you mean, it was clear before. The problem is that
once its below the critical number of drives, the previously existing
file system is busted. So it should go read only. But it can't because
it doesn't yet have the concept of faulty devices, *and* also an
understanding of how many faulty devices can be tolerated before
there's a totally untenable hole in the file system.




>Whether or not this behavior is correct is
> another argument, but that appears to be what we do currently.  Ideally,
> this should be a mount option, as strictly speaking, it's policy, which
> therefore shouldn't be in the kernel.

I think we can definitely agree the current behavior is suboptimal
because in fact whatever it wrote to 16 drives was sufficiently
confusing that mounting all 20 drives again isn't possible no matter
what option is used.




>> I think considering the idea of Btrfs is to be more scalable than past
>> storage and filesystems have been, it needs to be able to deal with
>> transient failures like this. In theory all available information is
>> written on all the disks. This was a temporary failure. Once all
>> devices are made available again, the fs should be able to figure out
>> what to do, even so far as salvaging the writes that happened after
>> the 4 devices went missing if those were successful full stripe
>> writes.
>
> I entirely agree.  If the fix doesn't require any kind of decision to be
> made other than whether to fix it or not, it should be trivially fixable
> with the tools.  TBH though, this particular issue with devices disappearing
> and reappearing could be fixed easier in the block layer (at least, there
> are things that need to be fixed WRT it in the block layer).

Right. The block layer needs a way to communicate device missing to
Btrfs and Btrfs needs to have some tolerance for transience.

>>
>>
>>>>
>>>> Of course it is possible there's corruption problems with those four
>>>> drives having vanished while writes were incomplete. But if you're
>>>> lucky, data write happen first, then metadata writes second, and only
>>>> then is the super updated. So the super should point to valid metadata
>>>> and that should point to valid data. If that order is wrong, then it's
>>>> bad news and you have to look at backup roots. But *if* you get all
>>>> the supers correct and on the same page, you can access the backup
>>>> roots by using -o recovery if corruption is found with a normal mount.
>>>
>>>
>>> This though is where the potential issue is.  -o recovery will only go
>>> back
>>> so many generations before refusing to mount, and I think that may be why
>>> it's not working now..
>>
>>
>> It also looks like none of the tools are considering the stale supers
>> on the formerly missing 4 devices. I still think those are the best
>> chance to recover because even if their most current data is wrong due
>> to reordered writes not making it to stable storage, one of the
>> available backups in those supers should be good.
>>
> Depending on utilization on the other devices though, they may not point to
> complete roots either.  In this case, they probably will because of the low
> write frequency.  In other cases, they may not though, because we try to
> reuse space in chunks before allocating new chunks.

Based on the superblock posted, I think the *38 generation tree might
be incomplete, but there's a *37 and *36 generation that should be
intact. Chunk generation is the same.

What complicates the rollback is any deletions were happening at the
time. If it's just file additions, I think a rollback has a good
chance of working. It's just tedious.


-- 
Chris Murphy
