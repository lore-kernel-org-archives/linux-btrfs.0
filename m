Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33385 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbcJAT5R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Oct 2016 15:57:17 -0400
Received: by mail-oi0-f68.google.com with SMTP id w11so9252150oia.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Oct 2016 12:57:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOf5Se5C+6Y+=uz=Lkv-wrPhHZOMD94hzrtLHwDR3D78UHiSSQ@mail.gmail.com>
References: <CAOf5Se5C+6Y+=uz=Lkv-wrPhHZOMD94hzrtLHwDR3D78UHiSSQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 1 Oct 2016 13:57:15 -0600
Message-ID: <CAJCQCtRw4oeTddQCTWGNjnLa07-71PmbHqa3hdbdLkGsP8smdQ@mail.gmail.com>
Subject: Re: Resize a btrfs File System : no enough free space... why ?!?
To: Nicolas Pujol <nicolas.pujol@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 1, 2016 at 2:42 AM, Nicolas Pujol <nicolas.pujol@gmail.com> wrote:

> Unfortunately, I want to change the RAID chunk size because it is only
> 4K so I have to update the size of BTRFS before. Now, array size is
> 5860537608 so I want to reduce to 5860537344k :
> $ btrfs filesystem resize 1:5860537344k /mnt/RAID
> Resize '/mnt/RAID' of '1:5860537344k'
> ERROR: unable to resize '/mnt/RAID': no enough free space

Try
btrfs fi resize -1m /mnt/RAID

If that fails also try something bigger maybe -100m

If that fails also...

# btrfs fi df /mnt/RAID
Data, single: total=3.48TiB, used=3.46TiB
System, DUP: total=8.00MiB, used=416.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=69.62GiB, used=5.86GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B


Maybe try to get rid of these unused single block groups for system
and metadata:

btrfs balance start -mconvert=dup,soft

And try resize again. If it still doesn't work:

btrfs balance start -musage=25

You've got 70GiB worth of allocation for metadata, but only 6GiB is
being used, so maybe get rid of that unused portion with a partial
balance. Then try again.

I'd do only one change at a time, and see at which point it
(hopefully) works. Because none of these things should be needed, but
then if they are, the error message needs to be cleared up. So I'm
kinda setting you up to collect enough information to file a bug.




-- 
Chris Murphy
