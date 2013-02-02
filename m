Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3BBR6U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 12:58:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "arnd@linaro.org" <arnd@linaro.org>
Subject: Re: Oops when mounting btrfs partition
Date: Sat, 02 Feb 2013 18:58:14 +0100
Message-ID: <5060362.oVLQKVsh9C@wuerfel>
In-Reply-To: <20130202152035.GA24264@shiny>
References: <4028366.UQxPtEU6If@wuerfel> <20130202152035.GA24264@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 02 February 2013 10:20:35 Chris Mason wrote:
> Hi Arnd,
> 
> First things first, nospace_cache is a safe thing to use.  It is slow
> because it's finding free extents, but it's just a cache and always safe
> to discard.  With your other errors, I'd just mount it readonly
> and then you won't waste time on atime updates.

Ok, I see. Thanks for taking a look so quickly.

> I'll take a look at the BUG you got during log recovery.  We've fixed a
> few of those during the 3.8 rc cycle.

Well, it happened on 3.8-rc4 and on 3.5 here, so I'd guess it's a
different one.

> > Feb  1 22:57:37 localhost kernel: [ 8561.599482] Kernel BUG at ffffffffa01fdcf7 [verbose debug info unavailable]
> 
> > Jan 14 19:18:42 localhost kernel: [1060055.746373] btrfs csum failed ino 15619835 off 454656 csum 2755731641 private 864823192
> > Jan 14 19:18:42 localhost kernel: [1060055.746381] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 17, gen 0
> > ...
> > Jan 21 16:35:40 localhost kernel: [1655047.701147] parent transid verify failed on 17006399488 wanted 54700 found 54764
> 
> These aren't good.  With a few exceptions for really tight races in fsx
> use cases, csum errors are bad data from the disk.  The transid verify
> failed shows we wanted to find a metadata block from generation 54700
> but found 54764 instead:
> 
> 54700 = 0xD5AC
> 54764 = 0xD5EC
> 
> This same bad block comes up a few different times.

The machine has had problems with data consistency in the past, so
I'm not too surprised with getting a single-bit error, although this
is the first time in a year that I've seen problems, and I replaced
the faulty memory modules some time ago.

Anyway, I already ordered a replacement box a few weeks ago, and that
one will have ECC memory besides being a modern Opteron system to replace
the aging Core 2.

> > Jan 21 16:35:40 localhost kernel: [1655047.752692] btrfs read error corrected: ino 1 off 17006399488 (dev /dev/sdb1 sector 64689288)
> 
> This shows we pulled from the second copy of this block and got the
> right answer, and then wrote the right answer to the duplicate.
> Inode 1 means it was metadata.
> 
> But for some reason still aborted the transaction.  It could have been
> an EIO on the correction, but the auto correction code in 3.5 did work
> well.
> 
> I think your plan to pull the data off and reformat is a good one.  I'd
> also look hard at your ram since drives don't usually send back single bit
> errors.

Ok. I'll wait before reformmatting though, in case you need to take
a look at the data later to find out why it crashed without fsck finding
a problem.

	Arnd
