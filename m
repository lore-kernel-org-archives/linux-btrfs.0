Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50196 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754105AbaE1UCb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 16:02:31 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Failed Disk RAID10 Problems
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKZK7uy6Y7_+JQGrZp5yTpZ2kCsH8wGDhz+Oq4oGidYkQNcq1g@mail.gmail.com>
Date: Wed, 28 May 2014 14:02:27 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <A8BF0761-B704-42DE-A0C8-C2DFDB83FFB5@colorremedies.com>
References: <CAKZK7uwZOZEjQ-T9z-KGSRpW1xpY911_QoDM26SBdmSViRtrZA@mail.gmail.com> <08C16AE5-02A8-413B-B95C-EC2B5A1D32EC@colorremedies.com> <CAKZK7ux1Cm0tQFqFJtTPbL089DQR+4Ekv5Ef8L3BgUkyY+bLQA@mail.gmail.com> <CAKZK7uy6Y7_+JQGrZp5yTpZ2kCsH8wGDhz+Oq4oGidYkQNcq1g@mail.gmail.com>
To: Justin Brown <justin.brown@fandingo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 28, 2014, at 12:39 PM, Justin Brown <justin.brown@fandingo.org> wrote:

> Chris,
> 
> Thanks for the tip. I was able to mount the drive as degraded and
> recovery. Then, I deleted the faulty drive, leaving me with the
> following array:
> 
> 
> Label: media  uuid: 7b7afc82-f77c-44c0-b315-669ebd82f0c5
> 
> Total devices 6 FS bytes used 2.40TiB
> 
> devid    1 size 931.51GiB used 919.88GiB path
> /dev/mapper/SAMSUNG_HD103SI_499431FS734755p1
> 
> devid    2 size 931.51GiB used 919.38GiB path /dev/dm-8
> 
> devid    3 size 1.82TiB used 1.19TiB path /dev/dm-6
> 
> devid    4 size 931.51GiB used 919.88GiB path /dev/dm-5
> 
> devid    5 size 0.00 used 918.38GiB path /dev/dm-11
> 
> devid    6 size 1.82TiB used 3.88GiB path /dev/dm-9
> 
> 
> /dev/dm-11 is the failed drive.

You deleted a faulty drive, dm-11 is a failed drive. Is there a difference between faulty drive and failed drive, or are they the same drive? And what drive is the one you said you successfully added?

I don't see how you have 6 devices raid10, with one failed and one added device. You need an even number of good drives to fix this.


> I take it that size 0 is a good sign.

Seems neither good nor bad to me, it's 0 because it's a dead drive presumably and therefore Btrfs isn't getting device information from it.

> I'm not really sure where to go from here. I tried rebooting the
> system with the failed drive attached, and Btrfs re-adds it to the
> array. Should I physically remove the drive now? Is a balance
> recommended?

No don't do anything else until someone actually understands faulty vs failed vs added drives.


Chris Murphy