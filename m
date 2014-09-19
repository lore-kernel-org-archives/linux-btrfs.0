Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41452 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbaISWAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 18:00:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XV6Dk-0007bS-1b
	for linux-btrfs@vger.kernel.org; Sat, 20 Sep 2014 00:00:04 +0200
Received: from 75.50.101.32 ([75.50.101.32])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 00:00:04 +0200
Received: from rohbeck by 75.50.101.32 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 00:00:04 +0200
To: linux-btrfs@vger.kernel.org
From: Ralf-Peter Rohbeck <rohbeck@yahoo.com>
Subject: Re: Single disk parrallelization
Date: Fri, 19 Sep 2014 14:29:56 -0700
Message-ID: <lvi78k$haj$1@ger.gmane.org>
References: <BLU406-EAS1974279D81BF03735D65B479AB40@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <BLU406-EAS1974279D81BF03735D65B479AB40@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2014 11:10 AM, Jeb Thomson wrote:
> With the advanced features of btrfs, it would be an additional simple task to make different platters run in parallel.
>
> In this case, say a disk has three platters, and so three seek heads as well. If we can identify that much, and what offsets they are at, it then becomes a trivial matter to place the reads and writes to different platters at the same time.
>
> In affect, this means each platter should be operating as a single virtualized unit, instead of one single unit...
>
> Regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
A disk drive has only one actuator that moves all heads in parallel. 
Also disk drives are an array of logical blocks today; nobody uses 
cylinder/head/sector addressing any more.

