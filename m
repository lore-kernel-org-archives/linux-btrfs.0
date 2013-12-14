Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47903 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754178Ab3LNXuN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 18:50:13 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:51002 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VryyK-000s3Q-Ip
	for linux-btrfs@vger.kernel.org; Sat, 14 Dec 2013 16:50:12 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Blocket for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
Date: Sat, 14 Dec 2013 16:50:11 -0700
Message-Id: <337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com> <46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com> <CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 14, 2013, at 4:19 PM, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:

> Looking into triggering the error again and dmesg and sysrq, but here
> are the other two:
> 
> # btrfs fi show
> Label: none  uuid: 9302fc8f-15c6-46e9-9217-951d7423927c
>        Total devices 8 FS bytes used 13.00TB
>        devid    4 size 3.64TB used 3.48TB path /dev/sdt
>        devid    3 size 3.64TB used 3.48TB path /dev/sds
>        devid    8 size 3.64TB used 3.48TB path /dev/sdr
>        devid    6 size 3.64TB used 3.48TB path /dev/sdp
>        devid    7 size 3.64TB used 3.48TB path /dev/sdq
>        devid    5 size 3.64TB used 3.48TB path /dev/sdo
>        devid    1 size 3.64TB used 3.48TB path /dev/sdl
>        devid    2 size 3.64TB used 3.48TB path /dev/sdm
> 
> Btrfs v0.20-rc1
> 
> 
> # btrfs fi df /storage/storage-vol0/
> Data, RAID10: total=13.89TB, used=12.99TB
> System, RAID10: total=64.00MB, used=1.19MB
> System: total=4.00MB, used=0.00
> Metadata, RAID10: total=21.00GB, used=17.59GB

By my count this is ~ 95.6% full. My past experience with other file systems, including btree file systems, is they get unpredictably fussy when they're this full. I start migration planning once 80% full is reached, and make it a policy to avoid going over 90% full.

I don't know what behavior Btrfs developers anticipate for this scenario. On the one hand it seems reasonable to  expect it to only be slow, rather than block the whole server for 2 minutes. But on the other hand, it's reasonable to expect server storage won't get this full.


Chris Murphy