Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:52706 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdKNDkG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 22:40:06 -0500
Received: by mail-wm0-f48.google.com with SMTP id t139so19150449wmt.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 19:40:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171101101510.218eeead@natsu>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <20171101101510.218eeead@natsu>
From: Dave <davestechshop@gmail.com>
Date: Mon, 13 Nov 2017 22:39:44 -0500
Message-ID: <CAH=dxU56geiO7MuWSbPgpfBQ3vbkPYm6juQZzu3-1=-RzG+ZSQ@mail.gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 1, 2017 at 1:15 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Wed, 1 Nov 2017 01:00:08 -0400
> Dave <davestechshop@gmail.com> wrote:
>
>> To reconcile those conflicting goals, the only idea I have come up
>> with so far is to use btrfs send-receive to perform incremental
>> backups as described here:
>> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup .
>
> Another option is to just use the regular rsync to a designated destination
> subvolume on the backup host, AND snapshot that subvolume on that host from
> time to time (or on backup completions, if you can synchronize that).
>
> rsync --inplace will keep space usage low as it will not reupload entire files
> in case of changes/additions to them.
>
> Yes rsync has to traverse both directory trees to find changes, but that's
> pretty fast (couple of minutes at most, for a typical root filesystem),
> especially if you use SSD or SSD caching.

Hello. I am implementing this suggestion. So far, so good. However, I
need some further recommendations on rsync options to use for this
purpose.

My rsync command currently looks like this:

rsync -axAHv --inplace --delete-delay --exclude-from="/some/file"
"$source_snapshop/" "$backup_location"

In particular, I want to know if I should or should not be using these options:

        -H, --hard-links            preserve hard links
        -A, --acls                  preserve ACLs (implies -p)
        -X, --xattrs                preserve extended attributes
        -x, --one-file-system       don't cross filesystem boundaries

I had to use the "x" option to prevent rsync from deleting files in
snapshots in the backup location (as the source location does not
retain any snapshots). Is there a better way?

I have my live system on one block device and a backup snapshot of it
on another block device. I am keeping them in sync with hourly rsync
transfers.

Here's how this system works in a little more detail:

1. I establish the baseline by sending a full snapshot to the backup
block device using btrfs send-receive.
2. Next, on the backup device I immediately create a rw copy of that
baseline snapshot.
3. I delete the source snapshot to keep the live filesystem free of
all snapshots (so it can be optimally defragmented, etc.)
4. hourly, I take a snapshot of the live system, rsync all changes to
the backup block device, and then delete the source snapshot. This
hourly process takes less than a minute currently. (My test system has
only moderate usage.)
5. hourly, following the above step, I use snapper to take a snapshot
of the backup subvolume to create/preserve a history of changes. For
example, I can find the version of a file 30 hours prior.

The backup volume contains up to 100 snapshots while the live volume
has no snapshots. Best of both worlds? I guess I'll find out over
time.
