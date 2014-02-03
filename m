Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51440 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751886AbaBCRab convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 12:30:31 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Receive on same subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52E9721D.6000908@matthewlai.ca>
Date: Mon, 3 Feb 2014 10:30:28 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4D0416BE-42D6-4458-9519-9836CC979005@colorremedies.com>
References: <52E9721D.6000908@matthewlai.ca>
To: Matthew Lai <m@matthewlai.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 29, 2014, at 2:26 PM, Matthew Lai <m@matthewlai.ca> wrote:

> Hello,
> 
> Is this supposed to work? (/data is the root volume, /data/a is a subvolume)
> 
> btrfs subvolume snapshot /data/a /data/b
> # make some changes in b
> btrfs send -p /data/a /data/b > delta
> btrfs receive /data/a < delta
> 
> I'm getting "ERROR: could not find parent subvolume" on receive.

> What I'm trying to do is to back up using send/receive, but I don't have 50% free space, and (please correct me if I'm wrong) since receive doesn't do deduplication, I want to use snapshot to do the initial bootstrapping, instead of send/receive without a parent.

I think you've oversimplified your commands, because it looks like you're using send/receive on the same file system. But if it's a backup, necessarily you'd have to be sending the subvolume(s) to another file system on another disk (either on the same system or remotely). So that needs some clarification.

Also, btrfs send requires subvolumes to be read only. Are they?

And btrfs incremental receive expects the identical parent already on the destination. Is it?

Also, while I'm not certain it matters, man page says to use -f to specify files. I haven't tested < and >. But then also the step where you create this intermediate snapshot file isn't necessary, just combine the send receive commands through pipe.


https://btrfs.wiki.kernel.org/index.php/Incremental_Backup


Chris Murphy

