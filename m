Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1465 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab3ALCS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 21:18:56 -0500
From: "Rick Liu" <rickliu@broadcom.com>
To: "Hugo Mills" <hugo@carfax.org.uk>
cc: =?iso-8859-1?Q?Joshua_Sch=FCler?= <joshua.schueler@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: how to resize (grow) device partition of a multi-device
 BTRFS filesystem?
Date: Sat, 12 Jan 2013 02:18:44 +0000
Message-ID: <7D0754FFADBD2D4785C1D233C497C47B1BCD81D0@SJEXCHMB06.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
>    You'll need to use something like fdisk or cfdisk to resize the
> partition first. With (c)fdisk, that involves deleting and recreating
> the partition with the same starting point. (fdisk gives you more
> control here). As with most low-level FS-resizing tools, btrfs fi
> resize doesn't attempt to change the size of the underlying device.
> 
>    Hugo.
[Rick Liu] 
I see.
So that means unlike ext4 filesystem,
which I can use resize2fs on line to grow partition without losing data,
BTRFS must re-create partition table (fdisk) and loss data.

I'll then use a workaround:
add new bigger virtual disk.

Thank for your help,

Rick

