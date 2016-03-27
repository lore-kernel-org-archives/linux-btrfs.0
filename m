Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51611 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbcC0QyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 12:54:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1akDwz-0000N6-CC
	for linux-btrfs@vger.kernel.org; Sun, 27 Mar 2016 18:54:05 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 18:54:05 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 18:54:05 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
Date: Sun, 27 Mar 2016 18:53:25 +0200
Message-ID: <20160327185325.5a7a38ef@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<12481278.TvmLfnWAX4@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 27 Mar 2016 14:18:26 +0200
schrieb Martin Steigerwald <martin@lichtvoll.de>:

> On Dienstag, 22. März 2016 09:03:42 CEST Kai Krakow wrote:
> > Hello!
> > 
> > Since one of the last kernel updates (I don't know which exactly),
> > I'm experiencing csum errors within VDI files when running
> > VirtualBox. A side effect of this is, as soon as dmesg shows these
> > errors, commands like "du" and "df" hang until reboot.
> > 
> > I've now restored the file from backup but it happens over and over
> > again.  
> 
> Just as another data point I am irregularily using a VM with
> Virtualbox in a VDI file on a BTRFS RAID 1 on two SSDs and had no
> such issues so far up to kernel 4.5.

Meanwhile I think this is a side effect of some other corruption in the
filesystem.

-- 
Regards,
Kai

Replies to list-only preferred.


