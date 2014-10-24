Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50448 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932421AbaJXRLS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 13:11:18 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem converting data raid0 to raid1: enospc errors during balance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl>
Date: Fri, 24 Oct 2014 11:11:21 -0600
Message-Id: <D3C31CA0-D46E-47A6-8EAD-74DFDF549902@colorremedies.com>
References: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Jasper Verberk <jverberk@hotmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 24, 2014, at 7:32 AM, Jasper Verberk <jverberk@hotmail.com> wrote:
> 
> [60104.040776] BTRFS info (device sdc): 1046 enospc errors during balance


To get more information, remount with enospc_debug option, and try to convert again.

> root@BlackMesa:/mnt# btrfs --version
> Btrfs v3.14.1

There are many fixes since this version, I suggest going to 3.17 which also has a lot of new fsck code in case that ends up being needed. You can try btrfs-image again. Then see if btrfs check (without --repair) shows anything suspicious.


Chris Murphy

