Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:49268 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3BOFtx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 00:49:53 -0500
Date: Fri, 15 Feb 2013 06:49:51 +0100
From: Sander <sander@humilis.net>
To: Fredrik Tolf <fredrik@dolda2000.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
Message-ID: <20130215054951.GA5071@panda>
Reply-To: sander@humilis.net
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com>
 <201302141544.05747.Martin@lichtvoll.de>
 <alpine.DEB.2.02.1302150435450.8810@shack.dolda2000.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1302150435450.8810@shack.dolda2000.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fredrik Tolf wrote (ao):
> How do I remove the conception of the missing device so that I can
> replace it? Should I simply add the replacement first, and only
> after that remove the missing device?
> 
> If the latter, how can I "scratch" the previous btrfs metadata from
> this "replacement" drive so that it doesn't try to autoreinsert it
> into the filesystem when it is detected? I assume it won't be enough
> be just zeroing the first few sectors of the drive, right?

You could use wipefs.

	Sander
