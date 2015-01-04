Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37325 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbbADDXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Jan 2015 22:23:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y7bmU-0005m0-NI
	for linux-btrfs@vger.kernel.org; Sun, 04 Jan 2015 04:23:06 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 04:23:06 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 04:23:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: I need to P. are we almost there yet?
Date: Sun, 4 Jan 2015 03:22:53 +0000 (UTC)
Message-ID: <pan$1d2cd$b8c74fee$d1b247b8$e5de75c@cox.net>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<54A7D3D1.10508@shiftmail.org>
	<pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
	<CAAe=sHXzrAoFr9wPUk49F5kV6knpWM7PtdxfNWBRXvpU0b+PgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sys.syphus posted on Sat, 03 Jan 2015 12:55:27 -0600 as excerpted:

>> But btrfs raid56 mode should be complete with kernel 3.19 and
>> presumably btrfs-progs 3.19 tho I'd give it a kernel or two to mature
>> to be sure. N-way-mirroring (my particular hotly awaited feature) is
>> next up, but given the time raid56 took, I don't think anybody's
>> predicting when it'll be actually in-tree and ready for use.
>>
>>
> is that the feature where you say i want x copies of this file and y
> copies of this other file? e.g. raid at the file level, with the ability
> to adjust redundancy by file?

Per-file isn't available yet, tho at least per-subvolume is roadmapped, 
and now that we have the properties framework working via xattr for files 
as well, at least in theory, there is AFAIK no reason to limit it to per-
subvolume, as per-file should be about as easy once the code that 
currently limits it to per-filesystem is rewritten.

But actually fully working per-filesystem raid56 is enough for a lot of 
people, and actually working per-filesystem N-way-mirroring is what I'm 
after, since I already setup multiple filesystems in ordered to keep my 
data eggs from all being in the same filesystem basket.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

