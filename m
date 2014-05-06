Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41945 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaEFUcc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 16:32:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Whlvl-0000c4-QB
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 22:25:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 22:25:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 22:25:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How does "btrfs fi show" show full?
Date: Tue, 6 May 2014 20:10:00 +0000 (UTC)
Message-ID: <pan$1f225$3bfd5829$2b5ac65b$4bb85dc6@cox.net>
References: <20140505005412.GS9061@merlins.org>
	<53670F70.1010509@swiftspirit.co.za> <20140505055029.GM10159@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 04 May 2014 22:50:29 -0700 as excerpted:

> In the second FS:
>> >Label: btrfs_pool1  uuid: [...]
>> >	Total devices 1 FS bytes used 442.17GiB
>> >	devid    1 size 865.01GiB used 751.04GiB path [...]
> 
> The difference is huge between 'Total used' and 'devid used'.
> 
> Is btrfs going to fix this on its own, or likely not and I'm stuck doing
> a full balance (without filters since I'm balancing data and not
> metadata)?
> 
> If that helps.
> legolas:~# btrfs fi df /mnt/btrfs_pool1
> Data, single: total=734.01GiB, used=435.29GiB
> System, DUP: total=8.00MiB, used=96.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=8.50GiB, used=6.74GiB
> Metadata, single: total=8.00MiB, used=0.00

Definitely helps.  The spread is in data.

Try

btrfs balance start -dusage=20 /mnt/btrfs_pool1

You still have plenty of unused (if allocated) space available, so you 
can play around with the usage= a bit.  -dusage=20 will be faster than 
something like -dusage=50 or -dusage=80, likely MUCH faster, but will 
return less chunks to unallocated, as well.  Still, your spread between 
data-total and data-used is high enough, I expect -dusage=20 will give 
you pretty good results.

Since show says you still have ~100 GiB unallocated in df, there's no 
real urgency, and again I'd try -dusage=20 the first time.  If that 
doesn't cut it you can of course try bumping the usage= as needed, but 
because you still have 100 GiB unallocated and because the data used vs. 
total spread is so big, I really do think -dusage=20 will do it for you.
As your actual device usage goes up the spread between used and size will 
go down, meaning more frequent balances to keep some reasonable 
unallocated space available, and you'll either need to actually delete 
some stuff or to bump up those usage= numbers as well, but usage=20 is 
very likely to be sufficient at this point.

I hadn't seen anyone try an actual formula as Brendan suggests in his 
post, and I'm not actually sure that formula will apply well in all use-
cases as I think fragmentation and fill-pattern will have a lot to do 
with it, but based on his post it does apply for his use-case, and the 
same general principle if not the specific formula should apply 
everywhere and is what I'm doing above, only simply eyeballing it, not 
using a specific formula.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

