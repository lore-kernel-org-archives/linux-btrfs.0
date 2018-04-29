Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35983 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbeD2Iab (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 04:30:31 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fChgt-0005YP-1N
        for linux-btrfs@vger.kernel.org; Sun, 29 Apr 2018 10:28:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: NVMe SSD + compression - benchmarking
Date: Sun, 29 Apr 2018 08:28:09 +0000 (UTC)
Message-ID: <pan$4c272$fabeda98$48538e85$39262988@cox.net>
References: <5be6d7f3-c905-dc7b-56e0-4c4be60ea952@swiftspirit.co.za>
        <e80e34ff-3d1c-99da-e622-4576c2dc8329@gmx.com>
        <6adcb5da-16af-5453-383b-f289e9857506@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Sat, 28 Apr 2018 09:30:30 +0200 as excerpted:

> My real worry is that I'm currently reading at 2.79GB/s (see result
> above and below) without compression when my hardware *should* limit it
> to 2.0GB/s. This tells me either `sync` is not working or my benchmark
> method is flawed.

No answer but a couple additional questions/suggestions:

* Tarfile:  Just to be sure, you're using an uncompressed tarfile, not a 
(compressed tarfile) tgz/tbz2/etc, correct?

* How does hdparm -t and -T compare?  That's read-only and bypasses the 
filesystem, so it should at least give you something to compare the 2.79 
GB/s to, both from-raw-device (-t) and cached/memory-only (-T).  See the 
hdparm (8) manpage for the details.

* And of course try the compressed tarball too, since it should be easy 
enough and should give you compressable vs. uncompressable numbers for 
sanity checking.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

