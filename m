Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f49.google.com ([209.85.167.49]:40384 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbeIOHKE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Sep 2018 03:10:04 -0400
Received: by mail-lf1-f49.google.com with SMTP id x26-v6so9345351lfi.7
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 18:52:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 14 Sep 2018 19:52:57 -0600
Message-ID: <CAJCQCtSsf_JSuqQUfnme-5V1rRXHhWGJ0usj+oKu+-uU4E3uaA@mail.gmail.com>
Subject: Re: state of btrfs snapshot limitations?
To: "James A. Robinson" <jim.robinson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2018 at 3:05 PM, James A. Robinson
<jim.robinson@gmail.com> wrote:

> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
>
> talks about the basic snapshot capabilities of btrfs and led
> me to look up what, if any, limits might apply.  I find some
> threads from a few years ago that talk about limiting the
> number of snapshots for a volume to 100.

It does seem variable and I'm not certain what the pattern is that
triggers pathological behavior. There's a container thread about a
year ago with someone using docker on Btrfs with more than 100K
containers, per day, but I don't know the turn over rate. That person
does say it's deletion that's expensive but not intolerably so.

My advice is you come up with as many strategies as you can implement.
Because if one strategy starts to implode with terrible performance,
you can just bail on it (or try fixing it, or submitting bug reports
to make Btrfs better down the road, etc.), and yet you still have one
or more other strategies that are still viable.

By strategy, you might want to implement both your ideal and
conservative approaches, and also something in the middle. Also, it's
reasonable to mirror those strategies on a different storage stack,
e.g. LVM thin volumes and XFS. LVM thin volumes are semi-cheap to
create, and semi-cheap to delete; where Btrfs snapshots are almost
free to create, and expensive to delete (varies depending on changes
in it or the subvolume it's created from). But if the LVM thin pool's
metadata pool runs out of space, it's big trouble. I expect to lose
all the LV's if that ever happens. Also, this strategy doesn't have
send/receive, so ordinary use of rsync is expensive since it reads and
compares both source and destination. The first answer for this
question contains a possible work around depending on hard links.

https://serverfault.com/questions/489289/handling-renamed-files-or-directories-in-rsync


With Btrfs big issues for scalability are the extent tree, which is
shared among all snapshots and subvolumes. Therefore, the bigger the
file system gets, in effect the more fragile the extent tree becomes.
The other thing is btrfs check is super slow with large volumes, some
people have dozen or more TiB file systems that take days to check.

I also agree with the noatime suggestion from Hans. Note this is a per
subvolume mount time option, so if you're using the subvol= or
subvolid= mount options, you need to noatime every time, once per file
system isn't enough.



-- 
Chris Murphy
