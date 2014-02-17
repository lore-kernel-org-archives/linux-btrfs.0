Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56815 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaBQDVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 22:21:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WFEln-0002Nq-Fb
	for linux-btrfs@vger.kernel.org; Mon, 17 Feb 2014 04:21:23 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Feb 2014 04:21:23 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Feb 2014 04:21:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck does not fix
Date: Mon, 17 Feb 2014 03:20:58 +0000 (UTC)
Message-ID: <pan$475be$cb0c1165$a3d91acc$c206709@cox.net>
References: <52C7127F.3060902@friedels.name>
	<0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>
	<52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba>
	<52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name>
	<A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>
	<52F73E2B.9080103@friedels.name>
	<837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>
	<82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>
	<53010EF9.60805@friedels.name>
	<21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 16 Feb 2014 12:54:44 -0700 as excerpted:

> On Feb 16, 2014, at 12:18 PM, Hendrik Friedel <hendrik@friedels.name>
> wrote:

[On balance converting to single from raidN:]

>> I think it didn't work.
>> 
>> btrfs balance start  -dconvert=single -mconvert=single -sconvert=single
>> --force /mnt/BTRFS/Video/
>> After >10h:
>> btrfs balance status /mnt/BTRFS/Video/
>> No balance found on '/mnt/BTRFS/Video/'
>> root@homeserver:~# btrfs fi df /mnt/BTRFS/Video/
>> Data, RAID0: total=4.00GB, used=4.00GB
>> Data: total=2.29TB, used=2.29TB
>> System: total=32.00MB, used=256.00KB
>> Metadata: total=4.00GB, used=2.57GB
> 
> It looks like everything is single except for 4GB of data which is still
> raid0. Weird. There should be a bunch of messages in dmesg during a
> normal/successful balance, and either something mentioned or missing
> might provide a clue why some chunks weren't converted.

Agreed.

> Unmounted, what do you get for btrfs check?

Agreed, but it's worth an explanation and explicit warning just in case...

btrfs check is read-only by default -- it'll tell you what it thinks is 
wrong, but won't attempt to correct anything.  Adding --repair tells it 
to try to correct the errors it found, but the recommendation is do NOT 
use --repair unless it's a last-ditch effort after other things failed, 
and preferably only after a btrfs dev says to, because sometimes it can 
make things worse instead of better.

So running the (read-only) /check/ to see what it says is a good idea, 
but do NOT try to run it with --repair just yet, no matter what errors it 
thinks it sees.

>> Do you have an idea what could be wrong?
> 
> No. I'd say it's a bug. 3.14rc3 should be out today, and might be worth
> a shot. Or btrfs-next. If you try again, you only need to convert the
> data profile.

https://btrfs.wiki.kernel.org/index.php/Balance_Filters

Based on that, I'd suggest

btrfs balance start -dconvert=single,soft /mnt/BTRFS/Video/

Given that there's only 4 GiB left to convert, it should go MUCH faster 
than the 10 hours the multiple TiB took.

> Also, 10 hours to balance two disks at 2.3TB seems like a long time. I'm
> not sure if that's expected.

FWIW, I think you may not realize how big 2.3 TiB is, and/or how slow 
spinning rust can be when dealing with TiBs of potentially fragmented 
data...

2.3TiB * 1024GiB/TiB * 1024 MiB/GiB / 10 hours / 60 min/hr / 60 sec/min =

66.99... real close to 67 MiB/sec

Since it's multiple TiB we're talking and only two devices, that's almost 
certainly spinning rust, not SSD, and on spinning rust, 67 MiB/sec really 
isn't /that/ bad, especially if the filesystem wasn't new and had been 
reasonably used, thus likely had some fragmentation to deal with.

But the good news is that the 4 GiB remaining should be much faster; @ 
the 67 MiB/sec average of the above, we're talking about a minute.  
Throwing in that "soft" should tell it to ignore the previously converted 
data, and only balance data chunks that aren't yet in the target single 
profile, so it should only do the 4 GiB that's still raid0, not redo the 
multiple TiB.

Tho it will probably have to check the profile on each chunk still, and 
if that remaining data is hugely fragmented or something that could take 
a bit longer, so it could be two minutes or ten minutes instead of one, 
but if it's more than an hour, I'd definitely be wondering what's up!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

