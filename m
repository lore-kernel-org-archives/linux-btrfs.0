Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41747 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdLWFnB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 00:43:01 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eScYI-0002P7-RD
        for linux-btrfs@vger.kernel.org; Sat, 23 Dec 2017 06:40:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unexpected raid1 behaviour
Date: Sat, 23 Dec 2017 05:40:44 +0000 (UTC)
Message-ID: <pan$31b37$7506d7cc$de73ea45$405141c@cox.net>
References: <20171218194351.GA25245@polanet.pl>
        <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
        <20171219144644.GA9855@polanet.pl>
        <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
        <20171219204155.GB14726@polanet.pl>
        <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
        <CAA91j0X_MZ+EjgZMNGrfChBdFed_G3oLttdpYjCOq-vERzoiKw@mail.gmail.com>
        <94b6b4cb-9f1a-c90b-5ffb-fb4d7385526b@gmail.com>
        <20171222160543.GA4199@polanet.pl>
        <CAJCQCtQ=ybjWxPtwBXcRx6-CS=s-FomWHoGpFR+J76q+gdLM+w@mail.gmail.com>
        <20171223025247.GA3427@polanet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Pala posted on Sat, 23 Dec 2017 03:52:47 +0100 as excerpted:

> On Fri, Dec 22, 2017 at 14:04:43 -0700, Chris Murphy wrote:
> 
>> I'm pretty sure degraded boot timeout policy is handled by dracut. The
> 
> Well, last time I've checked dracut on systemd-system couldn't even
> generate systemd-less image.

??

Unless it changed recently (I /chose/ a systemd-based dracut setup here, 
so I'd not be aware if it did), dracut can indeed do systemd-less initr* 
images.  Dracut is modular, and systemd is one of the modules, enabled by 
default on a systemd system, but not required, as I know, because I had 
dracut setup without the systemd module for some time after I switched to 
systemd for my main sysinit, and I verified it didn't install systemd in 
the initr* until I activated the systemd module.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

