Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44895 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3DTI0w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 04:26:52 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Josef Bacik <jbacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>
Subject: Re: btrfs scrub gives unable to find logical $hugenum len 16384
Date: Sat, 20 Apr 2013 10:26:49 +0200
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <5157386.Pre7jntDtG@merkaba> <201304191115.30452.Martin@lichtvoll.de> <20130420034938.GA2631@localhost.localdomain> (sfid-20130420_102140_219259_4FA13707)
In-Reply-To: <20130420034938.GA2631@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201304201026.50181.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 20. April 2013 schrieb Josef Bacik:
> On Fri, Apr 19, 2013 at 03:15:30AM -0600, Martin Steigerwald wrote:
> > Am Dienstag, 16. April 2013 schrieb Martin Steigerwald:
> > > On Saturday 13 April 2013 17:48:31 Martin Steigerwald wrote:
> > > > Hi!
> > > > 
> > > > Please answer soon whether it would be a good idea to replay a
> > > > backup right now as I am leaving to Berlin tomorrow for a week
> > > > without my backup drive with me. Well, I made space on an external
> > > > 2,5 inch drive, that I can take with me. I am taking that one with
> > > > me, after having made sure it has a consistent backup. :)
> > > 
> > > Ping.
> > > 
> > > Any hints on this one? I am going to recreate the filesystem next
> > > weekend at latest.
> > > 
> > > I did not see any I/O or BTRFS errors in logs so far, so filesystem
> > > appears to be good.
> > 
> > Last chance to let me dig out some more information about this.
> > 
> > Even with lack of any other oddities I am not going to tolerate a non
> > scrubbing BTRFS filesystem for longer than a week and will redo it
> > during the weekend.
> 
> Can you get a btrfs-image of the file system as it is and upload it
> somewhere for me to pull down so I can try and reproduce?  Thanks,

Yeah, can do. As I do not see any option in btrfs-image to make the image 
anonymous, I will just mail you and Liu directly and ask you to delete the 
image after analysis.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
