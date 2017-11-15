Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37577 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1759210AbdKOUYC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 15:24:02 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eF4Dv-0004aY-65
        for linux-btrfs@vger.kernel.org; Wed, 15 Nov 2017 21:23:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Read before you deploy btrfs + zstd
Date: Wed, 15 Nov 2017 20:23:44 +0000 (UTC)
Message-ID: <pan$9fe69$3a062179$aad19d2f$63c49115@cox.net>
References: <20171113225046.GD28899@suse.cz> <3013353.6rxLtS64S0@merkaba>
        <d0442de1-b53a-3b16-8932-54c783dd8afe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 14 Nov 2017 07:38:03 -0500 as
excerpted:

> On 2017-11-14 02:34, Martin Steigerwald wrote:
>> Hello David.
>> 
>> David Sterba - 13.11.17, 23:50:
>>> while 4.14 is still fresh, let me address some concerns I've seen on
>>> linux forums already.
>>>
>>> The newly added ZSTD support is a feature that has broader impact than
>>> just the runtime compression. The btrfs-progs understand filesystem
>>> with ZSTD since 4.13. The remaining key part is the bootloader.
>>>
>>> Up to now, there are no bootloaders supporting ZSTD. This could lead
>>> to an unmountable filesystem if the critical files under /boot get
>>> accidentally or intentionally compressed by ZSTD.
>> 
>> But otherwise ZSTD is safe to use? Are you aware of any other issues?
> Aside from the obvious issue that recovery media like SystemRescueCD and
> the GParted LIveCD haven't caught up yet, and thus won't be able to do
> anything with the filesystem, my testing has not uncovered any issues,
> though it is by no means rigorous.

Tho from my understanding and last I read, btrfs restore (I believe it 
was) hadn't been updated to handle zstd yet, tho btrfs check and btrfs 
filesystem defrag had been, and of course btrfs balance if the kernel 
handles it since all balance does is call the kernel to do it.

So just confirming, does btrfs restore handle zstd from -progs 4.13?  

Because once a filesystem goes unmountable, restore is what I've had best 
luck with, so if it doesn't understand zstd, no zstd for me.  
(Regardless, being the slightly cautious type I'll very likely wait a 
couple kernel cycles before switching from lzo to zstd here, just to see 
if any weird reports about it from the first-out testers hit the list in 
the mean time.)

Meanwhile, it shouldn't need said but just in case, if you're using it, 
be sure you have backups /not/ using zstd, for at least a couple kernel 
cycles. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

