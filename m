Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:40159 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeELMGL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 May 2018 08:06:11 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: replace drive with write_io_errs?
To: Adam Bahe <adambahe@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACzgC9g=gYnEEd_o2RqUpz4Yh1+YrAcfCCmcnqc8SmmzF878AQ@mail.gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <7922e0e4-28e4-3bb6-c38a-b9cd8b7a0a9e@dirtcellar.net>
Date: Sat, 12 May 2018 14:06:07 +0200
MIME-Version: 1.0
In-Reply-To: <CACzgC9g=gYnEEd_o2RqUpz4Yh1+YrAcfCCmcnqc8SmmzF878AQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Bahe wrote:
> Hello all,
> 
'All' includes me as well, but keep in mind I am not a BTRFS dev.

> I have a drive that has been in my btrfs array for about 6 months now.
> It was purchased new. Its an IBM-ESXS SAS drive rebranded from an HGST
> HUH721010AL4200. Here is the following stats, it passed a long
> smartctl test. But I'm not sure what to make of it.
> 
> [/dev/sdi].write_io_errs    1823
> [/dev/sdi].read_io_errs     0
> [/dev/sdi].flush_io_errs    0
> [/dev/sdi].corruption_errs  0
> [/dev/sdi].generation_errs  0
> 
Just a few observations.

You are more likely to get (faster) help from the friendly devs here if 
you provide the output of...

btrfs --version
uname -a
btrfs filesystem show

Have you gone through the "regular" stuff?! E.g. things like bad cables, 
rerouting cables, checking your power supply (noise, correct voltages), 
temperature (your drive is not *that* far off the trip temperature, if 
it is 52 C I imagine it could easily hit 65 C with a bit of load), 
trying to eliminate other hardware, sound cards, graphics cards etc...
If you run your array on a USB enclosure weird things may/will/(has to) 
happen.

> === START OF INFORMATION SECTION ===
> Vendor:               IBM-ESXS
> Product:              HUH721010AL4200
> Revision:             J6R2
> User Capacity:        9,931,038,130,176 bytes [9.93 TB]
> Logical block size:   4096 bytes
> Formatted with type 2 protection
> Logical block provisioning type unreported, LBPME=0, LBPRZ=0
> Rotation Rate:        7200 rpm
> Form Factor:          3.5 inches
> Logical Unit id:      0x5000cca266a405e4
> Serial number:        *YOINK*
> Device type:          disk
> Transport protocol:   SAS
> Local Time is:        Sat May 12 03:06:35 2018 CDT
> SMART support is:     Available - device has SMART capability.
> SMART support is:     Enabled
> Temperature Warning:  Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART Health Status: OK
> 
> Current Drive Temperature:     52 C
> Drive Trip Temperature:        65 C
> 
> Manufactured in week 33 of year 2017
> Specified cycle count over device lifetime:  50000
> Accumulated start-stop cycles:  28
> Specified load-unload count over device lifetime:  600000
> Accumulated load-unload cycles:  170
> Elements in grown defect list: 0
> 
> Vendor (Seagate) cache information
>    Blocks sent to initiator = 1848304782540800
> 
> Error counter log:
>             Errors Corrected by           Total   Correction
> Gigabytes    Total
>                 ECC          rereads/    errors   algorithm
> processed    uncorrected
>             fast | delayed   rewrites  corrected  invocations   [10^9
> bytes]  errors
> read:          0        0         0         0    1096283
> 14317.360           0
> write:         0        0         0         0       2906
> 27801.489           0
> verify:        0        0         0         0      13027
> 0.000           0
> 
> Non-medium error count:        0
> 
> SMART Self-test log
> Num  Test              Status                 segment  LifeTime
> LBA_first_err [SK ASC ASQ]
>       Description                              number   (hours)
> # 1  Background long   Completed                   -    2466
>        - [-   -    -]
> # 2  Background short  Completed                   -    2448
>        - [-   -    -]
> Long (extended) Self Test duration: 65535 seconds [1092.2 minutes]
> 
I have not seen the 'correction algorithm invocations' before, but I 
expect that such a large drive probably do some of this as part of 
regular use. If the number is significantly higher than your other 
drives (if they have the same load) I would suspect something is fishy 
with your drive. But then again , it's better to ask someone else.
> 
> I can't RMA the drive as I have no idea how or where to RMA an IBM
> branded HGST drive. So if on the off chance someone here is reading
> this who can also point me in the right direction, let me know where
> to RMA and IBM standalone drive with no FRU.
Uhm... can't you just return the drive where you purchased it?

> 
> But is this drive healthy or should I have it replaced? What is the
> extent of a write_io_err? Are they somewhat common or a sign of a bad
> drive? A scrub returned no errors.
> 
The manual is a bit hard to understand
https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-device

It does not say clearly what happens if you have a redundant storage 
profile for your (meta)data. Would a write be redirected to another 
copy? if yes would it retry the original write. I *assume* that as long 
as you don't get any write errors in your application it works. But 
perhaps someone else care to explain this better (by preferably updating 
the manual/wiki)

> Also what about the correction algorithm invocations? All of my IBM
> drives seem to have those. Whereas all of my other drives do not. I
> was curious about that too, if anyone knows. Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
