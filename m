Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57125 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934734Ab3FTAyi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Jun 2013 20:54:38 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: csum failed during rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAOMROUgePCJUS_P=VhnmJQ+CDT56kRg_o=brcdYaTzf1TcGCRg@mail.gmail.com>
Date: Wed, 19 Jun 2013 18:54:35 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <2DB3E3B2-7563-45E0-950C-889CFC9A554D@colorremedies.com>
References: <CAOMROUjkcZGC-OwkPdJvyx6KknpAeEA0jp3bkh=GF8zpS2mb9g@mail.gmail.com> <CAOMROUgePCJUS_P=VhnmJQ+CDT56kRg_o=brcdYaTzf1TcGCRg@mail.gmail.com>
To: John Haller <john.h.haller@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 19, 2013, at 5:55 PM, John Haller <john.h.haller@gmail.com> wrote:
> 
> It appears that devid 1 was never balanced. Note that the drive
> numbers are different because I still have the backup device connected
> which had the originals of corrupted files. The filesystem started
> with devid 1, was filled to the above capacity, and the other drives
> were added later, so it didn't start as a RAID 0 system.

Did you balance with -dconvert raid0 when you added the additional drives?


Chris Murphy
