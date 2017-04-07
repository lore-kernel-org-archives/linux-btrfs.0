Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:34808 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934207AbdDGQ2l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 12:28:41 -0400
Received: by mail-yw0-f170.google.com with SMTP id p77so36818721ywg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 09:28:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56b58b49-a4ab-56f9-25e5-94d64699da83@gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com> <CAD4AmV7-tFesnWbYR=geRVcFedgb4zcfKeVXuEVNnNtJN0qg1w@mail.gmail.com>
 <56b58b49-a4ab-56f9-25e5-94d64699da83@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 7 Apr 2017 10:28:40 -0600
Message-ID: <CAJCQCtQqomcKRn-J8bJchVng=D4od346p18CKvjYp86zKSZysA@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: John Petrini <jpetrini@coredial.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 7, 2017 at 7:50 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> If you care about both performance and data safety, I would suggest using
> BTRFS raid1 mode on top of LVM or MD RAID0 together with having good backups
> and good monitoring.  Statistically speaking, catastrophic hardware failures
> are rare, and you'll usually have more than enough warning that a device is
> failing before it actually does, so provided you keep on top of monitoring
> and replace disks that are showing signs of impending failure as soon as
> possible, you will be no worse off in terms of data integrity than running
> ext4 or XFS on top of a LVM or MD RAID10 volume.


Depending on the workload, and what replication is being used by Ceph
above this storage stack, it might make make more sense to do
something like three lvm/md raid5 arrays, and then Btrfs single data,
raid1 metadata, across those three raid5s. That's giving up only three
drives to parity rather than 1/2 the drives, and rebuild time is
shorter than losing one drive in a raid0 array.

If this is one ceph host, then it might make sense to split the drives
up so there are two storage bricks using ceph replication between them
for the equivalent of raid1. One brick can do Btrfs on LVM/md raid5,
call it brick A. The other brick can do XFS on LVM/md linear, call it
brick B. The advantage there is the different bricks are going to have
faster commit to stable media times with a mixed workload. The Btrfs
on raid5 brick will do better with sequential reads and writes. The
XFS on linear will do better with metadata heavy reads and writes.
There's probably some Ceph tuning where you can point certain
workloads to particular volumes, where those volumes are backed by
different priorities to the underlying storage. So you'd setup ceph
volume "mail" to be backed in order by brick B then A.

Not very well known but XFS will parallelize across drives in a
linear/concat arrangement, it's quite useful for e.g. busy mail
servers.


-- 
Chris Murphy
