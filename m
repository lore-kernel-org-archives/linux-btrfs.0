Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [69.252.207.42] ([69.252.207.42]:48620 "EHLO
	resqmta-ch2-10v.sys.comcast.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbaLOItr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 03:49:47 -0500
Message-ID: <548EA090.60308@pobox.com>
Date: Mon, 15 Dec 2014 00:49:20 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Nick Dimov <dimovnike@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive being very slow
References: <548E68A3.8040608@gmail.com> <548E8373.8060900@pobox.com> <548E90C7.8030209@gmail.com>
In-Reply-To: <548E90C7.8030209@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2014 11:41 PM, Nick Dimov wrote:
> Hi, thanks for the answer, I will answer between the lines.
>
> On 15.12.2014 08:45, Robert White wrote:
>> On 12/14/2014 08:50 PM, Nick Dimov wrote:
>>> Hello everyone!
>>>
>>> First, thanks for amazing work on btrfs filesystem!
>>>
>>> Now the problem:
>>> I use a ssd as my system drive (/dev/sda2) and use daily snapshots on
>>> it. Then, from time to time, i sync those on HDD (/dev/sdb4) by using
>>> btrfs send / receive like this:
>>>
>>> ionice -c3 btrfs send -p /ssd/previously_synced_snapshot /ssd/snapshot-X
>>> | pv | btrfs receive /hdd/snapshots
>>>
>>> I use pv to measure speed and i get ridiculos speeds like 5-200kiB/s!
>>> (rarely it goes over 1miB). However if i replace the btrfs receive with
>>> cat >/dev/null - the speed is 400-500MiB/s (almost full SSD speed) so I
>>> understand that the problem is the fs on the HDD... Do you have any idea
>>> of how to trace this problem down?
>>
>>
>> You have _lots_ of problems with that above...
>>
>> (1) your ionice is causing the SSD to stall the send every time the
>> receiver does _anything_.
> I will try to remove completely ionice - but them my system becomes
> irresponsive :(

Yep, see below.

Then again if it only goes bad for a minute or two, then just launch the 
backup right as you go for a break.

>>
>> (1a) The ionice doesn't apply to the pipeline, it only applies to the
>> command it proceeds. So it's "ionice -c btrfs send..." then pipeline
>> then "btrfs receive" at the default io scheduling class. You need to
>> specify it twice, or wrap it all in a script.
>>
>> ionice -c 3 btrfs send -p /ssd/parent /ssd/snapshot-X |
>> ionice -c 3 btrfs receive /hdd/snapshots
> This is usually what i do but I wanted to show that there is no throtle
> on the receiver. (i tested it with and without - the result is the same)
>>
>> (1b) Your comparison case is flawed because cat >/dev/null results in
>> no actual IO (e.g. writing to dev-null doesn't transfer any data
>> anywhere, it just gets rubber-stamped okay at the kernel method level).
> This was only an intention to show that the sender itself is OK.

I understood why you did it, I was just trying to point out that since 
there was no other IO competing with the btrfs send, it would give you 
are really outrageously false positive. Particularly if you always used 
ionice.

>>
>> (2) You probably get negative-to-no value from using ionice on the
>> sending side, particularly since SSDs don't have physical heads to
>> seek around.
> yeah in theory it should be like this, but in practice on my system -
> when i use no ionice my system becomes very unresponsive (ubuntu 14.10).

What all is in the snapshot? Is it your whole system or just /home or 
what? e.g. what are your subvolume boundaries if any?

btrfs send is very efficent, but that efficency means that it can rifle 
through a heck of a lot of the parent snapshot and decide it doesn't 
need sending, and it can do so very fast, and that can be a huge hit on 
other activities. If most of your system doesn't change between 
snapshots the send will plow through your disk yelling "nope" and "skip 
this" like a shopper in a black firday riot.


>> (2a) The value of nicing your IO is trivial on the actual SATA buss,
>> the real value is only realized on a rotating media where the cost of
>> interrupting other-normal-process is very high because you have to
>> seek the heads way over there---> when other-normal-process needs them
>> right here.
>>
>> (2b) Any pipeline will naturally throttle a more-left-end process to
>> wait for a more-right-end process to read the data. The default buffer
>> is really small, living in the neighborhood of "MAX_PIPE" so like 5k
>> last time I looked. If you want to throttle this sort of transfer just
>> throttle the writer. So..
>>
>> btrfs send -p /ssd/parent /ssd/snapshot-X |
>> ionice -c 3 btrfs receive /hdd/snapshots
>>
>> (3) You need to find out if you are treating things nicely on
>> /hdd/snapshots. If you've hoarded a lot of snapshots on there, or your
>> snapshot history is really deep, or you are using the drive for other
>> purposes that are unfriendly to large allocations, or you've laid out
>> a multi-drive array poorly, then it may need some maintenance.
> Yes this is what I suspect too, that the system is too fragmented. I
> have about 15 snapshots now, but new snapshots are created and older
> ones are deleted, is it possible that this caused the problem?
> is there a way to tell how badly the file system is fragmented?

Fifteen snapshots is fine. There have been some people on here taking 
snapshots every hour and keeping them for months. That gets excessive. 
As long as there is a reasonable amount of free space and you don't have 
weeks of hourly snapshots hanging around, this shouldn't be an issue.

>>
>> (3a) Test the raw receive throughput if you have the space to share.
>> To do this save the output of btrfs send to a file with -f some_file.
>> Then run the receive with -f some_file. Ideally some_file will be on
>> yet a third media, but it's okay if its on /hdd/snapshot somewhere.
>> Watch the output of iotop or your favorite graphical monitoring
>> daemon. If the write throughput is suspiciously low you may be dealing
>> with a fragmented filesystem.
> Great idea. Will try this.
>>
>> (3b) If /hdd/snapshots is a multi-device filesystem and you are using
>> "single" for data extents, try switching to RAID0. It's just as
>> _unsafe_ as "single" but its distributed write layout will speed up
>> your storage.
> Its single device.
>>
>> (4) If your system is busy enough that you really need the ionice, you
>> likely just need to really re-think your storage layouts and whatnot.
> Well, its a laptop :) and i'm not doing anything when the sync happens.
> I do ionice because without it - the system becomes unresponsive and I
> can't even browse the internet (it just freezes for 20 seconds or so).
> But this has to do with the sender somehow... (probably saturates the
> SATA throughput at 500mb/s?)

On a laptop, yea, that's probably gonna happen way more than on a server 
of some sort.

There are a lot of interractions between the "hot" parts of programs, 
the way programs are brought into memory with mmap(), and how the disk 
cache works. When you start hoovering things up off your hard disk, 
particularly while send is comparing the snapshots and finding what it's 
_not_ going to send (such as all of /bin /usr/bin /lib /usr/lib etc) 
that high performance drive with that high performance bus will just 
muscle-aside significant parts of your browser and all the other "user 
facing" stuff.

Then you have to get back in line to re-fetch the stuff that just got 
dropped from memory when you go back to your browser or whatever.

With a fast SSD and fast SATA bus you _are_ going to feel the send if 
its full speed. Your system is going to be _busy_.

But that's a separate thing from your question about effective 
throughput. The pipeline you gave wiht both ends ioniced will turn into 
a dainty little tea-party with each actor walking in lock-step and 
repeatedly saying "no, after you" and then waiting for the other to finish.

Check out the ionice page description of the Idle scheduler...

A program running with idle io priority will only get disk time when no 
other program has asked for disk io for a defined *grace* *period*. The 
impact of idle io processes on normal system activity should be zero. 
This scheduling class does not take a priority argument. Presently, this 
scheduling class is permitted for an ordinary user (since kernel 2.6.25).

Grace Period. Think about those two words...

So btrfs send goes out and tells receive to create a file named XXX, as 
soon as receive acts on that message btrfs send _stops_ _dead_, waits 
for it to finish, waits for the grace period, _then_ does its next thing.

If they are _both_ niced then they _both_ wait for eachother with a 
little grace period before the other gets to go.

That will take _all_ the time... So much so that your darn right, the 
send/receive will _not_ get the chance to effect your browser.

Oh, and every cookie your browser writes will barge through and stop 
them both.

So yeah... _slow_... really, really, slow with two ionice processes in a 
pipeline.

I'd just leave off the ionice and schedule my snapshot resends for right 
before I take a bathroom break... 8-)


>> (5) Remember to evaluate the secondary system effects. For example If
>> /hdd/snapshots is really a USB attached external storage unit, make
>> sure it's USB3 and so is the port you're plugging it into. Make sure
>> you aren't paging/swapping in the general sense (or just on the cusp
>> of doing so) as both of the programs are going to start competing with
>> your system for buffer cache and whatnot. A "nearly busy" system can
>> be pushed over the edge into thrashing by adding two large-IO tasks
>> like these.
>>
>> (5b) Give /hdd/snapshots the once-over with smartmontools, especially
>> if it's old, to make sure its not starting to have read/write retry
>> delays. Old disks can get "slower" before the get all "failed".
>>
>> And remember, you may not be able to do squat about your results. If
>> you are I/O bound, and you just _can't_ bear to part wiht some subset
>> of your snapshot hoard for any reason (e.g. I know some government
>> programs with hellish retention policies), then you might just be
>> living the practical outcome of your policies and available hardware.
>>
>>
> Thanks again for the answer I will try to do the tests described here
> and get back.
> Cheers!
>

