Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27965 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaLJCnu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 21:43:50 -0500
Message-ID: <5487B3FB.4070109@oracle.com>
Date: Wed, 10 Dec 2014 10:46:19 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Florian Uekermann <florian@uekermann.me>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Device only missing if unmounted
References: <708100218.650154.1418123709778.JavaMail.open-xchange@omgreatgod.store>
In-Reply-To: <708100218.650154.1418123709778.JavaMail.open-xchange@omgreatgod.store>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/12/2014 19:15, Florian Uekermann wrote:
> I am using a few disks in Raid1 mode. This is the output of various
> commands in unmounted state.
>
> root@oot:/# uname -a
> Linux oot 3.18.0-rc5+ #1 SMP Sun Nov 23 18:01:56 CET 2014 x86_64 GNU/Linux
> root@oot:/# btrfs --version
> Btrfs v3.17
> root@oot:/# btrfs fi show
> Label: none uuid: be2b3499-7452-4b91-b664-4ec4d7ff62b9
> Total devices 3 FS bytes used 149.68GiB
> devid 2 size 465.76GiB used 151.03GiB path /dev/sdb
> devid 3 size 465.76GiB used 151.03GiB path /dev/sda
> devid 4 size 92.26GiB used 0.00B path /dev/sdc4
>
> Btrfs v3.17
> root@oot:/# btrfs fi df /srv/storage/
> Data, RAID1: total=150.00GiB, used=149.40GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=1.00GiB, used=287.42MiB
> GlobalReserve, single: total=96.00MiB, used=0.00B
>
> I stripped a few lines from the output of btrfs fi show, which
> describe other filesystems.
> If I unmount the devices in question, I get the following
> output (note that missing devices are reported now):
>
> root@oot:/# btrfs fi show
> Label: none uuid: be2b3499-7452-4b91-b664-4ec4d7ff62b9
> Total devices 4 FS bytes used 149.68GiB
> devid 2 size 465.76GiB used 151.03GiB path /dev/sdb
> devid 3 size 465.76GiB used 151.03GiB path /dev/sda
> devid 4 size 92.26GiB used 0.00B path /dev/sdc4
> *** Some devices missing
>
> Btrfs v3.17
>
> I got into this state by removing a device from the array formatting it
> and then adding it again (some time ago, I can't remember the exact
> sequence of commands)


  above you mention both btrfs fi show outputs in unmounted only.

  It depends on the disk that is read first, you could read super block
  using btrfs-show-super and check if num_device.

> The discrepancy in output between mounted and unmounted state is not
> a problem in itself for me, but this issue seems to interrupt systemds
> boot sequence, which only continues successfully if I mount the array manually.
> The array is not degraded, I just removed a drive (via btrfs delete I think).

It may fail if you are mounting more than one subvol during boot and if 
you don't have this patch.

  commit 0f23ae74f589304bf33233f85737f4fd368549eb
  Author: Chris Mason <clm@fb.com>
  Date:   Thu Sep 18 07:49:05 2014 -0700

    Revert "Btrfs: device_list_add() should not update list when mounted"

      This reverts commit b96de000bc8bc9688b3a2abea4332bd57648a49f.


> If I try to remove the "missing devices" with the btrfs tool the following
> happens:
>
> btrfs dev del missing /srv/storage
> ERROR: error removing the device 'missing' - no missing devices found to remove

  that means you don't see missing when mounted. if you don't see
  missing when mounted then no need to run delete missing. ?


> btrfs balance start /srv/storage/ does not solve the issue.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
