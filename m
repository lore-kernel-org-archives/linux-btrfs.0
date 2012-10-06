Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46834 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab2JFNra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2012 09:47:30 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1377675bkc.19
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Oct 2012 06:47:28 -0700 (PDT)
Message-ID: <50703676.20608@gmail.com>
Date: Sat, 06 Oct 2012 15:47:34 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?UTF-8?B?U8OpYmFzdGllbiBNYXVyeQ==?= <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V3] btrfs filesystem df
References: <1349371679-10775-1-git-send-email-kreijack@inwind.com> (sfid-20121004_215416_819357_23AF71B8) <201210061157.03992.Martin@lichtvoll.de>
In-Reply-To: <201210061157.03992.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/06/2012 11:57 AM, Martin Steigerwald wrote:
> Am Donnerstag, 4. Oktober 2012 schrieb Goffredo Baroncelli:
>> Hi Chris,
>>
>
>
> Works nicely here:
>
> merkaba:/home/[…]>  ./btrfs fi df /
> Path: /
> Summary:
>    Disk_size:                 18.62GB
>    Disk_allocated:            18.62GB
>    Disk_unallocated:             0.00
>    Logical_size:              16.87GB
>    Used:                      12.46GB
>    Free_(Estimated):           4.41GB    (Max: 4.41GB, Min: 4.41GB)
>    Data_to_disk_ratio:           91 %
>
> Details:
>    Chunk_type  Mode     Size_(disk) Size_(logical)     Used
>    Data        Single       15.10GB     15.10GB     11.78GB
>    System      DUP          16.00MB      8.00MB      4.00KB
>    System      Single        4.00MB      4.00MB        0.00
>    Metadata    DUP           3.50GB      1.75GB    693.97MB
>    Metadata    Single        8.00MB      8.00MB        0.00
>
>
> merkaba:/home/[…]>  ./btrfs fi df /mnt/amazon
> Path: /mnt/amazon
> Summary:
>    Disk_size:                465.76GB
>    Disk_allocated:           465.76GB
>    Disk_unallocated:           4.00KB
>    Logical_size:             455.75GB
>    Used:                     368.83GB
>    Free_(Estimated):          86.93GB    (Max: 86.93GB, Min: 86.93GB)
>    Data_to_disk_ratio:           98 %
>
> Details:
>    Chunk_type  Mode     Size_(disk) Size_(logical)     Used
>    Data        Single      445.73GB    445.73GB    368.24GB
>    System      DUP          16.00MB      8.00MB     64.00KB
>    System      Single        4.00MB      4.00MB        0.00
>    Metadata    DUP          20.00GB     10.00GB    598.84MB
>    Metadata    Single        8.00MB      8.00MB        0.00
>
>
> I wonder about free size estimation minimum and maximum are the same tough.
>
> Do you have a explaination for this?

Yes, the explanation is quite simple: the unallocated sector are zero; 
all the disks are mapped in the chunk. So the allocation policy is 
stabilised and fixed. The free space is the sum of the free space of the 
metadata and the free space of the data (445.73-368.24 + 10-0.598 = ~86GB).
If some disk areas had un-allocated sectors, depending by the 
destination them would be DUPlicated or Single. This lead to have not 
*one* "free value" but a range.
In your case there is no choice because there is no allocation area 
available anymore.


>
> Otherwise:
>
> Tested-By: Martin Steigerwald<martin@lichtvoll.de>
>
> (as of commit c3f7fa95f3aa29972b79eed71ec063b6a3019017 from your repo.)
>
>
> The data to disk ratio on bigger disk is lower due to less duplicated meta
> data involved, I bet. I want to recreate / anyway with 16 KiB leaf and node
> size and then I think I will use single for metadata as its an SSD. The
> bigger one is external eSATA harddisk.
>
>
> I can test and post outputs of a few other disks including my oldest BTRFS
> filesystems on a ThinkPad T23 which are at least one, possible almost 2
> years old. Is there are way to tell filesystem creation date? And a 2 TiB
> backup disk with three or for subvolumes and>10 snapshots of all of them
> together.
>
>> Where:
>>          Disk_size                       ->  sum of sizes of teh disks
>>          Disk_allocated                  ->  sum of chunk sizes
>>          Disk_unallocated                ->  Disk_size - Disk_allocated
>>          Logical_size                    ->  sum of logical area sizes
>>          Used                            ->  logical area used
>>          Free_(Estimated)                ->  on the basis of allocated
>>                                             chunk, an estrapolation of
>>                                             the free space
>>          Data_to_disk_ratio              ->  ration between the space occuped
>>                                             by a chunk and the real space
>>                                             available ( due to duplication
>>                                             and/or RAID level)
>>          Chunk_type                      ->  kind of chunk
>>          Mode                            ->  allocation policy of a chunk
>>          Size_(disk)                     ->  area of disk(s) occuped by the
>>                                             chunk (see it as raw space used)
>>          Size_(logical)                  ->  logical area size of the chunk
>>          Used                            ->  portion of the logical area
>>                                             used by the filesystem
> […]

