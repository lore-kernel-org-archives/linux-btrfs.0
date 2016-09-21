Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0078.outbound.protection.outlook.com ([104.47.116.78]:31712
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755755AbcIUL24 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 07:28:56 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs rare silent data corruption with kernel data leak
Date: Wed, 21 Sep 2016 11:14:35 +0000
Message-ID: <ME1PR01MB13788B5A79BF88786A1D571D9EF60@ME1PR01MB1378.ausprd01.prod.outlook.com>
References: <20160921045556.GN21290@hungrycats.org>
In-Reply-To: <20160921045556.GN21290@hungrycats.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Zygo Blaxell
> Sent: Wednesday, 21 September 2016 2:56 PM
> To: linux-btrfs@vger.kernel.org
> Subject: btrfs rare silent data corruption with kernel data leak
> 
> Summary:
> 
> There seem to be two btrfs bugs here: one loses data on writes, and the
> other leaks data from the kernel to replace it on reads.  It all happens after
> checksums are verified, so the corruption is entirely silent--no EIO errors,
> kernel messages, or device event statistics.
> 
> Compressed extents are corrupted with kernel data leak.  Uncompressed
> extents may not be corrupted, or may be corrupted by deterministically
> replacing data bytes with zero, or may not be corrupted.  No preconditions
> for corruption are known.  Less than one file per hundred thousand seems to
> be affected.  Only specific parts of any file can be affected.
> Kernels v4.0..v4.5.7 tested, all have the issue.

Funny you should bring this up - I think I just suffered from this, or something similar.

I have a mysql database of around 20 GiB which is under relatively heavy workload for weeks at a time. 
I just remembered today that I still had my root partition using compression from when disk space was an issue about 4 months ago. I removed the compress mount option, upgraded the kernel (from 4.7.2 to 4.7.4) and rebooted. Mysql came up properly on reboot.
I stopped mysql, ran "btrfs filesystem defragment -v -r -c none /var/lib/mysql" to remove the compression and it finished reporting 1 error, but without any actual error messages.
However Mysql now wouldn't come back up. Remembering what I read earlier today I thought "oh no...." and checked dmesg:

[  539.166231] BTRFS warning (device sda1): csum failed ino 42906332 off 81920 csum 2566472073 expected csum 1967602629
[  539.166856] BTRFS warning (device sda1): csum failed ino 42906332 off 81920 csum 2566472073 expected csum 1967602629
[  539.166865] BTRFS warning (device sda1): csum failed ino 42906332 off 94208 csum 2566472073 expected csum 1625955513
[  539.166908] BTRFS warning (device sda1): csum failed ino 42906332 off 94208 csum 2566472073 expected csum 1625955513
[  539.167553] BTRFS warning (device sda1): csum failed ino 42906332 off 0 csum 2566472073 expected csum 3995365962
[  539.168234] BTRFS warning (device sda1): csum failed ino 42906332 off 0 csum 2566472073 expected csum 3995365962
[  539.168239] BTRFS warning (device sda1): csum failed ino 42906332 off 4096 csum 2566472073 expected csum 3937913037
[  539.168282] BTRFS warning (device sda1): csum failed ino 42906332 off 4096 csum 2566472073 expected csum 3937913037
[  539.168286] BTRFS warning (device sda1): csum failed ino 42906332 off 8192 csum 2566472073 expected csum 1100728286
[  539.168328] BTRFS warning (device sda1): csum failed ino 42906332 off 8192 csum 2566472073 expected csum 1100728286
[  612.832463] __readpage_endio_check: 2 callbacks suppressed
[  612.832466] BTRFS warning (device sda1): csum failed ino 42906332 off 81920 csum 2566472073 expected csum 1967602629
[  612.833160] BTRFS warning (device sda1): csum failed ino 42906332 off 81920 csum 2566472073 expected csum 1967602629
[  612.833167] BTRFS warning (device sda1): csum failed ino 42906332 off 94208 csum 2566472073 expected csum 1625955513
[  612.833202] BTRFS warning (device sda1): csum failed ino 42906332 off 94208 csum 2566472073 expected csum 1625955513
[  612.833863] BTRFS warning (device sda1): csum failed ino 42906332 off 0 csum 2566472073 expected csum 3995365962
[  612.834549] BTRFS warning (device sda1): csum failed ino 42906332 off 0 csum 2566472073 expected csum 3995365962
[  612.834555] BTRFS warning (device sda1): csum failed ino 42906332 off 4096 csum 2566472073 expected csum 3937913037
[  612.834602] BTRFS warning (device sda1): csum failed ino 42906332 off 4096 csum 2566472073 expected csum 3937913037
[  612.834608] BTRFS warning (device sda1): csum failed ino 42906332 off 8192 csum 2566472073 expected csum 1100728286
[  612.834652] BTRFS warning (device sda1): csum failed ino 42906332 off 8192 csum 2566472073 expected csum 1100728286

Using debug tree I found inode 42906332 was the file ibdata1

I tried to copy the mysql directory elsewhere, but that caused io failures in a few files so I just removed the whole lot and restored from last nights backup.
These are the errors I got before I cancelled the copy:

[ 1284.349881] __readpage_endio_check: 2 callbacks suppressed
[ 1284.349885] BTRFS warning (device sda1): csum failed ino 42906332 off 0 csum 2566472073 expected csum 3995365962
[ 1284.349901] BTRFS warning (device sda1): csum failed ino 42906332 off 65536 csum 2566472073 expected csum 3704130384
[ 1284.349906] BTRFS warning (device sda1): csum failed ino 42906332 off 126976 csum 2566472073 expected csum 254392532
[ 1284.349911] BTRFS warning (device sda1): csum failed ino 42906332 off 8192 csum 2566472073 expected csum 1100728286
[ 1284.349913] BTRFS warning (device sda1): csum failed ino 42906332 off 77824 csum 2566472073 expected csum 716549262
[ 1284.349923] BTRFS warning (device sda1): csum failed ino 42906332 off 131072 csum 2566472073 expected csum 788300917
[ 1284.349925] BTRFS warning (device sda1): csum failed ino 42906332 off 12288 csum 2566472073 expected csum 3265258934
[ 1284.349926] BTRFS warning (device sda1): csum failed ino 42906332 off 81920 csum 2566472073 expected csum 1967602629
[ 1284.349930] BTRFS warning (device sda1): csum failed ino 42906332 off 192512 csum 2566472073 expected csum 2025572636
[ 1284.349934] BTRFS warning (device sda1): csum failed ino 42906332 off 258048 csum 2566472073 expected csum 3392889013
[ 1298.892667] BTRFS info (device sda1): csum failed ino 44628191 extent 228384051200 csum 2566472073 wanted 847116788 mirror 0
[ 1298.892727] BTRFS info (device sda1): csum failed ino 44628191 extent 228384051200 csum 2566472073 wanted 847116788 mirror 2
[ 1298.892732] BTRFS info (device sda1): csum failed ino 44628191 extent 228384051200 csum 2566472073 wanted 847116788 mirror 2
[ 1298.892751] BTRFS info (device sda1): csum failed ino 44628191 extent 228384051200 csum 2566472073 wanted 847116788 mirror 2
[ 1298.892786] BTRFS info (device sda1): csum failed ino 44628191 extent 228383002624 csum 2566472073 wanted 847116788 mirror 1
[ 1298.892792] BTRFS info (device sda1): csum failed ino 44628191 extent 228383002624 csum 2566472073 wanted 847116788 mirror 1
[ 1298.892805] BTRFS info (device sda1): csum failed ino 44628191 extent 228383002624 csum 2566472073 wanted 847116788 mirror 1
[ 1298.892849] BTRFS info (device sda1): csum failed ino 44628191 extent 228384051200 csum 2566472073 wanted 847116788 mirror 0
[ 1298.892896] BTRFS info (device sda1): csum failed ino 44628191 extent 228383002624 csum 2566472073 wanted 847116788 mirror 1
[ 1311.456422] __readpage_endio_check: 4430 callbacks suppressed
[ 1311.456425] BTRFS warning (device sda1): csum failed ino 44628192 off 3221225472 csum 2566472073 expected csum 3669189289
[ 1311.456442] BTRFS warning (device sda1): csum failed ino 44628192 off 3221229568 csum 2566472073 expected csum 317582346
[ 1311.456451] BTRFS warning (device sda1): csum failed ino 44628192 off 3221233664 csum 2566472073 expected csum 1636016048
[ 1311.456459] BTRFS warning (device sda1): csum failed ino 44628192 off 3221237760 csum 2566472073 expected csum 95857614
[ 1311.456467] BTRFS warning (device sda1): csum failed ino 44628192 off 3221241856 csum 2566472073 expected csum 2014942236
[ 1311.456482] BTRFS warning (device sda1): csum failed ino 44628192 off 3221254144 csum 2566472073 expected csum 1884694409
[ 1311.456540] BTRFS warning (device sda1): csum failed ino 44628192 off 3222274048 csum 2566472073 expected csum 2741402016
[ 1311.456542] BTRFS warning (device sda1): csum failed ino 44628192 off 3222339584 csum 2566472073 expected csum 3503993973
[ 1311.456545] BTRFS warning (device sda1): csum failed ino 44628192 off 3222405120 csum 2566472073 expected csum 3548745998
[ 1311.456551] BTRFS warning (device sda1): csum failed ino 44628192 off 3222470656 csum 2566472073 expected csum 2988893031

I'm seeing a lot of checksum 2566472073 - Is that the checksum of blank space I wonder?

Here are the details of the filesystem concerned:

vm-server mysql # btrfs fi show /
Label: 'Root'  uuid: 58d27dbd-7c1e-4ef7-8d43-e93df1537b08
        Total devices 2 FS bytes used 103.21GiB
        devid   13 size 471.93GiB used 245.03GiB path /dev/sda1
        devid   14 size 471.93GiB used 245.03GiB path /dev/sdb1

vm-server mysql # btrfs fi df /
Data, RAID1: total=242.00GiB, used=102.42GiB
System, RAID1: total=32.00MiB, used=64.00KiB
Metadata, RAID1: total=3.00GiB, used=811.02MiB
GlobalReserve, single: total=272.00MiB, used=0.00B

/dev/sda1 on / type btrfs (rw,noatime,ssd,discard,noacl,space_cache=v2,subvolid=5,subvol=/)
(compress was enabled previously)


Regards,
Paul




