Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34323 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbaCIROs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Mar 2014 13:14:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WMhJH-0007hz-73
	for linux-btrfs@vger.kernel.org; Sun, 09 Mar 2014 18:14:47 +0100
Received: from 78-32-127-104.static.enta.net ([78.32.127.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 18:14:47 +0100
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 18:14:47 +0100
To: linux-btrfs@vger.kernel.org
From: boris <alex@bpmit.com>
Subject: Re: Massive BTRFS performance degradation
Date: Sun, 9 Mar 2014 17:14:23 +0000 (UTC)
Message-ID: <loom.20140309T180428-101@post.gmane.org>
References: <531C1CC4.701@gmail.com> <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk> <9889995.2gi4G0FAds@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh <swami <at> petaramesh.org> writes:


> Actually deduplication WAS the reason why I recently made the move to BTRFS 
> again, for deduplication in ZFS is working, but *SO* memory hungry and 
> performance killer unless you have *lots* of RAM...
> 

If you think about what dedup is has to do it's going to be fairly memory
hungry; hopefully there are a few maths (yes, it's maths not math! Think of
the game dominoe :-D ) bods on the team.

<starts to get excited about how one would tackle it then decides he needs
to get out more>

