Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54950 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbaCXTRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 15:17:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSAN7-0003I3-SG
	for linux-btrfs@vger.kernel.org; Mon, 24 Mar 2014 20:17:21 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 20:17:21 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 20:17:21 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Btrfs and raid5 status with kernel 3.14, documentation, and howto
Date: Mon, 24 Mar 2014 19:17:12 +0000
Message-ID: <lgq0b9$e5r$1@ger.gmane.org>
References: <20140323225657.GA17039@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20140323225657.GA17039@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23/03/14 22:56, Marc MERLIN wrote:
> Ok, thanks to the help I got from you, and my own experiments, I've
> written this:
> http://marc.merlins.org/perso/btrfs/post_2014-03-23_Btrfs-Raid5-Status.html
> 
> If someone reminds me how to edit the btrfs wiki, I'm happy to copy that
> there, or give anyone permission to take part of all of what I wrote 
> and use it for any purpose.
> 
> 
> 
> The highlights are if you're coming from the mdadm raid5 world:
[---]
> 
> Hope this helps,
> Marc

Thanks for the very good summary.

So... In very brief summary, btrfs raid5 is very much a work in progress.


Question: Is the raid5 going to be seamlessly part of the
error-correcting raids whereby raid5, raid6,
raid-with-n-redundant-drives are all coded as one configurable raid?

Also (second question): What happened to the raid naming scheme that
better described the btrfs-style of raid by explicitly numbering the
number of devices used for mirroring, striping, and error-correction?


Thanks,
Martin


