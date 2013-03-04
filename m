Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:40663 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab3CDOj6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 09:39:58 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 58C7E9A0368
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Mar 2013 07:39:58 -0700 (MST)
Date: Mon, 4 Mar 2013 09:39:56 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Joeri Vanthienen <mail@joerivanthienen.be>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/extent_map.c:78 free_extent_map+0x6e/0x90
 [btrfs]() [linux 3.8.0]
Message-ID: <20130304143956.GA3822@shiny.masoncoding.com>
References: <CAPsrAuCGwDCuWJ-NUt8vZGOgav779=KaF+32kf4A1bW7pZSF5g@mail.gmail.com>
 <CAPsrAuCk52oLpxyOfs8VyjKAoFZ3f8JqADRm=TVFuP4AWPkEHw@mail.gmail.com>
 <CAPsrAuCMLi2m-3_vSE+FZLwMEDRhHDLoM0qnJAw0tYgcqsr=Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAPsrAuCMLi2m-3_vSE+FZLwMEDRhHDLoM0qnJAw0tYgcqsr=Og@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 04, 2013 at 07:06:05AM -0700, Joeri Vanthienen wrote:
> Some more maybe usefull information. After reboot, the btrfs raid10
> filesystem is unmountable.
> I'm now running the test without enhanceIO from IO.
> 
> linux-testsan:~ #btrfs device scan --all-devices
> [  881.520686] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
> 2 transid 10 /dev/sdd
> [  881.522907] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
> 1 transid 14 /dev/sdc
> [  901.949559] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
> 4 transid 14 /dev/sdf
> [  901.949962] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
> 3 transid 14 /dev/sde
> [  901.950367] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
> 2 transid 10 /dev/sdd
> [  901.952572] device fsid 21b0cd45-019d-4e83-bf2f-053eaaf8b380 devid
> 1 transid 14 /dev/sdc
> linux-testsan:~ # btrfsck /dev/sde
> Check tree block failed, want=858902528, have=858836992

This is telling us the device returned the wrong block.  It could be
because the device really read from the wrong place, or perhaps it is
because the correct block was never written.

Please let us know if you're still seeing this without enhanceIO
involved.  I haven't tried enhanceIO yet, so I'm not sure how well it
supports btrfs.

-chris
