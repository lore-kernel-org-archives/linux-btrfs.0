Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35451 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2JNQLi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Oct 2012 12:11:38 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2602195eek.19
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2012 09:11:37 -0700 (PDT)
Message-ID: <507AE44E.4040008@gmail.com>
Date: Sun, 14 Oct 2012 18:11:58 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Tommy Pettersson <ptp@lysator.liu.se>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs suddenly lost all om my huge free space
References: <20121014001912.GA1247@fruity>
In-Reply-To: <20121014001912.GA1247@fruity>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

did you used the latest kernel version ?
The other thing that you could try is a scrub looking for a defective 
page.. but I don't think so....

BR
G.Baroncelli



On 2012-10-14 02:19, Tommy Pettersson wrote:
> Hi,
>
> (I'm not subscribed to the list, so please CC me.)
>
> I have a btrfs with raid1 on two identical unpartitioned disks.
> Today I noticed that df (normal df) said I am 77 % full. This
> was a chock, because since forever it has been around 12 %.
>
>
> # btrfs fi show
> Label: 'green'  uuid: dd83031c-2447-4736-a8f6-9bd9cdeea879
>          Total devices 2 FS bytes used 212.88GB
>          devid    2 size 1.82TB used 356.04GB path /dev/sdb
>          devid    1 size 1.82TB used 356.06GB path /dev/sda
>
> # btrfs fi df /
> Data, RAID1: total=276.00GB, used=209.02GB
> Data: total=8.00M, used=0.00
> System, RAID1: total=40.00MB, used=64.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=80.00GB, used=3.88GB
> Metadata: total=8.00MB, used=0.00
>
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> rootfs          3.7T  426G   134G  77% /
>
>
> The thing that has drastically changed is Avail in the output
> from df.
>
> I tried a btrfs balance, which self-aborted after some hours
> with No space left on device. I deleted two snapshots, so I got
> some free space and could use the system again.
>
> The balance, although it didn't finish, seems to have reduced
> the used space, but it also reduced the "available" space:
>
>
> # btrfs fi show
> Label: 'green'  uuid: dd83031c-2447-4736-a8f6-9bd9cdeea879
>          Total devices 2 FS bytes used 212.88GB
>          devid    2 size 1.82TB used 356.04GB path /dev/sdb
>          devid    1 size 1.82TB used 215.01GB path /dev/sda
>
> # btrfs fi df /
> Data, RAID1: total=210.00GB, used=197.97GB
> System, RAID1: total=8.00MB, used=44.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=5.00GB, used=3.41GB
>
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> rootfs          3.7T  403G   25G  95% /
>
>
> I made an unqualified guess that the space cache was corrupted,
> and tried to mount with option clear_cache and nospace_cache.
> Both of them caused btrfs to scan my disks for a couple of
> minutes at boot, but the amount of available space did not
> improve.
>
> What can I do to help locate the cause of this problem?
>
>
> Regards,
> Tommy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

