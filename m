Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:6152 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753197Ab3HWB0F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 21:26:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5F161E82-F226-43FB-860F-53AF859E4EFA@nickle.es>
Date: Thu, 22 Aug 2013 19:26:03 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <78390B95-F33F-44AC-BF85-ED48D7FF2BFE@colorremedies.com>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es> <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com> <5F161E82-F226-43FB-860F-53AF859E4EFA@nickle.es>
To: Nicholas Lee <email@nickle.es>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 22, 2013, at 6:59 PM, Nicholas Lee <email@nickle.es> wrote:
> 
> smartctl -x /dev/sdg | grep SCT

The grep filtered the current read/write values, try this:

smartctl -l scterc /dev/sdg


If it's higher than 300(30.0 seconds) then you should change it:

smartctl -l scterc,70,70 /dev/sdX

for all drives. And then I'd filter through dmesg to see if you have any PHY or read errors or ATA reset messages.


Chris Murphy