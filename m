Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:48593 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3KHUjK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 15:39:10 -0500
Received: from homiemail-a46.g.dreamhost.com (caibbdcaaaaf.dreamhost.com [208.113.200.5])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 19D1D38186
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Nov 2013 12:39:10 -0800 (PST)
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: yzb3@wp.pl
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs might be gradually slowing the boot process
Date: Sat, 09 Nov 2013 02:08:08 +0630
Message-ID: <1665274.eaCj6Je1We@bheem>
In-Reply-To: <527d2ee689e077.81319728@wp.pl>
References: <527d2ee689e077.81319728@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, November 08, 2013 07:35:18 PM yzb3@wp.pl wrote:
> Hello,
> 
> I recently noticed that my boot has become slower - it took around 29s,
> while at the beginning it was ~6s. I thought it was an issue with systemd,
> because it failed to properly indicate at which stage the slowdown occurred
> and how long it took. I rolled back to a pretty fresh root subvolume and
> the boot was fast again. However, after several reboots it started lagging
> again (10s? preposterous!). I decided to try the *clear_cache* mount
> option; it was only a guess, but it did speed the boot to the proper ~6s.
> 
> The question is - why? My filesystem is really small - I see no reason for a
> 5x boot slowdown. Is this a known issue? I will be glad to give any
> additional details about my fs.

Have you tried defragmenting everything, including directory objects? despite 
of small amount of data, it could be massively fragmented, slowing down 
everything.

HTH
-- 
Regards
 Shridhar
