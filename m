Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42647 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S933582AbdEOTMX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 15:12:23 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dALPc-000343-Cv
        for linux-btrfs@vger.kernel.org; Mon, 15 May 2017 21:12:08 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs/SSD
Date: Mon, 15 May 2017 21:12:06 +0200
Message-ID: <20170515211206.29c5c132@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
        <20170512203644.26e068e5@jupiter.sol.kaishome.de>
        <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
        <FA7013B1-621B-405F-B65C-236A4A33F022@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 15 May 2017 14:09:20 +0100
schrieb Tomasz Kusmierz <tom.kusmierz@gmail.com>:

> > Traditional hard drives usually do this too these days (they've
> > been under-provisioned since before SSD's existed), which is part
> > of why older disks tend to be noisier and slower (the reserved
> > space is usually at the far inside or outside of the platter, so
> > using sectors from there to replace stuff leads to long seeks).  
> 
> Not true. When HDD uses 10% (10% is just for easy example) of space
> as spare than aligment on disk is (US - used sector, SS - spare
> sector, BS - bad sector)
> 
> US US US US US US US US US SS
> US US US US US US US US US SS
> US US US US US US US US US SS
> US US US US US US US US US SS
> US US US US US US US US US SS
> US US US US US US US US US SS
> US US US US US US US US US SS
> 
> if failure occurs - drive actually shifts sectors up:
> 
> US US US US US US US US US SS
> US US US BS BS BS US US US US
> US US US US US US US US US US
> US US US US US US US US US US
> US US US US US US US US US SS
> US US US BS US US US US US US
> US US US US US US US US US SS
> US US US US US US US US US SS

This makes sense... Reserve area somehow implies it is continuous and
as such located at one far end of the platter. But your image totally
makes sense.


> that strategy is in place to actually mitigate the problem that
> you’ve described, actually it was in place since drives were using
> PATA :) so if your drive get’s nosier over time it’s either a broken
> bearing or demagnetised arm magnet causing it to not aim propperly -
> so drive have to readjust position multiple times before hitting a
> right track -- To unsubscribe from this list: send the line
> "unsubscribe linux-btrfs" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

I can confirm that such drives usually do not get noisier except there's
something broken other than just a few sectors. And faulty bearing in
notebook drives is the most often scenario I see. I always recommend to
replace such drives early because they will usually fail completely.
Such notebooks are good candidates for SSD replacements btw. ;-)

The demagnetised arm magnet is an interesting error scenario - didn't
think of it. Thanks for the pointer.

But still, there's one noise you can easily identify as bad sectors:
When the drive starts clicking for 30 or more seconds while trying to
read data, and usually also freezes the OS during that time. Such
drives can be "repaired" by rewriting the offending sectors (because it
will be moved to reserve area then). But I guess it's best to already
replace such a drive by that time.

Early, back in PATA times, I often had harddisks exposing seemingly bad
sectors when power was cut while the drive was writing data. I usually
used dd to rewrite such sectors and the drive was good as new again -
except I lost some file data maybe. Luckily, modern drives don't show
such behavior. And also SSDs learned to handle this...


-- 
Regards,
Kai

Replies to list-only preferred.


