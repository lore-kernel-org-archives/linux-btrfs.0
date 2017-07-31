Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20005 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbdGaSOz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 14:14:55 -0400
Date: Mon, 31 Jul 2017 11:12:01 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: "marcel.cochem" <marcel.cochem@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS error: bad tree block start 0 623771648
Message-ID: <20170731181200.GA3459@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAN_=hu0k8+FmrSOw5P5TAZyjzjvGyqv_ByYr27s8rZY456k87Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN_=hu0k8+FmrSOw5P5TAZyjzjvGyqv_ByYr27s8rZY456k87Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 30, 2017 at 06:14:35PM +0200, marcel.cochem wrote:
> Hello,
> 
> I had to shut down my PC because it hang up, after the next reboot i
> got the following error:
>     BTRFS error on /dev/nvme0n1p4 bad tree block start 0 623771648
>     open_ctree failed
>     mount wrong fs type
>     bad superblock
>     missing codepage or helper program, or other error.
> 
> I had no backup (schame on my, now i made a backup of my failed parition)
> I can't check or rescure any data, because all btrfs-progs stop with
> messages like:
> 
>     root@marcel-debug:/mnt# btrfs restore  /dev/nvme0n1p4 /mnt/1
>     checksum verify failed on 623771648 found E4E3BDB6 wanted 00000000
>     checksum verify failed on 623771648 found E4E3BDB6 wanted 00000000
>     bytenr mismatch, want=623771648, have=0
>     Couldn't read tree root

Superblock and chunk tree root is OK, looks like the header part of
the tree root is now all-zero, but I'm unable to think of a btrfs bug
which can lead to that (if there is, it is a serious enough one), and
on ssd like disks, by default there is only one copy for metadata.

Now that all progs has been stuck in reading tree root node, one
workaround is to hijack the btrfs code to bypass that whole
check(including checksum checking) for reading metadata blocks to let
us read the block no matter what mismatch it may have and see if the
content is meaningful to us.  The function that needs to be hijacked
is btree_readpage_end_io_hook() in fs/btrfs/disk-io.c

But please note you should play this trick on the backup copy disk
you've aleady made, instead of the original one.  The best situation
would be that tree root node is the only corrupted node.  Good luck.

thanks,

-liubo

> 
> or
> 
>     root@marcel-debug:/home/marcel/Desktop/btrfs-progs#
> ./btrfs-find-root /dev/nvme0n1p4
>     Couldn't read tree root
>     Superblock thinks the generation is 82096
>     Superblock thinks the level is 1
> 
> My bad installation had kernel 4.11 and my rescue installation has
> also 4.11 installed. However the btrfs-progs had some problems
> (endless loop for btrfs-find-root), so i decided to compile them
> myself with the newest version 4.12 . However neither version works.
> 
> I am pretty sure that not all data is lost as i can grep thorugh the
> 100 GB SSD partition. But my question is, if there is a tool to rescue
> all (intact) data and maybe have only a few corrupt files which can't
> be recovered.
> 
> I put detailed information and commands outputs in pastebin:
> https://pastebin.com/7kzjb4Ae
> 
> Best regards,
> Marcel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
