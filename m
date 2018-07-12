Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-3.server.virginmedia.net ([80.0.253.67]:36641
        "EHLO know-smtprelay-omc-3.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbeGLSRv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 14:17:51 -0400
Subject: Re: Transaction aborted (error -28)
 btrfs_run_delayed_refs*0x163/0x190
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
 <44fabb78-f0ec-d79c-be20-8689bd00d2cd@suse.com>
 <881e443e-60fe-9615-dd8e-7f935761d3af@petezilla.co.uk>
 <1ef30bf4-091d-cc4f-c081-9db262ebc7a8@suse.com>
From: Pete <pete@petezilla.co.uk>
Message-ID: <b89a3cdc-aaad-a927-1967-d4c32ad66b08@petezilla.co.uk>
Date: Thu, 12 Jul 2018 19:07:09 +0100
MIME-Version: 1.0
In-Reply-To: <1ef30bf4-091d-cc4f-c081-9db262ebc7a8@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/12/2018 08:11 AM, Nikolay Borisov wrote:
> 
> 
> This one shouldn't have gone RO since it has plenty of unallocated and
> free space. What was the workload at the time it went RO? Hard to say,
> it's best if you can provide output with the debug patch applied when
> this issue re-appears.
> 

I'll respond in a separate email to list, as the above is the more
important issue and I need to trawl the logs.

>>
>>
>> Incidental I've been running out of space on my ssd which contains / and
>> /home - which I am sorting.
>>
>> root@phoenix:~# btrfs fi usage /
>>
>> Overall:
>>
>>     Device size:                 350.00GiB
>>
>>     Device allocated:            350.00GiB
>>
>>     Device unallocated:            1.00MiB
>>
>>     Device missing:                  0.00B
>>
>>     Used:                        324.74GiB
>>
>>     Free (estimated):             23.28GiB      (min: 23.28GiB)
>>
>>     Data ratio:                       1.00
>>
>>     Metadata ratio:                   1.00
>>
>>     Global reserve:              512.00MiB      (used: 0.00B)
>>
> SO this doesn't look healthy, essentially you don't have any unallocated
> space on your device. I will suggest you run balance to try and compact
> the space in your data groups and hopefully free up some space. As a
> first step you can try and run :
> 
> btrfs balance start -dusage=0 -musage=0 /
> 
> This will try and reclaim any non-used block groups i.e it could bring
> some unallocated space back. Then you can run 'btrfs fi us / ' to see if
> this is the case. Then I'd suggest you run something like:
> 
> 'btrfs balance start -dusage=60 -musage=60 /' this will try and compact
> all data/metadata chunks which are less than 60% full.

Thank you, appreciated.  I have run the above and listed the usage.

root@phoenix:~# btrfs balance start -dusage=0 -musage=0 /
Done, had to relocate 0 out of 351 chunks
root@phoenix:~# btrfs fi usage /
Overall:

    Device size:                 350.00GiB

    Device allocated:            349.03GiB

    Device unallocated:          992.00MiB

    Device missing:                  0.00B

    Used:                        324.77GiB
    Free (estimated):             24.22GiB      (min: 24.22GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:343.00GiB, Used:319.75GiB
   /dev/disk/by-label/desk-system        343.00GiB

Metadata,single: Size:6.00GiB, Used:5.02GiB
   /dev/disk/by-label/desk-system          6.00GiB

System,single: Size:32.00MiB, Used:64.00KiB
   /dev/disk/by-label/desk-system         32.00MiB

Unallocated:
   /dev/disk/by-label/desk-system        992.00MiB
root@phoenix:~#


root@phoenix:~# btrfs balance start -dusage=60 -musage=60 /
Done, had to relocate 15 out of 351 chunks
root@phoenix:~# btrfs fi us /
Overall:
    Device size:                 350.00GiB
    Device allocated:            335.06GiB
    Device unallocated:           14.94GiB
    Device missing:                  0.00B
    Used:                        324.77GiB
    Free (estimated):             24.22GiB      (min: 24.22GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:329.03GiB, Used:319.75GiB
   /dev/disk/by-label/desk-system        329.03GiB

Metadata,single: Size:6.00GiB, Used:5.02GiB
   /dev/disk/by-label/desk-system          6.00GiB

System,single: Size:32.00MiB, Used:64.00KiB
   /dev/disk/by-label/desk-system         32.00MiB

Unallocated:
   /dev/disk/by-label/desk-system         14.94GiB
root@phoenix:~#

I believe this is simply coincidental to the error I was getting.  I've
got to do some housekeeping.  I think running out of disk space is a
combination of having root on the disk, installing another distro in
another subvolume, having losts of old kernels and modules around and
snapshotting directores that are likely churning files (.mozilla?).




