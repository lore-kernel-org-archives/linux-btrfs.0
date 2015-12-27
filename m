Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47161 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbbL0HXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 02:23:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aD5fU-00037x-D9
	for linux-btrfs@vger.kernel.org; Sun, 27 Dec 2015 08:23:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 08:23:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 08:23:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG?] btrfs scrub -d doesn't scan all devices
Date: Sun, 27 Dec 2015 07:22:59 +0000 (UTC)
Message-ID: <pan$bcf44$1632328c$31564c06$c04774a8@cox.net>
References: <1451187536.6446.14.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sun, 27 Dec 2015 04:38:56 +0100 as
excerpted:

> I've just noted the following behaviour:
> 
> # btrfs scrub start -Bdr /
> scrub device /dev/sda2 (id 1) done
> 	scrub started at Sun Dec 27 01:59:05 2015
>	and finished after 00:04:04
> 	total bytes scrubbed: 29.39GiB with 0 errors
> scrub device /dev/sdb2 (id 2) done
> 	scrub started at Sun Dec 27 01:59:05 2015
>	and finished after 00:04:08
> 	total bytes scrubbed: 29.39GiB with 0 errors
> 
> => that works as expected
> 
> However:
> # btrfs scrub start -Bdr /dev/disk/by-label/system
> scrub device /dev/sdb2 (id 2) done
> 	scrub started at Sun Dec 27 01:53:18 2015
>	and finished after 00:04:01
> 	total bytes scrubbed: 29.37GiB with 0 errors

> => seems to scan only sdb2 (which is where /dev/disk/by-label/system
> points to) at least, no output is given for sda2


I'd call that NOTABUG.  As the btrfs-scrub manpage suggests:

* When you point scrub at a mountpoint, it scrubs all devices composing 
that filesystem.

(The manpage specifically says "all devices of the filesystem identified 
by <path>".  Emphasis on _ALL_DEVICES_ if given a normal path.)

* When you point scrub at a specific device, it scrubs that specific 
device.

(The manpage continues ... "or on a single <device>." Emphasis on 
_SINGLE_DEVICE_ if given a device node.)


Since /dev/disk/by-*/* are symlinks to various block-device nodes, it 
follows that if you point scrub at them, only the device pointed at is 
scrubbed, exactly as one might expect based on the manpage.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

