Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51476 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbbL1BWB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:22:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDMVb-00046q-Di
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 02:21:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 02:21:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 02:21:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
Date: Mon, 28 Dec 2015 01:21:54 +0000 (UTC)
Message-ID: <pan$ec56c$f5c0c35d$65d6e7dd$4eded2b8@cox.net>
References: <567FEEB6.3080701@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Waxhead posted on Sun, 27 Dec 2015 14:59:18 +0100 as excerpted:

> I have a "toy-array" of 6x USB drives hooked up to a hub where I made a
> btrfs raid 6 data+metadata filesystem.

Just noting as an aside comment to the main thread...

While doing this with a "toy-array" for experimental purposes is fine and 
indeed encouraged, do your research and LOTS of testing before trying to 
setup particularly multi-device btrfs over USB for normal use.  There 
have been a number of trouble reports posted for USB connected devices, 
where the trouble simply vanished when the devices were attached via 
(e)SATA.  Apparently various SATA/USB bridge controllers aren't entirely 
reliable, a few USB root hubs likewise (tho the bridge-controllers are 
the most common culprit), and USB itself wasn't really designed for this 
sort of thing, tho obviously many people use it for attaching storage 
today.

Personally, while I might use btrfs on single-device USB attached 
storage, I'd be extremely hesitant to do multi-device btrfs via USB, and 
would definitely test it (VERY!) well before considering it usable if I 
did, as there's just too many ways multiple USB-attached devices can get 
out of sync with each other, breaking the filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

