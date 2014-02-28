Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42004 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751100AbaB1G0F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 01:26:05 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help with space
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <519E70A2-FA6F-41A3-9639-2C2BB965975E@colorremedies.com>
Date: Thu, 27 Feb 2014 23:26:03 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <4CE569C8-14AE-4C71-A2CC-FF8DB455460A@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <519E70A2-FA6F-41A3-9639-2C2BB965975E@colorremedies.com>
To: Justin Brown <otakujunction@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 27, 2014, at 11:13 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Feb 27, 2014, at 11:19 AM, Justin Brown <otakujunction@gmail.com> wrote:
> 
>> terra:/var/lib/nobody/fs/ubfterra # btrfs fi df .
>> Data, single: total=17.58TiB, used=17.57TiB
>> System, DUP: total=8.00MiB, used=1.93MiB
>> System, single: total=4.00MiB, used=0.00
>> Metadata, DUP: total=392.00GiB, used=33.50GiB
>> Metadata, single: total=8.00MiB, used=0.00
> 
> After glancing at this again, what I thought might be going on might not be going on. The fact it has 17+TB already used, not merely allocated, doesn't seem possible if there's a hard 16TB limit for Btrfs on 32-bit kernels.
> 
> But then I don't know why du -h is reporting only 13T total used. And I'm unconvinced this is a balance issue either. Is anything obviously missing from the file system?

What are your mount options? Maybe compression?

Clearly du is calculating things differently. I'm getting:

du -sch = 4.2G
df -h    = 5.4G
btrfs df  = 4.7G data and 620MB metadata(total).

I am using compress=lzo.

Chris Murphy

