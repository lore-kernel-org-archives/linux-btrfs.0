From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs: don't add both copies of DUP to reada extent
 tree
Date: Sat, 25 Feb 2012 22:03:32 +0000 (UTC)
Message-ID: <pan.2012.02.25.22.03.32@cox.net>
References: <1330157387-6803-1-git-send-email-sensille@gmx.net>
	<pan.2012.02.25.08.33.39@cox.net> <4F48DD9E.7030200@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen posted on Sat, 25 Feb 2012 14:09:50 +0100 as excerpted:

> On 02/25/12 09:33, Duncan wrote:
>> Arne Jansen posted on Sat, 25 Feb 2012 09:09:47 +0100 as excerpted:
>>
>>> Normally when there are 2 copies of a block, we add both to the reada
>>> extent tree and prefetch only the one that is easier to reach.
>>> This way we can better utilize multiple devices.
>>> In case of DUP this makes no sense as both copies reside on the same
>>> device.
>>
>> I'm not a coder and thus can't really read the code to know, but
>> wouldn't the same easier-to-reach logic apply there, only to seeking? 
>> One of the DUPs should be easier to reach (less seeking) than the
>> other.
>>
>>
> Well, the commit message is kind of sloppy. The reada code collects as
> many blocks near to each other and reads them sequentially. From time to
> time it moves on to the next filled zone. That's when a longer seek
> happens. It doesn't try to keep these longer seeks as short as possible,
> instead it picks a zone on the disk where it has many blocks to read.
> As both parts of a DUP are filled equally, it doesn't matter which one
> it picks, so it is sufficient to keep track of only one half of the
> mirror. Things change in a multi-disk setup, as the heads can move
> independently.
> 
> (this explanation is kind of sloppy, too)

Thanks.  Makes sense, now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

