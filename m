Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33721 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaIQIot (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 04:44:49 -0400
Message-ID: <54194B0E.6080603@oracle.com>
Date: Wed, 17 Sep 2014 16:49:18 +0800
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



>> And now I was able to reproduce on a second machine. The main
>> difference between the affected and the unaffected systems is
>> initramfs. On the affected systems, I don't use one.

  In this test of with or without initramfs script. I guess the kernel
  remain same at 3.17-rc3 and above

>> On the working
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

  this will work since the device path that we provide here
  is already the device path which probably will be the final
  device path after bootup.

Thanks

> if [[ -x /newroot/sbin/init ]]; then
>          umount /sys /proc
>          exec switch_root /newroot /sbin/init
> fi
>
> #rescue shell
> exec sh

