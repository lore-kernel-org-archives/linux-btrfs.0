Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BC8C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 01:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D470E208E3
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 01:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfABB4L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Jan 2019 20:56:11 -0500
Received: from [195.159.176.226] ([195.159.176.226]:51731 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727203AbfABB4L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jan 2019 20:56:11 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1geVjF-0002yA-GK
        for linux-btrfs@vger.kernel.org; Wed, 02 Jan 2019 02:53:53 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Checksum errors
Date:   Wed, 2 Jan 2019 01:53:47 +0000 (UTC)
Message-ID: <pan$89bf8$80d70458$84a5e41c$9564f4a0@cox.net>
References: <1546127794.2573034.1620895648.01F06240@webmail.messagingengine.com>
        <67b0235e-d79d-e0ff-fba6-310ad637ff98@gmx.com>
        <1546207041.3838954.1621431160.664E52D0@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; e65ba1502)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Josh Holland posted on Sun, 30 Dec 2018 21:57:21 +0000 as excerpted:

> $ sudo smartctl -a /dev/sda
> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.12-arch1-1-ARCH] (local build)
> Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

I'll leave the btrfs technical stuff to Qu, who's a dev and can actually help
with it.

But as a reasonably technical btrfs user and admin of my own systems,
I have some experience with an ssd going bad because with btrfs in raid1 mode
with a /good/ ssd as the other one in the pair and available backups, I was able
to actually let an ssd get much worse before replacing than I otherwise would
have, just to see how it went.

And I've some experience with reading smartctl status output as well...

[snippage to interesting...]

> === START OF INFORMATION SECTION ===
> Model Family:     Samsung based SSDs
> Device Model:     SAMSUNG MZHPV256HDGL-000L1
> User Capacity:    256,060,514,304 bytes [256 GB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    Solid State Device

Confirming ssd.  256 GB is likely a bit older, as confirmed below...

> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED

That's good...

> General SMART Values:
> Offline data collection status:  (0x00)	Offline data collection activity
> 					was never started.
> 					Auto Offline Data Collection: Disabled.
> Self-test execution status:      ( 121)	The previous self-test completed having
> 					the read element of the test failed.

Not so good...

> SCT capabilities: 	       (0x003d)	SCT Status supported.
> 					SCT Error Recovery Control supported.
> 					SCT Feature Control supported.
> 					SCT Data Table supported.

SCT error recovery control is a good thing.  I'm not an expert on it, but
it does mean that you can set the drive timeout to something reasonable,
a few seconds, well under IIRC 30 second default timeout on Linux' SATA
bus reset timers, thus letting Linux and btrfs get the error and deal
with it properly.  (Most consumer-level devices don't have that, and have a
timeout of 2-3 minutes, not only ridiculously long, but longer than the
Linux SATA bus default timeout time, causing Linux to give up and reset
the bus without finding out the real problem.  Setting a longer reset time
there is possible, but 2-3 minutes per error becomes unworkable pretty
quickly when the errors start to stack up.)
 
> SMART Attributes Data Structure revision number: 1
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   5 Reallocated_Sector_Ct   0x0033   067   067   010    Pre-fail  Always       -       435
>   9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       5858
>  12 Power_Cycle_Count       0x0032   098   098   000    Old_age   Always       -       1791
> 170 Unused_Rsvd_Blk_Ct_Chip 0x0032   050   050   010    Old_age   Always       -       435
> 171 Program_Fail_Count_Chip 0x0032   053   053   010    Old_age   Always       -       406
> 172 Erase_Fail_Count_Chip   0x0032   100   100   010    Old_age   Always       -       0
> 173 Wear_Leveling_Count     0x0033   080   080   005    Pre-fail  Always       -       609
> 174 Unexpect_Power_Loss_Ct  0x0032   099   099   000    Old_age   Always       -       37
> 178 Used_Rsvd_Blk_Cnt_Chip  0x0013   050   050   010    Pre-fail  Always       -       435
> 180 Unused_Rsvd_Blk_Cnt_Tot 0x0013   050   050   010    Pre-fail  Always       -       431
> 184 End-to-End_Error        0x0033   100   100   097    Pre-fail  Always       -       0
> 187 Uncorrectable_Error_Cnt 0x0032   099   099   000    Old_age   Always       -       43
> 194 Temperature_Celsius     0x0032   069   035   000    Old_age   Always       -       31
> 199 CRC_Error_Count         0x003e   100   100   000    Old_age   Always       -       0
> 233 Media_Wearout_Indicator 0x0032   099   099   000    Old_age   Always       -       156032
> 241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       14764
> 242 Total_LBAs_Read         0x0032   099   099   000    Old_age   Always       -       36217


This is actually the part that looks scary, particularly #5, 170, 171, 174 and 178,
all indicating that you're half way thru your reserved blocks!

Now your raw values are far lower than mine were, ~435 each used and remaining,
suggesting ~870 total, while I had literally 100,000+ (calculated from raw used
value against the percentage value for cooked, I didn't have all the different
ways of reporting it on mine that you have), so it took me quite awhile to work
thru them even tho I was chewing them up rather regularly, toward the end, sometimes
several hundred at a time.

But while the "cooked" values are standardized to 253 (254/255 are reserved) or
sometimes 100 (percentage) maximum, the raw values differ between manufacturers.
I'm pretty sure mine (Corsair Neutron brand) were the number of 512-byte sectors so
a couple K per MB and I had tens of MB of reserve, thus explaining the 5 digit raw
used numbers while still saying 80+ percent good cooked, but yours may be counting
in 2 MiB erase-blocks or some such, thus the far lower raw numbers.  Or perhaps
Samsung simply recognized that such huge numbers of reserve wasn't particularly
practical, people replaced the drive before it got /that/ bad, and put those would-be
reserves to higher usable capacity instead.


Regardless, while the ssd may continue to be usable as
cache for some time, I'd strongly suggest rotating it out of normal use for anything
you value, or at LEAST increasing your number of backups and/or pairing it with
something else in btrfs raid1, as I already had mine when I noticed it going bad, so
I could continue to use it and watch it degrade, over time.

I'd definitely *NOT* recommend trusting that ssd in single or raid0 mode, for anything
of value that's not backed up, period.  Whatever those raw events are measuring, 50%
on the cooked value is waaayyy too low to continue to trust it, tho as a cache device
or similar, where a block going out occasionally isn't a big deal, it may continue to
be useful for years.


FWIW, with my tens of thousands of reserve blocks and the device in btrfs raid1 with
a known good device, I was able to use routine btrfs scrubs to clean up the damage
for quite some time, IIRC 8 months or so, until it just got so bad I was doing scrubs
and finding and correcting sometimes hundreds of errors on every reboot, and as I
actually had a third ssd I had planned to put in something else and never did get it
there, I finally decided I had had enough, and after one final scrub, I did a btrfs
replace of the old device with the new one.  But AFAIK it had only gotten down to 85
cooked value or so, even then.  And there's no way I'd have considered the ssd usable
at anything under say 92 cooked, as blocks were simply erroring out too often, had
I not had btrfs raid1 mode and been able to scrub away the errors.

Meanwhile, FWIW the other devices, both the good one of the original pair, and the
replacement for the bad one, same make and model as the bad one, are still going today.
One of them has a 5/reallocated-sector-count raw value of 17, still 100% on the cooked
value, the other says 0-raw/253 cooked.  (For many values including this one,
a cooked value of 253 means entirely clean, with a single "event" it drops to 100%, and
it goes from there based on calculated percentage.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

