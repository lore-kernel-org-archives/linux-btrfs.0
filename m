Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50262 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbeHWIQR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 04:16:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fshVg-0003wB-VC
        for linux-btrfs@vger.kernel.org; Thu, 23 Aug 2018 06:46:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: lazytime mount =?CP1251?Q?option=97no?= support in Btrfs
Date: Thu, 23 Aug 2018 04:46:10 +0000 (UTC)
Message-ID: <pan$5bac3$e653290f$955bc939$6fc721ed@cox.net>
References: <ompef3$sim$1@blaine.gmane.org>
        <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
        <2641568.fxl50hTsRH@merkaba>
        <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
        <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com>
        <20180821120636.fatftem5qbhv22m4@angband.pl>
        <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
        <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
        <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
        <20180821160547.GF24025@twin.jikos.cz>
        <49b2ad81-256a-981e-cf6c-04e3bf32e932@gmail.com>
        <pan$4b9b5$2e5ff999$1d9fa649$483aa66c@cox.net>
        <3a460831-0924-7615-0977-b32ab82cbece@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 22 Aug 2018 07:30:09 -0400 as
excerpted:

>> Meanwhile, since broken rootflags requiring an initr* came up let me
>> take the opportunity to ask once again, does btrfs-raid1 root still
>> require an initr*?  It'd be /so/ nice to be able to supply the
>> appropriate rootflags=device=...,device=... and actually have it work
>> so I didn't need the initr* any longer!

> Last I knew, specifying appropriate `device=` options in rootflags works
> correctly without an initrd.

Just to confirm, that's with multi-device btrfs rootfs?  Because it used 
to work when the btrfs was single-device, but not multi-device.

(For multi-device, or at least raid1, one had to add degraded, also, or 
it would refuse to mount despite all the appropriate device= entries in 
rootflags, thus of course risking all the problems running degraded raid1 
operationally can bring, tho I never figured out for sure whether btrfs 
was smart enough to eventually pick up the other devices, after the scan 
before bringing other btrfs online or not, but either way it was a risk I 
wasn't willing to take.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
