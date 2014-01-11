Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from icts.hu ([195.70.57.6]:41997 "EHLO icts.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaAKTYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 14:24:39 -0500
Message-ID: <52D19A76.80701@dblaci.hu>
Date: Sat, 11 Jan 2014 20:24:38 +0100
From: =?UTF-8?B?U3phbG1hIEzDoXN6bMOz?= <dblaci@dblaci.hu>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS over LVM remounts read-only
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>	<20140111150454.GV15634@carfax.org.uk>	<CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>	<52D19217.3060106@dblaci.hu> <20140112011608.220a2ae3@natsu>
In-Reply-To: <20140112011608.220a2ae3@natsu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah, I used to do the way you wrote before, but in fact, G means 
gigabyte (1024^3), and works the same with both tools. On smaller units 
You have to watch for the rounding to extent size (4M by default).

Moreover, some could use:

btrfs fi re -2G /mount          (well, I just noticed, I accidentally 
wrote the device last time, but btrfs resize should be used on mount point.)
lvresize -L -2G /device

  :)

DBLaci

And of course, this is what should be done to prevent data loss. This 
method won't fix the original problem of course...

Thanks for your comment!

2014-01-11 20:16 keltezéssel, Roman Mamedov írta:
> On Sat, 11 Jan 2014 19:48:55 +0100
> Szalma László <dblaci@dblaci.hu> wrote:
>
>> 2014-01-11 18:10 keltezéssel, MegaBrutal írta:
>>> How can I shrink the FS to the correct size right now, ensuring that I
>>> really shrink it to the exact LV size?
>> btrfs fi re 10G /dev/mapper/vg-lv
>> lvresize -L 10G vg/lv
> That's setting yourself up for a failure if these tools happen to disagree on
> what "G" means (GB vs GiB). Maybe that's what happened here with the thread
> starter's FS?
>
> To be completely safe, I would recommend to resize the FS in two steps, leaving
> some safety margin to the partition resize first:
>
>    btrfs fi re 8G /dev/mapper/vg-lv
>    lvresize -L 10G vg/lv
>    btrfs fi re max /dev/mapper/vg-lv
>

