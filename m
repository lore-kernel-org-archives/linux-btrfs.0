Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58788 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752286AbaJ0Qnv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 12:43:51 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem converting data raid0 to raid1: enospc errors during balance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <DUB118-W201FD897C8121E783F626CDA9E0@phx.gbl>
Date: Mon, 27 Oct 2014 10:43:41 -0600
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <3E982444-5500-45BB-A04F-CF16D735CDF7@colorremedies.com>
References: <DUB406-EAS294A0E4ED8B326281AFD7C6DA9E0@phx.gbl>,<53BBD40F-B9F3-492C-9F56-15EAFC00119D@colorremedies.com> <DUB118-W201FD897C8121E783F626CDA9E0@phx.gbl>
To: Jasper Verberk <jverberk@hotmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 27, 2014, at 9:56 AM, Jasper Verberk <jverberk@hotmail.com> wrote:

> These are the results to a normal df:
> 
> http://paste.debian.net/128932/
> 
> The mountpoint is /data.

OK so this is with the new computation in kernel 3.17 (which I think contains a bug by counting free space twice); so now it shows available blocks based on the loss due to mirroring or parity. So 1k blocks 5860533168 = 5.45TiB. If you boot an older kernel my expectation is this shows up as 10.91TiB. In any case, df says there's 1.77TiB worth of data, so there should be plenty of space.

Somewhere there's a bug. Either the 'btrfs fi df' is insufficiently communicating whether the desired operation can be done, or there's actual kernel confusion on how much space is available to do the conversion.

I wonder what happens if you go back to kernel 3.16 and try do do the conversion?


Chris Murphy