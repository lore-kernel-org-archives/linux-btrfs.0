Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39369 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757061AbaJXSTW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 14:19:22 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem converting data raid0 to raid1: enospc errors during balance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <DUB118-W8DE2E384783A11BF1F307DA930@phx.gbl>
Date: Fri, 24 Oct 2014 12:19:16 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <7AFD9544-8F25-4B07-9612-CD69F830C938@colorremedies.com>
References: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl>,<D3C31CA0-D46E-47A6-8EAD-74DFDF549902@colorremedies.com> <DUB118-W8DE2E384783A11BF1F307DA930@phx.gbl>
To: Jasper Verberk <jverberk@hotmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 24, 2014, at 11:49 AM, Jasper Verberk <jverberk@hotmail.com> wrote:

> Did that, you can find the result in the pastebin.
> 
> http://paste.debian.net/128552/

Maybe Josef or David will have some idea.

I'd still take a btrfs-image and btrfs check with current btrfs-progs.

Chris Murphy

