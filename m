Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:49924 "EHLO
	mail.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbbIZO6b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 10:58:31 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by mail.sjomar.eu (Postfix) with ESMTPSA id 2087138B48
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 16:58:23 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs@vger.kernel.org
Subject: Re: raw devices or partitions?
Date: Sat, 26 Sep 2015 16:58:22 +0200
Message-ID: <1989142.6nohd6ZIPH@hoefnix>
In-Reply-To: <pan$b1277$da5af759$7c0940dd$1bc738e@cox.net>
References: <2432089.CrOTrZyfAm@hoefnix> <pan$b1277$da5af759$7c0940dd$1bc738e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 26 September 2015 01:43:32 Duncan wrote:
> Sjoerd posted on Fri, 25 Sep 2015 15:40:39 +0200 as excerpted:
> > Is it better to use raw devices for a RAID setup or make one partition
> > on the drive and then create your RAID from there?
> > Right now if have one setup that uses raw, but get messages "unknown
> > partition table" all the time in my logs.
> > I am planning to create a RAID 5 setup (seems to be stable these days?),
> > but wondering  to deal with  raw drives or partitions (4 at the moment).
> > In the wiki they're referring to raw devices in the examples, but that
> > could be outdated?
> 
> Raw device vs. partition (vs mdraid vs dmraid vs lvm) doesn't matter to
> btrfs.  They're all block devices.
> 
> That unknown partition table log entry is from elsewhere in the kernel,
> where it would normally read partition tables if there were any to read.
> It's simply telling you it couldn't find any, to help with diagnostics in
> case there's supposed to be one.  But if you deliberately used a raw
> device, there isn't supposed to be a partition table, so no big deal.
> 
> So just ignore the warning as the diagnostic aid for a case that doesn't
> apply to you, if you like.  Or if you find it irritating enough that
> isn't possible, then do the big partition thing and disappear the
> warning.  No big deal either way. =:^)
>

I went for the raw devices since that's more simple ;)
Weirdly enough on this raid5 setup I don't get those partition messages.
Maybe it has something to do with the complaining machine being external USB 
disks... 

Cheers,
Sjoerd


