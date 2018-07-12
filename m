Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbeGLHTW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 03:19:22 -0400
Subject: Re: Transaction aborted (error -28)
 btrfs_run_delayed_refs*0x163/0x190
To: Peter Chant <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
 <44fabb78-f0ec-d79c-be20-8689bd00d2cd@suse.com>
 <881e443e-60fe-9615-dd8e-7f935761d3af@petezilla.co.uk>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1ef30bf4-091d-cc4f-c081-9db262ebc7a8@suse.com>
Date: Thu, 12 Jul 2018 10:11:04 +0300
MIME-Version: 1.0
In-Reply-To: <881e443e-60fe-9615-dd8e-7f935761d3af@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.07.2018 10:04, Peter Chant wrote:
> On 07/12/2018 07:10 AM, Nikolay Borisov wrote:
>>
>>
>> On 10.07.2018 10:04, Pete wrote:
>>> I've just had the error in the subject which caused the file system to
>>> go read-only.
>>>
>>> Further part of error message:
>>> WARNING: CPU: 14 PID: 1351 at fs/btrfs/extent-tree.c:3076
>>> btrfs_run_delayed_refs*0x163/0x190
>>>
>>> 'Screenshot' here:
>>> https://drive.google.com/file/d/1qw7TE1bec8BKcmffrOmg2LS15IOq8Jwc/view?usp=sharing
>>>
>>> The kernel is 4.17.4.  There are three hard drives in the file system.
>>> dmcrypt (luks) is used between btrfs and the disks.
>>>
>>> I'm about to run a scrub.  On reboot the disks mounted fine.
>>
>> Show the output of :
>>
>> btrfs fi usage /path/to/fs
>>
> 
> On the hdd system, which recently went ro again:
> root@phoenix:~# btrfs fi usage /home_data/
> Overall:
>     Device size:                   9.10TiB
>     Device allocated:              6.38TiB
>     Device unallocated:            2.71TiB
>     Device missing:                  0.00B
>     Used:                          5.50TiB
>     Free (estimated):              1.80TiB      (min: 1.80TiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)>
> Data,RAID1: Size:3.15TiB, Used:2.71TiB
>    /dev/mapper/data_disk_1         1.80TiB
>    /dev/mapper/data_disk_2         1.80TiB
>    /dev/mapper/data_disk_3         2.70TiB
> 
> Metadata,RAID1: Size:42.00GiB, Used:40.56GiB
>    /dev/mapper/data_disk_1        25.00GiB
>    /dev/mapper/data_disk_2        26.00GiB
>    /dev/mapper/data_disk_3        33.00GiB
> 
> System,RAID1: Size:64.00MiB, Used:480.00KiB
>    /dev/mapper/data_disk_1        64.00MiB
>    /dev/mapper/data_disk_2        32.00MiB
>    /dev/mapper/data_disk_3        32.00MiB
> 
> Unallocated:
>    /dev/mapper/data_disk_1       926.46GiB
>    /dev/mapper/data_disk_2       925.49GiB
>    /dev/mapper/data_disk_3       924.99GiB
> 
> root@phoenix:~#


This one shouldn't have gone RO since it has plenty of unallocated and
free space. What was the workload at the time it went RO? Hard to say,
it's best if you can provide output with the debug patch applied when
this issue re-appears.

> 
> 
> Incidental I've been running out of space on my ssd which contains / and
> /home - which I am sorting.
> 
> root@phoenix:~# btrfs fi usage /
> 
> Overall:
> 
>     Device size:                 350.00GiB
> 
>     Device allocated:            350.00GiB
> 
>     Device unallocated:            1.00MiB
> 
>     Device missing:                  0.00B
> 
>     Used:                        324.74GiB
> 
>     Free (estimated):             23.28GiB      (min: 23.28GiB)
> 
>     Data ratio:                       1.00
> 
>     Metadata ratio:                   1.00
> 
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
SO this doesn't look healthy, essentially you don't have any unallocated
space on your device. I will suggest you run balance to try and compact
the space in your data groups and hopefully free up some space. As a
first step you can try and run :

btrfs balance start -dusage=0 -musage=0 /

This will try and reclaim any non-used block groups i.e it could bring
some unallocated space back. Then you can run 'btrfs fi us / ' to see if
this is the case. Then I'd suggest you run something like:

'btrfs balance start -dusage=60 -musage=60 /' this will try and compact
all data/metadata chunks which are less than 60% full.

> 
> 
> Data,single: Size:343.00GiB, Used:319.72GiB
> 
>    /dev/disk/by-label/desk-system        343.00GiB
> 
> Metadata,single: Size:6.97GiB, Used:5.02GiB
>    /dev/disk/by-label/desk-system          6.97GiB
> 
> System,single: Size:32.00MiB, Used:64.00KiB
>    /dev/disk/by-label/desk-system         32.00MiB
> 
> Unallocated:
>    /dev/disk/by-label/desk-system          1.00MiB
> root@phoenix:~#
> 
> Pete
> 
> 
> 
> 
