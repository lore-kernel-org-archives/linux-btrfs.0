Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:40508 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbeAUVy1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 16:54:27 -0500
Received: by mail-ot0-f175.google.com with SMTP id x4so5908684otg.7
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jan 2018 13:54:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7ebd40d4-3eea-9ad7-492f-b5d22cf935b0@gmail.com>
References: <7ebd40d4-3eea-9ad7-492f-b5d22cf935b0@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 21 Jan 2018 14:54:26 -0700
Message-ID: <CAJCQCtSRj1v-qksod3FetjVCutSL1MbLWdg1KSt1RsndJkTU=A@mail.gmail.com>
Subject: Re: Can't mount (even in ro) after power outage - corrupt leaf,
 open_ctree failed
To: msk conf <msk.conf@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 21, 2018 at 8:53 AM, msk conf <msk.conf@gmail.com> wrote:
> Hello there,
>
> I would like to ask you for help with (corrupted) btrfs on my nas.
>
> After power outage I can't mount it back at all:
> UUID="e8cb7e76-7f93-4eac-aec7-ca64395d2110"    /array  btrfs
> noatime,compress=lzo    0       2
> UUID="e8cb7e76-7f93-4eac-aec7-ca64395d2110"    /home   btrfs
> noatime,compress=lzo,subvolid=3315      0       0

What do you get for
btrfs fi df /array

I want to know if all block groups are raid1.


>
> I tried combination of recovery,ro,degraded,usebackuproot, specifying
> partial partitions where fs is placed to - no success at all.
> for example
> mount -ousebackuproot,ro
> /dev/disk/by-uuid/e8cb7e76-7f93-4eac-aec7-ca64395d2110 /mnt/restore
> mount -ousebackuproot,ro,degraded /dev/sdb4 /mnt/restore
> ...
>
> Failing with:
> [ 2765.719548] BTRFS critical (device sda4): corrupt leaf, slot offset bad:
> block=3997250650112, root=1, slot=48
> [ 2765.731772] BTRFS error (device sda4): failed to read block groups: -5
> [ 2765.781993] BTRFS error (device sda4): open_ctree failed

I don't know that "degraded" will know which device to ignore when
both devices are available. But then, if everything is raid1, a
failure on sda4 should result in a retry on sdb4. There's not enough
information in the log provided. Sounds like a bad sector resulting in
an IO error.


>
> Some informations at beginning:
>
> uname -a
> Linux nas 4.9.0-4-amd64 #1 SMP Debian 4.9.65-3 (2017-12-03) x86_64 GNU/Linux
>
> btrfs --version
> btrfs-progs v4.7.3

I wouldn't use btrfs check, let alone using it with --repair, with
this version. Get something newer, ideally 4.14.1.

The thing to include in the next report is output from:

btrfs check

btrfs check --mode=lowmem

I don't recommend using --repair until you've exhausted all other
options, including any scraping necessary with btrfs restore to get
your backups up to date.

-- 
Chris Murphy
