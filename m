Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:57296 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaF0UHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 16:07:44 -0400
Received: from slyserver.local (unknown [IPv6:2a01:e35:2ed8:d4f0:cdbf:9101:b6c4:b7d1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 0940F4B006D
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 22:07:39 +0200 (CEST)
Message-ID: <53ADCF0B.4010109@free.fr>
Date: Fri, 27 Jun 2014 22:07:39 +0200
From: =?ISO-8859-1?Q?S=E9bastien_ROHAUT?= <sebastien.rohaut@free.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Can't mount subvolume with ro option
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In the wiki, it's said we can mount subvolumes with different mount 
options. nosuid, nodev, rw and ro are listed, as valid generic mount 
options.

https://btrfs.wiki.kernel.org/index.php/FAQ#Can_I_mount_subvolumes_with_different_mount_options.3F

But, when I try to mount my subvolume in read only I get an error.

# df
/dev/sdb1             5242880     352    4689856   1% /my_btrfs

# btrfs subvolume list /my_btrfs
ID 257 gen 10 top level 5 path subvol1

# LANG=C mount -t btrfs -o subvol=subvol1,ro /dev/sdb1 /my_btrfs/subvol1_mnt
mount: /dev/sdb1 is already mounted or /my_btrfs/subvol1_mnt busy
        /dev/sdb1 is already mounted on /my_btrfs

nodev and nosuid are working.

Is there an error in the wiki, or do I do something wrong ?

Thanks,

Sebastien ROHAUT

Some infos :

# cat /etc/redhat-release
Fedora release 20 (Heisenbug)

# uname -a
Linux localhost.localdomain 3.14.7-200.fc20.x86_64 #1 SMP Wed Jun 11 
22:38:05 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
Btrfs v3.14.1

# btrfs fi show
Label: none  uuid: 66e0f120-e478-4cac-b04a-82a0ffc4d6ce
     Total devices 1 FS bytes used 208.00KiB
     devid    1 size 5.00GiB used 548.00MiB path /dev/sdb1

Btrfs v3.14.1

# dmesg|grep -i btrfs
[    2.753052] Btrfs loaded
[    2.766655] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 9 /dev/sdb1
[   36.382921] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 9 /dev/sdb1
[   36.389497] BTRFS info (device sdb1): disk space caching is enabled
[   36.393462] SELinux: initialized (dev sdb1, type btrfs), uses xattr
[  860.375237] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 9 /dev/sdb1
[ 1141.451952] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 10 /dev/sdb1
[ 1379.802221] BTRFS info (device sdb1): disk space caching is enabled
[ 1513.815988] BTRFS info (device sdb1): disk space caching is enabled
[ 1529.839598] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 11 /dev/sdb1
[ 1624.310822] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 11 /dev/sdb1
[ 1650.630700] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 11 /dev/sdb1
[ 2297.318435] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 11 /dev/sdb1
[ 2305.110964] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 11 /dev/sdb1
[ 2332.863021] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 12 /dev/sdb1
[ 2344.573903] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 12 /dev/sdb1
[ 2348.597860] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 12 /dev/sdb1
[ 2580.620032] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 13 /dev/sdb1
[ 2645.162881] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 13 /dev/sdb1
[ 2706.458681] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 13 /dev/sdb1
[ 2727.745959] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 13 /dev/sdb1
[ 2797.601678] BTRFS: device fsid 66e0f120-e478-4cac-b04a-82a0ffc4d6ce 
devid 1 transid 13 /dev/sdb1
