Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pecan2-mail.exetel.com.au ([220.233.0.71]:41342 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaKRMQW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 07:16:22 -0500
From: Paul Jones <paul@pauljones.id.au>
To: Robert White <rwhite@pobox.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: RE: BUG :: btrfs resize should require mount point not just
 /some/path
Date: Tue, 18 Nov 2014 12:16:14 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64593F3AD272@Server.waterlogic.com.au>
References: <546B24E9.2020705@pobox.com>
In-Reply-To: <546B24E9.2020705@pobox.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Robert White
> Sent: Tuesday, 18 November 2014 9:52 PM
> To: Btrfs BTRFS
> Subject: BUG :: btrfs resize should require mount point not just /some/path
> 
> So here's a thing...
> 
> If you've got a BTRFS root file system and you mount go to resize a
> removable media and you make a typo you can easily resize your root
> instead of a target.
> 
> mkdir /media/vol1 /media/vol2
> mount /dev/sdz1 /media/vol2 # intended vol1 btrfs resize -32G /media/vol1
> umount /dev/sdz1 #proceed to fark up /dev/sdz1 with partitioning tools
> 
> Since resize will accept _any_ existing directory (or even filename?) as the
> target of a resize instead of limiting the targets to known mount-points it
> pretty much invites mistakes.
> 
> The system _should_ error out on any path thats not a mount point in the
> name of safety alone.
> 
> A message like "/some/path not a mounted file system" would be less
> surprising than operating on a file system when any arbitrary directory is
> named.


I have done the same thing myself, commonly when using scrub, but also using add/del device.
It's most alarming!

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
