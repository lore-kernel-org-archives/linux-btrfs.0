Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39691 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab3GRHxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 03:53:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Uzj1c-0006kJ-3K
	for linux-btrfs@vger.kernel.org; Thu, 18 Jul 2013 09:53:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 09:53:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 09:53:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What is the current status of defragmentation?
Date: Thu, 18 Jul 2013 07:53:00 +0000 (UTC)
Message-ID: <pan$b4fcd$f147b0cc$851fe847$1ba9dd4f@cox.net>
References: <51E7182F.9020009@statystyka.net> <62476934.S7K7xSYr36@bheem>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shridhar Daithankar posted on Thu, 18 Jul 2013 08:29:22 +0530 as
excerpted:

> [A]fter you fully defrag the system(every btrfs
> mount/partition/filesystem), rebooting immediately with
> compress/autodefrag should do it automatically, since then.

Indeed.

It's worth noting that the automated install system used by many distros 
leaves system files (obviously, no user files at that point) rather 
fragmented.  Since the install process may leave no opportunity to mount 
with autodefrag during the install, it's worth either pre-creating/pre-
mounting the system partitions and skipping the part of the install 
process that would create and mount them, or installing to a temporary 
location and copying the whole install to a final location once you have 
the final destinations created/mounted with autodefrag and optionally 
compress, etc.  That'll save quite some time of the initial defrag 
slowing down the system, as well as allow you to defrag otherwise in-use 
files that aren't "online defragged" otherwise.

> Are you mounting with noatime? storing access time could lead to massive
> direcory level fragmentation which is hard to measure.

The kernel's relatime default helps, but unless you're running something 
like mutt that really depends on atime, it's worth using noatime as a 
rule.  (The only volumes I don't use noatime on are virtual filesystems 
such as tmpfs and sysfs, where it's simply a memory access in any case 
and I've seen no qualified opinion or benchmarks arguing either way.)

> filefrag can help you but its per file and does not exactly give the
> level of fragmentation.

Someone did mention that btrfs compressed files larger than some size 
(the btrfs leaf size?) will always look fragmented to filefrag.  I do not 
personally understand enough about it to verify, however.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

