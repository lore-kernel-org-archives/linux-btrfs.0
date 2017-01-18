Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:34159 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdARQFc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 11:05:32 -0500
Received: by mail-it0-f46.google.com with SMTP id k200so19695784itb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 08:05:32 -0800 (PST)
Subject: Re: Cannot mount vol after balance crash
To: Steven Hum <sdothum@gmail.com>, linux-btrfs@vger.kernel.org
References: <148474927391.4887.7184132005402873700@luna>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ed3c476f-09a9-52e3-a7cc-00a5b929d4fe@gmail.com>
Date: Wed, 18 Jan 2017 10:56:54 -0500
MIME-Version: 1.0
In-Reply-To: <148474927391.4887.7184132005402873700@luna>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-18 09:21, Steven Hum wrote:
>
> Added 2 drives to my RAID10, then ran btrfs balance. The system appears
> to have crashed after several hours (I was ssh'd in at the time on my
> local network). When I reboot the Arch system, I ran btrfs check and no
> errors were reported.
>
> However, attempting to mount the vol hangs the system. Trying to mount
> the system in recovery mode also hangs the system.
>
>     ─────  uname -a                                                                                                                             ~
> Linux luna 4.8.13-1-ARCH #1 SMP PREEMPT Fri Dec 9 07:24:34 CET 2016 x86_64 GNU/Linux
>     ─────     btrfs --version                                                                                                                   ~
> btrfs-progs v4.9
>     ─────     btrfs fi show                                                                                                                     ~
> Label: 'Archlinux'  uuid: e5ee12ac-7fb3-4e73-b9b2-a5cfb35145ae
>         Total devices 1 FS bytes used 66.41GiB
>         devid    1 size 111.24GiB used 111.24GiB path /dev/sda2
>
> Label: 'Share'  uuid: 9102bb33-49ad-4baf-a88d-1c7622bff938
>         Total devices 6 FS bytes used 4.20TiB
>         devid    1 size 2.73TiB used 1.90TiB path /dev/sdc
>         devid    2 size 2.73TiB used 1.90TiB path /dev/sdd
>         devid    3 size 2.73TiB used 1.90TiB path /dev/sde
>         devid    4 size 2.73TiB used 1.90TiB path /dev/sdb
>         devid    5 size 2.73TiB used 440.34GiB path /dev/sdf
>         devid    6 size 2.73TiB used 440.34GiB path /dev/sdg
>
>     ─────     btrfs fi df /home # Replace /home with the mount point of your btrfs-filesystem                                                   ~
> Data, single: total=109.22GiB, used=64.92GiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=2.02GiB, used=1.48GiB
> GlobalReserve, single: total=179.64MiB, used=0.00B
>
> The dmesg log when attempting to mount the vol can be found at url
>
> http://cwillu.com:8080/108.63.177.210/1
>
> Any ideas what can be done to be able to mount the volume and complete
> the balancing?
Based on the dmesg, something is screwed up either with your filesystem, 
your hardware, or your kernel.  Based on past experience, I'm inclined 
to blame things in that order when BTRFS is involved.  Other than the 
OOPS (which probably was the ultimate cause of the other BUG splats), I 
don't really see anything particularly worrying in the log (the only 
significant errors I saw were ACPI related, but I see errors like those 
on lots of systems with no ill effects).  The first thing I'd suggest 
trying is mounting with 'skip_balance' in the mount options.  This will 
prevent BTRFS from trying to start the balance operation again, and if 
it's the balance itself that's choking, should make the filesystem 
mountable (as long as you mount read-write, you only need this option 
once, but I would generally suggest just having it as the default for 
exactly the type of situation you've run into).  If that works, and you 
get another crash when trying to balance again, then it's probably a 
filesystem issue or kernel bug, unless you are seeing other odd storage 
related issues, in which case it's probably a hardware problem.  If the 
new balance doesn't crash, then it was probably a hardware error (most 
likely transient).
>
> NOTE: the wiki link for mailing list subscribe instructions links to
> a page indicating web subscriptions are no longer handled with no
> instructions how do subscribe manually -- presumably by sending
> a subscribe email request. Would appreciate a reply or cc to this email
> (and instructions how to subscribe to the mailing list).
Subscriptions are handled just like LKML.  Click the subscribe link 
here: http://vger.kernel.org/vger-lists.html#linux-btrfs and it should 
open your e-mail client with the message pre-loaded and ready to send. 
If things go well, you'll get a message back to confirm the subscription 
with instructions in it on how to do so.
