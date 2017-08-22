Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:33083 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdHVFxa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 01:53:30 -0400
Received: by mail-ua0-f180.google.com with SMTP id q40so14636347uag.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 22:53:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAANLjFo714ED=kMHZh0fTWc2WhQwkyZ4a7SZtThm9xwPghn1_Q@mail.gmail.com>
References: <CAANLjFo714ED=kMHZh0fTWc2WhQwkyZ4a7SZtThm9xwPghn1_Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 21 Aug 2017 23:53:29 -0600
Message-ID: <CAJCQCtQaPJ+BcNW0tq6ttC1=q1xV85qFnwdx_SWzt6rs1swZkg@mail.gmail.com>
Subject: Re: Btrfs Raid5 issue.
To: Robert LeBlanc <robert@leblancnet.us>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 11:19 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> Chris and Qu thanks for your help. I was able to restore the data off
> the volume. I only could not read one file that I tried to rsync (a
> MySQl bin log), but it wasn't critical as I had an off-site snapshot
> from that morning and ownclould could resync the files that were
> changed anyway. This turned out much better than the md RAID failure
> that I had a year ago. Much faster recovery thanks to snapshots.
>
> Is there anything you would like from this damaged filesystem to help
> determine what went wrong and to help make btrfs better? If I don't
> hear back from you in a day, I'll destroy it so that I can add the
> disks into the new btrfs volumes to restore redundancy.
>
> Bcache wasn't providing the performance I was hoping for, so I'm
> putting the root and roots for my LXC containers on the SSDs (btrfs
> RAID1) and the bulk stuff on the three spindle drives (btrfs RAID1).
> For some reason, it seemed that the btrfs RAID5 setup required one of
> the drives, but I thought I had data with RAID5 and metadata with 2
> copies. Was I missing something else that prevented mounting with that
> specific drive? I don't want to get into a situation where one drive
> dies and I can't get to any data.

With all three connected, what do you get for 'btrfs fi show' ?

The first email says the supers on all three drives are OK, but still
it's confusing the degraded is working. It suggests it's not finding
something on one of the drives that it needs to mount - usually that's
the first superblock or it could be the system block group is partly
corrupt or read error or something; and when degraded it makes it
possible to mount.

Anyway at least all of the data is safe now. Pretty much all you can
do to guard against data loss is backups. Any degraded state is
precarious because it requires just one more thing to go wrong and
it's all bad news from there.

Gluster is pretty easy to setup, and use either gluster native mount
on linux or smb with everything else. Stick a big drive in a raspberry
pi (or two) and even though it's only fast ethernet (haha, now slow
100bps ethernet) it will still replicate automatically as well as
failover. Plus one of those could be XFS if you wanted to hedge your
bets. Or one of the less expensive Intel NUCs will also work if you
want to stick with x86.



-- 
Chris Murphy
