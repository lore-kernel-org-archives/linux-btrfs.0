Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45433 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab3DSJPf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 05:15:35 -0400
Received: from merkaba.localnet (p5795400E.dip0.t-ipconnect.de [87.149.64.14])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id F119287
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 11:14:45 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub gives unable to find logical $hugenum len 16384
Date: Fri, 19 Apr 2013 11:15:30 +0200
References: <5157386.Pre7jntDtG@merkaba> <1622455.ObqXlP9ZKX@merkaba> (sfid-20130416_234614_211210_59459FC5)
In-Reply-To: <1622455.ObqXlP9ZKX@merkaba>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201304191115.30452.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 16. April 2013 schrieb Martin Steigerwald:
> On Saturday 13 April 2013 17:48:31 Martin Steigerwald wrote:
> > Hi!
> > 
> > Please answer soon whether it would be a good idea to replay a backup
> > right now as I am leaving to Berlin tomorrow for a week without my
> > backup drive with me. Well, I made space on an external 2,5 inch
> > drive, that I can take with me. I am taking that one with me, after
> > having made sure it has a consistent backup. :)
> 
> Ping.
> 
> Any hints on this one? I am going to recreate the filesystem next weekend
> at latest.
> 
> I did not see any I/O or BTRFS errors in logs so far, so filesystem
> appears to be good.

Last chance to let me dig out some more information about this.

Even with lack of any other oddities I am not going to tolerate a non 
scrubbing BTRFS filesystem for longer than a week and will redo it during the 
weekend.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
