Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54885 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbdIIMUn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 08:20:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dqekH-00051Z-6s
        for linux-btrfs@vger.kernel.org; Sat, 09 Sep 2017 14:20:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Please help with exact actions for raid1 hot-swap
Date: Sat, 9 Sep 2017 12:19:49 +0000 (UTC)
Message-ID: <pan$2f301$e10816b5$b2720187$72f9315c@cox.net>
References: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru>
        <9D2B6B65-7DE9-4922-82DC-08BF3A3A2E09@rqc.ru>
        <CAA7pwKMuv69dsXZGXEASN=qarSv3tCYU=-k1sHquL_tm4FU0kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik Lundquist posted on Sat, 09 Sep 2017 12:29:08 +0200 as excerpted:

> On 9 September 2017 at 12:05, Marat Khalili <mkh@rqc.ru> wrote:
>> Forgot to add, I've got a spare empty bay if it can be useful here.
> 
> That makes it much easier since you don't have to mount it degraded,
> with the risks involved.
> 
> Add and partition the disk.
> 
> # btrfs replace start /dev/sdb7 /dev/sdc(?)7 /mnt/data
> 
> Remove the old disk when it is done.

I did this with my dozen-plus (but small) btrfs raid1s on ssd partitions 
several kernel cycles ago.  It went very smoothly. =:^)

(TL;DR can stop there.)

I had actually been taking advantage of btrfs raid1's checksumming and 
scrub ability to continue running a failing ssd, with more and more 
sectors going bad and being replaced from spares, for quite some time 
after I'd have otherwise replaced it.  Everything of value was backed up, 
and I was simply doing it for the experience with both btrfs raid1 
scrubbing and continuing ssd sector failure.  But eventually the scrubs 
were finding and fixing errors every boot, especially when off for 
several hours, and further experience was of diminishing value while the 
hassle factor was building fast, so I attached the spare ssd, partitioned 
it up, did a final scrub on all the btrfs, and then one btrfs at a time 
btrfs replaced the devices from the old ssd's partitions to the new one's 
partitions.  Given that I was already used to running scrubs at every 
boot, the entirely uneventful replacements were actually somewhat 
anticlimactic, but that was a good thing! =:^)

Then more recently I bought a larger/newer pair of ssds (1 TB each, the 
old ones were quarter TB each) and converted my media partitions and 
secondary backups, which had still been on reiserfs on spinning rust, to 
btrfs raid1 on ssd as well, making me all-btrfs on all-ssd now, with 
everything but /boot and its backups on the other ssds being btrfs raid1, 
and /boot and its backups being btrfs dup. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

