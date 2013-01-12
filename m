Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:42495
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212Ab3ALDLW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 22:11:22 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: how to resize (grow) device partition of a multi-device BTRFS filesystem?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130112022848.GX19051@carfax.org.uk>
Date: Fri, 11 Jan 2013 20:11:19 -0700
Message-Id: <91428FEA-7325-4B98-AF07-2B3FB072421E@colorremedies.com>
References: <7D0754FFADBD2D4785C1D233C497C47B1BCD81D0@SJEXCHMB06.corp.ad.broadcom.com> <20130112022848.GX19051@carfax.org.uk>
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 11, 2013, at 7:28 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Sat, Jan 12, 2013 at 02:18:44AM +0000, Rick Liu wrote:
>>> 
>>>   You'll need to use something like fdisk or cfdisk to resize the
>>> partition first. With (c)fdisk, that involves deleting and recreating
>>> the partition with the same starting point. (fdisk gives you more
>>> control here). As with most low-level FS-resizing tools, btrfs fi
>>> resize doesn't attempt to change the size of the underlying device.
>>> 
>>>   Hugo.
>> [Rick Liu] 
>> I see.
>> So that means unlike ext4 filesystem,
>> which I can use resize2fs on line to grow partition without losing data,
>> BTRFS must re-create partition table (fdisk) and loss data.
> 
>   No, with resize2fs, you also need to resize the partition, using
> the same process. Deleting and enlarging a partition doesn't change
> any of the data in it. resize2fs doesn't modify partition tables. (Or
> at least, didn't the last time I really looked at it in detail).

It's does not. To grow you must first change the size of the container: the partition, the LV, or array device. Then you can resize the file system. It's the same with XFS, and NTFS. I'm only aware of Apple's diskutil resizevolume command that resizes the flavors of HFS+ and at the same time sets the new end value for the partition entry.

Chris Murphy