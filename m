Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42833 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3BOJFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 04:05:35 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
Date: Fri, 15 Feb 2013 10:05:28 +0100
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <201302141544.05747.Martin@lichtvoll.de> <alpine.DEB.2.02.1302150435450.8810@shack.dolda2000.com> (sfid-20130215_095505_610309_779D53E5)
In-Reply-To: <alpine.DEB.2.02.1302150435450.8810@shack.dolda2000.com>
Cc: Fredrik Tolf <fredrik@dolda2000.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302151005.29014.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 15. Februar 2013 schrieb Fredrik Tolf:
> On Thu, 14 Feb 2013, Martin Steigerwald wrote:
[…]
> > I´d restart the machine, see that BTRFS is using both devices again and
> > then try the balance again.
> 
> I mentioned it in another mail, but I'd very much prefer not to do that.
> I'd like to try and solve this as I normally should when a drive fails.

Well if Hugo´s solution with unmounting the FS, btrfs dev scan does not 
work, I see this my suggestion to reboot as making sense.

I do not have to add more to my analysis.

If any BTRFS developer or expert knows another solution in during runtime of 
the system, feel free :)

So or so I think a kernel bug is involved here. And I think I remember 
having seen something like this during a balance attempt myself already, but 
it was just a test BTRFS and I was not sure of it.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
