Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:24908 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab3BRPaB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 10:30:01 -0500
Message-ID: <512248F6.2000108@giantdisaster.de>
Date: Mon, 18 Feb 2013 16:29:58 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Fredrik Tolf <fredrik@dolda2000.com>
CC: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <201302141544.05747.Martin@lichtvoll.de> <alpine.DEB.2.02.1302150435450.8810@shack.dolda2000.com> (sfid-20130215_095505_610309_779D53E5) <201302151005.29014.Martin@lichtvoll.de> <alpine.DEB.2.02.1302152250280.8810@shack.dolda2000.com>
In-Reply-To: <alpine.DEB.2.02.1302152250280.8810@shack.dolda2000.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 15 Feb 2013 22:56:19 +0100 (CET), Fredrik Tolf wrote:
> The oops cut can be found here:
> <http://www.dolda2000.com/~fredrik/tmp/btrfs-oops>

This scrub issue is fixed since Linux 3.8-rc1 with commit
4ded4f6 Btrfs: fix BUG() in scrub when first superblock reading gives EIO

