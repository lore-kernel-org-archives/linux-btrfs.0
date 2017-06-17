Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50951 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752804AbdFQOLi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Jun 2017 10:11:38 -0400
Subject: Re: Disk usage is more than double the snapshots exclusive data
To: vianney@stroebel.fr, linux-btrfs@vger.kernel.org
References: <53ff5efd-74de-2ea5-fd1a-12ca35c550f3@stroebel.fr>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <08d83e41-dfdf-4901-8257-0701c970ced3@gmx.com>
Date: Sat, 17 Jun 2017 22:11:30 +0800
MIME-Version: 1.0
In-Reply-To: <53ff5efd-74de-2ea5-fd1a-12ca35c550f3@stroebel.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年06月15日 17:44, Vianney Stroebel wrote:
> On a backup drive for a home computer, disk usage as shown by 'btrfs fi 
> show' is more than double the snapshots exclusive data as shown by 
> "btrfs qgroup show" (574 GB vs 265 GB). >
> I've done a lot of research online and I couldn't find any answer to 
> this problem.

If btrfs check reports no qgroup related error, then it's related to how 
we calculate the "exclusive" number.

For qgroup, we're accounting extent if it is shared between different 
subvolumes/snapshots.

If one extent is shared between 2 subvolumes/snapshots, then it's 
accounted as "shared" and will not affect "exclusive" number.

In the following case, you can't add up all the "exclusive" number to 
calculate the total used space:

Subvol A:  Total: 2M Exclusive 0
Subvol B:  Total: 2M Exclusive 0
Subvol C:  Total: 4M Exclusive 2M

B and C are all snapshots created from A, while we write nothing to B, 
but write 2M exclusive data to C.
(Normally, there is should be at least nodesize "exclusive", but in this 
case I just skip such details)

The real data used on disk should be 2M (C) + 2M (shared among A, B, C) 
= 4M.

And it can be even more complicated with the following case:
Subvol A: Total: 2M Exclusive 0
Subvol B: Total: 2M Exclusive 0
Subvol C: Total: 2M Exclusive 2M.

B is snapshot created from A, without any new data.
And subvol C is a independent subvolume.
The real data used on disk is still 2M + 2M = 4M, but you can have 
totally different qgroup numbers for that.

So in your case, you must know how the "shared" number is and how they 
are shared between different subvolumes, which is almost impossible in 
practice.

To make it simple, you can't really calculate the real "used" space just 
by qgroup numbers.
And that's not designed for that use case.

Thanks,
Qu

> 
> Output of some commands:
> 
> uname -a
> Linux viybel-pc 4.10.0-22-generic #24-Ubuntu SMP Mon May 22 17:43:20 UTC 
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> btrfs --version
> btrfs-progs v4.9.1
> 
> sudo btrfs fi show
> Label: 'btrfs-backup'  uuid: 35905dc5-1400-4687-8be7-cf87d6ad0980
>      Total devices 1 FS bytes used 573.89GiB
>      devid    1 size 698.64GiB used 697.04GiB path /dev/sdb1
> 
> btrfs fi df /mnt/btrfs-backup
> Data, single: total=670.01GiB, used=564.26GiB
> System, DUP: total=8.00MiB, used=112.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=13.50GiB, used=8.64GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=14.95MiB
> 
>  From https://github.com/agronick/btrfs-size (i.e. more readable "btrfs 
> qgroup show")
> 
> btrfs-size /mnt/btrfs-backup
> ================================================================================================================================== 
> 
> Snapshot / Subvolume                                               ID   
> Total   Exclusive Data
> ================================================================================================================================== 
> 
> 10726 gen 216807 top level 5 path full/2016-06-19_12-32-01         10726 
> 208.68GB 208.68GB
> 21512 gen 216853 top level 5 path full/2016-12-14_16-21-34         21512 
> 166.98GB 40.36GB
> 23054 gen 216853 top level 5 path full/2017-03-03_08-47-00         23054 
> 154.79GB 7.53GB
> 25451 gen 216856 top level 5 path full/2017-04-14_21-54-25         25451 
> 123.48GB 3.07GB
> 26514 gen 216862 top level 5 path full/2017-05-02_14-58-09         26514 
> 123.70GB 5.03GB
> 28499 gen 218095 top level 5 path full/2017-06-11_19-29-16         28499 
> 154.65GB 169.78MB
> 28556 gen 218094 top level 5 path full/2017-06-13_03-15-00         28556 
> 154.88GB 403.89MB
> ================================================================================================================================== 
> 
>                                                                  
> Exclusive Total: 265.23GB
> 
> Feel free to ask me any question.
> 
> Vianney
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
