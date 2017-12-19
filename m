Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:39137 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967246AbdLSMrF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 07:47:05 -0500
Received: by mail-it0-f47.google.com with SMTP id 68so2635733ite.4
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 04:47:05 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <23096.15063.957412.712081@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <41e8ba5f-205d-ede5-e613-86896d463e4f@gmail.com>
Date: Tue, 19 Dec 2017 07:46:58 -0500
MIME-Version: 1.0
In-Reply-To: <23096.15063.957412.712081@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-18 17:01, Peter Grandi wrote:
>>> The fact is, the only cases where this is really an issue is
>>> if you've either got intermittently bad hardware, or are
>>> dealing with external
> 
>> Well, the RAID1+ is all about the failing hardware.
> 
>>> storage devices. For the majority of people who are using
>>> multi-device setups, the common case is internally connected
>>> fixed storage devices with properly working hardware, and for
>>> that use case, it works perfectly fine.
> 
>> If you're talking about "RAID"-0 or storage pools (volume
>> management) that is true. But if you imply, that RAID1+ "works
>> perfectly fine as long as hardware works fine" this is
>> fundamentally wrong.
> 
> I really agree with this, the argument about "properly working
> hardware" is utterly ridiculous. I'll to this: apparently I am
> not the first one to discover the "anomalies" in the "RAID"
> profiles, but I may have been the first to document some of
> them, e.g. the famous issues with the 'raid1' profile. How did I
> discover them? Well, I had used Btrfs in single device mode for
> a bit, and wanted to try multi-device, and the docs seemed
> "strange", so I did tests before trying it out.
> 
> The tests were simply on a spare PC with a bunch of old disks to
> create two block devices (partitions), put them in 'raid1' first
> natively, then by adding a new member to an existing partition,
> and then 'remove' one, or simply unplug it (actually 'echo 1 >
> /sys/block/.../device/delete') initially. I wanted to check
> exactly what happened, resync times, speed, behaviour and speed
> when degraded, just ordinary operational tasks.
> 
> Well I found significant problems after less than one hour. I
> can't imagine anyone with some experience of hw or sw RAID
> (especially hw RAID, as hw RAID firmware is often fantastically
> buggy especially as to RAID operations) that wouldn't have done
> the same tests before operational use, and would not have found
> the same issues too straight away. The only guess I could draw
> is that whover designed the "RAID" profile had zero operational
> system administration experience.
Or possibly that you didn't read the documentation thoroughly at all, 
which any reasonable system administrator would do before even starting 
to test something.  Unless you were doing stupid stuff like running for 
extended periods of time with half an array or not trying at all to 
repair things after the device reappeared, then none of what you 
described should have caused any issues.
> 
>> If the hardware needs to work properly for the RAID to work
>> properly, noone would need this RAID in the first place.
> 
> It is not just that, but some maintenance operations are needed
> even if the hardware works properly: for example preventive
> maintenance, replacing drives that are becoming too old,
> expanding capacity, testing periodically hardware bits. Systems
> engineers don't just say "it works, let's assume it continues to
> work properly, why worry".
Really?  So replacing hard drives just doesn't work on BTRFS?

Hmm...

Then that means that all the testing I do regularly of reshaping arrays 
and replacing devices that is consistently working (except for raid5 and 
raid6, but those have other issues too right now) must be a complete 
fluke.  I guess I have to go check my hardware and the QEMU sources to 
figure out how those are broken such that all of this is working 
successfully...

Seriously though, did you even _test_ replacing devices using the 
procedures described in the documentation, or did you just see that 
things didn't work in the couple of cases you thought were most 
important and assume nothing else worked?
> 
> My impression is that multi-device and "chunks" were designed in
> one way by someone, and someone else did not understand the
> intent, and confused them with "RAID", and based the 'raid'
> profiles on that confusion. For example the 'raid10' profile
> seems the least confused to me, and that's I think because the
> "RAID" aspect is kept more distinct from the "multi-device"
> aspect. But perhaps I am an optimist...
Then names were a stupid choice intended to convey the basic behavior in 
a way that idiots who have no business being sysadmins could understand 
(and yes, the raid1 profiles do behave as someone with a naive 
understanding of RAID1 as simple replication would expect). 
Unfortunately, we're stuck with them now, and there's no point in 
complaining beyond just acknowledging that the names were a poor choice.
> 
> To simplify a longer discussion to have "RAID" one needs an
> explicit design concept of "stripe", which in Btrfs needs to be
> quite different from that of "set of member devices" and
> "chunks", so that for example adding/removing to a "stripe" is
> not quite the same thing as adding/removing members to a volume,
> plus to make a distinction between online and offline members,
> not just added and removed ones, and well-defined state machine
> transitions (e.g. in response to hardware problems) among all
> those, like in MD RAID. But the importance of such distinctions
> may not be apparent to everybody.
Or maybe people are sensible and don't care about such distinctions as 
long as things work within the defined parameters?  It's only engineers 
and scientists that care about how and why (or stuffy bureaucrats who 
want control over things).  Regular users, and even some developers 
don't care about the exact implementation provided it works how they 
need it to work.
> 
[Obviously intentionally inflammatory comment removed]
