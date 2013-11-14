Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:63953 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757728Ab3KNVXB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 16:23:01 -0500
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50609 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1Vh4NP-003it1-Ox
	for linux-btrfs@vger.kernel.org; Thu, 14 Nov 2013 14:23:00 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BUG: btrfsRe: Does btrfs "raid1" actually provide any resilience?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <528536F7.6030503@libero.it>
Date: Thu, 14 Nov 2013 14:22:59 -0700
Message-Id: <A0F65AC7-D109-47AB-AA1B-9156A33E86A5@colorremedies.com>
References: <l62akc$ujc$1@ger.gmane.org> <528514CA.8080903@libero.it> <528536F7.6030503@libero.it>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 14, 2013, at 1:47 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
> Instead if I use the btrfs-progs c652e4efb8e2dd7... I got
> 
> [snip]

> Data+Metadata: total=8.00MB, used=28.00KB
> 
> Note the absence of any RAID1 profile.

What happens if the devices are large enough to avoid mandatory block group mixing? Try 100GB for each device. Is the problem reproducible?


Chris Murphy