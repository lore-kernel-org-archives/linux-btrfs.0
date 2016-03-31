Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33560 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbcCaVf1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 17:35:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1alkFQ-0005pV-5B
	for linux-btrfs@vger.kernel.org; Thu, 31 Mar 2016 23:35:24 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 23:35:24 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 23:35:24 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bad metadata crossing stripe boundary
Date: Thu, 31 Mar 2016 23:35:11 +0200
Message-ID: <20160331233511.6105beba@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
	<56F7E65C.7020300@gmx.com>
	<20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
	<56FC7E6D.8010805@cn.fujitsu.com>
	<56FC8C15.5060002@cn.fujitsu.com>
	<20160331210004.GZ9342@torres.zugschlus.de>
	<20160331231630.7b4ceda9@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 31 Mar 2016 23:16:30 +0200
schrieb Kai Krakow <hurikhan77@gmail.com>:

> Am Thu, 31 Mar 2016 23:00:04 +0200
> schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:
> 
> > On Thu, Mar 31, 2016 at 10:31:49AM +0800, Qu Wenruo wrote:  
> > > Would you please try the following patch based on v4.5
> > > btrfs-progs? https://patchwork.kernel.org/patch/8706891/    
> > 
> > This also fixes the "bad metadata crossing stripe boundary" on my
> > pet patient.
> > 
> > I find it somewhere between funny and disturbing that the first call
> > of btrfs check made my kernel log the following:
> > Mar 31 22:45:36 fan kernel: [ 6253.178264] EXT4-fs (dm-31): mounted
> > filesystem with ordered data mode. Opts: (null) Mar 31 22:45:38 fan
> > kernel: [ 6255.361328] BTRFS: device label fanbtr devid 1 transid
> > 67526 /dev/dm-31
> > 
> > No, the filesystem was not converted, it was directly created as
> > btrfs, and no, I didn't try mounting it.  
> 
> I suggest that your partition contained ext4 before, and you didn't
> run wipefs before running mkfs.btrfs. Now, the ext4 superblock is
> still detected because no btrfs structure or block did overwrite it.
> I had a similar problem when I first tried btrfs.
> 
> I think there is some magic dd-fu to damage the ext4 superblock
> without hurting the btrfs itself. But I leave this to the fs devs,
> they could properly tell you.

Tho, you could also try to force detecting btrfs before ext4 by
modifying /etc/filesystems.

-- 
Regards,
Kai

Replies to list-only preferred.

