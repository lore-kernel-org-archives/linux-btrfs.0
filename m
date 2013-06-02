Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:28113 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754354Ab3FBQwp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Jun 2013 12:52:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: RAID10 total capacity incorrect
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
Date: Sun, 2 Jun 2013 12:52:40 -0400
Cc: linux-btrfs@vger.kernel.org
Message-Id: <099CD4A1-A70D-4446-8C55-843D21BE4E7F@colorremedies.com>
References: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
To: Tim Eggleston <lists@timeggleston.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 2, 2013, at 12:17 PM, Tim Eggleston <lists@timeggleston.co.uk> wrote:
> 
> root@mckinley:/# btrfs fi df /mnt/shares/btrfsvol0
> Data, RAID10: total=2.06TB, used=2.06TB
> System, RAID10: total=64.00MB, used=188.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID10: total=3.00GB, used=2.29GB
> 
> 
> Am I being an idiot and missing something here? 

No, it's confusing. btrfs fi df doesn't show free space. The first value is what space the fs has allocated for the data usage type, and the 2nd value is how much of that allocation is actually being used. I personally think the allocated value is useless for mortal users. I'd rather have some idea of what free space I have left, and the regular df command presents this in an annoying way also because it shows the total volume size, not accounting for the double consumption of raid1. So no matter how you slice it, it's confusing.


Chris Murphy