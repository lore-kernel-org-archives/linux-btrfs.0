Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from astarte.centershock.net ([5.45.98.111]:48263 "EHLO
        astarte.centershock.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbcLFOOQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Dec 2016 09:14:16 -0500
Received: from [129.69.213.139] (lapsgs09.informatik.uni-stuttgart.de [129.69.213.139])
        by astarte.centershock.net (Postfix) with ESMTPSA id 0D4C9FFC1E
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Dec 2016 15:14:11 +0100 (CET)
From: Florian Lindner <mailinglists@xgm.de>
Subject: Re: Convert from RAID 5 to 10
To: linux-btrfs@vger.kernel.org
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
Message-ID: <5b691533-0f23-f702-0b6e-3ec918122b78@xgm.de>
Date: Tue, 6 Dec 2016 15:14:12 +0100
MIME-Version: 1.0
In-Reply-To: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot to all who replied! I learned a lot from this thread.

However, what I learned has made me even more doubtful that a btrfs RAID is the right choice for me at this moment.
There seems to be much uncertainty about the real state (experimental, stable, production-ready, mature, ...) of btrfs'
raid implementation, even on this very well informed lists.

I really want to have the checksumming and auto-repair feature of btrfs. That was the original reason why I did't go
with a dmraid in the first place. So there are basically two options left, btrfs, with a raid 10 or zfs with some raid
10 or 5 equivalent.

zfs seems to be nice, mature solution, but I also prefer to use something native to Linux.

Best Regards,
Florian


Am 29.11.2016 um 18:20 schrieb Florian Lindner:
> Hello,
> 
> I have 4 harddisks with 3TB capacity each. They are all used in a btrfs RAID 5. It has come to my attention, that there
> seem to be major flaws in btrfs' raid 5 implementation. Because of that, I want to convert the the raid 5 to a raid 10
> and I have several questions.
> 
> * Is that possible as an online conversion?
> 
> * Since my effective capacity will shrink during conversions, does btrfs check if there is enough free capacity to
> convert? As you see below, right now it's probably too full, but I'm going to delete some stuff.
> 
> * I understand the command to convert is
> 
> btrfs balance start -dconvert=raid10 -mconvert=raid10 /mnt
> 
> Correct?
> 
> * What disks are allowed to fail? My understanding of a raid 10 is like that
> 
> disks = {a, b, c, d}
> 
> raid0( raid1(a, b), raid1(c, d) )
> 
> This way (a XOR b) AND (c XOR d) are allowed to fail without the raid to fail (either a or b and c or d are allowed to fail)
> 
> How is that with a btrfs raid 10?
> 
> * Any other advice? ;-)
> 
> Thanks a lot,
> 
> Florian
> 
> 
> Some information of my filesystem:
> 
> # btrfs filesystem show /
> Label: 'data'  uuid: 57e5b9e9-01ae-4f9e-8a3d-9f42204d7005
>         Total devices 4 FS bytes used 7.57TiB
>         devid    1 size 2.72TiB used 2.72TiB path /dev/sda4
>         devid    2 size 2.72TiB used 2.72TiB path /dev/sdb4
>         devid    3 size 2.72TiB used 2.72TiB path /dev/sdc4
>         devid    4 size 2.72TiB used 2.72TiB path /dev/sdd4
> 
> # btrfs filesystem df /
> Data, RAID5: total=8.14TiB, used=7.56TiB
> System, RAID5: total=96.00MiB, used=592.00KiB
> Metadata, RAID5: total=12.84GiB, used=11.06GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> 
> /dev/sda4        11T  7.6T  597G  93% /
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


