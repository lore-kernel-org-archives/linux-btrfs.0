Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58111 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbcCVUfe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 16:35:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aiT1X-00038I-I5
	for linux-btrfs@vger.kernel.org; Tue, 22 Mar 2016 21:35:31 +0100
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 21:35:31 +0100
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 21:35:31 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
Date: Tue, 22 Mar 2016 21:35:19 +0100
Message-ID: <20160322213519.2ff69588@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<CAJCQCtQEutVto5q3Pps+Yx9NBhPFWXBNiX=UMzMWy=uyEDb1wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 22 Mar 2016 13:42:00 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> This is kinda confusing.

Err yes maybe... ;-D

> So the gist is that the guest OS is Windows, so the VDI contains an
> NTFS file system. Correct? And that VDI is on a Btrfs formatted bcache
> device. Correct? Does the VDI have +C xattr set?

Yes:

VirtualBox runs guest OS "Windows 7 32-bit"
VDI file is stored on btrfs running on bcache device
chattr +C is not set

I used chattr +C until a few weeks ago when I decided to flip
autodefrag back on and realised that +C won't allow compressing file
contents. The VM actually ran faster afterwards. And it ran fine until
lately when those errors occurred.

But I have to admit I didn't use the VM a lot in a while. So the first
time the error occurred may be a few more days back. According to my
snapshot backlog on the backup partition, the last successful backup of
this VDI file was on 2016-03-13 when I was running kernel 4.4.4
according to my emerge log.

-- 
Regards,
Kai

Replies to list-only preferred.

