Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:56813 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab3EJHBn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 03:01:43 -0400
Message-ID: <518C9B55.3050008@jan-o-sch.net>
Date: Fri, 10 May 2013 09:01:41 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <2sci5a-n8p.ln1@hurikhan.ath.cx> <5187700F.20807@jan-o-sch.net> <3egl5a-al5.ln1@hurikhan.ath.cx> <51889A4D.8000201@jan-o-sch.net> <ch7o5a-g0b.ln1@hurikhan.ath.cx> <7jio5a-b5g.ln1@hurikhan.ath.cx> <518A318A.7060105@jan-o-sch.net> <15ot5a-f1m.ln1@hurikhan.ath.cx>
In-Reply-To: <15ot5a-f1m.ln1@hurikhan.ath.cx>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 10, 2013 at 01:30 (+0200), Kai Krakow wrote:
> Jan Schmidt <list.btrfs@jan-o-sch.net> schrieb:
> 
>>> Apparently, it's not fixed. The system does not freeze now but it threw
>>> multiple backtraces right in front of my Xorg session. The backtraces
>>> look a little bit different now. Here's what I got:
>>>
>>> https://gist.github.com/kakra/8a340f006d01e146865d
>>>
>>> Occurence while running "bedup dedup --defrag --size-cutoff
>>> $((1024*1024))" which was currently dedup'ing my backup volume with daily
>>> snapshots filled by "rsync --inplace" - so I suppose some file contents
>>> are pretty scattered.
>>
>> At least that looks different for now. I'm not certain about all the fixes
>> in btrfs-next. Can you give it a try and bisect if btrfs-next is good?
>> That would be really helpful.
> 
> I'd prefer to not bisect my production system kernel... That will probably 
> take ages as running the "reproducable test" takes about 30-60 minutes 
> before the problem hits my system. At least unless you had a suggestion how 
> to speed up the process... ;-)

I see, hoped it would be something quicker.

> I saw the pull request with those fixes, so I supsect it didn't go into 
> 3.9.1 but rather will go into 3.9.2?

Probably. However, those patches obviously weren't enough to solve your problem.
We don't submit a lot of things to stable, so they are likely to remain the only
btrfs related changes in there, which would mean it is unlikely to help with
your problem.

We can try to debug that further, you can send me / upload the output of

   btrfs-image -c9 /dev/whatever blah.img

built from Josef's repository

   git://github.com/josefbacik/btrfs-progs.git

It contains all your metadata (like file names), data is omitted from the dump.

> I probably wait and just do not run the dedup process until I have 3.9.2 
> installed. The backup works with occassional hiccups, the system very very 
> sometimes freezes but I almost always see the backtraces in dmesg after 
> backup. Let's see if it's all gone in 3.9.2.

It's always an alternative to hope for the best :-)

-Jan
