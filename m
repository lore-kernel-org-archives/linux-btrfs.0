Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35784 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966AbaFQS1r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 14:27:47 -0400
Date: Tue, 17 Jun 2014 11:27:45 -0700
From: Marc MERLIN <marc@merlins.org>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: frustrations with handling of crash reports
Message-ID: <20140617182745.GO19071@merlins.org>
References: <20140519134915.GA27432@merlins.org> <539FE03F.5030306@jp.fujitsu.com> <20140617145957.GH19071@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140617145957.GH19071@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 17, 2014 at 07:59:57AM -0700, Marc MERLIN wrote:
> It is also ok to answer "Any FS created or used before kernel 3.x can be
> corrupted due to bugs we fixed in 3.y, thank you for your report but it's
> not a good use of our time to investigate this"
> (although newer kernels should not just crash with BUG(xxx) on unexpected
> data, they should remount the FS read only).

I was thinking about this some more, and I know I have no right to tell
others what to do, so take this as a mere suggestion :)

How about doing a release with cleanups and stabilization and better state
reporting when things go wrong?

This would give a good known version for users who have actual data and
backups that can take many hours or days to restore (never mind downtime).

A few things I was thinking about:
1) Wouldn't it be a good time to replace all the BUG ON statements with
appropriate error handling? Unexpected data can happen, the kernel shouldn't
crash that.
At the very least it should remount read only and give maybe a wiki link to
the user on what to do next (some bu reporting and recovery page)

2) On unexpected cases, output basic information on the filesystem or printk
instructions to the user on how to gather data that would be sent to the
list to be reviewed.
This would include information on how old the filesystem is when it's
possible to detect, and the instruction page could say "sorry, anything
older than X, we don't want to hear about, we already fixed corruption bugs
since then"

3) getting printk data on an end user machine when it just started refusing
to write to disk can be challenging and cause useful debug info to be lost.
Things I thinking about:
a) make sure most btrfs bugs do not just hang the kernel
b) recommend to users to send kernel syslog messages to an ext4 partition

How does that sound?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
