Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55880 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdDRDX3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 23:23:29 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d0Jje-0002dh-0Y
        for linux-btrfs@vger.kernel.org; Tue, 18 Apr 2017 05:23:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs/SSD
Date: Tue, 18 Apr 2017 03:23:13 +0000 (UTC)
Message-ID: <pan$3c7$b69cfe37$aed8e56e$e9f7b41d@cox.net>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
        <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
        <20170417232419.04474015@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Mon, 17 Apr 2017 23:24:19 +0500 as excerpted:

> Days are long gone since the end user had to ever think about device
> lifetimes with SSDs. Refer to endurance studies such as
> http://techreport.com/review/27909/the-ssd-endurance-experiment-theyre-
all-dead
> http://ssdendurancetest.com/
> https://3dnews.ru/938764/
> It has been demonstrated that all SSDs on the market tend to overshoot
> even their rated TBW by several times, as a result it will take any user
> literally dozens of years to wear out the flash no matter which
> filesystem or what settings used

Without reading the links...

Are you /sure/ it's /all/ ssds currently on the market?  Or are you 
thinking narrowly, those actually sold as ssds?

Because all I've read (and I admit I may not actually be current, but...) 
on for instance sd cards, certainly ssds by definition, says they're 
still very write-cycle sensitive -- very simple FTL with little FTL wear-
leveling.

And AFAIK, USB thumb drives tend to be in the middle, moderately complex 
FTL with some, somewhat simplistic, wear-leveling.

While the stuff actually marketed as SSDs, generally SATA or direct PCIE/
NVME connected, may indeed match your argument, no real end-user concern 
necessary any more as the FTLs are advanced enough that user or 
filesystem level write-cycle concerns simply aren't necessary these days.


So does that claim that write-cycle concerns simply don't apply to modern 
ssds, also apply to common thumb drives and sd cards?  Because these are 
certainly ssds both technically and by btrfs standards.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

