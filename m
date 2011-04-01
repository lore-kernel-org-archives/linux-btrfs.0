From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: btrfs balancing start - and stop?
Date: Fri, 01 Apr 2011 16:22:39 +0300
Message-ID: <4D95D19F.7060101@gmail.com>
References: <Bj0igski1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj0igski1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 1/4/2011 3:12 =CE=BC=CE=BC, Helmut Hullen wrote:
> Hallo, Struan,
>
> Du meintest am 01.04.11:
>
>> 1) Is the balancing operation expected to take many hours (or days?)
>> on a filesystem such as this? Or are there known issues with the
>> algorithm that are yet to be addressed?
> May be. Balancing about 15 GByte needed about 2 hours (or less),
> balancing about 2 TByte needed about 20 hours.
>
> "dmesg" counts down the number of remaining "jobs".
are you sure? here is a snippet of dmesg from a balance i did yesterday=
=20
(2.6.38.1)

btrfs: relocating block group 15338569728 flags 9
btrfs: found 17296 extents
btrfs: found 17296 extents
btrfs: relocating block group 13191086080 flags 9
btrfs: found 21029 extents
btrfs: found 21029 extents
btrfs: relocating block group 11043602432 flags 9
btrfs: found 4728 extents
btrfs: found 4728 extents


> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
