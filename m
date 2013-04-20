Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48742 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965681Ab3DTDtn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 23:49:43 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4B03C7C041B
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 21:49:41 -0600 (MDT)
Date: Fri, 19 Apr 2013 23:49:38 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs scrub gives unable to find logical $hugenum len 16384
Message-ID: <20130420034938.GA2631@localhost.localdomain>
References: <5157386.Pre7jntDtG@merkaba>
 <1622455.ObqXlP9ZKX@merkaba>
 <201304191115.30452.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201304191115.30452.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 19, 2013 at 03:15:30AM -0600, Martin Steigerwald wrote:
> Am Dienstag, 16. April 2013 schrieb Martin Steigerwald:
> > On Saturday 13 April 2013 17:48:31 Martin Steigerwald wrote:
> > > Hi!
> > > 
> > > Please answer soon whether it would be a good idea to replay a backup
> > > right now as I am leaving to Berlin tomorrow for a week without my
> > > backup drive with me. Well, I made space on an external 2,5 inch
> > > drive, that I can take with me. I am taking that one with me, after
> > > having made sure it has a consistent backup. :)
> > 
> > Ping.
> > 
> > Any hints on this one? I am going to recreate the filesystem next weekend
> > at latest.
> > 
> > I did not see any I/O or BTRFS errors in logs so far, so filesystem
> > appears to be good.
> 
> Last chance to let me dig out some more information about this.
> 
> Even with lack of any other oddities I am not going to tolerate a non 
> scrubbing BTRFS filesystem for longer than a week and will redo it during the 
> weekend.
>

Can you get a btrfs-image of the file system as it is and upload it somewhere
for me to pull down so I can try and reproduce?  Thanks,

Josef 
