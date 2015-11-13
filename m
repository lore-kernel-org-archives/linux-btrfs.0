Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36939 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbbKMHGE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 02:06:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zx8Qp-0004uc-7s
	for linux-btrfs@vger.kernel.org; Fri, 13 Nov 2015 08:05:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 08:05:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 08:05:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
Date: Fri, 13 Nov 2015 07:05:51 +0000 (UTC)
Message-ID: <pan$40936$8da53a7a$3a479f22$1086065d@cox.net>
References: <1447365063.7045.7.camel@scientia.net>
	<5645474D.8000804@cn.fujitsu.com> <1447381613.7045.21.camel@scientia.net>
	<56455073.1060406@cn.fujitsu.com> <1447387049.7045.39.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Fri, 13 Nov 2015 04:57:29 +0100 as
excerpted:

> As I've said I have these two 8TiB disks... one which is basically the
> master with loads of precious data, the other being a backup from the
> master, regularly created with incremental btrfs send/receive.

8 TiB disks -- are those the disk-managed SMR "archive" disks I've read 
about on a number of threads?

If so, that hardware is almost certainly the cause, as they're known to 
be problematic on current kernels.  While most filesystems (all?) will 
apparently go corrupt on them, it can remain invisible corruption for 
quite some time on many of them, but btrfs with its checksums and etc 
will tend to show up the problems far sooner, and there have been at 
least 2-3 threads on the problem already, on this list.

As I don't have any of those disks here I've been following the threads 
from a bit of a distance and haven't kept up with the full details, but I 
do know there's an active bugzilla.kernel.org bug open on the problem, 
and that the problem was first exposed by a commit that was supposed to 
help /support/ this sort of drive.  Rolling it back does seem to help.

I don't recall what kernel that commit landed in, but it was definitely 
after 3.16, so if that's what you were originally running, the problem 
wouldn't have shown up right away, until you upgraded to a kernel with 
the offending commit.

For more than that, you'll either need to wait until someone following a 
bit closer (possibly affected by the problem) posts a better followup, or 
find the other threads in the list archive, that discuss the issue.  You 
shouldn't have to go back more than a couple weeks or so, and it's very 
likely in the last week, so almost certainly in this month's posts, if 
you're checking a list archive on the web.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

