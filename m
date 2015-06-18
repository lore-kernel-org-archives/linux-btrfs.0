Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out13.tpgi.com.au ([220.244.226.123]:58251 "EHLO
	mail13.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750874AbbFRCkF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 22:40:05 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Christian <cdysthe@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: trim not working and irreparable errors from btrfsck
Date: Thu, 18 Jun 2015 02:20:20 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
 <CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
 <mls0gb$s7m$1@ger.gmane.org>
In-Reply-To: <mls0gb$s7m$1@ger.gmane.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Christian
> Sent: Thursday, 18 June 2015 12:34 AM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: trim not working and irreparable errors from btrfsck
> 
> On 06/17/2015 10:22 AM, Chris Murphy wrote:
> > On Wed, Jun 17, 2015 at 6:56 AM, Christian Dysthe <cdysthe@gmail.com>
> wrote:
> >> Hi,
> >>
> >> Sorry for asking more about this. I'm not a developer but trying to learn.
> >> In my case I get several errors like this one:
> >>
> >> root 2625 inode 353819 errors 400, nbytes wrong
> >>
> >> Is it inode 353819 I should focus on and what is the number after
> >> "root", in this case 2625?
> >
> > I'm going to guess it's tree root 2625, which is the same thing as fs
> > tree, which is the same thing as subvolume. Each subvolume has its own
> > inodes. So on a given Btrfs volume, an inode number can exist more
> > than once, but in separate subvolumes. When you use btrfs inspect
> > inode it will list all files with that inode number, but only the one
> > in subvol ID 2625 is what you care about deleting and replacing.
> >
> Thanks! Deleting the file for that inode took care of it. No more errors.
> Restored it from a backup.
> 
> However, fstrim still gives me "0 B (0 bytes) trimmed, so that may be another
> problem. Is there a way to check if trim works?

I've got the same problem. I've got 2 SSDs with 2 partitions in RAID1, fstrim always works on the 2nd partition but not the first. There are no errors on either filesystem that I know of, but the first one is root so I can't take it offline to run btrfs check.

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
