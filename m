Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64908 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762071AbdJRBYH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 21:24:07 -0400
Subject: Re: Mount failing - unable to find logical
To: Cameron Kelley <cameronkelley28@gmail.com>, linux-btrfs@vger.kernel.org
References: <8aa155ab-4722-9448-0f9e-b383f37d7973@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <93bfd00c-1ade-176d-0c0f-675fe904ab88@gmx.com>
Date: Wed, 18 Oct 2017 09:24:01 +0800
MIME-Version: 1.0
In-Reply-To: <8aa155ab-4722-9448-0f9e-b383f37d7973@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年10月18日 04:43, Cameron Kelley wrote:
> Hey btrfs gurus,
> 
> I have a 4 disk btrfs filesystem that has suddenly stopped mounting
> after a recent reboot. The data is in an odd configuration due to
> originally being in a 3 disk RAID1 before adding a 4th disk and running
> a balance to convert to RAID10. There wasn't enough free space to
> completely convert, so about half the data is still in RAID1 while the
> other half is in RAID10. Both metadata and system are RAID10. It has
> been in this configuration for 6 months or so now since adding the 4th
> disk. It just holds archived media and hasn't had any data added or
> modified in quite some time. I feel pretty stupid now for not correcting
> that sooner though.
> 
> I have tried mounting with different mount options for recovery, ro,
> degraded, etc. Log shows errors about "unable to find logical
> 3746892939264 length 4096"
> 
> When I do a btrfs check, it doesn't find any issues. Running
> btrfs-find-root comes up with a message about a block that the
> generation doesn't match. If I specify that block on the btrfs check, I
> get transid verify failures.
> 
> I ran a dry run of a recovery of the entire filesystem which runs
> through every file with no errors. I would just restore the data and
> start fresh, but unfortunately I don't have the free space at the moment
> for the ~4.5TB of data.
> 
> I also ran full smart self tests on all 4 disks with no errors.
> 
> root@nas2:~# uname -a
> Linux nas2 4.13.7-041307-generic #201710141430 SMP Sat Oct 14 14:39:06
> UTC 2017 i686 i686 i686 GNU/Linux

I don't think i686 kernel will cause any difference, but considering
most of us are using x86_64 to develop/test, maybe it will be a good
idea to upgrade to x86_64 kernel?

> 
> root@nas2:~# btrfs version
> btrfs-progs v4.13.2
> 
> root@nas2:~# btrfs fi show
> Label: none  uuid: 827029a4-8625-4a50-a22d-0fd28dbe2d36
>         Total devices 4 FS bytes used 4.60TiB
>         devid    1 size 2.73TiB used 2.33TiB path /dev/sdb1
>         devid    2 size 2.73TiB used 2.33TiB path /dev/sdc
>         devid    3 size 2.73TiB used 2.33TiB path /dev/sdd1
>         devid    4 size 2.73TiB used 2.33TiB path /dev/sde1
> 
> root@nas2:~# mount /dev/sdb1 /mnt/nas2/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> 
> root@nas2:~# dmesg | tail
> [  801.332623] BTRFS info (device sdb1): disk space caching is enabled
> [  801.332627] BTRFS info (device sdb1): has skinny extents
> [  801.333386] BTRFS critical (device sdb1): unable to find logical
> 3746892939264 length 4096
> [  801.333472] BTRFS critical (device sdb1): unable to find logical
> 3746892939264 length 4096
> [  801.333769] BTRFS critical (device sdb1): unable to find logical
> 3746892939264 length 4096
> [  801.333835] BTRFS critical (device sdb1): unable to find logical
> 3746892939264 length 4096
> [  801.333909] BTRFS critical (device sdb1): unable to find logical
> 3746892939264 length 4096
> [  801.333968] BTRFS critical (device sdb1): unable to find logical
> 3746892939264 length 4096
> [  801.334028] BTRFS error (device sdb1): failed to read chunk root
> [  801.365452] BTRFS error (device sdb1): open_ctree failed

Some of the chunk tree failed to be read out.

Either chunk tree or system chunk array has some problem.

Would you please dump the chunk tree and superblock by the following
commands?

# btrfs inspect-internal dump-tree -t chunk /dev/sdb1
# btrfs inspect-internal dump-super -fa /dev/sdb1

> 
> root@nas2:~# btrfs check /dev/sdb1
> Checking filesystem on /dev/sdb1
> UUID: 827029a4-8625-4a50-a22d-0fd28dbe2d36
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 5054297628672 bytes used, no error found
> total csum bytes: 4929567064
> total tree bytes: 5197856768
> total fs tree bytes: 15237120
> total extent tree bytes: 43433984
> btree space waste bytes: 161510789
> file data blocks allocated: 5050024812544
>  referenced 5049610178560

Unless we has some bug in btrfs-progs chunk mapping, the result seems
quite good.

Just in case, would you please also run "btrfs check --mode=lowmem
/dev/sdb1" to see if it's OK?

> 
> root@nas2:~# btrfs-find-root /dev/sdb1
> Superblock thinks the generation is 147970
> Superblock thinks the level is 1
> Found tree root at 21335861559296 gen 147970 level 1
> Well block 21335857758208(gen: 147969 level: 1) seems good, but
> generation/level doesn't match, want gen: 147970 level: 1

Since it's mostly related to chunk tree, would you please try the
following command?

# btrfs-find-root -o 3 /dev/sdb1
# btrfs check --chunk-root <the next chunk root bytenr> /dev/sdb1

Thanks,
Qu

> 
> root@nas2:~# btrfs check -r 21335857758208 /dev/sdb1
> parent transid verify failed on 21335857758208 wanted 147970 found 147969
> parent transid verify failed on 21335857758208 wanted 147970 found 147969
> parent transid verify failed on 21335857758208 wanted 147970 found 147969
> parent transid verify failed on 21335857758208 wanted 147970 found 147969
> Ignoring transid failure
> Checking filesystem on /dev/sdb1
> UUID: 827029a4-8625-4a50-a22d-0fd28dbe2d36
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> ERROR: transid errors in file system
> found 5054297628672 bytes used, error(s) found
> total csum bytes: 4929567064
> total tree bytes: 5197856768
> total fs tree bytes: 15237120
> total extent tree bytes: 43433984
> btree space waste bytes: 161510789
> file data blocks allocated: 5050024812544
>  referenced 5049610178560
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
