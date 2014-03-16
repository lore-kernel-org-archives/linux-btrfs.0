Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56387 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754964AbaCPXX1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 19:23:27 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140316231729.GA29149@merlins.org>
Date: Sun, 16 Mar 2014 17:23:25 -0600
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <85AE52FE-5191-49AF-98A9-380F224A5DA1@colorremedies.com>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
 <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
 <20140316231729.GA29149@merlins.org>


On Mar 16, 2014, at 5:17 PM, Marc MERLIN <marc@merlins.org> wrote:

> - but no matter how I remove the faulty drive, there is no rebuild on a
>  new drive procedure that works yet
> 
> Correct?

I'm not sure. From what I've read we should be able to add a device to raid5/6, but I don't know if it's expected we can add a device to a degraded raid5/6. If the add device succeeded, then I ought to be able to remove the missing devid, and then do a balance which should cause reconstruction.

https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg30714.html


Chris Murphy

