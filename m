Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17326 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968297Ab3DSLvd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 07:51:33 -0400
Date: Fri, 19 Apr 2013 19:51:46 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub gives unable to find logical $hugenum len 16384
Message-ID: <20130419115145.GB4949@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <5157386.Pre7jntDtG@merkaba>
 <1622455.ObqXlP9ZKX@merkaba>
 <201304191115.30452.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201304191115.30452.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 19, 2013 at 11:15:30AM +0200, Martin Steigerwald wrote:
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

Hi Martin,

I think the bug is hidden back in the backtrace, any chance to get a
btrfs-debug-tree output?

thanks,
liubo

> 
> Thanks,
> -- 
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
