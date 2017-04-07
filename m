Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35404 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934412AbdDGQ6X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 12:58:23 -0400
Received: by mail-it0-f48.google.com with SMTP id y18so122956228itc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 09:58:22 -0700 (PDT)
Subject: Re: Volume appears full but TB's of space available
To: Chris Murphy <lists@colorremedies.com>,
        John Petrini <jpetrini@coredial.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
 <CAD4AmV7-tFesnWbYR=geRVcFedgb4zcfKeVXuEVNnNtJN0qg1w@mail.gmail.com>
 <56b58b49-a4ab-56f9-25e5-94d64699da83@gmail.com>
 <CAJCQCtQqomcKRn-J8bJchVng=D4od346p18CKvjYp86zKSZysA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <12332db1-c52a-f483-e2e7-e23e508e6066@gmail.com>
Date: Fri, 7 Apr 2017 12:58:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQqomcKRn-J8bJchVng=D4od346p18CKvjYp86zKSZysA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-07 12:28, Chris Murphy wrote:
> On Fri, Apr 7, 2017 at 7:50 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> If you care about both performance and data safety, I would suggest using
>> BTRFS raid1 mode on top of LVM or MD RAID0 together with having good backups
>> and good monitoring.  Statistically speaking, catastrophic hardware failures
>> are rare, and you'll usually have more than enough warning that a device is
>> failing before it actually does, so provided you keep on top of monitoring
>> and replace disks that are showing signs of impending failure as soon as
>> possible, you will be no worse off in terms of data integrity than running
>> ext4 or XFS on top of a LVM or MD RAID10 volume.
>
>
> Depending on the workload, and what replication is being used by Ceph
> above this storage stack, it might make make more sense to do
> something like three lvm/md raid5 arrays, and then Btrfs single data,
> raid1 metadata, across those three raid5s. That's giving up only three
> drives to parity rather than 1/2 the drives, and rebuild time is
> shorter than losing one drive in a raid0 array.
Ah, I had forgotten it was a Ceph back-end system.  In that case, I 
would actually suggest essentially the same setup that Chris did, 
although I would personally be a bit more conservative and use RAID6 
instead of RAID5 for the LVM/MD arrays.  As he said though, it really 
depends on what higher-level replication you're doing.  In particular, 
if you're running erasure coding instead of replication at the Ceph 
level, I would probably still go with BTRFS raid1 on top of LVM/MD RAID0 
just to balance out the performance hit from the erasure coding.
