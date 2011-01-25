From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: How to fasten btrfs?
Date: Tue, 25 Jan 2011 11:30:36 +0100
Message-ID: <201101251130.37051.hka@qbs.com.pl>
References: <AANLkTikMucRF3e-w_x7HnfjPZ-8EmQyhSfcTCihQZmTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Magicloud Magiclouds <magicloud.magiclouds@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikMucRF3e-w_x7HnfjPZ-8EmQyhSfcTCihQZmTg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 25 of January 2011 07:45:02 Magicloud Magiclouds wrote:
> Hi,
>   I am using 2.6.36.3 kernel with btrfs, 512MB memory and a very slow
> disk, no special options for mounting btrfs except noatime. Now I
> found it very slow. When I rm a 5GB movie, it took 20 secs.

try mounting with nodatacow and defragment the directory the file resid=
es in

Regards
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
