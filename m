Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37619 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933105AbdBPUjS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 15:39:18 -0500
Received: by mail-it0-f52.google.com with SMTP id x75so39268687itb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Feb 2017 12:39:18 -0800 (PST)
Subject: Re: Way to force allocation of more metadata?
To: E V <eliventer@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAJtFHUTK-0m08usaak+_AVLntZnFZUswi5tq=vkiSVpacKW47A@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <793505a0-4041-b277-2e24-bff79bcd629e@gmail.com>
Date: Thu, 16 Feb 2017 15:39:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAJtFHUTK-0m08usaak+_AVLntZnFZUswi5tq=vkiSVpacKW47A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-16 15:13, E V wrote:
> It would be nice if there was an easy way to tell btrfs to allocate
> another metadata chunk. For example, the below fs is full due to
> exhausted metadata:
>
>     Device size:                1013.28GiB
>     Device allocated:           1013.28GiB
>     Device unallocated:            2.00MiB
>     Device missing:                  0.00B
>     Used:                        981.94GiB
>     Free (estimated):             15.16GiB      (min: 15.16GiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              510.31MiB      (used: 0.00B)
>
>              Data      Metadata  System
> Id Path      RAID1     RAID1     RAID1    Unallocated
> -- --------- --------- --------- -------- -----------
>  1 /dev/sdv1 505.63GiB   1.00GiB  8.00MiB     1.00MiB
>  2 /dev/sdw1 505.63GiB   1.00GiB  8.00MiB     1.00MiB
> -- --------- --------- --------- -------- -----------
>    Total     505.63GiB   1.00GiB  8.00MiB     2.00MiB
>    Used      490.47GiB 510.88MiB 96.00KiB
>
> I can delete a multi GB file and get several GB of unallocated space,
> however if I try and copy big files to it again the same exact thing
> happens. However, if I play with balance and deleting files and such
> and manage to get it to allocate another metadata chunk while there is
> unallocated space then the filesystem will happily fill up all of the
> data chunks. Failing an automatic allocation out of global reserve, or
> saving metadata as soon as unallocated space is available it would be
> nice if I could just delete a file and then tell btrfs to allocate
> more metadata immediately. Makes sense? No idea how easy this would be
> to do, but seems like it should be a simple thing btrfs file could do.
The potentially tricky bit about this is that BTRFS (at least, with 
recent kernels) will deallocate completely empty chunks.  The horribly 
ironic part of this is that that behavior got added to help avoid 
situations like this.  There is technically logic to allocate extra 
metadata chunks for every few data chunks that get allocated (and I 
think the reverse too), but because of the auto-deallocation behavior, 
this ends up just spinning and wasting cycles (and bandwidth).  I would 
personally love to see the following happen in regard to this all:
1. Add a switch to disable the auto-deallocation (ideally a mount 
option).  This bit _should_ be pretty easy, but I'm not certain.
2. Disable the auto-allocation of chunks of type X every N chunks of 
type Y that get allocated when the auto-deallocation is enabled.  This 
one should in theory be pretty easy too.
3. Add a tool (not sure where exactly makes the most sense) to force 
allocation of a specific chunk type.  This would also be insanely useful 
for debugging, but is probably the hardest part (would likely need a new 
ioctl).
4. Possibly add an option to reserve some percentage of the space to 
only be used for System and Metadata chunks.  This would help prevent 
this kind of thing from happening.  I'm not entirely sold on this right 
now, but it _seems_ like a generically good idea.

Sadly, I don't currently have the time to work on any of that myself, 
and there are other things that are higher priorities, so I don't know 
when (if ever) this may actually happen.  I might have some time to look 
into the first two things I listed some time soon, but I don't know how 
soon that might be.
