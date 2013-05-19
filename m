Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:11113 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751950Ab3ESSSX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 14:18:23 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:53044 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80)
	(envelope-from <lists@colorremedies.com>)
	id 1Ue8Ba-0012Wk-0c
	for linux-btrfs@vger.kernel.org; Sun, 19 May 2013 12:18:22 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Virtual Device Support
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130519171510.54897415@natsu>
Date: Sun, 19 May 2013 12:18:19 -0600
Message-Id: <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com>
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 19, 2013, at 5:15 AM, Roman Mamedov <rm@romanrm.ru> wrote:

> On Fri, 10 May 2013 07:03:38 -0700
> George Mitchell <george@chinilu.com> wrote:
> 
>> One the things that is frustrating me the most at this point from a user 
>> perspective regarding btrfs is the current lack of virtual devices to 
>> describe volumes and subvolumes.
> 
> From a user perspective btrfs subvolumes have a lot in common with just
> regular directories aka folders, and nothing in common with (block)devices.
> "Describing them with virtual devices" does not seem to make a whole lot of
> sense.

It's not possible to mount regular directories with other file systems. In some ways the btrfs subvolume behaves like a folder. In other ways it acts like a device. If you stat the mount point for btrfs subvolumes, you get a unique device ID for each.

It seems inconsistent that mount and unmount allows a /dev/ designation, but only mount honors label and UUID.

I can mount with mount /dev/disk/by-uuid/xxxxxxx, but if I use umount /dev/disk/by-uuid/xxxxxxxx I get a bogus error:

umount: /dev/disk/by-uuid/xxxxxxxxxx: not mounted

mount /dev/disk/by-uuid will autocomplete/list uuids in that directory, umount will not. So just from a consistency standpoint that seems broken.


Chris Murphy