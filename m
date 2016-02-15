Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30523 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbcBODlN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 22:41:13 -0500
Subject: Re: Problems with "btrfs dev remove" of dead disk
To: Andy Smith <andy@strugglers.net>
References: <20160214215531.GQ4290@bitfolk.com>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <56C148CB.3060704@oracle.com>
Date: Mon, 15 Feb 2016 11:40:59 +0800
MIME-Version: 1.0
In-Reply-To: <20160214215531.GQ4290@bitfolk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Feb 14 18:30:21 specialbrew kernel: [27576201.178630] BTRFS: bdev /dev/sdh errs: wr 128, rd 8, flush 2, corrupt 0, gen 0
> Feb 14 18:30:21 specialbrew kernel: [27576201.309583] BTRFS: lost page write due to I/O error on /dev/sdh
> Feb 14 18:30:21 specialbrew kernel: [27576201.315761] BTRFS: bdev /dev/sdh errs: wr 129, rd 8, flush 2, corrupt 0, gen 0
> Feb 14 18:30:21 specialbrew kernel: [27576201.322086] BTRFS: lost page write due to I/O error on /dev/sdh
>
> …and those BTRFS: messages continue now even though the system no
> longer has a /dev/sdh.

    You need the patch set
       [PATCH 00/15] btrfs: Hot spare and Auto replace

    which includes the patch required here.
     [PATCH 07/15] btrfs: introduce device dynamic state transition to 
offline or failed

   and this will take care of stopping the IO when disk fails.

> Now:
>
> $ sudo btrfs fi sh /srv/tank
> Label: 'tank'  uuid: 472ee2b3-4dc3-4fc1-80bc-5ba967069ceb
>          Total devices 6 FS bytes used 1.57TiB
>          devid    3 size 1.82TiB used 383.00GiB path /dev/sdg
>          devid    4 size 1.82TiB used 384.00GiB path /dev/sdf
>          devid    5 size 2.73TiB used 1.25TiB path /dev/sdk
>          devid    6 size 1.82TiB used 347.00GiB path /dev/sdj
>          devid    7 size 2.73TiB used 464.00GiB path /dev/sde
>          *** Some devices missing

  btrfs progs has a code to fabricate missing in the user land
  instead of obtaining from the kernel.
  ---
  commit 206efb60cbe3049e0d44c6da3c1909aeee18f813
     btrfs-progs: Add missing devices check for mounted btrfs.
  ---

  So I recommend to use 'btrfs fi show -m', which I guess in your
  case shall not show that devid 2 is missing. Because without
  the kernel patch
    [PATCH 07/15] btrfs: introduce device dynamic state transition to 
offline or failed
  Kernel won't make that (online to offline/failed) transitions at all.

  Current workaround to tell kernel that a device is missing is only
  by .. unmount and mount (not remount (bug)) which is a kind of
  (enterprise unacceptable) workaround. Sorry about that.


> $ sudo btrfs dev usage /srv/tank

::

> /dev/sdh, ID: 2
>     Device size:               0.00B
>     Data,RAID1:            383.00GiB
>     Metadata,RAID1:          1.00GiB
>     System,RAID1:           32.00MiB
>     Unallocated:             1.44TiB

  Yep kernel does not know that device is missing. That
  part of the code is in the patch to be integrated as above.

> So, ideally I'd like to remove the missing device sdh (id 2) to have
> redundant copies of the data until I can insert a new drive. But
> "remove" doesn't seem to want to work:


> $ sudo btrfs dev remove /dev/sdh /srv/tank
> ERROR: not a block device: /dev/sdh
> $ sudo btrfs dev remove 2 /srv/tank
> ERROR: not a block device: 2
> $ btrfs --version
> btrfs-progs v4.4

  Since now device is removed. So only option is to use devid
  if you want to remove/delete. but it needs the patch.
    [PATCH 0/7] Introduce device delete by devid
  I think this is being integrated into 4.5.x (needs both kernel
  and progs patches).


  If you happen to try any of these patches, please consider to
  post results.


> I expect my kernel might be too old as it is a Debian backports
> version on wheezy (linux-image-3.16.0-0.bpo.4-amd64
> 3.16.7-ckt20-1+deb8u3~bpo70+1).
>
> If I upgrade the kernel then should one of those remove commands
> above work?


> I would rather not reboot just now if I can achieve redundancy in
> some other way. Would a rebalance like:
>
> $ sudo btrfs balance -f -v -sdevid=2 -mdevid=2 /srv/tank
>
> reconstruct redundant copies elsewhere?

  No. Please don't do that. It would aggravate the IO errors and
  disk will never be removed from the kernel.

  I suggest reboot if its btrfs root or btrfs is not a kernel module,
  otherwise
  umount
  modprobe -r btrfs (removes stale device entries)
  btrfs dev scan
  mount

  Now 'btrfs fi show -m' should show device id 2 missing.
  So now either you may replace devid2 or delete devid 2 based
  on your business data protection needs.

  Kindly note. If you are trying the hot spare and auto replace patches,
  in this context after the reboot, the device id will be identified
  as missing. And Not failed. So the auto replace won't trigger
  the replace if you have a spare device. This is as designed.


> With this btrfs-progs and kernel version, will a later "btrfs
> replace start -r /dev/sdh /dev/sdl" work without me rebooting into a
> newer kernel, even though /dev/sdh doesn't exist as a device to the
> kernel right now?

  Yes you can consider this, without needing to reboot, however the
  command will be
    btrfs replace start -r 2 /dev/sdl /btrfs

Thanks, Anand


> Any information/advice appreciated.
>
> Cheers,
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
