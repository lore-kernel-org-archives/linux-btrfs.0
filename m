Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33648 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933161AbdDGNuV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 09:50:21 -0400
Received: by mail-io0-f172.google.com with SMTP id t68so16087905iof.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 06:50:21 -0700 (PDT)
Subject: Re: Volume appears full but TB's of space available
To: John Petrini <jpetrini@coredial.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
 <CAD4AmV7-tFesnWbYR=geRVcFedgb4zcfKeVXuEVNnNtJN0qg1w@mail.gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56b58b49-a4ab-56f9-25e5-94d64699da83@gmail.com>
Date: Fri, 7 Apr 2017 09:50:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAD4AmV7-tFesnWbYR=geRVcFedgb4zcfKeVXuEVNnNtJN0qg1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-07 09:28, John Petrini wrote:
> Hi Austin,
>
> Thanks for taking to time to provide all of this great information!
Glad I could help.
>
> You've got me curious about RAID1. If I were to convert the array to
> RAID1 could it then sustain a multi drive failure? Or in other words
> do I actually end up with mirrored pairs or can a chunk still be
> mirrored to any disk in the array? Are there performance implications
> to using RAID1 vs RAID10?
>
For raid10, your data is stored as 2 replicas striped at or below the 
filesystem-block level across all the disks in the array.  Because of 
how the data striping is done currently, you're functionally guaranteed 
to lose data if you lose more than one disk in raid10 mode.  This 
theoretically could be improved so that partial losses could be 
recovered, but doing so with the current implementation would be 
extremely complicated, and as such is not a high priority (although 
patches would almost certainly be welcome).

For raid1, your data is stored as 2 replicas with each entirely on one 
disk, but individual chunks (the higher level allocation in BTRFS) are 
distributed in a round-robin fashion among the disks, so any given 
filesystem block is on exactly 2 disks.  With the current 
implementation, for any reasonably utilized filesystem, you will lose 
data if you lose 2 or more disks in raid1 mode.  That said, there are 
plans (still currently vaporware in favor of getting raid5/6 working) to 
add arbitrary replication levels to BTRFS, so once that hits, you could 
set things to have as many replicas as you want.

In effect, both can currently only sustain one disk failure, but losing 
2 disks in raid10 will probably corrupt files (currently, it will 
functionally kill the FS, although with a bit of theoretically simple 
work this could be changed), while losing 2 disks in raid1 mode will 
usually just make files disappear unless they are larger than the data 
chunk size (usually between 1-5GB depending on the size of the FS), so 
if you're just storing small files, you'll have an easier time 
quantifying data loss with raid1 than raid10.  Both modes have the 
possibility of completely losing the FS if the lost disks happen to take 
out the System chunk.

As for performance, raid10 mode in BTRFS gets better performance, but 
you can get even better performance than that by running BTRFS in raid1 
mode on top of 2 LVM or MD raid0 volumes.  Such a configuration provides 
the same effective data safety as BTRFS raid10, but can get anywhere 
from 5-30% better performance depending on the workload.

If you care about both performance and data safety, I would suggest 
using BTRFS raid1 mode on top of LVM or MD RAID0 together with having 
good backups and good monitoring.  Statistically speaking, catastrophic 
hardware failures are rare, and you'll usually have more than enough 
warning that a device is failing before it actually does, so provided 
you keep on top of monitoring and replace disks that are showing signs 
of impending failure as soon as possible, you will be no worse off in 
terms of data integrity than running ext4 or XFS on top of a LVM or MD 
RAID10 volume.
