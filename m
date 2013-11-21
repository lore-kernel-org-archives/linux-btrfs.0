Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:40566 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3KUXiM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 18:38:12 -0500
MIME-Version: 1.0
In-Reply-To: <528E8FEC.2070204@hardwarefreak.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
	<528D61C5.70902@hardwarefreak.com>
	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>
	<528DADB1.8010604@hardwarefreak.com>
	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>
	<528E8FEC.2070204@hardwarefreak.com>
Date: Thu, 21 Nov 2013 15:38:11 -0800
Message-ID: <CAJBj3veHCTbGstLoUec67sMWuyHQMmZNY4A6bwcb+HQOgjJ_Ew@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: John Williams <jwilliams4200@gmail.com>
To: stan@hardwarefreak.com
Cc: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 21, 2013 at 2:57 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> He wrote that article in late 2009.  It seems pretty clear he wasn't
> looking 10 years forward to 20TB drives, where the minimum mirror
> rebuild time will be ~18 hours, and parity rebuild will be much greater.

Actually, it is completely obvious that he WAS looking ten years
ahead, seeing as several of his graphs have time scales going to
2009+10 = 2019.

And he specifically mentions longer rebuild times as one of the
reasons why higher parity RAIDs are needed.
