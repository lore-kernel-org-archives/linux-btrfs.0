Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42496 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752358Ab3FHWUV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Jun 2013 18:20:21 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Moved partition via dd
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <51B327C4.3000304@delorus.de>
Date: Sat, 8 Jun 2013 18:20:17 -0400
Cc: linux-btrfs@vger.kernel.org
Message-Id: <E3D849EC-DDAC-4E05-9571-303B869F7A8D@colorremedies.com>
References: <51B327C4.3000304@delorus.de>
To: =?iso-8859-1?Q?Andr=E9_Schlichting?= <andre@delorus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 8, 2013, at 8:47 AM, André Schlichting <andre@delorus.de> wrote:

> 
> The old partition had the sector boundaries: 245547520 - 732566527
> 
> I deleted this one and created a new one with boundaries: 33024 - 732566640
> 
> Now I moved the data
>  > sudo dd conv=notrunc bs=4096 iflag=fullblock if=/dev/sdc2 skip=$((245547520-33024)) seek=0 of=/dev/sdc2

You ultimately moved the wrong data because bs=4096 for dd, yet the partition logical sectors are based on 512 bytes.


Chris Murphy