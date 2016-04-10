Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36041 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbcDJRZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Apr 2016 13:25:48 -0400
Received: by mail-lf0-f49.google.com with SMTP id g184so129804757lfb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Apr 2016 10:25:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALJXSJpSsxES=SvtscJYCy7J1V37=rhXfWg1DjqU3XpkzJ-M6A@mail.gmail.com>
References: <CALJXSJrdkqau4xWax72xQGBcaONDxWBeDLOn4KD7vP8NKJikDw@mail.gmail.com>
	<CAPmG0jaxZY1d365KGy=HL+e7WNyZ7w6jtT2VJod00KD=JBC=ng@mail.gmail.com>
	<CALJXSJpSsxES=SvtscJYCy7J1V37=rhXfWg1DjqU3XpkzJ-M6A@mail.gmail.com>
Date: Sun, 10 Apr 2016 19:25:46 +0200
Message-ID: <CAPmG0jbYGBuDah_PvhzPVSdotqkGnO43Y3yi2ZYj94r+f9mt5w@mail.gmail.com>
Subject: Re: csum failed on innexistent inode
From: Henk Slager <eye1tm@gmail.com>
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> You might want this patch:
>> http://www.spinics.net/lists/linux-btrfs/msg53552.html
>>
>> As workaround, you can reset the counters on new/healty device with:
>>
>> btrfs device stats [-z] <path>|<device>
>>
>
> I did reset the stats and launched another scrub, and still, since the
> logical blocks are the same on both devices and checksum is different,
> is really seems like my problem was originally created when I booted
> this computer with bad memory (maybe?), could it have been that the
> checksum was saved on disk as bad in the first place and BTRFS doesn't
> want to read it back?

It was not fully clear what the sequence of events were:
- HW problem
- btrfs SW problem
- 1st scrub
- the --repair-sector with hdparm
- 2nd scrub
- 3rd scrub?

There is also DM between the harddisk and btrfs and I am not sure if
whether the hdparm action did repair or further corrupt things.

How do you know for sure that the contents of the 'logical blocks' are
the same on both devices?

If btrfs wants to read a diskblock and its csum doesn't match, then it
is an I/O error, same effect as an uncorrected badsector in the old
days. But in this case your (former/old) disk might still be OK, as
you suggest it might be due to some other error (HW or SW) that
content and csum don't match. It is hard to traceback based on the
info in the email thread. It looks like replace just copied the
problem and it seems a bottleneck now on filesystem level.

> Is it possible to reset the checksum on those? I couldn't find what
> file or metadata the blocks were pointing too.

Could it be that they in the meantime have been removed?
It might be that you again need to run scrub in order to try to find
the problem spot/files.

Fixing individual csum's has been asked before, I don't remember if
there are people who did fix them by own extra scripts/C-code or
whatever. A brute force method is to recalculate and rewrite all
csums:  btrfs check --init-csum-tree , you probably know that. But
maybe you want a rsync -c compare with backups first. Kernel/tools
versions and btrfs fi us output might also give some hints.
