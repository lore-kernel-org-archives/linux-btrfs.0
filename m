Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:51522 "EHLO
	mail.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbbJDLvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Oct 2015 07:51:18 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by mail.sjomar.eu (Postfix) with ESMTPSA id B808568ABE
	for <linux-btrfs@vger.kernel.org>; Sun,  4 Oct 2015 13:51:13 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID5 doesn't mount on boot, but you can afterwards?
Date: Sun, 04 Oct 2015 13:51:12 +0200
Message-ID: <3915563.6aU1oytTtV@hoefnix>
In-Reply-To: <pan$3b7e2$ac9e4b37$ac602701$c91b77c@cox.net>
References: <1627746.fEEz2JqgZk@hoefnix> <003401d0fe1d$999b41a0$ccd1c4e0$@gmx.de> <pan$3b7e2$ac9e4b37$ac602701$c91b77c@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 04 October 2015 02:28:29 Duncan wrote:
> guido_kuenne posted on Sat, 03 Oct 2015 22:53:46 +0200 as excerpted:
> > Beginner here, so just if it helps: My two-device raid 1 mounts on boot
> > in Fedora 22 (uuid in fstab, no further devices specified) but I mount
> > the fs via uuid while Sjoerd mounted subvolumes. From what I understand
> > (not much) it's either an subvolume issue or Fedora must then somehow
> > perform a device scan before handling fstab.
> 
> I'm guessing fedora has btrfs device scan in its initr*.

I think so too, since I was wondering why it did mount my multidevice JBOD 
correctly before mounting it in the same way as written in the first mail.
Later I found the probable answer that the JBOD setup was with Ubuntu 15.04 
and most likely they also put a btrfs scan somewhere in the init before 
mounting. So there're some approvements btrfs wise when not using the latest 
LTS release..

Sjoerd

