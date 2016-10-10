Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37304 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbcJJMIF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 08:08:05 -0400
Received: by mail-it0-f54.google.com with SMTP id z65so68216015itc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 05:08:05 -0700 (PDT)
Subject: Re: raid levels and NAS drives
To: Charles Zeitler <cfzeitler@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAB9fVVH6S-Y0Li=6xyw2P23CEPwVRA6hRbjJNi+_3etHnqMh1w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c7e8a508-1e55-4049-1e9e-63942f80d030@gmail.com>
Date: Mon, 10 Oct 2016 08:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAB9fVVH6S-Y0Li=6xyw2P23CEPwVRA6hRbjJNi+_3etHnqMh1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-09 19:12, Charles Zeitler wrote:
> Is there any advantage to using NAS drives
> under RAID levels,  as oppposed to regular
> 'desktop' drives for BTRFS?
Before I answer the question, it is worth explaining the differences 
between the marketing terms 'desktop', 'enterprise', 'NAS', and 'video' 
as they relate to hard drives.

The big distinguishing factors that make a hard drive a 'desktop' drive 
are that it will retry reading a bad sector for an insanely long time 
(multiple minutes on most drives), it usually won't run at more than 
7200 RPM, and it may have better energy efficiency and be designed to 
handle more load/unload cycles for the heads (that is, it's designed for 
regular desktop/laptop usage patterns).

An 'enterprise' drive by contrast has support for setting the read 
timeout and write timeout on bad sectors (variously called TLER, SCT 
ERC, and numerous other things), typically runs at higher speeds (10k or 
15k RPM), and is usually designed for continuous 24/7 operation.

A 'NAS' drive is somewhere between a 'desktop' and an 'enterprise' 
drive, they have TLER/ERC, but usually don't run at more than 7200 RPM, 
and are usually designed with energy efficiency in mind.

A 'video' or 'security' drive is a special case that's only marketed by 
WD as far as I know, they're designed for low error rate, 24/7 
operation, and very high performance streaming writes and reads.

So, as for what you should use in a RAID array, here's my specific advice:
1. Don't worry about enterprise drives unless you've already got a 
system that has them.  They're insanely overpriced for relatively 
minimal benefit when compared to NAS drives.
2. If you can afford NAS drives, use them, they'll get you the best 
combination of energy efficiency, performance, and error recovery.
3. If you can't get NAS drives, most desktop drives work fine, but you 
will want to bump up the scsi_command_timer attribute in the kernel for 
them (200 seconds is reasonable, just make sure you have good cables and 
a good storage controller).
4. Avoid WD Green drives, without special effort, they will get worse 
performance and have shorter lifetimes than any other hard disk I've 
ever seen.
5. Generally avoid drives with a capacity over 1TB from manufacturers 
other than WD, HGST, and Seagate, most of them are not particularly good 
quality (especially if it's an odd non-power-of-two size like 5TB).
