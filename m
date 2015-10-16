Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s8.hotmail.com ([65.55.116.19]:64662 "EHLO
	BLU004-OMC1S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbbJPPUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 11:20:33 -0400
Message-ID: <BLU436-SMTP232EC8D0E09909CF6CD682FA93D0@phx.gbl>
MIME-Version: 1.0
In-Reply-To: <zarafa.5620d341.12f4.4502d22b70e60c50@mascot.commandict.com.au>
References: <zarafa.5620d341.12f4.4502d22b70e60c50@mascot.commandict.com.au>
Date: Fri, 16 Oct 2015 17:20:28 +0200
Subject: Re: btrfs replace status >100%
From: Henk Slager <hslager@hotmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Brett,

As far as I can see, the replace will finish successfully, but the
numbers are quite confusing. Maybe the percentage at the end (after
more than half a day or so) gives a hint how the calculation is done,
I currently can't see it.

RAID1 and RAID10 have confusing output for commands   'btrfs
filesystem usage'  and  especially for   'btrfs device usage' . At
least for the latter, unallocated size was 2x too high I once saw/see,
but I have not analysed it in detail. I had once a RAID5 fs and there
I replaced devices via a   add   and then a  remove  . A replace was
considered too risky, also RAID5 size calculation was not supported at
that time. With a   btrfs fi us  I could see that things were going in
the right direction, with a lot of patience (a week or so).

With RAID10, I did a  native replace and mostly looked at  iostat
and/or ksysguard  and it went at expected speed (top media
transferrates). The replace status output was correctly from 0-100% in
my case, but it was same size replace. I did shrink the source first
to max device size minus 2048 sectors and then did replace from a
devid to a '/dev/sdX1'.
In your case, a 'max' the size of the 8T disk after succesful replace
is needed, otherwise 3T wont be used.

/Henk

On Fri, Oct 16, 2015 at 12:36 PM, Brett King
<brett.king@commandict.com.au> wrote:
> Hi All,
> I am noticing some strange numbers when replacing a disk under RAID1:
>
> [root@array ~]# btrfs replace status -1 /export/archive/
> 367.2% done, 0 write errs, 0 uncorr. read errs
>
> The filesystem is currently at 6x 6TB + 2x 5TB, replacing the first of each 5TB with 8TB units:
>
> [root@array ~]# btrfs fi df /export/archive/
> Data, RAID1: total=20.90TiB, used=20.62TiB
> System, RAID1: total=8.00MiB, used=2.91MiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=23.00GiB, used=22.13GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
> [root@array ~]# btrfs fi sh /export/archive/
> Label: 'archive'  uuid: 1b1f6bbb-0865-4752-bdaf-07ba30acb27e
>         Total devices 9 FS bytes used 20.64TiB
>         devid    0 size 4.55TiB used 4.55TiB path /dev/sdj
>         devid    1 size 5.46TiB used 5.46TiB path /dev/sdc
>         devid    2 size 5.46TiB used 5.46TiB path /dev/sdi
>         devid    3 size 5.46TiB used 5.46TiB path /dev/sdg
>         devid    4 size 5.46TiB used 5.46TiB path /dev/sdf
>         devid    5 size 4.55TiB used 4.55TiB path /dev/sdh
>         devid    6 size 4.55TiB used 4.55TiB path /dev/sdb
>         devid    7 size 5.46TiB used 5.46TiB path /dev/sde
>         devid    8 size 5.46TiB used 5.46TiB path /dev/sdd
>
> btrfs-progs v4.2.1
> [root@array ~]# btrfs device usage /export/archive/
> /dev/sdb, ID: 6
>    Device size:             4.55TiB
>    Data,RAID1:              4.55TiB
>    Metadata,RAID1:          1.00GiB
>    Unallocated:             1.02MiB
>
> /dev/sdc, ID: 1
>    Device size:             5.46TiB
>    Data,RAID1:              5.45TiB
>    Metadata,single:         8.00MiB
>    Metadata,RAID1:         10.00GiB
>    System,single:           4.00MiB
>    Unallocated:             5.02MiB
>
> /dev/sdd, ID: 8
>    Device size:             5.46TiB
>    Data,RAID1:              5.46TiB
>    Metadata,RAID1:          1.00GiB
>    Unallocated:             1.02MiB
>
> /dev/sde, ID: 7
>    Device size:             5.46TiB
>    Data,RAID1:              5.46TiB
>    Unallocated:             1.02MiB
>
> /dev/sdf, ID: 4
>    Device size:             5.46TiB
>    Data,RAID1:              5.45TiB
>    Metadata,RAID1:         11.00GiB
>    System,RAID1:            8.00MiB
>    Unallocated:             1.02MiB
>
> /dev/sdg, ID: 3
>    Device size:             5.46TiB
>    Data,RAID1:              5.45TiB
>    Metadata,RAID1:         11.00GiB
>    System,RAID1:            8.00MiB
>    Unallocated:             1.02MiB
>
> /dev/sdh, ID: 5
>    Device size:             4.55TiB
>    Data,RAID1:              4.55TiB
>    Metadata,RAID1:          1.00GiB
>    Unallocated:             1.02MiB
>
> /dev/sdi, ID: 2
>    Device size:             5.46TiB
>    Data,RAID1:              5.45TiB
>    Metadata,RAID1:         11.00GiB
>    Unallocated:             1.02MiB
>
> /dev/sdj, ID: 0
>    Device size:             7.28TiB
>    Unallocated:             4.55TiB
>
> [root@array ~]# uname -r
> 4.1.10-200.fc22.x86_64
>
> Is this a problem ? And is there another way to see moved / total blocks from the running replace job ?
>
> Thanks,
> Brett.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
