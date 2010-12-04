From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 04 Dec 2010 18:17:00 +0100
Message-ID: <BbFN9mlD1uB@helmut.hullen.de>
References: <Bb7IYwqi1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bb7IYwqi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I wrote am 02.12.10:

> I use 2 disks (1.5 Tbyte and 2.0 TByte) under 1 LABEL (for my video
> collection, nearly alle files have more than 1 GByte):

> Label: MM2  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
> 	Total devices 2 FS bytes used 2.38TB
> 	devid    2 size 1.35TB used 1.35TB path /dev/sdc3
> 	devid    1 size 1.81TB used 1.35TB path /dev/sdf2

> ("btrfs-show" uses TiByte, it's 10% less than TByte)

> Btrfs Btrfs v0.19

> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdc3            3400799848 2559596740 841203108  76% /srv/MM

> --------------------------------

> When I add some more videos, writing gets slower and slower, and then
> the system refuses with "no space left ..."

[...]

No help?

Viele Gruesse!
Helmut
