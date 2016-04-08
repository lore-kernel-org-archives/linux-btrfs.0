Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34527 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbcDHL3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 07:29:46 -0400
Received: by mail-qg0-f43.google.com with SMTP id c6so87472802qga.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 04:29:45 -0700 (PDT)
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
To: Chris Murphy <lists@colorremedies.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
 <CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
 <57064231.2070201@gmail.com>
 <CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
Cc: Ank Ular <ankular.anime@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5707961D.6000803@gmail.com>
Date: Fri, 8 Apr 2016 07:29:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-07 15:32, Chris Murphy wrote:
> On Thu, Apr 7, 2016 at 5:19 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-04-06 19:08, Chris Murphy wrote:
>>>
>>> On Wed, Apr 6, 2016 at 9:34 AM, Ank Ular <ankular.anime@gmail.com> wrote:
>>>
>>>>
>>>>   From the ouput of 'dmesg', the section:
>>>> [   20.998071] BTRFS: device label FSgyroA devid 9 transid 625039
>>>> /dev/sdm
>>>> [   20.999984] BTRFS: device label FSgyroA devid 10 transid 625039
>>>> /dev/sdn
>>>> [   21.004127] BTRFS: device label FSgyroA devid 11 transid 625039
>>>> /dev/sds
>>>> [   21.011808] BTRFS: device label FSgyroA devid 12 transid 625039
>>>> /dev/sdu
>>>>
>>>> bothers me because the transid value of these four devices doesn't
>>>> match the other 16 devices in the pool {should be 625065}. In theory,
>>>> I believe these should all have the same transid value. These four
>>>> devices are all on a single USB 3.0 port and this is the link I
>>>> believe went down and came back up.
>>>
>>>
>>> This is effectively a 4 disk failure and raid6 only allows for 2.
>>>
>>> Now, a valid complaint is that as soon as Btrfs is seeing write
>>> failures for 3 devices, it needs to go read-only. Specifically, it
>>> would go read only upon 3 or more write errors affecting a single full
>>> raid stripe (data and parity strips combined); and that's because such
>>> a write is fully failed.
>>
>> AFAIUI, currently, BTRFS will fail that stripe, but not retry it, _but_
>> after that, it will start writing out narrower stripes across the remaining
>> disks if there are enough for it to maintain the data consistency (so if
>> there's at least 3 for raid6 (I think, I don't remember if our lower limit
>> is 3 (which is degenerate), or 4 (which isn't, but most other software won't
>> let you use it for some stupid reason))).  Based on this, if the FS does get
>> recovered, make sure to run a balance on it too, otherwise you might have
>> some sub-optimal striping for some data.
>
> I can see this being happening automatically with up to 2 device
> failures, so that all subsequent writes are fully intact stripe
> writes. But the instant there's a 3rd device failure, there's a rather
> large hole in the file system that can't be reconstructed. It's an
> invalid file system. I'm not sure what can be gained by allowing
> writes to continue, other than tying off loose ends (so to speak) with
> full stripe metadata writes for the purpose of making recovery
> possible and easier, but after that metadata is written - poof, go
> read only.
I don't mean writing partial stripes, I mean writing full stripes with a 
reduced width (so in an 8 device filesystem, if 3 devices fail, we can 
still technically write a complete stripe across 5 devices, but it will 
result in less total space we can use).  Whether or not this behavior is 
correct is another argument, but that appears to be what we do 
currently.  Ideally, this should be a mount option, as strictly 
speaking, it's policy, which therefore shouldn't be in the kernel.
>
>>
>>>
>>> You literally might have to splice superblocks and write them to 16
>>> drives in exactly 3 locations per drive (well, maybe just one of them,
>>> and then delete the magic from the other two, and then 'btrfs rescue
>>> super-recover' should then use the one good copy to fix the two bad
>>> copies).
>>>
>>> Sigh.... maybe?
>>>
>>> In theory it's possible, I just don't know the state of the tools. But
>>> I'm fairly sure the best chance of recovery is going to be on the 4
>>> drives that abruptly vanished.  Their supers will be mostly correct or
>>> close to it: and that's what has all the roots in it: tree, fs, chunk,
>>> extent and csum. And all of those states are better farther in the
>>> past, rather than the 16 drives that have much newer writes.
>>
>> FWIW, it is actually possible to do this, I've done it before myself on much
>> smaller raid1 filesystems with single drives disappearing, and once with a
>> raid6 filesystem with a double drive failure.  It is by no means easy, and
>> there's not much in the tools that helps with it, but it is possible
>> (although I sincerely hope I never have to do it again myself).
>
> I think considering the idea of Btrfs is to be more scalable than past
> storage and filesystems have been, it needs to be able to deal with
> transient failures like this. In theory all available information is
> written on all the disks. This was a temporary failure. Once all
> devices are made available again, the fs should be able to figure out
> what to do, even so far as salvaging the writes that happened after
> the 4 devices went missing if those were successful full stripe
> writes.
I entirely agree.  If the fix doesn't require any kind of decision to be 
made other than whether to fix it or not, it should be trivially fixable 
with the tools.  TBH though, this particular issue with devices 
disappearing and reappearing could be fixed easier in the block layer 
(at least, there are things that need to be fixed WRT it in the block 
layer).
>
>>>
>>> Of course it is possible there's corruption problems with those four
>>> drives having vanished while writes were incomplete. But if you're
>>> lucky, data write happen first, then metadata writes second, and only
>>> then is the super updated. So the super should point to valid metadata
>>> and that should point to valid data. If that order is wrong, then it's
>>> bad news and you have to look at backup roots. But *if* you get all
>>> the supers correct and on the same page, you can access the backup
>>> roots by using -o recovery if corruption is found with a normal mount.
>>
>> This though is where the potential issue is.  -o recovery will only go back
>> so many generations before refusing to mount, and I think that may be why
>> it's not working now..
>
> It also looks like none of the tools are considering the stale supers
> on the formerly missing 4 devices. I still think those are the best
> chance to recover because even if their most current data is wrong due
> to reordered writes not making it to stable storage, one of the
> available backups in those supers should be good.
>
Depending on utilization on the other devices though, they may not point 
to complete roots either.  In this case, they probably will because of 
the low write frequency.  In other cases, they may not though, because 
we try to reuse space in chunks before allocating new chunks.
