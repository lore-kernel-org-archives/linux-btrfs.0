Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:35573 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbeBOGOb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 01:14:31 -0500
Received: by mail-ot0-f173.google.com with SMTP id a2so22513582otf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 22:14:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 14 Feb 2018 23:14:30 -0700
Message-ID: <CAJCQCtQn-rOA7MPP-613mEKvnfJW+0US9ZJ8eCNxkOYZbtQFsw@mail.gmail.com>
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 14, 2018 at 9:00 AM, Ellis H. Wilson III <ellisw@panasas.com> wrote:

> Frame-of-reference here: RAID0.  Around 70TB raw capacity.  No compression.
> No quotas enabled.  Many (potentially tens to hundreds) of subvolumes, each
> with tens of snapshots.

Even if non-catastrophic to lose such a file system, it's big enough
to be tedious and take time to set it up again. I think it's worth
considering one of two things as alternatives:

a. metadata raid1, data single: you lose the striping performance of
raid0, and if it's not randomly filled you'll end up with some disk
contention for reads and writes *but* if you lose a drive you will not
lose the file system. Any missing files on the dead drive will result
in EIO (and I think also a kernel message with path to file), and so
you could just run a script to delete those files and replace them
with backup copies.

b. Variation on the above would be to put it behind glusterfs
replicated volume. Gluster getting EIO from a brick should cause it to
get a copy from another brick and then fix up the bad one
automatically. Or in your raid0 case, the whole volume is lost, and
glusterfs helps do the full rebuild over 3-7 days while you're still
able to access those 70TB of data normally. Of course, this option
requires having two 70TB storage bricks available.


-- 
Chris Murphy
