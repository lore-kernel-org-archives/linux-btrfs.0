Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59396 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab2I1TiI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 15:38:08 -0400
Received: by bkcjk13 with SMTP id jk13so3847593bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 12:38:07 -0700 (PDT)
Message-ID: <5065FCB0.1010003@gmail.com>
Date: Fri, 28 Sep 2012 21:38:24 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr> <5064B96B.7060502@libero.it> <5064BEEB.1090707@libero.it> <20120928091759.6d096016@natsu> <5065D3D7.8080101@inwind.it> <20120929000223.4827d375@natsu>
In-Reply-To: <20120929000223.4827d375@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2012 08:02 PM, Roman Mamedov wrote:
> On Fri, 28 Sep 2012 18:44:07 +0200
> Goffredo Baroncelli<kreijack@inwind.it>  wrote:
>
>> This means that the ration of space physically allocated on the disk and
>> the space available is 7GB/10GB = 0.7 . So on 135GB of disk, only 94GB
>> are available.
>
> You assume metadata allocation will always grow linearly with data, which is
> not true. So in my opinion it is not a good estimate.

I am open to accept suggestion on how improve the algorithm. Today we 
have only ... nothing. If I elaborate the output of btrfs fi show I can 
estimate the best-case (i.e. the data have no further redundancy); my 
algorithm is a bit smarter. However I repeat: please suggest us a better 
algorithm.

Regarding the assumption about the ratio data/metadata is constant, yes 
I assumed that. Why this should change ? Of course could change, but 
which would be a better estimation ?

My algorithm is not perfect, but better than nothing.


>
>>> Are you ready to answer the flood of questions from people why their disk is
>>> only 62% efficient, and how to tune it to 100%? :-)
>>
>> I don't understand your question
>
> You mentioned that the aim was to make the output more friendly, i.e. to make
> it less confusing. But I find this percentage and the way it is labeled likely
> to achieve the opposite effect, causing a lot of new questions on what does
> this mean (while the percentage reported is likely not even being correct),
> how to improve it, etc.

These questions already are there, because the free space estimation in 
BTRFS is
a) very complex
b) "btrfs fi df" and "btrfs fi show" don't help to measure ( nor 
estimate) the space available.

>
>> Because on BTRFS the metadata are a lot
>
> Keep in mind that there is also inlining; so even if the space is allocated
> for metadata, it will be used to store small files. So it might be not
> completely fair to count the metadata allocated space as unusable space.

I never told that the metadata space is unusable space. Is true the 
opposite: I don't differentiate data/metadata/system.... I only consider 
the RAID/DUP/Single in terms of disk-space/available-space.

>
>>> Why use underscores instead of spaces?
>>
>> Simplify the parsing in scripts
>
> I think it looks awkward and is not warranted since this is a primarily
> user-facing utility. Also none of the other similar tools shy from having
> spaces anywhere they need to, e.g.

We could improve on this side. However these utilities are often used in 
scripts

>
> # mdadm --detail /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Wed May 25 00:07:38 2011
>       Raid Level : raid5
>       Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
>    Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
>     Raid Devices : 5
>    Total Devices : 5
>      Persistence : Superblock is persistent
>
>    Intent Bitmap : Internal
>
>      Update Time : Fri Sep 28 21:20:51 2012
>            State : active
>   Active Devices : 5
> Working Devices : 5
>   Failed Devices : 0
>    Spare Devices : 0
>
>           Layout : left-symmetric
>       Chunk Size : 64K
>
>             Name : avdeb:0  (local to host avdeb)
>             UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
>           Events : 14254
>
>      Number   Major   Minor   RaidDevice State
>         7       8       17        0      active sync   /dev/sdb1
>         6       8       33        1      active sync   /dev/sdc1
>         3       8       65        2      active sync   /dev/sde1
>         4       8       49        3      active sync   /dev/sdd1
>         5       8       81        4      active sync   /dev/sdf1
>
> # lvdisplay
>    --- Logical volume ---
>    LV Path                /dev/alpha/lv1
>    LV Name                lv1
>    VG Name                alpha
>    LV UUID                HP19fU-oMhM-sdqN-yFWa-N3Rs-ktBw-21GSD2
>    LV Write Access        read/write
>    LV Creation host, time ,
>    LV Status              available
>    # open                 0
>    LV Size                3.52 TiB
>    Current LE             115431
>    Segments               3
>    Allocation             inherit
>    Read ahead sectors     auto
>    - currently set to     4096
>    Block device           252:0
>

