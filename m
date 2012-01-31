From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: newbie problems (difficulty with mkfs.btrfs and learning how to
 navigate trees
Date: Tue, 31 Jan 2012 06:12:21 +0000 (UTC)
Message-ID: <pan.2012.01.31.06.12.20@cox.net>
References: <CAHb3AmJiv3Leq1QUO3JNQ3tuZ06jFQXWv=Jba65AW9qbk-T4Qw@mail.gmail.com>
	<pan.2012.01.30.05.56.40@cox.net>
	<CAHb3AmJWh-0W-f5AjZxstu8xtd+evA2VFidJPu+XecA4_O-t-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Rohit Mehta posted on Mon, 30 Jan 2012 11:38:51 -0500 as excerpted:

> Thanks, it does seem to work on larger filesystems.  I'll work with 500
> MB virtual disks.

FWIW I'd suggest 512 MiB, just because btrfs seems to like powers of two 
as opposed to powers of 10.  That might be what you meant anyway, but 
it's not what you posted.  =:^/

Talking about which, if you want to try 500 vs 512 vs 520 (or 512 plus 
whatever the system usage size turns out to be for such a volume, I 
assumed 8 MiB here), I'd be quite interested in comparative results.  It 
may be that getting it exactly right means a far more efficient layout, 
less space waste and faster access, or that it really doesn't matter that 
much.  I don't know, which is why the results of such a test would be so 
interesting. =:^)

Of course on real disks as opposed to virtual, speed would depend on the 
disk alignment (512 byte vs 4KiB physical sectors and alignment to it, 
for spinning media, larger erase chunks, up to 1 or 4 MiB, likely on ssd), 
etc, but physical disk layout shouldn't directly affect btrfs' chunk-size 
and space utilization efficiency.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

