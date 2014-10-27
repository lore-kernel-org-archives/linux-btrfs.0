Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58427 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750853AbaJ0Ekl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 00:40:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem converting data raid0 to raid1: enospc errors during balance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <544DA288.8040907@cn.fujitsu.com>
Date: Sun, 26 Oct 2014 22:40:39 -0600
Cc: Jasper Verberk <jverberk@hotmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <1304C47B-8A9D-4AEA-B64A-C6566C77A5E1@colorremedies.com>
References: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl> <544DA288.8040907@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 26, 2014, at 7:40 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> Hi,
> 
> Although I'm not completely sure, but it seems that, you really ran out of space.
> 
> [1] Your array won't hold raid1 for 1.97T data
> Your array used up 1.97T raid0 data, it takes 1.97T for raid0.
> But if converted to 1.97T, it will occupy 1.97T X2 = 3.94T.
> Your array are only 2.73T, it is too small to contain the data.

I'm not understanding. The btrfs fi show, shows 4x 2.73TiB devices, so that seems like it's a 10+TiB array.

There's 2.04TiB raid0 data chunks, so roughly 500GiB per device, yet 1.94TiB is reported used per device by fi show. Confusing.

Also it's still very confusing: Data, RAID1: total=2.85TiB, used=790.46GiB whether this means 2.85TiB out of 10TiB is allocated, or if it's twice that due to raid1. I can't ever remember this presentation detail, so again the secret decode ring where the UI doesn't expressly tell us what's going on is going to continue to be a source of confusion for users.


Chris Murphy