Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54664 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbaFLMhd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 08:37:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wv4G2-00037a-H9
	for linux-btrfs@vger.kernel.org; Thu, 12 Jun 2014 14:37:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 14:37:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 14:37:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: R: Re: Slow startup of systemd-journal on BTRFS
Date: Thu, 12 Jun 2014 12:37:13 +0000 (UTC)
Message-ID: <pan$22693$6b452195$976b783a$e4956372@cox.net>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli <kreijack@libero.it> posted on Thu, 12 Jun 2014
13:13:26 +0200 as excerpted:

>>systemd has a very stupid journal write pattern. It checks if there is
>>space in the file for the write, and if not it fallocates the small
>>amount of space it needs (it does *4 byte* fallocate calls!) and then
>>does the write to it.  All this does is fragment the crap out of the log
>>files because the filesystems cannot optimise the allocation patterns.
> 
> I checked the code, and to me it seems that the fallocate() are done in
> FILE_SIZE_INCREASE unit (actually 8MB).

FWIW, either 4 byte or 8 MiB fallocate calls would be bad, I think 
actually pretty much equally bad without NOCOW set on the file.

Why?  Because btrfs data blocks are 4 KiB.  With COW, the effect for 
either 4 byte or 8 MiB file allocations is going to end up being the 
same, forcing (repeated until full) rewrite of each 4 KiB block into its 
own extent.

Turning off the fallocate should allow btrfs to at least consolidate a 
bit, tho to the extent that multiple 4 KiB blocks cannot be written, 
repeated fsync will still cause issues.

80-100 MiB logs (size mentioned in another reply) should be reasonably 
well handled by btrfs autodefrag, however, if it's turned on.  I'd be 
worried if sizes were > 256 MiB and certainly as sizes approached a GiB, 
but it should handle 80-100 MiB just fine.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

