Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7507 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751120AbcLEDQg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 22:16:36 -0500
Subject: Re: btrfs repair and zero-log doesn't seem to do anything
To: Calle Kabo <calle.kabo@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <d3fdffb8-b5b5-11a7-1e04-d40c75059be7@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4fe6af11-a137-04ab-2714-5c6dc013bc06@cn.fujitsu.com>
Date: Mon, 5 Dec 2016 11:16:22 +0800
MIME-Version: 1.0
In-Reply-To: <d3fdffb8-b5b5-11a7-1e04-d40c75059be7@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/05/2016 10:28 AM, Calle Kabo wrote:
> Hi,
>
> I've got a Netgear NAS with an encrypted 4 disk RAID5 setup. One of the
> hard drives was emailing me about errors so I swapped it out before it
> died. While syncing another disk died. So I've cloned the disk I
> replaced before it died and managed to get the array running again. You
> can read more about that here:
> https://community.netgear.com/t5/Using-your-ReadyNAS/Re-adding-disk-to-volume/m-p/1179982/highlight/false
>
> But now BTRFS won't mount. I'd like to mount it read only so I can move
> the stuff to another drive and then format the NAS into a new array. If
> there's some data loss that's fine, the most important stuff is already
> backed up, but there are a few things that aren't backed up that I find
> it worth the effort of trying to restore if at all possible.
>
> Mandatory information:
> root@MyNAS:~# uname -a
> Linux MyNAS 4.1.30.armada.1 #1 SMP Thu Sep 22 16:39:49 PDT 2016 armv7l
> GNU/Linux
> root@MyNAS:~# btrfs --version
> btrfs-progs v4.7.3
> root@MyNAS:~# btrfs fi show
> Label: '0e35246e:data'  uuid: b6283e48-ebd3-4fdb-8976-b66b1f0868bc
>         Total devices 1 FS bytes used 3.99TiB
>         devid    1 size 8.17TiB used 4.22TiB path /dev/dm-0
>
> Here's what I've done (/dev/mapper/data-0 is symlinked to /dev/dm-0 so
> they're interchangeable):
>
> root@MyNAS:~# mount -t btrfs -o ro,recovery,nospace_cache,clear_cache
> /dev/dm-0 /data
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/data-0,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> root@MyNAS:~# dmesg | tail
> [25168.491582] BTRFS info (device dm-0): enabling auto recovery
> [25168.724395] BTRFS (device dm-0): parent transid verify failed on
> 2474687627264 wanted 558760 found 558769
> [25168.732497] BTRFS (device dm-0): parent transid verify failed on
> 2474687627264 wanted 558760 found 558769
> [25168.734444] BTRFS (device dm-0): parent transid verify failed on
> 2474687627264 wanted 558760 found 558769
> [25168.736294] BTRFS (device dm-0): parent transid verify failed on
> 2474687627264 wanted 558760 found 558769
> [25169.583328] BTRFS (device dm-0): bad tree block start
> 6746185026026631152 3067274493952
> [25169.595978] BTRFS (device dm-0): bad tree block start
> 13892978140409233545 3067274493952
> [25169.597777] BTRFS (device dm-0): bad tree block start
> 6746185026026631152 3067274493952
> [25169.599472] BTRFS (device dm-0): bad tree block start
> 13892978140409233545 3067274493952
> [25169.599516] BTRFS: Failed to read block groups: -5
> [25169.640222] BTRFS: open_ctree failed

According to the fsck report, extent tree seems to be corrupted heavily.
A lot of transid error and bad tree blocks.

No wonder kernel refuses to mount it.

>
> root@MyNAS:~# btrfs rescue zero-log /dev/mapper/data-0
> parent transid verify failed on 2474648240128 wanted 558760 found 558765
> parent transid verify failed on 2474648240128 wanted 558760 found 558765
> parent transid verify failed on 2474648240128 wanted 558760 found 558765
> parent transid verify failed on 2474648240128 wanted 558760 found 558765
> Ignoring transid failure
> parent transid verify failed on 2474688413696 wanted 558760 found 558769
> parent transid verify failed on 2474688413696 wanted 558760 found 558769
> parent transid verify failed on 2474688413696 wanted 558760 found 558769
> parent transid verify failed on 2474688413696 wanted 558760 found 558769
> Ignoring transid failure
> parent transid verify failed on 2474691854336 wanted 558765 found 558758
> parent transid verify failed on 2474691854336 wanted 558765 found 558758
> parent transid verify failed on 2474691854336 wanted 558765 found 558758
> parent transid verify failed on 2474691854336 wanted 558765 found 558758
> Ignoring transid failure
> leaf parent key incorrect 2474691854336
> Clearing log on /dev/mapper/data-0, previous log_root 0, level 0
> Unable to find block group for 0
> extent-tree.c:289: find_search_start: Assertion `1` failed.

Zero log won't help on such heavily damaged fs.

>
> The output of btrfs check --repair /dev/mapper/data-0 is attached.

Considering it's extent tree heavily damaged, normal repair won't help.

IMHO there will be 2 alternative method to recover:

1) Btrfs restore
    The safest method to recover files.
    Although it may need a lot of space to restore recovered data.

2) Btrfs check --init-extent-tree
    This will use fs tree to try to rebuild the extent tree.
    I don't believe it's only extent tree corrupted, so this may make
    things even *worse*, but at least it won't take several TBs to
    recover data which you may already have backup.

Thanks,
Qu
>
> What should I do next? Run --init-csum-tree? btrfs restore to a USB
> drive? Any help much appreciated.
>
> /Calle
>
>


