Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:48330 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934191AbdLRWCT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 17:02:19 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:44772)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89_1)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eR3UG-00077x-65
        for linux-btrfs@vger.kernel.org; Mon, 18 Dec 2017 22:02:16 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eR3U0-00050m-TU
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 22:02:00 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23096.15063.957412.712081@tree.ty.sabi.co.uk>
Date: Mon, 18 Dec 2017 22:01:59 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
In-Reply-To: <20171218194351.GA25245@polanet.pl>
References: <5A357909.8010206@yandex.ru>
        <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
        <23094.37316.66397.431081@tree.ty.sabi.co.uk>
        <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
        <20171218194351.GA25245@polanet.pl>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> The fact is, the only cases where this is really an issue is
>> if you've either got intermittently bad hardware, or are
>> dealing with external

> Well, the RAID1+ is all about the failing hardware.

>> storage devices. For the majority of people who are using
>> multi-device setups, the common case is internally connected
>> fixed storage devices with properly working hardware, and for
>> that use case, it works perfectly fine.

> If you're talking about "RAID"-0 or storage pools (volume
> management) that is true. But if you imply, that RAID1+ "works
> perfectly fine as long as hardware works fine" this is
> fundamentally wrong.

I really agree with this, the argument about "properly working
hardware" is utterly ridiculous. I'll to this: apparently I am
not the first one to discover the "anomalies" in the "RAID"
profiles, but I may have been the first to document some of
them, e.g. the famous issues with the 'raid1' profile. How did I
discover them? Well, I had used Btrfs in single device mode for
a bit, and wanted to try multi-device, and the docs seemed
"strange", so I did tests before trying it out.

The tests were simply on a spare PC with a bunch of old disks to
create two block devices (partitions), put them in 'raid1' first
natively, then by adding a new member to an existing partition,
and then 'remove' one, or simply unplug it (actually 'echo 1 >
/sys/block/.../device/delete') initially. I wanted to check
exactly what happened, resync times, speed, behaviour and speed
when degraded, just ordinary operational tasks.

Well I found significant problems after less than one hour. I
can't imagine anyone with some experience of hw or sw RAID
(especially hw RAID, as hw RAID firmware is often fantastically
buggy especially as to RAID operations) that wouldn't have done
the same tests before operational use, and would not have found
the same issues too straight away. The only guess I could draw
is that whover designed the "RAID" profile had zero operational
system administration experience.

> If the hardware needs to work properly for the RAID to work
> properly, noone would need this RAID in the first place.

It is not just that, but some maintenance operations are needed
even if the hardware works properly: for example preventive
maintenance, replacing drives that are becoming too old,
expanding capacity, testing periodically hardware bits. Systems
engineers don't just say "it works, let's assume it continues to
work properly, why worry".

My impression is that multi-device and "chunks" were designed in
one way by someone, and someone else did not understand the
intent, and confused them with "RAID", and based the 'raid'
profiles on that confusion. For example the 'raid10' profile
seems the least confused to me, and that's I think because the
"RAID" aspect is kept more distinct from the "multi-device"
aspect. But perhaps I am an optimist...

To simplify a longer discussion to have "RAID" one needs an
explicit design concept of "stripe", which in Btrfs needs to be
quite different from that of "set of member devices" and
"chunks", so that for example adding/removing to a "stripe" is
not quite the same thing as adding/removing members to a volume,
plus to make a distinction between online and offline members,
not just added and removed ones, and well-defined state machine
transitions (e.g. in response to hardware problems) among all
those, like in MD RAID. But the importance of such distinctions
may not be apparent to everybody.

But I may have read comments in which "block device" (a data
container on some medium), "block device inode" (a descriptor
for that) and "block device name" (a path to a "block device
inode") were hopelessly confused, so I don't hold a lot of
hope. :-(
