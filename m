Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:43928 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaHBN6n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Aug 2014 09:58:43 -0400
Received: from [82.94.249.234] (latitanza [82.94.249.234]) (Authenticated sender: francesco.devita@inventati.org) by localhost (Postfix) with ESMTPSA id 15823120921
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Aug 2014 13:35:45 +0000 (UTC)
From: Francesco De Vita <francesco.devita@inventati.org>
To: linux-btrfs@vger.kernel.org
Subject: unable to mount disk, error removing orphan entry and transid failures
Date: Sat, 02 Aug 2014 15:36:28 +0200
Message-ID: <9137964.Mz9lUL7tjl@fdv-a52je>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone

I'm not subscribed to this mailing list, so if you would like to reply 
to me please add my email address in CC.

I'm using Debian Jessie (Testing) with Linux 3.14-2-amd64 (3.14.13-2) 
and Btrfs v3.14.1.


These are my disks:

> $ sudo btrfs fi show
> Label: 'debian_ssd'  uuid: e51fe605-acfe-4cc3-911c-87498e5bf202
>         Total devices 1 FS bytes used 75.38GiB
>         devid    1 size 109.79GiB used 87.04GiB path /dev/sda2
>
> Label: 'data'  uuid: 29642a24-9e18-413b-a213-8f52f49348e5
>         Total devices 1 FS bytes used 153.34GiB
>         devid    1 size 298.09GiB used 160.04GiB path /dev/sdb1


and I have a problem with the second one, a HDD partitioned as follows:

> $ sudo fdisk -l /dev/sdb
>
> Disk /dev/sdb: 320.1 GB, 320072933376 bytes
> 255 heads, 63 sectors/track, 38913 cylinders, total 625142448 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0xe0c5913d
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1            2048   625139711   312568832   83  Linux


This is what happened: I was downloading a file with Ktorrent but 
suddenly the download was interrupted suggesting that there was no 
more space left on the disk (/dev/sdb1). Using "btrfs fi df 
/mountpoint" there were no evidences of no space left, so I tried to 
remove the file, in order to download it again, but then I received 
an I/O error message and it was impossibile to remove the file.
At this point I simply rebooted my system, and here come troubles...

To make a long story short, I'm now unable to mount the disk and also, 
to boot up my system I had to comment out /dev/sdb1 from fstab.
This is what happens if I try to mount it (with or without mount 
options):

> $ sudo mount -t btrfs -o recovery,nospace_cache,clear_cache \
> /dev/sdb1 /tmp/disk/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> $ dmesg | tail
> [ 4807.804659] BTRFS info (device sdb1): enabling auto recovery
> [ 4807.804676] BTRFS info (device sdb1): disabling disk space caching
> [ 4807.804687] BTRFS info (device sdb1): force clearing of disk cache
> [ 4808.204075] parent transid verify failed on 239058944 wanted 1150 
> 		 found 1125899906843774
> [ 4808.227703] parent transid verify failed on 239058944 wanted 1150 
> 		 found 1125899906843774
> [ 4808.227734] BTRFS error (device sdb1): Error removing orphan 
> 		 entry, stopping orphan cleanup
> [ 4808.227739] BTRFS critical (device sdb1): could not do orphan 
> 		 cleanup -22
> [ 4808.477155] BTRFS: open_ctree failed


Moreover btrfsck gives:

> $ sudo btrfsck /dev/sdb1
> Checking filesystem on /dev/sdb1
> UUID: 29642a24-9e18-413b-a213-8f52f49348e5
> checking extents
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
> Ignoring transid failure
> checking free space cache
> cache and super generation don't match, space cache will be 
>   invalidated
> checking fs roots
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
> Ignoring transid failure
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
> Ignoring transid failure
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
>
> ----- [hundreds of lines like above] -----
>
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
> Ignoring transid failure
> parent transid verify failed on 239058944 wanted 1150 found 
>   1125899906843774
> Ignoring transid failure
> root 5 inode 152079 errors 400, nbytes wrong
> found 116115363572 bytes used err is 1
> total csum bytes: 160413592
> total tree bytes: 388710400
> total fs tree bytes: 168460288
> total extent tree bytes: 21364736
> btree space waste bytes: 62697338
> file data blocks allocated: 346825613312
>  referenced 164106739712
> Btrfs v3.14.1


This is the problem and I don't understand what's going on. Is there 
the chance to at least retrieve the data in the disk? As stated 
at the beginning of the email I'm not subscribed to this ML, 
please add my email address in CC in the reply. Thank you in advance.

Best regards
-- 
Francesco De Vita
E-mail: francesco.devita@inventati.org
OpenPGP Key: 0x5E658D5F01C57174
