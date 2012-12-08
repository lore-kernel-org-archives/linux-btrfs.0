Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:44148
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066Ab2LHV2O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Dec 2012 16:28:14 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Help with corrupt filesystem: __btrfs_free_extent:5236: IO failure
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20121208161653.GA31750@lintop>
Date: Sat, 8 Dec 2012 14:21:04 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <F0BF473A-0D76-4CCF-9DDC-A7C8EB8DB211@colorremedies.com>
References: <20121208161653.GA31750@lintop>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 8, 2012, at 9:16 AM, Shawn Bohrer <shawn.bohrer@gmail.com> wrote:

>  When the machine came back up the sdc errors had stopped
> but there were numerous 'btrfs checksum failed sdc fixing' type
> messages which seemed to indicate btrfs was successfully rebuilding my
> RAID 1 array as it encountered bad blocks on sdc.

No, if they were bad sectors (persistent read failure) you'd have seen read errors in dmesg, but none such error is in what you posted. I think the bad checksums after reboot implies the data or checksum were corrupted on write, a function of a hardware problem.

sdc and sdd are on the same or different controllers? If it's the same, sounds like bad/loose cable to sdc, or the interface on sdc itself is failing.


>  At this point I
> thought it would be a good idea to help the process along so I started
> a 'btrfs scrub start /' and went off to bed to let it churn through my
> ~3TB of data.

I think you should have been more curious why these errors were happening in the first place, rather than expecting they're benign enough a file system can fix the problem. Why not check the cables? Run smartctl -a on the two drives? 


> So am I screwed?  I suppose since the drives do mount read only I
> should be able to copy all of the salvageable data to some new drives.
> Is this my only option?

Your next step depends on whether you have a backup of the data or not, and it sounds like you're playing with an experimental file system without a backup. If that's true and the data is important I'd block copy each disk independently to new disks, before you do anything else.

Chris Murphy