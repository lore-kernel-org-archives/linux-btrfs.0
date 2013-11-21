Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:18325 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3KUGw0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 01:52:26 -0500
Message-ID: <528DADB1.8010604@hardwarefreak.com>
Date: Thu, 21 Nov 2013 00:52:33 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: John Williams <jwilliams4200@gmail.com>
CC: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>	<528D61C5.70902@hardwarefreak.com> <CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>
In-Reply-To: <CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/20/2013 8:46 PM, John Williams wrote:
> For myself or any machines I managed for work that do not need high
> IOPS, I would definitely choose triple- or quad-parity over RAID 51 or
> similar schemes with arrays of 16 - 32 drives.

You must see a week long rebuild as acceptable...

> No need to go into detail here 

I disagree.

> on a subject Adam Leventhal has already
> covered in detail in an article "Triple-Parity RAID and Beyond" which
> seems to match the subject of this thread quite nicely:
> 
> http://queue.acm.org/detail.cfm?id=1670144

Mr. Leventhal did not address the overwhelming problem we face, which is
(multiple) parity array reconstruction time.  He assumes the time to
simply 'populate' one drive at its max throughput is the total
reconstruction time for the array.  While this is typically true for
mirror based arrays, it is clearly not for parity arrays.

The primary focus of my comments was reducing rebuild time, thus
increasing overall reliability.  RAID 51 or something similar would
achieve this.  Thus I think we should discuss alternatives to multiple
parity in detail.

-- 
Stan


