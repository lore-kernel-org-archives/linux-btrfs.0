Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39208 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750800AbaAKXIc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 18:08:32 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:52644 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W27fL-000IH4-Q4
	for linux-btrfs@vger.kernel.org; Sat, 11 Jan 2014 16:08:31 -0700
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS over LVM remounts read-only
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140112011608.220a2ae3@natsu>
Date: Sat, 11 Jan 2014 16:08:30 -0700
Message-Id: <B1D3A960-8CB9-4355-BFD4-82541D98F00C@colorremedies.com>
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com> <20140111150454.GV15634@carfax.org.uk> <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com> <52D19217.3060106@dblaci.hu> <20140112011608.220a2ae3@natsu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 11, 2014, at 12:16 PM, Roman Mamedov <rm@romanrm.net> wrote:

> On Sat, 11 Jan 2014 19:48:55 +0100
> Szalma László <dblaci@dblaci.hu> wrote:
> 
>> 2014-01-11 18:10 keltezéssel, MegaBrutal írta:
>>> How can I shrink the FS to the correct size right now, ensuring that I 
>>> really shrink it to the exact LV size?
>> 
>> btrfs fi re 10G /dev/mapper/vg-lv
>> lvresize -L 10G vg/lv
> 
> That's setting yourself up for a failure if these tools happen to disagree on
> what "G" means (GB vs GiB). Maybe that's what happened here with the thread
> starter's FS?

Yes. I've suggested a feature enhancement for Btrfs resize to report its new logical end (relative to fs start which would be 0). That can be used to deduce the resize needed for either partitions or LVs. If this is an fs shrink, it could just do the shrink without a warn. For an fs grow, if the partition isn't the right size, it fails and also states the new logical end value needed for the previously failed command to work.


> To be completely safe, I would recommend to resize the FS in two steps, leaving
> some safety margin to the partition resize first:
> 
>  btrfs fi re 8G /dev/mapper/vg-lv
>  lvresize -L 10G vg/lv
>  btrfs fi re max /dev/mapper/vg-lv

That's also a reasonable.


Chris Murphy