Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0057.outbound.protection.outlook.com ([104.47.116.57]:3296
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751101AbdHAKxv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 06:53:51 -0400
From: Paul Jones <paul@pauljones.id.au>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.UK>
CC: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: RE: Btrfs + compression = slow performance and high cpu usage
Date: Tue, 1 Aug 2017 10:53:48 +0000
Message-ID: <MEXPR01MB216832C336FC052D1D3B7F6C9EB30@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
 <8446582.541.1501260065690.JavaMail.gkos@dynomob>
 <22907.32175.311827.10738@tree.ty.sabi.co.uk>
 <19527869.26.1501422186960.JavaMail.gkos@dynomob>
 <22911.5971.350346.969146@tree.ty.sabi.co.uk>
 <6022267.255.1501581534233.JavaMail.gkos@dynomob>
In-Reply-To: <6022267.255.1501581534233.JavaMail.gkos@dynomob>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Konstantin V. Gavrilenko
> Sent: Tuesday, 1 August 2017 7:58 PM
> To: Peter Grandi <pg@btrfs.list.sabi.co.UK>
> Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
> Subject: Re: Btrfs + compression = slow performance and high cpu usage
> 
> Peter, I don't think the filefrag is showing the correct fragmentation status of
> the file when the compression is used.
> At least the one that is installed by default in Ubuntu 16.04 -  e2fsprogs |
> 1.42.13-1ubuntu1
> 
> So for example, fragmentation of compressed file is 320 times more then
> uncompressed one.
> 
> root@homenas:/mnt/storage/NEW# filefrag test5g-zeroes
> test5g-zeroes: 40903 extents found
> 
> root@homenas:/mnt/storage/NEW# filefrag test5g-data
> test5g-data: 129 extents found

Compressed extents are about 128kb, uncompressed extents are about 128Mb. (can't remember the exact numbers.) 
I've had trouble with slow filesystems when using compression. The problem seems to go away when removing compression.

Paul.






ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
