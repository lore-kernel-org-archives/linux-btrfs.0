Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39326 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbcDBJFG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Apr 2016 05:05:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amHUN-0005KP-SM
	for linux-btrfs@vger.kernel.org; Sat, 02 Apr 2016 11:05:03 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 11:05:03 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 11:05:03 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bad metadata crossing stripe boundary
Date: Sat, 2 Apr 2016 11:03:53 +0200
Message-ID: <20160402110353.10ae123a@jupiter.sol.kaishome.de>
References: <20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
	<56F7E65C.7020300@gmx.com>
	<20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
	<56FC7E6D.8010805@cn.fujitsu.com>
	<56FC8C15.5060002@cn.fujitsu.com>
	<20160331210004.GZ9342@torres.zugschlus.de>
	<20160331231630.7b4ceda9@jupiter.sol.kaishome.de>
	<20160401055725.GA9342@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 1 Apr 2016 07:57:25 +0200
schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:

> On Thu, Mar 31, 2016 at 11:16:30PM +0200, Kai Krakow wrote:
> > Am Thu, 31 Mar 2016 23:00:04 +0200
> > schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:  
> > > I find it somewhere between funny and disturbing that the first
> > > call of btrfs check made my kernel log the following:
> > > Mar 31 22:45:36 fan kernel: [ 6253.178264] EXT4-fs (dm-31):
> > > mounted filesystem with ordered data mode. Opts: (null) Mar 31
> > > 22:45:38 fan kernel: [ 6255.361328] BTRFS: device label fanbtr
> > > devid 1 transid 67526 /dev/dm-31
> > > 
> > > No, the filesystem was not converted, it was directly created as
> > > btrfs, and no, I didn't try mounting it.  
> > 
> > I suggest that your partition contained ext4 before, and you didn't
> > run wipefs before running mkfs.btrfs.  
> 
> I cryptsetup luksFormat'ted the partition before I mkfs.btrfs'ed it.
> That should do a much better job than wipefsing it, shouldnt it?

Not sure how luksFormat works. If it encrypts what is already on the
device, it would also encrypt orphan superblocks.

If it actually wipes the device, the orphan superblock should be gone.

This suggests it does not wipe the device:

https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption:

> Encryption options for LUKS mode
> The cryptsetup action to set up a new dm-crypt device in LUKS
> encryption mode is luksFormat. Unlike the name implies, it does not
> format the device, but sets up the LUKS device header and encrypts
> the master-key with the desired cryptographic options.

Thus, I may very well have an orphan superblock lying around.

-- 
Regards,
Kai

Replies to list-only preferred.

