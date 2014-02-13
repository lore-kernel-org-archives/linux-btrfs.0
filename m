Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44721 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752067AbaBMSRJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 13:17:09 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot when removing drive)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52FD08A2.3080205@gmail.com>
Date: Thu, 13 Feb 2014 11:17:05 -0700
Cc: Frank Kingswood <frank@kingswood-consulting.co.uk>,
        Saint Germain <saintger@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <FDDA816A-1F8F-4F2E-BBFB-ECAB2CF25FAC@colorremedies.com>
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com> <E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com> <CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com> <52FC8769.9030405@kingswood-consulting.co.uk> <298ECBDF-898C-4C2E-8004-BBCFEB677969@colorremedies.com> <52FD08A2.3080205@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 13, 2014, at 11:02 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> 
> While this is what the UEFI spec says is supposed to be the fallback,
> many systems don't actually look there unless the media is removable.
> All of my UEFI systems instead look for Microsoft/Boot/bootmgfw.efi as
> the fallback (Cause most x86 system designers don't care at all about
> standards compliance as long as it will run windows).

True, and they should be filed as bugs with the manufacturer, citing the UEFI spec as being violated. There's not much else to do in such cases, while considering they have a different fallback location: Microsoft/Boot/bootmgfw.efi.

Nevertheless, so long as NVRAM is behaving and isn't pilfered for other purposes, then you can specify a fallback entry there.

Chris Murphy