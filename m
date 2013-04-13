Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52245 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3DMQD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Apr 2013 12:03:27 -0400
Received: from merkaba.localnet (ppp-93-104-156-105.dynamic.mnet-online.de [93.104.156.105])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id BBFF5BB
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Apr 2013 18:02:47 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub gives unable to find logical $hugenum len 16384
Date: Sat, 13 Apr 2013 18:03:25 +0200
Message-ID: <1695693.CqHxPPafSI@merkaba>
In-Reply-To: <5157386.Pre7jntDtG@merkaba>
References: <5157386.Pre7jntDtG@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 13 April 2013 17:48:31 you wrote:
> Hi!
> 
> Please answer soon whether it would be a good idea to replay a backup
> right now as I am leaving to Berlin tomorrow for a week without my backup
> drive with me. Well, I made space on an external 2,5 inch drive, that I
> can take with me. I am taking that one with me, after having made sure it
> has a consistent backup. :)
> 
> 
> On investigating
> 
> [Akonadi] [Bug 318290] New: Empty mails:
> AkonadiAgentServer(4890)/libakonadi Akonadi::ResourceBase::itemRetrieved:
> Item does not provide part "HEAD"/"RFC822"
> https://bugs.kde.org/show_bug.cgi?id=318290
> 
> I thought I better prove that my home BTRFS is correct.
> 
> On trying, I got this:

[kernel backtrace]

Well here are the mount options:

martin@merkaba:~> grep home /proc/mounts
/dev/mapper/merkaba-home /mnt/home-zeit btrfs 
rw,noatime,compress=lzo,ssd,space_cache 0 0
/dev/mapper/merkaba-home /home btrfs rw,noatime,compress=lzo,ssd,space_cache 
0 0

The first one with with subvolid=5, so I can create "hidden" snapshots in 
there. The scrub also hangs if this is not mounted.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
