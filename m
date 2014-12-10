Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27901 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaLJDHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 22:07:35 -0500
Message-ID: <5487B991.9080906@oracle.com>
Date: Wed, 10 Dec 2014 11:10:09 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>
CC: Konstantin <newsbox1026@web.de>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com> <5484F198.3070206@web.de> <5485BCED.1060705@ubuntu.com>
In-Reply-To: <5485BCED.1060705@ubuntu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/12/2014 22:59, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 12/7/2014 7:32 PM, Konstantin wrote:
>>> I'm guessing you are using metadata format 0.9 or 1.0, which put
>>> the metadata at the end of the drive and the filesystem still
>>> starts in sector zero.  1.2 is now the default and would not have
>>> this problem as its metadata is at the start of the disk ( well,
>>> 4k from the start ) and the fs starts further down.
>> I know this and I'm using 0.9 on purpose. I need to boot from
>> these disks so I can't use 1.2 format as the BIOS wouldn't
>> recognize the partitions. Having an additional non-RAID disk for
>> booting introduces a single point of failure which contrary to the
>> idea of RAID>0.
>
> The bios does not know or care about partitions.  All you need is a
> partition table in the MBR and you can install grub there and have it
> boot the system from a mdadm 1.1 or 1.2 format array housed in a
> partition on the rest of the disk.  The only time you really *have* to
> use 0.9 or 1.0 ( and you really should be using 1.0 instead since it
> handles larger arrays and can't be confused vis. whole disk vs.
> partition components ) is if you are running a raid1 on the raw disk,
> with no partition table and then partition inside the array instead,
> and really, you just shouldn't be doing that.
>
>> Anyway, to avoid a futile discussion, mdraid and its format is not
>> the problem, it is just an example of the problem. Using dm-raid
>> would do the same trouble, LVM apparently, too. I could think of a
>> bunch of other cases including the use of hardware based RAID
>> controllers. OK, it's not the majority's problem, but that's not
>> the argument to keep a bug/flaw capable of crashing your system.
>
> dmraid solves the problem by removing the partitions from the
> underlying physical device ( /dev/sda ), and only exposing them on the
> array ( /dev/mapper/whatever ).  LVM only has the problem when you
> take a snapshot.  User space tools face the same issue and they
> resolve it by ignoring or deprioritizing the snapshot.
>
>> As it is a nice feature that the kernel apparently scans for drives
>> and automatically identifies BTRFS ones, it seems to me that this
>> feature is useless. When in a live system a BTRFS RAID disk fails,
>> it is not sufficient to hot-replace it, the kernel will not
>> automatically rebalance. Commands are still needed for the task as
>> are with mdraid. So the only point I can see at the moment where
>> this auto-detect feature makes sense is when mounting the device
>> for the first time. If I remember the documentation correctly, you
>> mount one of the RAID devices and the others are automagically
>> attached as well. But outside of the mount process, what is this
>> auto-detect used for?
>>
>> So here a couple of rather simple solutions which, as far as I can
>> see, could solve the problem:
>>
>> 1. Limit the auto-detect to the mount process and don't do it when
>> devices are appearing.

  In the test case provided earlier who is triggering the scan ?
  grub-probe ?


>> 2. When a BTRFS device is detected and its metadata is identical to
>> one already mounted, just ignore it.

  Seems like patch:
    commit b96de000bc8bc9688b3a2abea4332bd57648a49f
    Author: Anand Jain <anand.jain@oracle.com>
    Date:   Thu Jul 3 18:22:05 2014 +0800

      Btrfs: device_list_add() should not update list when mounted


But we had to revert, Since btrfs bug become a feature for the system 
boot process and fixing that breaks mount at boot with subvol.

  commit 0f23ae74f589304bf33233f85737f4fd368549eb
  Author: Chris Mason <clm@fb.com>
  Date:   Thu Sep 18 07:49:05 2014 -0700

    Revert "Btrfs: device_list_add() should not update list when mounted"

      This reverts commit b96de000bc8bc9688b3a2abea4332bd57648a49f.


> That doesn't really solve the problem since you can still pick the
> wrong one to mount in the first place.

  The question is does both device has same generation number ?
  if not then this fix will take care of picking the device
  with larger generation number it during mount.

commit 77bdae4d136e167bab028cbec58b988f91cf73c0
Author: Anand Jain <anand.jain@oracle.com>
Date:   Thu Jul 3 18:22:06 2014 +0800

     btrfs: check generation as replace duplicates devid+uuid


  Yes if there are two devices with the same
    fsid + devid + uuid + generation

  then it use last probed during mount.
  OR
  if the device is already mounted, just the device path is updated
  but still the original device will be still in use (bug).

Thanks


> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
>
> iQEcBAEBAgAGBQJUhbztAAoJENRVrw2cjl5RomkH/26Q3M6LXVaF0qEcEzFTzGEL
> uVAOKBY040Ui5bSK0WQYnH0XtE8vlpLSFHxrRa7Ygpr3jhffSsu6ZsmbOclK64ZA
> Z8rNEmRFhOxtFYTcQwcUbeBtXEN3k/5H49JxbjUDItnVPBoeK3n7XG4i1Lap5IdY
> GXyLbh7ogqd/p+wX6Om20NkJSx4xzyU85E4ZvDADQA+2RIBaXva5tDPx5/UD4XBQ
> h8ai+wS1iC8EySKxwKBEwzwb7+Z6w7nOWO93v/lL34fwTg0OIY9uEfTaAy5KcDjz
> z6QXWTmvrbiFpyy/qyGSqBGlPjZ+r98mVEDbYWCVfK8AoD6UmteD7R8WAWkWiWY=
> =PJww
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
