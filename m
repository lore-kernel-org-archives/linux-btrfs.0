Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:53259 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbdKNUwT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 15:52:19 -0500
Received: by mail-wm0-f51.google.com with SMTP id g141so24605737wmg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 12:52:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114135040.65a659c0@natsu>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <20171101101510.218eeead@natsu> <CAH=dxU56geiO7MuWSbPgpfBQ3vbkPYm6juQZzu3-1=-RzG+ZSQ@mail.gmail.com>
 <20171114135040.65a659c0@natsu>
From: Dave <davestechshop@gmail.com>
Date: Tue, 14 Nov 2017 15:51:57 -0500
Message-ID: <CAH=dxU7wjag+BPNdu__WidU1qNPeF7Sxgc8YthAVvxbrHx5VmA@mail.gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Roman Mamedov <rm@romanrm.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 14, 2017 at 3:50 AM, Roman Mamedov <rm@romanrm.net> wrote:
>
> On Mon, 13 Nov 2017 22:39:44 -0500
> Dave <davestechshop@gmail.com> wrote:
>
> > I have my live system on one block device and a backup snapshot of it
> > on another block device. I am keeping them in sync with hourly rsync
> > transfers.
> >
> > Here's how this system works in a little more detail:
> >
> > 1. I establish the baseline by sending a full snapshot to the backup
> > block device using btrfs send-receive.
> > 2. Next, on the backup device I immediately create a rw copy of that
> > baseline snapshot.
> > 3. I delete the source snapshot to keep the live filesystem free of
> > all snapshots (so it can be optimally defragmented, etc.)
> > 4. hourly, I take a snapshot of the live system, rsync all changes to
> > the backup block device, and then delete the source snapshot. This
> > hourly process takes less than a minute currently. (My test system has
> > only moderate usage.)
> > 5. hourly, following the above step, I use snapper to take a snapshot
> > of the backup subvolume to create/preserve a history of changes. For
> > example, I can find the version of a file 30 hours prior.
>
> Sounds a bit complex, I still don't get why you need all these snapshot
> creations and deletions, and even still using btrfs send-receive.


Hopefully, my comments below will explain my reasons.

>
> Here is my scheme:
> ============================================================================
> /mnt/dst <- mounted backup storage volume
> /mnt/dst/backup  <- a subvolume
> /mnt/dst/backup/host1/ <- rsync destination for host1, regular directory
> /mnt/dst/backup/host2/ <- rsync destination for host2, regular directory
> /mnt/dst/backup/host3/ <- rsync destination for host3, regular directory
> etc.
>
> /mnt/dst/backup/host1/bin/
> /mnt/dst/backup/host1/etc/
> /mnt/dst/backup/host1/home/
> ...
> Self explanatory. All regular directories, not subvolumes.
>
> Snapshots:
> /mnt/dst/snaps/backup <- a regular directory
> /mnt/dst/snaps/backup/2017-11-14T12:00/ <- snapshot 1 of /mnt/dst/backup
> /mnt/dst/snaps/backup/2017-11-14T13:00/ <- snapshot 2 of /mnt/dst/backup
> /mnt/dst/snaps/backup/2017-11-14T14:00/ <- snapshot 3 of /mnt/dst/backup
>
> Accessing historic data:
> /mnt/dst/snaps/backup/2017-11-14T12:00/host1/bin/bash
> ...
> /bin/bash for host1 as of 2017-11-14 12:00 (time on the backup system).
> ============================================================================
>
> No need for btrfs send-receive, only plain rsync is used, directly from
> hostX:/ to /mnt/dst/backup/host1/;


I prefer to start with a BTRFS snapshot at the backup destination. I
think that's the most "accurate" starting point.

>
> No need to create or delete snapshots during the actual backup process;


Then you can't guarantee consistency of the backed up information.

>
> A single common timeline is kept for all hosts to be backed up, snapshot count
> not multiplied by the number of hosts (in my case the backup location is
> multi-purpose, so I somewhat care about total number of snapshots there as
> well);
>
> Also, all of this works even with source hosts which do not use Btrfs.


That's not a concern for me because I prefer to use BTRFS everywhere.
