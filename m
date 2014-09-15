Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37232 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaIOM2e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 08:28:34 -0400
Message-ID: <5416DC7A.1070608@oracle.com>
Date: Mon, 15 Sep 2014 20:32:58 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
CC: "xavier.gnata@gmail.com" <xavier.gnata@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
References: <20140911002241.201bc6c2@datenkhaos.de>	<54110AEC.6040301@oracle.com>	<54135AE7.40400@gmail.com>	<5413D7E5.6080905@oracle.com>	<20140913195525.333f93a4@datenkhaos.de> <20140913232320.64fd189c@datenkhaos.de>
In-Reply-To: <20140913232320.64fd189c@datenkhaos.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Johannes,

  Can I have you this tested.. ? Thanks.


-------
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e9676a4..1224b61 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -533,7 +533,7 @@ static noinline int device_list_add(const char *path,
                  * the btrfs dev scan cli, after FS has been mounted.
                  */
                 if (fs_devices->opened) {
-                       return -EBUSY;
+                       goto out;
                 } else {
                         /*
                          * That is if the FS is _not_ mounted and if you
@@ -566,6 +566,7 @@ static noinline int device_list_add(const char *path,
         if (!fs_devices->opened)
                 device->generation = found_transid;

+out:
         *fs_devices_ret = fs_devices;

         return ret;
-------

Anand



On 09/14/2014 05:23 AM, Johannes Hirte wrote:
> On Sat, 13 Sep 2014 19:55:25 +0200
> Johannes Hirte <johannes.hirte@datenkhaos.de> wrote:
>
>> On Sat, 13 Sep 2014 13:36:37 +0800
>> Anand Jain <Anand.Jain@oracle.com> wrote:
>>
>>> Xavier, Johannes,
>>>
>>>       The quickest workaround for you will be to try to match
>>>    the device path as in the btrfs fi show -m </mnt> output to
>>>    your probably fstab/mnttab entry.
>>
>> Doesn't work here. I don't even get a path with the affected kernels.
>> I'll get:
>>
>> Label: none  uuid: 02edbd6b-f044-4800-b21e-ca8982c2c2e5
>>          Total devices 1 FS bytes used 270.10GiB
>>          *** Some devices missing
>>
>> Btrfs v3.16
>>
>> with a working kernel:
>>
>> Label: none  uuid: 02edbd6b-f044-4800-b21e-ca8982c2c2e5
>>          Total devices 1 FS bytes used 270.10GiB
>>          devid    1 size 293.89GiB used 289.06GiB path /dev/sda1
>>
>> Btrfs v3.16
>>
>> Filesystem layout is:
>>
>> subvolid 0 contains only the different subvolumes
>>
>> ID 257 gen 414674 top level 5 path rootfs
>> ID 269 gen 414615 top level 5 path home-USER1
>> ID 317 gen 411498 top level 5 path home-USER2
>> ID 363 gen 410939 top level 5 path home-USER3
>> ID 382 gen 315844 top level 5 path home-USER4
>> ID 933 gen 410514 top level 5 path home-USER5
>> ID 995 gen 315756 top level 5 path homefs-USER6
>>
>> subvol rootfs (ID 257) is set to the default subvolume, mounted at
>> start. Grub commandline is like following:
>>
>> root=/dev/sda1 ro rootflags=subvol=rootfs,inode_cache,autodefrag
>>
>> It doesn't matter, if the subvol parameter is set. I've tried with,
>> without and with subvolid=0 parameter. Everytime the same result.
>>
>>
>> And now I was able to reproduce on a second machine. The main
>> difference between the affected and the unaffected systems is
>> initramfs. On the affected systems, I don't use one. On the working
>> systems, the rootfs is mounted via initramfs before. I'll test, if an
>> initramfs will solve the issue. Seems likely, cause if I put the disk
>> of an affected system into a working system and mount it there,
>> everything works.
>
> Of course, with the initramfs it works. Content of the init-script:
>
> #!/bin/sh
>
> mount -t devtmpfs devtmpfs /dev
> mount -t proc proc /proc
> mount -t sysfs sysfs /sys
> mount -t tmpfs tmpfs /run
> sleep 3  # wait for kernel msgs to quiet
>
> echo "loading initrd"
>
> btrfs dev scan
> sleep 5
>
> mount -o ro,subvol=rootfs,inode_cache,autodefrag /dev/sda1 /newroot
>
> if [[ -x /newroot/sbin/init ]]; then
>          umount /sys /proc
>          exec switch_root /newroot /sbin/init
> fi
>
> #rescue shell
> exec sh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
