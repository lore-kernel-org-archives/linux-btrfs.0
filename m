Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:34569 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbdFSPXu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 11:23:50 -0400
Received: by mail-qt0-f175.google.com with SMTP id c10so113040566qtd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 08:23:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170615084604.2794d8b0@jupiter.sol.kaishome.de>
References: <CAPmG0jb=tokuCxBe6U3Rg+36X-70ptC2bhWx23e38ZxUjTgM4A@mail.gmail.com>
 <20170613072420.17314dbb@jupiter.sol.kaishome.de> <CAPmG0jbVju+S=jqmk+qr8L4MMe-5NirFVV8R7VQeczGjE=6Waw@mail.gmail.com>
 <CAPmG0jaVbfoL8-PpDT-=B+w_JH9H4ukJQm5UUkZFRKS6uSAs+Q@mail.gmail.com> <20170615084604.2794d8b0@jupiter.sol.kaishome.de>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 19 Jun 2017 17:23:33 +0200
Message-ID: <CAPmG0jZygkb+=Ke4i6OG_b64C8mB8M4CbxQKHRenpsyAtNhhqA@mail.gmail.com>
Subject: Re: csum failed root -9
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I think I leave it as is for the time being, unless there is some news
>> how to fix things with low risk (or maybe via a temp overlay snapshot
>> with DM). But the lowmem check took 2 days, that's not really fun.
>> The goal for the 8TB fs is to have an up to 7 year snapshot history at
>> sometime, now the oldest snapshot is from early 2014, so almost
>> halfway :)
>
> Btrfs is still much too unstable to trust 7 years worth of backup to
> it. You will probably loose it at some point, especially while many
> snapshots are still such a huge performance breaker in btrfs. I suggest
> trying out also other alternatives like borg backup for such a project.

Maybe I should clarify that I don't use snapshotting for archiving
explicitly. So in the latest snapshot still old but unused files from
many years back are there, like a disk image from a windowsxp laptop
(already recycled) for example. Userdata that is in older snapshots
but not in newer ones is what I consider useless data today, so I had
deleted that explicitly. But who knows maybe for some statistic or
whatever btrfs experiment it might be interesting to have a long and
may snapshot increments.

Another reason is the SMR characteristics of the disk, that made me
decide to designate this fs write-only. If I remove snapshots, the fs
gets free space fragmentation and then writing to it will be much
slower. This disk was relatively cheap and I don't want to experience
the slowness and longer on time.

I snapshot no more than 3 subvolumes monthly, then after 7 years the
fs has 252 snapshots, that is considered no problem for btrfs.
I think borg backup is interesting, but from kernel 3.11 to 4.11 (even
using raid5 up to 4.1) I have managed to keep it running/cloning
multi-site with just a few relatively simple scripts and btrfs
kernel+tools itself, also working on a low-power ARM platform. I don't
like yet another commandset and that borg uses its own extra repo or
small database for tracking diffs (I haven't used it so I am not
sure). But what I need, differential/incremental + compression, is
just build-in in btrfs, that I anyhow use for local snapshotting. I
finally put also some ARM boards btrfs rootfs recently, I am not sure
if/when I am going to use other backup tooling besides just rsync and
btrfs features.
