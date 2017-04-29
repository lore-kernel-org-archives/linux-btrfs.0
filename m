Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0063.outbound.protection.outlook.com ([104.47.116.63]:27479
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1951914AbdD2Bqj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 21:46:39 -0400
From: Paul Jones <paul@pauljones.id.au>
To: "kreijack@inwind.it" <kreijack@inwind.it>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs, journald logs, fragmentation, and fallocate
Date: Sat, 29 Apr 2017 01:46:36 +0000
Message-ID: <MEXPR01MB2168B9173B1D3C55040DFFEA9E120@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
 <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
In-Reply-To: <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Goffredo Baroncelli
> Sent: Saturday, 29 April 2017 3:05 AM
> To: Chris Murphy <lists@colorremedies.com>
> Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
> Subject: Re: btrfs, journald logs, fragmentation, and fallocate
> 
> 
> In the past I faced the same problems; I collected some data here
> http://kreijack.blogspot.it/2014/06/btrfs-and-systemd-journal.html.
> Unfortunately the journald files are very bad, because first the data is
> written (appended), then the index fields are updated. Unfortunately these
> indexes are near after the last write . So fragmentation is unavoidable.

Perhaps a better idea for COW filesystems is to store the index in a separate file, and/or rewrite the last 1 MB block (or part thereof) of the data file every time data is appended? That way the data file will use 1MB extents and hopefully avoid ridiculous amounts of metadata. 


Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
