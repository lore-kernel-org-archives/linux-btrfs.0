Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36152 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858AbaLHCjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 21:39:52 -0500
Message-ID: <54851033.7010601@cn.fujitsu.com>
Date: Mon, 8 Dec 2014 10:42:59 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <ashford@whisperpc.com>, <kreijack@inwind.it>
CC: Shriramana Sharma <samjnaa@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>    <44320137.fRRuR6EFMP@merkaba> <5484A83A.5090109@inwind.it>    <6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>    <5484DC3C.7040409@inwind.it> <73b1fa42cc61f5a843206a8164952f74.squirrel@webmail.wanet.net>
In-Reply-To: <73b1fa42cc61f5a843206a8164952f74.squirrel@webmail.wanet.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: <ashford@whisperpc.com>
To: <kreijack@inwind.it>
Date: 2014年12月08日 08:12
> Goffredo,
>
>> So in case you have a raid1 filesystem on two disks; each disk has 300GB
>> free; which is the free space that you expected: 300GB or 600GB and why ?
> You should see 300GB free.  That's what you'll see with RAID-1 with a
> hardware RAID controller, and with MD RAID.  Why would you expect to see
> anything else with BTRFS RAID?
>
> Peter Ashford
Yeah, you pointed out the real problem here:

[DIFFERENT RESULT FROM DIFFERENT VIEW]
See from *PURE ON-DISK* usage, it is still 600G, no matter what level of 
RAID.
See from *BLOCK LEVEL RAID1* usage, it is 300G. If fs(not btrfs) is 
build on BLOCK LEVEL RAID1,
then the *FILESYSTEM* usage will also be 300G

[BTRFS DOES NOT BELONG TO ANY TYPE]
But, btrfs is neither pure block level management(that should be MD or 
HW RAID or LVM), nor a
traditional filesystem!!

So the root of the problem is, btrfs mixs the position of block level 
management and filesystem level
management, which makes everything hard to understand.
You can't treat btrfs raid1 as a complete block level raid1, due to its 
flexibility on metadata/data profile different.

If vanilla df command shows filesystem level freespace, then btrfs won't 
give a accurate on.

[ONLY PREDICABLE CASE]
For the 300Gx2 case for btrfs, you can only consider it 300G free space 
only if you can ensure that
there was/is and will be only RAID1 data/metadata storing on it.(also 
need to ignore small space usage on CoW)

[RELIABLE DATA IS ON-DISK USAGE]
Only pure on-disk level usage is *a little* reliable. There is still 
problem for unbalanced metadata/data chunk
allocation problem(e.g, all space is allocated for data, no space for 
metadata CoW write).

[FEATURE SIMILAR CASE]
The only case that I may see similar problem will be mirrored thin 
lv(not implemented yet)
and normal thin lv competing for a thin pool.

Although not implemented, I think even implemented, admins may not 
complain so much since LVM doesn't
report free space, only used space on thin pool case.

Thanks,
Qu

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

