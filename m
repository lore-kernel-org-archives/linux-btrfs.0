Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aarghimedes.fi ([62.75.165.48]:35568 "EHLO aarghimedes.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbcFKDLe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 23:11:34 -0400
Received: from [192.168.2.120] (79-134-100-39.cust.suomicom.net [79.134.100.39])
	by aarghimedes.fi (Postfix) with ESMTPSA id A75DD63C58D9
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jun 2016 06:11:30 +0300 (EEST)
Subject: Re: Kernel crash on mount after SMR disk trouble
References: <5736DFA3.3090904@aarghimedes.fi>
 <CAPmG0ja9J40q0npcANz=gN1EAiNOc400NjjA5V1wV_FFMPc02Q@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jukka Larja <roskakori@aarghimedes.fi>
Message-ID: <575B816B.90506@aarghimedes.fi>
Date: Sat, 11 Jun 2016 06:11:39 +0300
MIME-Version: 1.0
In-Reply-To: <CAPmG0ja9J40q0npcANz=gN1EAiNOc400NjjA5V1wV_FFMPc02Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

10.6.2016, 23.20, Henk Slager kirjoitti:
> On Sat, May 14, 2016 at 10:19 AM, Jukka Larja <roskakori@aarghimedes.fi> wrote:
>> In short:
>>
>> I added two 8TB Seagate Archive SMR disk to btrfs pool and tried to delete
>> one of the old disks. After some errors I ended up with file system that can
>> be mounted read-only, but crashes the kernel if mounted normally. Tried
>> btrfs check --repair (which noted that space cache needs to be zeroed) and
>> zeroing space cache (via mount parameter), but that didn't change anything.
>>
>> Longer version:
>>
>> I was originally running Debian Jessie with some pretty recent kernel (maybe
>> 4.4), but somewhat older btrfs tools. After the trouble started, I tried
>
> You should at least have kernel 4.4, the critical patch for supporting
> this drive was added in 4.4-rc3 or 4.4-rc4, i dont remember exactly.
> Only if you somehow disable NCQ completely in your linux system
> (kernel and more) or use a HW chipset/bridge that does that for you it
> might work.

After the crash I tracked the issue somewhat and found a discussion about 
very similar issue (starting with drives failing with dd or badblocks and 
ending, after several patches, to drives working in everything except maybe 
in Btrfs in certain cases). As far as I could tell, the 4.5 kernel has all 
the patches from that discussion, but I may have missed something that 
wasn't mentioned there.

>> updating (now running Kernel 4.5.1 and tools 4.4.1). I checked the new disks
>> with badblocks (no problems found), but based on some googling, Seagate's
>> SMR disks seem to have various problems, so the root cause is probably one
>> type or another of disk errors.
>
> Seagate provides a special variant of the linux ext4 fs system that
> should then play well with their SMR drive. Also the advice is to not
> use this drive in a array setup; the risk is way to high that they
> can't keep up with the demands of the higher layers and then get
> resets or their FW crashes. You should have had also have a look at
> your system's and drive timeouts (see scterc). To summarize: adding
> those drives to an btrfs raid array is asking for trouble.

Increasing timeouts didn't help with the drive. Array freezes when drive 
drops out, then there's a crash when timeout occurs. It doesn't matter if 
the drive has come back in the mean time (drive doesn't return with same 
/dev/sdX, though I don't know if that matters for Btrfs).

I always thought that the problem with these drives was supposed to be bad 
performance and worse than usual ability to handle power going out. My use 
case is quite light from bytes written point of view, so I didn't expect 
trouble. Of course, doing the initial add + balance isn't light at all.

What I don't expect is what's essentially write errors. Pity, since the 
disks are dirt cheap compared to alternatives and I really don't care about 
performance.

> I am using 1 such drive with an Intel J1900 SoC (Atom, SATA2) and it
> works, although I get still the typical error occasionally. As it is
> just a btrfs receive target, just 1 fs dup/dup/single for the whole
> drive, all CoW, it survives those lockups or crashes, I just restart
> the board+drive. In general, reading back multi-TB ro snapshots works
> fine and is on par with Gbps LAN speeds.

I'll probably test those drives as a target for DVR backups, when I get them 
out of the array (still waiting for new drives with which to start over. 
Then I just tear down the old array).

> Indeed kernel should not crash on such a case. It is not clear if you
> run a 4.5.1 or 4.5.0 kernel in terms of kernel.org terminology, but
> newer than 4.5.x probably does not help in this case.
> You could try to mount with usebackuproot and then see if you can get
> it writable, after setting long timeout values for the drive. If it
> works, then remove those 2 SMRs from the array ASAP.

I understand that usebackuproot requires kernel >= 4.6. I probably won't be 
installing a custom kernel, but if I still have the array in its current 
state when 4.6 becomes available in Debian Stretch, I'll give it a try.

-- 
      ...Elämälle vierasta toimintaa...
      Jukka Larja, jlarja@iki.fi, 0407679919

"... on paper looked like a great chip (10 GFs at 1.2 GHZ whith 35W"
"It's a mystery to me why people continue to use silicon - processors on 
paper are always faster and cooler :-)"
- lubemark and Richard Cownie on RWT forums -

