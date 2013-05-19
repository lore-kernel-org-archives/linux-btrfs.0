Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42189 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752073Ab3ESSWM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 14:22:12 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:53046 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80)
	(envelope-from <lists@colorremedies.com>)
	id 1Ue8FH-0013cx-Vi
	for linux-btrfs@vger.kernel.org; Sun, 19 May 2013 12:22:12 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Virtual Device Support
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com>
Date: Sun, 19 May 2013 12:22:11 -0600
Message-Id: <26BABD4D-3B5E-4574-AB90-CA714F19D4A8@colorremedies.com>
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu> <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 19, 2013, at 12:18 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> It's not possible to mount regular directories with other file systems. In some ways the btrfs subvolume behaves like a folder. In other ways it acts like a device. If you stat the mount point for btrfs subvolumes, you get a unique device ID for each.

Also a possible use case for btrfs subvolumes as virtual devices, if this isn't already possible or reliable, is in place of LV's for virtual machines. It's very convenient to point a VM to local LVM storage, and have it use an LV which can easily be created, located, and destroyed, and presented to the VM as a single block device. A btrfs subvolume isn't a block device of course, but if it can be pointed to in this fashion it would make it as useful in this scenario as LVs.

Otherwise I have to create another btrfs file system on a qcow2 image which then resides on btrfs. So it's double btrfs which performance wise I think is an undesirable hit.

Chris Murphy