Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0065.outbound.protection.outlook.com ([104.47.42.65]:54624
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1423849AbeBOQpv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 11:45:51 -0500
Subject: Re: Status of FST and mount times
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <CAJCQCtQn-rOA7MPP-613mEKvnfJW+0US9ZJ8eCNxkOYZbtQFsw@mail.gmail.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <c9f84d14-7e9c-c5c6-bf40-dbd17f747f9e@panasas.com>
Date: Thu, 15 Feb 2018 11:45:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQn-rOA7MPP-613mEKvnfJW+0US9ZJ8eCNxkOYZbtQFsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/15/2018 01:14 AM, Chris Murphy wrote:
> On Wed, Feb 14, 2018 at 9:00 AM, Ellis H. Wilson III <ellisw@panasas.com> wrote:
> 
>> Frame-of-reference here: RAID0.  Around 70TB raw capacity.  No compression.
>> No quotas enabled.  Many (potentially tens to hundreds) of subvolumes, each
>> with tens of snapshots.
> 
> Even if non-catastrophic to lose such a file system, it's big enough
> to be tedious and take time to set it up again. I think it's worth
> considering one of two things as alternatives:
> 
> a. metadata raid1, data single: you lose the striping performance of
> raid0, and if it's not randomly filled you'll end up with some disk
> contention for reads and writes *but* if you lose a drive you will not
> lose the file system. Any missing files on the dead drive will result
> in EIO (and I think also a kernel message with path to file), and so
> you could just run a script to delete those files and replace them
> with backup copies.

This option is on our roadmap for future releases of our parallel file 
system, but unfortunately we do not presently have the time to implement 
the functionality to report from the manager of that btrfs filesystem to 
the pfs manager that said files have gone missing.  We will absolutely 
be revisiting that as an option in early 2019, as replacing just one 
disk instead of N is highly attractive.  Waiting for EIO as you suggest 
in b is a non-starter for us, as we're working at scales sufficiently 
large that we don't want to wait for someone to stumble over a partially 
degraded file.  Pro-active reporting is what's needed, and we'll 
implement that Real Soon Now.

> b. Variation on the above would be to put it behind glusterfs
> replicated volume. Gluster getting EIO from a brick should cause it to
> get a copy from another brick and then fix up the bad one
> automatically. Or in your raid0 case, the whole volume is lost, and
> glusterfs helps do the full rebuild over 3-7 days while you're still
> able to access those 70TB of data normally. Of course, this option
> requires having two 70TB storage bricks available.

See my email address, which may help understand why GlusterFS is a 
non-starter.  Nevertheless, the idea is a fine one and we'll have 
something similar going on, but at higher raid levels and across 
typically a dozen or more of such bricks.

Best,

ellis
