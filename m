From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: btrfs-convert fails
Date: Mon, 1 Nov 2010 10:06:12 +0800
Message-ID: <AANLkTimFGe1PSbns4ps_wGSpSVMNhWehd=zoA8XnAu5_@mail.gmail.com>
References: <BZurHFYT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BZurHFYT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 31, 2010 at 11:55 PM, Helmut Hullen <Hullen@t-online.de> wr=
ote:
> Hallo, linux-btrfs,
>
> I've tried to convert a 12 GByte ext2 partition (nearly full, 280 MBy=
te
> free) with btrfs-convert.
>
> After about 15 minutes (700-MHz-CPU) the system tells
>
> =A0...
> =A0creating ext2fs image file
> =A0cleaning up system chunk
> =A0btrfs-convert: extent-tree.c:2529: btrfs_reserve_extent: Assertion
> =A0 =A0 `!(ret)' failed
> =A0Abgebrochen

Try btrfs-convert -r /dev/xxx, hopefully it will recover your ext2.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
