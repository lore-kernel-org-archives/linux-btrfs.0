Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51469 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933530AbaFSRhm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 13:37:42 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49408 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WxgHO-003sNv-3w
	for linux-btrfs@vger.kernel.org; Thu, 19 Jun 2014 11:37:42 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: frustrations with handling of crash reports
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53A2A5DB.40204@gmail.com>
Date: Thu, 19 Jun 2014 11:37:41 -0600
Message-Id: <6720DA04-9DDC-4612-8AC6-71B29B43E2EE@colorremedies.com>
References: <20140519134915.GA27432@merlins.org>	<539FE03F.5030306@jp.fujitsu.com> <20140617145957.GH19071@merlins.org>	<20140617182745.GO19071@merlins.org> <53A192B8.2040601@gmail.com> <pan$d2b51$8d2a30e2$29b90599$a8fc24d9@cox.net> <53A2A5DB.40204@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 19, 2014, at 2:56 AM, Konstantinos Skarlatos <k.skarlatos@gmail.com> wrote:
> 
> My filesystem that consistently kernel panics when a specific logical address is read, passes scrub without anything bad reported. What's the use of scrub if it cant deal with this?

The myriad repair tools: automatic at mount, recovery mount option, scrub, check/repair, btrfs-zero-log, chunk-recover, super-recover certainly make Btrfs significantly more challenging to troubleshoot for the user familiar with other file systems. I think this is just a maturity issue, and as the necessary logic of repairing a file system reveals itself I think we'll see consolidation and more automation of these repair methods.

fs/btrfs/scrub.c comments say what it does now and future enhancements. 

" … reads all
 * extent and super block and verifies the checksums. In case a bad checksum
 * is found or the extent cannot be read, good data will be written back if
 * any can be found."

Scrub is pretty much just about checksum verification. It doesn't check file system consistency. So the file system could be inconsistent and a scrub still comes up clean.

> Well my use case is about 25 filesystems on rotating disks, 20 of them on single disks, and the rest are multiple disk filesystems, either raid1 or single. I have many subvolumes and in some cases thousands of snapshots, but no databases, systemd and the like on them.

That's a lot of subvolumes and snapshots. I don't know this is expected to work really well right now (?), yes hundreds but with thousands there have been some known problems in the recent past at least.


> Of course I have everything backed up, </nag mode on> but I believe that after all those years of development I shouldnt still be forced to do mkfs every 6 monts or so, when i use no new features. </nag mode off>

The problem is that an old file system implies many kernels doing different kinds of reads and writes over time, making a given file system rather non-deterministic compared to any other. So the possible problems aren't all known and therefore the way to fix them may not be known yet either.


Chris Murphy