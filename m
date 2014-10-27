Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58820 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaJ0K6B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 06:58:01 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so5402329lbv.21
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 03:57:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <alpine.DEB.2.19.4.1410270333250.9302@trent.utfs.org>
References: <alpine.DEB.2.19.4.1410270333250.9302@trent.utfs.org>
Date: Mon, 27 Oct 2014 10:57:59 +0000
Message-ID: <CAL3q7H4MbLCVXxLzT5d4vim1pp8ffZRsLX2GwDqgXNK3p5+sLg@mail.gmail.com>
Subject: Re: suspicious number of devices: 72057594037927936
From: Filipe David Manana <fdmanana@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 27, 2014 at 10:34 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> (somehow this message did not make it to the list)
>
> Hi,
>
> After upgrading from linux 3.17.0 to 3.18.0-rc2, I cannot mount my btrfs
> partition any more. It's just one btrfs partition, no raid, no
> compression, no fancy mount options:
>
> # mount -t btrfs -o ro /dev/sda6 /usr/local/
> mount: wrong fs type, bad option, bad superblock on /dev/sda6,
> [...]
> BTRFS: suspicious number of devices: 72057594037927936
> BTRFS: super offset mismatch 1099511627776 != 65536
> BTRFS: superblock contains fatal errors
> BTRFS: open_ctree failed
>
> The only thing fancy may be the machine: PowerBook G4 (powerpc 32 bit),
> running Debian/Linux (stable).
>
> The message comes from the newly added fs/btrfs/disk-io.c:
>
> if (sb->num_devices > (1UL << 31))
>      printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
>               sb->num_devices);
>
> And 72057594037927936 is 2^56, so maybe there's an endianess problem here?

Sounds like you need to revert this patch:
https://patchwork.kernel.org/patch/5004701/ (which ignored endianess)
or go back to an older kernel (don't use 3.17 or 3.17.1 however, due
to other serious issues, latest 3.16.x should be safe). There's a v2
of that patch that fixes the endianess issue, but it didn't make it to
3.18-rc1/2 (https://patchwork.kernel.org/patch/5082701/)

regards

>
> Some details below, please let me know what other details may be needed.
> Going back to 3.17 now...
>
> Thanks,
> Christian.
>
> # file -Ls /dev/sda6
> /dev/sda6: sticky BTRFS Filesystem sectorsize 4096, nodesize 4096,
> leafsize 4096)
>
> # btrfsck /dev/sda6
> checking extents
> checking fs roots
> checking root refs
> found 2035929088 bytes used err is 0
> total csum bytes: 1886920
> total tree bytes: 102936576
> total fs tree bytes: 94441472
> btree space waste bytes: 30875964
> file data blocks allocated: 1932992512
>  referenced 1932849152
> Btrfs Btrfs v0.19
> # echo $?
> 0
>
>
> --
> BOFH excuse #427:
>
> network down, IP packets delivered via UPS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
