Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36233 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdHDKJn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 06:09:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ddZXz-0006m7-FR
        for linux-btrfs@vger.kernel.org; Fri, 04 Aug 2017 12:09:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: SQLite Re: csum errors on top of dm-crypt
Date: Fri, 4 Aug 2017 10:09:25 +0000 (UTC)
Message-ID: <pan$265d8$96ed0c2d$31e293b6$784e0a9e@cox.net>
References: <20170804121858.1c860065@natsu> <20170804124444.6d102183@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Fri, 04 Aug 2017 12:44:44 +0500 as excerpted:

> On Fri, 4 Aug 2017 12:18:58 +0500 Roman Mamedov <rm@romanrm.net> wrote:
> 
>> What I find weird is why the expected csum is the same on all of these.
>> Any idea what this might point to as the cause?
>> 
>> What is 0x98f94189, is it not a csum of a block of zeroes by any
>> chance?
> 
> It does seem to be something of that sort, as it appears in
> https://www.spinics.net/lists/linux-btrfs/msg67281.html (though as
> factual csum, not the expected one).
> 
>> a few files turned out to be unreadable
> 
> Actually, turns out ALL of those are sqlite files(!)
> 
> .mozilla/firefox/.../places.sqlite <- 4 instances (for 4 users)
> .moonchild productions/pale moon/.../urlclassifier3.sqlite
> .config/chromium/Default/Application Cache/Cache/data_3 <- twice (for 2
> users)
> .config/chromium/Default/History .config/chromium/Default/Top Sites
> 
> nothing else affected.
> 
> Forgot to mention that the kernel version is 4.9.40.

Not very scientific but FWIW...

Kernel 4.9 or perhaps a couple kernel cycles earlier is about the time I 
had some similar issues with my firefox database files, too.  I lost 
extensions and their settings and had to bisect to the file level and 
restore the files from backup.

The problem in my case was very likely an ungraceful shutdown.  But I've 
had a couple such shutdowns recently (I stay current and am now on 4.13-
rc3) as well, due to summer storm season and a power supply going out, 
that have had much better results -- clean scrubs after remount and 
nothing lost that I can see, even after the one that blinked back out 
right as I was rebooting.

So it may be something fixed in newer kernels or just happenstance, but I 
won't argue with more reliable recent kernel btrfs, even if it /is/ "just 
me". =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

