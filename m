Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51614 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbcEMHqp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 03:46:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b17o1-00054I-S2
	for linux-btrfs@vger.kernel.org; Fri, 13 May 2016 09:46:42 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 09:46:41 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 09:46:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Input/output error on newly created file
Date: Fri, 13 May 2016 07:46:31 +0000 (UTC)
Message-ID: <pan$b1cd$3f36224$2014cb30$68062598@cox.net>
References: <8760uoqjlt.fsf@vostro.rath.org>
	<878tzilhf3.fsf@vostro.rath.org> <87eg971dqf.fsf@thinkpad.rath.org>
	<58549996.M9MX6vESn9@archlinux> <8760uj18d6.fsf@thinkpad.rath.org>
	<ade418fb-d741-54d0-c9c2-1018889edc72@dblaci.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Szalma László posted on Thu, 12 May 2016 20:28:24 +0200 as excerpted:

> The files that rarely become unreadable (I/O error but no error in dmesg
> or anywhere) are mysql MyIsam database files, and they are always small.
> Like 16kbyte for example, or smaller. Sometimes dropping the fs cache
> fixes the problem, sometimes not. Umount / mount always fixes the
> problem. Scrub says the filesystem is OK (when the file is unreadable).

Is it possible the files are always under 4 KiB?

While there's a few variables as to max size, with 4 KiB being the 
practical max, btrfs will inline really small files into their metadata 
node instead of writing them out as 4 KiB data block extents.  Since 
that's obviously a different code-path, if it's only 4 KiB and smaller 
files, it's possible there's a race in that code-path that when lost, 
results in the file "disappearing" without a dmesg trace, only to 
reappear after reboot.

Actually, now that I think about it, if the files are all OVER say 2 KiB 
but still quite small, say under 16 KiB, and if they had just recently 
grown, it's possible that the race is in the transition from the inline 
metadata state to the multiples of 4 KiB block data extent state.

And if all the files had just shrunk, say from compaction (if done in-
place, not with a copy and rename), perhaps it's the reverse, the 
transition from written data blocks to inline metadata state.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

