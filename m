Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46922 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbaCaS3F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 14:29:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WUgxD-0006dz-6Q
	for linux-btrfs@vger.kernel.org; Mon, 31 Mar 2014 20:29:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 20:29:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 20:29:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Especially broken btrfs
Date: Mon, 31 Mar 2014 18:28:52 +0000 (UTC)
Message-ID: <pan$907b1$50c6d5fb$4633652$98ec0154@cox.net>
References: <532BB037.90401@gmx.com> <5339A026.2070907@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bob Marley posted on Mon, 31 Mar 2014 19:04:38 +0200 as excerpted:

> Hi, I hadn't noticed this post,
> I think I know the reason this time : you have used USB you bad guy!
> I think USB does not support flush / barrier , which is mandatory for
> BTRFS to work correctly in case of power loss.
> For most filesystems actually, but the damages suffered by COW
> filesystems such as btrfs are much more severe than for static
> filesystems such as ext4 .
> 
> Please check if when you connect the USB drive you see in dmesg
> something like:
> 
> |[  .... . .....] sd ...:0:0:0: [sdf] Write cache: ....., read cache:
> ....., doesn't support DPO or FUA
> |

Umm... Most direct-connect SATA drives are apparently missing DPO/FUA 
also, or at least it's not normally enabled by the driver.  Certainly 
that's what dmesg says for my SATA drives here, tho for the pair of SSDs 
(but not the spinning rust) hdparm -I says WRITE__{DMA|MULTIPLE}_FUA_EXT 
is enabled (star in the enabled column), while  WRITE_DMA_QUEUED_FUA_EXT 
is not (no star).

Google says only enterprise-grade SAS/SCSI drives are likely to have it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

