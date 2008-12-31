From: "Liu Hui" <onlyflyer@gmail.com>
Subject: Re: A bug with multiple devices?
Date: Wed, 31 Dec 2008 09:17:01 +0800
Message-ID: <2c3b11250812301717q7d54a8cdt6417d32468ea2eee@mail.gmail.com>
References: <49597D06.1050806@cn.fujitsu.com> <495AC6AC.4000302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Shen Feng" <shen@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <495AC6AC.4000302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs -m raid1 just means 'meta data' works as raid1

You should try mkfs.btrfs -d raid1

This maybe help:
mkfs.btrfs [-A <offset>] [-b <size>] [-l <size>] [-n <size>] [-l
<label>] [-s <size>] [-m raid0|raid1|raid10|single] [-d
raid0|raid1|raid10|single] <device>

2008/12/31 Shen Feng <shen@cn.fujitsu.com>:
>
>
> on 12/30/2008 09:44 AM, Shen Feng wrote:
>> Hi,
>>
>> I create a raid-1 btrfs with the following command.
>>
>> [root@localhost ~]# fdisk -l /dev/sdb
>>
>> Disk /dev/sdb: 320.0 GB, 320072933376 bytes
>> 255 heads, 63 sectors/track, 38913 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0xb44829ea
>>
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdb1               1        4863    39062016   83  Linux
>> /dev/sdb2            4864        9726    39062047+  83  Linux
>> /dev/sdb3            9727       38905   234375905+   f  W95 Ext'd (LBA)
>> /dev/sdb5            9727       14590    39063374   83  Linux
>> /dev/sdb6           14590       19453    39068690+   7  HPFS/NTFS
>> /dev/sdb7           19454       29178    78116031   83  Linux
>> /dev/sdb8           29179       31610    19535008+  83  Linux
>> /dev/sdb9           31611       34041    19526976   83  Linux
>> /dev/sdb10          34042       36473    19535008+  83  Linux
>> /dev/sdb11          36474       38904    19526976   83  Linux
>>
>> [root@localhost ~]# mkfs.btrfs -m raid1 /dev/sdb8 /dev/sdb9 /dev/sdb10 /dev/sdb11
>> adding device /dev/sdb9 id 2
>> adding device /dev/sdb10 id 3
>> adding device /dev/sdb11 id 4
>> fs created label (null) on /dev/sdb8
>>       nodesize 4096 leafsize 4096 sectorsize 4096 size 74.50GB
>> Btrfs v0.16-29-g0d53b21
>>
>> [root@localhost ~]# mount -t btrfs /dev/sdb8 /mnt/btrfs[root@localhost ~]# df
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> ...
>> /dev/sdb8             78123968        28  78123940   1% /mnt/btrfs
>>
>
> More test:
>
> [root@localhost btrfs]# df -h /dev/sdb8
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb8              75G   28K   75G   1% /mnt/btrfs
> [root@localhost btrfs]# dd if=/dev/zero of=/mnt/btrfs/file bs=1024 count=1024
> 1024+0 records in
> 1024+0 records out
> 1048576 bytes (1.0 MB) copied, 0.0481317 s, 21.8 MB/s
> [root@localhost btrfs]# sync
> [root@localhost btrfs]# df -h /dev/sdb8
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb8              75G  1.1M   75G   1% /mnt/btrfs
>
> With raid-1, the used space may be double (about 2.2M), I think.
>
>
>
>> I think the partition size is no correct since this is a raid-1 partition.
>> The size should be half.
>> Is this a bug?
>>
>> -Shen
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
> --
> Best Regards,
> --------------------------------------------------
> Shen Feng
> Development Dept.I
> Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
> 8/F., Civil Defense Building, No.189 Guangzhou Road,
> Nanjing, 210029, China
> PHONE: +86-25-86630566-950
> COINS: 79955-950
> FAX: +86-25-83317685
> MAIL: shen@cn.fujitsu.com
> -------------------------------------------------
> This communication is for use by the intended recipient(s) only and may contain information that is privileged, confidential and exempt from disclosure under applicable law. If you are not an intended recipient of this communication, you are hereby notified that any dissemination, distribution or copying hereof is strictly prohibited.  If you have received this communication in error, please notify me by reply e-mail, permanently delete this communication from your system, and destroy any hard copies you may have printed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks & Best Regards
Liu Hui
--
