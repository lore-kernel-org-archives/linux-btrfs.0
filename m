Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33603 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaAJRER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 12:04:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W1fVI-00072y-0e
	for linux-btrfs@vger.kernel.org; Fri, 10 Jan 2014 18:04:16 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 18:04:16 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 18:04:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How does btrfs handle bad blocks in raid1?
Date: Fri, 10 Jan 2014 17:03:52 +0000 (UTC)
Message-ID: <pan$e7d15$902dd302$8a10224f$9d8c4bb8@cox.net>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
	<20140109104247.GH15634@carfax.org.uk>
	<pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>
	<28EF9764-B846-4AB4-AA88-9A37F106B6C6@colorremedies.com>
	<52CEE901.1090207@gmail.com>
	<DD76DCF3-93B9-4EAF-9732-C703D7C50A74@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 09 Jan 2014 11:52:08 -0700 as excerpted:

> Understood. I'm considering a 2nd drive dying during rebuild (from a 1st
> drive dying) as essentially simultaneous failures. And in the case of
> raid10, the likelihood of a 2nd drive failure being the lonesome drive
> in a mirrored set is statistically very unlikely. The next drive to fail
> is going to be some other drive in the array, which still has a mirror.

While still statistically unlikely, the likelihood of that critical 
second device[1] in a mirror-pair on a raid10 dying isn't /as/ unlikely 
as you might think -- it's actually more likely than that of any one of 
the still mirrored devices failing, for example.

The reason is that as soon as one of the devices in a mirror-pair fails, 
the other one is suddenly doing double the work it was previously, and 
twice the work any other still-paired devices in the array are doing!  
And as any human who has tried to pull an 80-hour-work-week can attest, 
double the work is *NOT* simply double the stress!

If both devices in the pair are from the same manufacturing run and were 
installed at the same time and run under exactly the same conditions, as 
quite likely unless deliberately guarded against, chances are rather 
higher than you'd like that by the time one fails, suddenly piling twice 
the workload on the OTHER one isn't going to end well, especially under 
the increased workload of a recovery after a replacement device has been 
added.

That's the well known but all too infrequently considered trap of both 
raid5 and 2-way-mirrored raid1, thus the reason many admins are so 
reluctant to trust them and prefer N-way-mirroring/parity, with N bumped 
upward as necessary to suit the level of device-failure paranoia.

For me, that cost/benefit/paranoia balance tends toward N=3 for 
mirroring, N=2 for parity (since parity parallels mirror redundancy 
count, not mirror total count). =:^)

---
[1] I'm trying to train myself to use "device" in most cases where I 
formerly used "drive", since "device" is generally technically correct 
even if it's a logical/virtual device such as an mdraid device or even 
simply a partition on a physical device, while "drive" may well be 
technically incorrect, since both virtual devices such as mdraid and 
partitions, and physical devices such as SSDs, are arguably not "drives" 
at all.  But it's definitely a process I'm still in the middle of.  It's 
not a formed habit yet and if I'm not thinking about that when I chose my 
term...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

